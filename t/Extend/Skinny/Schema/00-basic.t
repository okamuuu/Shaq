#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use t::Extend::Skinny::Mock::SQLite;
use t::Extend::Skinny::Mock::DB;

subtest "serialize" => sub {

    my $book = t::Extend::Skinny::Mock::DB->single('books', {id=>1});
    is_deeply( $book->json_data, {width=>80, height=>100} );

    $book->set({ json_data => {width=>100, height=>120} });
    is_deeply( $book->json_data, {width=>100, height=>120} );

    done_testing;

};

done_testing;
