package Shaq::CMS::Archive;
use strict;
use warnings;

sub new {
    my ( $class, %arg ) = @_;

    bless {
        _basename    => $arg{basename},
        _title       => $arg{title},
        _keywords    => $arg{keywords},
        _description => $arg{description},
        _content     => $arg{content},
    }, $class;
}

sub basename    { $_[0]->{_basename} }
sub title       { $_[0]->{_title} }
sub keywords    { $_[0]->{_keywords} }
sub description { $_[0]->{_description} }
sub content     { $_[0]->{_content} }

1;

=head1 NAME

CMS::Lite::Archive - parseddata from text formatted Trac

=head1 DESCRIPTION

Shaq::CMSを構成する最小単位のデータ。

=head1 METHODS

=head2 new

=head2 basename

=head2 title

=head2 keywords

=head2 description

=head2 content
