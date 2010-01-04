package Shaq::Api::WebService::Youtube;
use strict;
use warnings;
use Shaq::Api::WebService::Youtube::User;
use Shaq::Api::WebService::Youtube::Feed;

sub new {
    my ( $class ) = @_;

    my $self = bless {
        _user  => Shaq::Api::WebService::Youtube::User->new,
        _feed  => Shaq::Api::WebService::Youtube::Feed->new,
    }, $class;
}

sub user  { $_[0]->{_user} }
sub feed  { $_[0]->{_feed} }

1;

__END__

=head1 NAME 

Shaq::Api::WebService::Youtube - Youtube API

=head1 METHODS

=head2 new

=head2 user

Youtubeのユーザープロフィールエントリは常に１エントリーである
ためAPIレスポンスのルートタグは<entry>となる。

この場合はXML::Feedでは解析できないためParserをXML::Simple
としたUserクラスを用意しています。

=head2 feed

XML::Feedで解析していますがOpenSearch要素<openSearch:totalResults>
やYouTube要素<yt:age>はXML::Feedでは解析できないため、これらは
XML::LibXMLを使って解析しています。

XML::LibXMLは解析したXML::Feed::Entry内に含まれているのでそこから
呼び出せます。

=cut


