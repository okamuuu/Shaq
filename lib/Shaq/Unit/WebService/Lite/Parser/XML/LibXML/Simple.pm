package Shaq::Unit::WebService::Lite::Parser::XML::LibXML::Simple;
use Mouse;
use XML::LibXML::Simple;

with 'Shaq::Unit::WebService::Lite::Parser';

no Mouse;

__PACKAGE__->meta->make_immutable;

sub parse {
    my ( $self, $response ) = @_;
    return XMLin( $response->content );
}

1;

__END__

=head1 NAME 

Shaq::Api::WebService::Lite::Parser::XML::LibXML::Simple - Parser Class

=head1 DESCRIPTION

WebService::Simpleを研究するために再発明したモジュール

=head1 METHODS

=head2 parse

=cut


