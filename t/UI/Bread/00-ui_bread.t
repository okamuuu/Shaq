#!/usr/bin/perl
use strict;
use warnings;
use Test::Declare;
use Test::Differences;
use Shaq::UI::Bread;

plan tests => blocks;

#use Data::Dumper;

describe 'test' => run {
    
    my $bread;
    init { $bread = Shaq::UI::Bread->new; };

    test 'isa ok' => run {
        isa_ok $bread, 'Shaq::UI::Bread';
    };

    test 'xhtml' => run {

#        eq_or_diff $bread->xhtml, <<"_EOF_"; 
        is $bread->xhtml, <<"_EOF_"; 
<!-- bread[start] -->
<p id="bread">
home
</p>
<!-- bread[end] -->
_EOF_
    
    };


    test 'xhtml' => run {
    
        $bread->add( { dir => 'news', name => 'latest news' });

#        eq_or_diff $bread->xhtml, <<"_EOF_"; 
        is $bread->xhtml, <<"_EOF_"; 
<!-- bread[start] -->
<p id="bread">
<a href="/">home</a> &gt; 
latest news
</p>
<!-- bread[end] -->
_EOF_
    
    };

    test 'xhtml' => run {
        
        $bread->init;
        $bread->add( { dir => 'contact', name => 'CONTACT' } );
        $bread->add( { dir => 'confirm', name => 'CONFIRM' } );

#        eq_or_diff $bread->xhtml, <<"_EOF_"; 
        is $bread->xhtml, <<"_EOF_"; 
<!-- bread[start] -->
<p id="bread">
<a href="/">home</a> &gt; 
<a href="/contact">CONTACT</a> &gt; 
CONFIRM
</p>
<!-- bread[end] -->
_EOF_
    
    };

    cleanup { $bread = undef };
};

