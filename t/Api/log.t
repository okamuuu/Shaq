#!/usr/bin/perl
use strict;
use warnings;
use Test::Most;

my $CLASS = 'Shaq::Api::Log';

use_ok($CLASS);

my $log;

subtest "create $CLASS instance" => sub {
    
    $log = $CLASS->new;
    isa_ok $log, $CLASS;
};

subtest 'Log instance can remenber its action result.' => sub {

    is $log->has_log_msgs, 0,
      'At first, this action has not handle some subs yet.';

    lives_ok { $log->set_log_msgs('you send a mail') }
    'If you want notice of finishing some work. '
      . 'you can store log messages into this instance';

    is $log->has_log_msgs, 1, 'Now you can get some log messages';

    like [$log->get_log_msgs]->[0],  qr/^you send a mail/, 'get msgs and elapsed.';
    diag( "I'm thorough and I want to trace actions, like this.\n" .
    "[[[[[ " . [$log->get_log_msgs]->[0] . " ]]]]]");

    lives_ok { $log->set_log_msgs( 'you got a mail', 'you drop the mail' ) }
    'And more over you can set several messages at once.';

    is $log->has_log_msgs, 3, 'you can know how many messages stored before now.';

    like  [ $log->get_log_msgs ]->[0], qr/you send a mail/;
    like  [ $log->get_log_msgs ]->[1], qr/you got a mail/;
    like  [ $log->get_log_msgs ]->[2], qr/you drop the mail/;
};

done_testing;
