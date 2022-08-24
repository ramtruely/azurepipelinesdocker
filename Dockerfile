FROM node:16 as BUILD_IMAGE
WORKDIR /var/www/app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

# remove dev dependencies
RUN npm prune --production

FROM node:16
WORKDIR /var/www/app
COPY --from=BUILD_IMAGE /var/www/app/package.json ./package.json
COPY --from=BUILD_IMAGE /var/www/app/node_modules ./node_modules
COPY --from=BUILD_IMAGE /var/www/app/.next ./.next
COPY --from=BUILD_IMAGE /var/www/app/public ./public

EXPOSE 3000
CMD ["npm", "start"]
