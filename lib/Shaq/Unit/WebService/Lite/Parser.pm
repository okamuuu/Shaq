package Shaq::Unit::WebService::Lite::Parser;
use Mouse::Role;

requires 'parse';

no Mouse::Role;

sub parse { 
    my ( $self, $response ) = @_;
    die("abstract...");
}

1;

__END__

=head1 NAME 

Shaq::Api::WebService::Lite::Parser - Parser Role Class

=head1 DESCRIPTION

WebService::Simpleを研究するために再発明したモジュール

=head1 METHODS

=head2 parse

=cut

