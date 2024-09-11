#!/bin/bash

# SPDX-FileCopyrightText: 2017 - 2024 sudorook <daemon@nullcodon.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see <https://www.gnu.org/licenses/>.

set -eu

#
# Check that all the packages in ../packages actually exist.
#

PKGDIR=../packages
MISSING=false

for FILE in "${PKGDIR}"/*; do
  basename "${FILE}"

  while read -r PACKAGE; do
    if apt-cache search --names-only ^"${PACKAGE//+/\\\+}"$ | grep -q "${PACKAGE}"; then
      echo -e "\033[1;35m✓\033[0m" "${PACKAGE}"
    else
      MISSING=true
      echo -e "\033[1;31m✗ ${PACKAGE}\033[m"
    fi
  done < "${FILE}"

  echo
done

if ${MISSING}; then
  exit 1
fi
