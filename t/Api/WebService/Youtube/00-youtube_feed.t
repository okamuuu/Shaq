#!/usr/bin/perl
use strict;
use warnings;
use Test::Declare;
use Shaq::Api::WebService::Youtube::Feed;

plan tests => blocks;

describe 'test' => run {

    my $yt;
    init { $yt = Shaq::Api::WebService::Youtube::Feed->new };

    test 'isa ok' => run {
        isa_ok $yt, 'Shaq::Api::WebService::Youtube::Feed';
    };

    test 'can ok' => run {
        can_ok( $yt, 'subscriptions' );
        can_ok( $yt, 'videos' );
    };

    test 'subscriptions' => run {
        is $yt->subscriptions('okamuuuuu')->[0], 'geniusLOL';
        
    };

    test 'videos' => run {
        my $cond = { author => 'geniusLOL' };
        my $attr = { orderby => "published" };
        my ( $videos, $pager ) = $yt->videos( $cond, $attr );
        
        isa_ok $videos->[0], "XML::Feed::Entry";
=pod
        ok $videos->[0]->{id};
        ok $videos->[0]->{title};
        ok $videos->[0]->{content};
        ok $videos->[0]->{thum_url};
        ok $videos->[0]->{thum_width};
        ok $videos->[0]->{thum_height};
        ok $videos->[0]->{published};
=cut
        isa_ok $pager, "Data::Page";
    };


    cleanup { $yt = undef };
};


