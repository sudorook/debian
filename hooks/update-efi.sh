#!/bin/bash
set -eu

function get_cmdline {
  local default
  local cmdline
  default=$(grep ^default /boot/efi/loader/loader.conf | cut -d"	" -f2)
  cmdline=$(grep ^options "/boot/efi/loader/entries/${default}" | cut -d"	" -f2)
  echo "${cmdline}"
}

function get_default {
  local default
  local current
  local new
  if [ -f /boot/efi/loader/loader.conf ]; then
    default=$(grep ^default /boot/efi/loader/loader.conf | cut -d"	" -f2)
    current=$(grep ^linux "/boot/efi/loader/entries/${default}" | cut -d"	" -f2)
  fi
  if [[ -n "${current}" ]]; then
    # for backported kernels...
    if [[ "${current}" =~ bpo ]]; then
      local kernels
      kernels=($(ls -r /boot/vmlinuz*bpo*))
      new=$(basename ${kernels[0]})
    # if using default kernel...
    elif [[ "${current}" =~ vmlinuz-[0-9]\.[0-9]+\.0-[0-9]+-[amd64|i386] ]]; then
      local version
      local kernels
      version="$(basename "${current}" | sed -n "s/vmlinuz-\([0-9\.-]\+\)-[0-9]\+-\(i386\|amd64\)/\1/p")"
      kernels=($(ls -r /boot/vmlinuz-${version}*))
      new=$(basename ${kernels[0]})
    # if using non-standard kernel, keep it if it still exists
    elif [ -f "/boot/$(basename "${current}")" ]; then
      new="$(basename "${current}")"
    # otherwise pick the first (lexicographically sorted) kernel
    else
      local kernels
      kernels=($(ls -r /boot/vmlinuz*))
      new=$(basename ${kernels[0]})
    fi
  else
    local kernels
    kernels=($(ls -r /boot/vmlinuz*))
    new=$(basename ${kernels[0]})
  fi
  echo "${new}"
}

function make_loader {
  local kernel
  local version
  local outfile
  kernel="${1}"
  version="${kernel/vmlinuz-/}"
  version="${version/-amd64/}"
  version="${version/-i386/}"
  outfile="linux-${version}.conf"
  cat > /boot/efi/loader/loader.conf << EOF
default	${outfile}"
timeout	1
console-mode	max
editor	no
EOF
}

function make_entry {
  local kernel
  local version
  local cmdline
  local outfile
  kernel="${1}"
  version="${kernel/vmlinuz-/}"
  version="${version/-amd64/}"
  version="${version/-i386/}"
  cmdline="${2}"
  outfile="linux-${version}.conf"

  cat > "/boot/efi/loader/entries/${outfile}" << EOF
title	Debian, linux-${version}
linux	/${kernel}
initrd	/${kernel/vmlinuz/initrd.img}
options	${cmdline}
EOF
}

function clear_entries {
  find /boot/efi/loader -type f -name "*.conf" -delete
  find /boot/efi -type f -name "vmlinuz*" -delete
  find /boot/efi -type f -name "initrd.img*" -delete
}

if [ "$(bootctl is-installed)" = "yes" ]; then
  DEFAULT="$(get_default)"
  CMDLINE="$(get_cmdline)"

  clear_entries
  for kernel in /boot/vmlinuz*; do
    cp -af "${kernel}" /boot/efi/
    cp -af "${kernel/vmlinuz/initrd.img}" /boot/efi/
    make_entry "$(basename "${kernel}")" "${CMDLINE}"
  done
  make_loader "${DEFAULT}"
fi
