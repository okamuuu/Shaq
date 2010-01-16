package Shaq::DB::Mixin::Extend;
use strict;
use warnings;
use Carp;
use Data::Page;

=head1 NAME

Shaq::DB::Mixin::Extend - My personal library

=head1 METHODS

=head2 register_method

=head2 listing

=head2 lately

=head2 toggle_display_fg

=cut

sub register_method {
    {
        listing           => \&listing,
        lately            => \&lately,
        toggle_display_fg => \&toggle_display_fg,
    };
}

sub listing {
    my ( $self, $table, $cond, $attr ) = @_;

    $attr->{page} ||= 1;
    $attr->{rows} ||= 10;
    $attr->{order_by} ||= { created_at => 'DESC' };

    ### 条件式にlimit, offsetを追加
    ### このDBICとのインターフェースの違いはどうしようか
    ### DBIx::Mocoを使ってみたりしたら決めよう
    my $page     = $attr->{page};
    my $limit    = $attr->{rows};
    my $offset   = $limit*( $page - 1);

    $attr->{limit}  = $limit;
    $attr->{offset} = $offset;

    my @rows  = $self->search( $table, $cond, $attr )->all;
    my $count = $self->count(  $table, 'id', $cond );

    my $pager = Data::Page->new( $count, $limit, $page );

    return ( [@rows], $pager );
}

sub lately {
    my ($self, $table, $cond, $attr ) = @_;

    $cond->{display_fg} ||= 1;
    $attr->{limit}      ||= 5;
    $attr->{order_by}   ||= { created_at => 'DESC' };

    my @rows  = $self->search( $table, $cond, $attr )->all;

    return [@rows];
}

sub toggle_display_fg {
    my ( $self, $table, $rid ) = @_;

    my $row = $self->search( $table, { rid => $rid } )->first;
    my $fg = $row->display_fg ? 0 : 1;
    $row->update( { display_fg => $fg } );
}

1;

