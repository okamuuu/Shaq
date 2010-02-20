#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Data::Dumper;
use t::CMS::Utils;

subtest 'simple isa test' => sub {

    isa_ok( $_, 'Shaq::CMS::Archive') for t::CMS::Utils::get_archives;
    isa_ok( $_, 'Shaq::CMS::Menu') for t::CMS::Utils::get_menus;

    done_testing();
};

done_testing();

