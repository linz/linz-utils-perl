#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail
shopt -s failglob inherit_errexit



cd "$(dirname "$0")"

perl Build.PL

./Build distmeta # builds Makefile.PL (among other things)

./Build manifest # builds MANIFEST

perl Makefile.PL

# Append custom rules
cat <<EOF >> Makefile
check:
	perl Build test \${RUNTESTFLAGS}
EOF
