package Shaq::UI::Navigation::Tab;
use strict;
use warnings;

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
    Carp::croak("Please set categories ...") unless @categories;

    my $xhtml = "<!-- category[start] -->\n";
    $xhtml .= "<ul id=\"tab\">\n";

    for my $category ( @categories ) {
        
        my $dir   = $category->{dir};
        my $name  = $category->{name};
   
        my $class;
        if ( $dir eq $self->current ) { 
            $class = $dir . " current";
        }
        else {
            $class = $dir;
        }

        my $base_url = $self->base_url;

        if ($dir eq 'home' ) {
            $xhtml .= qq{<li><a href="$base_url/" class="$class">$name</a></li>\n};
        }
        else {
            $xhtml .= qq{<li><a href="$base_url/$dir/" class="$class">$name</a></li>\n};
        }
    }

    $xhtml .= "</ul>\n";
    $xhtml .= "<!-- category[end] -->\n";
}

1;

__END__

=head1 NAME

Shaq::UI::Navigation::Tab - UI 

=head1 METHODS

=head2 new

=head2 categories

=head2 base_url

=head2 current

=head2 xhtml

=cut


