#!/usr/bin/perl -w

use Test::More;
use Test::Exception;

use LINZ::Config;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
$year+=1900;
$mon+=1;

my $cfg = new LINZ::Config; # reads Config.cfg (default path follows executable name)

# Test built-in variables

ok($cfg->has('_runtime'), 'has _runtime');
is($cfg->_runtime, sprintf("%d%02d%02d%02d%02d%02d",
  $year, $mon, $mday, $hour, $min, $sec), '_runtime is correct');
ok($cfg->has('_runtimestr'), 'has _runtimestr');
is($cfg->_runtimestr, sprintf("%d-%02d-%02d %02d:%02d:%02d",
  $year, $mon, $mday, $hour, $min, $sec), '_runtimestr is correct');
ok($cfg->has('_year'), 'has _year');
is($cfg->_year, $year, "_year is correct");
ok($cfg->has('_month'), 'has _month');
is($cfg->_month, sprintf("%02d", $mon), '_month is correct');
ok($cfg->has('_day'), 'has _day');
is($cfg->_day, sprintf("%02d", $mday), '_day is correct');
ok($cfg->has('_hour'), 'has _hour');
is($cfg->_hour, sprintf("%02d", $hour), '_hour is correct');
ok($cfg->has('_minute'), 'has _minute');
is($cfg->_minute, sprintf("%02d", $min), '_minute is correct');
ok($cfg->has('_second'), 'has _second');
is($cfg->_second, sprintf("%02d", $sec), '_second is correct');
ok($cfg->has('_configdir'), 'has _configdir');
is($cfg->_configdir, 't', '_configdir is correct');
ok($cfg->has('_homedir'), 'has _homedir');
is($cfg->_homedir, 't', '_homedir is correct');
ok($cfg->has('_config_file'), 'has _config_file');
is($cfg->_config_file, 't/Config.cfg', '_config_file is correct');
ok($cfg->has('_hostname'), 'has _hostname');
is($cfg->_hostname, Sys::Hostname::hostname(), '_hostname is correct');

# Test values access via ->

is($cfg->k1, 'v1', 'reads single-word value (k1)');
is($cfg->k1('def'), 'v1', 'reads single-word value not applying default (k1)');
is($cfg->k2, 'v2 has spaces', 'reads multi-word value (k2)');
is($cfg->k3, "v3\nis\nmultiline\n", 'reads multi-line value (k3)');
is($cfg->k4, 'v4 appears twice', 'reads overridden value (k4)');
is($cfg->k5, 'v5 has # no comment', 'reads value with hash char (k5)');
is($cfg->K4, 'V4', 'case sensitive by default (K4)');
is($cfg->krefrefref, 'v1 ref ref ref', 'recursively resolves refs');

# Test accessing missing key

throws_ok { $cfg->kmissing }
  qr/Configuration item "kmissing" is missing/,
  'missing key caught';
ok(! $cfg->has('kmissing'), 'knows when key does not exist (kmissing)' );
is($cfg->kmissing('def'), 'def', 'applies default to missing key (kmissing)');
ok($cfg->has('kmissing'), 'missing key is created after getting with default (kmissing)' );
is($cfg->kmissing, 'def', 'missing key has assigned-default value' );

# Void key

is($cfg->kvoid, undef, 'reads key with no value (kvoid)');
ok($cfg->has('kvoid'), 'knows key with no value exists' );
is($cfg->kvoid('def'), undef, 'does not assign a default to value-less key (kvoid)');

# Test case-insensitive operations

my $options = { _case_sensitive=>0, };
$cfg = new LINZ::Config( $options );
is($cfg->k4, 'V4', 'case insensitive if requested (k4)');
is($cfg->K4, 'V4', 'case insensitive if requested (K4)');
ok($cfg->has('k4'), 'has k4');
ok($cfg->has('K4'), 'has K4');
ok($cfg->has('k5'), 'has k5');
ok($cfg->has('K5'), 'has K5 (case-insensitive)');

# Test custom configpath

$options = { _configpath=>'~/Config.cfg.extra', };
$cfg = new LINZ::Config( $options );
is($cfg->k4, 'k4 extra', 'reads k4 in extra');
ok(! $cfg->has('k1'), 'extra config has no k1');

# Test extra config

$options = { _configextra=>'extra', };
$cfg = new LINZ::Config( $options );
is($cfg->k1, 'v1', 'finds k1 in base config');
is($cfg->k4, 'k4 extra', 'k4 in extra overrides base config');
is($cfg->K4, 'V4', 'K4 is found in base config');

# Test reload with alternative options

TODO: {
  local $TODO = "See https://github.com/linz/linz_utils_perl/issues/13";
$cfg = new LINZ::Config;
is($cfg->k4, 'v4 appears twice', 'k4 from base config (reload)');
$cfg->reload( { _casesensitive=>0 } );
is($cfg->k4, 'V4', 'k4 insensitive from base config (reload)');
$cfg->reload( { _configextra=>'extra' } );
is($cfg->k4, 'k4 extra', 'k4 insensitive from extra config (reload)');
is($cfg->K4, 'V4', 'K4 from base config (case-sensitive, reload)');
$cfg->reload( { _configextra=>'extra', _casesensitive=>0 } );
is($cfg->K4, 'k4 extra', 'K4 from extra config (case-insensitive, reload)');
}

done_testing();
