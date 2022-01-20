#!/usr/bin/env bash

set -o errexit -o noclobber -o nounset -o pipefail
shopt -s failglob inherit_errexit



cd "$(dirname "$0")"

perl Build.PL
test $? = 0 || exit 1

./Build distmeta # builds Makefile.PL (among other things)
test $? = 0 || exit 1

./Build manifest # builds MANIFEST
test $? = 0 || exit 1

perl Makefile.PL
test $? = 0 || exit 1

# Append custom rules
cat <<EOF >> Makefile
deb:
	dpkg-buildpackage -b -us -uc

check:
	perl Build test \${RUNTESTFLAGS}
EOF
