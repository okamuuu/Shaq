#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;

use_ok( 'Shaq::Unit::MT' );

my $mt;

subtest "create unit MT " => sub {

    $mt = Shaq::Unit::MT->new;

    isa_ok( $mt, "Shaq::Unit::MT", "object isa Shaq::Unit::MT" );
    can_ok( $mt, 'tmpl_file');
    can_ok( $mt, 'stash');
    can_ok( $mt, 'mt');
    can_ok( $mt, 'render');

    done_testing;

};

subtest "create unit MT with no arugument " => sub {

    $mt = Shaq::Unit::MT->new;
    
    diag('wrapper_file is $Bin/../tmpl/base.mt');
    my $content = $mt->render( 'name.mt', {name=>'okamura'} );

    eq_or_diff $content, <<"_EOF_";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title>Test</title>
</head>
<body>
    <div id="content">
        <? block content => sub {} ?>
    </div>
</body>
</html>
_EOF_

    done_testing;

};

subtest "use macro 'raw_string', 'html_unescape'" => sub {

    $mt = Shaq::Unit::MT->new;
    
    my $content = $mt->render( 'raw_string.mt', { xhtml =>'<p>test</p>', encoded => "&lt;p&gt;test&lt;/p&gt;" } );

    eq_or_diff $content, <<"_EOF_";
&lt;p&gt;test&lt;/p&gt;
<p>test</p>
<p>test</p>
_EOF_

    done_testing;

};


subtest "use macro 'uri'" => sub {

    $mt = Shaq::Unit::MT->new;
    
    diag('SEE ALSO RFC 2396 and updated by RFC 2732');
    my $content = $mt->render( 'uri_escape.mt', { uri => "http://search.yahoo.co.jp/search?p=東京" } );

    eq_or_diff $content, <<"_EOF_";
http://search.yahoo.co.jp/search?p=東京
http%3A%2F%2Fsearch.yahoo.co.jp%2Fsearch%3Fp%3D%E6%9D%B1%E4%BA%AC
_EOF_

    done_testing;

};

done_testing;

