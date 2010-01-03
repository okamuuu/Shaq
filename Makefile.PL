use inc::Module::Install;

name     'Shaq';
all_from 'lib/Shaq.pm';
author   'okamura <okamuuuuu@gmail.com>';
license  'perl';

requires 'Carp';
requires 'Devel::NYTProf'
requires 'UNIVERSAL::require';

build_requires 'Test::More';

auto_install;

WriteAll;



