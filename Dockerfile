FROM alpine:latest

RUN apk add --no-cache openssh-server openssh-sftp-server nginx python3 py3-pip bash curl

RUN pip3 install flask

RUN mkdir -p /var/run/sshd /var/www/html /etc/ssh/panel && \
    echo "root:root123" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "Port 22" >> /etc/ssh/sshd_config

RUN echo "events { worker_connections 1024; } http { server { listen 8080; location / { root /var/www/html; index index.html; } location /app17 { proxy_pass http://localhost:8081; proxy_http_version 1.1; proxy_set_header Upgrade \$http_upgrade; proxy_set_header Connection \"upgrade\"; proxy_set_header Host \$host; proxy_read_timeout 3600s; } } }" > /etc/nginx/nginx.conf

RUN echo '#!/bin/sh
echo "========================================"
echo "SSH PANEL - DEMARRAGE"
echo "========================================"
echo "ROOT PASSWORD: root123"
echo "========================================"
/usr/sbin/sshd
python3 -m http.server 8081 --directory /var/www/html &
nginx -g "daemon off;"' > /start.sh && chmod +x /start.sh

RUN echo '<!DOCTYPE html>
<html>
<head>
    <title>SSH Panel</title>
    <style>
        body { font-family: Arial; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-align: center; padding: 50px; }
        h1 { font-size: 3em; }
        .info { background: rgba(255,255,255,0.2); padding: 20px; border-radius: 10px; margin: 20px; }
    </style>
</head>
<body>
    <h1>🔐 SSH PANEL</h1>
    <div class="info">
        <p>Serveur SSH actif</p>
        <p>User: root | Password: root123</p>
        <p>WebSocket Path: /app17</p>
    </div>
</body>
</html>' > /var/www/html/index.html

EXPOSE 8080
CMD ["/start.sh"]
