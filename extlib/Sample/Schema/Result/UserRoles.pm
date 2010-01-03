package Sample::Schema::Result::UserRoles;

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
__PACKAGE__->table("user_roles");
__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "role_id",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("user_id", "role_id");
__PACKAGE__->belongs_to("user", "Sample::Schema::Result::Users", { id => "user_id" });
__PACKAGE__->belongs_to("role", "Sample::Schema::Result::Roles", { id => "role_id" });


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-12-02 21:12:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JnRBtuPN56l2McyoyV8J7w


# You can replace this text with custom content, and it will be preserved on regeneration
1;
