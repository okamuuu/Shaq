package Shaq::Unit::DBI;
use strict;
use warnings;
use base qw/DBI/;

our $MASTER;
our $SLAVE;
our $QUERY_LOG_PATH;

sub get_master_dbh {
    my $class = shift;

    my $dbh = DBI->connect( @{$MASTER}, {RaiseError=>1} ) or die "$DBI::errstr";
}

sub get_slave_dbh {
    my $class = shift;

    my $dbh = DBI->connect( @{$SLAVE}, {RaiseError=>1} ) or die "$DBI::errstr";
}

package Shaq::Unit::DBI::db;
use base qw/DBI::db/;

package Shaq::Unit::DBI::st;
use strict;
use warnings;
use base qw/DBI::st/;

use Time::HiRes qw();

sub execute {
    my ($self, @bind_params) = @_;

    if ($QUERY_LOG_PATH) {
        my $start  = Time::HiRes::time();
        my $rv     = $self->SUPER::execute(@bind_params);
        my $elapse = Time::HiRes::time() - $start;

        print STDERR
          sprintf( 'sql: %s, elapse: %f', $self->{Statement}, $elapse );
    }

    return $rv;

}

=head1 NAME

Shaq::Unit::DBI - DBIの拡張クラス

=head2 SYNOPSYS

    use DBI;
    DBI->connect('dbi:mysql:dbname=hoge', 'username', 'password', +{ RootClass => 'Shaq::Unit::DBI' });

    use Shaq::Unit::DBI;
    my $master = Shaq::Unit::DBI->get_master_dbh; 

=head2 DESCRIPTION

    use Data::Dumper;

    my $dbh = DBI->connect('dbi:mysql:dbname=hoge', 'username', 'password', +{ RootClass => 'Shaq::Unit::DBI' });
    my $sth = $dbh->prepare('SHOW TABLES');
    $sth->execute;
    
    print Dumper($sth->fetchall_arrayref(+{}));
    $sth->finish;
    $dbh->disconnect;

=cut

1;

