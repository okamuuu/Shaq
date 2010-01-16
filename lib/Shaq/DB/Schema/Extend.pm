package Shaq::DB::Schema::Extend;
use strict;
use warnings;
use DateTime;
use DateTime::Format::Strptime;
use DateTime::Format::MySQL;
use DateTime::TimeZone; 
use String::Random;

our $VERSION = '0.01';

=head1 NAME

Shaq::DB::Schema::Extend - My personal library

=head1 METHODS

=head2 import

=cut

sub import {
    
    my $schema = caller;
    
    #-----------------------------------------------------------
    # rid 
    #-----------------------------------------------------------
    push @{ $schema->common_triggers->{pre_insert} }, sub {
        my ( $self, $args, $table ) = @_;
        my ($column) = grep { $_ eq 'rid' } $schema->schema_info->{$table}->{columns};
        $args->{rid} ||= String::Random->new->randregex('[A-Za-z0-9]{10}'); 
    };
   
    #-----------------------------------------------------------
    # DateTime
    #-----------------------------------------------------------
    my $timezone = DateTime::TimeZone->new( name => 'local' );

    ### DateTimeオブジェクトとして使う
    for my $rule (qw(^.+_at$ ^.+_on$)) {
        $schema->inflate_rules->{$rule}->{inflate} = sub {
            my $value = shift or return;
            return $value if ref $value eq 'DateTime';
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
    my $cb = sub {
        my ( $self, $args, $table ) = @_;
        $self->clear_cache($table) if $self->can('clear_cache');
    };

    push @{ $schema->common_triggers->{post_insert} }, $cb;
    push @{ $schema->common_triggers->{post_update} }, $cb;
    push @{ $schema->common_triggers->{post_delete} }, $cb;

}

1;

