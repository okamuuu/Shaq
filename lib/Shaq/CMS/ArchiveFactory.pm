package Shaq::CMS::ArchiveFactory;
use strict;
use warnings;
use UNIVERSAL::require;
use FindBin qw($Bin);
use Path::Class qw/dir file/;

sub new {
    my ( $class, %arg ) = @_;

    my $parser  = $arg{parser};

    Carp::croak("$parser couldn't does 'parse' ...")
      unless $parser->can('parse');

    bless {
        _parser  => $parser->new,
    }, $class;

}

sub parser  { $_[0]->{_parser} }

sub file2archive {
    my ( $self, $file ) = @_;

    Carp::croak("the param must be Path::Class::File.")
      unless $file->isa('Path::Class::File');

    my $is_match = $file->basename =~ m/^
                          \d+   # 並び順をここで指定してある
                          -     # ハイフン区切り
                          (\w*) # ファイル名、-は指定できない仕様
                          \.txt # 拡張子は.txt
                          $
                       /x;

    ### scalarで明示しないと最初の1行目しか渡せない模様
    $is_match ? $self->parser->parse( basename => $1, text => scalar $file->slurp ) : undef;
}

1;

