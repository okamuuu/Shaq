use strict;
use warnings;
use Test::More;
use Test::Differences;

use_ok( 'Shaq::Unit::TX' );

local $Shaq::Unit::TX::BASE_TEMPLATE_DIR = "t/template";

subtest "create" => sub {

    isa_ok( Shaq::Unit::TX->create, 'Text::Xslate' );
};

subtest "render" => sub {

    my $html = Shaq::Unit::TX->render('name.tt',{name=>'Mike'});
    
    chomp $html;
    is $html, 'Hello, Mike!';

};

done_testing();

