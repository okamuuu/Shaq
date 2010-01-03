package Shaq::Api::Config;
use strict;
use warnings;
use base 'Class::Singleton';
use Cwd;
use Path::Class::Dir;
use Path::Class::File;
use Config::Multi;

our $FILES;

=head1 NAME

Shaq::Api::Config - Simple Config Library

=head1 METHODS

=head2 _new_instance

=head2 files

=head2 home

=head2 path_to

=cut

sub _new_instance {
    my ( $class, %arg ) = @_;

    my $conf_dir  = $arg{conf_dir}  || 'conf';
    my $app_name  = $arg{app_name}  || 'myapp';
    my $extension = $arg{extension} || 'yml';

    my $cm = Config::Multi->new({
        dir => path_to( $conf_dir )->stringify,
        app_name    => $app_name,
        extension   => $extension,
    });

    my $config = $cm->load();
    $FILES = $cm->files;
    return $config;
}

sub files { return $FILES; }

sub home { Path::Class::Dir->new(  getcwd()  ); }

sub path_to {
    my ( @path ) = @_;
    my $path = Path::Class::Dir->new( &home , @path );

    if ( -d $path ) { return $path }
    else { return Path::Class::File->new( &home, @path )->stringify }
}

1;


