package Shaq::Web::Utils;
use strict;
use warnings;
use Carp;
use FindBin qw($Bin);
use Path::Class::File;
use Path::Class::Dir;


sub path_to {
    my (@path) = @_;
    my $path = Path::Class::Dir->new( home_dir(), @path );
 
    return $path if $path->is_dir;
    return Path::Class::File->new( home_dir(), @path );
}

sub home_dir { Path::Class::Dir->new( $Bin, '..' ); }

1;

