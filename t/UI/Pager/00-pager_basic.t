#!/usr/bin/perl
use strict;
use warnings;
use Test::Declare;
use Test::Differences;
use Shaq::UI::Pager;
use Data::Page;

plan tests => blocks;
 
describe 'contruction test' => run {
 
    my $pager = Data::Page->new;
    my $ui    = Shaq::UI::Pager->new;
    my $path  = '/example';
 
    test 'isa ok' => run {
        isa_ok $ui, 'Shaq::UI::Pager';
        isa_ok $pager, "Data::Page";
    };
 
    test '[1] 2 3 4 5 6' => run {
 
        $pager->total_entries(180);
        $pager->entries_per_page(10);
       
        $pager->current_page(1);
        my $extended = $ui->extend($pager, $path )->extended;
        is $extended->{first_visible_page}, 1;
        is $extended->{last_visible_page}, 6;
    };
    
    test '1 [2] 3 4 5 6' => run {
        $pager->current_page(2);
        my $extended = $ui->extend($pager, $path )->extended;
        is $extended->{first_visible_page}, 1;
        is $extended->{last_visible_page}, 7;
    };
    
    test '1 2 3 4 5 [6] 7 8 9 10 11' => run {
        $pager->current_page(6);
        my $extended = $ui->extend($pager, $path )->extended;
        is $extended->{first_visible_page}, 1;
        is $extended->{last_visible_page}, 11;
    };
    
    test '2 3 4 5 6 [7] 8 9 10 11 12' => run {
        $pager->current_page(7);
        my $extended = $ui->extend($pager, $path )->extended;
        is $extended->{first_visible_page}, 2;
        is $extended->{last_visible_page}, 12;
    };

    test '1 [2] 3 4' => run {
        $pager->total_entries(35);
        $pager->current_page(2);
        my $extended = $ui->extend($pager, $path )->extended;
        is $extended->{first_visible_page}, 1;
        is $extended->{last_visible_page}, 4;
 
    };
 
    test 'xhtml' => run {
        $pager->total_entries(200);
        $pager->entries_per_page(10);
        $pager->current_page(1);
 
        my $xhtml = $ui->extend($pager, $path )->xhtml;
        is $xhtml, <<"_EOF_";
<!-- pager[start] -->
<div class="pager">
<ul>
<li><span class="current">1</span></li>
<li><a href="/example?page=2">2</a></li>
<li><a href="/example?page=3">3</a></li>
<li><a href="/example?page=4">4</a></li>
<li><a href="/example?page=5">5</a></li>
<li><a href="/example?page=6">6</a></li>
<li class="next"><a href="/example?page=2">NEXT</a></li>
</ul>
</div>
<!-- pager[end] -->
_EOF_

        $pager->current_page(2);
        my $xhtml2 = $ui->extend($pager, $path )->xhtml;
        is $xhtml2, <<"_EOF_";
<!-- pager[start] -->
<div class="pager">
<ul>
<li class="prev"><a href="/example?page=1">PREV</a></li>
<li><a href="/example?page=1">1</a></li>
<li><span class="current">2</span></li>
<li><a href="/example?page=3">3</a></li>
<li><a href="/example?page=4">4</a></li>
<li><a href="/example?page=5">5</a></li>
<li><a href="/example?page=6">6</a></li>
<li><a href="/example?page=7">7</a></li>
<li class="next"><a href="/example?page=3">NEXT</a></li>
</ul>
</div>
<!-- pager[end] -->
_EOF_
    };
 
    test 'single page' => run {
        $pager->total_entries(10);
        $pager->entries_per_page(10);
        $pager->current_page(1);
        
        my $xhtml = $ui->extend($pager, $path )->xhtml;
 
        is $xhtml, <<"_EOF_";
<!-- pager[start] -->
<!-- pager[end] -->
_EOF_

        $pager->total_entries(5);
        $pager->entries_per_page(10);
        $pager->current_page(1);
  
        my $xhtml2 = $ui->extend($pager, $path )->xhtml;
 
        is $xhtml2, <<"_EOF_";
<!-- pager[start] -->
<!-- pager[end] -->
_EOF_

    };
 
    cleanup { $pager = undef };
};
 
