#!/bin/bash
# ==================================================
#  █████╗ ██╗   ██╗██████╗ ██╗███████╗███████╗
# ██╔══██╗██║   ██║██╔══██╗██║██╔════╝██╔════╝
# ███████║██║   ██║██║  ██║██║███████╗█████╗  
# ██╔══██║██║   ██║██║  ██║██║╚════██║██╔══╝  
# ██║  ██║╚██████╔╝██████╔╝██║███████║███████╗
# ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝╚══════╝╚══════╝
#      AUDI RS6 AR PROJECT - FUTURISTIC SETUP
# ==================================================

LOG_FILE="$HOME/AudiRS6_AR/setup_log.txt"
PROJECT_NAME="AudiRS6_AR"
MODEL_FILE="rs6.fbx"

detect_os() {
    OS="unknown"
    case "$(uname -s)" in
        Linux*) OS="linux";;
        Darwin*) OS="macos";;
        *) echo "[❌ ERRORE] Sistema operativo non supportato." && exit 1;;
    esac
    echo "[🌍 INFO] Sistema operativo rilevato: $OS" | tee -a $LOG_FILE
}

install_unity() {
    echo "[🔍 INFO] Controllo installazione Unity..." | tee -a $LOG_FILE

    UNITY_VERSION=$(unityhub --version 2>/dev/null)
    if [[ -z "$UNITY_VERSION" ]]; then
        echo "[🚀 INFO] Unity Hub non trovato. Installazione in corso..." | tee -a $LOG_FILE
        open "https://unity.com/download"
        exit 1
    fi

    echo "[✅ INFO] Unity Hub rilevato: Versione $UNITY_VERSION" | tee -a $LOG_FILE
}

install_project() {
    echo "[🚀 INFO] Avvio installazione per $OS..." | tee -a $LOG_FILE
    PROJECT_DIR="$HOME/$PROJECT_NAME"
    mkdir -p "$PROJECT_DIR/Assets/Models"
    cp "$MODEL_FILE" "$PROJECT_DIR/Assets/Models/" || echo "[❌ ERRORE] File modello non trovato." | tee -a $LOG_FILE

    UNITY_EXEC=$(which unity)
    echo "[📦 INFO] Installazione pacchetti Unity richiesti..." | tee -a $LOG_FILE
    $UNITY_EXEC -batchmode -executeMethod UnityEditor.PackageManager.Client.Add -args "com.unity.render-pipelines.universal" -quit
    $UNITY_EXEC -batchmode -executeMethod UnityEditor.PackageManager.Client.Add -args "com.unity.xr.arfoundation" -quit

    echo "[✅ INFO] SETUP COMPLETATO! Avviando Unity..." | tee -a $LOG_FILE
    $UNITY_EXEC "$PROJECT_DIR" &
}

echo "=================================================="
echo "   🚀 BENVENUTO NEL SETUP FUTURISTICO DI AUDI RS6 🚀"
echo "=================================================="
echo "1) Installa Unity"
echo "2) Installa il progetto"
echo "3) Esci"
read -p "Scelta: " MENU_CHOICE

detect_os

case "$MENU_CHOICE" in
    1) install_unity; exit 0;;
    2) install_project; exit 0;;
    3) exit 0;;
    *) echo "[❌ ERRORE] Scelta non valida."; exit 1;;
esac
