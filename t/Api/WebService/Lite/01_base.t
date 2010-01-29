#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use_ok( 'Shaq::Api::WebService::Lite' );

my $config = {
    base_param => { api_key => $ENV{LAST_FM_API_KEY} },
    host       => 'http://ws.audioscrobbler.com',
    base_path  => '2.0',
    #        response_parser => "XML::Simple",
};

subtest 'base test' => sub {

    my $core = Shaq::Api::WebService::Lite->new($config);

    ok( $core, "objecte created ok" );
    isa_ok( $core, 
            'Shaq::Api::WebService::Lite',
            'objecte isa Shaq::Api::WebService::Lite' );
        
    can_ok( $core, 'get' ); 

    my $hash_ref = $core->get( { param => { method => "artist.getsimilar", artist => "Ne-Yo" } });
    ok( $hash_ref, "hash-ref returned"  );
    isa_ok( $hash_ref, 'HASH', 'hash-ref returned'); 
    is( $hash_ref->{status}, 'ok' );

    done_testing();
};

done_testing();
