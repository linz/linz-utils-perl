#!/usr/bin/perl -w

use Test::More;
use Test::Exception;

use LINZ::Config;

my $cfg = new LINZ::Config; # reads t/Config.cfg (default path)

is($cfg->k1, 'v1', 'reads single-word value (k1)');
is($cfg->k1('def'), 'v1', 'reads single-word value not applying default (k1)');
is($cfg->k2, 'v2 has spaces', 'reads multi-word value (k2)');
is($cfg->k3, "v3\nis\nmultiline\n", 'reads multi-line value (k3)');
is($cfg->k4, 'v4 appears twice', 'reads overridden value (k4)');
is($cfg->k5, 'v5 has # no comment', 'reads value with hash char (k5)');

throws_ok { $cfg->kmissing }
  qr/Configuration item "kmissing" is missing/,
  'missing key caught';
ok(! $cfg->has('kmissing'), 'knows when key does not exist (kmissing)' );
is($cfg->kmissing('def'), 'def', 'applies default to missing key (kmissing)');

is($cfg->kvoid, undef, 'reads key with no value (kvoid)');
ok($cfg->has('kvoid'), 'knows key with no value exists' );

# SKIP: {
#   my $TODO = <<EOT;
# handling of value-less keys is bogus,
# see https://github.com/linz/linz_utils_perl/issues/12
# EOT
#   is($cfg->kvoid('def'), 'def', 'applies default to no-value key (kvoid)');
# }

done_testing();
