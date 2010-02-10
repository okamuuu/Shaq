#!/usr/bin/perl
use strict;
use warnings;
use URI::Escape;

warn my $url  = "http://search.yahoo.co.jp/search?p=東京";
warn my $safe = uri_escape($url);
warn my $str  = uri_unescape($safe);

__END__

warn my $safe = uri_escape("10% is enough\n");
warn my $verysafe = uri_escape("foo", "\0-\377");
warn my $str  = uri_unescape($safe);


 

=pod

http://www.7key.jp/rfc/2396/rfc2396.html
http://www.7key.jp/rfc/2396/rfc2396_2.html#li16

=cut
