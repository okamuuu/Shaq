#!/usr/bin/perl
use strict;
use warnings;
use Test::Base;
plan tests => 1 * blocks;

use Shaq::Unit::Config;

filters {
    input    => [qw/yaml/],
    expected => [qw/chomp/],
};

run {
    my $block  = shift;
    my $config = Shaq::Unit::Config->instance( %{ $block->input } );
    
    is ( $config->{name}, $block->expected );
}

=pod

Shaq::Unit::Configはクラス変数内に設定ファイルに記述された情報を
Singletonとして保持しています。

最初のテストを実行した段階では最初に設定ファイルから読み込まれた情報を取得します。

次のテストでも同じクラスから異なる設定ファイルを読み込んでいるように
見えますが、このスクリプト内では一度読み込まれた設定ファイルが
継続して有効になっている事を確認しています。

=cut

__END__

=== # conf/myapp.yml
--- input
conf_dir: Config/conf
app_name: myapp
extension: yml

--- expected
MyApp

=== # spcified conf/myapp.yml but this is singleton..
--- input
basic:
  conf_dir: Config/conf
  app_name: myapp2
  extension: yml

--- expected
MyApp


