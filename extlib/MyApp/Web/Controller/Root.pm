package MyApp::Web::Controller::Root;
use strict;
use warnings;

sub auto {
    my ( $c, $args ) = @_;
    $c->stash->{lang} = 'ja';
#    $c->stash->{current_view_instance} = '';
}

sub redirect { }

sub error { }

sub end {
    my ( $c, $args ) = @_;

    
=pod if you need to use Template-Toolkit api...

    if ( $c->response->status == 302 ) { return; }    # because redirect

    my $template = $c->stash->{template} or croak 'set template..';
    $c->stash->{c} = $c; 

    my $body;
    if ( $c->stash->{current_view_instance} eq 'no_wrap' ) {
        $body = $c->api->tt_nowrap->render(
            tmpl_file => $template,
            stash     => $c->stash
        );

    }
    else {
        $body =
          $c->api->tt->render( tmpl_file => $template, stash => $c->stash );
    }
    $c->response->status(200);
    $c->response->content_type('text/html');
    $c->response->body($body);

=cut

}

1;

