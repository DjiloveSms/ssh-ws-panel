FROM alpine:latest

RUN apk add --no-cache openssh-server nginx python3 bash curl

RUN mkdir -p /var/run/sshd /var/www/html && \
    echo "root:root123" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN echo "events { worker_connections 1024; } http { server { listen 8080; location / { root /var/www/html; index index.html; } location /app17 { proxy_pass http://127.0.0.1:8081; proxy_http_version 1.1; proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection 'upgrade'; } } }" > /etc/nginx/nginx.conf

RUN echo '#!/bin/sh
echo "========================================"
echo "SSH PANEL - DEMARRAGE"
echo "========================================"
echo "ROOT PASSWORD: root123"
echo "========================================"
/usr/sbin/sshd
python3 -m http.server 8081 --directory /var/www/html &
nginx -g "daemon off;"' > /start.sh && chmod +x /start.sh

RUN echo '<h1>SSH PANEL</h1><p>User: root | Pass: root123</p>' > /var/www/html/index.html

EXPOSE 8080
CMD ["/start.sh"]
