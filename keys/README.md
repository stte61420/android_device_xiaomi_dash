# Release Keys Guide for dash (uwuAOSP 16.2)

本目录用于存放发布构建的公钥材料与证书生成脚本。

> **警告**：绝对禁止将私钥（`*.pk8` / `*.pem`）提交到任何 Git 仓库！

## 1. 生成 4096-bit 签名材料

在编译服务器或离线签名机上执行：

```bash
./device/xiaomi/dash/keys/gen_release_keys.sh ~/.android-certs
```

生成的密钥包括：
- `releasekey`: 基础/默认应用签名
- `platform`: 系统核心（system uid）签名
- `shared`: 共享数据（shared uid）签名
- `media`: 媒体服务签名
- `networkstack`: 网络栈签名
- `otakey`: OTA 包校验公钥
- `avb`: Android Verified Boot 2.0 签名（RSA 4096，配对 `BOARD_AVB_ALGORITHM := SHA256_RSA4096`）

## 2. 编译发布版注入

```bash
source build/envsetup.sh
lunch custom_dash-bp4a-user
m DASH_RELEASE_KEYS=true DASH_KEYDIR=$HOME/.android-certs \
  DASH_AVB_KEY_PATH=$HOME/.android-certs/avb.pk8 bacon -j$(nproc)
```
