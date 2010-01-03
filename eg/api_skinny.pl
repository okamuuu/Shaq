#!/usr/bin/perl
use strict;
use warnings;
use Perl6::Say;
use Data::Dumper;
use Data::Dump qw(dump);
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use lib dir($Bin, '..', 'lib')->stringify;
use lib dir($Bin, '..', 'extlib')->stringify;
use Shaq::Api::Skinny;

my $config = {
    skinny => {
        master => {
            db_class       => 'Proj::DB',
            connect_info   => ['dbi:SQLite:dbname=db/skinny.db'],
            query_log_path => './logs/skinny_master_query.log',
            log_mode       => 1,
        },
        slave => {
            db_class       => 'Proj::DB',
            connect_info   => ['dbi:SQLite:dbname=db/skinny.db'],
            query_log_path => './logs/skinny_slave_query.log',
#            log_mode       => 1,
        },
    }
};

my $skinny = Shaq::Api::Skinny->new( $config->{skinny} );

my $db = $skinny->master_db;
#my $db = $skinny->slave_db;

# 実験用テーブルを作成
$db->do(q{drop table if exists users});
$db->do(q{
    create table users (
        id       INTEGER PRIMARY KEY AUTOINCREMENT,
        rid      VARCHAR(10) NOT NULL,
        name     TEXT    NOT NULL,
        birth_on DATE,
        created_at DATETIME
    )
});

# INSERT INTO user (name), VALUES ('nekokak');
# を実行
my $row = $db->create('users',{name => 'nekokak'});
print $row->id, "\n";   # print 1
print $row->rid, "\n";   # print 1
print $row->name, "\n"; # print 'nekokak'
print $row->created_at, "\n";
print $row->created_at->ymd, "\n";

#$db->create('users',{name => 'takada'});

my ( $rows, $pager ) = $db->listing('users');

for my $row ( @$rows ) {
    say $row;
}





__END__

# UPDATE user set name = 'yappo' WHERE id = 1;
# を実行
# $row->update({name => 'yappo'});でも同じ
$db->update('user',{name => 'yappo'}, {id => $row->id});

# SELECT * FROM user WHERE name = 'nekokak'
# を実行
$row = $db->search('user', {name => 'yappo'})->first;
print $row->id, "\n";   # print 1
print $row->name, "\n"; # print 'yappo'
print $row->created_at, "\n";

# SELECT * FROM user WHERE id = 1 limit 1;
# を実行
$row = $db->single('user', {id => 1});
print $row->id, "\n";   # print 1
print $row->name, "\n"; # print 'yappo'

# count
my $count = $db->count('user' , 'id', {name => 'nekokak'});
print $count , "\n";

# DELETE FROM user WHERE id = 1;
# を実行
$db->delete('user',{id =>1});

warn Dumper ( Proj::DB->query_log);
