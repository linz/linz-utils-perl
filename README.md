[![Actions Status](https://github.com/linz/linz_utils_perl/workflows/test/badge.svg?branch=master)](https://github.com/linz/linz_utils_perl/actions)

# LINZ Util Perl Package

Contains Modules to preform simple logging to file and load configuration information from a
configuration file.

## Simple install

```shell
perl Build.PL
./Build install
```

## Advanced install options

The build system is using perl Module::Build. A full list of the building options are available run:

```shell
./Build help
```

A more complex example involving specific install directories could something like:

```shell
perl Build.PL --prefix=/usr/local
./Build install
```

## Install as a Debian package

A binary Debian package can be built with:

    dpkg-buildpackage -b -us -uc

When successful (make sure to have libmodule-build-perl installed) it will create a .deb and a
.changes files one directory above the root of this repository, something like:

    ../liblinz-utils-perl_<version>_*

So then you can install it via:

    dpkg -i ../liblinz-utils-perl_*.deb

## License

This program is released under the terms of the new BSD license. See the LICENSE file for more
information.

Copyright 2011 Crown copyright (c) Land Information New Zealand and the New Zealand Government.
