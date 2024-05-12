# NixOS configurations

Configurations and miscellaneous files for my home server and my laptops.

### Installation instructions

```
sudo su
cfdisk /dev/vda
mkfs.ext4 /dev/vda2
mkfs.fat -F32 /dev/vda1
mkswap /dev/vda3
mount /dev/vda2 /mnt
mkdir /mnt/boot
mount -o umask=0077 /dev/vda1 /mnt/boot
swapon /dev/vda3
nixos-generate-config --root /mnt
cd /mnt/etc/nixos
mv configuration.nix configuration.nix.orig
git clone https://github.com/michael8rown/nixos.git
# now move the proper configurations into place, both configuration.nix and home.nix
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --update
nixos-install
```

### Variables

The following variables need to be changed:

- VAR_USERNAME: This is whatever your actual username is
- VAR_YOUR_NAME: This is your first and last name, such as John Smith
- VAR_DOMAIN: This is whatever your domain is
- VAR_EMAIL: This is your own email address
- VAR_SSH_PORT: This is the port you use for `sshd`
- VAR_HTTP_ROOT: This is the root directory of your webserver, such as `/var/www` or `/srv/httpd`
- VAR_HOSTNAME: This is the name of your machine

### T0-DO

- [ ] Write a script to change the variables
