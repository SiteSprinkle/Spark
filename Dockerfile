# Use a Windows Server Core base image
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Set working directory
WORKDIR /app

# Install utilities to download and extract the file (powershell)
RUN powershell -Command \
    Set-ExecutionPolicy Unrestricted -Scope Process -Force; \
    Invoke-WebRequest -Uri https://github.com/SiteSprinkle/Spark/releases/download/v0.2.1/server_windows_amd64.zip -OutFile server_windows_amd64.zip

# Extract the downloaded zip file
RUN powershell -Command \
    Expand-Archive -Path server_windows_amd64.zip -DestinationPath .; \
    Remove-Item server_windows_amd64.zip

# Expose the port for the app (change if needed)
EXPOSE 8080

# Run the Windows executable (assuming it's server.exe inside the zip)
CMD ["./server.exe"]
