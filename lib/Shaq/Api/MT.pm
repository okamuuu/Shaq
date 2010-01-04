package Shaq::Api::MT;
use strict;
use warnings;
use Carp;
use Encode; # 5.8以降ってどうするんだっけ
use Text::MicroTemplate::Extended;
use Path::Class::File;
use Path::Class::Dir;
use FindBin qw($Bin);

sub new {
    my ( $class, $config ) = @_;
    
    my $wrapper   = $config->{wrapper}  || 'base';
    my $tmpl_dir  = $config->{tmpl_dir} || _path_to('tmpl');
    my $tmpl_file = $config->{tmpl_file} || '';

    my $mt = Text::MicroTemplate::Extended->new(
        tag_start    => '<%',
        tag_end      => '%>',
        line_start   => '%',
        wrapper_file => $wrapper,
        extension    => '.mt',
        include_path => [$tmpl_dir],
        escape_func  => undef,
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

sub render {
    my ($self, $template, $stash ) = @_;

    $template ||= $self->tmpl_file;
    $stash    ||= $self->stash;
    
    $self->mt->template_args( $stash );
    my $content = $self->mt->render( $template );

    ### フラグがあればencode 
    if ( utf8::is_utf8($content) ) {
        $content = encode('utf-8', $content);
    }

    return $content;
}

sub _path_to {
    my (@path) = @_;
    my $path = Path::Class::Dir->new( _home_dir(), @path );

    return $path if $path->is_dir;
    return Path::Class::File->new( _home_dir(), @path );
}

sub _home_dir { return Path::Class::Dir->new( $Bin, '..' ); }


1;

__END__
 
=head1 NAME

Shaq::Api::MT - Api

=head1 METHODS

=head2 new

=head2 tmpl_file

=head2 stash

=head2 mt

=head2 render
 
