#!/bin/bash

set -euo pipefail
CHECK_FAILED=0

echo "======================================"
echo "       DeployOps Health Check"
echo "======================================"

echo "Starting health checks..."

check_command() {
    local command_name="$1"

    if command -v "$command_name" >/dev/null 2>&1; then
        echo "[PASS] $command_name is available"
        return 0
    else
        echo "[FAIL] $command_name is not available"
        return 1
    fi
}

check_disk() {
    local usage

    usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

    echo "Disk usage: ${usage}%"

    if [ "$usage" -lt 80 ]; then
        echo "[PASS] Disk usage is healthy"
        return 0
    elif [ "$usage" -lt 90 ]; then
        echo "[WARN] Disk usage is getting high"
        return 0
    else
        echo "[FAIL] Disk usage is critical"
        return 1
    fi
}

check_memory() {
    local memory_usage

    memory_usage=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')

    echo "Memory usage: ${memory_usage}%"

    if [ "$memory_usage" -lt 80 ]; then
        echo "[PASS] Memory usage is healthy"
        return 0
    elif [ "$memory_usage" -lt 90 ]; then
        echo "[WARN] Memory usage is getting high"
        return 0
    else
        echo "[FAIL] Memory usage is critical"
        return 1
    fi
}

check_cpu() {
    local cpu_usage

    cpu_usage=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')

    cpu_usage=$(printf "%.0f" "$cpu_usage")

    echo "CPU usage: ${cpu_usage}%"

    if [ "$cpu_usage" -lt 80 ]; then
        echo "[PASS] CPU usage is healthy"
        return 0
    elif [ "$cpu_usage" -lt 90 ]; then
        echo "[WARN] CPU usage is getting high"
        return 0
    else
        echo "[FAIL] CPU usage is critical"
        return 1
    fi
}

check_users() {
    local user_count

    user_count=$(who | wc -l)

    echo "Logged-in users: $user_count"

    if [ "$user_count" -gt 0 ]; then
        echo "[PASS] Active user session detected"
        return 0
    else
        echo "[WARN] No active user session detected"
        return 0
    fi
}

check_port() {
    local port="$1"

    if ss -tuln | grep -q ":$port "; then
        echo "[PASS] Port $port is listening"
        return 0
    else
        echo "[FAIL] Port $port is not listening"
        return 1
    fi
}

check_http() {
    local url="$1"

    if curl -fsS --max-time 5 "$url" >/dev/null 2>&1; then
        echo "[PASS] HTTP health check successful: $url"
        return 0
    else
        echo "[FAIL] HTTP health check failed: $url"
        return 1
    fi
}

if ! check_command bash; then
    CHECK_FAILED=1
fi

if ! check_command python3; then
    CHECK_FAILED=1
fi

if ! check_command curl; then
    CHECK_FAILED=1
fi

if ! check_disk; then
    CHECK_FAILED=1
fi

if ! check_memory; then
    CHECK_FAILED=1
fi

if ! check_cpu; then
    CHECK_FAILED=1
fi

if ! check_users; then
    CHECK_FAILED=1
fi

if ! check_port 8080; then
    CHECK_FAILED=1
fi

if ! check_http "http://localhost:8080"; then
    CHECK_FAILED=1
fi


echo
echo "======================================"
echo "          Health Check Result"
echo "======================================"

if [ "$CHECK_FAILED" -eq 0 ]; then
    echo "RESULT: HEALTHY"
    exit 0
else
    echo "RESULT: UNHEALTHY"
    exit 1
fi