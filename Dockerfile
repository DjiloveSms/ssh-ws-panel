FROM alpine:latest

# Installation de nginx
RUN apk add --no-cache nginx

# Création de la page web
RUN mkdir -p /usr/share/nginx/html && \
    echo '<!DOCTYPE html>
<html>
<head>
    <title>SSH Panel</title>
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-align: center; padding: 50px; }
        h1 { font-size: 3em; }
        .info { background: rgba(255,255,255,0.2); padding: 30px; border-radius: 10px; margin: 20px auto; max-width: 600px; }
        .success { color: #4CAF50; font-weight: bold; }
    </style>
</head>
<body>
    <h1>🔐 SSH PANEL</h1>
    <div class="info">
        <h2 class="success">✅ DÉPLOIEMENT RÉUSSI</h2>
        <p>Serveur SSH Panel actif</p>
        <p>Région: Canada (northamerica-northeast1)</p>
        <p>Statut: Opérationnel</p>
    </div>
</body>
</html>' > /usr/share/nginx/html/index.html

# Exposition du port
EXPOSE 8080

# Démarrage de nginx
CMD ["nginx", "-g", "daemon off;"]
