docker build -t asia-northeast1-docker.pkg.dev/spesill-staging/nlm-ingestor/nlm-ingestor .
docker push asia-northeast1-docker.pkg.dev/spesill-staging/nlm-ingestor/nlm-ingestor
gcloud run deploy nlm-ingestor --image asia-northeast1-docker.pkg.dev/spesill-staging/nlm-ingestor/nlm-ingestor --region asia-northeast1 --project spesill-staging --timeout=60m --service-account cloudrun@spesill-staging.iam.gserviceaccount.com --port=5001 --memory=2Gi
