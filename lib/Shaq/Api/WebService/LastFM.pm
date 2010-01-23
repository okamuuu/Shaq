package Shaq::Api::WebService::LastFM;
use strict;
use warnings;
use Try::Tiny;
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

sub core { $_[0]->{_core} }

sub parse {
    my ( $self, $param ) = @_;

    my $data;
    try {
        $data = $self->core->ws->get($param)->parse_response;
        $self->core->msg->set_errors("nothing...") unless $data;
    }
    catch {
        $self->core->msg->set_errors( $_ );
        return undef;
    };

    return $data;
}

1;

__END__

=head1 NAME 

Shaq::Api::WebService::LastFM - API

=head1 METHODS

=head2 new

=head2 parse



