#!/usr/bin/perl
use strict;
use warnings;
use Test::Declare;
use Test::Differences;
use Shaq::UI::Navigation::Bread;

plan tests => blocks;

#use Data::Dumper;

describe 'test' => run {
    
    my $bread;
    init { $bread = Shaq::UI::Navigation::Bread->new; };

    test 'isa ok' => run {
        isa_ok $bread, 'Shaq::UI::Navigation::Bread';
    };

    test 'xhtml' => run {

        eq_or_diff $bread->xhtml, <<"_EOF_"; 
<!-- bread[start] -->
<p id="bread">
HOME
</p>
<!-- bread[end] -->
_EOF_
    
    };


    test 'xhtml' => run {
    
        $bread->add_bread( { dir => 'news', name => 'latest news' });

        eq_or_diff $bread->xhtml, <<"_EOF_"; 
<!-- bread[start] -->
<p id="bread">
<a href="/">HOME</a> &gt; 
latest news
</p>
<!-- bread[end] -->
_EOF_
    
    };

    test 'xhtml' => run {
        
        $bread->init;
        $bread->add_bread( { dir => 'contact', name => 'CONTACT' } );
        $bread->add_bread( { dir => 'confirm', name => 'CONFIRM' } );

        eq_or_diff $bread->xhtml, <<"_EOF_"; 
<!-- bread[start] -->
<p id="bread">
<a href="/">HOME</a> &gt; 
<a href="/contact">CONTACT</a> &gt; 
CONFIRM
</p>
<!-- bread[end] -->
_EOF_
    
    };

    cleanup { $bread = undef };
};

