#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::CMS::Utils;
use Shaq::CMS::Category;
use Shaq::CMS::Site;

### prepare
my ( $index, $about, $news )  = t::CMS::Utils::get_archives();
my ( $menu1, $menu2, $menu3 ) = t::CMS::Utils::get_menus();

my $category1 = Shaq::CMS::Category->new(
    name     => 'HOME',
    dirname  => 'home',
    menus    => [ $menu1, $menu2, $menu3 ],
    archives => [ $index, $about, $news ],
);

my $category2 = Shaq::CMS::Category->new(
    name     => 'CentOS5.3',
    dirname  => 'centos53',
    menus    => [ $menu1, $menu2, $menu3 ],
    archives => [ $index, $about, $news ],
);

my $site;

subtest "create site object" => sub {

    $site = Shaq::CMS::Site->new(
        name       => 'My Site',
        categories => [ $category1, $category2 ]
    );

    isa_ok( $site, 'Shaq::CMS::Site');
    done_testing();
};

subtest "site has some categories" => sub {
    is_deeply( [$site->categories], [ $category1, $category2 ] );
    done_testing();
};

done_testing();

