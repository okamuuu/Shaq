package Shaq::Model::Thumbnail;
use strict;
use warnings;

sub new {
    my ( $class, %arg ) = @_;

    my $self = bless {
        _src    => $arg{src},
        _alt    => $arg{alt},
        _width  => $arg{width},
        _height => $arg{height},
    }, $class;
}

sub src    { $_[0]->{_src} }
sub alt    { $_[0]->{_alt} }
sub width  { $_[0]->{_width} }
sub height { $_[0]->{_height} }

sub xhtml {
    my ($self) = @_;

    my $src    = $self->src;
    my $alt    = $self->alt;
    my $width  = $self->width;
    my $height = $self->height;

    my $xhtml = qq{<img src="$src" alt="$alt" width="$width" height="$height" />};
}

sub to_json {
    my ($self) = @_;

    my $src    = $self->src;
    my $alt    = $self->alt;
    my $width  = $self->width;
    my $height = $self->height;

    return qq/{"src":"$src", "alt":"$alt", "width":"$width", "height":"$height"}/;
}

1;

__END__

=head1 NAME

Shaq::Model::Thumbnail - Model

=head1 METHODS

=head2 new

=head2 src

=head2 alt

=head2 width

=head2 height

=head2 xhtml


