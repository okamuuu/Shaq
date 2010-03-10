package Shaq::Model::Tab;
use Mouse;
use MouseX::AttributeHelpers;

has 'categories' => (
    is        => 'rw',
    isa       => 'ArrayRef[HashRef]',
    default   => sub { [ { dir => 'home', name => 'HOME' } ] },
    metaclass => 'Collection::Array',
    provides => { push => 'add_category', },
    auto_deref => 1,
);

has 'base_path' => ( is => 'rw', default => sub { '/'} );
has 'current' => ( is => 'rw' ) ;

sub xhtml {
    my ($self) = @_;

    my $xhtml = "<!-- category[start] -->\n";
    $xhtml .= "<ul id=\"tab\">\n";

    for my $category ( $self->categories ) {
    
        my $dir   = $category->{dir};
        my $name  = $category->{name};
        my $current = $self->current;
         
        my $class = ( defined $current and $dir eq $current ) ? "$dir current" : $dir;
        my $base_path = $self->base_path;

        if ($dir eq 'home' ) {
            $xhtml .= qq{<li><a href="$base_path" class="$class">$name</a></li>\n};
        }
        else {
            $xhtml .= qq{<li><a href="$base_path$dir/" class="$class">$name</a></li>\n};
        }
    }

    $xhtml .= "</ul>\n";
    $xhtml .= "<!-- category[end] -->\n";
}

1;

__END__

=head1 NAME

Shaq::Model::Tab

=head1 METHODS

=head2 new

=head2 categories

=head2 base_url

=head2 current

=head2 xhtml

=cut


