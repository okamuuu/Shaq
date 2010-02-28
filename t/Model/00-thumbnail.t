#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Shaq::Model::Thumbnail;
use JSON;

my $thumbnail = Shaq::Model::Thumbnail->new(
    src => '/path/to',
    alt => 'test',
    width => 80,
    height => 70,
);

subtest "xhtml" => sub {
    eq_or_diff $thumbnail->xhtml, qq{<img src="/path/to" alt="test" width="80" height="70" />};
    done_testing();
};

subtest "to_json" => sub {

    eq_or_diff $thumbnail->to_json,
      qq({"src":"/path/to", "alt":"test", "width":"80", "height":"70"});

    ### JSONでパースできるか確かめる
    my $hashref = decode_json $thumbnail->to_json;
    ok($hashref);

    is_deeply( $hashref,
        { width => 80, height => 70, alt => 'test', src => '/path/to' } );

    done_testing();

};

done_testing();

