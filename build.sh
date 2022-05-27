clear
DATE=$(date +"%Y%m%d")
VERSION=$(git rev-parse --short HEAD)
KERNEL_NAME=GHOST-grus-stable-"$DATE"

KERNEL_PATH=$PWD
CLANG_PATH=~/kernel/clang/proton-clang
ANYKERNEL_PATH=~/kernel/Anykernel3
TOOLS_PATH=~/kernel/tools

echo "===================Setup Environment==================="

#Download Clang
if [ ! -d $CLANG_PATH ]; then
git clone https://github.com/kdrag0n/proton-clang $CLANG_PATH --depth=1
fi

# Clone AnyKernel3
if [ ! -d $ANYKERNEL_PATH ]; then
git clone https://github.com/osm0sis/AnyKernel3 -b master $ANYKERNEL_PATH
fi

# Download libufdt
if [ ! -d $TOOLS_PATH/libufdt ]; then
    wget https://android.googlesource.com/platform/system/libufdt/+archive/refs/tags/android-10.0.0_r45/utils.tar.gz
    mkdir -p $TOOLS_PATH/libufdt
    tar xvzf utils.tar.gz -C $TOOLS_PATH/libufdt
    rm utils.tar.gz
fi

echo "=========================Clean========================="
rm -rf $KERNEL_PATH/out/ *.zip
make clean mrproper

echo "=========================Build========================="
make O=out CC=clang ARCH=arm64 sdm670-perf_defconfig xiaomi/sdm710-common.config xiaomi/grus.config
PATH="$CLANG_PATH/bin:${PATH}"       \
make -j$(nproc --all) O=out	      \
ARCH=arm64			      \
CC=clang 			      \
HOSTCC=clang			      \
HOSTCXX=clang++		      \
HOSTLD=ld.lld			      \
AS=llvm-as			      \
AR=llvm-ar			      \
NM=llvm-nm			      \
OBJCOPY=llvm-objcopy		      \
OBJDUMP=llvm-objdump		      \
STRIP=llvm-strip		      \
CROSS_COMPILE=aarch64-linux-gnu-     \
CROSS_COMPILE_ARM32=arm-linux-gnueabi-

if [ ! -e $KERNEL_PATH/out/arch/arm64/boot/Image ]; then
    echo "=======================FAILED!!!======================="
    rm -rf $ANYKERNEL_PATH $CLANG_PATH $KERNEL_PATH/out/
    make mrproper>/dev/null 2>&1
    exit -1>/dev/null 2>&1
fi

echo "=========================Patch========================="
rm -r $ANYKERNEL_PATH/modules $ANYKERNEL_PATH/patch $ANYKERNEL_PATH/ramdisk
cp $KERNEL_PATH/anykernel.sh $ANYKERNEL_PATH/
cp $KERNEL_PATH/out/arch/arm64/boot/Image $ANYKERNEL_PATH/
cd $TOOLS_PATH/libufdt/src && python2 mkdtboimg.py create $KERNEL_PATH/out/arch/arm64/boot/dtbo.img $KERNEL_PATH/out/arch/arm64/boot/dts/qcom/*.dtbo
cp $KERNEL_PATH/out/arch/arm64/boot/dtbo.img $ANYKERNEL_PATH/
cd $ANYKERNEL_PATH
zip -r $KERNEL_NAME *
mv $KERNEL_NAME.zip $KERNEL_PATH/out/
cd $KERNEL_PATH
#rm -rf $CLANG_PATH
rm -rf $ANYKERNEL_PATH
echo $KERNEL_NAME.zip

git reset --hard
