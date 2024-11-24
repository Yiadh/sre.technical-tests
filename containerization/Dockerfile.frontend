# Stage 1: Clone the repository and install dependencies
FROM alpine:3.18 as builder

## Install git and any necessary tools
RUN apk add --no-cache git

## Set the working directory
WORKDIR /app

## Clone the repository
ARG REPO_URL="https://github.com/slgevens/example-ariane.git"
RUN git clone ${REPO_URL} .

# Stage 2: Create a lightweight image for runtime

FROM node:16-alpine

# Set the working directory
WORKDIR /app

# Install Required node modules
RUN npm install express

# Copy the build artifacts from the previous stage
COPY --from=builder /app/app.js ./app.js
COPY --from=builder /app/package-lock.json ./package-lock.json
COPY --from=builder /app/package.json ./package.json

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["node", "app.js"]
