#! /bin/bash
set -eu

# Debian (post-)install scripts
# Copyright (C) 2020
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


#
# Check that all the packages in ../packages actually exist.
#

PKGDIR=../packages
MISSING=false

for file in "${PKGDIR}"/*; do
  basename "${file}"

  while read -r package; do
    if apt-cache search --names-only ^"${package//+/\\\+}"$ | grep -q "${package}"; then
      echo -e "\033[1;35m✓\033[0m" "${package}"
    else
      MISSING=true
      echo -e "\033[1;31m✗ ${package}\033[m"
    fi
  done < "${file}"

  echo
done

if ${MISSING}; then
  exit 1
fi
