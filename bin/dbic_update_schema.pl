#!/usr/bin/perl -w
use strict;
use warnings;
use FindBin;
use File::Spec;

my $app_name = 'myapp';

# bk...
BEGIN { no warnings; DBIx::Class::Schema::Loader::Base->import;}
use DBIx::Class::Schema::Loader::DBI; # _setup_src_metaを衝突させる

use lib (
File::Spec->catfile( $FindBin::Bin, qw/.. extlib/ ),
File::Spec->catfile( $FindBin::Bin, qw/.. schema_tmpl/ )
); # dump時につながるファイルを用意

use DBIx::Class::Schema::Loader qw(make_schema_at);
use Shaq::Api::Config;

my $config = Shaq::Api::Config->instance( app_name => $app_name ); 
my $DIGEST_KEY = $config->{dbic}->{digest}; # use in _setup_src_meta

my @connect_info = @{ $config->{dbic}->{master}->{connect_info} };
my $schema_class = $config->{dbic}->{master}->{schema_class};

unlink( glob( File::Spec->catdir( $FindBin::Bin, '..', 'extlib', split( /::/, $schema_class ) ) . '/*.pm' ) );

make_schema_at(
$schema_class,
{
    components => [ qw/
        RandomStringColumns
        InflateColumn::DateTime
        TimeStamp
        DigestColumns::Lite
        UTF8Columns
    / ],
        #StorageReadOnly
#    use_namespaces => 1, # 可能性を感じるんだが…
    dump_directory => File::Spec->catfile( $FindBin::Bin, qw/.. extlib/ ), # schemaを生成
    debug => 0,
    relationships => 1,
    really_erase_my_files => 0,
    inflect_singular => sub {
        my $relname = shift;
        my $res =  Lingua::EN::Inflect::Number::to_S($relname);
        $res =~ s/_id$//;
        return $res;
    },

},
\@connect_info
);

### BK: 故意に関数を重複させて処理内容を強奪
### ただし、外部参照をしないでhas-manyなどを設定したい場合は
### テーブル命名規則などを用いて別の処理を考える
package DBIx::Class::Schema::Loader::Base;
use Data::Dumper;

sub _setup_src_meta {
    my ($self, $table) = @_;

    my $schema       = $self->schema;
    my $schema_class = $self->schema_class;

    my $table_class = $self->classes->{$table};
    my $table_moniker = $self->monikers->{$table};

    $self->_dbic_stmt($table_class,'table',$table);

    my $cols = $self->_table_columns($table);
    my $col_info;
    eval { $col_info = $self->_columns_info_for($table) };

    ### parsing columns
    my $is_rid = 0;
    my @digests;
    my @utf8columns;

    for my $name ( @{$cols} ) {

        ### Random String
        if ( $name =~ /^rid$/ ) {
            $is_rid = 1;
        }
        ### 暗号化
        elsif ( $name =~ /(password|passwd|_pw)$/ ) {
            push @digests, $name;
        }
        ### DateTime
        elsif ( $name =~ /^created_at$/ ) {
             my %col = %{ $col_info->{created_at} };
             $col_info->{created_at} = { %col, set_on_create => 1 };
        }
        ### DateTime
        elsif ( $name =~ /^updated_at$/ ) {
             my %col = %{ $col_info->{updated_at} };
             $col_info->{updated_at} = { %col, set_on_create => 1, set_on_update => 1 };
        }
        ### 文字列型
        elsif ( $col_info->{$name}->{data_type} =~ /(CHAR|TEXT)$/ ) {
            warn $name;
            push @utf8columns, $name; 
        }
    }

    ### add_columns
    if($@) {
        $self->_dbic_stmt($table_class,'add_columns',@$cols);
    }
    else {
        my %col_info_lc = map { lc($_), $col_info->{$_} } keys %$col_info;
        $self->_dbic_stmt(
            $table_class,
            'add_columns',
            map { $_, ($col_info_lc{$_}||{}) } @$cols
        );

    }
 
    ### random_string_columns
    if ( $is_rid ) { 
        $self->_dbic_stmt($table_class,'random_string_columns', 'rid', {length => 10} );
    } 

    ### digest_columns
    if ( @digests > 0 ) { 
        $self->_dbic_stmt($table_class,'digest_columns', @digests );
        $self->_dbic_stmt($table_class,'digest_key', $DIGEST_KEY );
    } 

    ### utf8_columns
    if ( @utf8columns > 0 ) { 
        $self->_dbic_stmt($table_class,'utf8_columns', @utf8columns );
    }

    my $pks = $self->_table_pk_info($table) || [];
    @$pks ? $self->_dbic_stmt($table_class,'set_primary_key',@$pks)
          : carp("$table has no primary key");

    my $uniqs = $self->_table_uniq_info($table) || [];
    $self->_dbic_stmt($table_class,'add_unique_constraint',@$_) for (@$uniqs);

    $schema_class->register_class($table_moniker, $table_class);
    $schema->register_class($table_moniker, $table_class) if $schema ne $schema_class;
}

1;
