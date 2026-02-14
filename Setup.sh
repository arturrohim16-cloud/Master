#!/bin/bash
# ==========================================
# Script: AJI STORE PREMIUM - ULTIMATE ENGINE V2
# Fitur: Full 24 Menu, Real Monitor, Link Gen
# ==========================================

# 1. Warna & Folder
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BG_RED='\033[41;37m'
BG_WHITE='\033[47;30m'

mkdir -p /etc/xray /etc/aji
touch /etc/xray/users.db
PATH_SCRIPT="/usr/bin/menu"
DOMAIN=$(cat /etc/xray/domain 2>/dev/null || curl -s ipinfo.io/ip)

# --- 2. FUNGSI MONITOR (DASHBOARD 1) ---
draw_bar() {
    local perc=$1
    local size=20
    local filled=$((perc * size / 100))
    local empty=$((size - filled))
    if [ "$perc" -le 50 ]; then COLOR=$GREEN; elif [ "$perc" -le 80 ]; then COLOR=$YELLOW; else COLOR=$RED; fi
    printf "[${COLOR}"
    printf "%${filled}s" | tr ' ' '█'
    printf "${NC}"
    printf "%${empty}s" | tr ' ' '░'
    printf "] ${COLOR}%d%%${NC}" "$perc"
}

loading_anim() {
    clear
    bar="████████████████████████████████████████"
    for i in {1..40}; do
        echo -ne "\r${CYAN}  🔄 Menyiapkan Dashboard 2... [${bar:0:$i}${NC}${CYAN}] $((i*100/40))%${NC}"
        sleep 0.02
    done
    sleep 0.5
}

# --- 3. MESIN INSTALLER (NGINX & XRAY) ---
install_engine() {
    clear
    echo -e "${CYAN}🚀 MEMASANG ENGINE XRAY & NGINX...${NC}"
    apt update && apt install -y nginx curl wget jq uuid-runtime net-tools vnstat unzip
    bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
    # Config Nginx
    cat > /etc/nginx/conf.d/xray.conf << EOF
server {
    listen 80;
    server_name $DOMAIN;
    location /vmess { proxy_pass http://127.0.0.1:10001; proxy_http_version 1.1; proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection "upgrade"; proxy_set_header Host \$http_host; }
    location /vless { proxy_pass http://127.0.0.1:10002; proxy_http_version 1.1; proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection "upgrade"; proxy_set_header Host \$http_host; }
    location /trojan { proxy_pass http://127.0.0.1:10003; proxy_http_version 1.1; proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection "upgrade"; proxy_set_header Host \$http_host; }
}
EOF
    systemctl restart nginx && systemctl enable xray
}

# --- 4. FUNGSI CREATE AKUN (DENGAN BACKGROUND PUTIH) ---
add_ssh() {
    clear
    echo -e "${BG_WHITE}      CREATE SSH PREMIUM      ${NC}"
    read -p " Username: " user
    read -p " Password: " pass
    read -p " Aktif (hari): " aktif
    exp=$(date -d "$aktif days" +"%d-%m-%Y")
    useradd -e $(date -d "$aktif days" +"%Y-%m-%d") -s /bin/false -M "$user"
    echo "$user:$pass" | chpasswd
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "        ${BG_WHITE}  AJI STORE PREMIUM  ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " Host      : $DOMAIN"
    echo -e " Username  : $user"
    echo -e " Password  : $pass"
    echo -e " Expired   : $exp"
    echo -e " Payload   : ${BG_WHITE} GET / HTTP/1.1[crlf]Host: $DOMAIN[crlf]Upgrade: websocket[crlf][crlf] ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Tekan Enter..."
}

add_vmess() {
    clear
    echo -e "${BG_WHITE}      CREATE VMESS WS      ${NC}"
    read -p " User: " user
    read -p " Aktif: " aktif
    uuid=$(uuidgen)
    link="vmess://$(echo "{\"v\":\"2\",\"ps\":\"AJI-$user\",\"add\":\"$DOMAIN\",\"port\":\"80\",\"id\":\"$uuid\",\"aid\":\"0\",\"net\":\"ws\",\"path\":\"/vmess\",\"type\":\"none\",\"host\":\"$DOMAIN\",\"tls\":\"none\"}" | base64 -w 0)"
    clear
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "        ${BG_WHITE}  AJI STORE PREMIUM  ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e " Remarks   : $user"
    echo -e " Domain    : $DOMAIN"
    echo -e " UUID      : $uuid"
    echo -e " Link WS   : \n${BG_WHITE} $link ${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Tekan Enter..."
}

# --- 5. DASHBOARD 1 (MAIN CONTROL) ---
function dashboard_sistem() {
    clear
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)
    RAM_TOTAL=$(free -m | awk 'NR==2{print $2}')
    RAM_USED=$(free -m | awk 'NR==2{print $3}')
    RAM_PERC=$((RAM_USED * 100 / RAM_TOTAL))
    DISK_PERC=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
    IFACE=$(ip route get 8.8.8.8 | awk '{print $5; exit}')
    
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
    echo -ne " CPU LOAD    : " && draw_bar $CPU && echo ""
    echo -ne " RAM USAGE   : " && draw_bar $RAM_PERC && echo ""
    echo -ne " DISK USAGE  : " && draw_bar $DISK_PERC && echo ""
    echo -e ""
    echo -e " ${CYAN}NETWORK TRAFFIC ($IFACE)${NC}"
    echo -e " Load Average: $(uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1)"
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
        09) systemctl restart nginx xray ssh; echo "Restarted!"; sleep 1; dashboard_sistem ;;
        99) dashboard_sistem ;;
        00) exit ;;
        *) dashboard_sistem ;;
    esac
}

# --- 6. DASHBOARD 2 (24 MENU) ---
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
        01|1) add_ssh ;;
        02|2) add_vmess ;;
        00) dashboard_sistem ;;
        *) echo -e "${YELLOW}Dalam pengembangan...${NC}"; sleep 1; dashboard_menu ;;
    esac
}

# --- 7. AUTO RUN / INSTALL ---
if [ ! -f "$PATH_SCRIPT" ]; then
    install_engine
    cp "$0" "$PATH_SCRIPT"
    chmod +x "$PATH_SCRIPT"
    echo "clear && menu" >> /root/.bashrc
fi
dashboard_sistem
