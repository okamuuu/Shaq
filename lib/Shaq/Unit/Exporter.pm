package Shaq::Unit::Exporter;
use strict;

our $VERSION = '0.01';

sub import {
    my $exporter = shift;
    my $caller = caller;

    no strict 'refs';

    *{"${caller}::has"} = sub {
        my ( $attr, %arg ) = @_;
        $exporter->mk_accessors( $attr, ( $arg{is} || "rw" ) );
    };

    *{"${caller}::new"} = sub {
        my ( $class, %arg ) = @_;
        bless {%arg}, $class;
    };

}

sub mk_accessors {
    my ( $exporter, $attr, $access ) = @_;

    no strict 'refs';
    my $pkg = caller(1);

    if ( $access eq 'ro' ) {
        *{ $pkg . '::' . $attr } = __ro($attr);
    }
    else {
       *{ $pkg . '::' . $attr } = __rw($attr);
    }
}

sub __ro {
    my $attr = shift;
    sub {
        if ( @_ == 1 ) {
            return $_[0]->{$attr};
        }
        else {
            Carp::croak("cannot alter the value of $attr ...");
        }
    };
}

sub __rw {
    my $attr = shift;
    sub {
        if ( @_ == 1 ) {
            return $_[0]->{$attr};
        }
        elsif ( @_ == 2 ) {
            $_[0]->{$attr} = $_[1];
            return $_[0];
        }
        else {
            my $self = shift;
            $self->{$attr} = \@_;  
            return $self;
        }
    };
}

1;

__END__
 
=head1 NAME

Shaq::Unit::Exporter - for my personal project 

=head1 SYNOPSIS

package MyPackage;

    use Shaq::Unit::Exporter;

=head1 SEE ALSO

C<Class::Accessor::Lite>
