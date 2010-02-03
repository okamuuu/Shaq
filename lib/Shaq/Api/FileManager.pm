package Shaq::Api::FileManager;
use strict;
use warnings;
use Path::Class qw/dir file/;

sub new { 
    my ( $class, %arg ) = @_;

    my $root = $arg{root};

    ### 例外処理
#    if ( not $root->isa('Path::Class') ) {
#        Carp::croak("root must be 'Path::Class' object ...");
#    }

    my $self = bless {
        _root    => $root,
    }, $class;

    return $self;
};

sub root { $_[0]->{_root} }

sub search_tail_dir {
    my ( $self, $regex ) = @_;

    my @dirs;
    for my $dir ( sort $self->root->children ) {

        ### ディレクトリでなく、ファイルの場合は次の処理へ
        next unless $dir->is_dir;

        ### ディレクトリの階層を配列化
        my @list = $dir->dir_list;
        
        ### 配列の最後が最下層のディレクトリ
        my $dirname = $list[-1];

        ### パターンが指定されている場合
        if ( $regex ) {
            next unless $dirname =~ m/$regex/;
#        next unless $dirname =~ m/^(\d+)-(.*)$/;
        }
        push @dirs, $dirname;
    }
    
    return [@dirs];
}

1;

=head1 NAME 

Shaq::Api::FileManager

=head1 METHODS

=head2 new



