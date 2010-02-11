package Shaq::Unit::MT;
use strict;
use warnings;
use Text::MicroTemplate::Extended;
use Path::Class qw/dir file/;
use FindBin qw($Bin);
use Encode;
use URI::Escape;
use HTML::Entities;
 
sub new {
    my ( $class, $config ) = @_;
    
    my $tmpl_dir  = $config->{tmpl_dir} || _path_to('tmpl');
    my $wrapper   = $config->{wrapper}  || _path_to( $tmpl_dir, 'base.mt');
    my $tmpl_file = $config->{tmpl_file} || undef;

    my $mt = Text::MicroTemplate::Extended->new(
        tag_start    => '<%',
        tag_end      => '%>',
        line_start   => '%',
        wrapper_file => $wrapper,
        extension    => '',
        include_path => [$tmpl_dir],
        use_cache => 1,
        open_layer => ':utf8',
        macro => {
            raw_string => sub($) { Text::MicroTemplate::EncodedString->new($_[0]) },
            uri => sub($) {
                my $uri = Encode::is_utf8( $_[0] )
                    ? URI::Escape::uri_escape_utf8($_[0])
                    : URI::Escape::uri_escape($_[0]);
            },
            html_unescape => sub($) {
                my $decoded = HTML::Entities::decode_entities($_[0]);
                Text::MicroTemplate::EncodedString->new($decoded);
            },
        },
    );

    my $self = bless {
       _mt        => $mt,
       _stash     => '',
    } , $class;

    return $self;
}

sub tmpl_file { $_[0]->{_tmpl_file} }
sub stash     { $_[0]->{_stash} }
sub mt        { $_[0]->{_mt} }

sub render_file {
    my ($self, $template, $stash ) = @_;

    $template ||= $self->tmpl_file;
    $stash    ||= $self->stash;
    
    $self->mt->template_args( $stash );

    my $mt_encoded_stirng = $self->mt->render_file( $template ); 
    $mt_encoded_stirng->as_string;
}

sub _path_to {
    my (@path) = @_;
    my $path = dir( _home_dir(), @path );

    ### XXX: なにしたかったんだっけ？
    return $path if $path->is_dir;
    return file( _home_dir(), @path );
}

sub _home_dir { return dir( $Bin, '..' ) }


1;

__END__
 
=head1 NAME

Shaq::Unit::MT - Unit

=head1 METHODS

=head2 new

=head2 tmpl_file

=head2 stash

=head2 mt

=head2 render

=head1 SEE ALSO

=over 2

=item hhttp://github.com/typester/text-microtemplate-extended-perl

=item http://github.com/nekokak/p5-Kamui/blob/master/lib/Kamui/View/MT.pm
 
=back

