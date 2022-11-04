# # https://hub.docker.com/_/microsoft-dotnet-framework-sdk (see Full tag listing section)
# FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc20194
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]
# SHELL ["powershell", "-Command"]
SHELL ["cmd", "-c"]

# WORKDIR /actions-runner

# # Install Chocolatey
# RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# RUN choco install -y \
#     curl \
#     git

# RUN choco install -y \
#     azure-cli \
#     powershell-core \
#     az.powershell

# RUN choco install -y \
#     unzip \
#     zip \
#     7zip

# RUN choco install -y \
#     nodejs \
#     python3

# RUN choco install -y \
#     sqlpackage \
#     sqlserver-cmdlineutils

COPY ./netfw/481/dotnet-framework-installer.exe .
COPY ./netfw/481/patch.msu .
COPY ./netfw/481/nuget.exe .
COPY ./netfw/481/vs_TestAgent.exe .

# SHELL ["/bin/bash", "-c"]
# Install .Net Framework 4.8
ENV \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    COMPLUS_RUNNING_IN_CONTAINER=1 \
    COMPLUS_NGenProtectedProcess_FeatureEnabled=0

# RUN \
    # Install .NET Fx 4.8
#RUN curl -fSLo dotnet-framework-installer.exe https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe
#RUN curl -o dotnet-framework-installer.exe https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe
# RUN curl -o dotnet-framework-installer.exe https://download.visualstudio.microsoft.com/download/pr/6f083c7e-bd40-44d4-9e3f-ffba71ec8b09/3951fd5af6098f2c7e8ff5c331a0679c/ndp481-x86-x64-allos-enu.exe

RUN .\dotnet-framework-installer.exe /q
RUN del .\dotnet-framework-installer.exe
RUN powershell Remove-Item -Force -Recurse ${Env:TEMP}\*

# ## Apply latest patch
# # RUN curl -o patch.msu https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/updt/2022/08/windows10.0-kb5017263-x64-ndp48_bbc9586178ba2f66be2a58ef7c6b4d2362b7bdfe.msu
# # RUN curl -o patch.msu https://catalog.s.download.windowsupdate.com/d/msdownload/update/software/updt/2022/08/windows10.0-kb5017268-x64-ndp481_684aa04c830ad9b05b4f91c6f4e5b4a3970a0a23.msu
# RUN mkdir patch
# RUN expand patch.msu patch -F:*
# RUN del patch.msu
# # RUN dism /Online /Quiet /Add-Package /PackagePath:C:\patch\windows10.0-kb5017263-x64-ndp48.cab
# RUN dism /Online /Quiet /Add-Package /PackagePath:C:\patch\windows10.0-kb5017268-x64-ndp481.cab
# RUN rmdir /S /Q patch


# SHELL ["cmd", "-c"]
    # ngen .NET Fx
# RUN %windir%\Microsoft.NET\Framework64\v4.0.30319\ngen uninstall "Microsoft.Tpm.Commands, Version=10.0.0.0, Culture=Neutral, PublicKeyToken=31bf3856ad364e35, processorArchitecture=amd64"
RUN %windir%\Microsoft.NET\Framework64\v4.0.30319\ngen install "Microsoft.PowerShell.Utility.Activities, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    
RUN %windir%\Microsoft.NET\Framework64\v4.0.30319\ngen update
RUN %windir%\Microsoft.NET\Framework\v4.0.30319\ngen update

ENV \
    # Do not generate certificate
    DOTNET_GENERATE_ASPNET_CERTIFICATE=false \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # NuGet version to install
    NUGET_VERSION=6.3.0 \
    # Install location of Roslyn
    ROSLYN_COMPILER_LOCATION="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\Bin\Roslyn"



# Azure Devops Runner
WORKDIR /azp

