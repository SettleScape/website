#!/usr/bin/env sh
exec certbot certonly \
    --domain='settlescape.org' \
    --domain='*.settlescape.org' \
    --domain='settlescape.com' \
    --domain='*.settlescape.com' \
    --domain='settlescape.net' \
    --domain='*.settlescape.net'
