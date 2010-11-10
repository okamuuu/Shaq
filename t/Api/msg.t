#!/usr/bin/perl
use strict;
use warnings;
use Test::Most;

use_ok('Shaq::Api::Msg');

my $msg;

subtest 'Shaq::Api::Msg provide instance' => sub {
    
    $msg = Shaq::Api::Msg->new;
    isa_ok $msg, 'Shaq::Api::Msg';
};

subtest 'Api instance can remenber its action result.' => sub {

    my $msg = Shaq::Api::Msg->new;

    is $msg->has_status_msgs, 0,
      'At first, this action has not handle some subs yet.';

    lives_ok { $msg->set_status_msgs('you send a mail') }
    'If you want notice of finishing some work. '
      . 'you can store status messages into this instance';

    is $msg->has_status_msgs, 1, 'Now you can get some status messages';

    is_deeply [ $msg->get_status_msgs ], ['you send a mail'],
      'So we can show user notice what this action has done.';

    lives_ok { $msg->set_status_msgs( 'you got a mail', 'you drop the mail' ) }
    'And more over you can set several messages at once.';

    is $msg->has_status_msgs, 3, 'you can know how many messages stored before now.';

    is_deeply [ $msg->get_status_msgs ], ['you send a mail', 'you got a mail', 'you drop the mail'],
      'you can get all notice what this action has done.';
};

subtest 'Api instance can remenber its error messages as same ad status messages.' => sub {

    my $msg = Shaq::Api::Msg->new;

    is $msg->has_error_msgs, 0, 'this action still not has error.';

    lives_ok { $msg->set_error_msgs('you fault to send a mail') } 'set error message ok.';

    is $msg->has_error_msgs, 1, 'You can decision to discontinueaction if this action has already has error.';

    is_deeply [ $msg->get_error_msgs ], ['you fault to send a mail'],
      'We will show users why this action was fault.';

    lives_ok { $msg->set_error_msgs( 'you have not enough money', 'you can not buy it' ) }
    'And more over you can set several error messages at once.';

    is $msg->has_error_msgs, 3, 'you can know how many error messages stored before now.';

    is_deeply [ $msg->get_error_msgs ], ['you fault to send a mail', 'you have not enough money', 'you can not buy it'],
      'you can get all errors.';
};

done_testing;
