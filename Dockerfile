FROM microsoft/aspnetcore-build:2.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out
RUN dotnet ef database update

# Build runtime image
FROM build-env
WORKDIR /app
COPY --from=build-env /app/out .

EXPOSE 5001/tcp
ENV ASPNETCORE_URLS http://*:5001
#ENV ASPNETCORE_ENVIRONMENT Development

ENTRYPOINT ["dotnet", "netcore-test.dll"]