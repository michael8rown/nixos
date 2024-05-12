# My NixOS configurations

This is where I will keep my configs.

### Preliminary instructions

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
mv configuration.nix configuration.nix.orig
git clone https://github.com/michael8rown/nixos.git
# now move the proper configurations into place, both configuration.nix and home.nix
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --update
nixos-install
```

