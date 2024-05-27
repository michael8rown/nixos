#!/run/current-system/sw/bin/bash

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/vda
  o # clear the in memory partition table
  g # set to gpt
  n # new partition
  1 # partition number 1
    # default - start at beginning of disk
  +1G # 1GB boot parttion
  n # new partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +25G # extend partition 25GB
  n # new partition
  3 # partion number 2
    # default, start immediately after preceding partition
    # default, take up the remainder of the disk
  t # change type of ...
  1 # /dev/vda1 to ...
  1 # EFI system partition
  t # change type of ...
  3 # /dev/vda3 to ...
  19 # Linux swap
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

mkfs.fat -F32 /dev/vda1
mkfs.ext3 /dev/vda2
mkswap /dev/vda3

mount /dev/vda2 /mnt
mkdir /mnt/boot
mount -o umask=077 /dev/vda1 /mnt/boot
swapon /dev/vda3

nixos-generate-config --root /mnt
cd /mnt/etc/nixos
git clone https://github.com/michael8rown/nixos.git
cd nixos

echo "Basic setup complete. Open \"setup.sh\" and edit the variables, then run ./setup.sh"
