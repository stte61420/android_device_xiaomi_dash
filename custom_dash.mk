#
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2025 The LineageOS Project
# Copyright (C) 2026 The uwuAOSP Project
#
# uwuAOSP 16.2 主产物 — Redmi Turbo 5 Max (dash)
#
#   lunch custom_dash-bp4a-userdebug   # 开发调试构建
#   lunch custom_dash-bp4a-user        # 正式发布构建
#

DASH_RELEASE_KEYS ?= false

include device/xiaomi/dash/uwu_product_common.mk

PRODUCT_NAME := custom_dash
