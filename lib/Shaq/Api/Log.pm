package Shaq::Api::Msg;
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

sub set_log_msgs { shift->set_log_msg($_) for @_ }

sub set_log_msg {
    my ( $self, $msg ) = @_;

    my $elapsed = Time::HiRes::tv_interval($self->start, [gettimeofday]);
    $self->{_logs} = [ $self->get_logs, "$msg ( $elapsed sec )" ];
}

1;

