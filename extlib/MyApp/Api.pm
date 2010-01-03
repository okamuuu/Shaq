package MyApp::Api;
use strict;
use warnings;

sub new {
    my ( $class, $config ) = @_;
    my $self = bless {
#        _tt        => Shaq::Api::TT->new,
#        _tt_nowrap => Shaq::Api::TT->new( wrapper => '' ),
#        _dbic      => DancePod::Api::DBIC->new( $config->{dbic} ),
    }, $class;
    return $self;
}

#sub tt        { return $_[0]->{_tt}        }
#sub tt_nowrap { return $_[0]->{_tt_nowrap} }
#sub dbic      { return $_[0]->{_dbic}      }

1;

