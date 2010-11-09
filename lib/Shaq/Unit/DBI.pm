package Shaq::Unit::DBI;
use strict;
use warnings;
use base qw/DBI/;

our $MASTER;
our $SLAVE;
our $LOG_FILE;

sub get_master_dbh {
    $_[0]->connect( @{$MASTER}, { RaiseError => 1 } ) or die "$DBI::errstr";
}

sub get_slave_dbh {
    $_[0]->connect( @{$SLAVE}, { RaiseError => 1 } ) or die "$DBI::errstr";
}

### These subs are almost for Test::memcached..
sub get_master_dsn { $_[0]->get_master_dbh->get_info(2); }

sub get_slave_dsn  { $_[0]->get_slave_dbh->get_info(2); }

1;

package Shaq::Unit::DBI::db;
use base qw/DBI::db/;

package Shaq::Unit::DBI::st;
use strict;
use warnings;
use base qw/DBI::st/;

use Time::HiRes ();

sub execute {
    my ($self, @binds) = @_;

    my $rv;
    if ($LOG_FILE) {
        
        my $start  = Time::HiRes::time();
        $rv     = $self->SUPER::execute(@binds);
        my $elapse = Time::HiRes::time() - $start;

        my $bind = @binds ? join ', ', @binds : undef;

        my $log = sprintf( "sql: %s bind: %s \nelapse: %f\n\n",
            $bind, $self->{Statement}, $elapse );

        $LOG_FILE->open('a')->print($log);
    }
    else {
        $rv     = $self->SUPER::execute(@binds);
    }

    return $rv;

}

1;

=head1 NAME

Shaq::Unit::DBI - This providing DBI Factory methods.

=head2 SYNOPSYS

    use Shaq::Unit::DBI;
    my $master = Shaq::Unit::DBI->get_master_dbh; 
    my $dsn    = Shaq::Unit::DBI->get_master_dsn;

    use Test::Mysqld;


=head2 DESCRIPTION

=cut

