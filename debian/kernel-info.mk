########################################################################
# Kernel settings
########################################################################

# Kernel variant.
VARIANT = android

# Kernel base version
KERNEL_BASE_VERSION = 4.19.325

# The kernel cmdline to use
# Match the Android device tree for pipa, then append Droidian-specific bits.
KERNEL_BOOTIMAGE_CMDLINE = quiet splash \
                            androidboot.hardware=qcom \
                            androidboot.console=ttyMSM0 \
                            androidboot.memcg=1 \
                            lpm_levels.sleep_disabled=1 \
                            msm_rtb.filter=0x237 \
                            service_locator.enable=1 \
                            androidboot.usbcontroller=a600000.dwc3 \
                            swiotlb=2048 loop.max_part=7 \
                            cgroup.memory=nokmem,nosocket reboot=panic_warm \
                            androidboot.fstab_suffix=qcom \
                            androidboot.init_fatal_reboot_target=recovery \
                            androidboot.selinux=permissive \
                            droidian.lvm.prefer

# Slug for the device vendor.
DEVICE_VENDOR = xiaomi

# Slug for the device model.
DEVICE_MODEL = pipa

# Marketing-friendly full-name.
DEVICE_FULL_NAME = Xiaomi Pad 6

# Whether to use configuration fragments to augment the kernel configuration.
KERNEL_CONFIG_USE_FRAGMENTS = 0

# Whether to use diffconfig to generate the device-specific configuration.
KERNEL_CONFIG_USE_DIFFCONFIG = 0

# Defconfig to use
KERNEL_DEFCONFIG = vendor/pipa_defconfig

# Whether to include DTBs with the image. Use 0 (no) or 1.
# Set to 0 — uses dtbo.img for device tree (stock Xiaomi boot flow).
KERNEL_IMAGE_WITH_DTB = 0

# Whether to include a DTB Overlay. Use 0 (no) or 1.
# Kept at 1 so the snippet packages dtbo.img; actual dtbo.img is
# provided as prebuilt (droidian/dtbo.img), not compiled from source.
KERNEL_IMAGE_WITH_DTB_OVERLAY = 1

# Whether to merge DTB + Overlay into the kernel image at build time.
KERNEL_IMAGE_WITH_DTB_OVERLAY_IN_KERNEL = 0

# Specify DTB Overlay file to include (relative to KERNEL_OUT).
# Merged with the base DTB via ufdt_apply_overlay to produce the pipa device tree.
# Unused when KERNEL_IMAGE_DTB_OVERLAY_CONFIGURATION is set (which uses cfg_create instead).
# KERNEL_IMAGE_DTB_OVERLAY = arch/arm64/boot/dts/vendor/qcom/pipa-sm8250-overlay.dtbo

# DTBO configuration file for mkdtboimg cfg_create.
# Packs all 13 Xiaomi SM8250 device overlays into a single dtbo.img,
# matching the stock dtbo partition format.
KERNEL_IMAGE_DTB_OVERLAY_CONFIGURATION = arch/arm64/boot/dts/vendor/qcom/sm8250-xiaomi-dtbo.cfg

# Directory containing the compiled .dtbo files (relative to KERNEL_OUT).
KERNEL_IMAGE_DTB_OVERLAY_DTB_DIRECTORY = arch/arm64/boot/dts/vendor/qcom

# Whether to build a boot image header from scratch.
KERNEL_BUILD_HEADER = 1

# Various other settings that will be passed straight to mkbootimg
KERNEL_BOOTIMAGE_PAGE_SIZE = 4096
KERNEL_BOOTIMAGE_BASE_OFFSET = 0x00000000

# Boot partition size for AVB footer (192 MB for Xiaomi Pad 6 pipa)
KERNEL_BOOTIMAGE_PARTITION_SIZE = 201326592

# Specify boot image security patch level if needed
# KERNEL_BOOTIMAGE_PATCH_LEVEL = 2023-08

# Specify boot image OS version if needed
# KERNEL_BOOTIMAGE_OS_VERSION = 12.0.0

# Kernel bootimage version.
# Upstream Android device trees mark pipa as VAB, which uses header v3.
KERNEL_BOOTIMAGE_VERSION = 3

# Kernel initramfs compression.
KERNEL_INITRAMFS_COMPRESSION = gz

########################################################################
# Android verified boot
########################################################################

# Whether to build a flashable vbmeta.img.
DEVICE_VBMETA_REQUIRED = 1

########################################################################
# Automatic flashing on package upgrades
########################################################################

FLASH_ENABLED = 1
FLASH_IS_AONLY = 0
FLASH_IS_LEGACY_DEVICE = 0
FLASH_IS_EXYNOS = 0

# Device manufacturer. Checked against ro.product.vendor.manufacturer.
FLASH_INFO_MANUFACTURER = Xiaomi

# Device model. Checked against ro.product.vendor.model.
FLASH_INFO_MODEL = 23043RP34G

# Device CPU. This will be grepped against /proc/cpuinfo.
FLASH_INFO_CPU = Qualcomm Technologies, Inc SM8250 (Snapdragon 870)

# Space-separated list of supported device ids as reported by fastboot
FLASH_INFO_DEVICE_IDS = pipa

########################################################################
# Kernel build settings
########################################################################

# Whether to cross-build.
BUILD_CROSS = 1

# (Cross-build only) The build triplet to use.
BUILD_TRIPLET = aarch64-linux-android-

# (Cross-build only) The build triplet to use with clang.
BUILD_CLANG_TRIPLET = aarch64-linux-gnu-

# The compiler to use.
BUILD_CC = clang

# Set to 1 to skip modules packaging if CONFIG_MODULES is disabled in defconfig
BUILD_SKIP_MODULES = 0

# Set clang version
CLANG_VERSION = 14.0-r450784d

# Set to 1 to use a manually installed toolchain
CLANG_CUSTOM = 0

# Extra paths to prepend to the PATH variable.
BUILD_PATH = /usr/lib/llvm-android-$(CLANG_VERSION)/bin

# Extra packages to add to the Build-Depends section.
DEB_TOOLCHAIN = linux-initramfs-halium-generic:arm64, binutils-aarch64-linux-gnu, crossbuild-essential-arm64, gcc-4.9-aarch64-linux-android, g++-4.9-aarch64-linux-android, libgcc-4.9-dev-aarch64-linux-android-cross, lz4

# Where we're building on
DEB_BUILD_ON = amd64

# Where we're going to run this kernel on
DEB_BUILD_FOR = arm64

# Target kernel architecture
KERNEL_ARCH = arm64

# Kernel target to build
KERNEL_BUILD_TARGET = Image
