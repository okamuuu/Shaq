package Shaq::Model::Pager;
use Mouse;
use Data::Page;

has displayable_block => ( is => 'rw', default => sub { '11' } );
has extended          => ( is => 'rw', default => sub { 0 } );
has base_path => ( is => 'rw' );
has pager => (
    is      => 'rw',
    isa     => 'Data::Page',
    default => sub { Data::Page->new },
    handles => [
        qw/previous_page next_page total_entries entries_per_page current_page last_page/
    ]
);

has first_visible_page => ( is => 'rw' );
has last_visible_page  => ( is => 'rw' );
has visible_pages => ( is => 'rw', isa => 'ArrayRef', auto_deref => 1 );
has single_page => ( is => 'rw' );
has cache => ( is => 'rw', predicate => 'has_cache' );

no Mouse;

sub extend {
    my ( $self ) = @_;

    ### 同一ページに2か所Pagerを表示した場合
    ### この処理は一度しか行いたくない
    return $self->pager if $self->extended;

    ### 1番左側に表示されるページ数
    my $first_page =
      $self->current_page - int( ( $self->displayable_block - 1 ) / 2 );
    
    $first_page < 1
      ? $self->first_visible_page(1)
      : $self->first_visible_page($first_page);

    ### 1番右側に表示されるページ数
    my $last_page = 
        $self->current_page + int( $self->displayable_block / 2 );

    $self->last_page > $last_page
      ? $self->last_visible_page($last_page)
      : $self->last_visible_page($self->last_page);

    ### 表示されるページの配列
    $self->visible_pages( [$self->first_visible_page .. $self->last_visible_page] );

    ### 複数ページでない場合
    if ( $self->first_visible_page == $self->last_visible_page ) {
        $self->single_page(1);
    }
   
    $self->extended(1);
    
    return $self;
}

sub xhtml {
    my ($self ) = @_;
    
    return $self->cache if $self->has_cache;

    $self->extend unless $self->extended;

    my $xhtml = "<!-- pager[start] -->\n";
    if ( not $self->single_page ) {
        $xhtml .= "<div class=\"pager\">\n";
        $xhtml .= "<ul>\n";
        if ( $self->previous_page ) {
            $xhtml .=
                "<li class=\"prev\"><a href=\""
              . $self->base_path
              . "?page="
              . $self->previous_page
              . "\">PREV</a></li>\n";
        }

        for my $page ( $self->visible_pages ) {
            $xhtml .= "<li>";

            if ( $page == $self->current_page ) {
                $xhtml .= "<span class=\"current\">$page</span>";
            }
            else {
                $xhtml .=
                    "<a href=\""
                  . $self->base_path
                  . "?page="
                  . $page
                  . "\">$page</a>";
            }

            $xhtml .= "</li>\n";
        }

        if ( $self->next_page ) {
            $xhtml .=
                "<li class=\"next\"><a href=\""
              . $self->base_path
              . "?page="
              . $self->next_page
              . "\">NEXT</a></li>\n";
        }

        $xhtml .= "</ul>\n";
        $xhtml .= "</div>\n";
    }
    $xhtml .= "<!-- pager[end] -->\n";

    $self->cache($xhtml); ### XXX: リファレンス渡し問題ないならそうしたいが…
    return $xhtml;
}

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

Shaq::Api::Pager - pager class

=head1 METHODS

=head2 new

=head2 displayable_block

=head2 extended

=head2 path

=head2 extend

=head2 xhtml


