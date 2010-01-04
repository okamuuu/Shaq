package Shaq::Tools;
use strict;
use warnings;
use Cwd;
use FindBin qw/$Bin/;
use Path::Class;
use Test::Harness;
use List::Util 'shuffle';
use FindBin qw($Bin);
use Sys::Hostname(); 

our $VERSION = '0.01';

=head1 NAME

Shaq::Tools - The great new Shaq::Tools!

=head1 METHODS

=head2 run

=cut

sub run {
    my @test_files = @_;

    ### t/以下の.tを全て探す
    ### ここはもっと良い処理がある気も
    unless ( @test_files ) {
        my $cb = sub {
            my $f = shift;
            return if $f->is_dir;
            return unless $f =~ /\.t$/;
            return if $f =~ /98_perlcritic\.t$/ && $ENV{NO_PERLCRITIC};
            push @test_files, $f->stringify;
        };

        ### getcwdは実行したファイルの位置ではなく、実行した場所を返してくれる
        dir( getcwd, 't')->recurse( callback => $cb );
#        dir( $Bin, '..',  't')->recurse( callback => $cb );

        @test_files = shuffle @test_files; # ほう、混ぜる？
    }

    my $harness = TAP::Harness->new(
        {
            verbosity => 1,
            lib       => [ 'lib', 'blib/lib', 'blib/arch' ],
            color     => 1
        }
    );
    
    $harness->runtests(@test_files);
}


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Shaq::Tools;

    my $foo = Shaq::Tools->new();
    ...

=head1 FUNCTIONS

=head1 AUTHOR

okamura, C<< <okamuuuuu at gmail.com> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 okamura, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Shaq::Tools
