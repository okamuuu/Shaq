package t::Extend::Skinny::Mock::DB;
use DBIx::Skinny setup => {
    dsn => 'dbi:SQLite:test.db',
    username => '',
    password => '',
};
 
package t::Extend::Skinny::Mock::DB::Schema;
use DBIx::Skinny::Schema;
use Shaq::Extend::Skinny::Schema;
 
install_table books => schema {
    pk 'id';
    columns qw/id author_id json_data name published_at created_at updated_at/;
};
 
install_table authors => schema {
    pk 'id';
    columns qw/id name debuted_on created_on updated_on/;
};

1;

=head1 SEE ALSE

ここを真似している

http://github.com/nekoya/p5-dbix-skinny-inflatecolumn-datetime/blob/master/t/Mock/DB.pm
