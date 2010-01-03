#!/usr/bin/perl
use strict;
use warnings;
use Test::Declare;
use Test::Differences;
use Shaq::Utils;

plan tests => blocks;

describe 'method test' => run {
   
    test 'camelize' => run {
        is Shaq::Utils::camelize('home'), 'Home'; 
        is Shaq::Utils::camelize('test_cat'), 'TestCat'; 
    }

};

