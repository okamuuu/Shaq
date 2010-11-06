package Shaq::Web::Action;
use strict;
use warnings;
use UNIVERSAL::require;

my $ROOT_CLASS;

sub use_controllers {
    my ( $class, @controllers ) = @_;

    for my $controller (@controllers) {

        if ( $controller =~ m/Root$/ ) {
            $ROOT_CLASS = $controller;
        }

        $controller->use;
    }

    Carp::croak("NotFound ROOT_CLASS...") unless $ROOT_CLASS;
}

sub run {
    my ( $class, $rule, $context ) = @_;

    Carp::croak(
        "NotFound ROOT_CLASS. You might not implement 'use_controllers' ...")
      unless $ROOT_CLASS;

    my $controller = $rule->{'controller'} or die('arienai');
    my $action     = $rule->{'action'}     or die('arienai');

    if ( $controller eq $ROOT_CLASS ) {

        $controller->auto($context)
          if $controller->can('auto');

        $controller->$action($context);

        $controller->end($context)
          if $controller->can('end');

    }
    else {
        $ROOT_CLASS->auto($context)
          if $ROOT_CLASS->can('auto');

        $controller->auto($context)
          if $controller->can('auto');

        $controller->$action($context);

        $controller->end($context)
          if $controller->can('end');

        $ROOT_CLASS->end($context)
          if $ROOT_CLASS->can('end');
    }
}

1;

