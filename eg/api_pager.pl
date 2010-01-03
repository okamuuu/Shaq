#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Time::HiRes qw/time/;
use lib dir($Bin, '..', 'lib')->stringify;
use Shaq::Api::Pager;

my $pager = Shaq::Api::Pager->new;

my $start;
my $end;

# [1] 2 3 4 5 6
$start = time;
$pager->total_entries(180);
$pager->entries_per_page(10);
$pager->current_page(1);
warn $end = time - $start;


$start = time;
$pager->extend;
warn $end = time - $start;

$start = time;
$pager->base_url("http://www.example.com");
$pager->xhtml;
warn $end = time - $start;

