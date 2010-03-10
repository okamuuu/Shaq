package Shaq::CMS::Menu;
use Mouse;
use MouseX::AttributeHelpers;

has order => ( is => 'ro', isa => 'Str', default => sub { [] }, );
has name  => ( is => 'ro', isa => 'Str', default => sub { [] }, );

has titles => (
    is         => 'rw',
    isa        => 'ArrayRef',
    metaclass  => 'Collection::Array',
    default    => sub { [] },
    provides   => { push => 'add_titles' },
);

has basenames => (
    is         => 'rw',
    isa        => 'ArrayRef',
    metaclass  => 'Collection::Array',
    default    => sub { [] },
    provides   => { push  => 'add_basenames' },
);

no Mouse;

### 必要になるまで極力呼ばない呼ばない
sub get_list {
    my ( $self ) = @_;

    my @titles    = @{ $self->titles };
    my @basenames = @{ $self->basenames };
    
    if ( scalar @titles != scalar @basenames ) {
        Carp::croak("titles and basename are differ in number");
    }

    ### FIXME: 野暮ったい
    my @list;
    for my $index ( 0 .. $#titles ) {
        push @list,
          { title => $titles[$index], basename => $basenames[$index] };
    }

    return [@list];  
}

sub add_list {
    my ( $self, $list ) = @_;

    Carp::croak("couldn't find param: '$list->{basename}'") unless $list->{basename};
    Carp::croak("couldn't find param: '$list->{title}'")    unless $list->{title};

    ### FIXME: もうちょいなんとかなるとは思うが
    my ( %is_exists_basename, %is_exists_title );
    Carp::croak("duplicate basename ...")
      if grep { $_ > 1 } map { ++$is_exists_basename{$_} } @{ $self->basenames };
    Carp::croak("duplicate title ...")
      if grep { $_ > 1 } map { ++$is_exists_title{$_} } @{ $self->titles };

    $self->add_titles( $list->{title} ); 
    $self->add_basenames( $list->{basename} ); 
    $self;
};

sub xhtml {
    my ( $self ) = @_;

    my $name  = $self->name; 
    my $order = $self->order;

    my $xhtml = qq{<!-- menu[start] -->\n};
    $xhtml   .= qq{<h3>$name</h3>\n};
    $xhtml   .= qq{<ul class="menu">\n};
    
    for my $list ( @{$self->get_list} ) {
        my $basename = $list->{basename}; 
        my $title    = $list->{title}; 
        
       $xhtml   .= qq{    <li><a href="$basename.html">$title</a></li>\n};
    } 
    $xhtml   .= qq{</ul>\n};
    $xhtml   .= qq{<!-- menu[end] -->\n};

}

__PACKAGE__->meta->make_immutable;

=head1 NAME

CMS::Lite::Category - store archive data into this class

=head1 DESCRIPTION

アーカイブを分類するためのクラス
Menuで使用するリストも内包する

=head1 METHODS

=cut




