package Shaq::Api::Msg;
use strict;
use warnings;

sub new { 
    my ( $class, %arg ) = @_;

    my $messages = $arg{messages} || [];
    my $errors   = $arg{errors}   || [];

    if ( ref $messages ne 'ARRAY' ) {
        croak('messagesにはarray-refを渡す必要があります。');
    }
    
    if ( ref $errors ne 'ARRAY' ) {
        croak('errorsにはarray-refを渡す必要があります。');
    }

    my $self = bless {
        _messages => $messages,
        _errors   => $errors,
    }, $class;

    return $self;
};

sub clear {
    my ( $self ) = @_;

    $self->{_messages} = [];
    $self->{_errors}   = [];

    return $self;
}

sub set_errors {
    my $self = shift;

    my @errors = @{ $self->{_errors} };
    $self->{_errors} = [ @errors, @_ ];
    return $self;
}

sub set_messages {
    my $self = shift;
    my @errors = @{ $self->{_messages} };
    $self->{_messages} = [ @errors, @_ ];
    return $self;
}

sub get_errors { $_[0]->{_errors} }
sub has_errors { scalar @{ $_[0]->get_errors } }

sub get_messages { $_[0]->{_messages} }
sub has_messages { scalar @{ $_[0]->get_messages } }
 
1;

=head1 NAME 

Shaq::Api::Msg - message class

=head1 METHODS

=head2 new

=head2 clear

=head2 set_errors

=head2 set_messages

=head2 get_errors

=head2 get_messages

=head2 has_errors

=head2 has_messages


