#
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2025 The LineageOS Project
# Copyright (C) 2026 The uwuAOSP Project
#
# uwuAOSP 16.2 (branch uwu-16.2) 公共产品片段 — Redmi Turbo 5 Max (dash)
#

# ---------------------------------------------------------------------------
# 0) uwuAOSP 钩子变量 —— 必须最早赋值（早于任何 inherit-product）
#
#    vendor/custom/config/version.mk 会展开：
#        ro.custom.device  = $(CUSTOM_BUILD)
#        ro.custom.version = uwuAOSP_$(CUSTOM_VERSION)
#
#    vendor/custom/build/envsetup.sh 仅对 `custom_*` 前缀自动导出 CUSTOM_BUILD，
#    这里用 ?= 兜底，使 uwu_dash-* lunch 同样被正确识别。
# ---------------------------------------------------------------------------
CUSTOM_BUILD   ?= dash
CUSTOM_VERSION ?= 16.2

# ---------------------------------------------------------------------------
# 1) GMS 互斥开关
#    uwuAOSP 的 vendor/custom/config/pixel.mk 已注入完整 Pixel GMS（WITH_GMS := true）。
#    此处提前置位，消除 device.mk 解析时的顺序竞态。
# ---------------------------------------------------------------------------
WITH_GMS         ?= true
DASH_INJECT_MTGA ?= false

# LineageParts（org.lineageos.parts）RRO 覆盖层开关
DASH_WITH_LINEAGE_PARTS ?= false

# ---------------------------------------------------------------------------
# 2) 发布构建签名钩子（user / release-keys）
#    用法：m DASH_RELEASE_KEYS=true DASH_KEYDIR=$HOME/.android-certs ...
# ---------------------------------------------------------------------------
DASH_RELEASE_KEYS ?= false
DASH_KEYDIR       ?= $(HOME)/.android-certs

# ---------------------------------------------------------------------------
# 3) 架构：dash 为 64-bit-only（arm64-v8a，无 32 位支持）
# ---------------------------------------------------------------------------
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# dash 专属能力开关（DashWake / DashCharging / DashLedService 等读取）
DASH_ENABLE_POWER_HOOKS ?= true

# ---------------------------------------------------------------------------
# 4) 设备配置
# ---------------------------------------------------------------------------
$(call inherit-product, device/xiaomi/dash/device.mk)

# ---------------------------------------------------------------------------
# 5) uwuAOSP 公共配置 —— 唯一入口
#    vendor/custom/config/common_full_phone.mk 内部已串联：
#        vendor/lineage/config/common_full_phone.mk
#        vendor/custom/config/common.mk
#             └─ vendor/custom/config/pixel.mk   (Pixel GMS, WITH_GMS := true)
# ---------------------------------------------------------------------------
LINEAGE_BUILDTYPE ?= RAWHIDE
$(call inherit-product, vendor/custom/config/common_full_phone.mk)

TARGET_FORCE_OTA_PACKAGE := false

# ---------------------------------------------------------------------------
# 6) 产品身份（fingerprint 组成部分，必须与源树保持一致）
# ---------------------------------------------------------------------------
PRODUCT_BRAND                := Redmi
PRODUCT_DEVICE               := dash
PRODUCT_MANUFACTURER         := Xiaomi
PRODUCT_MODEL                := 2602BRT18C

PRODUCT_SYSTEM_NAME          := dash
PRODUCT_SYSTEM_DEVICE        := dash
PRODUCT_SYSTEM_BRAND         := Redmi
PRODUCT_SYSTEM_MODEL         := 2602BRT18C
PRODUCT_SYSTEM_MANUFACTURER  := Xiaomi

PRODUCT_RELEASE_NAME         := dash
PRODUCT_GMS_CLIENTID_BASE    := android-xiaomi

# 屏幕尺寸（用于 bootanimation 分辨率适配）
TARGET_SCREEN_WIDTH          := 1280
TARGET_BOOT_ANIMATION_RES    := 1280

# ---------------------------------------------------------------------------
# 7) release-keys 签名注入（仅 DASH_RELEASE_KEYS=true 时生效）
# ---------------------------------------------------------------------------
ifeq ($(DASH_RELEASE_KEYS),true)
PRODUCT_DEFAULT_DEV_CERTIFICATE := $(DASH_KEYDIR)/releasekey
PRODUCT_OTA_PUBLIC_KEYS         += $(DASH_KEYDIR)/otakey
PRODUCT_EXTRA_RECOVERY_KEYS     += $(DASH_KEYDIR)/otakey
endif
