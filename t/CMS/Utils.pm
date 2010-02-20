package t::CMS::Utils;
use strict;
use warnings;
use utf8;
use Perl6::Slurp;
use YAML::Syck;
use Shaq::CMS::Archive;
use Shaq::CMS::Menu;

my $CACHE;

sub get_archives {
    map { Shaq::CMS::Archive->new(%{$_}) } @{ _get_fixture('archives')->{archives} };
}

sub get_menus {
    map { Shaq::CMS::Menu->new(%{$_}) } @{ _get_fixture('menus')->{menus} };
}

sub _get_fixture {
    my ($target) = @_;

    $CACHE = Perl6::Slurp::slurp( \*DATA ) unless $CACHE;

    my $data = $CACHE
      or Carp::confess("Could not get data from __DATA__ segment");

    my @files = split /^__(.+)__\r?\n/m, $data;

    shift @files;
    while (@files) {
        my ( $name, $content ) = splice @files, 0, 2;

        if ( $target eq $name ) {
            return YAML::Syck::Load($content);
        }
    }

    return 0;
}

1;

## シチュエーション毎に分ける事を想定

__DATA__

__archives__
archives:
  - basename: index
    title: index title
    keywords:
      - some
        keywords
        here
    description: 'outline of this documentation'
    content: 'long long text'
  - basename: about
    title: 'about title'
    keywords: 
      - key 
        word
        here
    description: 'outline of atout this website'
    content: 'this site is ..'
  - basename: news
    title: news
    keywords:
      - news
    description: 'this is news ..'
    content: 'news news news!!'

__menus__
menus:
  - order: '01'
    name: README
  - order: '02'
    name: SETUP
  - order: '03'
    name: SECURITY

