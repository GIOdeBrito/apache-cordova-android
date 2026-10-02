#!/usr/bin/env bash
set -x

# Builds the app
if [ "$1" = "--build-app" ]; then
  cordova platform add android@latest
  npm run build && chown 1000 /apks/app-debug.apk
  shift
fi

# Run app as a web server
if [ "$1" = "--serve-app" ]; then
  shift
  npx http-server /app/www/ -p 8000
fi

echo "done"

