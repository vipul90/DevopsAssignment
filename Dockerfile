FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim
WORKDIR DevopsApp/app
COPY DevopsApp/app/publish .
ENTRYPOINT ["dotnet", "DevopsApp.dll"]
EXPOSE 80
EXPOSE 443