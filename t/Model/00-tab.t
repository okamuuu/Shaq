#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Shaq::Model::Tab;

subtest 'basic test' => sub {
    
    my $tab = Shaq::Model::Tab->new;
    isa_ok $tab, 'Shaq::Model::Tab';

    $tab->add_category(
        { dir => 'news',      name => 'NEWS' },
        { dir => 'recommend', name => 'RECOMMEND' }
    );
    
    eq_or_diff $tab->xhtml, <<"_EOF_"; 
<!-- category[start] -->
<ul id="tab">
<li><a href="/" class="home">HOME</a></li>
<li><a href="/news/" class="news">NEWS</a></li>
<li><a href="/recommend/" class="recommend">RECOMMEND</a></li>
</ul>
<!-- category[end] -->
_EOF_

    done_testing;
};
    
subtest 'spcify current' => sub {

     my $tab = Shaq::Model::Tab->new;

    $tab->add_category(
        { dir => 'news',      name => 'NEWS' },
        { dir => 'recommend', name => 'RECOMMEND' }
    );

    $tab->base_path("http://www.example.com/" );
    $tab->current( "home" );

    eq_or_diff $tab->xhtml, <<"_EOF_"; 
<!-- category[start] -->
<ul id="tab">
<li><a href="http://www.example.com/" class="home current">HOME</a></li>
<li><a href="http://www.example.com/news/" class="news">NEWS</a></li>
<li><a href="http://www.example.com/recommend/" class="recommend">RECOMMEND</a></li>
</ul>
<!-- category[end] -->
_EOF_

    done_testing;
};

done_testing;
