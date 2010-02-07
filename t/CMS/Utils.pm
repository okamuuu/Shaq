package t::CMS::Utils;
use strict;
use warnings;
use Shaq::CMS::Archive;
use Shaq::CMS::Menu;

my %archive_of = (
    '001-index' => {
        basename    => 'index',
        title       => 'index title',
        keywords    => [qw/some keywords here/], 
        description => 'outline of this documentation',
        content     => 'long long text',
    },
    '002-about' => {
        basename    => 'about',
        title       => 'about title',
        keywords    => [qw/key word here/], 
        description => 'outline of atout this website',
        content     => 'this site is ..',
    },
    '003-news' => {
        basename    => 'news',
        title       => 'news',
        keywords    => [qw/news/], 
        description => 'this is news ..',
        content     => 'news news news!!',
    },
);

my %menu_of = (
    '01-readme' => {
        order => '01',
        name  => 'README',
    },
    '02-setup' => {
        order => '02',
        name  => 'SETUP',
    },
    '03-security' => {
        order => '03',
        name  => 'SECURITY',
    },
);

sub get_archive {
    my $name = shift;
    Shaq::CMS::Archive->new( %{ $archive_of{$name} } );
}

sub get_menu {
    my $name = shift;
    Shaq::CMS::Menu->new( %{ $menu_of{$name} } );
}

1;

