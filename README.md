# gentoo-config

```sh
mkdir /etc/portage/gnupg
gpg --homedir=/etc/portage/gnupg --locate-keys dev@dyama.net
gpg --homedir=/etc/portage/gnupg --edit-key dev@dyama.net trust q
gpg --homedir=/etc/portage/gnupg --check-trustdb
chmod 644 /etc/portage/gnupg/trustdb.gpg
```
