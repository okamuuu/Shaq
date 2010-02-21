#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::CMS::Utils;
use Shaq::CMS::Category;

### prepare
my ( $index, $about, $news )  = t::CMS::Utils::get_archives();
my ( $menu1, $menu2, $menu3 ) = t::CMS::Utils::get_menus();
my $category;

subtest "create category object" => sub {

    $category = Shaq::CMS::Category->new(
        name     => 'HOME',
        dirname  => 'home',
        menus    => [ $menu1, $menu2, $menu3 ],
        archives => [ $index, $about, $news ],
    );

    isa_ok( $category, "Shaq::CMS::Category", "object isa Shaq::CMS::Category" );
    can_ok( $category, "menus" );  
    can_ok( $category, "archives" );  

    done_testing();
};

subtest "category has some archives" => sub {
    is_deeply( $category->menus, [ $menu1, $menu2, $menu3 ] );
    done_testing();
};

subtest "category has some archives" => sub {
    is_deeply( [$category->archives], [$index, $about, $news] );
    done_testing();
};

done_testing();

