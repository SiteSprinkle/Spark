# Use a Python base image
FROM python:3.8-slim

# Set environment variable to prevent Python from writing .pyc files
ENV PYTHONUNBUFFERED 1

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies needed for building packages (if needed)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libssl-dev \
    libffi-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Clone the XenoRAT repository into the container
RUN git clone https://github.com/moom825/xeno-rat.git /app

# Change working directory to the XenoRAT directory
WORKDIR /app

# Install additional libraries to parse imports and install dependencies
RUN pip install pipreqs

# Use pipreqs to generate requirements automatically from the repository's imports
RUN pipreqs . --force

# Install the dependencies from the generated requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the RAT will use (Change this if the RAT uses a different port)
EXPOSE 8080

# Run XenoRAT on startup (Make sure to adjust this according to the main script)
CMD ["python", "main.py"]
