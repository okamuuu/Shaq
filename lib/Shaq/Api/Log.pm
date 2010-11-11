package Shaq::Api::Log;
use strict;
use warnings;
use Time::HiRes ();

sub new {
    my $class = shift;
    bless {
        _start     => [Time::HiRes::gettimeofday],
        _log_msgs  => [],
    }, $class;
}

sub start { $_[0]->{_start} }

sub get_log_msgs { @{ $_[0]->{_log_msgs} }  }

sub has_log_msgs { scalar $_[0]->get_log_msgs }

sub set_log_msgs { 
    my ($self, @msgs) = @_;
    $self->set_log_msg($_) for @msgs;
}

sub set_log_msg {
    my ( $self, $msg ) = @_;

    my $elapsed = Time::HiRes::tv_interval($self->start, [Time::HiRes::gettimeofday]);
    $self->{_log_msgs} = [ $self->get_log_msgs, "$msg ( $elapsed sec )" ];
}

1;

