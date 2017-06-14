#!/usr/bin/perl -w

use Test::More;
use Test::Exception;

use LINZ::Config;

my $cfg = new LINZ::Config; # reads Config.cfg (default path follows executable name)

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

# SKIP: {
#   my $TODO = <<EOT;
# handling of value-less keys is bogus,
# see https://github.com/linz/linz_utils_perl/issues/12
# EOT
#   is($cfg->kvoid('def'), 'def', 'applies default to no-value key (kvoid)');
# }

# Test case-insensitive operations

my $options = { _case_sensitive=>0, };
$cfg = new LINZ::Config( $options );
is($cfg->k4, 'V4', 'case insensitive if requested (k4)');
is($cfg->K4, 'V4', 'case insensitive if requested (K4)');
ok($cfg->has('k4'), 'has k4');
ok($cfg->has('K4'), 'has K4');
ok($cfg->has('k5'), 'has k5');
ok($cfg->has('K5'), 'has K5 (case-insensitive)');

done_testing();
