#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use lib dir($Bin, '..', 'lib')->stringify;

plan skip_all => 'could not find $ENV{TEST_UNIT_FTP_HOSTNAME}' unless $ENV{TEST_UNIT_FTP_HOSTNAME};
plan skip_all => 'could not find $ENV{TEST_UNIT_FTP_USERNAME}' unless $ENV{TEST_UNIT_FTP_USERNAME};
plan skip_all => 'could not find $ENV{TEST_UNIT_FTP_PASSWORD}' unless $ENV{TEST_UNIT_FTP_PASSWORD};

use_ok( 'Shaq::Unit::FTP' );

my $home_dir = dir( $Bin, '..', '..', '..' );

my $config = {
    unit => {
        ftp => {
            hostname => $ENV{TEST_UNIT_FTP_HOSTNAME},
            username => $ENV{TEST_UNIT_FTP_USERNAME},
            password => $ENV{TEST_UNIT_FTP_PASSWORD},
        }
    }
};

subtest "create unit FTP " => sub {

    my $mt = Shaq::Unit::FTP->new($config->{unit}->{ftp});

    isa_ok( $mt, "Shaq::Unit::FTP", "object isa Shaq::Unit::FTP" );
    done_testing;

};

done_testing;

