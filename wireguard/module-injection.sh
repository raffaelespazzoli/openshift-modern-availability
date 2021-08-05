#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
set -o xtrace

RHOCP_VERSION=$(awk -F'"' '/VERSION_ID/{print $2}' /etc/os-release)
KERNEL_VERSION=$(uname -r)
KERNEL_CORE=$(find /tmp/overlay -name kernel-core-${KERNEL_VERSION}.rpm -exec ls {} \; | tail -n1)
KERNEL_DEVEL=$(find /tmp/overlay -name kernel-devel-${KERNEL_VERSION}.rpm -exec ls {} \; | tail -n1)
KERNEL_HEADERS=$(find /tmp/overlay -name kernel-headers-${KERNEL_VERSION}.rpm -exec ls {} \; | tail -n1)

if [ -z "${KERNEL_CORE}" ] || [ -z "${KERNEL_DEVEL}" ] || [ -z "${KERNEL_HEADERS}" ]; then
  KERNEL_CORE=kernel-core-${KERNEL_VERSION}
  KERNEL_DEVEL=kernel-devel-${KERNEL_VERSION}
  KERNEL_HEADERS=kernel-headers-${KERNEL_VERSION}
fi

dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm

#export kernel_version=$(uname -a | awk '{print $3}' | awk -F. '{print $(NF-1)}' | sed 's/^..//' | tr '_' '.')
#subscription-manager release --set=${kernel_version}
#dnf install -y --enablerepo=rhel-8-for-x86_64-baseos-rpms ${KERNEL_DEVEL} ${KERNEL_HEADERS} ${KERNEL_CORE} iproute kmod-wireguard wireguard-tools

export kernel_version=$(uname -a | awk '{print $3}' | awk -F. '{print $(NF-1)}')
#export package_suffix=$(dnf --showduplicates list kmod-wireguard | grep ${kernel_version} | sort | awk 'END{print}' | awk '{print $2}')
export package_suffix=$(dnf --showduplicates list kmod-wireguard | grep -F $(uname -r | rev | cut -d. -f2 | rev) | awk 'END{print $2}')
dnf install -y --enablerepo=rhel-8-for-x86_64-baseos-rpms ${KERNEL_DEVEL} ${KERNEL_HEADERS} ${KERNEL_CORE} iproute kmod-wireguard-${package_suffix} wireguard-tools

modprobe wireguard

ip link add dev wg0-test type wireguard
ip link delete dev wg0-test

sleep infinity