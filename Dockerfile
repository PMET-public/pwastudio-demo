FROM node:10.20.1-slim

RUN /bin/bash -c "source settings.sh"

ENV MAGENTO_BACKEND_URL=$MAGENTO_BACKEND_URL
ENV CHECKOUT_BRAINTREE_TOKEN=sandbox_8yrzsvtm_s2bg8fs563crhqzk
ENV MAGENTO_BACKEND_EDITION=CE

# RUN mkdir -p /pwa

# COPY . /pwa

# WORKDIR /pwa

# #  Install dependencies
# RUN npm install

# # PWA Studio Domain
# # RUN npm run buildpack -- create-custom-origin .

# # PWA Studio Build
# RUN npm run build

# RUN npm prune --production

# EXPOSE 3000

# CMD ["npm", "start"]
