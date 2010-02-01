#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Shaq::UI::Menu;

my $menu = Shaq::UI::Menu->new(
    path    => '/path/to/',
    ext     => '.html',
    title   => 'READ ME',
    list    => [
        { id => 'index', name => 'home' },
        { id => 'about', name => 'about this site' },
        { id => 'news',  name => 'new informations' },
    ],
);

subtest "render xhtml" => sub {

    eq_or_diff $menu->xhtml, <<"_EOF_";
<!-- menu[start] -->
<div class="menu">
    <h3>READ ME</h3>
    <ul>
        <li><a href="/path/to/index.html">home</a></li>
        <li><a href="/path/to/about.html">about this site</a></li>
        <li><a href="/path/to/news.html">new informations</a></li>
    </ul>
</div>
<!-- menu[end] -->
_EOF_

    done_testing();

};

done_testing();

