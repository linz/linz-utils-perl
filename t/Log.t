#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Exception;
use File::Temp qw/ tempfile /;

use LINZ::Log;

my ($fh, $logfname) = tempfile( '/tmp/Log.t-out-XXXX', UNLINK=>1);
my $line;

# Test log with DEBUG level

ok(my $log = LINZ::Log->new($logfname, {level => 'DEBUG'}),
  "can create debug-level log");
ok( $log->debug("1"), "can write debug to debug-level log" );
ok( $log->info("2"), "can write info to debug-level log" );
ok( $log->warn("3"), "can write warning to debug-level log" );
throws_ok { $log->die("4"); } qr/^4$/, 'dies with message on log->die';
# Closing logs as a workaround lack of flush control in logger module
# see https://github.com/linz/linz_utils_perl/issues/15
# Could alternatively use this hack: $log->{fh}->autoflush(1);
$log->close();
$line = <$fh>; like( $line, qr/DEBUG: 1$/, "found debug in debug-level log" );
$line = <$fh>; like( $line, qr/INFO: 2$/, "wrote info correctly" );
$line = <$fh>; like( $line, qr/WARN: 3$/, "wrote warning correctly" );
$line = <$fh>; like( $line, qr/ERROR: 4$/, "wrote fatal correctly" );

# Test log with INFO level
ok($log = LINZ::Log->new($logfname, {level => 'INFO'}),
  "can create log with level INFO");
ok( ! $log->debug("1"), "can not write debug to info-level log" );
ok( $log->info("2"), "can write info to info-level log" );
ok( $log->warn("3"), "can write info to info-level log" );
throws_ok { $log->die("4"); } qr/4/, 'dies with message on log->die';
$log->close();
$line = <$fh>; like( $line, qr/INFO: 2/, "found info in info-level log" );
$line = <$fh>; like( $line, qr/WARN: 3/, "found warn in info-level log" );
$line = <$fh>; like( $line, qr/ERROR: 4/, "found error in info-level log" );

# Test log with WARNING level
ok($log = LINZ::Log->new($logfname, {level => 'WARN'}),
  "can create log with level WARN");
ok( ! $log->debug("1"), "can not write debug to warn-level log" );
ok( ! $log->info("2"), "can not write info to warn-level log" );
ok( $log->warn("3"), "can write info to warn-level log" );
throws_ok { $log->die("4"); } qr/4/, 'dies with message on log->die';
$log->close();
$line = <$fh>; like( $line, qr/WARN: 3/, "found warn in warn-level log" );
$line = <$fh>; like( $line, qr/ERROR: 4/, "found error in warn-level log" );

# Test log with ERROR level
ok($log = LINZ::Log->new($logfname, {level => 'ERROR'}),
  "can create log with level ERROR");
ok( ! $log->debug("1"), "can not write debug to error-level log" );
ok( ! $log->info("2"), "can not write info to error-level log" );
ok( ! $log->warn("3"), "can write info to error-level log" );
throws_ok { $log->die("4"); } qr/4/, 'dies with message on log->die';
$log->close();
$line = <$fh>; like( $line, qr/ERROR: 4/, "found error in error-level log" );
$line = <$fh>; is( $line, undef ); # EOF

# TODO: rotate_log, rotate_size

done_testing(31);
