# New system installation

## Prerequisites

See `fileSystems` config for the host and create necessary partitions. For existing partitions, make sure to update `fileSystems` to reflect how storage is set up.


## Installation

1. Boot NixOS from a Live USB

2. Enter shell with git and vim:

```bash
nix --extra-experimental-features "nix-command flakes" shell nixpkgs#git nixpkgs#vim
```

3. Mount all required partitions under `/mnt`.

- On new hardware, consider  running `nixos-generate-config` and examine the `configuration.nix` and `hardware-configuration.nix` to see if any declarations are required to be added to the configuration.

4. Clone the repo with the configuration:

```bash
git clone git@github.com:admiral-shlork/nixos-micro-slab.git
```
```bash
git clone https://github.com/admiral-shlork/nixos-micro-slab.git
```

5. To install the OS run the following command from the root folder of the cloned repository:

```bash
sudo nixos-install --root /mnt  --flake .#micro-slab
```

6. Set a password for the user:

```bash
nixos-enter --root /mnt -c 'passwd whatever'
```

## Some useful Nix commands:

- Apply configuration from a Flake and rebuild the OS
```bash
sudo nixos-rebuild switch --flake .#micro-slab
```


- Remove older generations from the bootloader
```bash
nix-collect-garbage --delete-older-than 1d
```
```bash
sudo nixos-rebuild boot --flake .#micro-slab
```
```bash
nh clean all --keep 2
```
```bash
sudo nixos-rebuild boot --flake .#micro-slab
```

- Update the flake.lock file and rebuild the system
```bash
nix flake update
```
```bash
sudo nixos-rebuild switch --flake .#micro-slab
```

# Appendix

## Partitioning cheat sheet

- create and open a LUKS container
```bash
cryptsetup luksFormat /dev/sda1
```
```bash
cryptsetup luksOpen /dev/sda1 some_luks_container
```

- create an LVM Physical Volume and add a Volume Group to it
``` bash
pvcreate /dev/mapper/some_luks_container
```
``` bash
vgcreate some_volume_group /dev/mapper/some_luks_container
```

- create LVM Logical Volume
``` bash
lvcreate -n some_logical_volume -L 42G some_volume_group
```
``` bash
lvcreate -n some_logical_volume -l 100%FREE some_volume_group
```

- create a filesystem
```bash
mkfs.ext4 /dev/mapper/some_logical_volume
```
```bash
mkfs.vfat /dev/mapper/some_partition
```

## Assorted useful commands

- create a key file and attach it to a LUKS container
```bash
dd if=/dev/urandom of=/root/some_luks_container.key bs=1024 count=4
```
```bash
chmod 0400 /root/some_luks_container.key
```
```bash
cryptsetup luksAddKey /dev/sda1 /root/some_luks_container.key
```
