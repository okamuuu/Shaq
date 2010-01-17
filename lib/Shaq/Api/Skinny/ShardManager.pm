package Shaq::Api::Skinny::ShardManager;
use strict;
use warnings;
use Data::Dumper;
use UNIVERSAL::require;
use Shaq::Api::Skinny::Profiler;

sub new {
    my ( $class, $config ) = @_;

    my $master_db     = _db( $config->{master_db} );
    my $slave_db      = _db( $config->{slave_db} );
    my $manager_db    = _db( $config->{manager_db} );
    my $shard_base_db = _db( $config->{shard_base_db} );

    my $self = bless {
        _master_db     => $master_db,
        _slave_db      => $slave_db,
        _manager_db    => $manager_db,
        _shard_base_db => $shard_base_db,
    }, $class;
}

sub master_db     { $_[0]->{_master_db}     }
sub slave_db      { $_[0]->{_slave_db}      }
sub manager_db    { $_[0]->{_manager_db}    }
sub shard_base_db { $_[0]->{_shard_base_db} }

sub datasource_from {
    my ( $self, $node ) = @_;
    
    my $dsn = sprintf(
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
    my ($self, $type, $role, $type_key) = @_;
    
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
    my ($self, $type, $role, $type_key ) = @_;

    ### マッチするレコードがある場合はsetup済み
    my $single_cond = { type => $type, role => $role, type_key => $type_key };
    my $row  = $self->shard_manager_db->single( 'rows', $single_cond );
    
    return $row if $row;

    ### 使える全ノード取得
    ### ここid以外のカラム必要ない気が…
    my $search_cond = { type => $type, role => $role, status => 'ok' };
    my @node_ids = map { $_->id } $self->shard_manager_db->search($search_cond);
    Carp::croak 'undefined node!!!' unless @node_ids;

    ### 分散してDBへの格納を行うため
    ### 各ノード毎での使用件数をマッピング。
    my %used_count_of = map { $_->node_id => $_->count } $self->shard_manager_db->search_by_sql(
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
    my $new = $self->shard_manager_db->insert('rows',
        {
            node_id  => $min_node->{node_id},
            type     => $type,
            role     => $role,
            type_key => $type_key,
        }
    );
}

sub _db {
    my ( $config ) = @_;

    my $db_class = $config->{class};
    $db_class->use or Carp::croak $@; # mixinが無ければrequireでも可

    my ( $dsn, $username, $password ) = @{$config->{connect_info}};

    my $db = $db_class->new( { dsn=> $dsn, username => $username, password => $password } );

    ### 真となりうる値が格納されているとログモードになる
    $db->attribute->{profile} = $config->{log_mode};

    ### ログの出力先が指定されている場合はログファイルを生成する
    if ( $config->{query_log_path} ) {
        $db->{profiler} = Shaq::Api::Skinny::Profiler->new(
            { log_path => $config->{query_log_path} } );
    }
    
    $db;
}


1;

=head1 NAME

Shaq::Api::Skinny::ShardManager - ShardManager

=head1 METHODS

=head2 new 

=head2 manager_db 

=head2 base_db_class

=head2 base_datasource

=head2 datasource_from

=head2 handler_for

=head2 setup_handler

=head2 _db
