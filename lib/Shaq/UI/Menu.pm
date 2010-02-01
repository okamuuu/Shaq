package Shaq::UI::Menu;
use strict;
use warnings;
use Carp;

sub new {
    my ( $class, %param ) = @_;

    my $self = bless {
        _path  => $param{path}, 
        _ext   => $param{ext},
        _title => $param{title} || croak("title..."),
        _list  => $param{list}, # チェックが必要かも
    }, $class;
}

sub path  { $_[0]->{_path}  }
sub ext   { $_[0]->{_ext}   }
sub title { $_[0]->{_title} }
sub list  { $_[0]->{_list}  }

sub xhtml {
    my ($self) = @_;

    my $title = $self->title;

    my $xhtml = qq{<!-- menu[start] -->\n};
    $xhtml   .= qq{<div class="menu">\n};
    $xhtml   .= qq{    <h3>$title</h3>\n};
    $xhtml   .= qq{    <ul>\n};
    
    for my $menu ( @{ $self->list } ) {
        my $name = $menu->{name};
        my $href = $self->path . $menu->{id};
        if ( $self->ext ) { $href .= $self->ext } 
        $xhtml   .= qq{        <li><a href="$href">$name</a></li>\n};
    }

    $xhtml .= qq{    </ul>\n};
    $xhtml .= qq{</div>\n};
    $xhtml .= qq{<!-- menu[end] -->\n};
}

1;

__END__

=head1 NAME

Shaq::UI::Menu - UI 

=head1 DESCRIPTION

=head1 METHODS

=head2 new

=head2 path

=head2 ext

=head2 title

=head2 list

=head2 xhtml

=cut

