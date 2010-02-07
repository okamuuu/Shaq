#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Shaq::CMS::ArchiveFactory; 

use_ok( 'Shaq::CMS::ArchiveFactory' );

subtest 'create Shaq::CMS::Archive via Shaq::CMS::ArchiveFactory' => sub {

    my $factory = Shaq::CMS::ArchiveFactory->new( parser => 'Shaq::CMS::ArchiveParser::Trac' );

    ok($factory, "object created ok");
    isa_ok( $factory, "Shaq::CMS::ArchiveFactory", "object isa Shaq::CMS::ArchiveFactory" );
    can_ok( $factory, 'file2archive');
    
    my $file = file( $Bin, '..', '..',  "t/CMS/samples/doc/01-first/02-about.txt" );
    my $archive = $factory->file2archive( $file );

    ok($archive, "object created ok");
    isa_ok( $archive, "Shaq::CMS::Archive", "object isa Shaq::CMS::Archive" );
    ok( $archive->basename );
    ok( $archive->title );
    ok( $archive->keywords );
    ok( $archive->description );
    ok( $archive->content );

    is ($archive->basename, 'about');
    is ($archive->title, 'Linodeについて');
    is_deeply ($archive->keywords, [qw/ディストリビューション root権限 レンタルサーバー 専用IPアドレス メモリ/]);
    is ($archive->description, 'アメリカを拠点とするVPSホスティングサービスです。');

    done_testing();
};

done_testing();

