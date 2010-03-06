#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Test::Requires 'DBD::SQLite';
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use lib dir($Bin, '..', 'lib')->stringify;
use Shaq::Unit::Fixture::SQLite;

$Shaq::Unit::Fixture::SQLite::DB_FILE=file( $Bin,  '..', 'db', '_test.db' );
$Shaq::Unit::Fixture::SQLite::SQL_FILE=file( $Bin,  '..', 'db', 'schema.sql' );
$Shaq::Unit::Fixture::SQLite::FIXTURE_DIR=dir( $Bin,  '..', 'db', 'fixture' );
 
subtest "setup" => sub {

    Shaq::Unit::Fixture::SQLite->setup(json_columns=>[qw/category/]);

    isa_ok _dbh(), "DBI::db";
    
    my $fixture = _fixture();
    isa_ok $fixture->{books}, 'ARRAY'; 
    isa_ok $fixture->{authors}, 'ARRAY'; 
 
    my $book   = _dbh()->selectrow_hashref("SELECT * FROM books WHERE id = 1"); 
    my $author = _dbh()->selectrow_hashref("SELECT * FROM authors WHERE id = 1"); 
  
    is $book->{name}, 'neko_book1'; 
    is $author->{name}, 'nekokak'; 
    
    done_testing;

};

done_testing;

