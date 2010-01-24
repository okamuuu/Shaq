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
    my ( $class, $config ) = @_;

    my $api_key   = $config->{api_key} or Carp::croak("Please set 'api_key' to use LastFM Web API ...");
    my $parser    = $config->{parser}    || "XML::Simple";
    my $base_url  = $config->{base_url}  || 'http://ws.audioscrobbler.com/2.0';
    my $namespace = $config->{namespace} || 'last_fm_';

    my $core = Shaq::Api::WebService::Core->new({
        api_key         => $api_key,
        response_parser => $parser,
        base_url        => $base_url,
        namespace       => $namespace,
    }); 

    my $self = bless {
        _core  => $core,
    }, $class;
}

sub ua    { $_[0]->{_core}->ua }
sub ws    { $_[0]->{_core}->ws }
sub msg   { $_[0]->{_core}->msg }
sub dtx   { $_[0]->{_core}->dtx }
sub parse { shift->{_core}->parse(@_) }

sub get_similar_artist {
    my ( $self, $name ) = @_;

    my $param = { 
        method => 'artist.getsimilar', 
        artist => $name, 
    };

    $self->parse($param);
}

1;

__END__

=head1 NAME 

Shaq::Api::WebService::LastFM - API

=head1 METHODS

=head2 new

=head2 parse



