#!/usr/bin/perl
use strict;
use Test::More;

{
    package Foo;
    use Mouse;
    use Shaq::Extend::MouseX::Types qw(DateTime);

    has 'datetime' => (is => 'rw', isa => 'DateTime', coerce => 1, required => 0);
}

my $obj = Foo->new( datetime => '2010-01-01T00:00:00' );

isa_ok $obj, 'Foo';
isa_ok $obj->datetime => 'DateTime';
is     $obj->datetime => '2010-01-01T00:00:00';

done_testing;

