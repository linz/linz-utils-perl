#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Exception;
use File::Temp qw/ tempfile /;

use LINZ::Log;

my ($logfh, $logfname) = tempfile( '/tmp/Log.t-out-XXXX', UNLINK=>1);

ok(my $log = LINZ::Log->new($logfname, {level => 'DEBUG'}),
  "can create new log");

ok( $log->info("Some information"), "can write info" );
ok( $log->warn("Warning message"), "can write warning" );
ok( $log->debug("Debugging information"), "can write debug" );

throws_ok {
  $log->die("Goodbye");
} qr/Goodbye/, 'dies with message on log->die';

# Closing logs as a workaround lack of flush control in logger module
# see https://github.com/linz/linz_utils_perl/issues/15
# Could alternatively use this hack: $log->{fh}->autoflush(1);
$log->close();

my $line;
$line = <$logfh>;
like( $line, qr/INFO: Some information/, "wrote info correctly" );
$line = <$logfh>;
like( $line, qr/WARN: Warning message/, "wrote warning correctly" );
$line = <$logfh>;
like( $line, qr/DEBUG: Debugging information/, "wrote debug correctly" );
$line = <$logfh>;
like( $line, qr/ERROR: Goodbye/, "wrote fatal correctly" );

# TODO: test level, rotate_log, rotate_size

done_testing(9);
