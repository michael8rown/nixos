# NixOS flake-based configurations

Configurations and miscellaneous files for my home server and my laptops.

> [!CAUTION]
> These steps are not used exactly this way anymore. Each different profile will get its own installation instructions. The only profile-specific instructions written so far are those for the [`server`](https://github.com/michael8rown/nixos/tree/main/server) profile.

### Note March 14, 2026

I've tried several times to install the NixOS server configuration on bare metal and have failed miserably each time. Whether it's networking or webserver cgi, something always seems to go wrong. So I always end up back on Arch with this server config installed in a VM.

Over the past two weeks, I've tinkered with it pretty much non-stop. Thanks to two sample configurations, [barracadu's nyarlathotep configuration.nix](https://github.com/barrucadu/nixfiles/blob/master/hosts/nyarlathotep/configuration.nix#L465) and [stigok's article on custom perl packages](https://blog.stigok.com/2020/04/16/building-a-custom-perl-package-for-nixos.html), I finally solved my issues with getting Python to work with non-standard modules in systemd services as well as getting Perl modules such as DBI and CGI to work under httpd, two tasks that are absolutely straight-forward under most Linux distributions but which are phenomenally convoluted under NixOS. I still haven't figured out the best networking config because I really need to install on bare metal in order to truly test it, but that will be my next task.

What I've learned over these last couple of weeks is this: NixOS seems best-suited to IT professionals. ~~It is definitely not great for beginners just wanting a normal Linux experience~~ <sup>[see note]</sup>, and it's not even really good for Linux hobbyists like me. I really love to write new scripts in Perl or Python, or drum up a whole new webapp to manage some task or other in my daily life. NixOS does not seem to be well-suited for that kind of behavior.

<sup>Note:</sup> I believe I am mistaken about this: in fact, NixOS might be the *perfect* OS for a Linux beginner who just wants an OS that stays out of their way and works. In that regard, NixOS is quite possibly the best Linux OS out there.

That being said, I admit I feel a huge amount of pride at having figured out two of my biggest issues. If I can get the networking issue settled, I might actually use NixOS on my home server. I really, really love the idea of NixOS. I really, really want it to work for me. But if I have too many more catastrophes, I may have to abandon this effort.

If nothing else, I've become *really good* at quickly and efficiently re-installing Arch. :-)

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
- VAR_FULLNAME: This is your first and last name, such as John Smith
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
