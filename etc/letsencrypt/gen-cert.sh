#!/usr/bin/env bash
exec certbot certonly \
    --dns-cloudflare \
    --dns-cloudflare-credentials='/etc/letsencrypt/cloudflare.ini' \
    --dns-cloudflare-propagation-seconds 60 \
    --domain='settlescape.com' \
    --domain='*.settlescape.com' \
    --domain='settlescape.org' \
    --domain='*.settlescape.org' \
    --domain='settlescape.net' \
    --domain='*.settlescape.net'
