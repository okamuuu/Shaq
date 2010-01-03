package Shaq::Api::TT;
use strict;
use warnings;
use Carp;
use Encode;
use Template;
use Path::Class::File;
use Path::Class::Dir;
use FindBin qw($Bin);

sub new {
    my ( $class, %arg ) = @_;
    
    my $wrapper   = $arg{wrapper}  || 'layout.tt2';
    my $tmpl_dir  = $arg{tmpl_dir} || _path_to('tmpl');
    my $tmpl_file = $arg{tmpl_file} || '';
    
    my $tt = Template->new(
        WRAPPER  => $wrapper,
        ABSOLUTE => 1,
        RELATIVE => 1,
        ENCODING => 'utf-8', # read file encoded utf-8
        UNICODE  => 1,       # as UNICODE
        INCLUDE_PATH => [ $tmpl_dir ],
    );
    
    my $self = bless {
       _tt        => $tt,
       _tmpl_file => '',
       _stash     => '',
       _c         => '',
    } , $class;

    return $self;
}

sub tmpl_file { $_[0]->{_tmpl_file} }
sub stash     { $_[0]->{_stash} }
sub tt        { $_[0]->{_tt} }
sub c         { $_[0]->{_c} }

sub render {
    my ($self, %param) = @_;

    my $template = $param{tmpl_file} || $self->tmpl_file;
    my $stash    = $param{stash} || $self->stash;
    
    croak('Please set $param{tmpl_file} ...') unless $template;
    
    my $content;
    $self->tt->process( $template, $stash, \$content ) or die $@;

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
 
 
=head1 NAME

Shaq::Api::TT - The great new Shaq::Api::TT!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

    use Shaq::Api::TT;

    my $foo = Shaq::Api::TT->new();
    ...



=cut

1;
