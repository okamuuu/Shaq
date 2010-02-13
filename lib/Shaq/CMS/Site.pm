package Shaq::CMS::Site;
use Any::Moose;
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

__PACKAGE__->meta->make_immutable;

no Any::Moose;

1;

=head1 NAME

CMS::Lite::Site - framework class


