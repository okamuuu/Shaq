#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::Differences;
use Shaq::CMS::Menu;

my $menu;

subtest "prepare archive objects for store into category objecte" => sub {

    $menu = Shaq::CMS::Menu->new( order=> '01', name => 'README' );

    ok($menu, "object created ok");
    isa_ok($menu, 'Shaq::CMS::Menu');
    can_ok($menu, 'order');
    can_ok($menu, 'titles');
    can_ok($menu, 'basenames');
    
    is $menu->order, '01';
    is $menu->name, 'README';
   
    done_testing();
};

subtest "add list" => sub {

    $menu->add_list( {basename=>'index', title => 'index title' } );
    
    is_deeply $menu->get_list,
    [
        { basename => 'index', title => 'index title' },
    ];

    done_testing();
};

subtest "add archive again" => sub {

    $menu->add_list( {basename=>'about', title => 'about title' } );
     
    is_deeply $menu->get_list,
    [
        { basename => 'index', title => 'index title' },
        { basename => 'about', title => 'about title' },
    ];

    done_testing();
};

subtest "render xhtml" => sub {

    eq_or_diff $menu->xhtml, <<"_EOF_";
<!-- menu[start] -->
<h3>README</h3>
<ul class="menu">
    <li><a href="index.html">index title</a></li>
    <li><a href="01-about.html">about title</a></li>
</ul>
<!-- menu[end] -->
_EOF_
    
    done_testing();
};

done_testing();

