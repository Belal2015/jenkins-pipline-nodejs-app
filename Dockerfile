# Stage 1: Build
FROM node:18 AS build

WORKDIR /app

# Copy package files first to leverage caching
COPY package*.json ./

# Install dependencies (including devDependencies for Vite)
RUN npm install

# Copy rest of the source code
COPY . .

# Build the project using npx (works even if Vite is not global)
RUN npx vite build

# Stage 2: Production
FROM nginx:alpine

# Copy build output
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
