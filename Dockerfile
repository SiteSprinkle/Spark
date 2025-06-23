# Use an official Go image (Linux-based)
FROM golang:1.24.4-alpine

# Set working directory
WORKDIR /app

# Install utilities to download and extract files (curl, tar)
RUN apk add --no-cache curl tar

# Download the Linux executable (e.g., from GitHub or your server)
RUN curl -LO https://github.com/SiteSprinkle/Spark/releases/download/v1.0.0/server_linux_amd64.tar.gz

# Extract the downloaded tar file
RUN tar -xvzf server_linux_amd64.tar.gz

# Expose the port for the app (change if needed)
EXPOSE 8080

# Run the Linux executable (assuming it's server in the extracted files)
CMD ["./server"]
