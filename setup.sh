dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi
clear
# // Exporting Language to UTF-8
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'
BIRed='\033[1;91m'
red='\e[1;31m'
bo='\e[1m'
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
# // Export Banner Status Information
export EROR="[${RED} ERROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Exporting URL Host
export Server_URL="raw.githubusercontent.com/Zeastore/test/main"
export Server1_URL="raw.githubusercontent.com/Zeastore/limit/main"
export Server_Port="443"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther=".geovpn"

# // Exporting Script Version
export VERSION="1.1"
 
# // Exporint IP AddressInformation
export IP=$( curl -s https://ipinfo.io/ip/ )

# // License Validating
echo ""
read -p "Input Your License Key : " Input_License_Key

# // Checking Input Blank
if [[ $Input_License_Key ==  "" ]]; then
    echo -e "${EROR} Please Input License Key !${NC}"
    exit 1
fi

# // Checking License Validate
Key="$Input_License_Key"

# // Set Time To Jakarta / GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# // Algoritma Key
algoritmakeys="1920192019209129403940293013912" 
hashsuccess="$(echo -n "$Key" | sha256sum | cut -d ' ' -f 1)" 
Sha256Successs="$(echo -n "$hashsuccess$algoritmakeys" | sha256sum | cut -d ' ' -f 1)" 
License_Key=$Sha256Successs
echo ""
echo -e "${OKEY} Successfull Connected To Server"
sleep 1

# // Validate Result
Getting_Data_On_Server=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep $License_Key | cut -d ' ' -f 1 )
if [[ "$Getting_Data_On_Server" == "$License_Key" ]]; then
    mkdir -p /etc/${Auther}/
    echo "$License_Key" > /etc/${Auther}/license.key
    echo -e "${OKEY} License Validated !"
    sleep 1
else
    echo -e "${EROR} Your License Key Not Valid !"
    exit 1
fi
# // Checking Your VPS Blocked Or No
if [[ $IP == "" ]]; then
    echo -e "${EROR} Your IP Address Not Detected !"
    exit 1
else
    # // Checking Data
    export Check_Blacklist_Atau_Tidak=$( curl -s https://${Server_URL}/blacklist.txt | grep -w $License_Key | awk '{print $1}' | tr -d '\r' | tr -d '\r\n' | head -n1 )
    if [[ $Check_Blacklist_Atau_Tidak == $IP ]]; then
        echo -e "${EROR} 403 Forbidden ( Your VPS Has Been Blocked ) !"
        exit 1
    else
        Skip='true'
    fi
fi
# // cek limit
export limit=$( curl -s https://${Server1_URL}/limit.txt | grep $License_Key | wc -l )
export Install_Limited=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $License_Key | cut -d ' ' -f 2)
if [[ $limit == $Install_Limited ]]; then
        echo -e "${EROR} 403 Forbidden ( Your License Max Limit Install ) !"
        exit 1
    else
        Skip='true'
fi
# // License Key Detail
export Tanggal_Pembelian_License=`date +"%Y-%m-%d" -d "$dateFromServer"`
export Nama_Issued_License=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $License_Key | cut -d ' ' -f 7| tr -d '\r' | tr -d '\r\n')
export mekmek=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $License_Key | cut -d ' ' -f 3 | tr -d '\r' | tr -d '\r\n')
export Masa_Laku_License_Berlaku_Sampai=`date -d "$mekmek days" +"%Y-%m-%d"`
export Install_Limit=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $License_Key | cut -d ' ' -f 2 | tr -d '\r' | tr -d '\r\n')
export Tipe_License=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $License_Key | cut -d ' ' -f 8 | tr -d '\r' | tr -d '\r\n')

# // Ouputing Information
echo -e "${OKEY} License Type / Edition ( ${GREEN}$Tipe_License Edition${NC} )" # > // Output Tipe License Dari Exporting
echo -e "${OKEY} This License Issued to (${GREEN} $Nama_Issued_License ${NC})"
echo -e "${OKEY} Subscription Started On (${GREEN} $Tanggal_Pembelian_License${NC} )"
echo -e "${OKEY} Subscription Ended On ( ${GREEN}${Masa_Laku_License_Berlaku_Sampai}${NC} )"
echo -e "${OKEY} Installation Limit ( ${GREEN}$Install_Limit VPS${NC} )"
echo -e "${OKEY} Installation Usage ( ${GREEN}$limit VPS${NC} )"

