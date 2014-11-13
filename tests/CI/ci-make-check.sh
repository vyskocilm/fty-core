#!/bin/sh

# Copyright (C) 2014 Eaton
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#   
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Author(s): Tomas Halman <TomasHalman@eaton.com>
#
# Description: installs dependecies and compiles the project

[ "x$CHECKOUTDIR" = "x" ] && CHECKOUTDIR=~/project

set -e

apt-get update
mk-build-deps --tool 'apt-get --yes --force-yes' --install $CHECKOUTDIR/obs/core.dsc
cd $CHECKOUTDIR

# TODO: parallelization?
echo "======================== make and make check ==============================="
autoreconf -vfi && ./configure --prefix=$HOME && make && make check && make install

echo "===================== make dist and make distcheck ========================="
make distclean && ./configure && make dist && make distcheck