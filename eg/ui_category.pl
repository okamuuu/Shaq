#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Time::HiRes qw/time/;
use lib dir($Bin, '..', 'lib')->stringify;
use Shaq::UI::Category;

my $category = Shaq::UI::Category->new;

my $start;
my $end;

$start = time;
$category->categories([qw/home news recommend/]);
warn $end = time - $start;

$start = time;
$category->base_url("http://www.example.com" );
warn $end = time - $start;

$start = time;
$category->xhtml;
warn $end = time - $start;


