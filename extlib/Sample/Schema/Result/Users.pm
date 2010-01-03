package Sample::Schema::Result::Users;

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
__PACKAGE__->table("users");
__PACKAGE__->add_columns(
  "id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "username",
  {
    data_type => "STRING",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "password",
  {
    data_type => "STRING",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "email_address",
  {
    data_type => "STRING",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "first_name",
  {
    data_type => "STRING",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "last_name",
  {
    data_type => "STRING",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "active",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->digest_columns("password");
__PACKAGE__->digest_key(12345678);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->has_many(
  "user_roles",
  "Sample::Schema::Result::UserRoles",
  { "foreign.user_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-12-02 21:12:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J/zSe222kC/mDUKl7VHGsw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
