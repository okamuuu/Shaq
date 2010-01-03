package Sample::Schema::Result::Books;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components(
  "RandomStringColumns",
  "InflateColumn::DateTime",
  "TimeStamp",
  "DigestColumns::Lite",
  "UTF8Columns",
  "Core",
);
__PACKAGE__->table("books");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "category_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "title",
  {
    data_type => "STRING",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->utf8_columns("description");
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "category",
  "Sample::Schema::Result::Categories",
  { id => "category_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-12-02 21:12:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6rl7LnbXwMT8lUe6VWj5tg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
