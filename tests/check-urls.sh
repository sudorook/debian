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

function show_success {
  echo -e $'\033[1;35m✓ \033[0m'"$*"
}

function show_error {
  echo -e $'\033[1;31m✗ '"$*"$'\033[0m' 1>&2
}

function try_wget {
  wget -q --tries=5 --timeout=30 --spider "${1}" > /dev/null
}

function try_curl {
  curl -ILs --retry 5 --retry-connrefused "${1}" > /dev/null
}

function check_url_debian {
  local url="https://debian.org"
  local missing=false
  if try_curl ${url}; then
    show_success "${url}"
  else
    missing=true
    show_error "${url}"
  fi
  ${missing} && return 1 || return 0
}

function check_neovim_appimage {
  local neovim_url="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.appimage"
  local missing=false

  if try_curl "${neovim_url}"; then
    show_success "${neovim_url}"
  else
    show_error "${neovim_url}"
    missing=true
  fi
  ${missing} && return 1 || return 0
}

function check_url_torbrowser {
  local torbrowser_version
  local torbrowser_url="https://www.torproject.org/dist/torbrowser"
  local missing=false
  torbrowser_version=$(curl -Ls https://www.torproject.org/download/ |
                       sed -n 's,^ \+<a class="downloadLink" href="/dist/torbrowser/\([0-9\.]\+\)/tor-browser-linux.*">,\1,p')
  for arch in "32" "64"; do
    local torbrowser_package="tor-browser-linux${arch}-${torbrowser_version}_ALL.tar.xz"
    if try_curl "${torbrowser_url}/${torbrowser_version}/${torbrowser_package}"; then
      show_success "${torbrowser_url}/${torbrowser_version}/${torbrowser_package}"
    else
      show_error "${torbrowser_url}/${torbrowser_version}/${torbrowser_package}"
      missing=true
    fi
  done
  ${missing} && return 1 || return 0
}

check_url_debian
check_neovim_appimage
check_url_torbrowser
