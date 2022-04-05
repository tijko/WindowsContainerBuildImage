# escape=`
FROM mcr.microsoft.com/dotnet/sdk:6.0

# Set up environment to collect install errors.
COPY Install.cmd C:\TEMP\
ADD https://aka.ms/vscollect.exe C:\TEMP\collect.exe

# Download channel for fixed install.
ARG CHANNEL_URL=https://aka.ms/vs/19/release/channel
ADD ${CHANNEL_URL} C:\TEMP\VisualStudio.chman

# Download and install Build Tools for Visual Studio 2017.
ADD https://aka.ms/vs/19/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --channelUri C:\TEMP\VisualStudio.chman



SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install WebDeploy and NuGet with Chocolatey
RUN Install-PackageProvider -Name chocolatey -RequiredVersion 2.8.5.130 -Force; `
    Install-Package -Name nodejs.install -RequiredVersion 14.17.3 -Force; `
    Install-Package -Name webdeploy -RequiredVersion 3.6.0 -Force; `
    Install-Package nuget.commandline -RequiredVersion 4.9.2 -Force; 

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 4.8.0

RUN Invoke-WebRequest -OutFile dotnet.zip https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$Env:DOTNET_SDK_VERSION/dotnet-sdk-$Env:DOTNET_SDK_VERSION-win-x64.zip; `
    $dotnet_sha512 = '87776c7124cd25b487b14b3d42c784ee31a424c7c8191ed55810294423f3e59ebf799660864862fc1dbd6e6c8d68bd529399426811846e408d8b2fee4ab04fe5'; `
    if ((Get-FileHash dotnet.zip -Algorithm sha512).Hash -ne $dotnet_sha512) { `
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
        exit 1; `
    }; `
    `
    Expand-Archive dotnet.zip -force -DestinationPath $Env:ProgramFiles\dotnet; `
    Remove-Item -Force dotnet.zip

RUN setx /M PATH $($Env:PATH + ';' + $Env:ProgramFiles + '\dotnet')

#Download Azure DevOps agent
WORKDIR c:/setup
ADD https://vstsagentpackage.azureedge.net/agent/2.144.0/vsts-agent-win-x64-2.144.0.zip .

COPY InstallAgent.ps1 .
COPY ConfigureAgent.ps1 .

# Reset the shell.
SHELL ["cmd", "/S", "/C"]
RUN powershell -noexit "& "".\InstallAgent.ps1"""

# Configure agent on startup 
CMD powershell -noexit .\ConfigureAgent.ps1

