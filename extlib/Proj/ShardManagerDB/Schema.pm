package Proj::ShardManagerDB::Schema;
use strict;
use warnings;
use DBIx::Skinny::Schema;
use Shaq::DB::Schema::Extend;

install_table shard_users => schema {
    pk 'id';
    columns qw/id rid name birth_on created_at/;
};



1;

