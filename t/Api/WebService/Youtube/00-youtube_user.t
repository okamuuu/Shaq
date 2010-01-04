#!/usr/bin/perl
use strict;
use warnings;
use Test::Declare;
use Test::Differences;
use Shaq::Api::WebService::Youtube::User;

plan tests => blocks;

describe 'test' => run {

    my $yt;
    init { $yt = Shaq::Api::WebService::Youtube::User->new };

    test 'isa ok' => run {
        isa_ok $yt, 'Shaq::Api::WebService::Youtube::User';
    };

    test 'can ok' => run {
        can_ok( $yt, 'get' );
    };

    test 'get' => run {
        is $yt->get('chihiroyuki')->{"yt:username"}, 'chihiroyuki'  ;
        
    };

    cleanup { $yt = undef };
};


