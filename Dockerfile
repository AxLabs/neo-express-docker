FROM mcr.microsoft.com/dotnet/sdk:5.0 as dotnet-builder

FROM ubuntu:focal

WORKDIR /app

COPY --from=dotnet-builder /usr/share/dotnet /usr/share/dotnet

# install dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    jq \
    wait-for-it \
    net-tools \
    # Neo Blockchain Toolkit dependencies:
    libsnappy-dev \
    libc6-dev \
    librocksdb-dev \
    # SSL certs:
    ca-certificates

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
    NUGET_XMLDOC_MODE=skip \
    # Check this out:
    # https://github.com/dotnet/core/issues/2186#issuecomment-671105420
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet && \
    # Ensure backwards compatibility with some tools:
    ln -s /usr/share/dotnet/dotnet /usr/local/bin/dotnet

# Install: Neo Express
RUN dotnet tool install --global Neo.Express \
        --add-source https://pkgs.dev.azure.com/ngdenterprise/Build/_packaging/public%40Local/nuget/v3/index.json \
        --version 2.0.50-preview

ADD init_and_run_neoxp.sh /app/init_and_run_neoxp.sh
RUN chmod +x /app/init_and_run_neoxp.sh 

ENTRYPOINT ["/app/init_and_run_neoxp.sh"]
