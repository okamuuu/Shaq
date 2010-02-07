package Shaq::CMS;
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Shaq::CMS::Menu;
use Shaq::CMS::Category;
use Shaq::CMS::Site;

sub new {
    my ( $class, %arg ) = @_;
    
    my $doc_dir = $arg{doc_dir};
    my $parser  = $arg{parser};

    Carp::croak("$doc_dir is not 'Path::Class::Dir' ...")
      unless $doc_dir->isa('Path::Class::Dir');

    Carp::croak("$parser couldn't does 'parse' ...")
      unless $parser->can('parse');

    bless {
        _doc_dir => $doc_dir,
        _parser  => $parser,
    }, $class;

}

sub doc_dir { $_[0]->{_doc_dir} }
sub parser  { $_[0]->{_parser}  }

sub create_site {
    my ($self, $name ) = @_;
    Shaq::CMS::Site->new(name=> $name );
}

sub dir2menus {
    my ( $self, $dir ) = @_;

    Carp::croak("the param must be Path::Class::Dir.")
      unless $dir->isa('Path::Class::Dir');

    my @menus = map { $self->dir2menu( $_ ) } $dir->children;
    [@menus];
}

sub dir2menu {
    my ( $self, $dir ) = @_;

    Carp::croak("the param must be Path::Class::Dir.")
      unless $dir->isa('Path::Class::Dir');

    my @list = $dir->dir_list;
    my $dirname = $list[-1];
    
    $dirname =~ m/
                    ^
                    (\d+)
                    -
                    ([^-]*)   # 日本語OK
                    $
                /x
    ? Shaq::CMS::Menu->new( order=> $1, name => $2 )
    : undef;
}

sub dir2archives {
    my ( $self, $dir ) = @_;

    Carp::croak("the param must be Path::Class::Dir.")
      unless $dir->isa('Path::Class::Dir');

    my @archives =
      map  { $self->file2archive($_) } 
      grep { !$_->is_dir }  
      $dir->children;

    return [@archives];
}

sub file2archive {
    my ( $self, $file ) = @_;

    Carp::croak("the param must be Path::Class::File.")
      unless $file->isa('Path::Class::File');

    ### XXX: もっと上手く書けないものか
    $file->basename =~ m/^
                          \d+               # 並び順
                          -                 # ハイフン
                          (\w*)             # ファイル名、-は指定できない仕様
                          \.txt             # 拡張子
                          $
                       /x
    ? $self->parser->parse( basename => $1, text => scalar $file->slurp ) 
    : undef;
}

1;

