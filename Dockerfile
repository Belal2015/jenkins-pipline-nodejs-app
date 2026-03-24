# We skip the 'build' stage because Jenkins already did it!
FROM nginx:alpine

# Copy the 'dist' folder that was created in the 'Build' stage of your Jenkinsfile
# This folder is sitting in your Jenkins workspace on the EC2 host.
COPY dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
