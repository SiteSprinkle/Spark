# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    tar \
    unzip \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Download the server tarball
RUN curl -L -o server_linux_arm64.tar.gz https://github.com/XZB-1248/Spark/releases/download/v0.2.1/server_linux_arm64.tar.gz

# Verify that the file was downloaded
RUN ls -lh server_linux_arm64.tar.gz

# Extract the tarball
RUN tar -xzvf server_linux_arm64.tar.gz

# Expose the necessary port (adjust if needed)
EXPOSE 8080

# Run the server
CMD ["./server"]
