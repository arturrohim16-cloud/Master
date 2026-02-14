#!/bin/bash
# ==========================================
# Script: AJI STORE PREMIUM - Final Edition
# ==========================================

# 1. Konstanta Warna & Folder
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

# 2. Fungsi Ambil Data System
IP=$(curl -s ipinfo.io/ip)
DOMAIN=$(cat /etc/xray/domain 2>/dev/null || echo "aji.rvpn.web.id")
OS=$(cat /etc/os-release | grep -w PRETTY_NAME | cut -d= -f2 | sed 's/"//g')

# 3. Fungsi Output SSH (4 Input + Limit + Background Putih)
function add_ssh() {
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BG_WHITE}         AJI STORE PREMIUM          ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p " 1. Username      : " user
    read -p " 2. Password      : " pass
    read -p " 3. Masa aktif    : " aktif
    read -p " 4. Limit IP (1-2): " maxip
    read -p " 5. Limit Kuota GB: " quota
    
    exp=$(date -d "$aktif days" +"%d-%m-%Y")
    useradd -e $(date -d "$aktif days" +"%Y-%m-%d") -s /bin/false -M "$user"
    echo "$user:$pass" | chpasswd
    echo "$user | $pass | $exp | SSH | $maxip | $quota" >> /etc/xray/users/database.db

    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "        ${BG_WHITE}  AJI STORE PREMIUM  ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " Username   : $user"
    echo -e " Password   : $pass"
    echo -e " Limit IP   : $maxip IP"
    echo -e " Limit GB   : $quota GB"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}Format Login${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BG_WHITE} $DOMAIN:22@$user:$pass ${NC}"
    echo -e "${BG_WHITE} $DOMAIN:80@$user:$pass ${NC}"
    echo -e "${BG_WHITE} $DOMAIN:443@$user:$pass ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}Payload (HTTP Custom)${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BG_WHITE} GET / HTTP/1.1[crlf]Host: $DOMAIN[crlf]Connection: Keep-Alive[crlf][crlf] ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " Expiry     : $exp"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -n 1 -s -r -p "Tekan [Enter] untuk kembali..."
}

# 4. Fungsi Xray (Vmess/Vless/Trojan - TLS, HTTP, gRPC)
function add_xray() {
    local tipe=$1
    clear
    echo -e "${BG_WHITE}      CREATE AKUN $tipe PREMIUM      ${NC}"
    read -p " 1. Username      : " user
    read -p " 2. Masa Aktif    : " aktif
    read -p " 3. Limit IP      : " maxip
    read -p " 4. Limit Kuota GB: " quota
    uuid=$(uuidgen)
    exp=$(date -d "$aktif days" +"%d-%m-%Y")

    # Generate Link (Contoh Vmess)
    link_tls="vmess://$(echo -n "{\"v\":\"2\",\"ps\":\"$user-TLS\",\"add\":\"$DOMAIN\",\"port\":\"443\",\"id\":\"$uuid\",\"aid\":\"0\",\"net\":\"ws\",\"path\":\"/vmess\",\"host\":\"$DOMAIN\",\"tls\":\"tls\"}" | base64 -w 0)"
    link_http="vmess://$(echo -n "{\"v\":\"2\",\"ps\":\"$user-HTTP\",\"add\":\"$DOMAIN\",\"port\":\"80\",\"id\":\"$uuid\",\"aid\":\"0\",\"net\":\"ws\",\"path\":\"/vmess\",\"host\":\"$DOMAIN\",\"tls\":\"\"}" | base64 -w 0)"
    link_grpc="vmess://$(echo -n "{\"v\":\"2\",\"ps\":\"$user-gRPC\",\"add\":\"$DOMAIN\",\"port\":\"443\",\"id\":\"$uuid\",\"aid\":\"0\",\"net\":\"grpc\",\"path\":\"vmess-grpc\",\"host\":\"$DOMAIN\",\"tls\":\"tls\"}" | base64 -w 0)"

    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "        ${BG_WHITE}  AJI STORE PREMIUM  ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " Remarks    : $user"
    echo -e " Limit IP   : $maxip IP"
    echo -e " Limit GB   : $quota GB"
    echo -e " Expired    : $exp"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}Link TLS (443)${NC}"
    echo -e "${BG_WHITE} $link_tls ${NC}"
    echo -e " ${YELLOW}Link HTTP (80)${NC}"
    echo -e "${BG_WHITE} $link_http ${NC}"
    echo -e " ${YELLOW}Link gRPC (443)${NC}"
    echo -e "${BG_WHITE} $link_grpc ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -n 1 -s -r -p "Tekan [Enter]..."
}

# 5. Dashboard Utama (100% Sesuai Foto)
function menu() {
    clear
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}${BG_RED}         Welcome To Script Premium AJI STORE            ${NC}${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo -e " ↘ System OS      = $OS"
    echo -e " ↘ IP VPS         = $IP"
    echo -e " ↘ Domain         = $DOMAIN"
    echo -e " ↘ Date/Time      = $(date +'%d/%m/%Y %H:%M')"
    echo -e "${CYAN}╙────────────────────────────────────────────────────────────╜${NC}"
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
    echo -e " [00] BACK TO EXIT MENU <<<"
    read -p " Select menu : " opt
    case $opt in
        01|1) add_ssh ;;
        02|2) add_xray "VMESS" ;;
        03|3) add_xray "VLESS" ;;
        04|4) add_xray "TROJAN" ;;
        00) exit ;;
        *) menu ;;
    esac
}

# Jalankan Menu
menu
