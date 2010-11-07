package MyApp::Web::Controller::Root;
use strict;
use warnings;

sub auto {
    my ($class, $c) = @_;
    
    $c->res->body('this');  
}
sub index {
    my ($class, $c) = @_;
   
    my $body = $c->res->body . ' is'; 
    $c->res->body($body);  
}
sub end {
    my ($class, $c) = @_;

    my $body = $c->res->body . ' test.';
    $c->res->body($body);  
}

package main;
use strict;
use warnings;
use Test::Most;
use Plack::Test;
use Router::Simple;
use HTTP::Request::Common qw/GET/;

use_ok('Shaq::Web::Handler');

my $router = Router::Simple->new();
$router->connect(
    '/',
    {
        controller => 'MyApp::Web::Controller::Root',
        action     => 'index',
    }
);

my $app = Shaq::Web::Handler->app(
    router => $router,
    controllers => ['MyApp::Web::Controller::Root'],
);


test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->( GET "/" );
    is $res->content, "this is test.";
};

done_testing();

