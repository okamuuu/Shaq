#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Shaq::Unit::Config' );
}

diag( "Testing Shaq::Unit::Config $Shaq::Unit::Config::VERSION, Perl $], $^X" );
