#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Shaq::Unit::WebService::Lite::Parser::XML::LibXML::Simple;

use_ok( 'Shaq::Unit::WebService::Lite' );

my $config = {
    uri        => URI->new('http://ws.audioscrobbler.com/2.0'),
    base_param => { api_key => $ENV{LAST_FM_API_KEY} },
};

subtest 'use XML::LibXML::Simple' => sub {

    $config->{parser} = "XML::LibXML::Simple";
    my $lite = Shaq::Unit::WebService::Lite->new($config);

    common_test($lite);
    done_testing();
};

subtest 'use JSON' => sub {

    $config->{parser} = "JSON";
    $config->{base_param} = { api_key => $ENV{LAST_FM_API_KEY}, format=>'json' };
    my $lite = Shaq::Unit::WebService::Lite->new($config);

    common_test($lite);
    done_testing();
};

done_testing();

sub common_test {
    my $obj = shift;
    ok( $obj, "objecte created ok" );
    isa_ok( $obj, 
            'Shaq::Unit::WebService::Lite',
            'objecte isa Shaq::Api::WebService::Lite' );
        
    can_ok( $obj, 'get' ); 

    my $hashref = $obj->get( { param => { method => "artist.getsimilar", artist => "Ne-Yo" } });
   
    ok( $hashref, "hash-ref returned"  );
    isa_ok( $hashref, 'HASH', 'hash-ref returned'); 
    ok( $hashref->{similarartists}, 'ok' );
}

