package Acme::PHPish;

use strict;
use warnings;
our $VERSION = '0.01';
BEGIN {
    require B::OPCheck;
};

sub import {
    my ( $class,) = @_;

    my $opname = 'anonlist';
    my $mode = 'check';
    my $sub = sub {
        die "php doesn't have a array constructor";
    };

    $^H |= 0x120000;  # set HINT_LOCALIZE_HH + an unused bit to work around a %^H bug

    my $by_opname = $^H{OPCHECK_leavescope} ||= {};
    my $guards    = $by_opname->{$opname}   ||= [];
    push @$guards, Scope::Guard->new(
        sub {
            no strict 'refs';
            &{"B::OPCheck::leavescope"}( $opname, $mode, $sub );
        }
    );

    no strict 'refs';
    &{"B::OPCheck::enterscope"}( $opname, $mode, $sub );

    my $pkg = caller(0);
    *{"${pkg}::array"} = *{"${class}::_array"};
}

sub unimport {
    my ( $class, $opname ) = @_;

    if ( defined $opname ) {
        my $by_opname = $^H{OPCHECK_leavescope};
        delete $by_opname->{$opname};
        return if scalar keys %$by_opname;    # don't delete other things
    }

    delete $^H{OPCHECK_leavescope};
    $^H &= ~0x120000;
}

sub _array {
    [@_]
}

1;
__END__

=head1 NAME

Acme::PHPish -

=head1 SYNOPSIS

    use Acme::PHPish;
    [qw/1 2 3/]; # => syntax error in compile time

    array(1,2,3); # ok!

=head1 DESCRIPTION

PHP is friendly with newbies.PHP has array() function but PHP doesn't have a anonymous arrayref constructor syntax.
Anonymous arrayref constructor is not a friendly with newbies??

=head1 AUTHOR

Tokuhiro Matsuno E<lt>tokuhirom jsdfkla gmail fsadkjl comE<gt>

=head1 SEE ALSO

L<PHP>, L<B:OPCheck>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
