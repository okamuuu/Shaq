package Shaq::Unit::WebService::Lite;
use Mouse;
use UNIVERSAL::require;
use LWP::UserAgent;
use Digest::MD5 qw/md5_hex/;
use Cache::Memcached::Fast;

our $VERSION = '0.03';

has 'uri'    => ( is => 'ro', isa => 'URI', required => 1 );
has 'base_param' => ( is => 'ro', isa => 'HashRef', auto_deref => 1 );
has 'cache'  => ( is => 'ro', isa => 'Cache::Memcached::Fast',  predicate => 'has_cache');
has 'parser' => ( is => 'ro', does => 'Shaq::Unit::WebService::Lite::Parser' );
has 'expire' => ( is => 'ro');
has 'ua'     => ( is => 'ro', default => sub { LWP::UserAgent->new } );

no Mouse;

sub BUILDARGS {
    my $self = shift;
    my $config = @_ == 1 ? shift : {@_};

    my $servers    = $config->{cache}->{servers} || [ { address => 'localhost:11211'} ];
    my $namespace  = $config->{cache}->{namespace} || 'ws#';
    my $expire     = $config->{cache}->{expire} || 60 * 60 * 24;
    my $parser     = $config->{parser} || "XML::Simple";
    my $uri        = $config->{uri};
    my $base_param = $config->{base_param} || {};

    my $cache_obj = Cache::Memcached::Fast->new(
        {
            servers   => $servers,
            namespace => $namespace,
        }
    );

    Carp::croak("Please run memcached  ...")
      unless keys %{ $cache_obj->server_versions };

    $parser = "Shaq::Unit::WebService::Lite::Parser::" . $parser;
    $parser->require or die $@;
    my $parser_obj = $parser->new;
     
    my $uri_obj = URI->new($uri);

    return my $opt = {
        cache      => $cache_obj,
        parser     => $parser_obj,
        uri        => $uri_obj,
        base_param => $base_param,
        expire     => $expire,
    };
}

sub get {
    my ( $self, $extra ) = @_;

    my $path  = $extra->{path} || undef;
    my $param = $extra->{param} || {};

    my $uri = $self->uri->clone;

    $uri->path( $uri->path . $path ) if $path;
    $uri->query_form( { $self->base_param, %$param } );

    my $response;
    if ( $self->has_cache ) {
        $response = $self->_cache_get($uri->as_string);

        if ( not $response ) {
            $response = $self->ua->get($uri->as_string);
        
            $response->is_success
              ? $self->_cache_set( $uri->as_string, $response, $self->expire )
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


