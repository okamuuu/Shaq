#!/usr/bin/perl
use strict;
use warnings;
use Test::Declare;

plan tests => blocks;

use Shaq::Api::Memcached;

my $config = {
    namespace => 'test',
};

describe 'basic test' => run {

    my $cache = Shaq::Api::Memcached->new( $config );

    test 'isa ok' => run {
        isa_ok $cache, 'Shaq::Api::Memcached';
    };

    test 'can ok' => run {
        can_ok( $cache, 'memd' );
        can_ok( $cache, 'exptime' );
    };

    test 'set and get' => run {
        my $key   = 'key_v001';
        my $value = { test => 'this is test.' };  
        $cache->set( $key, $value );
        my $data = $cache->get( $key );

        is_deeply( $value, $data );
    }; 

}


