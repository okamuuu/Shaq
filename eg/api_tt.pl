#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib ("$FindBin::Bin/../lib");
use Shaq::Api::TT;

my $tt = Shaq::Api::TT->new( wrapper => 'layout.tt2', tmpl_dir => 'tmpl' );
my $content = $tt->render( tmpl_file => 'name.tt2', stash => {name => 'okamura'} );

print $content;


