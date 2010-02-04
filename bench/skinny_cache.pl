#!/usr/bin/env perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Data::Dumper;
use Devel::Size qw(size total_size);
use lib dir($Bin, '..', 'lib')->stringify;
use lib dir($Bin, '..', 'extlib')->stringify;
use Shaq::Api::Skinny;
use Shaq::Api::Memcached;

use Benchmark qw(:all);

my $config = {
    memcache => {
        namespace => 'eg_',
    },
    skinny => {
        master => {
            db_class       => 'Proj::DB',
            connect_info   => ['dbi:SQLite:dbname=db/skinny.db'],
            query_log_path => './logs/skinny_master_query.log',
#            log_mode       => 1,
        },
        slave => {
            db_class       => 'Proj::DB',
            connect_info   => ['dbi:SQLite:dbname=db/skinny.db'],
            query_log_path => './logs/skinny_slave_query.log',
#            log_mode       => 1,
        },
    }
};

my $memcache = Shaq::Api::Memcached->new( $config->{memcache} );
my $skinny   = Shaq::Api::Skinny->new( $config->{skinny} );

my $db = $skinny->master_db;

# 実験用テーブルを作成
$db->do(q{drop table if exists users});
$db->do(q{
    create table users (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        rid      VARCHAR(10) NOT NULL,
        name     TEXT    NOT NULL,
        birth_on DATE,
        created_at DATETIME,
        updated_at DATETIME
    )
});

# INSERT INTO user (name), VALUES ('nekokak');
# を実行して中身のデータを確認
my $row = $db->create('users',{name => 'nekokak'});
print $row->id, "\n";   # print 1
print $row->rid, "\n";   # print 1
print $row->name, "\n"; # print 'nekokak'
print $row->created_at, "\n";
print $row->created_at->ymd, "\n"; # datetime object
warn size $row;

### skinnyはこうやってオブジェクトからハッシュにできる
### この状態だとmemcacheに保存できる
warn Dumper my $hashref = $row->get_columns;

$memcache->set( 'key' => $hashref );
warn Dumper $memcache->get('key');

cmpthese timethese 10_000, {
	'hash to row' => sub {
		my $row = $db->data2itr( 'users',[$hashref])->first;
	},
	'row from db' => sub {
		my $row = $db->single('users',{id=>1});
	},
	'make hash form memcache to row object' => sub {
        my $hash = $memcache->get( 'key' );
		my $row = $db->data2itr('users',[$hash])->first;
	},
};

# SEE ALSO http://d.hatena.ne.jp/okamuuu/20100204/1265289418
