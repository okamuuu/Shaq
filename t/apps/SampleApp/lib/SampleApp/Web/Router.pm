package SampleApp::Web::Router;
use strict;
use warnings;
use Router::Simple;

sub create {
    my $class = shift;

    my $router = Router::Simple->new();
    $router->connect(
        '/',
        {
            controller => 'Pinky::Web::Controller::Root',
            action     => 'index',
        }
    );
    $router->connect(
        '/debug/',
        {
            controller => 'Pinky::Web::Controller::Debug',
            action     => 'index',
        }
    );

    $router->connect(
        '/debug/test',
        {
            controller => 'Pinky::Web::Controller::Debug',
            action     => 'test',
        }
    );

    return $router;
}

1;

