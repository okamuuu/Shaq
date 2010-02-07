#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use FindBin qw($Bin);
use Path::Class qw/dir file/;
use Shaq::CMS::Manager;
use Shaq::CMS::ArchiveParser::Trac;

#my $layout_file = "t/template/layout.tt2";
#my $template_root   = "t/template/root.tt2";
#my $doc_dir    = "t/doc/001-siteA";
#my $root_dir   = "t/root/001-siteA";
#my $backup_dir = "t/backup/001-siteA";
#my $upload_dir = "/";

my $doc_dir = dir( $Bin, '..', '..', "t/CMS/samples/doc" );
my $parser  = Shaq::CMS::ArchiveParser::Trac->new;

my $manager;

subtest "prepate" => sub {

    $manager = Shaq::CMS::Manager->new(
        name        => 'Site Name',
        doc_dir     => dir( $Bin, '..', '..', "t/CMS/samples/doc" ),
        root_dir    => dir( $Bin, '..', '..', "t/CMS/samples/root" ),
        backup_dir  => dir( $Bin, '..', '..', "t/CMS/samples/backup" ),
        upload_dir  => '/',
        layout_file => file( $Bin, '..', '..', "t/CMS/samples/layout.tt2"),
        parser      => Shaq::CMS::ArchiveParser::Trac->new,
    );
 
    isa_ok( $manager, "Shaq::CMS::Manager", "object isa Shaq::CMS::Manager" );
    can_ok( $manager, "file2archive" );  
    can_ok( $manager, "dir2archives" );  
    can_ok( $manager, "dir2menus" );  
    can_ok( $manager, "create_site" );  
    done_testing();
};

subtest "create archive from file" => sub {

    my $cat_dir = dir( $Bin, '..', '..', "t/CMS/samples/doc/01-first" );
    
    for my $file ( $cat_dir->children ) {
        my $archive = $manager->file2archive( $file );
        isa_ok( $archive, 'Shaq::CMS::Archive' );
    }

    done_testing();
};

subtest "create archives from dir" => sub {

    my $target_dir = dir( $Bin, '..', '..', "t/CMS/samples/doc/01-first" );

    for my $archive ( @{ $manager->dir2archives($target_dir) } ) {
        isa_ok( $archive, 'Shaq::CMS::Archive' );
    }
    done_testing();

};

subtest "create menu object from dir" => sub {
 
    can_ok( $manager, "dir2menu" );  
    
    my $target_dir = dir( $Bin, '..', '..', "t/CMS/samples/doc/01-first" );
    my $menu       = $manager->dir2menu($target_dir);
    
    isa_ok $menu, "Shaq::CMS::Menu";
    
    done_testing();
}; 

subtest "create site" => sub {

    my $site = $manager->create_site( 'Test' );
    isa_ok( $site, 'Shaq::CMS::Site' );
        
    done_testing();

};

done_testing();

__END__


