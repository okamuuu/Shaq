package MyApp::Web::Controller::Home;
use strict;
use warnings;

sub auto {
    my ( $c, $args ) = @_;
    $c->stash->{nav} = 'home';
}

sub index {
    my ( $c, $args ) = @_;

    $c->response->status(200);
    $c->response->content_type('text/html');
    $c->response->body( 'hello, world' );
}

sub end { }

1;
