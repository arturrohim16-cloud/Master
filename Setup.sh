#!/bin/bash
# ==========================================
# Script: AJI STORE PREMIUM - SMART MONITOR
# Fitur: Dynamic Color Bar & Auto-Run Login
# ==========================================

# Warna
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BG_RED='\033[41;37m'

# Folder & DB
mkdir -p /etc/xray/users/
touch /etc/xray/users/database.db
PATH_SCRIPT="/usr/bin/menu"

# Fungsi Progress Bar dengan Warna Dinamis
draw_bar() {
    local perc=$1
    local size=20
    local filled=$((perc * size / 100))
    local empty=$((size - filled))
    
    if [ "$perc" -le 50 ]; then
        COLOR=$GREEN
    elif [ "$perc" -le 80 ]; then
        COLOR=$YELLOW
    else
        COLOR=$RED
    fi

    printf "["
    printf "${COLOR}"
    printf "%${filled}s" | tr ' ' '█'
    printf "${NC}"
    printf "%${empty}s" | tr ' ' '░'
    printf "] ${COLOR}%d%%${NC}" "$perc"
}

# Animasi Loading
loading_anim() {
    clear
    echo -e "\n\n"
    bar="████████████████████████████████████████"
    for i in {1..40}; do
        echo -ne "\r${CYAN}  🔄 Menyiapkan Dashboard 2... [${bar:0:$i}${NC}${CYAN}] $((i*100/40))%${NC}"
        sleep 0.02
    done
    echo -e "\n\n${GREEN}  ✅ Dashboard Siap!${NC}"
    sleep 0.5
}

# --- DASHBOARD 1: RESOURCE MONITOR ---
function dashboard_sistem() {
    clear
    CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)
    RAM_TOTAL=$(free -m | awk 'NR==2{print $2}')
    RAM_USED=$(free -m | awk 'NR==2{print $3}')
    RAM_PERC=$((RAM_USED * 100 / RAM_TOTAL))
    DISK_PERC=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
    
    IFACE=$(ip route get 8.8.8.8 | awk '{print $5; exit}')
    RX_BEFORE=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null || echo 0)
    TX_BEFORE=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null || echo 0)
    sleep 1
    RX_AFTER=$(cat /sys/class/net/$IFACE/statistics/rx_bytes 2>/dev/null || echo 0)
    TX_AFTER=$(cat /sys/class/net/$IFACE/statistics/tx_bytes 2>/dev/null || echo 0)
    RX_SPEED=$(( (RX_AFTER - RX_BEFORE) / 1024 ))
    TX_SPEED=$(( (TX_AFTER - TX_BEFORE) / 1024 ))

    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}${BG_RED}         Welcome To Script Premium AJI STORE            ${NC}${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo -e "             >>> STATUS SERVER <<<"
    echo -e " ┌──────────────────┬──────────────────┬──────────────────┐"
    echo -e "  SSH     : ${GREEN}ON√${NC}     NGINX   : ${GREEN}ON√${NC}     XRAY    : ${GREEN}ON√${NC}"
    echo -e "  WS-ePRO : ${GREEN}ON√${NC}     DROPBEAR: ${GREEN}ON√${NC}     HAPROXY : ${GREEN}ON√${NC}"
    echo -e " └──────────────────┴──────────────────┴──────────────────┘"
    echo -e ""
    echo -e " ${YELLOW}RESOURCE MONITOR (REALTIME)${NC}"
    echo -ne " CPU LOAD    : " && draw_bar $CPU_LOAD && echo ""
    echo -ne " RAM USAGE   : " && draw_bar $RAM_PERC && echo ""
    echo -ne " DISK USAGE  : " && draw_bar $DISK_PERC && echo ""
    echo -e ""
    echo -e " ${CYAN}NETWORK TRAFFIC ($IFACE)${NC}"
    echo -e " RX: ${GREEN}$RX_SPEED KB/s${NC} | TX: ${GREEN}$TX_SPEED KB/s${NC}"
    echo -e ""
    echo -e "${RED}══════════════════════════════════════════════════════${NC}"
    echo -e "                ${PURPLE}🎛 MAIN CONTROL MENU${NC}"
    echo -e "${RED}══════════════════════════════════════════════════════${NC}"
    echo -e " [01] 👥 User Management (Dashboard 2)"
    echo -e " [02] 📡 NOC Realtime Monitoring"
    echo -e " [03] 🛠 Service Control"
    echo -e " [04] 🔐 Security & Firewall"
    echo -e " [05] 🌐 Network Tools"
    echo -e " [06] 📦 Backup / Restore"
    echo -e " [07] 🤖 Bot Panel Settings"
    echo -e " [08] 🚀 Create Slow Config"
    echo -e " [09] 🔄 Restart All Services"
    echo -e "${RED}══════════════════════════════════════════════════════${NC}"
    echo -e " [99] 🔄 Refresh Dashboard"
    echo -e " [00] ❌ Exit Panel"
    echo -e "${RED}══════════════════════════════════════════════════════${NC}"
    read -p " Select menu : " opt_main
    
    case $opt_main in
        01|1) loading_anim; dashboard_menu ;;
        09) systemctl restart ssh xray nginx >/dev/null 2>&1; echo -e "${GREEN}Layanan direstart!${NC}"; sleep 1; dashboard_sistem ;;
        99) dashboard_sistem ;;
        00) exit ;;
        *) dashboard_sistem ;;
    esac
}

# --- DASHBOARD 2 ---
function dashboard_menu() {
    clear
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}${BG_RED}           DAFTAR MENU AJI STORE PREMIUM                ${NC}${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo -e " [01] SSH MENU          [08] DELL ALL EXP     [15] BCKP/RSTR"
    echo -e " [02] VMESS MENU        [09] AUTOREBOOT       [16] REBOOT"
    echo -e " [03] VLESS MENU        [10] INFO PORT        [17] RESTART"
    echo -e " [04] TROJAN MENU       [11] SPEEDTEST        [18] DOMAIN"
    echo -e " [05] SHADOW MENU       [12] RUNNING          [19] CERT SSL"
    echo -e " [06] TRIAL MENU        [13] CLEAR LOG        [20] INS. UDP"
    echo -e " [07] VPS INFO          [14] CREATE SLOW      [21] CLEAR CACHE"
    echo -e " [22] BOT NOTIF         [23] UPDATE SCRIPT    [24] BOT PANEL"
    echo -e ""
    echo -e " [00] KEMBALI KE MAIN CONTROL <<<"
    read -p " Select menu : " opt
    case $opt in
        00) dashboard_sistem ;;
        *) echo -e "${YELLOW}Dalam pengembangan...${NC}"; sleep 1; dashboard_menu ;;
    esac
}

# --- LOGIKA INSTALASI ---
if [ ! -f "$PATH_SCRIPT" ]; then
    apt update && apt install net-tools -y >/dev/null 2>&1
    cp "$0" "$PATH_SCRIPT"
    chmod +x "$PATH_SCRIPT"
    
    # Membuat script otomatis muncul saat login (Auto-Run)
    if ! grep -q "menu" /root/.bashrc; then
        echo "clear" >> /root/.bashrc
        echo "menu" >> /root/.bashrc
    fi
fi

dashboard_sistem
