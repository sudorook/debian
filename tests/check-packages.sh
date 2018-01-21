#! /bin/bash
set -eu

#
# Check that all the packages in ../packages actually exist.
#

function clean_pkgname() {
  echo "${1}" | sed -e "s,+$,\\\+,g"
}

pkgdir=../packages

for file in ${pkgdir}/*; do
  echo $(basename ${file})

  for package in $(cat ${file}); do
    if apt-cache search --names-only ^$(clean_pkgname "${package}")$ >/dev/null; then
    # if dpkg -s ^$(clean_pkgname "${package}")$ >/dev/null; then
      echo "✓ ${package}"
    else
      echo "✗ ${package}"
    fi
  done

  echo
done
