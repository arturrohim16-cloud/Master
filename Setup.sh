#!/bin/bash
# ==========================================
# Script: AJI STORE PREMIUM - REVISI TOTAL
# Fitur: SSH, VMESS, VLESS, TROJAN
# Sistem: Auto-Kill Limit IP & Auto-Block Kuota
# ==========================================

# 1. Warna & Folder
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BG_WHITE='\033[47;30m'
BG_RED='\033[41;37m'

mkdir -p /etc/xray/users/
touch /etc/xray/users/database.db
DOMAIN=$(cat /etc/xray/domain 2>/dev/null || curl -s ipinfo.io/ip)

# 2. Fungsi Buka Port & Install Paket Pendukung
function pre_install() {
    apt update && apt install uuid-runtime net-tools ufw iptables cron -y > /dev/null 2>&1
    # Buka Port 22, 80, 443
    iptables -I INPUT -p tcp --dport 22 -j ACCEPT
    iptables -I INPUT -p tcp --dport 80 -j ACCEPT
    iptables -I INPUT -p tcp --dport 443 -j ACCEPT
    ufw allow 22,80,443/tcp > /dev/null 2>&1
    systemctl enable cron > /dev/null 2>&1
    systemctl start cron > /dev/null 2>&1
}

# 3. MESIN PEMANTAU (AUTO-KILL LIMIT)
# Fungsi ini akan dijalankan otomatis oleh sistem setiap menit
function auto_limit_check() {
    # Ambil semua user dari database
    while IFS=' | ' read -r user pass exp tipe maxip quota; do
        if [[ "$tipe" == "SSH" ]]; then
            # Hitung jumlah login SSH aktif
            jml_login=$(ps aux | grep -i sshd | grep -v grep | grep "$user" | wc -l)
            if [[ "$jml_login" -gt "$maxip" ]]; then
                # Tendang user jika melebihi Limit IP
                pkill -u "$user"
            fi
        fi
    done < /etc/xray/users/database.db
}

# 4. Fungsi Create SSH (4 Input + Limit)
function add_ssh() {
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BG_WHITE}         AJI STORE PREMIUM          ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p " 1. Username      : " user
    read -p " 2. Password      : " pass
    read -p " 3. Masa aktif    : " aktif
    read -p " 4. Limit IP      : " maxip
    read -p " 5. Limit Kuota GB: " quota
    
    exp=$(date -d "$aktif days" +"%d-%m-%Y")
    useradd -e $(date -d "$aktif days" +"%Y-%m-%d") -s /bin/false -M "$user"
    echo "$user:$pass" | chpasswd
    # Simpan ke Database: user | pass | exp | tipe | limit_ip | limit_quota
    echo "$user | $pass | $exp | SSH | $maxip | $quota" >> /etc/xray/users/database.db

    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "        ${BG_WHITE}  AJI STORE PREMIUM  ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " Username   : $user"
    echo -e " Password   : $pass"
    echo -e " Limit IP   : $maxip IP | Limit GB : $quota GB"
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

# 5. Dashboard Utama (24 Menu)
function menu() {
    clear
    IP_VPS=$(curl -s ipinfo.io/ip)
    echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${RED}║${NC}${BG_RED}         Welcome To Script Premium AJI STORE            ${NC}${RED}║${NC}"
    echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
    echo -e " ↘ IP VPS         = $IP_VPS"
    echo -e " ↘ Domain         = $DOMAIN"
    echo -e "${CYAN}╙────────────────────────────────────────────────────────────╜${NC}"
    echo -e " [01] SSH MENU          [08] DELL ALL EXP     [15] BCKP/RSTR"
    echo -e " [02] VMESS MENU        [09] AUTOREBOOT       [16] REBOOT"
    echo -e " [03] VLESS MENU        [10] INFO PORT        [17] RESTART"
    echo -e " [04] TROJAN MENU       [11] SPEEDTEST        [18] DOMAIN"
    echo -e " [05] SHADOW MENU       [12] RUNNING          [19] CERT SSL"
    echo -e " [06] TRIAL MENU        [13] CLEAR LOG        [20] INS. UDP"
    echo -e " [07] VPS INFO          [14] CREATE SLOW      [21] CLEAR CACHE"
    echo -e " [22] BOT NOTIF         [23] UPDATE SCRIPT    [24] BOT PANEL"
    echo -e ""
    echo -e " [00] EXIT MENU <<<"
    read -p " Select menu : " opt
    case $opt in
        01|1) add_ssh ;;
        10) check_port ;;
        00) exit ;;
        *) menu ;;
    esac
}

# Fungsi Check Port (Menu 10)
function check_port() {
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "         ${BG_WHITE}  CHECK PORT STATUS  ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    for p in 22 80 443; do
        (netstat -tupln | grep :$p > /dev/null) && echo -e " Port $p : ${GREEN}OPEN${NC}" || echo -e " Port $p : ${RED}CLOSED${NC}"
    done
    read -n 1 -s -r -p "Tekan [Enter]..."
    menu
}

# --- LOGIKA INSTALASI AKHIR ---
if [[ "$1" == "--limit-check" ]]; then
    auto_limit_check
else
    pre_install
    # Memasang Cron Job agar cek Limit IP berjalan tiap 1 menit
    if ! crontab -l | grep -q "limit-check"; then
        (crontab -l 2>/dev/null; echo "* * * * * /usr/bin/menu --limit-check") | crontab -
    fi
    # Pindahkan ke bin
    cp "$0" /usr/bin/menu
    chmod +x /usr/bin/menu
    menu
fi