# // Exporting Expired Date
export Tanggal_Sekarang=`date -d "0 days" +"%Y-%m-%d"`
export Masa_Aktif_Dalam_Satuan_Detik=$(date -d "$Masa_Laku_License_Berlaku_Sampai" +%s)
export Tanggal_Sekarang_Dalam_Satuan_Detik=$(date -d "$Tanggal_Sekarang" +%s)
export Hasil_Pengurangan_Dari_Masa_Aktif_Dan_Hari_Ini_Dalam_Satuan_Detik=$(( (Masa_Aktif_Dalam_Satuan_Detik - Tanggal_Sekarang_Dalam_Satuan_Detik) / 86400 ))
if [[ $Hasil_Pengurangan_Dari_Masa_Aktif_Dan_Hari_Ini_Dalam_Satuan_Detik -lt 0 ]]; then
    echo -e "${EROR} Your License Expired On ( ${RED}$Masa_Laku_License_Berlaku_Sampai${NC} )"
    exit 1
else
    echo -e "${OKEY} Your License Key = $(if [[ ${Hasil_Pengurangan_Dari_Masa_Aktif_Dan_Hari_Ini_Dalam_Satuan_Detik} -lt 5 ]]; then
    echo -e "${RED}${Hasil_Pengurangan_Dari_Masa_Aktif_Dan_Hari_Ini_Dalam_Satuan_Detik}${NC} Days Left"; else
    echo -e "${GREEN}${Hasil_Pengurangan_Dari_Masa_Aktif_Dan_Hari_Ini_Dalam_Satuan_Detik}${NC} Days Left"; fi )"
fi

# // Validate Successfull
echo ""
read -p "$( echo -e "Press ${CYAN}[ ${NC}${GREEN}Enter${NC} ${CYAN}]${NC} For Starting Installation") "
echo ""

# // cek old script
if [[ -r /etc/xray/domain ]]; then
clear
echo -e "${INFO} Having Script Detected !"
echo -e "${INFO} If You Replacing Script, All Client Data On This VPS Will Be Cleanup !"
read -p "Are You Sure Wanna Replace Script ? (Y/N) " josdong
if [[ $josdong == "Y" ]]; then
clear
echo -e "${INFO} Starting Replacing Script !"
elif [[ $josdong == "y" ]]; then
clear
echo -e "${INFO} Starting Replacing Script !"
rm -rf /var/lib/scrz-prem 
elif [[ $josdong == "N" ]]; then
echo -e "${INFO} Action Canceled !"
exit 1
elif [[ $josdong == "n" ]]; then
echo -e "${INFO} Action Canceled !"
exit 1
else
echo -e "${EROR} Your Input Is Wrong !"
exit 1
fi
clear
fi
echo -e "${GREEN}Starting Installation............${NC}"
# // Go To Root Directory
cd /root/
# // Remove
apt-get remove --purge nginx* -y
apt-get remove --purge nginx-common* -y
apt-get remove --purge nginx-full* -y
apt-get remove --purge dropbear* -y
apt-get remove --purge stunnel4* -y
apt-get remove --purge apache2* -y
apt-get remove --purge ufw* -y
apt-get remove --purge firewalld* -y
apt-get remove --purge exim4* -y
apt autoremove -y

# // Update
apt update -y

# // Install Requirement Tools
apt-get --reinstall --fix-missing install -y sudo dpkg psmisc socat jq ruby wondershaper python2 tmux nmap bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget vim net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential gcc g++ automake make autoconf perl m4 dos2unix dropbear libreadline-dev zlib1g-dev libssl-dev dirmngr libxml-parser-perl neofetch git lsof iptables iptables-persistent
apt-get --reinstall --fix-missing install -y libreadline-dev zlib1g-dev libssl-dev python2 screen curl jq bzip2 gzip coreutils rsyslog iftop htop zip unzip net-tools sed gnupg gnupg1 bc sudo apt-transport-https build-essential dirmngr libxml-parser-perl neofetch screenfetch git lsof openssl easy-rsa fail2ban tmux vnstat dropbear libsqlite3-dev socat cron bash-completion ntpdate xz-utils sudo apt-transport-https gnupg2 gnupg1 dnsutils lsb-release chrony
gem install lolcat

