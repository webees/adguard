FROM adguard/adguardhome:v0.108.0-b.71

# 53     : TCP, UDP : DNS
# 67     :      UDP : DHCP (server)
# 68     :      UDP : DHCP (client)
# 80     : TCP      : HTTP (main)
# 443    : TCP, UDP : HTTPS, DNS-over-HTTPS (incl. HTTP/3), DNSCrypt (main)
# 853    : TCP, UDP : DNS-over-TLS, DNS-over-QUIC
# 3000   : TCP, UDP : HTTP(S) (alt, incl. HTTP/3)
# 5443   : TCP, UDP : DNSCrypt (alt)
# 6060   : TCP      : HTTP (pprof)
EXPOSE 53/tcp 53/udp \
       67/udp 68/udp \
       80/tcp 443/tcp 443/udp \
       853/tcp 853/udp \
       3000/tcp 3000/udp \
       5443/tcp 5443/udp \
       6060/tcp

WORKDIR /

ARG SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.2.29/supercronic-linux-amd64 \
    OVERMIND_URL=https://github.com/DarthSim/overmind/releases/download/v2.4.0/overmind-v2.4.0-linux-amd64.gz

ENV TZ="Asia/Shanghai" \

    OVERMIND_CAN_DIE=supercronic \

    SMTP_HOST=smtp.gmail.com \
    SMTP_PORT=587 \
    SMTP_USERNAME=88888888@gmail.com \
    SMTP_PASSWORD=88888888 \
    SMTP_FROM=88888888@gmail.com \
    SMTP_TO= \

    RESTIC_REPOSITORY=s3://88888888.r2.cloudflarestorage.com/adguard \
    RESTIC_PASSWORD= \
    AWS_ACCESS_KEY_ID= \
    AWS_SECRET_ACCESS_KEY=

COPY scripts/overmind.sh \
     scripts/supercronic.sh \
     scripts/restic.sh \
     /

RUN apk add --no-cache \
        curl \
        restic \
        ca-certificates \
        openssl \
        tzdata \
        iptables \
        ip6tables \
        iputils-ping \
        tmux \
        msmtp \
        mailx \
        && rm -rf /var/cache/apk/* \

        && curl -fsSL "$SUPERCRONIC_URL" -o /usr/local/bin/supercronic \
        && curl -fsSL "$OVERMIND_URL" | gunzip -c - > /usr/local/bin/overmind \

        && ln -sf /usr/bin/msmtp /usr/bin/sendmail \
        && ln -sf /usr/bin/msmtp /usr/sbin/sendmail \

        && chmod +x /usr/local/bin/supercronic \
        && chmod +x /usr/local/bin/overmind \

        && chmod +x /overmind.sh \
        && chmod +x /supercronic.sh \
        && chmod +x /restic.sh \

        && mkdir -p /data/conf \
        && mkdir -p /data/work \
        && rm -rf /opt/adguardhome/conf \
        && rm -rf /opt/adguardhome/work \
        && ln -s /data/conf /opt/adguardhome/conf \
        && ln -s /data/work /opt/adguardhome/work

ENTRYPOINT ["/overmind.sh"]
CMD ["-"]
