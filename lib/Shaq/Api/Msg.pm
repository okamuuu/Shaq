package Shaq::Api::Msg;
use strict;
use warnings;

sub new {
    my $class = shift;
    bless {
        _status_msgs  => [],
        _error_msgs   => [],
    }, $class;
}

sub get_status_msgs { @{ $_[0]->{_status_msgs} }  }

sub has_status_msgs { scalar $_[0]->get_status_msgs }

sub set_status_msgs {
    my ( $self, @new_messages ) = @_;

    $self->{_status_msgs} = [ $self->get_status_msgs, @new_messages ];
}

sub get_error_msgs { @{ $_[0]->{_error_msgs} } }

sub has_error_msgs { scalar $_[0]->get_error_msgs }

sub set_error_msgs {
    my ( $self, @new_messages ) = @_;

    $self->{_error_msgs} = [ $self->get_error_msgs, @new_messages ];
}

1;