# // Update & Upgrade
apt update -y
apt upgrade -y
apt dist-upgrade -y

# // Clear
clear
clear && clear && clear
clear;clear;clear

# // Starting Setup Domain
echo -e "${GREEN}Indonesian Language${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo -e "Anda Ingin Menggunakan Domain Pribadi ?"
echo -e "Atau Ingin Menggunakan Domain Otomatis ?"
echo -e "Jika Ingin Menggunakan Domain Pribadi, Ketik ${GREEN}1${NC}"
echo -e "dan Jika Ingin menggunakan Domain Otomatis, Ketik ${GREEN}2${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo ""
echo -e "${GREEN}English Language${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo -e "You Want to Use a Private Domain ?"
echo -e "Or Want to Use Auto Domain ?"
echo -e "If You Want Using Private Domain, Type ${GREEN}1${NC}"
echo -e "else You Want using Automatic Domain, Type ${GREEN}2${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo ""

read -p "$( echo -e "${GREEN}Input Your Choose ? ${NC}(${YELLOW}1/2${NC})${NC} " )" choose_domain

# // Validating Automatic / Private
if [[ $choose_domain == "2" ]]; then # // Using Automatic Domain

# // Folder Sistem Yang Tidak Boleh Di Hapus
mkdir -p /usr/bin
# // Remove File & Directory
rm -fr /usr/local/bin/xray
rm -fr /usr/local/bin/stunnel
rm -fr /usr/local/bin/stunnel5
rm -fr /etc/nginx
rm -fr /var/lib/scrz-prem/
rm -fr /usr/bin/xray
rm -fr /etc/xray
rm -fr /usr/local/etc/xray
# // Making Directory 
mkdir -p /etc/nginx
mkdir -p /var/lib/scrz-prem/
mkdir -p /usr/bin/xray
mkdir -p /etc/xray
mkdir -p /usr/local/etc/xray

# // String / Request Data
sub=$(</dev/urandom tr -dc a-z0-9 | head -c4)
DOMAIN=vpnmurah.me
SUB_DOMAIN=${sub}.vpnmurah.me
CF_ID=paoandest@gmail.com
CF_KEY=1d158d0efc4eef787222cefff0b6d20981462
set -euo pipefail
IP=$(curl -sS ifconfig.me);
echo "Updating DNS for ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
     
echo "Host : $SUB_DOMAIN"
echo $SUB_DOMAIN > /root/domain
echo "IP=$SUB_DOMAIN" > /var/lib/scrz-prem/ipvps.conf
sleep 1
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "Domain added.."
sleep 3
domain=$(cat /root/domain)
cp -r /root/domain /etc/xray/domain

# // Making Certificate
clear
echo -e "[ ${GREEN}INFO${NC} ] Starting renew cert... " 
sleep 2
echo -e "${OKEY} Starting Generating Certificate"
rm -fr /root/.acme.sh
mkdir -p /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
# // Success
echo -e "${OKEY} Your Domain : $domain"
sleep 2

# // ELif For Selection 1
elif [[ $choose_domain == "1" ]]; then

# // Clear
clear
clear && clear && clear
clear;clear;clear

echo -e "${GREEN}Indonesian Language${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo -e "Silakan Pointing Domain Anda Ke IP VPS"
echo -e "Untuk Caranya Arahkan NS Domain Ke Cloudflare"
echo -e "Kemudian Tambahkan A Record Dengan IP VPS"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo ""
echo -e "${GREEN}Indonesian Language${NC}"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo -e "Please Point Your Domain To IP VPS"
echo -e "For Point NS Domain To Cloudflare"
echo -e "Change NameServer On Domain To Cloudflare"
echo -e "Then Add A Record With IP VPS"
echo -e "${YELLOW}-----------------------------------------------------${NC}"
echo ""
echo ""

