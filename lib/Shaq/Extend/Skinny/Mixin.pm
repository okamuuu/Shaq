package Shaq::Extend::Skinny::Mixin;
use strict;
use warnings;
use Data::Page;

sub register_method {
    {
        toggle_display_fg => \&toggle_display_fg,
    };
}

sub toggle_display_fg {
    my ( $self, $table, $rid ) = @_;

    my $row = $self->search( $table, { rid => $rid } )->first;
    my $fg = $row->display_fg ? 0 : 1;
    $row->update( { display_fg => $fg } );
}

1;

=head1 NAME

Shaq::Extend::Skinny::Mixin - Extend Skinny module

=head1 METHODS

=head2 register_method

=head2 toggle_display_fg

=cut


