# Stage 1: Build front-end using Node.js
FROM node:18 AS frontend

# Set working directory for front-end
WORKDIR /app/web

# Copy front-end package files
COPY ./web/package.json ./web/package-lock.json ./

# Install dependencies silently, only show errors
RUN npm install --silent || { echo 'npm install failed!'; exit 1; }

# Build front-end silently, only show errors
RUN npm run build-prod --silent || { echo 'npm run build-prod failed!'; exit 1; }

# Debug: List the files in the /web directory to verify if ./dist is created
RUN ls -la ./web

# Stage 2: Build Go back-end (including Node.js for the front-end build)
FROM golang:1.24.4 AS backend

# Install Node.js in Go container (for npm and statik)
RUN apt-get update && apt-get install -y nodejs npm

# Set working directory for Go back-end
WORKDIR /app

# Copy the entire project
COPY . .

# Check if the dist directory exists and output an error if not
RUN if [ ! -d "./web/dist" ]; then echo "Error: ./web/dist directory not found!"; exit 1; fi

# Embed front-end into the Go app (using statik) with error output only
RUN go install github.com/rakyll/statik || { echo 'statik installation failed!'; exit 1; }

RUN statik -m -src="./web/dist" -f -dest="./server/embed" -p web -ns web || { echo 'Statik embedding failed!'; exit 1; }

# Build Go client and back-end silently, only show errors
RUN mkdir -p ./built && \
    go mod tidy && \
    go mod download && \
    ./scripts/build.client.sh || { echo 'Client build failed!'; exit 1; } && \
    mkdir -p ./releases && \
    go build -tags netgo -ldflags '-s -w' -o app || { echo 'Go build failed!'; exit 1; } && \
    ./scripts/build.server.sh || { echo 'Server build failed!'; exit 1; }

# Final Stage: Prepare the app to run
FROM golang:1.24.4

WORKDIR /app

# Copy the final Go binary from the build stage
COPY --from=backend /app/app .

# Expose the app's port (usually 8080 for Go servers)
EXPOSE 8080

# Run the Go app
CMD ["./app"]
