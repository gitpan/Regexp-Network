use strict;
use warnings;
use Test::More tests => 8;

BEGIN
{
    use_ok 'Regexp::Network', qw/$ip_RE/;
}

while (<DATA>)
{
    my $ip = $_;
    chomp $ip;
    ok $ip !~ /^$ip_RE$/ => "$ip should not parse";
}

__DATA__
a.b.c.d
150.203.1159.52
256.0.1.3
0150.203.115.3
150.0203.115.3
af.bf.4.5
3.5.6.7.8
