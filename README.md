# gentoo-config

https://github.com/yamader/overlay もどうぞ

## init

```sh
emerge-webrsync
emerge -1j dev-vcs/git
rm -r /etc/portage
git clone https://github.com/yamader/gentoo-config /etc/portage
rm -r /var/db/repos/gentoo
emerge --sync
eselect profile set yamad:llvm-desktop

mv /etc/portage/env/mold /tmp
USE=-* emerge -1 hwloc
emerge -1 mold
mv /tmp/mold /etc/portage/env
```
