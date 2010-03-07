package Shaq::Model::Iterator;
use Mouse;

has 'position' => ( is => 'rw', default => sub { 0 } );
has 'load'    => ( is => 'rw' );
has '_stored' => ( is => 'rw', isa => 'ArrayRef[HashRef]' );

no Mouse;

sub set {
    my ( $self, $datas ) = @_;
    $self->_stored($datas);
}

sub iterator {
    my $self = shift;

    my $data = $self->_stored->[$self->position];
    
    return unless $data;

    $self->load( $data );

    ### XXX: ++できないんだっけ？
    my $position = $self->position + 1;
    $self->position($position);

    return $self;
}

sub reset { $_[0]->position(0); return $_[0]; }

sub next { $_[0]->iterator; }

sub first { $_[0]->reset->next; }

sub count { scalar @{ $_[0]->_stored }; }

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

Shaq::Model::Iterator

=head1 SYNOPSIS

テストをご覧ください

=head1 DESCRIPTION

一覧表示などでオブジェクトの個体を10個つくるのではなく、集合体オブジェクトを1個生成しておいて
内包しているデータから実際に使用するデータの位置を記録させておき、実行されるたびに
データをオブジェクト化させる

イメージはピストル。
引き金引かれるまではただの火薬の塊(_stored)。
トリガを引くたびにイテレートして次に発射される弾丸をセット(load)している

=head1 MANESURUNA

dataの妥当性をチェックする機能を実装すると単体オブジェクトを都度コンストラクション
するのとあんまり変わらないので全く意味がない気がしてきたという罠

せいぜい10個程度のオブジェクトを生成するコストに対して神経質になる必要はなかったという反省

=head1 SEE ALSO 

http://github.com/nekokak/p5-dbix-skinny/blob/master/lib/DBIx/Skinny/Iterator.pm
