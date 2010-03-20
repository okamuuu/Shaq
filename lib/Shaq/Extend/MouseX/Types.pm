package Shaq::Extend::MouseX::Types;
use strict;
use warnings;
use DateTime();
use DateTime::Format::Strptime();
use Mouse::Util::TypeConstraints;
use MouseX::Types::Mouse qw(Any Str HashRef);
use namespace::clean;

use MouseX::Types
    -declare => [qw/DateTime/];

our $VERSION = '0.01';

class_type 'DateTime' => { class => 'DateTime' };

subtype DateTime, as 'DateTime';

coerce 'DateTime', from Str, via {
    my $str = $_;
    $str =~ s/T/ /;
    my $dt = DateTime::Format::Strptime->new(
        pattern   => '%Y-%m-%d %H:%M:%S',
        time_zone => 'Asia/Tokyo',
    )->parse_datetime($str);
    return 'DateTime'->from_object( object => $dt );
};

1;

=head1 NAME 

Shaq::Extend::MouseX::Types - Extend MouseX::Types

=head1 DESCRIPTION

DateTime  - DateTimeX::Easyで必要だったDateTime::Format::Flexibleがインストール時にエラーになったので自力で実装している

=cut 
