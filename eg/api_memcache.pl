#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir/;
use lib dir( $Bin, '..', 'lib' )->stringify;
use Shaq::Api::Memcached;
use Perl6::Say;
use Data::Dumper;

my $config = { namespace => 'example' };

my $memd = Shaq::Api::Memcached->new($config);

my $key   = 'key_v001';
my $value = { test => 'this is test.' };

=pod
warn $key = $memd->auto_gen_key;
$memd->set( $key, $value );
warn Dumper my $data = $memd->get( $key );
=cut

=pod
$memd->cache($value);
warn Dumper $memd->cache;
=cut

my $hoge = Hoge->new($config);

warn Dumper $hoge->get_data;

package Hoge;
use Shaq::Api::Memcached;
use strict;
use warnings;

sub new {
    my ( $class, $config ) = @_;
    
    my $memd = Shaq::Api::Memcached->new($config);

    my $self = bless {
         _memd => $memd,
    }, $class;

    return $self;
}

sub memd { $_[0]->{_memd} }

sub get_data {
    my ( $self ) = @_;

    my $cache = $self->memd->cache;
    return $cache if $cache;

    my $data = { id => 1, name => 'yoshiki' };
    $self->memd->cache($data);
    
    return $data;
}

1;
