package Shaq::Api::WebService::Lite::Parser::XML::Simple;
use strict;
use warnings;
use base qw/Shaq::Api::WebService::Lite::Parser/;
use XML::Simple;

sub parse_content { XMLin($_[1]) }

1;

__END__

=head1 NAME 

Shaq::Api::WebService::Lite::Parser::XML::Simple - Parse XML content

=head1 METHODS

=head2 new

=head2 parse_response($response)

=cut


