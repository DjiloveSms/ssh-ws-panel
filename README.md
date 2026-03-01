# SSH WebSocket Panel for Cloud Run

## 🇨🇦 Déploiement sur Cloud Run (Canada)

```bash
gcloud builds submit --tag gcr.io/alien-drake-487413-q3/ssh-panel --timeout=30m
gcloud run deploy ssh-panel --image gcr.io/alien-drake-487413-q3/ssh-panel --platform managed --region northamerica-northeast1 --allow-unauthenticated --port 8080 --memory 1Gi --cpu 1 --timeout 3600
