package Shaq::CMS::Manager;
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Archive::Zip;
use DateTime;
use UNIVERSAL::require;
use Shaq::CMS::Site;
use Shaq::CMS::Category;
use Shaq::CMS::Menu;

sub new {
    my ( $class, $config ) = @_;

    ### XXX: $Binへの依存は自身が使う分には便利だが第三者がこのコードを見た時
    ### 「ん!?」となるので一瞬思考コストを奪ってしまう恐れがある
    my $name       = $config->{name};
    my $doc_dir    = $config->{doc_dir} || dir( $Bin, '..', 'doc' );
    my $root_dir   = $config->{root_dir} || dir( $Bin, '..', 'root' );
    my $backup_dir = $config->{backup_dir} || dir( $Bin, '..', 'backup' );
    my $parser     = $config->{parser};

    Carp::croak("Please set param 'name' ...") unless $name;

    for my $dir ( $doc_dir, $root_dir, $backup_dir ) {
        Carp::croak("$dir is not 'Path::Class::Dir' ...")
          unless $dir->isa('Path::Class::Dir');
    }

    my $parser_module = "Shaq::CMS::ArchiveParser::" . $parser;
    $parser_module->use or die $@;

    Carp::croak("$parser_module couldn't does 'parse' ...")
      unless $parser_module->can('parse');

    bless {
        _name       => $name,
        _doc_dir    => $doc_dir,
        _root_dir   => $root_dir,
        _backup_dir => $backup_dir,
        _parser     => $parser_module->new,
    }, $class;
}

sub name        { $_[0]->{_name}       }
sub doc_dir     { $_[0]->{_doc_dir}    }
sub root_dir    { $_[0]->{_root_dir}   }
sub backup_dir  { $_[0]->{_backup_dir} }
sub parser      { $_[0]->{_parser}     }

sub doc2site {
    my ($self) = @_;

    my @categories =
      map  { $self->dir2category($_) }
      sort { $a cmp $b } $self->doc_dir->children;

    my $site = Shaq::CMS::Site->new( name => $self->name, categories => [@categories] );
}

sub backup {
    my ($self) = @_;

    my $zip = Archive::Zip->new;
    my $dt = DateTime->now( time_zone => 'local' );

    my $filename =
      file( $self->backup_dir, "backup_" . $dt->ymd('') . ".zip" )->stringify;

    $zip->addTree( $self->doc_dir );
    $zip->writeToFileNamed($filename);
}
     
sub dir2category {
    my ( $self, $cat_dir ) = @_;

    my @dir_list = $cat_dir->dir_list;
    my $dirname  = $dir_list[-1];

    my ( @all_archives, @menus );
    for my $dir ( sort { $a cmp $b } $cat_dir->children ) {

        ### _から始まるディレクトリはここで無視される
        my $menu = $self->dir2menu($dir) or next;

        my @archives = $self->dir2archives($dir);

        ### 生成された記事を元にメニューを作る
        for my $archive (@archives) {
            $menu->add_list(
                { basename => $archive->basename, title => $archive->title } );
        }

        push @all_archives, @archives;
        push @menus,        $menu;
    }

    my $category = Shaq::CMS::Category->new(
        name     => $dirname, # FIXME: どうやって設定するか考える
        dirname  => $dirname,
        menus    => [@menus],
        archives => [@all_archives]
    );
}

sub dir2menu {
    my ( $self, $dir ) = @_;

    die("the param must be Path::Class::Dir.")
      unless $dir->isa('Path::Class::Dir');

#    my @list = $dir->dir_list;
#    my $dirname = $list[-1];
    my $dirname = $dir->dir_list(-1);
   
    ### 先頭にアンダースコアがあるディレクトリは下書きだよ
    return if $dirname =~ m/^_/; 
    
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

    die("the param must be Path::Class::Dir.")
      unless $dir->isa('Path::Class::Dir');

#    my @list = $dir->dir_list;
#    my $dirname = $list[-1];
    my $dirname = $dir->dir_list(-1);
 
    $dirname =~ m/
                    ^
                    (\d+)
                    -
                    ([^-]*)   # 日本語OK
                    $
                /x;
   
    grep { defined $_ } map { $self->file2archive($1, $_) } sort {"$a" cmp "$b"} $dir->children;
}

sub file2archive {
    my ( $self, $dir_num, $file ) = @_;

    Carp::croak("the param must be Path::Class::File.")
      unless $file->isa('Path::Class::File');

    $file->basename =~ m/
                          ^
                          \d+               # 並び順
                          -                 # ハイフン
                          (\w*)             # ファイル名、-は指定できない仕様
                          \.txt             # 拡張子
                          $
                       /x or return; ### matchしない場合は即座にリターン

    my $basename = ( $1 eq 'index' ) ? 'index' : $dir_num . "-" . $1;
    $self->parser->parse( basename => $basename, text => scalar $file->slurp ) or undef;
}

1;

