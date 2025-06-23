# Use the official .NET Core SDK image to build the application
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Install .NET SDK for building the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the .csproj and restore dependencies
COPY ["xeno rat server/xeno rat server.csproj", "xeno rat server/"]
RUN dotnet restore "xeno rat server/xeno rat server.csproj"

# Copy the rest of the code and build the app
COPY . .
WORKDIR "/src/xeno rat server"
RUN dotnet build "xeno rat server.csproj" -c Release -o /app/build

# Publish the app to the /app/publish directory
RUN dotnet publish "xeno rat server.csproj" -c Release -o /app/publish

# Set the entry point for running the app
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "xeno rat server.dll"]
