#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Shaq::Model::Iterator;

my $collection;
my $datas = [
    {
        id => 1,
        name => 'taro',
    },
    {
        id => 2,
        name => 'jiro',
    },
    {
        id => 3,
        name => 'saburo',
    }
]; 

subtest "construction" => sub {
    $collection = Shaq::Model::Iterator->new;
    isa_ok $collection, "Shaq::Model::Iterator";
    done_testing;
};

subtest "set raw datas" => sub {
    ok $collection->set($datas);
    done_testing();
};

subtest "check next loaded data" => sub {
    is $collection->next->load->{id}, 1;
    is $collection->next->load->{id}, 2;
    is $collection->next->load->{id}, 3;
    done_testing();
};

subtest "check first loaded data" => sub {
    is $collection->first->load->{id}, 1;
    is $collection->first->load->{name}, 'taro';
    done_testing();
};

subtest "reset iteration" => sub {
    $collection->reset;
    is $collection->next->load->{id}, 1;
    is $collection->next->load->{id}, 2;

    $collection->reset;
    is $collection->next->load->{id}, 1;
    is $collection->next->load->{id}, 2;

    done_testing();
};

subtest "count" => sub {
    is $collection->count, 3;
    done_testing();
};

done_testing();

