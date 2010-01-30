package Shaq::UI::Head;
use strict;
use warnings;
use Carp;
use Path::Class qw/dir file/;

sub new {
    my ( $class, %param ) = @_;

    my $self = bless {
        _title => $param{title} || croak("title..."),
        _keywords => $param{keywords}
          || croak("keywords..."),
        _description => $param{description}
          || croak("description..."),
        _import_css_path => $param{css_path}       || '/common/css/import.css',
        _print_css_path  => $param{print_css_path} || '/common/css/print.css',
    }, $class;
}

sub _title           { $_[0]->{_title} }
sub _keywords        { $_[0]->{_keywords} }
sub _description     { $_[0]->{_description} }
sub _import_css_path { $_[0]->{_import_css_path} }
sub _print_css_path  { $_[0]->{_print_css_path} }

### javascriptを追加したりする場合のメソッドがあったほうが良いかも。
sub extra_text {}

sub xhtml {
    my ($self) = @_;

    my $title        = $self->_title;
    my $keywords_str = join ', ', @{ $self->_keywords };
    my $description  = $self->_description;

    my $import_css_path = $self->_import_css_path;
    my $print_css_path  = $self->_print_css_path;

    my $xhtml = qq{<head>\n};
    $xhtml   .= qq{    <meta http-equiv="content-type" content="text/html; charset=utf8" />\n};
    $xhtml   .= qq{    <title>$title</title>\n};
    $xhtml   .= qq{    <meta name="keywords" content="$keywords_str" />\n};
    $xhtml   .= qq{    <meta name="description" content="$description" />\n};
    $xhtml   .= qq{    <meta name="robots" content="all" />\n};
    $xhtml   .= qq{    <link rel="stylesheet" type="text/css" media="screen, projection, tv" href="$import_css_path" />\n};
    $xhtml   .= qq{    <link rel="stylesheet" type="text/css" media="print" href="$print_css_path" />\n};
    $xhtml   .= qq{</head>\n};
}

1;

__END__

=head1 NAME

Shaq::UI::Head - UI 

=head1 DESCRIPTION

重視しているのはkeywordsがぬけていたり、print.cssなどを考慮しないで
XHTMLを記述しがちな自分への警告を行いたい。そんな用途を満たすモジュール、
のはずです。<head>～</head>はページによっては異なる場合がある為使える
ケースを限定するか、機能を拡張するか、自分に合わせて実装します。

=head1 METHODS

=head2 new

=head2 xhtml

TODO: JavaScriptとの歩み方を考える必要がある

=cut


