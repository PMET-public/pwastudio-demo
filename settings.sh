# !/bin/bash

read -r -d '' applescriptCode <<'EOF'
   set magento_url to text returned of (display dialog "🔌  What's your Magento Cloud Environment URL?" default answer "https://venia.magento.com")
   return magento_url
EOF

export magento_url=$(osascript -e "$applescriptCode");

if [ -n "$magento_url" ]; then
    export MAGENTO_BACKEND_URL=$magento_url;
else
  echo "⚠️ You need a Magento URL to build a PWA."
  return
fi
