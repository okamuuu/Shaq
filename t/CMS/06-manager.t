#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Shaq::CMS::Manager;
use Shaq::CMS::ArchiveParser::Trac;

subtest "create manager object" => sub {

    my $site = Shaq::CMS::Manager->new({
        name        => 'Site Name',
        doc_dir     => dir( $Bin, '..', '..', "t/CMS/samples/doc" ),
        root_dir    => dir( $Bin, '..', '..', "t/CMS/samples/root" ),
        backup_dir  => dir( $Bin, '..', '..', "t/CMS/samples/backup" ),
        upload_dir  => '/',
        parser      => 'Trac',
    });
 
    isa_ok( $site, "Shaq::CMS::Manager", "object isa Shaq::CMS::Manager" );

    ### 属性に値が存在しているかをチェック
    ok($_, "attribute $_ is ok") for qw/name doc_dir root_dir backup_dir parser/;

    ### 振舞いの可否をチェック
    can_ok( $site, "doc2site" );  
    
    done_testing();
};

done_testing();


