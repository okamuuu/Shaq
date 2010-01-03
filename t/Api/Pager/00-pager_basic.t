#!/usr/bin/perl
use strict;
use warnings;
use Test::Declare;
use Test::Differences;
use Shaq::Api::Pager;

plan tests => blocks;

#use Data::Dumper;

describe 'contruction test' => run {

    my $pager;
    init { $pager = Shaq::Api::Pager->new };

    test 'isa ok' => run {
        isa_ok $pager, 'Shaq::Api::Pager';
    };

    test 'extend' => run {

        $pager->total_entries(180);
        $pager->entries_per_page(10);
       
        # [1] 2 3 4 5 6  
        $pager->current_page(1);  
        is $pager->extend->{first_visible_page}, 1;
        is $pager->extend->{last_visible_page}, 6;

        # 1 [2] 3 4 5 6  
        $pager->current_page(2);  
        is $pager->extend->{first_visible_page}, 1;
        is $pager->extend->{last_visible_page}, 7;

        # 1 2 3 4 5 [6] 7 8 9 10 11  
        $pager->current_page(6);  
        is $pager->extend->{first_visible_page}, 1;
        is $pager->extend->{last_visible_page}, 11;

        # 2 3 4 5 6 [7] 8 9 10 11 12
        $pager->current_page(7);  
        is $pager->extend->{first_visible_page}, 2;
        is $pager->extend->{last_visible_page}, 12;

        # 1 [2] 3 4
        $pager->total_entries(35);
        $pager->current_page(2);  
        is $pager->extend->{first_visible_page}, 1;
        is $pager->extend->{last_visible_page},  4;

    };

    test 'xhtml' => run {
        $pager->total_entries(200);
        $pager->entries_per_page(10);
        $pager->current_page(1);  
        $pager->base_url("http://example.com");

        eq_or_diff $pager->extend->xhtml, <<"_EOF_"; 
<!-- pager[start] -->
<div class="pager">
<ul>
<li><span class="current">1</span></li>
<li><a href="http://example.com?page=2">2</a></li>
<li><a href="http://example.com?page=3">3</a></li>
<li><a href="http://example.com?page=4">4</a></li>
<li><a href="http://example.com?page=5">5</a></li>
<li><a href="http://example.com?page=6">6</a></li>
<li class="next"><a href="http://example.com?page=2">NEXT</a></li>
</ul>
</div>
<!-- pager[end] -->
_EOF_

        $pager->current_page(2);  
        $pager->base_url("http://example.com");

        eq_or_diff $pager->extend->xhtml, <<"_EOF_"; 
<!-- pager[start] -->
<div class="pager">
<ul>
<li class="prev"><a href="http://example.com?page=1">PREV</a></li>
<li><a href="http://example.com?page=1">1</a></li>
<li><span class="current">2</span></li>
<li><a href="http://example.com?page=3">3</a></li>
<li><a href="http://example.com?page=4">4</a></li>
<li><a href="http://example.com?page=5">5</a></li>
<li><a href="http://example.com?page=6">6</a></li>
<li><a href="http://example.com?page=7">7</a></li>
<li class="next"><a href="http://example.com?page=3">NEXT</a></li>
</ul>
</div>
<!-- pager[end] -->
_EOF_
    };

    test 'single page' => run {
        $pager->total_entries(10);
        $pager->entries_per_page(10);
        $pager->current_page(1);  
        $pager->base_url("http://example.com");

        eq_or_diff $pager->extend->xhtml, <<"_EOF_"; 
<!-- pager[start] -->
<!-- pager[end] -->
_EOF_
    };

    cleanup { $pager = undef };
};

