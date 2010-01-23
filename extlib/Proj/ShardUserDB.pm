package Proj::ShardUserDB;
use DBIx::Skinny;
use DBIx::Skinny::Mixin modules => [qw/+Shaq::DB::Mixin::Extend/];

sub clear_cache {
    my ( $self, $table ) = @_;
    warn $table;    
}

1;

