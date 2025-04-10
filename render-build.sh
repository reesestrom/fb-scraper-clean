#!/bin/bash

# Step 1: Install Node dependencies
npm install

# Step 2: Download and extract Chrome
mkdir -p chrome
cd chrome
curl -sSL -o chrome.zip https://storage.googleapis.com/chrome-for-testing-public/118.0.5993.70/linux64/chrome-linux64.zip
unzip chrome.zip
mv chrome-linux64 chrome
chmod +x chrome/chrome
cd ..

echo "✅ Chrome build steps complete"
