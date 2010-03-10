package Shaq::CMS::Site;
use Mouse;
use MouseX::AttributeHelpers;

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has categories  => ( 
    metaclass   => 'Collection::Array',
    is => 'rw', 
    isa => 'ArrayRef[Shaq::CMS::Category]', 
    default => sub {[]},
    provides => {
        push => 'add_category',
    },
    auto_deref => 1,
);

no Mouse;

__PACKAGE__->meta->make_immutable;

=head1 NAME

Shaq::CMS::Site - CMS


