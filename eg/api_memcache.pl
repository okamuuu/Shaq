#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir/;
use lib dir( $Bin, '..', 'lib' )->stringify;
use Shaq::Api::Memcached;
use Perl6::Say;
use Data::Dumper;

my $config = { namespace => 'eg_' };

my $memd = Shaq::Api::Memcached->new($config);

my $key   = 'key_v001';
my $value = { test => 'this is test.' };

#$memd->set( $key, $value );
#warn Dumper my $data = $memd->get( $key );

warn $memd->__cache_key('test');


1;
