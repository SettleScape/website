#!/usr/bin/env sh
setfacl -m u:nginx:r-x /etc/letsencrypt/live
setfacl -m u:nginx:r-x /etc/letsencrypt/archive
setfacl -m u:nginx:rx /etc/letsencrypt/live/settlescape.org
setfacl -m u:nginx:r /etc/letsencrypt/live/settlescape.org/fullchain.pem
setfacl -m u:nginx:r /etc/letsencrypt/live/settlescape.org/privkey.pem
setfacl -m u:nginx:r /etc/letsencrypt/ssl-dhparams.pem
exit $?
