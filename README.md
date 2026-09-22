Device configuration for Redmi Turbo 5 Max (dash) — uwuAOSP 16.2
====================================================================

This repository provides the device tree for the **Redmi Turbo 5 Max (dash)** adapted for **uwuAOSP 16.2** (`uwu-16.2` branch, Android 16 / Baklava / BP4A), ported from @YorokobiMaster's LineageOS 23.2 implementation.

## Device Specifications

| Attribute | Specification |
| :--- | :--- |
| **SoC** | MediaTek Dimensity 9500s (MT6991Z/ECZB, TSMC 3 nm) |
| **CPU** | Octa-core: 1x 3.73 GHz Cortex-X925 & 3x 3.30 GHz Cortex-X4 & 4x 2.40 GHz Cortex-A720 |
| **GPU** | Immortalis-G925 MC12 |
| **Memory** | 12/16 GB LPDDR5X RAM |
| **Storage** | 256/512 GB/1 TB UFS 4.1 |
| **Shipped OS** | HyperOS 3 (Android 16, API 36, VNDK 35) |
| **Battery** | 9000 mAh Si/C battery, 100W wired (PPS/PD3.0) |
| **Display** | 6.83" AMOLED, 1280 x 2772 (1.5K), 120 Hz |
| **Biometrics** | Ultrasonic under-display fingerprint |
| **Target ROM** | uwuAOSP 16.2 (`uwu-16.2`) |

---

## Quick Start (uwuAOSP 16.2 Build)

### 1. Initialize Manifest & Local Manifest

```bash
mkdir -p ~/uwuaosp-16.2 && cd ~/uwuaosp-16.2
repo init -u https://github.com/uwuAOSP/platform_manifests -b uwu-16.2 --git-lfs

# Add local manifest for dash
mkdir -p .repo/local_manifests
cp device/xiaomi/dash/docs/dash.xml .repo/local_manifests/dash.xml

# Sync source
repo sync -c -j$(nproc) --force-sync --no-clone-bundle --no-tags
```

### 2. Standard userdebug Build

```bash
source build/envsetup.sh
lunch custom_dash-bp4a-userdebug
m bacon -j$(nproc)
```

### 3. Production user / release-keys Build

1. Generate 4096-bit RSA keys:
   ```bash
   ./device/xiaomi/dash/keys/gen_release_keys.sh ~/.android-certs
   ```
2. Build with release keys:
   ```bash
   source build/envsetup.sh
   lunch custom_dash-bp4a-user
   m DASH_RELEASE_KEYS=true DASH_KEYDIR=$HOME/.android-certs \
     DASH_AVB_KEY_PATH=$HOME/.android-certs/avb.pk8 bacon -j$(nproc)
   ```

---

## Key Adaptations from lineage-23.2

1. **ROM Heritage**:
   - Switched from `vendor/lineage/config/common_full_phone.mk` to `vendor/custom/config/common_full_phone.mk`.
   - Preserved Lineage SDK and hardware components while cleanly importing uwuAOSP / PixelOS custom extensions and Pixel GMS suite.
2. **Product & Lunch Choices**:
   - Added `custom_dash.mk` (`PRODUCT_NAME := custom_dash`) and compatibility alias `uwu_dash.mk`.
   - Provided `custom_dash-bp4a-user` and `custom_dash-bp4a-userdebug` targets.
3. **GMS Decoupling**:
   - Conditional inclusion via `ifneq ($(WITH_GMS),true)` in `device.mk` to avoid package collisions between device-level MindTheGApps and uwuAOSP's native Pixel GMS suite.
4. **AVB 2.0 Key Flexibility**:
   - Enabled flexible resolution for `BOARD_AVB_KEY_PATH` supporting custom release keys and user builds (`--flags 0`).

---

## License

[Apache-2.0](LICENSE)
