#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::CMS::Utils;
use Shaq::CMS::Site;

my ( $index, $about, $info ); # archives
my ( $menu1, $menu2, $menu3 );
my $site;

subtest "prepare" => sub {

    $index = t::CMS::Utils::get_archive( '001-index' );
    $about = t::CMS::Utils::get_archive( '002-about' );
    $info  = t::CMS::Utils::get_archive( '003-info'  );

    isa_ok $index, 'Shaq::CMS::Archive';
    isa_ok $about, 'Shaq::CMS::Archive';
    isa_ok $info,  'Shaq::CMS::Archive';

    $menu1 = t::CMS::Utils::get_menu( '01-readme' );
    $menu2 = t::CMS::Utils::get_menu( '02-setup' );
    $menu3 = t::CMS::Utils::get_menu( '03-security' );

    isa_ok $menu1, 'Shaq::CMS::Menu';
    isa_ok $menu2, 'Shaq::CMS::Menu';
    isa_ok $menu3, 'Shaq::CMS::Menu';

    done_testing();
};

subtest "create site objecte" => sub {
   
    $site = Shaq::CMS::Site->new(
        name => 'Site Name',
    );
 
    ok($site, "object created ok");
    isa_ok( $site, "Shaq::CMS::Site", "object isa Shaq::CMS::Site" );
    can_ok( $site, "menus" );  
    can_ok( $site, "add_menus" );  
    can_ok( $site, "archives" );  
    can_ok( $site, "add_archives" );  

    done_testing();

};

subtest "At first, site object has no archive, menu also." => sub {
   
    is_deeply( $site->archives, [] );
    is_deeply( $site->menus,    [] );
    
    done_testing();
};

subtest "add archives" => sub {
    
    $site->add_archives( $index );
    is_deeply( $site->archives, [$index] );
     
    $site->add_archives( $about, $info );
    is_deeply( $site->archives, [$index, $about, $info] );

    done_testing();
};

subtest "add menus" => sub {
    
    $site->add_menus( $menu1 );
    is_deeply( $site->menus, [$menu1] );
     
    $site->add_menus( $menu2, $menu3 );
    is_deeply( $site->menus, [$menu1, $menu2, $menu3] );

    done_testing();
};

done_testing();

