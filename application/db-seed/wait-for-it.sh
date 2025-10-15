#!/usr/bin/env bash
set -e

HOST="${1:-mongodb}"
PORT="${2:-27017}"

echo "⏳ Waiting for MongoDB at $HOST:$PORT ..."
# nc bazı imajlarda yoksa, bash /dev/tcp ile deneriz
for i in {1..60}; do
  (echo > /dev/tcp/$HOST/$PORT) >/dev/null 2>&1 && echo "✅ Mongo is up." && exit 0
  sleep 2
done

echo "❌ Timeout waiting for $HOST:$PORT"
exit 1
