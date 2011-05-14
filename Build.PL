#!usr/bin/perl
################################################################################
#
# $Id$
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

my $requires = {
    'Sys::Hostname' => 0,
};

my $build =  Module::Build->new(
    module_name        => 'LINZ::Utils',
    license            => 'bsd',
    dist_author        => 'LINZ',
    dist_abstract      => 'LINZ perl utility modules',
    dist_version_from  => 'VERSION',
    sign               => 1,
    requires           => $requires,
    create_makefile_pl => 'small',
);

$build->create_build_script;
