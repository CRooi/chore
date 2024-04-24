#!/bin/bash

wget -O config.json https://raw.githubusercontent.com/CRooi/chore/main/config.json

openssl ecparam -genkey -name prime256v1 -out private.key
openssl req -new -x509 -days 36500 -key private.key -out cert.crt -subj "/CN=www.bing.com"

ip=$(curl ip.sb)

uuid=$(sing-box generate uuid)
password_uuid=$(sing-box generate uuid)

keypair_output=$(sing-box generate reality-keypair)
private_key=$(echo "$keypair_output" | grep 'PrivateKey:' | cut -d ' ' -f 2)
public_key=$(echo "$keypair_output" | grep 'PublicKey:' | cut -d ' ' -f 2)
short_id=$(printf '%x\n' $((RANDOM % 256**4)))

ss_password=$(sing-box generate rand --base64 16)

sed -i "s/\[INPUT_UUID\]/$uuid/g" ./config.json
sed -i "s/\[INPUT_PRIVATE_KEY\]/$private_key/g" ./config.json
sed -i "s/\[INPUT_PASSWORD\]/$password_uuid/g" ./config.json
sed -i "s/\[INPUT_SHORT_ID\]/$short_id/g" ./config.json
sed -i "s/\[INPUT_SS_PASSWORD\]/$ss_password/g" ./config.json

echo "config.json has been updated."

echo ""

echo "=== IP Address ==="
echo "$ip"

echo ""

echo "=== Reality ==="
echo "PrivateKey: $private_key"
echo "ShortID: $short_id"

echo ""

echo "=== Hysteria2 ==="
echo "UUID: $uuid"

echo ""

echo "=== Shadowsocks 2022 ==="
echo "Password: $ss_password"

echo ""

echo "=== Run ==="
echo "systemctl start sing-box.service"
echo "systemctl status sing-box.service"

echo ""