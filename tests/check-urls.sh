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


function show_success {
  echo -e $'\033[1;35m✓ \033[0m'"$*"
}

function show_error {
  echo -e $'\033[1;31m✗ '"$*"$'\033[0m' 1>&2
}

function try_wget {
  wget -q --tries=5 --timeout=30 --spider "${1}" >/dev/null
}

function check_url_debian {
  local url="https://debian.org"
  local missing=false
  if try_wget ${url}; then
    show_success "${url}"
  else
    missing=true
    show_error "${url}"
  fi
  return ${missing}
}

function check_url_torbrowser {
  local torbrowser_version
  local torbrowser_url="https://www.torproject.org/dist/torbrowser"
  local missing=false
  torbrowser_version=$(curl -s https://www.torproject.org/download/ | \
                       sed -n 's,^ \+<a class="downloadLink" href="/dist/torbrowser/\([0-9\.]\+\)/tor-browser-linux.*">,\1,p')
  for arch in "32" "64"; do
    local torbrowser_package="tor-browser-linux${arch}-${torbrowser_version}_en-US.tar.xz"
    if try_wget "${torbrowser_url}/${torbrowser_version}/${torbrowser_package}"; then
      show_success "${torbrowser_url}/${torbrowser_version}/${torbrowser_package}"
    else
      show_error "${torbrowser_url}/${torbrowser_version}/${torbrowser_package}"
      missing=true
    fi
  done
  return ${missing}
}

check_url_debian
check_url_torbrowser
