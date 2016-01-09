#!/bin/sh

# 6e36ae20c211cdc8aad36b2ea757fec95874b499  bios.rom
# 0287ebcef2c1ce11dc71be15a99d2d7e0e128b1e  341011d0.bin
# a75ce5aab6401355bf1ab01b04e4946a424879b5  341012d8.bin
# 8d82a1da63224859bd619005fab62c4714b25dd7  341013e0.bin
# 37501be96d36d041667c15d63e0c1eff2f7dd4e9  341014e8.bin
# e6bf91ed28464f42b807f798fc6422e5948bf581  341015f0.bin
# 07a3bdce3e34bbed5246fe09a9938d8f334a8225  341020f8.bin


# SHA1 checksum 
export rom_path_src=../roms
export rom_path=../build

export romgen_path=../romgen_src
#mkdir $rom_path

sha1sum $rom_path_src/bios.rom

#341-011-D0	Applesoft BASIC D0
#341-012-D8	Applesoft BASIC D8
#341-013-E0	Applesoft BASIC E0
#341-014-E8	Applesoft BASIC E8
#341-015-F0	Applesoft BASIC F0
#341-020-F8	Autostart Monitor
#3420028A.BIN   Disk slot 6

sha1sum $rom_path_src/341011d0.bin
sha1sum $rom_path_src/341012d8.bin
sha1sum $rom_path_src/341013e0.bin
sha1sum $rom_path_src/341014e8.bin
sha1sum $rom_path_src/341015f0.bin
sha1sum $rom_path_src/341020f8.bin

sha1sum $rom_path_src/slot6.rom

rm $rom_path_src/apple_II_auto.bin

# autostart rom
cat $rom_path_src/341011d0.bin $rom_path_src/341012d8.bin $rom_path_src/341013e0.bin $rom_path_src/341014e8.bin $rom_path_src/341015f0.bin $rom_path_src/341020f8.bin >> $rom_path_src/apple_II_auto.bin
$romgen_path/romgen $rom_path_src/apple_II_auto.bin apple_II_auto_rom 14 a r  > $rom_path/apple_II_auto_rom.vhd 

# test rom
$romgen_path/romgen $rom_path_src/bios.rom bios_rom 14 a r  > $rom_path/bios_rom.vhd 

# disk rom
$romgen_path/romgen $rom_path_src/slot6.rom slot6_rom 8 a r  > $rom_path/slot6_rom1.vhd 

