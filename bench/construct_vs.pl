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

sub id { $_[0]->{id} }
sub order { $_[0]->{order} }
sub title { $_[0]->{title} }
sub keywords { $_[0]->{keywords} }
sub description { $_[0]->{description} }
sub content { $_[0]->{content} }

1;

package Lite;
use strict;
use warnings;
use Class::Accessor::Lite;
Class::Accessor::Lite->mk_accessors(qw/id order title keywords description content/);

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

package Unit;
use strict;
use warnings;
use Shaq::Unit::Exporter;

has id          => ( is => 'ro' );
has order       => ( is => 'ro' );
has title       => ( is => 'ro' );
has keywords    => ( is => 'ro' );
has description => ( is => 'ro' );
has content     => ( is => 'ro' );

package main;
use strict;
use warnings;
use Benchmark qw(:all);

my $data = {
    id => 'name',
    order => '001',
    title => 'title',
    keywords => [qw/some keywords here/],
    description => 'test test test',
    content => 'content content content',
};

cmpthese timethese 100_000, {
	'Mouse' => sub {
		my $o = Mou->new(%$data);
#        $o->id;
#        $o->order;
#        $o->title;
#        $o->keywords;
#        $o->description;
#        $o->content;
	},
	'Moose' => sub {
		my $o = Moo->new(%$data);
#        $o->id;
#        $o->order;
#        $o->title;
#        $o->keywords;
#        $o->description;
#        $o->content;
	},
	'Plane' => sub {
		my $o = Plane->new($data);
#        $o->id;
#        $o->order;
#        $o->title;
#        $o->keywords;
#        $o->description;
#        $o->content;
	},
	'Class::Accessor::Lite' => sub {
		my $o = Lite->new($data);
#        $o->id;
#        $o->order;
#        $o->title;
#        $o->keywords;
#        $o->description;
#        $o->content;
	},
	'Shaq::Unit::Exporter' => sub {
		my $o = Unit->new(%$data);
#        $o->id;
#        $o->order;
#        $o->title;
#        $o->keywords;
#        $o->description;
#        $o->content;
	},

};



