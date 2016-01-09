#!/bin/sh

echo Build a SD Card....
export rom_disk_src=../disks

export sd_disk_path=/dev/mmcblk0

echo Copy  $rom_path_src/dos33master.nib to $sd_disk_path  CD Card

#sudo dd if=$rom_path_src/dos33master.nib of=/dev/mmcblk0
sync



