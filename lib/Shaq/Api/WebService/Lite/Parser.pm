package Shaq::Api::WebService::Lite::Parser;
use strict;
use warnings;
 
sub new { bless \do{''}, $_[0] }
sub parse_content { die 'this method is abstract!!' }

1;

__END__

=head1 NAME 

Shaq::Api::WebService::Lite::Parser - Base Parser Class

=head1 METHODS

=head2 new

=head2 parse_response($response)

Parses the response object. Your subclass must implement this method

=cut


