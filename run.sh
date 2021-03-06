#!/bin/bash

echo "\nš  What's your Magento Cloud Environment URL?"
read magento_url

export MAGENTO_BACKEND_URL=$magento_url
export CHECKOUT_BRAINTREE_TOKEN=sandbox_8yrzsvtm_s2bg8fs563crhqzk
export MAGENTO_BACKEND_EDITION=CE

echo "\nš  Setting PWA Studio with $magento_url.\n"
npm install
clear

echo "\nš  Generating a unique, secure custom domain for your project. You might be asked to enter your computer's crendetials.\n"
npm run buildpack -- create-custom-origin .
clear

echo "\nš·āāļø  Building PWA \n"
npm run build
clear

echo "\nš”  Running PWA \n"
npm start
