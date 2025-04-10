#!/bin/bash

# Install dependencies
npm install

# Create chrome folder
mkdir -p chrome
cd chrome

# Download stable Chrome-for-Testing (manually set version known to work)
curl -sSL -o chrome.zip https://storage.googleapis.com/chrome-for-testing-public/118.0.5993.70/linux64/chrome-linux64.zip
unzip chrome.zip
mv chrome-linux64 chrome
chmod +x chrome/chrome
