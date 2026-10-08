# Start your image with a node base image
FROM node:22-alpine AS builder

# The /app directory should act as the main application directory
WORKDIR /app

# Copy the app package and package-lock.json file
COPY package*.json ./

# Copy local directories to the current local directory of our docker image (/app)
COPY ./src ./src
COPY ./public ./public

# Install the locked dependencies and build the static site.
RUN npm ci --ignore-scripts \
    && npm run build

# Use a slim nginx image to reduce our image size drastically
FROM nginx:alpine-slim
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

USER nginx
EXPOSE 8080
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
