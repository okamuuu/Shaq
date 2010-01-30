package Shaq::Api::WebService::Lite;
use strict;
use warnings;
use UNIVERSAL::require;
use LWP::UserAgent;
use Digest::MD5 ();
our $VERSION = '0.01';

sub new {
    my ( $class, $config, $cache ) = @_;

    if ( $cache ) {
        Carp::croak("This cache object can't get ...") unless $cache->can('get');
        Carp::croak("This cache object can't set ...") unless $cache->can('set');
        Carp::croak("This cache object can't remove ...") unless $cache->can('remove');
    }
    
    my $debug      = $config->{debug} || 0;    
    my $host       = $config->{host} or Carp::croak("Please set 'host' ...");
    my $base_path  = $config->{base_path} || undef;
    my $base_param = $config->{base_param} || {};
    my $parser     = $config->{parser} || "XML::Simple";

    if ( not $parser =~ m/XML::Simple|XML::LibXML::Simple|JSON::XS/g ) {
        Carp::croak("please set 'parser' XML::Simple, XML::LibXML::Simple or JSON::XS ...");
    }

    my $uri = URI->new($host);
    $uri->path( $base_path ) if $base_path;

    my $self = bless {
        _debug      => $debug,
        _ua         => LWP::UserAgent->new,
        _uri        => $uri,
        _base_param => $base_param,
        _cache      => $cache,
    }, $class;

    ### load parser object
    $parser->use or die $@;
    $self->{_parser} = $parser->new;
    
    $self; 
}

sub get {
    my ( $self, $extra ) = @_;

    my $uri = $self->_uri->clone;

    $uri->path( $extra->{path} ) if $extra->{path};
    $uri->query_form( %{$self->_base_param}, %{$extra->{param}} );

    my $request_url = $uri->as_string;
    my $response    = $self->_cache_get($request_url);

    if ( not $response ) {
        $response = $self->_ua->get($request_url);

        if ( !$response->is_success ) {
            Carp::croak("request to $request_url failed");
        }
        
        $self->_cache_set( $request_url, $response );
    }

    my $content = $response->content;

    $self->_parse( $content );
}

sub _parser     { $_[0]->{_parser} }
sub _parse      { 
    my ( $self, $content ) = @_;
     
    if ( $self->_parser =~ m{XML::Simple|XML::LibXML::Simple} ) {
        return XMLin( $content ); 
    }
    elsif ( $self->_parser =~ m{JSON::XS} ) { # JSONでもXSがあればそれが呼ばれるのだけれども
        return decode_json( $content );
    }
    else {}

    Carp::croak("this is not extected ...");
}

sub _ua         { $_[0]->{_ua} }
sub _uri        { $_[0]->{_uri} }
sub _base_param { $_[0]->{_base_param} }
sub _cache      { $_[0]->{_cache}->memd if $_[0]->{_cache} }

sub _cache_get {
    my $self  = shift;
    my $cache = $self->_cache;
    return unless $cache;

    my $key = $self->_cache_key(shift);
    return $cache->get( $key, @_ );
}

sub _cache_set {
    my $self  = shift;
    my $cache = $self->_cache;
    return unless $cache;

    my $key = $self->_cache_key(shift);
    return $cache->set( $key, @_ );
}

sub _cache_remove {
    my $self  = shift;
    my $cache = $self->_cache;
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

Shaq::Api::WebService::Lite - My Personal Class

=head1 METHODS

=head2 new

=head2 get

=cut


