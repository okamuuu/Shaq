#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Shaq::Api::Cache' );
}

diag( "Testing Shaq::Api::Cache $Shaq::Api::Config::VERSION, Perl $], $^X" );
