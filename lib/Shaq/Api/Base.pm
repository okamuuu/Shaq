package Shaq::Api::Base;
use strict;
use warnings;
use Shaq::Api::Msg;
use Shaq::Api::Log;

our $LOG_PATH;

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;

    my $msg = Shaq::Api::Msg->new;
    my $log = Shaq::Api::Log->new;

    bless {
        _msg => $msg,
        _log => $log,
    }, $class;
}

sub msg { $_[0]->{_msg} }

sub log { $_[0]->{_log} }

sub set_status_msgs {
    my ( $self, @new_messages ) = @_;
    $self->msg->set_status_msgs(@new_messages);
    $self->log->set_logs(@new_messages);
}

sub set_error_msgs {
    my ( $self, @new_messages ) = @_;
    $self->msg->set_error_msgs(@new_messages);
    $self->log->set_logs(@new_messages);
}

sub set_debug_msgs {
    my ( $self, @new_messages ) = @_;
    $self->log->set_logs(@new_messages);
}

sub DESTROY {
    my $self = shift;
    
    if ( $LOG_PATH and $self->log->has_logs ) {

        my $fh = IO::File->new( $LOG_PATH, 'a');
        
        $fh->print( '-' x 10, "\n" );
        $fh->print($_) for map { "$_\n" } $self->log->get_logs();
        $fh->print("\n");
        $fh->close;
    }
    else {
        return;    # なにもしない
    }
}

1;

