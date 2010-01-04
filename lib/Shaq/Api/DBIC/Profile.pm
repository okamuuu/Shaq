package Shaq::Api::DBIC::Profile;
use strict;
use warnings;
use Carp;
use Time::HiRes qw/time/;

use base 'DBIx::Class::Storage::Statistics';

our $VERSION = '0.01';
our $DEBUG = 1;

my $start;

sub query_start {
    my ($self, $sql, @params) = @_;

    if ($DEBUG) {
        $sql =~ s/\?/$_/ for (@params);
        $self->debugfh->print("SQL Statement: ", "\n$sql\n");
        $start = time;
    }
}

sub query_end {
    my ($self, $sql, @params) = @_;

    if ($DEBUG) {
        $self->debugfh->print( sprintf "-- Take %0.4f seconds.\n\n", time - $start );
    }
}


1;

__END__

=head1 NAME

Shaq::Api::DBIC::Profile - dbic profiler

=head1 METHODS

=head2 query_start

=head2 query_end

