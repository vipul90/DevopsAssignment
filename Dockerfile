FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim
WORKDIR /app
COPY DevopsAppPublish/app/publish .
ENTRYPOINT ["dotnet", "DevopsApp.dll"]
EXPOSE 90
EXPOSE 444