# Kernel packaging configuration for Xiaomi Pad 6 (pipa)
# See: https://github.com/droidian-devices/common_fragments

VARIANT = android
KERNEL_BASE_VERSION = 4.19-325

DEVICE_VENDOR = xiaomi
DEVICE_MODEL = pipa
DEVICE_FULL_NAME = Xiaomi Pad 6

# Kernel source: https://github.com/SD870/kernel_xiaomi_sm8250
# Branch: 16
# Includes vendor/xiaomi/pipa.config and vendor/xiaomi/sm8250-common.config.

KERNEL_DEFCONFIG = vendor/kona_defconfig
KERNEL_ARCH = arm64
KERNEL_IMAGE_WITH_DTB = 0
KERNEL_IMAGE_WITH_DTB_OVERLAY = 0

# Pipa uses appended DTB via header generation
KERNEL_BUILD_HEADER = 1

# Cross-compilation
BUILD_CROSS = 1
BUILD_TRIPLET = aarch64-linux-gnu-
DEB_TOOLCHAIN = gcc-aarch64-linux-gnu
DEB_BUILD_ON = amd64
DEB_BUILD_FOR = arm64

# Boot image
KERNEL_BOOTIMAGE_CMDLINE = console=ttyMSM0,115200n8 androidboot.hardware=qcom \
                           androidboot.console=ttyMSM0 androidboot.memcg=1 \
                           lpm_levels.sleep_disabled=1 msm_rtb.filter=0x237 \
                           service_locator.enable=1 swiotlb=2048 \
                           loop.max_part=7 androidboot.selinux=permissive \
                           droidian.lvm.prefer

# Flashing
FLASH_ENABLED = 1
FLASH_IS_AONLY = 0
FLASH_INFO_DEVICE_IDS = pipa
FLASH_INFO_CPU = Qualcomm Technologies, Inc SM8250 (Snapdragon 870)
FLASH_VBMETA_REQUIRED = 0

# Build target (no appended DTB, device uses boot image header)
KERNEL_BUILD_TARGET = Image.gz

# Droidian-specific config fragments
KERNEL_CONFIG_FRAGMENTS = vendor/kona-perf_defconfig \
                          vendor/xiaomi/sm8250-common.config \
                          vendor/xiaomi/pipa.config \
                          droidian.config

# Kernel variant
KERNEL_VARIANT = droidian
