#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir/;
use lib dir( $Bin, '..', 'lib' )->stringify;
use Shaq::Api::Tyrant;

use Perl6::Say;
use Data::Dumper;


my $rdb = TokyoTyrant::RDB->new();
$rdb->open("localhost", 1978) or die "open error: ".$rdb->errmsg($rdb->ecode);

$rdb->put("foo","bar") or die "put error: ".$rdb->errmsg($rdb->ecode);
my $value = $rdb->get("foo");
defined $value or die "get error: ".$rdb->errmsg($rdb->ecode);
printf("%s\n", $value);
$rdb->close() or die "close error: ".$rdb->errmsg($rdb->ecode);


