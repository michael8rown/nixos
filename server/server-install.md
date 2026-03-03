# New steps for setting up the server

```
git clone https://github.com/michael8rown/nixos.git
cd nixos
```

[ edit `part.sh` if you want to automate partitioning ]

[ my new server layout is: ]

```
	/dev/sda
		sda1	/boot
		sda2	/
		sda3	/mnt/storage
				/mnt/storage/www	=> /var/www
				/mnt/storage/home	=> /home
				/mnt/storage/images	=> /var/lib/libvirtd/images
		sda4	swap
	/dev/sdb
		sdb1	/mnt/backup

mkdir -p /mnt/home
mkdir -p /mnt/var/www
mkdir -p /mntvar/lib/libvirt/images

mount -o bind /mnt/mnt/storage/home -m /mnt/home
mount -o bind /mnt/mnt/storage/www -m /mnt/var/www
mount -o bind /mnt/mnt/storage/images -m /mnt/var/lib/libvirt/images

nixos-generate-config --root /mnt
```

[ let nixos-generate-config set up the binds with the correct uuids, then move them ]
[ to configuration.nix later in these steps ]

```
umount /mnt/home
umount /mnt/var/www
umount /mnt/var/lib/libvirt/images

cp -R /home/nixos/nixos/server /mnt/etc/nixos/.
cp -R /home/nixos/nixos/setup.sh /mnt/etc/nixos/.
cp -R /home/nixos/nixos/README.md /mnt/etc/nixos/.

cd /mnt/etc/nixos

mv configuration.nix orig.configuration.nix 
mv server/flake.nix .
```

[ edit `setup.sh` to reflect the correct variables then run it ]

```
./setup.sh
```

[ move fileSystems entries for the binds from `hardware-configuration.nix` to `configuration.nix` ]

```
nix-channel --remove nixos && nix-channel --update 
nixos-install --flake .#<hostname>
nixos-enter --root /mnt -c 'passwd <username>'
```
