#!/usr/bin/env bash

set -e

# Install Node dependencies
npm install

# Download Chrome for Puppeteer
mkdir -p chrome && cd chrome
curl -sSL -o chrome.zip https://storage.googleapis.com/chrome-for-testing-public/118.0.5993.70/linux64/chrome-linux64.zip
unzip chrome.zip
mv chrome-linux64 chrome
chmod +x chrome/chrome
cd ..

echo "✅ Chrome downloaded and made executable"
