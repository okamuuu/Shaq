package Shaq::Api::Memcached;
use strict;
use warnings;
use Carp qw/croak/;
use Cache::Memcached::Fast;

our $VERSION = '0.01';

sub new {
    my ( $class, $config ) = @_;

    my $debug     = $config->{debug} || 0;
    my $namespace = $config->{namespace} or croak("Please set namespace...");
    my $servers   = $config->{servers} || ['127.0.0.1:11211'];
#    my $exptime   = $config->{exptime} || '300';

    my $self = bless {
         _memd => Cache::Memcached::Fast->new(
            {
                namespace => $namespace,
                servers   => $servers,
#                exptime   => $exptime,
            },
        ),
    }, $class;

    croak("Memcachedが起動していません。")
      unless keys %{ $self->memd->server_versions };

    return $self;
}

=pod

下記の操作でmemcachedが行っている処理をファイル出力
したらよいかもしれないと思って

=cut

sub get { 
    my ( $self, $key ) = @_;
    $self->{_memd}->get( $key );
}

sub set { 
    my ( $self, $key, $value ) = @_;
    $self->{_memd}->set( $key, $value );
}

sub remove { 
    my ( $self, $key, $value ) = @_;
    $self->{_memd}->remove( $key, $value );
}

1;

