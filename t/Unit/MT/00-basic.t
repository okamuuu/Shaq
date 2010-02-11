#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Differences;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use lib dir($Bin, '..', 'lib')->stringify;

use_ok( 'Shaq::Unit::MT' );

my $home_dir = dir( $Bin, '..', '..', '..' );

my $config = {
    unit => {
        mt => {
            tmpl_dir => dir( $home_dir, 't', 'Unit', 'MT', 'tmpl' )->stringify,
        },
    },
};

subtest "create unit MT " => sub {

    my $mt = Shaq::Unit::MT->new($config->{unit}->{mt});

    isa_ok( $mt, "Shaq::Unit::MT", "object isa Shaq::Unit::MT" );
    can_ok( $mt, 'tmpl_file');
    can_ok( $mt, 'stash');
    can_ok( $mt, 'mt');
    can_ok( $mt, 'render_file');

    done_testing;

};

subtest "render with template file" => sub {

    my $mt = Shaq::Unit::MT->new($config->{unit}->{mt});
    
    diag('wrapper_file is $Bin/../tmpl/base.mt');
    my $content = $mt->render_file( 'name.mt', {name=>'Mike'} );

    eq_or_diff $content, <<"_EOF_";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title>Test</title>
</head>
<body>
    <div id="content">
            Hi, Mike.

    </div>
</body>
</html>
_EOF_

    done_testing;

};

subtest "use macro 'raw_string', 'html_unescape'" => sub {

    my $mt = Shaq::Unit::MT->new($config->{unit}->{mt});
    
    my $content = $mt->render_file( 'raw_string.mt', { xhtml =>'<p>test</p>', encoded => "&lt;p&gt;test&lt;/p&gt;" } );

    eq_or_diff $content, <<"_EOF_";
&lt;p&gt;test&lt;/p&gt;
<p>test</p>
<p>test</p>
_EOF_

    done_testing;

};

subtest "use macro 'uri'" => sub {

    my $mt = Shaq::Unit::MT->new($config->{unit}->{mt});
    
    diag('SEE ALSO RFC 2396 and updated by RFC 2732');
    my $content = $mt->render_file( 'uri_escape.mt', { uri => "http://search.yahoo.co.jp/search?p=東京" } );

    eq_or_diff $content, <<"_EOF_";
http://search.yahoo.co.jp/search?p=東京
http%3A%2F%2Fsearch.yahoo.co.jp%2Fsearch%3Fp%3D%E6%9D%B1%E4%BA%AC
_EOF_

    done_testing;

};

done_testing;

