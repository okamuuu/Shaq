package Shaq::Api::WebService::Base;
use strict;
use warnings;
use Carp;
use Try::Tiny;
use LWP::UserAgent;
use Cache::Memcached::Fast;
use WebService::Simple;
use Shaq::Api::Msg;
use Data::Page;

sub new {
#    my ( $class, %arg ) = @_;
    my ( $class, $config ) = @_;

    my $base_url        = $config->{base_url} or croak("Plase set base_url..");
    my $param           = $config->{param} || {};
    my $response_parser = $config->{parser} || "XML::Simple";
    my $namespace       = $config->{namespace} || 'webservice';

    my $cache = Cache::Memcached::Fast->new(
        {
            servers => [ { address => 'localhost:11211'} ],
            namespace => $namespace,
        }
    );

    croak("Memcachedが起動していません。")
      unless keys %{ $cache->server_versions };

    my $ws = WebService::Simple->new(
        base_url        => $base_url,
        param           => $param,
        response_parser => $response_parser,
        cache           => $cache,
    );

    my $self = bless {
        _ws    => $ws,
        _ua    => LWP::UserAgent->new,
        _msg   => Shaq::Api::Msg->new,
        _pager => Data::Page->new,
    }, $class;
}

sub ua    { $_[0]->{_ua} }
sub ws    { $_[0]->{_ws} }
sub msg   { $_[0]->{_msg} }
sub pager { $_[0]->{_pager} }

sub parse {
    my ( $self, $path, $attr ) = @_;

    my $data;
    try {
        $data = $self->ws->get($path, $attr)->parse_response;
        $self->msg->set_errors("nothing...") unless $data; # or die XML::Feed->errstrとか、Parserをカスタムしよ
    }
    catch {
        $self->msg->set_errors( $_ );
        return undef;
    };
    
    return $data;
}

1;

__END__

=head1 NAME 

Shaq::Api::WebService::Base - WebService Base class

=head1 METHODS

=head2 new

=head2 ua

=head2 ws

=head2 msg

=head2 pager

=head2 parse

=cut


