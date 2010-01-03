#!/usr/bin/env perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use URI::file;
use XML::LibXML;
use XML::Feed;
use XML::Bare;
use Benchmark qw(:all);
use Data::Dumper;

my $atom_file  = file( $Bin, '..', '..', '..', "t/Api/WebService/samples/atom.xml" )->stringify;
my $rss10_file = file( $Bin, '..', '..', '..', "t/Api/WebService/samples/rss10.xml" )->stringify;
my $rss20_file = file( $Bin, '..', '..', '..', "t/Api/WebService/samples/rss20.xml" )->stringify;

my $fh;
open $fh, '<', $atom_file or die;
my $atom = do { local $/; <$fh> };
close $fh;

open $fh, '<', $rss10_file or die;
my $rss10 = do { local $/; <$fh> };
close $fh;

open $fh, '<', $rss20_file or die;
my $rss20 = do { local $/; <$fh> };
close $fh;

cmpthese timethese 10000, {
	'XML::LibXML' => sub {
		my $doc1 = XML::LibXML->new->parse_string($atom);
		my $doc2 = XML::LibXML->new->parse_string($rss10);
		my $doc3 = XML::LibXML->new->parse_string($rss20);
	},
	'XML::Feed' => sub {
		my $obj1 = XML::Feed->parse($atom);
		my $obj2 = XML::Feed->parse($rss10);
		my $obj3 = XML::Feed->parse($rss20);
	},
	'Bare' => sub {
		my $root1 = XML::Bare->new( text => $atom  )->parse;
		my $root2 = XML::Bare->new( text => $rss10 )->parse;
		my $root3 = XML::Bare->new( text => $rss20 )->parse;
	},
};

__END__

解析結果が異なる為厳密に判断できないがXML::Feedが
AnyEvent::Feed などで使用されている事からもXML::Feedが良いのか、、、

ただし、XML::FeedではYoutubeで必要な要素(yt:username)などを取得しようとすると

$entry->{entry}->{elem}->getChildrenByTagName( 'yt:username' )->string_value;

となってしまう。この処理はXML::LibXMLの機能を用いて解析している。

結局XML::Feedでそこそこ処理を行ってから細かい場所はXML::LibXMLで追いかける図式

本当はXML::Simpleのようにhash-refが欲しいが解析に時間かかる、、、高速化できたらいいな

- XML::Hash::LX は考え方が良いが速度に難あり。
- XML::Bare 高速だけどXMLがマルチコンテントだと対応しないとかなんとか

着地点: XML::Feedで高速処理。足りない個所はXML::LibXMLのメソッドを使って追いかける

:!perl eg/Api/WebService/parser_bench.pl
Benchmark: timing 10000 iterations of Bare, XML::Feed, XML::LibXML...

Bare: 12 wallclock secs ( 0.01 usr + 11.73 sys = 11.74 CPU) @ 851.79/s (n=10000)
XML::Feed:  3 wallclock secs ( 0.09 usr +  3.14 sys =  3.23 CPU) @ 3095.98/s (n=10000)
XML::LibXML: 13 wallclock secs ( 0.00 usr + 12.96 sys = 12.96 CPU) @ 771.60/s (n=10000)

Rate XML::LibXML        Bare   XML::Feed
XML::LibXML  772/s          --         -9%        -75%
Bare         852/s         10%          --        -72%
XML::Feed   3096/s        301%        263%          --


