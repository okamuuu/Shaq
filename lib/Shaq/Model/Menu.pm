package Shaq::Model::Menu;
use strict;
use warnings;
use Carp;

sub new {
    my ( $class, %param ) = @_;

    my $self = bless {
        _path  => $param{path}, 
        _ext   => $param{ext},
        _name  => $param{name} || croak("title..."),
        _list  => $param{list}, # チェックが必要かも
    }, $class;
}

sub path  { $_[0]->{_path}  }
sub ext   { $_[0]->{_ext}   }
sub name  { $_[0]->{_name}  }
sub list  { $_[0]->{_list}  }

sub xhtml {
    my ($self) = @_;

    my $name = $self->name;

    my $xhtml = qq{<!-- menu[start] -->\n};
    $xhtml   .= qq{<div class="menu">\n};
    $xhtml   .= qq{    <h3>$name</h3>\n};
    $xhtml   .= qq{    <ul>\n};
    
    for my $menu ( @{ $self->list } ) {
        my $title = $menu->{title};
        my $href = $self->path . $menu->{id};
        if ( $self->ext ) { $href .= $self->ext } 
        $xhtml   .= qq{        <li><a href="$href">$title</a></li>\n};
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

