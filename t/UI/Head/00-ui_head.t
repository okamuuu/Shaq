#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use Shaq::UI::Head;

my $head;

subtest 'create object' => sub {

    $head = Shaq::UI::Head->new(
        title       => 'this is test',
        keywords    => [qw/some keywords here/],
        description => 'description description description',
    );

    ok($head, "object created ok");
    isa_ok( $head, "Shaq::UI::Head", "object isa Shaq::UI::Head" );
        
    done_testing();
   
};

 
subtest 'render check' => sub {

        eq_or_diff $head->xhtml, <<"_EOF_"; 
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf8" />
    <title>this is test</title>
    <meta name="keywords" content="some, keywords, here" />
    <meta name="description" content="description description description" />
    <meta name="robots" content="all" />
    <link rel="stylesheet" type="text/css" media="screen, projection, tv" href="/common/css/import.css" />
    <link rel="stylesheet" type="text/css" media="print" href="/common/css/print.css" />
</head>
_EOF_
    
    done_testing();
};

done_testing();
