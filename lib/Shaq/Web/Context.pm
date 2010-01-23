package Shaq::Web::Context;
use Mouse;
use DateTimeX::Web;
use URI::QueryParam;
use String::CamelCase qw/decamelize/;

has 'app'      => ( is => 'ro', isa => 'Str' );
has 'home_dir' => ( is => 'ro', isa => 'Path::Class::Dir' );
has 'request'  => ( is => 'ro', isa => 'Plack::Request' );
has 'response' => ( is => 'ro', isa => 'Plack::Response' );
has 'api'      => ( is => 'ro');
has 'ui'       => ( is => 'ro');
has 'dtx'      => ( is => 'ro');
has 'stash'    => ( is => 'rw', isa => 'HashRef' );
has 'config'   => ( is => 'ro', isa => 'HashRef' );

no Mouse;

__PACKAGE__->meta->make_immutable;

sub res { shift->response(@_); }
sub req { shift->request(@_); }

sub uri_for {
    my ( $self, $path ) = @_;

    ### いくつか問題を発見したが、自分のアプリに影響しないので無視
    my $base = $self->req->base; 
    $base =~ s{/$}{}gmx;

    ### 絶対パスの場合はbaseを活用
    if ( $path =~ m{^/} ) {
        $base =~ s{/$}{}gmx;
        return $base . $path; 
    }
    else {
        my $path = $self->req->path;
        return $base . "/" . $path;
    }
}

### Catalystと互換性を持たせたいから$c->req->uri_withとしたい...
### 日本語のUTF8問題は無視して簡易実装Templateで[% c.uri_with(a=>1) %]とすると
### 引数がHashRefに変換されるので注意
sub uri_with {
    my ( $self, $param_ref ) = @_;

    ### いくつか問題を発見したが、自分のアプリに影響しないので無視
    my $base = $self->req->base; 
    $base =~ s{/$}{}gmx;
    my $path = $self->req->path;

    my $param_str = '?';
    for my $key ( keys %{$param_ref} ) {
         $param_str = $param_str . $key . "=" . $param_ref->{$key};
    }

    return $base . $path . $param_str;

}

### Text::MicroTemplate::Plugin::XMLEscapeとかあればいいな
### ぬぅ、そもそもTest::MicroTemplateは自動的にエスケープするのか…
sub escape {
    my ( $self, $text ) = @_;
    $text =~ s/&/&amp;/go;
    $text =~ s/</&lt;/go;
    $text =~ s/>/&gt;/go;
    $text =~ s/'/&apos;/go;
    $text =~ s/"/&quot;/go;
    return $text;
}

sub redirect {
    my ( $self, $location ) = @_;
    $self->response->redirect($location);
}

1;
 
__END__

=head1 NAME

haq::Web::Context - context

=head1 METHODS

=head2 res

=head2 req

=head2 uri_for

=head2 uri_with

=head2 escape

=head2 redirect