# // Reading Your Input
read -p "Input Your Domain : " domain
if [[ $domain == "" ]]; then
    clear
    echo -e "${EROR} No Input Detected !"
    exit 1
fi

# // Folder Sistem Yang Tidak Boleh Di Hapus
mkdir -p /usr/bin
# // Remove File & Directory
rm -fr /usr/local/bin/xray
rm -fr /usr/local/bin/stunnel
rm -fr /usr/local/bin/stunnel5
rm -fr /etc/nginx
rm -fr /var/lib/scrz-prem/
rm -fr /usr/bin/xray
rm -fr /etc/xray
rm -fr /usr/local/etc/xray
# // Making Directory 
mkdir -p /etc/nginx
mkdir -p /var/lib/scrz-prem/
mkdir -p /usr/bin/xray
mkdir -p /etc/xray
mkdir -p /usr/local/etc/xray

# // Input Domain TO VPS
echo "$domain" > /etc/${Auther}/domain.txt
echo "IP=$domain" > /var/lib/scrz-prem/ipvps.conf
echo "$domain" > /root/domain
domain=$(cat /root/domain)
cp -r /root/domain /etc/xray/domain

# // Making Certificate
clear
echo -e "[ ${GREEN}INFO${NC} ] Starting renew cert... " 
sleep 2
echo -e "${OKEY} Starting Generating Certificate"
rm -fr /root/.acme.sh
mkdir -p /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
# // Success
echo -e "${OKEY} Your Domain : $domain"
sleep 2

# // Else Do
else
    echo -e "${EROR} Please Choose 1 & 2 Only !"
    exit 1
fi

#install jembot
echo -e "$white\033[0;34m┌─────────────────────────────────────────┐${NC}"
echo -e " \E[41;1;39m           ⇱ Install Jembot ⇲            \E[0m$NC"
echo -e "$white\033[0;34m└─────────────────────────────────────────┘${NC}"
sleep 1 
wget -q https://raw.githubusercontent.com/Zeastore/asd/main/jembot.sh && chmod +x jembot.sh && ./jembot.sh
#install ssh-vpn
echo -e "$white\033[0;34m┌─────────────────────────────────────────┐${NC}"
echo -e " \E[41;1;39m          ⇱ Install SSH / WS ⇲           \E[0m$NC"
echo -e "$white\033[0;34m└─────────────────────────────────────────┘${NC}"
sleep 1
wget -q https://raw.githubusercontent.com/Zeastore/asd/main/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
#install ins-xray
echo -e "$white\033[0;34m┌─────────────────────────────────────────┐${NC}"
echo -e " \E[41;1;39m            ⇱ Install Xray ⇲             \E[0m$NC"
echo -e "$white\033[0;34m└─────────────────────────────────────────┘${NC}"
sleep 1 
wget -q https://raw.githubusercontent.com/Zeastore/asd/main/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh

