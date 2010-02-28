#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Shaq::Model::Pager;

subtest 'contruction test' => sub {
 
    my $pager = Shaq::Model::Pager->new;
    isa_ok($pager, 'Shaq::Model::Pager');

    done_testing;
};

subtest 'add base_path' => sub {
    
    my $pager = Shaq::Model::Pager->new;
    $pager->base_path('/example');
    
    is $pager->base_path, '/example';
    done_testing;
};

subtest '[1] 2 3 4 5 6' => sub {

    my $pager = Shaq::Model::Pager->new;
    $pager->total_entries(180);
    $pager->entries_per_page(10);
    $pager->current_page(1);

    $pager->extend;

    is $pager->first_visible_page, 1;
    is $pager->last_visible_page, 6;
    
    done_testing;
};

subtest '1 [2] 3 4 5 6' => sub {

    my $pager = Shaq::Model::Pager->new;
    $pager->total_entries(180);
    $pager->entries_per_page(10);
    $pager->current_page(2);

    $pager->extend;
    
    is $pager->first_visible_page, 1;
    is $pager->last_visible_page, 7;
    
    done_testing;
};

subtest '1 2 3 4 5 [6] 7 8 9 10 11' => sub {

    my $pager = Shaq::Model::Pager->new;
    $pager->total_entries(180);
    $pager->entries_per_page(10);
    $pager->current_page(6);

    $pager->extend;
    
    is $pager->first_visible_page, 1;
    is $pager->last_visible_page, 11;
      
    done_testing;
};

subtest '2 3 4 5 6 [7] 8 9 10 11 12' => sub {

    my $pager = Shaq::Model::Pager->new;
    $pager->total_entries(180);
    $pager->entries_per_page(10);
    $pager->current_page(7);
    
    $pager->extend;
    
    is $pager->first_visible_page, 2;
    is $pager->last_visible_page, 12;
 
    done_testing;
};

subtest '1 [2] 3 4' => sub {

    my $pager = Shaq::Model::Pager->new;
    $pager->total_entries(35);
    $pager->entries_per_page(10);
    $pager->current_page(2);
    
    $pager->extend;
    
    is $pager->first_visible_page, 1;
    is $pager->last_visible_page, 4;

    done_testing;
};

subtest 'xhtml' => sub {
    
    my $pager = Shaq::Model::Pager->new;
    $pager->base_path('/example');
    $pager->total_entries(200);
    $pager->entries_per_page(10);
    $pager->current_page(1);
 
    eq_or_diff $pager->xhtml, <<"_EOF_";
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

    done_testing;
};

subtest 'xhtml2' => sub {
    
    my $pager = Shaq::Model::Pager->new;
    $pager->base_path('/example');
    $pager->total_entries(200);
    $pager->entries_per_page(10);
    $pager->current_page(2);
    
    eq_or_diff $pager->xhtml, <<"_EOF_";
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
    
    done_testing;
};
 
subtest 'single page' => sub {

    my $pager = Shaq::Model::Pager->new;
    $pager->base_path('/example');
    $pager->total_entries(10);
    $pager->entries_per_page(10);
    $pager->current_page(1);
    
    eq_or_diff $pager->xhtml, <<"_EOF_";
<!-- pager[start] -->
<!-- pager[end] -->
_EOF_

    done_testing;
};

subtest 'single page' => sub {

    my $pager = Shaq::Model::Pager->new;
    $pager->base_path('/example');
    $pager->total_entries(5);
    $pager->entries_per_page(10);
    $pager->current_page(1);
 
    eq_or_diff $pager->xhtml, <<"_EOF_";
<!-- pager[start] -->
<!-- pager[end] -->
_EOF_

    eq_or_diff $pager->xhtml, <<"_EOF_";
<!-- pager[start] -->
<!-- pager[end] -->
_EOF_

    done_testing;
};

done_testing;
