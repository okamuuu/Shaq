package Shaq::Unit::TX;
use strict;
use warnings;
use Text::Xslate ();
use File::Spec ();
use Cwd ();

our $BASE_TEMPLATE_DIR = File::Spec->catdir( Cwd::cwd, 'template');

my $CACHE;

sub create {
    my $class = shift;

    return $CACHE->{tx} if $CACHE->{tx};

    $CACHE->{tx} = Text::Xslate->new(
        path      => [ $BASE_TEMPLATE_DIR ],
        syntax    => 'TTerse',
        cache_dir => '/tmp/',
        function  => {
            html_unescape => sub {
                Text::Xslate::mark_raw(shift);
            },
        },
    );
}

sub render {
    my ($class, $path, $vars) = @_;

    return $class->create->render($path, $vars);
}

1;
 
