#!/usr/bin/perl
use strict;
use warnings;
use Test::Base;
plan tests => 1 * blocks;

use Shaq::Api::Config;

filters {
    input    => [qw/yaml/],
    expected => [qw/chomp/],
};

run {
    my $block  = shift;
    my $config = Shaq::Api::Config->instance( %{ $block->input } );
    
    is ( $config->{name}, $block->expected );
}

=pod

最初のテストを実行した段階で設定ファイルをsingletonで呼び出します。
次のテストでも同じクラスから異なる設定ファイルを読み込んでいるように
見えますが、このスクリプト内では一度読み込まれた設定ファイルが
継続して有効であるため、異なるファイルを指定してあるにもかかわらず
最初のテストで読み込んでいる設定ファイルの情報が有効になっています。

=cut

__END__

=== # conf/myapp.yml
--- input
conf_dir: t/Api/Config/conf
app_name: myapp
extension: yml

--- expected
MyApp

=== # spcified conf/myapp.yml but this is singleton..
--- input
basic:
  conf_dir: t/Api/Config/conf
  app_name: myapp2
  extension: yml

--- expected
MyApp


