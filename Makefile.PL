use inc::Module::Install;

name     'Shaq';
all_from 'lib/Shaq.pm';
author   'okamura <okamuuuuu@gmail.com>';
license  'perl';

requires 'FCGI::Client'
requires 'Carp';
requires 'Devel::NYTProf'
requires 'UNIVERSAL::require';
requires 'Test::MicroTemplate::File';
requires 'XML::LibXML';
requires 'XML::Feed';

build_requires 'Test::More';

auto_install;

WriteAll;



