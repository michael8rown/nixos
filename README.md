# NixOS flake-based configurations

Configurations and miscellaneous files for my home server and my laptops.

### Installation instructions

Boot into the NixOS installation iso. Close the installer and open `console`, then run

```
sudo su
git clone https://github.com/michael8rown/nixos.git
cd nixos
```

`part.sh` will automatically partition the drive and mount those paritions like this:

```
	vda           8:0    0    30G  0 disk 
	├─vda1        8:1    0     1G  0 part /boot
	├─vda2        8:2    0    25G  0 part /
	└─vda3        8:5    0     4G  0 part [SWAP]
```

If you require a different partition layout, then edit `part.sh` accordingly or follow the steps below, manually creating whatever partitions you need.

```
cfdisk /dev/vda
mkfs.ext4 /dev/vda#
# If you have an existing boot partition, skip the next step!!
mkfs.fat -F32 /dev/vda#
mkswap /dev/vda#
mount /dev/vda# /mnt
mkdir /mnt/boot
mount -o umask=0077 /dev/vda# /mnt/boot
swapon /dev/vda#
# Also, be sure to format/mount any other partitions, such as /home or /var if needed
```

Once everything is created, formatted, and mounted, install NixOS as follows:

```
nixos-generate-config --root /mnt
cd /mnt/etc/nixos
mv configuration.nix configuration.nix.orig
mv /home/nixos/nixos/* .
# Edit variables in setup.sh (see Variables section below) and then run it ...
nano setup.sh
./setup.sh
# Remove nixos channel
nix-channel --remove nixos
nix-channel --update
# Install system from the flake
nixos-install --flake .#VAR_HOSTNAME
# nixos-install --flake requires you to identify a hostname
# be sure to include it here (whatever you've set VAR_HOSTNAME
# at below); nixos-rebuild later does not require it

# Don't forget to create a password for your username
# otherwise you'll need to log in to the newly
# installed system as root to set it later
nixos-enter --root /mnt -c 'passwd VAR_USERNAME'
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
- VAR_PROFILE: This is profile you're installing, either `laptop` or `server`

### TO-DO

- [x] Write a script to change the variables
- [x] Update instructions to account for flakes
