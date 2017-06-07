[![Build Status](https://travis-ci.org/linz/linz_utils_perl.svg?branch=master)](https://travis-ci.org/linz/linz_utils_perl)

# LINZ Util Perl Package

Contains Modules to preform simple logging to file and load configuration
information from a configuration file. 

## Simple install

```shell
perl Build.PL
./Build install
```

## Advanced install options

The build system is using perl Module::Build. A full list of the building
options are available run:

```shell
./Build help
```

A more complex example involving specific install directories could something
like:

```shell
perl Build.PL --prefix=/usr/local
./Build install
```

## License

This program is released under the terms of the new BSD license. See the 
LICENSE file for more information.

Copyright 2011 Crown copyright (c) Land Information New Zealand and the New
Zealand Government.
