#
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2025 The LineageOS Project
# Copyright (C) 2026 The uwuAOSP Project
#
# Product registration — Redmi Turbo 5 Max (dash)
#
# custom_dash : uwuAOSP 官方命名（vendor/custom/build/envsetup.sh 识别 `custom_` 前缀）
# uwu_dash    : 兼容别名（envsetup 不识别该前缀，靠 uwu_product_common.mk 的 CUSTOM_BUILD ?= dash 兜底）
# lineage_dash: 保持 LineageOS 构建兼容
#

PRODUCT_MAKEFILES := \
    $(LOCAL_DIR)/custom_dash.mk \
    $(LOCAL_DIR)/uwu_dash.mk \
    $(LOCAL_DIR)/lineage_dash.mk

COMMON_LUNCH_CHOICES := \
    custom_dash-bp4a-user \
    custom_dash-bp4a-userdebug \
    uwu_dash-bp4a-user \
    uwu_dash-bp4a-userdebug \
    lineage_dash-bp4a-userdebug
