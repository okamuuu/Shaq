#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Shaq::UI::Navigation::Tab;

subtest 'basic test' => sub {
    
    my $tab = Shaq::UI::Navigation::Tab->new;
    isa_ok $tab, 'Shaq::UI::Navigation::Tab';

    $tab->categories([
        { dir => 'home',      name => 'HOME' },
        { dir => 'news',      name => 'NEWS' },
        { dir => 'recommend', name => 'RECOMMEND' }
    ]);
    
    $tab->base_url("http://www.example.com");

    eq_or_diff $tab->xhtml, <<"_EOF_"; 
<!-- category[start] -->
<ul id="nav">
<li><a href="http://www.example.com/" class="home">HOME</a></li>
<li><a href="http://www.example.com/news/" class="news">NEWS</a></li>
<li><a href="http://www.example.com/recommend/" class="recommend">RECOMMEND</a></li>
</ul>
<!-- category[end] -->
_EOF_

    done_testing;
};
    

subtest 'spcify current' => sub {

     my $tab = Shaq::UI::Navigation::Tab->new;

    $tab->categories([
        { dir => 'home',      name => 'HOME' },
        { dir => 'news',      name => 'NEWS' },
        { dir => 'recommend', name => 'RECOMMEND' }
    ]);

    $tab->base_url("http://www.example.com" );
    $tab->current( "home" );

    eq_or_diff $tab->xhtml, <<"_EOF_"; 
<!-- category[start] -->
<ul id="nav">
<li><a href="http://www.example.com/" class="home current">HOME</a></li>
<li><a href="http://www.example.com/news/" class="news">NEWS</a></li>
<li><a href="http://www.example.com/recommend/" class="recommend">RECOMMEND</a></li>
</ul>
<!-- category[end] -->
_EOF_

    done_testing;
};

done_testing;
