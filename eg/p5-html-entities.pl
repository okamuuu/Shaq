#!/usr/bin/perl
use strict;
use warnings;
use HTML::Entities;

my $xhtml = "<p>test</p>";
warn my $encoded = HTML::Entities::encode_entities( $xhtml );
warn my $decoed  = HTML::Entities::decode_entities( $encoded );
 
