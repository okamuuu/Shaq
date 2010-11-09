#!/usr/bin/perl
use strict;
use warnings;
use t::TestUtils;
use Test::Most;

use_ok("Shaq::Unit::DBI");

my $mysqld = t::TestUtils->get_test_mysqld;

subtest 'provide dbh' => sub {
   
    note 'syntax error using mecab';

    isa_ok( Shaq::Unit::DBI->get_master_dbh, 'DBI::db' );
    isa_ok( Shaq::Unit::DBI->get_slave_dbh, 'DBI::db' );

};

subtest 'provide dsn' => sub {
    
    like( Shaq::Unit::DBI->get_master_dsn, qr/^dbi:mysql:dbname=test;/ );
    like( Shaq::Unit::DBI->get_slave_dsn,    qr/^dbi:mysql:dbname=test;/ );

};

subtest 'This class provid query log if it is specified.' => sub {
    pass();
};

=pod
subtest 'using like this.' => sub {

    {
        package MyPrj::Unit::DBI;
        use base qw/Shaq::Unit::DBI/;
        
        local $MASTER = ;
        local $SLAVE  = ;
        local $LOG_FILE = undef;
    
        1;
    }

    isa_ok MyPrj::Unit::DBI->get_master_dbh, "DBI::db";
    isa_ok MyPrj::Unit::DBI->get_slave_dbh, "DBI::db";

};
=cut

done_testing();


