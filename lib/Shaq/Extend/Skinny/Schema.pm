package Shaq::Extend::Skinny::Schema;
use strict;
use warnings;
use utf8;
use DateTime;
use DateTime::Format::Strptime;
use DateTime::Format::MySQL;
use DateTime::TimeZone; 
use String::Random;
use JSON::XS;

our $VERSION = '0.03';

sub import {
    
    my $schema = caller;
    
    #-----------------------------------------------------------
    # to rid 
    #-----------------------------------------------------------
    push @{ $schema->common_triggers->{pre_insert} }, sub {
        my ( $self, $args, $table ) = @_;
        my ($column) = grep { $_ eq 'rid' } $schema->schema_info->{$table}->{columns};
        $args->{rid} ||= String::Random->new->randregex('[A-Za-z0-9]{10}'); 
    };
 
    #-----------------------------------------------------------
    # serialize
    #-----------------------------------------------------------
    for my $rule (qw(^.+_data$)) {
        $schema->inflate_rules->{$rule}->{inflate} = sub {
            my $value = shift or return;
            decode_json $value;
        };
        $schema->inflate_rules->{$rule}->{deflate} = sub {
            my $value = shift or return;
            encode_json $value;
        };
    }
 
    #-----------------------------------------------------------
    # inflate DateTime
    #-----------------------------------------------------------
    my $timezone = DateTime::TimeZone->new( name => 'Asia/Tokyo' );

    for my $rule (qw(^.+_at$ ^.+_on$)) {
        $schema->inflate_rules->{$rule}->{inflate} = sub {
            my $value = shift or return;
            return $value if ref $value eq 'DateTime'; # !? そんなばかな !?
            my $dt = DateTime::Format::Strptime->new(
                pattern   => '%Y-%m-%d %H:%M:%S',
                time_zone => $timezone,
            )->parse_datetime($value);
            return DateTime->from_object( object => $dt );
        };
        $schema->inflate_rules->{$rule}->{deflate} = sub {
            my $value = shift;
            return DateTime::Format::MySQL->format_datetime($value);
        };
    }

    ### pre insert
    push @{ $schema->common_triggers->{pre_insert} }, sub {
        my ( $self, $args, $table ) = @_;
        my $columns = $schema->schema_info->{$table}->{columns};
        my $now = DateTime->now( time_zone => $timezone );
        for my $key (qw/created_at created_on updated_at updated_on/) {
            $args->{$key} ||= $now if grep { /^$key$/ } @$columns;
        }
    };

    ### pre update
    push @{ $schema->common_triggers->{pre_update} }, sub {
        my ( $self, $args, $table ) = @_;
        my $columns = $schema->schema_info->{$table}->{columns};
        my $now = DateTime->now( time_zone => $timezone );
        for my $key (qw/updated_at updated_on/) {
            $args->{$key} ||= $now if grep { /^$key$/ } @$columns;
        }
    };

    #-----------------------------------------------------------
    # Cache 
    #-----------------------------------------------------------
    my $callback = sub {
        my ( $self, $args, $table ) = @_;
        $self->clear_cache($table) if $self->can('clear_cache');
    };

    push @{ $schema->common_triggers->{post_insert} }, $callback;
    push @{ $schema->common_triggers->{post_update} }, $callback;
    push @{ $schema->common_triggers->{post_delete} }, $callback;

}

1;


=head1 NAME

Shaq::Extend::Skinny::Schema - My personal library

=head1 METHODS

=head2 import

=cut


