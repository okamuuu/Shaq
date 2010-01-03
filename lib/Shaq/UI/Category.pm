package Shaq::UI::Category;
use strict;
use warnings;

=head1 NAME

Shaq::UI::Category - UI 

=head1 METHODS

=head2 new

=head2 categories

=head2 base_url

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

sub categories {
    my ( $self, $categories ) = @_;
    $self->{_categories} = $categories if $categories; 
    $self->{_categories};
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

    for my $category ( @categories ) {
        my $class;
        if ( $category eq $self->current ) { 
            $class = $category . " current";
        }
        else {
            $class = $category;
        }

        my $upper = join( ' ', map { uc $_ } split( /(?<=[A-Za-z])_(?=[A-Za-z])|\b/, $category ) );

        if ($category eq 'home' ) {
            
            $xhtml .= qq{<li><a href="$base_url/" class="$class">$upper</a></li>\n};
        }
        else {
            $xhtml .= qq{<li><a href="$base_url/$category/" class="$class">$upper</a></li>\n};
        }
    }

    $xhtml .= "</ul>\n";
    $xhtml .= "<!-- category[end] -->\n";
}

1;

