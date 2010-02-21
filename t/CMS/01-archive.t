#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use_ok( 'Shaq::CMS::Archive' );

subtest 'basic test' => sub {

    my $archive = Shaq::CMS::Archive->new(
        basename    => 'archive_name',
        title       => 'title',
        keywords    => [qw/some keywords here/], 
        description => 'outline of this documentation',
        content     => 'long long text',
    );

    ok($archive, "object created ok");
    isa_ok( $archive, "Shaq::CMS::Archive", "object isa Shaq::CMS::Archive" );

    can_ok( $archive, 'basename');
    can_ok( $archive, 'title');
    can_ok( $archive, 'keywords');
    can_ok( $archive, 'description');
    can_ok( $archive, 'content');

    is( $archive->basename, 'archive_name' );
    is( $archive->title, 'title' );
    is_deeply( $archive->keywords, [qw/some keywords here/] );
    is( $archive->description, 'outline of this documentation' );
    is( $archive->content, 'long long text' );

    done_testing();
};

done_testing();

