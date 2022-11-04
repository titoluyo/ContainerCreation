FROM mcr.microsoft.com/windows/servercore:ltsc2019

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

WORKDIR /actions-runner

# Install Chocolatey
RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

RUN choco install -y \
    curl \
    git

RUN choco install -y \
    azure-cli \
    powershell-core \
    az.powershell

RUN choco install -y \
    unzip \
    zip \
    7zip

RUN choco install -y \
    nodejs \
    python3

RUN choco install -y \
    sqlpackage \
    sqlserver-cmdlineutils

# SHELL ["/bin/bash", "-c"]
# Install .Net Framework 4.8
ENV \
    # Enable detection of running in a container
    COMPLUS_RUNNING_IN_CONTAINER=1 \
    COMPLUS_NGenProtectedProcess_FeatureEnabled=0

# RUN \
    # Install .NET Fx 4.8
#RUN curl -fSLo dotnet-framework-installer.exe https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe
RUN curl -o dotnet-framework-installer.exe https://download.visualstudio.microsoft.com/download/pr/2d6bb6b2-226a-4baa-bdec-798822606ff1/8494001c276a4b96804cde7829c04d7f/ndp48-x86-x64-allos-enu.exe
RUN pwd
RUN dir
RUN .\dotnet-framework-installer.exe /q
RUN del .\dotnet-framework-installer.exe
RUN powershell Remove-Item -Force -Recurse ${Env:TEMP}\*

    # Apply latest patch
RUN    curl -o patch.msu https://catalog.s.download.windowsupdate.com/c/msdownload/update/software/updt/2022/08/windows10.0-kb5017263-x64-ndp48_bbc9586178ba2f66be2a58ef7c6b4d2362b7bdfe.msu
RUN    mkdir patch
RUN    expand patch.msu patch -F:*
RUN    del patch.msu
RUN    dism /Online /Quiet /Add-Package /PackagePath:C:\actions-runner\patch\windows10.0-kb5017263-x64-ndp48.cab
RUN    rmdir /S /Q patch

    # ngen .NET Fx
RUN    %windir%\Microsoft.NET\Framework64\v4.0.30319\ngen uninstall "Microsoft.Tpm.Commands, Version=10.0.0.0, Culture=Neutral, PublicKeyToken=31bf3856ad364e35, processorArchitecture=amd64"
RUN    %windir%\Microsoft.NET\Framework64\v4.0.30319\ngen update
RUN    %windir%\Microsoft.NET\Framework\v4.0.30319\ngen update

# Azure Devops Runner
WORKDIR /azp

