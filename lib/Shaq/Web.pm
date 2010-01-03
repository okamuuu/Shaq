package Shaq::Web;
use Carp;
use Mouse;
use Module::Find;
use Path::Class;
use URI;
use Shaq::Web::Utils;
use Shaq::Web::Context;
use Plack::Request;
use String::CamelCase qw/decamelize/;
use Term::ANSIColor qw(:constants);
use UNIVERSAL::require;

use Data::Dumper;

our $VERSION = '0.02';
local $Term::ANSIColor::AUTORESET = 0;

has 'app'      => ( is => 'ro', isa => 'Str', required => 1 );
has 'config'   => ( is => 'ro', predicate => 'has_config' );
has 'plugins'  => ( is => 'ro', isa => 'ArrayRef' );
has 'home_dir' => ( is => 'ro', default => sub { Shaq::Web::Utils::home_dir(); } );
has 'uri'  => ( is => 'ro', isa => 'URI' );

no Mouse; # no more suggar

sub BUILDARGS {
    my ( $self, %arg ) = @_;
    $self->SUPER::BUILDARGS(
        app     => $self,
        config  => $arg{config},
    );
}

sub handler {
    my $self = shift;

    #----------------------------------------
    # common handle
    #----------------------------------------
    ### construction api
    my $app = $self->app;
    my $api = "${app}::Api";
    $api =~ s/Web::Api/Api/; # 後で考える
   
    $api->use or die "Cant' use $api..";

    my $api_instance = $api->new($self->config);
    
    ### prepare search and use controllers
    my @controllers = useall "${app}::Controller";
   
    ### find Dispatcher Class and require it, or die.
    my $dispatcher = "${app}::Dispatcher";
    $dispatcher->require or die "can't find dispatcher : $@";
    
    #----------------------------------------
    # Plack::Server::$IMPL each run this anonymous function after request
    # so you might not write common handle after here.
    #----------------------------------------
    return sub {
        my $env = shift;
    
        ### get request and set default response 404
        my $req = Plack::Request->new($env);
        my $res = $req->new_response(404);

        ### targetting controller and method
        my $rule = $dispatcher->match($req)
          or return $self->handle_404("couldn't found match rule...");

        my $root       = $app . "::" . "Controller" . "::" . "Root";
        my $controller = $app . "::" . "Controller" . "::" . $rule->{controller};
        my $method     = $rule->{action};

        ### set context
        my $context = Shaq::Web::Context->new(
            app      => $self->app,
            home_dir => $self->home_dir,
            request  => $req,
            response => $res,
            api      => $api_instance,
            stash    => {},
            config   => $self->config,
        );

        ### implement controller method
        eval {
            no strict 'refs';
            "${root}\::auto"->( $context,            $rule->{args} );
            "${controller}\::auto"->( $context,      $rule->{args} );
            "${controller}\::${method}"->( $context, $rule->{args} );
            "${controller}\::end"->( $context,       $rule->{args} );
            "${root}\::end"->( $context,             $rule->{args} );
        };

        ### PSGI spcify response must be <code-ref>
        ### return response ( code-ref ), or return 505
        if ( $@ ) {
            warn $@;
            return $self->handle_500;
        }
        else {
            return $context->response->finalize;
        }

    }
}

sub handle_404 {
    my ( $self, $warnings ) = @_;
    warn $warnings;
    return [
        404, [ "Content-Type" => "text/plain", "Content-Length" => 13 ],
        ["404 Not Found"]
    ];
}
 
sub handle_500 {
    my ( $self, $warnings ) = @_;
    warn $warnings;
    return [
        500, [ "Content-Type" => "text/plain", "Content-Length" => 21 ],
        ["Internal Server Error"]
    ];
}

__PACKAGE__->meta->make_immutable;


=head1 NAME

Shaq - The great new Shaq!

=head1 SYNOPSIS

    use Shaq;

    my $foo = Shaq->new();
    ...

=head1 METHODS

=head2 method_name

=head1 AUTHOR

okamura, C<< <okamura at example.com> >>

=cut

1; # End of Shaq

