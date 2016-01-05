#!/bin/sh

# SHA1 checksum 
export rom_path_src=./roms
export rom_path=./build
#export tools_path=../build2/romgen

export romgen_path=./romgen_src
#mkdir $rom_path

sha1sum $rom_path_src/apple_II.rom
sha1sum $rom_path_src/APPLE2.ROM
sha1sum $rom_path_src/bios.rom

#341-011-D0	Applesoft BASIC D0
#341-012-D8	Applesoft BASIC D8
#341-013-E0	Applesoft BASIC E0
#341-014-E8	Applesoft BASIC E8
#341-015-F0	Applesoft BASIC F0
#341-020-F8	Autostart Monitor


rm $rom_path_src/apple_II_auto.bin

# autostart rom
cat $rom_path_src/341011d0.bin $rom_path_src/341012d8.bin $rom_path_src/341013e0.bin $rom_path_src/341014e8.bin $rom_path_src/341015f0.bin $rom_path_src/341020f8.bin >> $rom_path_src/apple_II_auto.bin

$romgen_path/romgen $rom_path_src/apple_II_auto.bin apple_II_auto_rom 14 a r  > $rom_path/apple_II_auto_rom.vhd 

$romgen_path/romgen $rom_path_src/apple_II.rom apple_II_rom 14 a r  > $rom_path/apple_II_rom.vhd 

$romgen_path/romgen $rom_path_src/APPLE2.ROM APPLE2_ROM 14 a r  > $rom_path/APPLE2_ROM.vhd 

# test rom
$romgen_path/romgen $rom_path_src/bios.rom bios_rom 14 a r  > $rom_path/bios_rom.vhd 



