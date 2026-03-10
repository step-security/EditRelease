FROM mcr.microsoft.com/dotnet/sdk:10.0@sha256:ea13841f10c6c410a6df63c6c97ab549dfd2b5fcfff1c00186531ba30208117d AS build
WORKDIR /src
COPY ["src/EditRelease/EditRelease.csproj", "EditRelease/"]
RUN dotnet restore EditRelease/EditRelease.csproj
COPY ["src/EditRelease", "EditRelease/"]
RUN dotnet publish EditRelease/EditRelease.csproj -c Release --no-restore -o /publish

# Label the container
LABEL maintainer="step-security"
LABEL repository="https://github.com/step-security/edit-release"
LABEL homepage="https://github.com/step-security/edit-release"

# Label as GitHub Action
LABEL com.github.actions.name="Edit Release"
LABEL com.github.actions.description="A GitHub Action for editing an existing release."
LABEL com.github.actions.icon="edit"
LABEL com.github.actions.color="purple"

FROM mcr.microsoft.com/dotnet/runtime:10.0-noble-chiseled@sha256:4064d8b92a610279f1d6de907c6de9bc4e4a07e4e1f94fdff77cd77a406d9725 AS final
WORKDIR /app
COPY --from=build /publish .
ENV DOTNET_EnableDiagnostics=0
ENTRYPOINT ["dotnet", "/app/EditRelease.dll"]
