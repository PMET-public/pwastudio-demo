FROM node:10.20.1-slim

RUN mkdir -p /pwa

COPY . /pwa

WORKDIR /pwa

#  Install dependencies
RUN npm install --silent --no-audit --no-fund

ARG MAGENTO_BACKEND_URL=https://venia.magento.com
ENV MAGENTO_BACKEND_URL=$MAGENTO_BACKEND_URL
ENV CHECKOUT_BRAINTREE_TOKEN=sandbox_8yrzsvtm_s2bg8fs563crhqzk
ENV MAGENTO_BACKEND_EDITION=CE
ENV PORT=3000

# PWA Studio Domain
# RUN npm run buildpack -- create-custom-origin .

# PWA Studio Build
RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
