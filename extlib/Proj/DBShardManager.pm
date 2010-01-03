package Proj::DBShardManager;
use strict;
use warnings;
use Proj::DB;

sub new {
    my ( $class, $config ) = @_;
    my $self = bless {
        _db => Proj::DB->new( $config ),
    }, $class;
    return $self;
}

sub db { $_[0]->{_db} }

sub datasource {
    my ( $self, $dsn ) = @_;

    my $datasource = {
        dsn      => $dsn,
        username => '',
        password => '',
    };
}

=head2 setup_handler_setting

db_node_mapに$user_nameに対応するレコードを登録する

=cut

sub setup_handler_setting {
    my ( $self, $user_name ) = @_;

    Carp::croak "Plase set 'user_name'... " unless $user_name;

    # db_node_mapにすでに登録されている場合はスルー
    return if $self->db->single( 'db_node_map', { type_key => $user_name } );

    warn '!!';

    # 使える全masterノード取得
    my @db_node_ids = map { $_->id } $self->{db}->search_by_sql(
        q{
            SELECT id
            FROM   db_node
            WHERE  type   = 'author'
            AND    role   = 'master'
            AND    status = 'ok'
        }, [], 'db_node'
    );

    Carp::croak 'undefined db_node!!!' unless @db_node_ids;

    # 既に使用されているノードを取得
    my %list = map { $_->db_node_id => $_->count } $self->{db}->search_by_sql(
        q{
            SELECT db_node_map.db_node_id, count(db_node_map.db_node_id) AS count
            FROM db_node, db_node_map
            WHERE db_node.id   = db_node_map.db_node_id
            AND   db_node.type = 'message'
            GROUP BY db_node_map.db_node_id
            ORDER BY count ASC
        }, [], 'db_node_map'
    );

    my $use_db_node = {};
    for my $db_node_id (@db_node_ids) {

        ### 何だろうね
        if ( defined $use_db_node->{count}
            and ( $use_db_node->{count} <= ( $list{$db_node_id} || 0 ) ) )
        {
            next;
        }

        $use_db_node = {
            count => $list{$db_node_id} || 0,
            db_node_id => $db_node_id,
        };
    }

    $self->{db}->insert(
        'db_node_map',
        {
            db_node_id => $use_db_node->{db_node_id},
            type_key   => $user_name,
        }
    );
}

sub handler_for {
    my ($self, $user_name) = @_;
    Carp::croak "Please set 'user_name' ..." unless $user_name;

    my $row = $self->db->search_by_sql(
        q{
            SELECT db_node.id, db_node.number, db_node.host, db_node.type
            FROM   db_node, db_node_map
            WHERE  db_node.id = db_node_map.db_node_id
            AND    db_node.type         = 'message'
            AND    db_node.role         = 'master'
            AND    db_node_map.type_key = ?
            LIMIT 1
        }, [$user_name], 'db_node'
    )->first;

    my $dsn;
    if ($row) {
        $dsn = $row->gen_dsn;
    } else {
        $dsn = $self->setup_handler_setting($user_name)->gen_dsn;
    }

    my $db = Proj::DB->new($self->datasource($dsn));
    # 必要であればset namesを打つ
#    $db->do(q{SET NAMES utf8});
#    $db;
}

1;
