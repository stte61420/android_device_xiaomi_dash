#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# 生成 Android release-keys 全套 4096-bit RSA 签名材料（私钥保存在本地，绝不入库）
set -euo pipefail

KEYDIR="${1:-$HOME/.android-certs}"
SUBJECT="${2:-/C=CN/ST=Beijing/L=Beijing/O=stte61420/OU=AndroidROM/CN=uwuAOSP-dash-release}"
DAYS="${DAYS:-10000}"

umask 077
mkdir -p "$KEYDIR"
chmod 700 "$KEYDIR"

gen_key() {
    local name="$1"
    echo "[*] generating RSA-4096 key: $name"
    openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 \
        -out "$KEYDIR/$name.pem" 2>/dev/null
    openssl pkcs8 -topk8 -inform PEM -outform DER -nocrypt \
        -in "$KEYDIR/$name.pem" -out "$KEYDIR/$name.pk8"
    openssl req -new -x509 -sha256 -key "$KEYDIR/$name.pem" \
        -out "$KEYDIR/$name.x509.pem" -days "$DAYS" -subj "$SUBJECT" \
        -set_serial 0x"$(openssl rand -hex 16)"
    shred -u "$KEYDIR/$name.pem"
}

# APK/JAR 签名证书
for k in releasekey platform shared media networkstack otakey; do
    gen_key "$k"
done

# 可选：SDK Sandbox
[ "${GEN_SDK_SANDBOX:-0}" = "1" ] && gen_key sdk_sandbox

# dm-verity
gen_key verity

# AVB 2.0 密钥（4096-bit 匹配 SHA256_RSA4096）
gen_key avb

# 提取 AVB 公钥指纹（用于比对和 fastboot 刷入验证）
if command -v avbtool >/dev/null 2>&1; then
    avbtool extract_public_key --key "$KEYDIR/avb.pk8" --output "$KEYDIR/avb_pkmd.bin"
fi

echo
echo "[✔] key material ready in: $KEYDIR"
ls -l "$KEYDIR"
echo
echo "[!] 注意：私钥 (*.pk8) 属于绝密凭证，务必备份并妥善保存，严禁提交到 git 仓库！"
