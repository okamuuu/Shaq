#!/usr/bin/perl
use strict;
use warnings;
use FindBin::libs;
use Carp;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use lib dir( $Bin, '..', 'lib')->stringify; # search lib of Shaq::Tools
use Shaq::Tools;

Shaq::Tools::run(@ARGV);


