package Shaq::Unit::Fixture::SQLite;
use strict;
use warnings;
use utf8;
use base 'Exporter';
our $VERSION = '0.01';
use Cwd;
use DBI;
use JSON::XS;
use Config::Multi;
use SQL::Abstract;
use Path::Class qw/dir file/;

our $DB_FILE     = file( cwd(), 'db', '_test.db'   );
our $SQL_FILE    = file( cwd(), 'db', 'schema.sql' );
our $FIXTURE_DIR = dir(  cwd(), 'db', 'fixture'    );
our $BUILD_MODE  = 0;

my %IS_JSON;

sub setup {
    my ($class, %opt) = @_;
    my $caller = caller;

    %IS_JSON = map { $_ => 1 } @{ $opt{json_columns} };

    ### XXX: t/Unit/Fixture/SQLite/00-basic.t .. 
    ### DBD::SQLite::db do failed: not an error at /home/okamura/p5/Shaq/lib/Shaq/Unit/Fixture/SQLite.pm line 23.
    my $dbh = DBI->connect("dbi:SQLite:$DB_FILE", '', '');
    my @statements = split ';', scalar $SQL_FILE->slurp;
    $dbh->do($_) for @statements;
 
    my $cm = Config::Multi->new(
        {
            dir       => $FIXTURE_DIR,
            app_name  => 'test',
            extension => 'yml',
            unicode   => 1    # unicode option
        }
    );
  
    my $fixture = $cm->load();
    
    my @queries = _fixture2queries($fixture);
            
    for my $query ( @queries ) { 
        my $sth = $dbh->prepare($query->{stmt});
        $sth->execute(@{ $query->{binds} });
    }

    ### XXX: test method 
    {
        no strict 'refs';
        *{"$caller\::_dbh"} = sub { $dbh };
        *{"$caller\::_fixture"} = sub { $fixture };
        *{"$caller\::_fixture2queries"} = \&_fixture2queries;
    }
}

sub _fixture2queries {
    my $fixture = shift;

    my $sql = SQL::Abstract->new;

    my @queries; 
    for my $table ( keys %$fixture ) {
        for my $record ( @{ $fixture->{$table} } ) {

            for my $column ( keys %$record ) {

                if ( $IS_JSON{$column} ) {
                    $record->{$column} = encode_json $record->{$column};
                }
            }
            my ( $stmt, @binds ) = $sql->insert( $table, $record );
            push @queries, { stmt => $stmt, binds => [@binds] };
        }
    }

    return @queries;
}

sub END {
    unlink $DB_FILE if not $BUILD_MODE;
}

1;
 
=head1 SEE ALSO

http://github.com/nekoya/p5-dbix-skinny-inflatecolumn-datetime/blob/master/t/Mock/SQLite.pm
http://github.com/nekokak/p5-test-fixture-dbixskinny/blob/master/lib/Test/Fixture/DBIxSkinny.pm
