#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
EXPOSE 5000
WORKDIR /app

# Copy csproj and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the entire project and build
COPY . .
RUN dotnet build -c Release --no-restore

# Publish the application
RUN dotnet publish -c Release -o out --no-restore

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app

# Copy the published output from the build stage
COPY --from=build /app/out .

# Set the entry point for the container
ENTRYPOINT ["dotnet", "BackendForOpenShiftDemo.dll"]