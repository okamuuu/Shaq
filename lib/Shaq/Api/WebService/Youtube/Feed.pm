package Shaq::Api::WebService::Youtube::Feed;
use strict;
use warnings;
use base qw/Shaq::Api::WebService::Base/;
use Data::Page;

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

    ### データ構造をhash-refとして解析する場合に使用する
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

    ### Pagerオブジェクト
    my $pager = $self->pager;
    $pager->total_entries( $total );
    $pager->entries_per_page( $limit );
    $pager->current_page( $page );

    return ( [$feed->entries], $pager );    
}

1;

=head1 NAME

Shaq::Api::WebService::Youtube::Feed - Youtube API 

=head1 METHODS

=head2 new

=head2 parse

=head2 subscriptions

=head2 videos



