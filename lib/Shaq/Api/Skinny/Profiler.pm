package Shaq::Api::Skinny::Profiler;
use base qw/DBIx::Skinny::Profiler/;
use strict;
use warnings;

sub new {
    my ( $class, $arg ) = @_; 

    my $self = $class->SUPER::new( $arg );
    $self->{_log_path} = $arg->{log_path};
    $self;

}

sub log_path { $_[0]->{_log_path} }

sub record_query {
    my ( $self, $sql, $bind ) = @_;

    my $log = _normalize($sql);
    if ( ref $bind eq 'ARRAY' ) {
        my @binds;
        push @binds, defined $_ ? $_ : 'undef' for @$bind;
        $log .= ' :binds ' . join ', ', @binds;
    }
    
    if ( $self->log_path ) {
        my $fh = IO::File->new( $self->log_path, 'a' );
        $fh->print( $log, "\n" );
    }

    push @{ $self->query_log }, $log;

}

sub _normalize {
    my $sql = shift;
    $sql =~ s/^\s*//;
    $sql =~ s/\s*$//;
    $sql =~ s/[\r\n]/ /g;
    $sql =~ s/\s+/ /g;
    return $sql;
}

1;

=head1 NAME

Shaq::Api::Skinny::Profiler - Profiler

=head1 METHODS

=head2 new

=head2 log_path

=head2 record_query

