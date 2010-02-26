package Shaq::UI::Navigation::Bread;
use strict;
use warnings;
use Path::Class qw/dir file/;

sub new {
    my ($class, $base_url) = @_;
    
    my $self = bless {
        _base_url  => $base_url || '/',
        _breads => [ { dir => '/', name => 'home' } ],
    }, $class;
}

sub init { $_[0]->{_breads} = [ { dir => '/', name => 'home' } ] }

sub breads { $_[0]->{_breads} }

sub add {
    my ( $self, $bread ) = @_;

    Carp::croak("Bread must has dir ...") unless $bread->{dir};
    Carp::croak("Bread must has name ...") unless $bread->{name};
    
    my @breads = @{ $self->{_breads} };
    push @breads, $bread;
    
    $self->{_breads} = [@breads];
}

sub base_url {
    my ( $self, $base_url ) = @_;
    $self->{_base_url} = $base_url if $base_url; 
    $self->{_base_url};
}

sub xhtml {
    my ($self) = @_;

    Carp::croak("Please set base_url ...") unless $self->base_url;

    my $path = $self->base_url;

    my $xhtml = qq{<!-- bread[start] -->\n};
    $xhtml .= qq{<p id="bread">\n};

    my $count = 0;
    my @breads = @{$self->breads};
    for my $bread ( @breads  ) {
        my $dir  = $bread->{dir};
        my $name = $bread->{name};

        # 特にPath::Classで処理する必要は無い。
        $path = dir( $path, $dir )->stringify;
        if ( $#breads != $count ) { 
            $xhtml .= qq{<a href="$path">$name</a> &gt; \n}; 
        } 
        else { 
            $xhtml .= qq{$name\n}; 
        }
        $count++;
    }

    $xhtml .= qq{</p>\n};
    $xhtml .= qq{<!-- bread[end] -->\n};
}

1;

__END__

=head1 NAME

Shaq::UI::Navigation::Bread - UI 

=head1 METHODS

=head2 new

=head2 init

=head2 breads

=head2 add

=head2 base_url

=head2 xhtml

=cut


