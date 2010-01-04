#!/usr/bin/perl
use strict;
use warnings;
use Test::Declare;
use Test::Differences;
use Shaq::UI::Category;

plan tests => blocks;

#use Data::Dumper;

describe 'contruction test' => run {
    
    my $category;
    init { $category = Shaq::UI::Category->new; };

    test 'isa ok' => run {
        isa_ok $category, 'Shaq::UI::Category';
    };

    $category->categories([qw/home news recommend/]);
    $category->base_url("http://www.example.com" );

    test 'xhtml' => run {

        is $category->xhtml, <<"_EOF_"; 
<!-- category[start] -->
<ul id="nav">
<li><a href="http://www.example.com/" class="home">HOME</a></li>
<li><a href="http://www.example.com/news/" class="news">NEWS</a></li>
<li><a href="http://www.example.com/recommend/" class="recommend">RECOMMEND</a></li>
</ul>
<!-- category[end] -->
_EOF_

    $category->categories([qw/home news_test recommend_test/]);
 
        is $category->xhtml, <<"_EOF_"; 
<!-- category[start] -->
<ul id="nav">
<li><a href="http://www.example.com/" class="home">HOME</a></li>
<li><a href="http://www.example.com/news_test/" class="news_test">NEWS TEST</a></li>
<li><a href="http://www.example.com/recommend_test/" class="recommend_test">RECOMMEND TEST</a></li>
</ul>
<!-- category[end] -->
_EOF_

    $category->current("home");
 
        is $category->xhtml, <<"_EOF_"; 
<!-- category[start] -->
<ul id="nav">
<li><a href="http://www.example.com/" class="home current">HOME</a></li>
<li><a href="http://www.example.com/news_test/" class="news_test">NEWS TEST</a></li>
<li><a href="http://www.example.com/recommend_test/" class="recommend_test">RECOMMEND TEST</a></li>
</ul>
<!-- category[end] -->
_EOF_

    };

    cleanup { $category = undef };
};

