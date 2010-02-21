#!/usr/perl/bin/perl
use strict;
use Socket;
use IO::Socket::INET;
use AnyEvent::Socket;
use AnyEvent::Handle;
use YAML;

=pod

http://d.hatena.ne.jp/tokuhirom/20090712/1247413978

=cut

my $cv = AnyEvent->condvar;

my $hdl;

warn "listening on port 34832...\n";

AnyEvent::Socket::tcp_server undef, 34832, sub {
   my ($clsock, $host, $port) = @_;
   print "Got new client connection: $host:$port\n";

   $hdl =
      AnyEvent::Handle->new (
         fh => $clsock,
         on_eof => sub { print "client connection $host:$port: eof\n" },
         on_error => sub { print "Client connection error: $host:$port: $!\n" }
      );

   $hdl->push_read (json => sub {
        my (undef, $msg) = @_;
        print Dump($msg);
        $hdl->push_write(json => $msg);
        $hdl->push_shutdown();
   });
};

$cv->wait;

