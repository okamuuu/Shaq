package Shaq::Model::Thumbnail;
use Mouse;

has src => ( is => 'rw' );
has alt => ( is => 'rw' );
has width => ( is => 'rw' );
has height => ( is => 'rw' );

no Mouse;

sub BUILDARGS {
    my ( $self, $args ) = @_;
    return $args;
}

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

__PACKAGE__->meta->make_immutable;

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


