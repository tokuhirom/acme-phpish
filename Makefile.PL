use inc::Module::Install;
name 'Acme-PHPish';
all_from 'lib/Acme/PHPish.pm';

requires 'B::OPCheck' => 0.27;

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
