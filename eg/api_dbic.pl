#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib ("$FindBin::Bin/../lib");
use lib ("$FindBin::Bin/../extlib");
use Shaq::Api::DBIC;

my $config = {
    dbic => {
        digest => 12345678,
        master => {
            schema_class   => "Sample::Schema",
            connect_info   => ['dbi:SQLite:dbname=db/dbic_master.db'],
            query_log_path => './logs/dbic_master_query.log',
            log_mode       => 1,
        },
        slave => {
            schema_class   => "Sample::Schema",
            connect_info   => ['dbi:SQLite:dbname=db/dbic_master.db'],
            query_log_path => './logs/dbic_slave_query.log',
            log_mode       => 1,
        }
    }
};

my $dbic   = Shaq::Api::DBIC->new($config->{dbic});
my $schema = $dbic->get_slave_schema;

my $rs = $schema->resultset('Books')->search;

my @books = $rs->all;
print $_->title for @books;


