# Use an official Go image (Linux-based, ARM64 compatible)
FROM golang:1.24.4-alpine

# Set working directory
WORKDIR /app

# Install utilities to download, extract files, and unzip (curl, tar, bash)
RUN apk add --no-cache curl tar bash unzip

# Download the Linux ARM64 executable from the GitHub release
RUN curl -L -o server_linux_arm64.tar.gz https://github.com/XZB-1248/Spark/releases/download/v0.2.1/server_linux_arm64.tar.gz

# Verify the downloaded file (list the file to ensure it exists)
RUN ls -lh server_linux_arm64.tar.gz && echo "File downloaded successfully"

# Check the file integrity (exit with an error if the file is invalid)
RUN tar -tzf server_linux_arm64.tar.gz || { echo 'Invalid tar file!'; exit 1; }

# Extract the tar.gz file using tar (without gunzip)
RUN tar -xvzf server_linux_arm64.tar.gz -C /app || { echo 'Extraction failed!'; exit 1; }

# Expose the port for the app (change if needed)
EXPOSE 8080

# Run the extracted executable
CMD ["./server"]
