FROM mcr.microsoft.com/dotnet/sdk:5.0 as dotnet-builder

WORKDIR /app

ENV HOME=/root

ENV \
    PATH=$HOME/.dotnet/tools:$PATH \
    #############################
    # .NET Core SDK: Env vars:
    #############################
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Disable Telemetry
    DOTNET_CLI_TELEMETRY_OPTOUT=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip

# Install: Neo Express
RUN dotnet tool install --global Neo.Express \
        --add-source https://pkgs.dev.azure.com/ngdenterprise/Build/_packaging/public%40Local/nuget/v3/index.json \
        --version 2.0.39-preview

ENTRYPOINT ["neoxp", "run"]