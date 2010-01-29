package Shaq::Api::WebService::Lite::Parser::JSON::XS;
use strict;
use warnings;
use base qw/Shaq::Api::WebService::Lite::Parser/;
use JSON::XS;

sub parse_content {
    my ( $self, $content ) = @_;
    # JSONP to pure JSON
    $content =~ s/[a-zA-Z_\$][a-zA-Z0-9_\$]*\s*\((.+)\)\s*;?\s*$/$1/;
    $self->parser->decode($content);
}

1;

__END__

=head1 NAME 

Shaq::Api::WebService::Lite::Parser::JSON::XS - Parse JSON content

=head1 METHODS

=head2 new

=head2 parse_response($response)

=cut


