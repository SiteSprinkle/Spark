# Stage 1: Build front-end (Node.js environment)
FROM node:18 AS frontend

# Set working directory
WORKDIR /app/web

# Copy front-end files
COPY ./web/package.json ./web/package-lock.json ./
RUN npm install

# Stage 2: Build Go server (Go environment)
FROM golang:1.24.4 AS backend

# Install Node.js (because it's missing in the Go image)
RUN apt-get update && \
    apt-get install -y nodejs npm

# Set working directory for the backend
WORKDIR /app

# Copy Go files
COPY . .

# Step 1: Build front-end (using Node.js)
RUN cd web && npm run build-prod

# Step 2: Embed static resources into Go app
RUN go install github.com/rakyll/statik && \
    statik -m -src="./web/dist" -f -dest="./server/embed" -p web -ns web

# Step 3: Build Go client
RUN mkdir -p ./built && \
    go mod tidy && \
    go mod download && \
    ./scripts/build.client.sh

# Step 4: Build Go server
RUN mkdir -p ./releases && \
    go build -tags netgo -ldflags '-s -w' -o app && \
    ./scripts/build.server.sh

# Final stage: Prepare app to run
FROM golang:1.24.4

WORKDIR /app

# Copy the final Go binary
COPY --from=backend /app/app .

# Expose the app's port
EXPOSE 8080

# Run the Go app
CMD ["./app"]
