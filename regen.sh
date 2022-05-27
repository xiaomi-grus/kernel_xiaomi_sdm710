#!/bin/bash
# SPDX-License-Identifier: GPL-3.0
# Copyright © 2021,
# Author: Tashfin Shakeer Rhythm <tashfinshakeerrhythm@gmail.com>

# A really dirty defconfig regeneration script by Tashar

# Colors
red="\033[1;31m"
green="\033[1;32m"

regen_start() {
    echo -e "$green Regen Method $red                                       "
    echo -e " ╔════════════════════════════════════════════════════════════╗"
    echo -e " ║$green 1. Regenerate full defconfigs                 	      $S$red║"
    echo -e " ║$green 2. Regenerate with Savedefconfig               	      $S$red║"
    echo -e " ║$green e. EXIT                                        	      $S$red║"
    echo -e " ╚════════════════════════════════════════════════════════════╝"
    echo -ne "$green \n Enter your choice or press 'e' for back to shell:  "

    read -r selector
if [[ "$selector" == "1" ]]; then
echo "  _____    ______   _____    ______   ___    _  "
echo " |  __ \  |  ____| / ____|  |  ____| |   \  | | "
echo " | |__| } | |___  | /  ___  | |___   | .\ \ | | "
echo " |  _  /  |  ___| | | |_  | |  ___|  | | \ \| | "
echo " | | \ \  | |____ | \___| | | |____  | |  \ ' | "
echo " |_|  \_\ |______| \_____/  |______| |_|   \__| "

regen() {
rm -rf out
make O=out ARCH=arm64 ${DEVICE}_defconfig	\
   	   LLVM=1						\
   	   LLVM_IAS=1						\
   	   PATH="$HOME/neutron-clang/bin/:${PATH}"

rm -rf arch/arm64/configs/${DEVICE}_defconfig
mv out/.config arch/arm64/configs/${DEVICE}_defconfig
}

sdm670-perf() {
DEVICE=sdm670-perf
regen
}

sdm670-perf
rm -rf out

git add arch/arm64/configs/${DEVICE}-defconfig
git commit -asm "sdm670-perf: Regenerate defconfigs"

elif [[ "$selector" == "2" ]]; then 
echo "  _____    ______   _____    ______   ___    _  "
echo " |  __ \  |  ____| / ____|  |  ____| |   \  | | "
echo " | |__| } | |___  | /  ___  | |___   | .\ \ | | "
echo " |  _  /  |  ___| | | |_  | |  ___|  | | \ \| | "
echo " | | \ \  | |____ | \___| | | |____  | |  \ ' | "
echo " |_|  \_\ |______| \_____/  |______| |_|   \__| "

regen() {
rm -rf out
make O=out ARCH=arm64 ${DEVICE}_defconfig savedefconfig	\
   	   LLVM=1								\
   	   LLVM_IAS=1								\
   	   PATH="$HOME/neutron-clang/bin/:${PATH}"
   	   
rm -rf arch/arm64/configs/${DEVICE}_defconfig
mv out/defconfig arch/arm64/configs/${DEVICE}_defconfig
}

sdm670-perf() {
DEVICE=sdm670-perf
regen
}

sdm670-perf
rm -rf out

git add arch/arm64/configs/${DEVICE}_defconfig
git commit -asm "sdm670-perf: Regenerate with Savedefconfig"
elif [[ "$selector" == "e" ]]; then
    exit
else
    error
fi
}

regen_start
