# Use official nginx as base image
FROM nginx:alpine

# Set maintainer label
LABEL maintainer="mybesant"

# Copy custom HTML page into nginx's default serving directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
