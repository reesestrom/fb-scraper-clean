#!/bin/bash

# Step 1: Install dependencies
npm install

# Step 2: Create a local directory to store Chrome
mkdir -p chrome
cd chrome

# Step 3: Download and extract Chrome for Testing (working version)
curl -sSL -o chrome.zip https://storage.googleapis.com/chrome-for-testing-public/118.0.5993.70/linux64/chrome-linux64.zip
unzip chrome.zip
mv chrome-linux64 chrome
chmod +x chrome/chrome

# Step 4: Back out to root
cd ..

# Step 5: Done — let Render run `npm start`
echo "✅ Chrome build steps complete"