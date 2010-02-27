package Shaq::Unit::WebService::Base;
use strict;
use warnings;
use UNIVERSAL::require;
use WebService::Simple;

sub new {
    my ( $class, $config ) = @_;

    my $base_url        = $config->{base_url} or Carp::croak("Plase set base_url..");
    my $param           = $config->{param} || {};
    my $response_parser = $config->{parser} || "XML::Simple";
    my $use_cache       = $config->{use_cache} || 0;
    my $cache_namespace = $config->{cache_namespace} || 'ws_';
    my $cache_servers   = $config->{cache_servers} || [ { address => 'localhost:11211'} ];

    my $cache;
    if ( $use_cache ) {

        Cache::Memcached::Fast->use;
        $cache = Cache::Memcached::Fast->new(
            {
                servers =>   $cache_servers,
                namespace => $cache_namespace,
            }
        );

        croak("Please run memcached  ...")
            unless keys %{ $cache->server_versions };
    }

    my $ws = WebService::Simple->new(
        base_url        => $base_url,
        param           => $param,
        response_parser => $response_parser,
        cache           => $cache,
    );

    my $self = bless {
        _ws    => $ws,
    }, $class;
}

sub ws    { $_[0]->{_ws} }

sub parse { die "abstract" }

1;

__END__

=head1 NAME 

Shaq::Unit::WebService - WebService Base class

=head1 METHODS

=head2 new

=head2 ws

=head2 parse

overwride like this if you need

    sub parse {
        my ( $self, $path, $attr ) = @_;
        return $self->ws->get($path, $attr)->parse_response;
    }

=cut


