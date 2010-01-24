package Shaq::Api::Memcached;
use strict;
use warnings;
use Carp qw/croak/;
use Cache::Memcached::Fast;

sub new {
    my ( $class, $config ) = @_;

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
        _cache   => undef,
        ),
    }, $class;

    croak("Memcachedが起動していません。")
      unless keys %{ $self->memd->server_versions };

    return $self;
}

sub memd    { $_[0]->{_memd} }

1;

