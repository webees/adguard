#!/bin/sh

cat > /crontab <<EOF
@hourly /restic.sh
EOF

supercronic /crontab