package Shaq::Unit::Skinny;
use strict;
use warnings;
use IO::File;
use UNIVERSAL::require;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Data::Page;
use Data::Dumper;
use lib dir($Bin, '..', 'lib')->stringify;
use Shaq::Api::Skinny::Profiler;

sub new {
    my ( $class, $config ) = @_;

    Carp::croak('Please set $config->{master}->{db_class}')
      unless $config->{master}->{db_class};
    Carp::croak('Please set $config->{master}->{connect_info}')
      unless $config->{master}->{connect_info};
    Carp::croak('Please set $config->{slave}->{db_class}')
      unless $config->{slave}->{db_class};
    Carp::croak('Please set $config->{slave}->{connect_info}')
      unless $config->{slave}->{connect_info};
   
    my $self = bless {
        _config    => $config,
    }, $class;

    $self->set_master_db;
    $self->set_slave_db;

    return $self;
}

sub config { $_[0]->{_config} }

sub master_db {$_[0]->{_master_db} }
sub slave_db {$_[0]->{_slave_db} }

sub set_master_db {
    my ( $self ) = @_;

    my $db_class = $self->config->{master}->{db_class};
    $db_class->use or Carp::croak $@;

    my ( $dsn, $username, $password ) = @{$self->config->{master}->{connect_info}}; 
    my $db = $db_class->new( { dsn=> $dsn, username => $username, password => $password } );

    if ( $self->config->{master}->{log_mode} ) {
        $db->attribute->{profile} = 1;
        $db->{profiler} = Shaq::Api::Skinny::Profiler->new({log_path=>$self->config->{master}->{query_log_path}});
    }

    $self->{_master_db} = $db;
}

sub set_slave_db {
    my ( $self ) = @_;

    my $db_class = $self->config->{slave}->{db_class};
    $db_class->use or Carp::croak $@;

    my ( $dsn, $username, $password ) = @{$self->config->{slave}->{connect_info}}; 
    my $db = $db_class->new( { dsn=> $dsn, username => $username, password => $password } );

    if ( $self->config->{slave}->{log_mode} ) {
        $db->attribute->{profile} = 1;
        $db->{profiler} = Shaq::Api::Skinny::Profiler->new({ log_path => $self->config->{slave}->{query_log_path}});
    }
   
    $self->{_slave_db} = $db;
}

1;

__END__

=head1 NAME

Shaq::Api::Skinny - Api

=head1 METHODS

=head2 new

=head2 config

=head2 master_db

=head2 slave_db

=head2 set_master_db

=head2 set_slave_db

