#!/usr/bin/env bash
set -e

echo "🔧 Installing dependencies..."
npm install

echo "⬇️ Downloading Chrome for Puppeteer..."
mkdir -p chrome && cd chrome

curl -fSL -o chrome.zip https://storage.googleapis.com/chrome-for-testing-public/118.0.5993.70/linux64/chrome-linux64.zip || {
  echo "❌ Failed to download Chrome zip"
  exit 1
}

echo "📦 Unzipping Chrome..."
unzip -q chrome.zip || {
  echo "❌ Failed to unzip Chrome"
  exit 1
}

mv chrome-linux64 chrome
chmod +x chrome/chrome || echo "❗ Warning: could not make chrome binary executable"
cd ..

echo "✅ Chrome setup complete"
