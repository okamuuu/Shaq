package Shaq::Api::WebService::Core;
use strict;
use warnings;
use Carp;
use Try::Tiny;
use LWP::UserAgent;
use XML::Simple;
use Digest::MD5 ();
#use URI::Escape;
#use Shaq::Api::Msg;
#use DateTimeX::Web;

sub new {
    my ( $class, $cache, $config ) = @_;

# あー集約だとこれできないのかー
#    croak("Please set 'cache object' ...")
#      unless $cache->isa('Cache::Memcached::Fast');

    my $debug      = $config->{debug} || 0;    
    my $host       = $config->{host} or croak("Please set 'host' ...");
    my $base_path  = $config->{base_path} || undef;
    my $base_param = $config->{base_param} || {};

    my $self = bless {
        _debug      => $debug,
        _parser     => XML::Simple->new,
        _ua         => LWP::UserAgent->new,
        _uri        => URI->new($host),
        _base_path  => $base_path,
        _base_param => $base_param,
        _cache      => $cache,
    }, $class;

}

sub parser     { $_[0]->{_parser} }
sub ua         { $_[0]->{_ua} }
sub uri        { $_[0]->{_uri} }
sub base_path  { $_[0]->{_base_path} }
sub base_param { $_[0]->{_base_param} }
sub cache      { $_[0]->{_cache}->memd  }

sub get {
    my ( $self, $extra ) = @_;

    my $path       = $extra->{path} || $self->base_path;
    my $param      = $extra->{param} || {};
    my $base_param = $self->base_param || {};

    $self->uri->path( $path );
    $self->uri->query_form( {%{$base_param}, %{$param}}  );

    my $request_url = $self->uri->as_string;

warn    my $response = $self->_cache_get( $request_url );

    if ( not $response ) {
        $response = $self->ua->get($request_url);

        if ( !$response->is_success ) {
            Carp::croak("request to $request_url failed");
        }
        
        $self->_cache_set( $request_url, $response );
    }

    my $content = $response->content;

    $self->parser->XMLin( $content ); 
}

sub _cache_get {
    my $self  = shift;
    my $cache = $self->cache;
    return unless $cache;

    my $key = $self->_cache_key(shift);
    return $cache->get( $key, @_ );
}

sub _cache_set {
    my $self  = shift;
    my $cache = $self->cache;
    return unless $cache;

    my $key = $self->_cache_key(shift);
    return $cache->set( $key, @_ );
}

sub _cache_remove {
    my $self  = shift;
    my $cache = $self->cache;
    return unless $cache;

    my $key = $self->_cache_key(shift);
    return $cache->remove( $key, @_ );
}

sub _cache_key {
    my $self = shift;
    local $Data::Dumper::Indent   = 1;
    local $Data::Dumper::Terse    = 1;
    local $Data::Dumper::Sortkeys = 1;
    return Digest::MD5::md5_hex( Data::Dumper::Dumper( $_[0] ) );
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


