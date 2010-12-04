package Shaq::Web::Handler;
use strict;
use warnings;
use Shaq::Web::Action;
use Shaq::Web::Context;
use Plack::Request;
use Try::Tiny qw/try catch/;
use Carp ();

sub app {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
  
    my $router      = delete $args{router};
    my $controllers = delete $args{controllers};

    if ( ref $router ne 'Router::Simple' ) {
        Carp::croak('this is NOT the Router::Simple...');
    }
   
    Shaq::Web::Action->use_controllers(@{$controllers});
    
    return sub {
        my $env = shift;

        my $rule = $router->match($env) or return $class->handle_404;

        my $req = Plack::Request->new($env);

        my $context = Shaq::Web::Context->new(
            request => $req,
            response => $req->new_response(200),
            stash => {},
        );

        try {    
            Shaq::Web::Action->run($rule, $context);
        }
        catch {
            warn $_;
            return $class->handle_500;
        };
    
        return $context->response->finalize;
    }
}

sub handle_404 {
    my $class = shift;
    return [
        404, [ "Content-Type" => "text/plain", "Content-Length" => 13 ],
        ["404 Not Found"]
    ];
}

sub handle_500 {
    my $class = shift;
    return [
        500, [ "Content-Type" => "text/plain", "Content-Length" => 21 ],
        ["Internal Server Error"]
    ];
}

1;

