# escape=`
FROM mcr.microsoft.com/dotnet/sdk:6.0

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

