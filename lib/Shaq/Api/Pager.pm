package Shaq::Api::Pager;
use strict;
use warnings;
use base qw/Data::Page/;

=head1 NAME

Shaq::Api::Pager - pager class

=head1 METHODS

=head2 extend

=head2 base_url

=head2 xhtml

=cut

sub extend {
    my ( $self, $displayable_block ) = @_;

    ### 一度に表示させるブロック。指定が無ければ11
    $displayable_block ||= 11;

    ### 1番左側に表示されるページ数
    $self->{first_visible_page} =
      $self->current_page - int( ( $displayable_block - 1 ) / 2 );
    $self->{first_visible_page} = 1 if $self->{first_visible_page} < 1;

    ### 1番右側に表示されるページ数
    $self->{last_visible_page} =
      $self->current_page + int( $displayable_block / 2 );
    $self->{last_visible_page} = $self->last_page
      if $self->{last_visible_page} > $self->last_page;

    ### 表示されるページの配列
    $self->{visible_pages} =
      [ $self->{first_visible_page} .. $self->{last_visible_page} ];

    ### 複数ページでない場合
    if ( $self->{first_visible_page} == $self->{last_visible_page} ) {
        $self->{single_page} = 1;
    }
    
    return $self;
}

sub base_url {
    my ( $self, $base_url ) = @_;
    $self->{_base_url} = $base_url if $base_url; 
    $self->{_base_url};
}

sub xhtml {
    my ($self) = @_;

    Carp::croak("Please set base_url ...") unless $self->base_url;

    my $xhtml = "<!-- pager[start] -->\n";
    if ( not $self->{single_page} ) {
        $xhtml .= "<div class=\"pager\">\n";
        $xhtml .= "<ul>\n";
        if ( $self->previous_page ) {
            $xhtml .=
                "<li class=\"prev\"><a href=\""
              . $self->base_url
              . "?page="
              . $self->previous_page
              . "\">PREV</a></li>\n";
        }

        for my $page ( @{ $self->{visible_pages} } ) {
            $xhtml .= "<li>";

            if ( $page == $self->{current_page} ) {
                $xhtml .= "<span class=\"current\">$page</span>";
            }
            else {
                $xhtml .=
                    "<a href=\""
                  . $self->base_url
                  . "?page="
                  . $page
                  . "\">$page</a>";
            }

            $xhtml .= "</li>\n";
        }

        if ( $self->next_page ) {
            $xhtml .=
                "<li class=\"next\"><a href=\""
              . $self->base_url
              . "?page="
              . $self->next_page
              . "\">NEXT</a></li>\n";
        }

        $xhtml .= "</ul>\n";
        $xhtml .= "</div>\n";
    }
    $xhtml .= "<!-- pager[end] -->\n";
}

1;

