#!/bin/bash
# ./deploy.sh
set -e

echo "🔨 Building Flutter web (production)..."
flutter build web --release --target lib/main_production.dart

echo "📦 Copying build output to public/..."
rm -rf public/*
cp -r build/web/* public/

echo "🚀 Deploying to Firebase Hosting (cleanmacfordevs)..."
firebase deploy --only hosting

echo "✅ Deploy concluído!"
