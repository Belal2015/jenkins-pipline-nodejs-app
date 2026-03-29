# Stage 1: Build
FROM node:18 AS build

WORKDIR /app

COPY package*.json ./

RUN npm install --prefer-offline=false

COPY . .

RUN ./node_modules/.bin/vite build

# Stage 2: Production
FROM nginx:alpine
# Copy pre-built dist from Jenkins workspace
COPY dist/ /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
