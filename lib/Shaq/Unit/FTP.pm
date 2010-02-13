package Shaq::Unit::FTP;
use strict;
use warnings;
use Net::FTP;

sub new {
    my ( $class, $config ) = @_;

    my $hostname  = $config->{hostname} or Carp::croak("Please set param: hostname ...");
    my $username  = $config->{username} or Carp::croak("Please set param: username ...");
    my $password  = $config->{password} or Carp::croak("Please set param: password ...");

    my $self = bless {
        _hostname   => $hostname,
        _username   => $username,
        _password   => $password,
    }, $class;

    return $self;
}

sub hostname   { $_[0]->{_hostname} }
sub username   { $_[0]->{_username} }
sub password   { $_[0]->{_password} }

sub upload {
    my ( $self, $local_dir, $remote_dir ) = @_;

    Carp::croak("the client_dir must be Path::Class::Dir.")
      unless $local_dir->isa('Path::Class::Dir');
  
    Carp::croak("the server_dir must be Path::Class::Dir.")
      unless $remote_dir->isa('Path::Class::Dir');

    my $hostname = $self->hostname; 
    my $username = $self->username;
    my $password = $self->password;
 
    my $ftp = Net::FTP->new( $hostname, Debug => 0)
      or die "Cannot connect to $hostname: $@";

    $ftp->login($username, $password)
      or die "Cannot login ", $ftp->message;

    $ftp->cwd( "/" )
      or die "Cannot change working directory ", $ftp->message;

    ### mkdir ( DIR [, RECURSE ])
    $ftp->mkdir($remote_dir->stringify, 1)
      or die "mkdir failed ", $ftp->message;

    $ftp->cwd($remote_dir->stringify)
      or die "Cannot change working directory ", $ftp->message;

    for my $child ( $local_dir->children ) {
        next if $child->is_dir;
        $ftp->put( $child->stringify, $child->basename );
    }

    $ftp->quit;

}

1;

__END__
 
=head1 NAME

Shaq::Unit::FTP - Unit

=head1 METHODS

=head2 new

=head2 hostname

=head2 username

=head2 password

=head2 upload


