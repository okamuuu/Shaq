package Shaq::Api::Memcached;
use strict;
use warnings;
use Carp;
use Cache::Memcached::Fast;

sub new {
    my ( $class, $config ) = @_;

    my $namespace = $config->{namespace} or croak("Please set namespace...");
    my $servers   = $config->{servers} || ['127.0.0.1:11211'];
    my $exptime   = $config->{exptime} || '300';

    my $self = bless {
         _memd => Cache::Memcached::Fast->new(
            {
                namespace => $namespace . '_',
                servers   => $servers,
            }
        ),
    }, $class;

    croak("Memcachedが起動していません。")
      unless keys %{ $self->memd->server_versions };

    return $self;
}

sub memd { $_[0]->{_memd} }

sub exptime { $_[0]->{_exptime} }

sub get {
    my ($self, $key) = @_;
    my $cache = $self->memd->get($key);
}

sub set {
    my ($self, $key, $data) = @_;
    $self->memd->set( $key => $data, $self->exptime );
}

sub cache {
    my ($self, $value) = @_;
    
    my $key = $self->auto_gen_key;

    if ( $value ) {
        return $self->memd->set( $key => $value, $self->exptime );
    }
    else {
        return $self->memd->get($key);
    
    }
}

sub auto_gen_key {
    my ($self) = @_;

    my $key = (caller(2))[3]; # 完全修飾名 eg. Shaq::Api::method 
    croak('callerが見つかりません。mainからの呼び出しには対応していません') unless $key;
    $key;
} 

1;

