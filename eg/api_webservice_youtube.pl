#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Time::HiRes qw/time/;
#use Data::Dumper;
#$Data::Dumper::Maxdepth = 6;
use lib dir($Bin, '..', 'lib')->stringify;
use Shaq::Api::WebService::Youtube;
#Shaq::Api::WebService::Youtube::DEBUG = 1;

my $yt = Shaq::Api::WebService::Youtube->new;

#warn Dumper $yt->subscriptions('okamuuuuu');

my $start = time;
my ($videos, $pager) =  $yt->videos( { author => 'CwalkerLokos'},{page=>1} );
warn my $end = time - $start;

#warn Dumper $videos;
#warn Dumper $pager;
