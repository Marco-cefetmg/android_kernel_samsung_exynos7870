export ARCH=arm64
export CROSS_COMPILE=~/android/toolchains/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export ANDROID_MAJOR_VERSION=o
make exynos7870-gtanotexllte_defconfig
CONFIG_DEBUG_SECTION_MISMATCH=y make -j4

if [ ! -d "AnyKernel3" ]; then
	git clone --recursive --depth=1 -j $(nproc) https://github.com/osm0sis/AnyKernel3 AnyKernel3
	sed -i 's/kernel.string=ExampleKernel by osm0sis @ xda-developers/kernel.string=TestKernel by Marco-cefetmg @ xda-developers/g' AnyKernel3/anykernel.sh
	sed -i 's/device.name1=maguro/device.name1=gtanotexllte/g' AnyKernel3/anykernel.sh
	sed -i 's/device.name2=toro/device.name2=/g' AnyKernel3/anykernel.sh
	sed -i 's/device.name3=toroplus/device.name3=/g' AnyKernel3/anykernel.sh
	sed -i 's/device.name4=tuna/device.name4=/g' AnyKernel3/anykernel.sh
	sed -i 's!BLOCK=/dev/block/platform/omap/omap_hsmmc.0/by-name/boot;!BLOCK=/dev/block/platform/13540000.dwmmc0/by-name/BOOT;!g' AnyKernel3/anykernel.sh
	sed -i 's/backup_file init.rc;/#&/g' AnyKernel3/anykernel.sh
	sed -i 's/replace_string init\.rc "cpuctl cpu,timer_slack" "mount cgroup none \/dev\/cpuctl cpu" "mount cgroup none \/dev\/cpuctl cpu,timer_slack";/#&/g' AnyKernel3/anykernel.sh
	sed -i 's/backup_file init.tuna.rc;/#&/g' AnyKernel3/anykernel.sh
	sed -i 's/insert_line init\.tuna\.rc "nodiratime barrier=0" after "mount_all \/fstab\.tuna" "\\tmount ext4 \/dev\/block\/platform\/omap\/omap_hsmmc\.0\/by-name\/userdata \/data remount nosuid nodev noatime nodiratime barrier=0";/#&/g' AnyKernel3/anykernel.sh
	sed -i 's/append_file init.tuna.rc "bootscript" init.tuna;/#&/g' AnyKernel3/anykernel.sh
	sed -i 's/backup_file fstab.tuna;/#&/g' AnyKernel3/anykernel.sh
	sed -i 's/patch_fstab fstab\.tuna \/system ext4 options "noatime,barrier=1" "noatime,nodiratime,barrier=0";/#&/g' AnyKernel3/anykernel.sh
	sed -i 's/patch_fstab fstab\.tuna \/cache ext4 options "barrier=1" "barrier=0,nomblk_io_submit";/#&/g' AnyKernel3/anykernel.sh
	sed -i 's/patch_fstab fstab\.tuna \/data ext4 options "data=ordered" "nomblk_io_submit,data=writeback";/#&/g' AnyKernel3/anykernel.sh
	sed -i 's/append_file fstab.tuna "usbdisk" fstab;/#&/g' AnyKernel3/anykernel.sh
fi

mv arch/arm64/boot/Image* AnyKernel3
cd AnyKernel3/
zip -r9 AnyKernel3-update.zip * -x .git README.md *placeholder
# qrencode -t ansiutf8 $(curl bashupload.com -T AnyKernel3-update.zip | grep -Eo "http:\/\/([^\/]*)\/(.*)$")
adb reboot recovery
read -p "press enter:"
adb sideload AnyKernel3-update.zip
cd ..
rm -rf AnyKernel3/Image*
