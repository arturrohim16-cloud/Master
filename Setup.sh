#!/bin/bash
# ==========================================
# Script: AJI STORE PREMIUM - ULTIMATE EDITION
# Fitur: SSH, VMESS, VLESS, TROJAN
# Sistem: AUTO-KILL IP & AUTO-BLOCK KUOTA GB
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

# 2. Fungsi Persiapan (Instalasi Pengukur Kuota)
function pre_install() {
    apt update && apt install uuid-runtime net-tools ufw iptables cron vnstat -y > /dev/null 2>&1
    systemctl enable vnstat && systemctl start vnstat
    # Buka Port
    iptables -I INPUT -p tcp --dport 22 -j ACCEPT
    iptables -I INPUT -p tcp --dport 80 -j ACCEPT
    iptables -I INPUT -p tcp --dport 443 -j ACCEPT
    ufw allow 22,80,443/tcp > /dev/null 2>&1
}

# 3. MESIN PEMANTAU OTOMATIS (IP & KUOTA)
function auto_limit_check() {
    while IFS=' | ' read -r user pass exp tipe maxip quota; do
        # --- A. CEK LIMIT IP (SSH) ---
        if [[ "$tipe" == "SSH" ]]; then
            jml_login=$(ps aux | grep -i sshd | grep -v grep | grep "$user" | wc -l)
            if [[ "$jml_login" -gt "$maxip" ]]; then
                pkill -u "$user"
            fi
        fi

        # --- B. CEK LIMIT KUOTA (GB) ---
        # Mengambil data pemakaian harian dari vnstat (dalam MB)
        # Note: Ini versi sederhana menggunakan total trafik interface utama
        usage_mb=$(vnstat --oneline | cut -d';' -f11 | sed 's/ MiB//' | cut -d. -f1)
        usage_gb=$((usage_mb / 1024))

        if [[ "$usage_gb" -ge "$quota" ]]; then
            # Jika kuota user tertentu habis (berdasarkan logika database)
            if [[ "$tipe" == "SSH" ]]; then
                passwd -l "$user" # Kunci akun SSH
                pkill -u "$user"
            else
                # Untuk Xray (Vmess/Vless/Trojan)
                # Logika: Hapus user dari config jika kuota habis
                sed -i "/$user/d" /etc/xray/config.json
                systemctl restart xray > /dev/null 2>&1
            fi
        fi
    done < /etc/xray/users/database.db
}

# 4. Fungsi Create SSH (Output Background Putih)
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
    echo -e "${BG_WHITE} $DOMAIN:22@$user:$pass ${NC}"
    echo -e "${BG_WHITE} $DOMAIN:80@$user:$pass ${NC}"
    echo -e "${BG_WHITE} $DOMAIN:443@$user:$pass ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " ${YELLOW}Payload (HTTP Custom)${NC}"
    echo -e "${BG_WHITE} GET / HTTP/1.1[crlf]Host: $DOMAIN[crlf]Connection: Keep-Alive[crlf][crlf] ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " Expiry     : $exp"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -n 1 -s -r -p "Tekan [Enter] untuk kembali..."
}

# 5. Dashboard Menu (24 Menu)
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

# --- SISTEM INSTALASI & CRON ---
if [[ "$1" == "--limit-check" ]]; then
    auto_limit_check
else
    pre_install
    if ! crontab -l | grep -q "limit-check"; then
        (crontab -l 2>/dev/null; echo "*/5 * * * * /usr/bin/menu --limit-check") | crontab -
    fi
    cp "$0" /usr/bin/menu
    chmod +x /usr/bin/menu
    menu
fi
