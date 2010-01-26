#!/usr/bin/perl
use strict;
use warnings;
use Test::Declare;

plan tests => blocks;

use_ok( 'Shaq::Api::WebService::Lite' );

my $config = {
    base_param => { api_key => $ENV{LAST_FM_API_KEY} },
    host       => 'http://ws.audioscrobbler.com',
    base_path  => '2.0',
    #        response_parser => "XML::Simple",
};

describe 'base test' => run {

    my $core = Shaq::Api::WebService::Lite->new($config);

    test 'core objecte created ok' => run {
        ok( $core, "objecte created ok" );
        isa_ok( $core, 
                'Shaq::Api::WebService::Lite',
                'objecte isa Shaq::Api::WebService::Lite' );
            
        can_ok( $core, 'get' ); 
    };

    test 'get returned hash-ref' => run {
        my $hash_ref = $core->get( { param => { method => "artist.getsimilar", artist => "Ne-Yo" } });
        ok( $hash_ref, "hash-ref returned"  );
        isa_ok( $hash_ref, 'HASH', 'hash-ref returned'); 
        is( $hash_ref->{status}, 'ok' );
    };

    cleanup { $core = undef };

};


