#!/bin/bash

set -u

URL="http://localhost:8080"
MAX_RETRIES=5
RETRY_COUNT=1

echo "Starting deployment verification..."

while [ "$RETRY_COUNT" -le "$MAX_RETRIES" ]
do
    echo "Attempt $RETRY_COUNT/$MAX_RETRIES"

    if curl -fsS --max-time 5 "$URL" >/dev/null 2>&1; then
        echo "[PASS] Application is responding"
        echo "Deployment verification successful"
        exit 0
    fi

    echo "[WARN] Application is not ready"

    if [ "$RETRY_COUNT" -eq "$MAX_RETRIES" ]; then
        echo "[FAIL] Deployment verification failed"
        exit 1
    fi

    echo "Retrying in 2 seconds..."
    sleep 2

    RETRY_COUNT=$((RETRY_COUNT + 1))
done
