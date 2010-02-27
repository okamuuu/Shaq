package Shaq::Unit::WebService::Lite;
use Mouse;
use UNIVERSAL::require;
use Data::Dumper;
use LWP::UserAgent;

our $VERSION = '0.03';

has 'uri'    => ( is => 'ro', isa => 'URI', required => 1 );
has 'base_param' => ( is => 'ro', isa => 'HashRef', auto_deref => 1);
has 'cache'  => ( is => 'ro', isa => 'Cache::Memcached::Fast',  predicate => 'has_cache');
has 'parser' => ( is => 'ro', isa => 'Shaq::Unit::WebService::Lite::Parser' );
has 'ua'     => ( is => 'ro', default => sub { LWP::UserAgent->new } );

no Mouse;

sub BUILDARGS {
    my ( $self, $config ) = @_;

    my $parser = "Shaq::Unit::WebService::Lite::Parser::" . $config->{parser};
    $parser->require or die $@;
    
    $config->{parser} = $parser->new;    
    return $config;
}

sub get {
    my ( $self, $extra ) = @_;

    my $path  = $extra->{path} || undef;
    my $param = $extra->{param} || undef;

    my $uri = $self->uri->clone;

    $uri->path( $uri->path, $path ) if $path;
    $uri->query_form( { $self->base_param, %$param } );

    my $response;
    if ( $self->has_cache ) {
        $response = $self->_cache_get($uri->as_string);

        if ( not $response ) {
            $response = $self->ua->get($uri->as_string);
        
            $response->is_success
              ? $self->_cache_set( $uri->as_string, $response )
              : Carp::croak("request failed to : " . $uri->as_string );
        }
    }
    else {
        $response = $self->ua->get($uri->as_string);
    }

    $self->parser->parse( $response );
}

sub _cache_get {
    my $self  = shift;

    return unless $self->has_cache;

    my $key = $self->_cache_key(shift);
    return $self->cache->get( $key, @_ );
}

sub _cache_set {
    my $self  = shift;

    return unless $self->has_cache;

    my $key = $self->_cache_key(shift);
    return $self->cache->set( $key, @_ );
}

sub _cache_remove {
    my $self  = shift;

    return unless $self->has_cache;

    my $key = $self->_cache_key(shift);
    return $self->cache->remove( $key, @_ );
}

sub _cache_key {
    my $self = shift;
    local $Data::Dumper::Indent   = 1;
    local $Data::Dumper::Terse    = 1;
    local $Data::Dumper::Sortkeys = 1;
    return Digest::MD5::md5_hex( Data::Dumper::Dumper( $_[0] ) );
}

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME 

Shaq::Api::WebService::Lite - My WebService Lite module

=head1 DESCRIPTION

WebService::Simpleを研究するために再発明したモジュール

=head1 METHODS

=head2 new

=head2 get

=cut


