package Shaq::Web;
use strict;
use warnings;
use Carp;
use Module::Find;
use UNIVERSAL::require;
use Path::Class;
use Shaq::Web::Utils;
use Shaq::Web::Context;
use Plack::Request;
use String::CamelCase qw/decamelize/;
use Term::ANSIColor qw(:constants);

our $VERSION = '0.02';
local $Term::ANSIColor::AUTORESET = 0;

sub new {
    my ( $class, %arg ) = @_;
   
    my $config = $arg{config};
    my $home_dir = $arg{home_dir} || Shaq::Web::Utils::home_dir();
    
    my $self = bless {
        _app    => $class,
        _config => $config,
        _home_dir => $home_dir,
    } , $class;
}

sub app      { $_[0]->{_app} }
sub config   { $_[0]->{_config} }
sub home_dir { $_[0]->{_home_dir} }

sub handler {
    my $self = shift;

    #----------------------------------------
    # common handle
    #----------------------------------------
    my $app = $self->app;
    my $proj = $app;
    $proj =~ s/::Web$//;

    my $api = "${proj}::Api";
    my $ui  = "${proj}::UI";

    $api->use or die "Cant' use api.. $@";
    $ui->use or die "Cant' use ui.. $@";
    
    my $api_instance = $api->new($self->config->{api});
    my $ui_instance  = $ui->new($self->config->{ui});
    
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
            ui       => $ui_instance,
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

1;

__END__

=head1 NAME

Shaq::Web - this is not WaF...

=head1 METHODS

=head2 new

=head2 app

=head2 config

=head2 home_dir

=head2 handler

=head2 handle_404

=head2 handle_500


