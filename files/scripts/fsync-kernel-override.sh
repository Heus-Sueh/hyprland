#!/usr/bin/env bash

set -oue pipefail

# inspired by: https://github.com/antuan1996/formile-cachyos-ublue

echo 'Enable SElinux policy'
setsebool -P domain_kernel_load_modules on

echo 'fsync kernel override'
rpm-ostree cliwrap install-to-root / &&
	rpm-ostree override replace --experimental --freeze --from repo='copr:copr.fedorainfracloud.org:sentry:kernel-fsync' kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra
#rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --install --from repo='copr:copr.fedorainfracloud.org:sentry:kernel-fsync' kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra

#rpm-ostree override replace --experimental --from repo='copr:copr.fedorainfracloud.org:sentry:kernel-fsync' \
#kernel \
#kernel-core-* \
#kernel-modules-* \
#kernel-uki-virt-*
