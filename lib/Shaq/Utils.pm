package Shaq::Utils;
use strict;
use warnings;
use Cwd;
use Path::Class::File;
use Path::Class::Dir;

=head1 NAME 

Shaq::Utils - util class

=head1 METHODS

=head2 path_to

=head2 home_dir

=cut

sub path_to {
    my (@path) = @_;
    my $path = Path::Class::Dir->new( home_dir(), @path );
 
    return $path if $path->is_dir;
    return Path::Class::File->new( home_dir(), @path );
}

sub home_dir { Path::Class::Dir->new( getcwd )->stringify; }

sub camelize {
    my $s = shift;
    join( '', map { ucfirst $_ } split( /(?<=[A-Za-z])_(?=[A-Za-z])|\b/, $s ) );
}

sub upper {
    my $s = shift;
    join( ' ', map { uc $_ } split( /(?<=[A-Za-z])_(?=[A-Za-z])|\b/, $s ) );
}


1;

