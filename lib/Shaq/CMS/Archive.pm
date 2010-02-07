package Shaq::CMS::Archive;
use Any::Moose;

has basename    => ( is => 'ro', isa => 'Str' );
has title       => ( is => 'ro', isa => 'Str' );
has keywords    => ( is => 'ro', isa => 'ArrayRef' );
has description => ( is => 'ro', isa => 'Maybe[Str]' );
has content     => ( is => 'ro', isa => 'Str' );

__PACKAGE__->meta->make_immutable;

no Any::Moose;

=head1 NAME

CMS::Lite::Archive - parseddata from text formatted Trac

=head1 DESCRIPTION

Shaq::CMSを構成する最小単位のデータ。

=head1 METHODS

=cut

1;
