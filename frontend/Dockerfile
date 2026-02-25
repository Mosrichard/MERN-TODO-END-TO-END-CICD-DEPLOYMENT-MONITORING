# -----------------------------
# Stage 1: Build Frontend App
# -----------------------------
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files first for caching
COPY package.json package-lock.json ./

# Use public npm registry, clean cache, update npm, install dependencies
RUN npm config set registry https://registry.npmjs.org/ \
    && npm cache clean --force \
    && npm install -g npm@11 \
    && npm install

# Copy the rest of the app
COPY . .

# Build the app (React, Next.js, etc.)
RUN npm run build

# -----------------------------
# Stage 2: Serve with Nginx
# -----------------------------
FROM nginx:alpine

# Copy built app from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
