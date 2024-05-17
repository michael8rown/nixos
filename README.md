# NixOS configurations

Configurations and miscellaneous files for my home server and my laptops.

### Installation instructions

```
sudo su
cfdisk /dev/vda
mkfs.ext4 /dev/vda2
# If you have an existing boot partition, skip the next step!!
mkfs.fat -F32 /dev/vda1
mkswap /dev/vda3
mount /dev/vda2 /mnt
mkdir /mnt/boot
mount -o umask=0077 /dev/vda1 /mnt/boot
swapon /dev/vda3
# Also, be sure to format/mount any other partitions, such as /home or /var if needed
# Once everything is created, formatted, and mounted ...
nixos-generate-config --root /mnt
cd /mnt/etc/nixos
mv configuration.nix configuration.nix.orig
git clone https://github.com/michael8rown/nixos.git
# Move configuration.nix and home.nix into place
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --update
nixos-install
```

### Variables

The following variables need to be changed:

- VAR_USERNAME: This is whatever your actual username is
- VAR_YOUR_NAME: This is your first and last name, such as John Smith
- VAR_MSMTP_EMAIL: This is the email address that should be used for `msmtp`
- VAR_MSMTP_SERVER: This is the mailserver address, such as `mail.domain.com`
- VAR_EMAIL: This is your personal email address, such as `johnsmith@qooqle.com`
- VAR_SSH_PORT: This is the port you use for `sshd`
- VAR_HTTP_ROOT: This is the root directory of your webserver, such as `/var/www` or `/srv/httpd`
- VAR_HOSTNAME: This is the name of your machine

### TO-DO

- [x] Write a script to change the variables