# // Download Data
echo -e "${GREEN}Download Data${NC}"
wget -q -O /usr/bin/add-ws "https://raw.githubusercontent.com/Zeastore/asd/main/add-ws.sh"
wget -q -O /usr/bin/add-ssws "https://raw.githubusercontent.com/Zeastore/asd/main/add-ssws.sh"
#wget -q -O /usr/bin/add-socks "https://raw.githubusercontent.com/Zeastore/asd/main/add-socks.sh"
wget -q -O /usr/bin/add-vless "https://raw.githubusercontent.com/Zeastore/asd/main/add-vless.sh"
wget -q -O /usr/bin/add-tr "https://raw.githubusercontent.com/Zeastore/asd/main/add-tr.sh"
#wget -q -O /usr/bin/add-trgo "https://raw.githubusercontent.com/Zeastore/asd/main/add-trgo.sh"
wget -q -O /usr/bin/autoreboot "https://raw.githubusercontent.com/Zeastore/asd/main/autoreboot.sh"
wget -q -O /usr/bin/restart "https://raw.githubusercontent.com/Zeastore/asd/main/restart.sh"
wget -q -O /usr/bin/tendang "https://raw.githubusercontent.com/Zeastore/asd/main/tendang.sh"
wget -q -O /usr/bin/clearlog "https://raw.githubusercontent.com/Zeastore/asd/main/clearlog.sh"
wget -q -O /usr/bin/running "https://raw.githubusercontent.com/Zeastore/asd/main/running.sh"
wget -q -O /usr/bin/cek-trafik "https://raw.githubusercontent.com/Zeastore/asd/main/cek-trafik.sh"
wget -q -O /usr/bin/cek-speed "https://raw.githubusercontent.com/Zeastore/asd/main/speedtes_cli.py"
wget -q -O /usr/bin/cek-bandwidth "https://raw.githubusercontent.com/Zeastore/asd/main/cek-bandwidth.sh"
#wget -q -O /usr/bin/cek-ram "https://raw.githubusercontent.com/Zeastore/asd/main/ram.sh"
wget -q -O /usr/bin/limit-speed "https://raw.githubusercontent.com/Zeastore/asd/main/limit-speed.sh"
wget -q -O /usr/bin/menu-vless "https://raw.githubusercontent.com/Zeastore/asd/main/menu-vless.sh"
wget -q -O /usr/bin/menu-vmess "https://raw.githubusercontent.com/Zeastore/asd/main/menu-vmess.sh"
#wget -q -O /usr/bin/menu-socks "https://raw.githubusercontent.com/Zeastore/asd/main/menu-socks.sh"
wget -q -O /usr/bin/menu-ss "https://raw.githubusercontent.com/Zeastore/asd/main/menu-ss.sh"
wget -q -O /usr/bin/menu-trojan "https://raw.githubusercontent.com/Zeastore/asd/main/menu-trojan.sh"
#wget -q -O /usr/bin/menu-trgo "https://raw.githubusercontent.com/Zeastore/asd/main/menu-trgo.sh"
wget -q -O /usr/bin/menu-ssh "https://raw.githubusercontent.com/Zeastore/asd/main/menu-ssh.sh"
#wget -q -O /usr/bin/menu-bckp "https://raw.githubusercontent.com/Zeastore/asd/main/menu-bckp-telegram.sh"
wget -q -O /usr/bin/menu-bckp "https://raw.githubusercontent.com/Zeastore/asd/main/menu-bckp-github.sh"
#wget -q -O /usr/bin/bckp "https://raw.githubusercontent.com/Zeastore/asd/main/bckpbot.sh"
wget -q -O /usr/bin/usernew "https://raw.githubusercontent.com/Zeastore/asd/main/usernew.sh"
wget -q -O /usr/bin/menu "https://raw.githubusercontent.com/Zeastore/asd/main/menu.sh"
wget -q -O /usr/bin/wbm "https://raw.githubusercontent.com/Zeastore/asd/main/webmin.sh"
wget -q -O /usr/bin/xp "https://raw.githubusercontent.com/Zeastore/asd/main/xp.sh"
#wget -q -O /usr/bin/update "https://raw.githubusercontent.com/Zeastore/asd/main/update.sh"
chmod +x /usr/bin/add-ws
chmod +x /usr/bin/add-ssws
#chmod +x /usr/bin/add-socks
chmod +x /usr/bin/add-vless
chmod +x /usr/bin/add-tr
#chmod +x /usr/bin/add-trgo
chmod +x /usr/bin/usernew
chmod +x /usr/bin/autoreboot
chmod +x /usr/bin/restart
chmod +x /usr/bin/tendang
chmod +x /usr/bin/clearlog
chmod +x /usr/bin/running
chmod +x /usr/bin/cek-trafik
chmod +x /usr/bin/cek-speed
chmod +x /usr/bin/cek-bandwidth
#chmod +x /usr/bin/cek-ram
chmod +x /usr/bin/limit-speed
chmod +x /usr/bin/menu-vless
chmod +x /usr/bin/menu-vmess
chmod +x /usr/bin/menu-ss
#chmod +x /usr/bin/menu-socks
chmod +x /usr/bin/menu-trojan
#chmod +x /usr/bin/menu-trgo
chmod +x /usr/bin/menu-ssh
chmod +x /usr/bin/menu-bckp
chmod +x /usr/bin/menu
#chmod +x /usr/bin/bckp
chmod +x /usr/bin/wbm
chmod +x /usr/bin/xp
#chmod +x /usr/bin/update

