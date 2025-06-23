# Stage 1: Build front-end using Node.js
FROM node:18 AS frontend

# Set working directory for the front-end
WORKDIR /app/web

# Copy front-end package files
COPY ./web/package.json ./web/package-lock.json ./

# Install dependencies and suppress unnecessary logs
RUN npm install --silent

# Build front-end and suppress unnecessary logs
RUN npm run build-prod --silent

# Stage 2: Build Go back-end (including Node.js for the front-end build)
FROM golang:1.24.4 AS backend

# Install Node.js in Go container
RUN apt-get update && \
    apt-get install -y nodejs npm

# Set working directory for Go back-end
WORKDIR /app

# Copy the entire project
COPY . .

# Embed front-end into the Go app (using statik) with error logs only
RUN go install github.com/rakyll/statik && \
    statik -m -src="./web/dist" -f -dest="./server/embed" -p web -ns web

# Build Go client and back-end, showing errors only
RUN mkdir -p ./built && \
    go mod tidy && \
    go mod download && \
    ./scripts/build.client.sh && \
    mkdir -p ./releases && \
    go build -tags netgo -ldflags '-s -w' -o app && \
    ./scripts/build.server.sh

# Final Stage: Prepare the app to run
FROM golang:1.24.4

WORKDIR /app

# Copy the final Go binary from the build stage
COPY --from=backend /app/app .

# Expose the app's port (usually 8080 for Go servers)
EXPOSE 8080

# Run the Go app
CMD ["./app"]
