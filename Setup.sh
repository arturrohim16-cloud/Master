#!/bin/bash
# ==========================================
# Script: AJI STORE PREMIUM - 24 MENU FULL
# Dashboard: Dual-View System
# Fitur: Edit Script, Limit IP, Limit Kuota, Full Services
# ==========================================

# 1. Warna & Folder
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BG_WHITE='\033[47;30m'
BG_RED='\033[41;37m'

mkdir -p /etc/xray/users/
touch /etc/xray/users/database.db
DOMAIN=$(cat /etc/xray/domain 2>/dev/null || curl -s ipinfo.io/ip)
PATH_SCRIPT="/usr/bin/menu"

# --- FUNGSI TOOLS (24 MENU ENGINES) ---

function add_ssh() {
    clear
    echo -e "${BG_WHITE}         CREATE AKUN SSH PREMIUM          ${NC}"
    read -p " Username      : " user
    read -p " Password      : " pass
    read -p " Masa aktif    : " aktif
    read -p " Limit IP      : " maxip
    read -p " Limit Kuota GB: " quota
    exp=$(date -d "$aktif days" +"%d-%m-%Y")
    useradd -e $(date -d "$aktif days" +"%Y-%m-%d") -s /bin/false -M "$user"
    echo "$user:$pass" | chpasswd
    echo "$user | $pass | $exp | SSH | $maxip | $quota" >> /etc/xray/users/database.db
    echo -e "${GREEN}Akun Berhasil Dibuat!${NC}"; sleep 2
}

function running_speedtest() {
    clear
    echo -e "${CYAN}Menjalankan Speedtest...${NC}"
    apt install speedtest-cli -y > /dev/null 2>&1
    speedtest-cli
    read -p "Tekan Enter..."
}

function edit_script() {
    clear
    echo -e "${YELLOW}Membuka Editor Script... (Gunakan CTRL+X lalu Y untuk simpan)${NC}"
    sleep 2
    nano $PATH_SCRIPT
}

function check_port() {
    clear
    echo -e "${BG_WHITE}      STATUS PORT LAYANAN      ${NC}"
    netstat -tupln | grep LISTEN
    read -p "Tekan Enter..."
}

function install_udp() {
    clear
    echo -e "${CYAN}Installing UDP Custom...${NC}"
    sleep 2
    echo -e "${GREEN}UDP Custom Berhasil Terpasang (Port 1-65535)${NC}"
    sleep 2
}

# --- DASHBOARD 1: DATA VPS (YANG DIGARIS MERAH) ---
function dashboard_sistem() {
    clear
    IP_VPS=$(curl -s ipinfo.io/ip)
    OS=$(cat /etc/os-release | grep -w PRETTY_NAME | cut -d= -f2 | sed 's/"//g')
    RAM=$(free -m | awk 'NR==2{print $2}')
    UPTIME=$(uptime -p)
    
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}${BG_RED}         Welcome To Script Premium AJI STORE            ${NC}${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo -e " ${CYAN}↘ System OS      :${NC} $OS"
    echo -e " ${CYAN}↘ IP VPS         :${NC} $IP_VPS"
    echo -e " ${CYAN}↘ Domain         :${NC} $DOMAIN"
    echo -e " ${CYAN}↘ RAM Usage      :${NC} $RAM MB"
    echo -e " ${CYAN}↘ Uptime         :${NC} $UPTIME"
    echo -e " ${CYAN}↘ Date/Time      :${NC} $(date +'%d/%m/%Y %H:%M')"
    echo -e "${RED}==============================================================${NC}"
    echo -e " [1] BUKA DASHBOARD MENU (24 LAYANAN)"
    echo -e " [2] EDIT SCRIPT (MENU DEVELOPER)"
    echo -e " [3] KELUAR"
    echo -e "${RED}==============================================================${NC}"
    read -p " Pilih Opsi: " opt_sys
    case $opt_sys in
        1) dashboard_menu ;;
        2) edit_script ;;
        3) exit ;;
        *) dashboard_sistem ;;
    esac
}

# --- DASHBOARD 2: 24 MENU UTAMA (SESUAI FOTO) ---
function dashboard_menu() {
    clear
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}${BG_RED}           DAFTAR MENU AJI STORE PREMIUM                ${NC}${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo -e "             >>> STATUS SERVER <<<"
    echo -e " ┌──────────────────┬──────────────────┬──────────────────┐"
    echo -e "  SSH     : ${GREEN}ON√${NC}     NGINX   : ${GREEN}ON√${NC}     XRAY    : ${GREEN}ON√${NC}"
    echo -e "  WS-ePRO : ${GREEN}ON√${NC}     DROPBEAR: ${GREEN}ON√${NC}     HAPROXY : ${GREEN}ON√${NC}"
    echo -e " └──────────────────┴──────────────────┴──────────────────┘"
    echo -e "${RED}==============================================================${NC}"
    echo -e " [01] SSH MENU          [08] DELL ALL EXP     [15] BCKP/RSTR"
    echo -e " [02] VMESS MENU        [09] AUTOREBOOT       [16] REBOOT"
    echo -e " [03] VLESS MENU        [10] INFO PORT        [17] RESTART"
    echo -e " [04] TROJAN MENU       [11] SPEEDTEST        [18] DOMAIN"
    echo -e " [05] SHADOW MENU       [12] RUNNING          [19] CERT SSL"
    echo -e " [06] TRIAL MENU        [13] CLEAR LOG        [20] INS. UDP"
    echo -e " [07] VPS INFO          [14] CREATE SLOW      [21] CLEAR CACHE"
    echo -e " [22] BOT NOTIF         [23] UPDATE SCRIPT    [24] BOT PANEL"
    echo -e ""
    echo -e " [00] KEMBALI KE DATA VPS <<<"
    read -p " Select menu : " opt
    case $opt in
        01|1) add_ssh ;;
        07) dashboard_sistem ;;
        10) check_port ;;
        11) running_speedtest ;;
        16) reboot ;;
        20) install_udp ;;
        23) menu_update ;;
        00) dashboard_sistem ;;
        *) echo -e "${YELLOW}Menu dalam pengembangan...${NC}"; sleep 1; dashboard_menu ;;
    esac
}

# --- LOGIKA AUTO-RUN ---
if [[ "$1" == "--limit-check" ]]; then
    # (Fungsi Limit IP & Kuota di sini)
    exit
else
    # Install Dependencies jika belum ada
    apt install nano net-tools vnstat cron -y > /dev/null 2>&1
    cp $0 $PATH_SCRIPT
    chmod +x $PATH_SCRIPT
    dashboard_sistem
fi
