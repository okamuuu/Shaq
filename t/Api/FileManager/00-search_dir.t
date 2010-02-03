#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Test::Exception;
use Test::Differences;
use Shaq::Api::FileManager;
use FindBin qw($Bin);
use Path::Class qw/dir file/;

my $path = dir($Bin, 'sample');
my $manager;

subtest "Shaq::Api::FileManager object created ok" => sub {

    $manager = Shaq::Api::FileManager->new( root => $path );

    ok($manager, "object created ok");
    isa_ok( $manager, "Shaq::Api::FileManager", "object isa Shaq::Api::FileManager" );
    can_ok( $manager, 'search_tail_dir' );
   
    done_testing();
};

subtest "search t/Api/FileManager/sample/**/" => sub {

    is_deeply($manager->search_tail_dir, [qw{01-bar 02-foo 03-hoge XX-moo}]);
    isa_ok( $manager, "Shaq::Api::FileManager", "object isa Shaq::Api::FileManager" );
   
    done_testing();
};

subtest "search t/Api/FileManager/sample/^(\d+)-(.*)$/" => sub {

    my $regex = qr/^(\d+)-(.*)$/;
    is_deeply($manager->search_tail_dir($regex), [qw/01-bar 02-foo 03-hoge/]);
    isa_ok( $manager, "Shaq::Api::FileManager", "object isa Shaq::Api::FileManager" );
   
    done_testing();
};


done_testing();



__END__


subtest "add archive" => sub {

    $category->add_archives( $index );
    is_deeply $category->archives, [ $index ];
    is_deeply $category->menu_list,
    [
        { id => 'index', title => 'index title' },
    ];

    done_testing();
};

subtest "add archive again" => sub {

    $category->add_archives( $about );
    is_deeply $category->archives, [ $index, $about ];
    is_deeply $category->menu_list,
      [
        { id => 'index', title => 'index title' },
        { id => '01-about', title => 'about title' }, # 02はcategoryのorder
    ];

    done_testing();
};

subtest "couldn't add duplicate archive id" => sub {

    throws_ok { $category->add_archives( $about ) } qr/...$/;
    done_testing();

};

done_testing();

