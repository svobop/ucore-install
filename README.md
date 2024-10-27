# install ucore

[source](https://coreos.github.io/coreos-installer/getting-started/)

Install utilities:
```bash
sudo dnf install coreos-installer butane yq
```
Download iso, verify signature
```bash
coreos-installer download -f iso
```
Since both butane and ign file contain sensitive information is should not be shared, create separate `ucore-passwd.butane` for credentials
```yaml
passwd:
  users:
    - name: core
      ssh_authorized_keys:
        - YOUR_SSH_PUB_KEY_HERE
      password_hash: YOUR_GOOD_PASSWORD_HASH_HERE
```
Generate rsa key with
```bash
ssh-keygen -t ed25519
```
Generate password hash with
```bash
openssl passwd -6
```

Merge credentials with autorebase example and create ignition file

```bash
yq -n 'load("ucore-autorebase.butane") * load("ucore-passwd.butane")' | butane > ucore-autorebase.ign
```

Embed ignition file into iso (just for liveiso not install)
```bash
coreos-installer iso ignition embed -i ucore-autorebase.ign fedora-coreos-
```
Custom install
```bash
coreos-installer iso customize  --dest-device /dev/sda --dest-ignition ucore-autorebase.ign fedora-coreos-
```
Network keyfile, inginition ca are optional
[syntax for network-keyfile](https://networkmanager.dev/docs/api/latest/nm-settings-keyfile.html)
