#!/usr/bin/perl
use strict;
use warnings;
use Cwd;
use FindBin qw/$Bin/;
use Path::Class qw/dir file/;

my %argv;
use App::Options (
    values => \%argv,
    option => { 
        script => {
            type=>"string",
            required => 1,
        },
    },
);

my $script = $argv{script};

warn my $src  = file( getcwd(), 'eg', $script )->stringify;
warn my $out  = file( getcwd(), 'nytprof.out' )->stringify; 
warn my $html = dir(  getcwd(), 'nytprof' )->stringify; 

system("perl -d:NYTProf $src");
system( "nytprofhtml --out=$html" );
unlink $out;

exit();


