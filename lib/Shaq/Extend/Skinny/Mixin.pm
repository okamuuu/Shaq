package Shaq::Extend::Skinny::Mixin;
use strict;
use warnings;
use Shaq::Model::Pager;

sub register_method {
    {
        lookup            => \&lookup,
        listing           => \&listing,
        toggle_display_fg => \&toggle_display_fg,
    };
}

sub lookup {
    my ( $self, $cond ) = @_;
    return $self->unit->skinny->slave_db->single( 'authors', $cond );
}

### TODO: こいつはアプリ側のロジックだから移動
sub displayables { $_[0]->search( { display_fg => 1}, { limit => 10, page => 1} ); }

### TODO: 中身はDancePodなの変える
sub listing {
    my ( $self, $where, $attr ) = @_;

    my $limit  = $attr->{rows} || 10;
    my $page   = $attr->{page} || 1;
    my $offset = $limit * ( $page - 1 );

    my $rs = $self->resultset(
        {
            select => [
                qw/id rid username title location thumbnail created_at updated_at display_fg/
            ],
            from => [qw/authors/]
        }
    );

    $rs->add_where(%$where) if scalar %$where;
    $rs->limit($limit);
    $rs->offset($offset);
    $rs->order( { column => 'id', desc => 'DESC' }); #

    my $itr = $rs->retrieve('author'); # DancePod::DB::Row::Author. Not Authors table

    $rs = $self->resultset;
    $rs->add_select( "COUNT(id)" => 'count' );
    $rs->from( [qw/authors/] );
    $rs->add_where(%$where) if scalar %$where;

    my $count = $rs->retrieve('author')->first->count;
    my $pager = Shaq::Model::Pager->new; # TODO: 都度コンストラクトはちとコストが高い
    $pager->total_entries($count);
    $pager->entries_per_page($limit);
    $pager->current_page($page);

    return ( $itr, $pager );
}

sub toggle_display_fg {
    my ( $self, $table, $cond ) = @_;

    my $row = $self->single( $table, $cond );
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


