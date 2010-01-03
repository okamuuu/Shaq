package Shaq::Api::DBIC::Pager;
use strict;
use warnings;

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

sub pager {
    my ( $self, $pager, $displayable_block ) = @_;

    ### 一度に表示させるブロック。指定が無ければ11
    $displayable_block ||=  11;

    ### 1番左側に表示されるページ数
    $pager->{first_visible_page} =
      $pager->current_page - int( ( $displayable_block - 1 ) / 2 );
    $pager->{first_visible_page} = 1 if $pager->{first_visible_page} < 1;

    ### 1番右側に表示されるページ数
    $pager->{last_visible_page} =
      $pager->current_page + int( $displayable_block / 2 );
    $pager->{last_visible_page} = $pager->last_page
      if $pager->{last_visible_page} > $pager->last_page;

    ### 表示されるページの配列
    $pager->{visible_pages} =
      [ $pager->{first_visible_page} .. $pager->{last_visible_page} ];

    ### 複数ページでない場合
    if ( $pager->{first_visible_page} == $pager->{last_visible_page} ) {
        $pager->{single_page} = 1;
    }

    ### 受け取った$pagerに上記の情報を加えてから返す
    return $pager
}

