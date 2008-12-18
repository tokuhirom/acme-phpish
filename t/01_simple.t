use strict;
use warnings;
use Test::More tests => 4;

{
    eval q{ use Acme::PHPish; [];};
    my $e = $@;
    ok $e;
    like $e, qr/php doesn't have a array constructor/;
}

{
    my $ret = eval q{ use Acme::PHPish; array(1,2,3)};
    my $e = $@;
    ok !$e, $e;
    is_deeply $ret, [qw/1 2 3/];
}

