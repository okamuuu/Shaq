package Shaq::Model::Bread;
use Mouse;
use MouseX::AttributeHelpers;
use Path::Class qw/dir file/;

has 'base_url' => ( is => 'ro', default => sub { '/' } );
has 'breads' => (
    is        => 'rw',
    isa       => 'ArrayRef[HashRef]',
    default   => sub { [ { dir => '/', name => 'home' } ] },
    metaclass => 'Collection::Array',
    provides => { push => 'add', },
);

no Mouse;

sub xhtml {
    my ($self) = @_;

    Carp::croak("Please set base_url ...") unless $self->base_url;

    my $path = $self->base_url;

    my $xhtml = qq{<!-- bread[start] -->\n};
    $xhtml .= qq{<p id="bread">\n};

    my $count  = 0;
    my @breads = @{ $self->breads };
    for my $bread (@breads) {
        my $dir  = $bread->{dir};
        my $name = $bread->{name};

        # 特にPath::Classで処理する必要は無い。
        $path = dir( $path, $dir )->stringify;
        if ( $#breads != $count ) {
            $xhtml .= qq{<a href="$path">$name</a> &gt;\n};
        }
        else {
            $xhtml .= qq{$name\n};
        }
        $count++;
    }

    $xhtml .= qq{</p>\n};
    $xhtml .= qq{<!-- bread[end] -->\n};
}

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

Shaq::Model::Bread - Bread Model

=head1 METHODS

=head2 xhtml

=cut

