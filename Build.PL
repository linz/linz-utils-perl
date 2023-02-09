#!usr/bin/perl
################################################################################
#
# LINZ Utils Perl package
#
# Copyright 2011 Crown copyright (c)
# Land Information New Zealand and the New Zealand Government.
# All rights reserved
#
# This program is released under the terms of the new BSD license. See the
# LICENSE file for more information.
#
################################################################################
use strict;
use warnings;

use Config;
use Module::Build;
use lib '.';
use inc::MyBuilder;

my $requires = {
    'Sys::Hostname' => 0,
};

my $version = '1.3.0';
if ( `which git` && -d '.git' ) {
  $version = `git describe`;
  chop($version);
}


my $build =  inc::MyBuilder->new(
    module_name        => 'LINZ::Utils',
    license            => 'bsd',
    dist_author        => 'LINZ',
    dist_abstract      => 'LINZ perl utility modules',
    dist_version       => $version,
    sign               => 1,
    requires           => $requires,
    create_makefile_pl => 'small',
);

$build->create_build_script;
