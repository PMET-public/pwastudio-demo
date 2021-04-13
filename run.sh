#!/bin/bash

echo "\n🔌  What's your Magento Cloud Environment URL?"
read magento_url

echo "\n🏗  Setting PWA Studio with $magento_url.\n"
npm install
clear

echo "\n🔐  Generating a unique, secure custom domain for your project. You might be asked to enter your computer's crendetials.\n"
MAGENTO_BACKEND_URL=$magento_url npm run buildpack -- create-custom-origin .
clear

echo "\n👷‍♀️  Building PWA \n"
MAGENTO_BACKEND_URL=$magento_url npm run build
clear

echo "\n📡  Running PWA \n"
MAGENTO_BACKEND_URL=$magento_url npm start
