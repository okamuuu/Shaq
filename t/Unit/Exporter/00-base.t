use strict;
use warnings;

package Unit;
use Shaq::Unit::Exporter;
has name  => ( is => "ro" );
has hobby => ( is => "rw" );

1;

package main;
use Test::More;
use Test::Exception;

my $unit = Unit->new( name => 'taro', hobby => 'walking' );

ok($unit);

is $unit->name, 'taro';
throws_ok { $unit->name('hoge') } qr/...$/;

is $unit->hobby, 'walking';
is $unit->hobby('tennis')->hobby, 'tennis';

done_testing;


