package Shaq::Unit::WebService::Lite::Parser::JSON;
use Mouse;
use JSON;

with 'Shaq::Unit::WebService::Lite::Parser';

no Mouse;

sub parse {
    my ( $self, $response ) = @_;
    decode_json( $response->content )
}

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME 

Shaq::Api::WebService::Lite::Parser::JSON - Parser Class

=head1 DESCRIPTION

WebService::Simpleを研究するために再発明したモジュール

=head1 METHODS

=head2 parse

JSON::XSがない場合はPurePerlのJSONを使う、はず

=cut


