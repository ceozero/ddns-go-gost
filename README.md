docker build -t ddns-gost-realm .
wget -N https://raw.githubusercontent.com/ceozero/ddns-gost-realm/refs/heads/main/realm.sh && chmod +x realm.sh && ./realm.sh
