#!/usr/bin/env perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use URI::file;
use XML::Feed;
use XML::Hash::LX;
use XML::Hash;
use XML::Simple;
use XML::Twig;
use XML::Bare;
use XML::LibXML::Simple;
use Benchmark qw(:all);
use Data::Dumper;

my $file = file( $Bin, '..', "bench/samples/atom.xml" )->stringify;

open my $fh, '<', $file or die;
my $xml = do { local $/; <$fh> };
close $fh;

cmpthese timethese 10_000, {
	'XML::Feed' => sub {
		my $obj = XML::Feed->parse($xml);
	},
	'XML::Bare' => sub {
		my $root = XML::Bare->new( text => $xml )->parse;
	},
	'XML::Twig' => sub {
		my $hash = XML::Twig->new()->parse($xml);
	},
	'XML::Simple' => sub {
		my $hash = XML::Simple::XMLin($xml);
	},
	'Hash::LX' => sub {
		my $xml_hash = xml2hash($xml);
	},
	'XML::LibXML' => sub {
		my $doc = XML::LibXML->new->parse_string($xml);
	},
	'XML::LibXML::Simple' => sub {
		my $hash = XML::LibXML::Simple::XMLin($xml);
	},

};


__END__

:!perl bench/xml_parser.pl
Benchmark: timing 10000 iterations of Hash::LX, XML::Bare, XML::Feed, XML::LibXML, XML::LibXML::Simple, XML::Simple, XML::Twig...
  Hash::LX: 89 wallclock secs ( 5.79 usr + 83.59 sys = 89.38 CPU) @ 111.88/s (n=10000)
 XML::Bare:  5 wallclock secs ( 0.00 usr +  4.84 sys =  4.84 CPU) @ 2066.12/s (n=10000)
 XML::Feed:  2 wallclock secs ( 0.01 usr +  1.11 sys =  1.12 CPU) @ 8928.57/s (n=10000)
XML::LibXML:  4 wallclock secs ( 0.01 usr +  4.82 sys =  4.83 CPU) @ 2070.39/s (n=10000)
XML::LibXML::Simple: 79 wallclock secs ( 1.28 usr + 77.61 sys = 78.89 CPU) @ 126.76/s (n=10000)
XML::Simple: 108 wallclock secs ( 1.03 usr + 106.67 sys = 107.70 CPU) @ 92.85/s (n=10000)
 XML::Twig: 171 wallclock secs ( 2.79 usr + 168.32 sys = 171.11 CPU) @ 58.44/s (n=10000)
                      Rate XML::Twig XML::Simple Hash::LX XML::LibXML::Simple XML::Bare XML::LibXML XML::Feed
XML::Twig           58.4/s        --        -37%     -48%                -54%      -97%        -97%      -99%
XML::Simple         92.9/s       59%          --     -17%                -27%      -96%        -96%      -99%
Hash::LX             112/s       91%         20%       --                -12%      -95%        -95%      -99%
XML::LibXML::Simple  127/s      117%         37%      13%                  --      -94%        -94%      -99%
XML::Bare           2066/s     3435%       2125%    1747%               1530%        --         -0%      -77%
XML::LibXML         2070/s     3443%       2130%    1751%               1533%        0%          --      -77%
XML::Feed           8929/s    15178%       9516%    7880%               6944%      332%        331%        --

SEE ALSO: http://d.hatena.ne.jp/okamuuu/20100128/1264686132
