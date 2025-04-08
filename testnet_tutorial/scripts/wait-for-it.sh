#!/bin/bash
set -e

host="$1"
port="$2"
shift 2
cmd="$@"

until nc -z "$host" "$port"; do
  echo "waiting for $host:$port..."
  sleep 2
done

echo "$host:$port is available"

if [ -n "$cmd" ]; then
  exec $cmd
fi 