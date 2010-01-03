#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use lib ( dir( $Bin, '..', 'lib' )->stringify,
          dir( $Bin, '..', 'extlib' )->stringify );

use MyApp::Web;
use Plack::Builder;
use Plack::Server::Standalone;

my $web  = MyApp::Web->new( config => {} );

### make handler enable Plack::Middleware::Static
### $handler is code-ref
my $handler = builder {
#    enable "Plack::Middleware::AccessLog", format => "combined";
    enable "Plack::Middleware::StackTrace";
    $web->handler;
};

### build server and run !!
my $server = Plack::Server::Standalone->new( host => 'colinux',  port => 5000 );
$server->run($handler);

