package t::TestUtils;
use strict;
use warnings;
use Carp ();
use Hash::MultiValue;
use YAML;
use Test::Memcached;
use Test::mysqld;
use FindBin qw($Bin);
#use Shaq::Unit::Memcached;
use Shaq::Unit::DBI;

=pod
sub get_test_memcached {
    my $class = shift;

    my $memd = Test::Memcached->new(
        options => {
            user => 'memcached-user',
        }
    );

    $memd->start;

    my $port = $memd->option( 'tcp_port' );

    $Shaq::Unit::Memcache::SERVERS = ["127.0.0.1:$port"];
    
    return $memd;
}
=cut

sub get_test_mysqld {
    my $class = shift;

    my $mysqld = Test::mysqld->new( my_cnf => { 'skip-networking' => undef } );
    my $dsn = $mysqld->dsn( dbname => 'test' );

    {
        no warnings 'once';
        $Shaq::Unit::DBI::MASTER    = [$dsn];
        $Shaq::Unit::DBI::SLAVE     = [$dsn];
        $Shaq::Unit::DBI::LOG_FILE  = undef;
    }

    return $mysqld;
}

1;