#cat > /etc/cron.d/re_otm <<-END
#SHELL=/bin/sh
#PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
#0 7 * * * root /sbin/reboot
#END

cat > /etc/cron.d/xp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/bin/xp
END

cat > /etc/cron.d/cl_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 1 * * * root /usr/bin/clearlog
END

cat > /home/re_otm <<-END
7
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

clear
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

if [ -f "/root/log-install.txt" ]; then
rm -fr /root/log-install.txt 
fi
if [ -f "/etc/afak.conf" ]; then
rm -fr /etc/afak.conf 
fi
if [ ! -f "/etc/log-create-user.log" ]; then
echo "Log All Account " > /etc/log-create-user.log
fi
history -c
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
echo -e "[ ${green}Pleas Wait Update DB ${NC} ]"
git clone https://github.com/Zeastore/limit.git /root/limit/ &> /dev/null
babu=$(cat /etc/.geovpn/license.key)
echo -e "$babu $IP $Masa_Laku_License_Berlaku_Sampai" >> /root/limit/limit.txt
cd /root/limit
    git config --global user.email "pribadi.no99@gmail.com" &> /dev/null
    git config --global user.name "Zeastore" &> /dev/null
    rm -fr .git &> /dev/null
    git init &> /dev/null
    git add . &> /dev/null
    git commit -m m &> /dev/null
    git branch -M main &> /dev/null
    git remote add origin https://github.com/Zeastore/limit
    git push -f https://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@github.com/kenDevXD/limit.git &> /dev/null
cd
echo "1.1" >> /home/.ver
rm -fr /root/limit
curl -sS ifconfig.me > /etc/myipvps
echo " "
echo "=====================-[ Kenn Hiroyuki Premium ]-===================="
echo ""
echo "------------------------------------------------------------"
echo ""
echo ""
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - SSH Websocket           : 80" | tee -a log-install.txt
echo "   - SSH SSL Websocket       : 443" | tee -a log-install.txt
echo "   - Stunnel5                : 447, 777" | tee -a log-install.txt
echo "   - Dropbear                : 109, 143" | tee -a log-install.txt
echo "   - Badvpn                  : 7100-7300" | tee -a log-install.txt
echo "   - Nginx                   : 81" | tee -a log-install.txt
echo "   - XRAY  Vmess TLS         : 443" | tee -a log-install.txt
echo "   - XRAY  Vmess None TLS    : 80" | tee -a log-install.txt
echo "   - XRAY  Vless TLS         : 443" | tee -a log-install.txt
echo "   - XRAY  Vless None TLS    : 80" | tee -a log-install.txt
echo "   - Trojan GRPC             : 443" | tee -a log-install.txt
echo "   - Trojan WS               : 443" | tee -a log-install.txt
echo "   - Trojan GO               : 443" | tee -a log-install.txt
#echo "   - Trojan GFW              : 443" | tee -a log-install.txt
echo "   - Sodosok WS/GRPC         : 443" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot Off          : $aureb:00 $gg GMT +7" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - AutoKill Multi Login User" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Fully automatic script" | tee -a log-install.txt
echo "   - VPS settings" | tee -a log-install.txt
echo "   - Admin Control" | tee -a log-install.txt
echo "   - Change port" | tee -a log-install.txt
echo "   - Restore Data" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""
echo ""
echo "------------------------------------------------------------"
echo ""
echo "===============-[ Script Created By Kenn Hiroyuki ]-==============="
echo -e ""
echo ""
echo "" | tee -a log-install.txt
rm -fr /root/weleh.sh 
rm -fr /root/jembot.sh 
rm -fr /root/ssh-vpn.sh
rm -fr /root/ins-xray.sh
rm -fr /root/setup.sh
rm -fr /root/domain
history -c

echo -ne "[ ${yell}WARNING${NC} ] Apakah Anda Ingin Reboot Sekarang ? (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
