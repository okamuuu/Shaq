package SampleApp::Web;
use strict;
use warnings;
use Shaq::Web::Handler;
use SampleApp::Web::Router;

sub app {
    my $class = shift;

    my $router = SampleApp::Web::Router->create;  
    my @controllers = qw/
        SampleApp::Web::Controller::Root
        SampleApp::Web::Controller::Debug
    /;

    Shaq::Web::Handler->app(
        router => $router,
        controllers => [@controllers],
    );
}

1;

