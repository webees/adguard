#!/bin/sh

cat > /Procfile <<EOF
adguard: /opt/adguardhome/AdGuardHome --no-check-update -c /opt/adguardhome/conf/AdGuardHome.yaml -w /opt/adguardhome/work
supercronic: /supercronic.sh
EOF

overmind start -f /Procfile