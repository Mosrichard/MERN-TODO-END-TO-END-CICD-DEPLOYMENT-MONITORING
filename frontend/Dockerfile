# Stage 1: Build
FROM node:18-alpine AS build

WORKDIR /app

# Copy package.json & package-lock.json first for caching
COPY package.json package-lock.json ./

# Use public npm registry, clean cache, and update npm
RUN npm config set registry https://registry.npmjs.org/ \
    && npm cache clean --force \
    && npm install -g npm@11 \
    && npm install

# Copy the rest of the app
COPY . .

# Build the app
RUN npm run build

# Stage 2: Serve with Nginx
FROM nginx:alpine

# Copy build artifacts from Stage 1
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
