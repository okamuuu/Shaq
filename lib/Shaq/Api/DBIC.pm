package Shaq::Api::DBIC;
use strict;
use warnings;
use Carp 'croak';
use IO::File;
use UNIVERSAL::require;
use Shaq::Api::DBIC::Profile;

=head1 METHODS

=head2 new

=head2 get_master_schema

=head2 get_slave_schema

=cut

sub new {
    my ( $class, $config ) = @_;

    croak( 'Please set $config->{master}->{schema_class}' ) unless $config->{master}->{schema_class};
    croak( 'Please set $config->{master}->{connect_info}' ) unless $config->{master}->{connect_info};
    croak( 'Please set $config->{slave}->{schema_class}' ) unless $config->{slave}->{schema_class};
    croak( 'Please set $config->{slave}->{connect_info}' ) unless $config->{slave}->{connect_info};
    
    my $self = bless {
        _config  => $config,
        _profile => Shaq::Api::DBIC::Profile->new,
    }, $class;
    return $self;
}

sub config  { $_[0]->{_config}  }
sub profile { $_[0]->{_profile} }

sub get_master_schema {
    my ($self) = @_;

    my $schema_class = $self->config->{master}->{schema_class};
    $schema_class->require;
    
    my @connect_info = @{ $self->config->{master}->{connect_info} };
    my $schema       = $schema_class->connect(@connect_info);

    if ( $self->config->{master}->{log_mode} ) {
        my $fh =
          IO::File->new( $self->config->{master}->{query_log_path}, 'a' );
        $schema->storage->debug(1);
        $schema->storage->debugobj( $self->profile );
        $schema->storage->debugfh($fh);
    }

    return $schema;
}

sub get_slave_schema {
    my ( $self ) = @_;
    
    my $schema_class  = $self->config->{slave}->{schema_class};
    $schema_class->require;

    my @connect_info  = @{ $self->config->{slave}->{connect_info} };
    my $schema = $schema_class->connect( @connect_info ); 
    
    if ( $self->config->{slave}->{log_mode} ) {
        my $fh = IO::File->new( $self->config->{slave}->{query_log_path}, 'a' );
        $schema->storage->debug(1);
        $schema->storage->debugobj($self->profile);
        $schema->storage->debugfh( $fh );
    }

    return $schema;
}

sub pager {
    my ( $self, $pager, $displayable_block ) = @_;

    ### 一度に表示させるブロック。指定が無ければ11
    $displayable_block ||=  11;

    ### 1番左側に表示されるページ数
    $pager->{first_visible_page} =
      $pager->current_page - int( ( $displayable_block - 1 ) / 2 );
    $pager->{first_visible_page} = 1 if $pager->{first_visible_page} < 1;

    ### 1番右側に表示されるページ数
    $pager->{last_visible_page} =
      $pager->current_page + int( $displayable_block / 2 );
    $pager->{last_visible_page} = $pager->last_page
      if $pager->{last_visible_page} > $pager->last_page;

    ### 表示されるページの配列
    $pager->{visible_pages} =
      [ $pager->{first_visible_page} .. $pager->{last_visible_page} ];

    ### 複数ページでない場合
    if ( $pager->{first_visible_page} == $pager->{last_visible_page} ) {
        $pager->{single_page} = 1;
    }

    ### 受け取った$pagerに上記の情報を加えてから返す
    return $pager
}

1;

