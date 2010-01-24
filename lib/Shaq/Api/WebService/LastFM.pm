package Shaq::Api::WebService::LastFM;
use strict;
use warnings;
use Shaq::Api::WebService::Core;

=head1 NAME

Shaq::Api::WebService::LastFM - Api

=head1 METHODS

=head2 new

=cut

sub new {
    my ( $class, $cache,  $config ) = @_;

    my $api_key   = $config->{base_param}->{api_key} or Carp::croak("Please set 'api_key' to use LastFM Web API ...");
    my $parser    = $config->{parser}    || "XML::Simple";
    my $host      = $config->{host}  || 'http://ws.audioscrobbler.com/2.0';
    my $base_path = $config->{base_path};
    my $base_param = $config->{base_param};

    my $core = Shaq::Api::WebService::Core->new($cache, {
        base_param      => { api_key => $api_key},
        response_parser => $parser,
        host            => $host,
        base_path       => $base_path,
        base_param      => $base_param,
    }); 

    my $self = bless {
        _core  => $core,
    }, $class;
}

sub get   { shift->{_core}->get(@_) }
sub parse { shift->{_core}->parse(@_) }

sub get_similar_artist {
    my ( $self, $name ) = @_;

    my $param = { 
        method => 'artist.getsimilar', 
        artist => $name, 
    };

    $self->parse({ param => $param });
}

1;

__END__

=head1 NAME 

Shaq::Api::WebService::LastFM - API

=head1 METHODS

=head2 new

=head2 parse



