#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use_ok( 'Shaq::Unit::WebService::Base' );

my $config = {
    base_param => { api_key => $ENV{LAST_FM_API_KEY} },
    host       => 'http://ws.audioscrobbler.com',
    base_path  => '2.0',
    #        response_parser => "XML::Simple",
};

subtest 'use XML::Simple' => sub {

    my $lite = Shaq::Api::WebService::Lite->new($config);
    
    common_test($lite);
    done_testing();
};

subtest 'use XML::LibXML::Simple' => sub {

    $config->{parser} = "XML::LibXML::Simple";
    my $lite = Shaq::Api::WebService::Lite->new($config);

    common_test($lite);
    done_testing();
};

subtest 'use JSON::XS' => sub {

    $config->{parser} = "JSON::XS";
    $config->{base_param} = { api_key => $ENV{LAST_FM_API_KEY}, format=>'json' };
    my $lite = Shaq::Api::WebService::Lite->new($config);

    common_test($lite);
    done_testing();
};

done_testing();

sub common_test {
    my $obj = shift;
    ok( $obj, "objecte created ok" );
    isa_ok( $obj, 
            'Shaq::Api::WebService::Lite',
            'objecte isa Shaq::Api::WebService::Lite' );
        
    can_ok( $obj, 'get' ); 

    my $hash_ref = $obj->get( { param => { method => "artist.getsimilar", artist => "Ne-Yo" } });
   
    ok( $hash_ref, "hash-ref returned"  );
    isa_ok( $hash_ref, 'HASH', 'hash-ref returned'); 
    ok( $hash_ref->{similarartists}, 'ok' );

}
