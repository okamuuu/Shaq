#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Shaq::UI::Thumbnail;

my $thumbnail = Shaq::UI::Thumbnail->new(
    src => '/path/to',
    alt => 'test',
    width => 80,
    height => 70,
);

subtest "render xhtml" => sub {

    eq_or_diff $thumbnail->xhtml, qq{<img src="/path/to" alt="test" width="80" height="70" />};
    done_testing();

};

done_testing();

