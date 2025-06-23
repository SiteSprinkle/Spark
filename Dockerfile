# Stage 1: Build Go back-end (without front-end build)
FROM golang:1.24.4 AS backend

# Set working directory for Go back-end
WORKDIR /app

# Copy the entire project
COPY . .

# Check that Go dependencies are in place
RUN go mod tidy && go mod download

# Build Go server and put it in releases folder
RUN mkdir -p ./releases && go build -tags netgo -ldflags '-s -w' -o ./releases/app

# Final Stage: Run the server executable from releases
FROM golang:1.24.4

# Set working directory for running the server
WORKDIR /app

# Copy the built executable from the backend stage
COPY --from=backend /app/releases/app .

# Expose the app's port (usually 8080 for Go servers)
EXPOSE 8080

# Run the Go server executable directly
CMD ["./app"]
