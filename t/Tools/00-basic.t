#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Shaq::Tools' );
}
diag( "Testing Shaq::Tools $Shaq::Tools::VERSION, Perl $], $^X" );
