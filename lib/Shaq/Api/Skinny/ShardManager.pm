package Shaq::Api::Skinny::ShardManager;
use strict;
use warnings;
use UNIVERSAL::require;
use Carp;
use Params::Validate qw/validate_pos/;

sub new {
    my ( $class, %arg ) = @_;

    my $manager_db      = $arg{manager_db};
    my $base_db_class   = $arg{base_db_class};
    my $base_datasource = $arg{base_datasource};

    my $self = bless {
        _manager_db      => $manager_db,
        _base_db_class   => $base_db_class,
        _base_datasource => $base_datasource,
    }, $class;
}

sub manager_db      { $_[0]->{_manager_db}      }
sub base_db_class   { $_[0]->{_base_db_class}   }
sub base_datasource { $_[0]->{_base_datasource} }

sub datasource_from {
    my ( $self, $node ) = @_;
    
    my $dsn = sprintf(
#        'dbi:mysql:%s_%s_%s;hostname=%s',
        'dbi:sqlite:%s_%s',
        $node->type, $node->number, # $node->host
    ); # eg. dbi:sqlite:db/uesr_01.db

    return {
        dsn => $dsn,
        username => '',
        password => '',
    };
}

sub handler_for {
    my $self = shift;

    my ( $type, $role, $type_key ) =
      validate_pos( @_, 1, { regex => qr/^(master|slave)$/ }, 1, );

    ### 現在のノード状況から最適なノード情報を掴んでいるレコードから
    ### それを取得する。
    my $row  = $self->setup_handler( $type, $role, $type_key );
    my $node = $self->master_db->single( 'node', { id => $row->node_id } );

    ### 取得したノード情報からDBへの接続情報を入手する。
    my $datasource = $self->datasource_from($node);

    ### 分割されたdatabaseを扱うDBクラスは共通
    ### なのでDBクラスは同一のものを使用しdsn
    $self->base_db_class->use or Carp::croak $@;
    my $db = $self->base_db_class->new($datasource);
    $db->do(q{SET NAMES utf8});
    $db;
}

sub setup_handler {
    my $self = shift;

    my ( $type, $role, $type_key ) =
      validate_pos( @_, 1, { regex => qr/^(master|slave)$/ }, 1, );

    ### マッチするレコードがある場合はsetup済み
    my $single_cond = { type => $type, role => $role, type_key => $type_key };
    my $row  = $self->manager_db->single( 'rows', $single_cond );
    
    return $row if $row;

    ### 使える全ノード取得
    ### ここid以外のカラム必要ない気が…
    my $search_cond = { type => $type, role => $role, status => 'ok' };
    my @node_ids = map { $_->id } $self->manager_db->search($search_cond);
    croak 'undefined node!!!' unless @node_ids;

    ### 分散してDBへの格納を行うため
    ### 各ノード毎での使用件数をマッピング。
    my %used_count_of = map { $_->node_id => $_->count } $self->manager_db->search_by_sql(
        q{
            SELECT node_id, count(node_id) AS count
            FROM rows
            WHERE type = ? 
            AND   role = ?
            GROUP BY node_id
        }, [$type, $role], 'rows'
    ); # %list = ( node_id => count, ... );

    ### 最も少ない件数のノードをセットする処理を行う
    my $min_node = {};
    for my $node_id (@node_ids) {

        my $used_count = $used_count_of{$node_id} || 0;
        my $min_count  = $min_node->{count}       || 0;

        ### 最も使用件数が少ないノードが見つかったら$min_nodeを差し替える
        if ( $min_count >= $used_count ) {
            $min_node = {
                count   => $used_count,
                node_id => $node_id,
            };
        }
    }

    ### 最適なノードに対して新しいhandlerとなるrowをセット
    my $new = $self->manager_db->insert('rows',
        {
            node_id  => $min_node->{node_id},
            type     => $type,
            role     => $role,
            type_key => $type_key,
        }
    );
}

1;

