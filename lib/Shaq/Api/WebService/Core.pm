package Shaq::Api::WebService::Core;
use strict;
use warnings;
use Carp;
use Try::Tiny;
use LWP::UserAgent;
use Cache::Memcached::Fast;
use WebService::Simple;
use Shaq::Api::Msg;
use Data::Page;
use DateTimeX::Web;
use DateTime::Format::Atom;
use DateTime::Format::Mail;

sub new {
    my ( $class, $config ) = @_;
    
    my $param           = $config->{param} || {}; # for WebService::Simple
    my $api_key         = $config->{api_key} or croak("Please set 'api_key' for LastFM Web API ...");
    my $base_url        = $config->{base_url} or croak("Please set 'base_url' for WebService::Simple ...");
    my $response_parser = $config->{response_parser} or croak("Please set 'response_parser' for WebService::Simple ...");
    my $namespace       = $config->{namespace} or croak("Please set 'namespace' for Cache::Memcached::Fast ...");

    my $cache = Cache::Memcached::Fast->new(
        {
            servers => [ { address => 'localhost:11211'} ],
            namespace => $namespace,
        }
    );

    croak("Memcachedが起動していません。")
      unless keys %{ $cache->server_versions };

    my $ws = WebService::Simple->new(
        base_url        => $base_url,
        param           => $param,
        response_parser => $response_parser,
        cache           => $cache,
        param           => { api_key => $api_key, }
    );

    my $self = bless {
        _ws    => $ws,
        _ua    => LWP::UserAgent->new,
        _msg   => Shaq::Api::Msg->new,
        _dtx   => DateTimeX::Web->new(time_zone => 'Asia/Tokyo'),
    }, $class;
}

sub ua    { $_[0]->{_ua} }
sub ws    { $_[0]->{_ws} }
sub msg   { $_[0]->{_msg} }
sub dtx   { $_[0]->{_dtx} }

sub parse {
    my ( $self, $param ) = @_;

    my $data;
    try {
        $data = $self->ws->get($param)->parse_response;
        $self->msg->set_errors("nothing...") unless $data; # or die XML::Feed->errstrとか、Parserをカスタムしよ
    }
    catch {
        $self->msg->set_errors( $_ );
        return undef;
    };
    
    return $data;
}

1;

__END__

=head1 NAME 

Shaq::Api::WebService::Core - WebService Core class

=head1 METHODS

=head2 new

=head2 ua

=head2 ws

=head2 msg

=head2 pager

=head2 parse

=cut


