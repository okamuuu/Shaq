#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Shaq::Api::Config' );
}

diag( "Testing Shaq::Api::Config $Shaq::Api::Config::VERSION, Perl $], $^X" );
