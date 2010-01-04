package Shaq::UI::Layout::Header;
use strict;
use warnings;
use Carp;

=head1 NAME

Shaq::UI::Layout::Header - UI 

=head1 DESCRIPTION

開発中

=head1 METHODS

=head2 new

=head2 base_url

=head2 current

=head2 xhtml

=cut

sub new {
    my ($class) = @_;

    my $self = bless {
        _categories => [],
        _base_url => '',
        _current  => '',
    }, $class;

}

sub base_url {
    my ( $self, $base_url ) = @_;
    $self->{_base_url} = $base_url if $base_url; 
    $self->{_base_url};
}

sub current {
    my ( $self, $current ) = @_;
    $self->{_current} = $current if $current; 
    $self->{_current};
}

sub xhtml {
    my ($self) = @_;

    my @categories = @{ $self->categories };
    my $base_url   = $self->base_url;

    Carp::croak("Please set categories ...") unless @categories;

    my $xhtml = "<!-- category[start] -->\n";
    $xhtml .= "<ul id=\"nav\">\n";

    $xhtml .= "</ul>\n";
    $xhtml .= "<!-- category[end] -->\n";
}

sub base {
    my ($self, %arg) = @_;

    my $title       = $arg{title}       or croak("Please set title ...");
    my $keywords    = $arg{keywords}    or croak("Please set title ...");
    my $description = $arg{description} or croak("Please set description ...");
    my $body_id     = $arg{body_id}     or croak("Please set body_id ...");
    my $groups      = $arg{groups}      or croak("Please set groups ...");

1;

