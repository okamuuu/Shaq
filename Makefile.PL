use inc::Module::Install;

name     'Shaq';
all_from 'lib/Shaq.pm';
author   'okamura <okamuuu@gmail.com>';
license  'perl';

requires 'DBI';
requires 'Carp';
requires 'Devel::NYTProf';
requires 'UNIVERSAL::require';
requires 'XML::LibXML';
requires 'XML::Feed';
requires 'Path::Class';
requires 'Hash::MultiValue';
requires 'YAML';
requires 'Router::Simple';
requires 'UNIVERSAL::require';

requires 'parent';
requires 'Plack::Test';
requires 'Test::Memcached';
requires 'Test::mysqld';

requires 'Test::Perl::Critic';
requires 'Test::Base';
requires 'Test::Harness';
requires 'Test::Pod';
requires 'Test::Requires';
requires 'Test::Most';

build_requires 'Test::More';
auto_include;
WriteAll;
