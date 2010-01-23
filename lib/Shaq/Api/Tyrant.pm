package Shaq::Api::Tyrant;
use strict;
use warnings;
use Carp;
use TokyoTyrant;

sub new {
    my ( $class, $config ) = @_;

    my $host = $config->{host} || 'localhost';
    my $port = $config->{port} || 1978;

    my $rdb = TokyoTyrant::RDB->new(); 
    
#    $rdb->open( $host, $port ) or die "open error: ".$rdb->errmsg($rdb->ecode);

    my $self = bless {
        _host => $host,
        _port => $port,
        _rdb  => $rdb,
    }, $class;

    return $self;
}

sub host { $_[0]->{_host} }
sub port { $_[0]->{_port} }
sub rdb  { $_[0]->{_rdb}  }

sub get {
    my ($self, $key) = @_;
    $self->rdb->open( $self->host, $self->port );
    my $cache = $self->rdb->get($key);
    $self->rdb->close;
    return $cache;
}

sub set {
    my ($self, $key, $data) = @_;
    $self->rdb->open( $self->host, $self->port );
    $self->rdb->set( $key => $data, $self->exptime );
    $self->rdb->close;
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

