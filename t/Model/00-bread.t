#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Shaq::Model::Bread;
use JSON;

subtest "no arguments xhtml" => sub {
    my $bread = Shaq::Model::Bread->new;
    eq_or_diff $bread->xhtml, <<"_EOF_";
<!-- bread[start] -->
<p id="bread">
home
</p>
<!-- bread[end] -->
_EOF_
        
    done_testing();
};

subtest 'add bread xhtml' => sub {
    my $bread = Shaq::Model::Bread->new;

    $bread->add( { dir => 'news', name => 'latest news' });
    eq_or_diff $bread->xhtml, <<"_EOF_";
<!-- bread[start] -->
<p id="bread">
<a href="/">home</a> &gt;
latest news
</p>
<!-- bread[end] -->
_EOF_
    
    done_testing();

};

done_testing();

