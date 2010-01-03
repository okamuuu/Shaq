#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib ("$FindBin::Bin/../lib");
use lib ("$FindBin::Bin/../extlib");
use Shaq::Api::MT;

my $mt = Shaq::Api::MT->new;

warn my $content = $mt->render( 'child', { name => 'okamura' } );


