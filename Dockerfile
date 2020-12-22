FROM microsoft/dotnet:2.1-sdk AS build
COPY . ApmTest/
WORKDIR /ApmTest
run dotnet restore ApmTest.sln

FROM build AS publish
WORKDIR /ApmTest/
RUN dotnet publish ApmTest.sln -c Release -o /app

FROM microsoft/dotnet:2.1-aspnetcore-runtime AS runtime
COPY . ApmTest/
WORKDIR /app
EXPOSE 8003

FROM runtime AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ApmTest.dll"] 