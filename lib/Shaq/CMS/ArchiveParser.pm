package Shaq::CMS::ArchiveParser;
use Any::Moose;

has parser => ( 
    is => 'rw',
    does => 'Shaq::CMS::ArchiveParser::Parser',
    required => 1,
    handles => [qw/parse/],
);

__PACKAGE__->meta->make_immutable;

no Any::Moose;

=head1 NAME

Shaq::CMS::ArchiveParser - Parser

=head1 DESCRIPTION

CMS::Lite::ArchiveParser::Parserの役割を持つParserを格納
このメソッドのpaserメソッドを呼び出して使用。

=head1 METHODS

=cut

1;

