package Shaq::UI::Pager;
use strict;
use warnings;

sub new {
    my ( $class ) = @_;

    my $self = bless {
        _displayable_block => 11,
        _extened => '',
    }, $class;
}

sub displayable_block { $_[0]->{_displayable_block} }
sub extended { $_[0]->{_extended} }
sub path { $_[0]->{_path} }

sub extend {
    my ( $self, $pager, $path ) = @_;

    if ( ref $pager ne 'Data::Page' ) {
        Carp::croak("Please set Data::Page ...");
    }

    $self->{_path} = $path;

    my $displayable_block = $self->displayable_block;

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
   
    $self->{_extended} = $pager;
    
    return $self;
}

sub xhtml {
    my ($self ) = @_;

    my $pager = $self->extended;
    my $path  = $self->path;

    my $xhtml = "<!-- pager[start] -->\n";
    if ( not $pager->{single_page} ) {
        $xhtml .= "<div class=\"pager\">\n";
        $xhtml .= "<ul>\n";
        if ( $pager->previous_page ) {
            $xhtml .=
                "<li class=\"prev\"><a href=\""
              . $path
              . "?page="
              . $pager->previous_page
              . "\">PREV</a></li>\n";
        }

        for my $page ( @{ $pager->{visible_pages} } ) {
            $xhtml .= "<li>";

            if ( $page == $pager->{current_page} ) {
                $xhtml .= "<span class=\"current\">$page</span>";
            }
            else {
                $xhtml .=
                    "<a href=\""
                  . $self->path
                  . "?page="
                  . $page
                  . "\">$page</a>";
            }

            $xhtml .= "</li>\n";
        }

        if ( $pager->next_page ) {
            $xhtml .=
                "<li class=\"next\"><a href=\""
              . $self->path
              . "?page="
              . $pager->next_page
              . "\">NEXT</a></li>\n";
        }

        $xhtml .= "</ul>\n";
        $xhtml .= "</div>\n";
    }
    $xhtml .= "<!-- pager[end] -->\n";
}

1;

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


