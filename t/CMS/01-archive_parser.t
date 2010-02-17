use strict;
use warnings;
use Test::Base;
plan tests => 1 * blocks;

use Shaq::CMS::ArchiveParser;
use Shaq::CMS::ArchiveParser::Trac;

my $parser = Shaq::CMS::ArchiveParser->new( parser => Shaq::CMS::ArchiveParser::Trac->new );

sub test_method {
    my $archive = $parser->parse( basename => 'filename', text => $_[0] );

    my $result = {
        basename    => $archive->basename,
        title       => $archive->title,
        keywords    => $archive->keywords,
        description => $archive->description,
#        content     => $archive->content,
    };
}

filters {
    i => [ 'test_method' ],
    e => [ 'yaml'],
};

run_is_deeply 'i' => 'e';

=pod yamlでundef返す方法が分からないという

=== # descriptionが存在しない
--- i
= head1 =

''test''です。''em''は''強調''です。

== heading2 ==
--- e
basename: filename
title: head1
keywords: 
  - test
  - em
  - 強調
description: 

=== # keywordsが存在しない
--- i
= head1 =


== heading2 ==
--- e
basename: filename
title: head1
keywords: []
description: 

=cut

__END__

=== # description keywordsが存在する
--- i
= test見出し1 =

'''''概要はdescriptionとして認識'''''

== heading2 ==

''test''です!!''test''です!!''em''は''強調''です。

--- e
basename: filename
title: test見出し1
keywords: 
  - test
  - em
  - 強調
description: 概要はdescriptionとして認識





