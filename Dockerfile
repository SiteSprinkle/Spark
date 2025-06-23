# Use an official Go image (Linux-based, ARM64 compatible)
FROM golang:1.24.4-alpine

# Set working directory
WORKDIR /app

# Install utilities to download, extract files, and unzip (curl, tar, unzip, bash)
RUN apk add --no-cache curl tar bash unzip

# Download the Linux ARM64 executable from the GitHub release
RUN curl -L -o server_linux_arm64.tar.gz https://github.com/XZB-1248/Spark/releases/download/v0.2.1/server_linux_arm64.tar.gz

# Verify the download (optional: check if the file exists and is not empty)
RUN ls -lh server_linux_arm64.tar.gz && echo "File downloaded successfully"

# Unzip the .tar.gz and then extract it
RUN gunzip -c server_linux_arm64.tar.gz | tar -xv -C /app

# Expose the port for the app (change if needed)
EXPOSE 8080

# Run the Linux ARM64 executable (assuming it's named 'server' in the extracted files)
CMD ["./server"]
