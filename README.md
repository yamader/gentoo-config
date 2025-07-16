# gentoo-config

https://github.com/yamader/overlay もどうぞ

## memo

- `dev-lang/swift::guru`: `<gcc-16`・`<cmake-4`

## init

```sh
emerge-webrsync
emerge -1j dev-vcs/git sys-devel/mold
rm -r /etc/portage
git clone https://github.com/yamader/gentoo-config /etc/portage
rm -r /var/db/repos/gentoo
emerge --sync
eselect profile set yamad:llvm-desktop

#USE=-* emerge -1 \
#  app-text/xmlto \
#  dev-lang/python{,:3.14t} \
#  media-libs/harfbuzz \
#  media-libs/libwebp
```
