#!/usr/bin/env perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Benchmark qw(:all);
use Data::Dumper;

my $data = {
    id => 'name',
    order => '001',
    title => 'title',
    keywords => [qw/some keywords here/],
    description => 'test test test',
    content => 'content content content',
};

cmpthese timethese 10_000, {
	'Mou' => sub {
		Mou->new($data);
	},
	'Moo' => sub {
		Moo->new($data);
	},
	'Plane' => sub {
		Plane->new($data);
	},
};

package Mou;
use Mouse;

has id          => ( is => 'ro', isa => 'Str' );
has order       => ( is => 'ro', isa => 'Str' );
has title       => ( is => 'ro', isa => 'Str' );
has keywords    => ( is => 'ro', isa => 'ArrayRef' );
has description => ( is => 'ro', isa => 'Maybe[Str]' );
has content     => ( is => 'ro', isa => 'Str' );

__PACKAGE__->meta->make_immutable;

no Mouse;

1;


package Moo;
use Moose;

has id          => ( is => 'ro', isa => 'Str' );
has order       => ( is => 'ro', isa => 'Str' );
has title       => ( is => 'ro', isa => 'Str' );
has keywords    => ( is => 'ro', isa => 'ArrayRef' );
has description => ( is => 'ro', isa => 'Maybe[Str]' );
has content     => ( is => 'ro', isa => 'Str' );

__PACKAGE__->meta->make_immutable;

no Moose;

1;

package Plane;
use strict;
use warnings;

sub new { 
    my ($class, $data ) = @_;
    bless {
        id => $data->{id},
        order => $data->{order},
        title => $data->{title},
        keywords => $data->{keywords},
        description => $data->{description},
        content => $data->{content}, 
    }, $class;
}

1;

__END__

