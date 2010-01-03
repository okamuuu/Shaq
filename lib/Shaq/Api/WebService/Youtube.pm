package Shaq::Api::WebService::Youtube;
use strict;
use warnings;
use base qw/Shaq::Api::WebService::Base/;

our $DEBUG=0;

sub new {
    my ( $class, $config ) = @_;
    my $self = $class->SUPER::new( %$config,
        parser   => "XML::Feed",
        base_url => "http://gdata.youtube.com/feeds/api/" );
}

sub parse {
    my ( $self, $path, $attr  ) = @_;

    my $feed = $self->SUPER::parse( $path, $attr );

    if ( $DEBUG ) {
        require XML::Simple; import XML::Simple;
        require Data::Dumper; import Data::Dumper;
        warn Dumper XMLin($feed->as_xml)
    }
    return $feed;
}

sub subscriptions {
    my ( $self, $username, $attr ) = @_;
    
    $attr->{order_by} ||= "published";
    my $feed = $self->parse( "/users/$username/subscriptions", $attr );
    my @subscriptions;
    for my $entry ( $feed->entries ) {
        push @subscriptions, $entry->{entry}->{elem}->getChildrenByTagName( 'yt:username' )->string_value;
    }
    return [@subscriptions];
}

sub videos {
    my ( $self, $cond, $attr ) = @_;

    my $page  = $attr->{page} || 1;
    my $limit = $attr->{"max-results"} ||= 10;

    $attr->{"start-index"} = ( $page - 1 ) * $limit + 1;
    $attr->{orderby} ||= "published";

    ### データ取得
    my $feed = $self->parse( "/videos", {%$cond, %$attr} );

    ### 最大件数を取得
    my $total = $feed->{atom}->{elem}->getElementsByTagName( 'openSearch:totalResults' )->string_value;

    ### Pagerオブジェクトを生成
    my $pager = $self->pager->make( $total, $limit, $page );

    ### XML::Feed::Entry::Format::Atom -> Hash
    my $videos = $self->feed2videos( $feed );

    return ( $videos, $pager );    
}

sub feed2videos {
    my ( $self, $feed ) = @_;

    my @videos;
    for my $entry ( $feed->entries ) {
    
        ### idを取得
        my $id = $entry->id;
        $id =~ s{http://gdata.youtube.com/feeds/api/videos/([^/]+)$}{$1};
        
        my $thumbnail   = $entry->{entry}->{elem}->getElementsByTagName('media:thumbnail')->[0];
        my $thum_url    = $thumbnail->getAttributeNode( "url" )->value;
        my $thum_width  = $thumbnail->getAttributeNode( "width" )->value;
        my $thum_height = $thumbnail->getAttributeNode( "height" )->value;
        my $published   = $entry->{entry}->{elem}->getElementsByTagName('published')->string_value;
        my @keywords    = split ', ', $entry->{entry}->{elem}->getElementsByTagName('media:keywords')->string_value;

        my $video = {
            id          => $id,
            title       => $entry->title,
            content     => $entry->content->body,
            thum_url    => $thum_url,
            thum_width  => $thum_width,
            thum_height => $thum_height,
            published   => $published,
            keywords    => [@keywords],
        };
        push @videos, $video;
    }
    return [@videos];
}

1;

