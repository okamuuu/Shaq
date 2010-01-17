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
use Shaq::Api::Skinny::ShardManager;

my $config = {
    master_db => {
        class          => 'Proj::DB',
        connect_info   => ['dbi:SQLite:dbname=db/master.db'],
        query_log_path => './logs/skinny_master_db_query.log',
        log_mode       => 1,
    },
    slave_db => {
        class          => 'Proj::DB',
        connect_info   => ['dbi:SQLite:dbname=db/master.db'],
        query_log_path => './logs/skinny_master_db_query.log',
        log_mode       => 1,
    },
    manager_db => {
        class          => 'Proj::ShardManagerDB',
        connect_info   => ['dbi:SQLite:dbname=db/shard_manager.db'],
        query_log_path => './logs/skinny_shard_manager_db_query.log',
        log_mode       => 1,
    },
    shard_base_db => {
        class          => 'Proj::ShardUserDB',
        connect_info   => ['dbi:SQLite:dbname=db/shard_user.db'],
        query_log_path => './logs/skinny_shard_db_query.log',
        log_mode       => 1,
    },
};

my $skinny = Shaq::Api::Skinny::ShardManager->new($config);
my $manager_db = $skinny->manager_db;



__END__

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


