package Shaq::CMS::Category;
use Mouse;
use MouseX::AttributeHelpers;

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1
);

has dirname => ( is => 'ro', isa => 'Str', required => 1 );

has archives  => ( 
    metaclass => 'Collection::Array',
    is => 'ro', 
    isa => 'ArrayRef[Shaq::CMS::Archive]', 
    auto_deref => 1,
);

has menus   => ( 
    metaclass => 'Collection::Array',
    is => 'ro', 
    isa => 'ArrayRef[Shaq::CMS::Menu]', 
#    auto_deref => 1,
);


no Mouse;

__PACKAGE__->meta->make_immutable;

=head1 NAME

CMS::Lite::Category - Category has menus and archives


