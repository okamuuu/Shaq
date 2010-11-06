package Shaq::Web::Context;
use strict;
use warnings;
use Class::Accessor::Lite;
Class::Accessor::Lite->mk_accessors(qw/request response stash/);

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;

    bless {%args}, $class;
}

sub res { shift->response(@_); }

sub req { shift->request(@_); }

1;


