# $Id: live-tests.t,v 1.2 2007/03/16 15:34:35 drhyde Exp $
use strict;

my $warning;
BEGIN {
    $^W=1;
    $SIG{__WARN__} = sub {
        $warning = join('', @_);
        die("Caught a warning, making it fatal:\n$warning\n")
            if($warning !~ /^Net::Random: /);
    };
}

use Test::More tests => 12;
use Net::Random;

my $r;

my %dist = ();
$r = Net::Random->new(src => 'random.org');
$warning = '';
my @data = $r->get(512);
SKIP: {
    skip "not enough random bytes", 2 if($warning);
    %dist = (); $dist{$_}++ foreach (@data);
    ok(!(grep { $_ < 0 || $_ > 255 } @data), "generates bytes in correct range (0-255)");
    ok(!(grep { $_ > 10 } values %dist), "distribution looks sane");
}

$r = Net::Random->new(min => 1, max => 6, src => 'random.org');
$warning = '';
@data = $r->get(128);
SKIP: {
    skip "not enough random bytes", 2 if($warning);
    %dist = (); $dist{$_}++ foreach (@data);
    ok(!(grep { $_ < 1 || $_ > 6 } @data), "generates bytes in correct range (1-6)");
    ok(!(grep { $_ > 35 } values %dist), "distribution looks sane");
    # print "[".join(' ', @data)."]\n";
}

$r = Net::Random->new(min => 301, max => 306, src => 'random.org');
$warning = '';
@data = $r->get(128);
SKIP: {
    skip "not enough random bytes", 2 if($warning);
    %dist = (); $dist{$_}++ foreach (@data);
    ok(!(grep { $_ < 301 || $_ > 306 } @data), "generates bytes in correct range (301-306)");
    ok(!(grep { $_ > 35 } values %dist), "distribution looks sane");
    # print "[".join(' ', @data)."]\n";
}

$r = Net::Random->new(max => 300, src => 'random.org');
$warning = '';
@data = $r->get(1024);
SKIP: {
    skip "not enough random bytes", 2 if($warning);
    %dist = (); $dist{$_}++ foreach (@data);
    ok(!(grep { $_ < 0 || $_ > 300 } @data), "generates bytes in correct range (0-300)");
    ok(!(grep { $_ > 15 } values %dist), "distribution looks sane");
    # print "[".join(' ', @data)."]\n";
}

$r = Net::Random->new(max => 70000, src => 'random.org');
$warning = '';
@data = $r->get(10240);
SKIP: {
    skip "not enough random bytes", 2 if($warning);
    %dist = (); $dist{$_}++ foreach (@data);
    ok(!(grep { $_ < 0 || $_ > 70000 } @data), "generates bytes in correct range (0-70000)");
    ok(!(grep { $_ > 6 } values %dist), "distribution looks sane");
    # print "[".join(' ', @data)."]\n";
}

$r = Net::Random->new(max => 2 ** 30, src => 'random.org');
$warning = '';
@data = $r->get(1024);
SKIP: {
    skip "not enough random bytes", 2 if($warning);
    %dist = (); $dist{$_}++ foreach (@data);
    ok(!(grep { $_ < 0 || $_ > 2 ** 30 } @data), "generates bytes in correct range (0-2^30)");
    ok(!(grep { $_ > 2 } values %dist), "distribution looks sane");
    # print "[".join(' ', @data)."]\n";
}
