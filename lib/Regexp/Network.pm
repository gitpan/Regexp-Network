package Regexp::Network;

=head1 NAME

Regexp::Network - some useful routines for the DHCP bits and pieces.

=head1 SYNOPSIS

   use Regexp::Network;

   print "$ip is valid!" if $ip =~ $ip_RE;

   my (@macs) = ($data =~ /\b($mac_RE)\b/g);
   @macs = map { cleanether($_) } @macs;

=head1 DESCRIPTION

Provide useful routines and constants and stuff for analysing assorted
network log files and data.

=cut

use 5.006;
use strict;
use warnings;
use Carp;
use Exporter ();
use Memoize;

=head1 EXPORTATIONS

As an Exporter, it provides (optionally):

=over 4

=cut

our @ISA = qw/Exporter/;
our ( $VERSION ) = '$Revision: 1.3 $ ' =~ /\$Revision:\s+([^\s]+)/;

our %EXPORT_TAGS = ( 'all' => [ qw/cleanether $ip_RE $mac_RE/ ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw();

memoize('cleanether');

=item $ip_RE

Matches an IP address. Mostly useful for extracting IPs from log files
or validating them. e.g.

	print "IP is valid!" if ($ip =~ /$ip_RE/);

It has weaknesses, but it will at least limit things to 0-255 rather
than allowing 354.543.551.79485 as a valid IP. Has problems with things
like 0123.01.5.6 (leading zeroes).

=cut

#(?!0+\.0+\.0+\.0+\s)
our $ip_RE = qr/
	      (?:[01]?\d\d?|2[0-4]\d|25[0-5])
	    \.(?:[01]?\d\d?|2[0-4]\d|25[0-5])
	    \.(?:[01]?\d\d?|2[0-4]\d|25[0-5])
	    \.(?:[01]?\d\d?|2[0-4]\d|25[0-5])
	    /xo;

=item $mac_RE

Matches a MAC address. Either ':' or '-' separated. Either with leading
zeroes, or without. Case insensitive. Once pulled, you can use
cleanether on it to turn it into the canonical form.

	print "MAC is valid!" if ($mac =~ /$mac_RE/);

=cut

our $mac_RE = qr/(?:[\dA-Fa-f]{1,2}[: -]){5}[\dA-Fa-f]{1,2}/ox; # mac address

=item cleanether()

Cleans ethernet hardware addresses (MACs) into the preferred canonical
form. This routine follows design by contract principles and dies if the
MAC address is not parsable by C<$mac_RE>, hence only pass suitable
stuff in.

    $clean_MAC = cleanether($dirty_MAC);

=cut

sub cleanether
{
    my $data = shift;
    croak "MAC address [$data] invalid." unless $data =~ /^$mac_RE$/;
    $data =~ s/[ -]/:/g; # convert '-' to ':' since i'm inconsistent
    $data = lc $data;
    # insert zeros
    1 while $data =~ s/:([\da-f]):/:0$1:/g;
    $data =~ s/^([\da-f]):/0$1:/;
    $data =~ s/:([\da-f])$/:0$1/;
    return $data;
}

1;

#
# ========================================================================
#                                                Rest Of The Documentation

=back

=head1 AUTHOR

Iain Truskett <spoon@cpan.org> L<http://eh.org/~koschei/>

Please report any bugs, or post any suggestions, to either the mailing
list at <cpan@dellah.anu.edu.au> (email
<cpan-subscribe@dellah.anu.edu.au> to subscribe) or directly to the
author at <spoon@cpan.org>

=head1 PLANS

Impove ip_RE for leading noughts, and such like.

=head1 COPYRIGHT

Copyright (c) 2002 Iain Truskett. All rights reserved. This program is
free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

    $Id: Network.pm,v 1.3 2002/04/05 07:56:05 koschei Exp $

=head1 ACKNOWLEDGEMENTS

None really. Just happened to need the facilities of this module.

=head1 SEE ALSO

L<Memoize>

