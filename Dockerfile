FROM ubuntu:16.04
LABEL version="0.1"
MAINTAINER Pedro Calixto - pgcalixto

ARG MPLABX_VERSION=4.15
ARG XC32_VERSION=2.05

# Sets up environment for MPLAB tools installation
# Download and install xc32 compiler
# Download and install MPLAB X IDE
# Download and install PIC32 Legacy Peripheral Libraries (plib)
RUN dpkg --add-architecture i386 \
 \
 && apt-get update && apt-get install -qq \
    libc6:i386 \
    lld-5.0 \
    lldb-5.0 \
    libexpat1:i386 \
    libgtk2.0-0 \
    libssl-dev \
    libstdc++6:i386 \
    libx11-6:i386 \
    libxext6:i386 \
    libxext6 \
    libxrender1 \
    libxslt1.1 \
    libxtst6 \
    wget \
 \
 && wget -O /tmp/xc32.run "http://ww1.microchip.com/downloads/en/DeviceDoc/xc32-v${XC32_VERSION}-full-install-linux-installer.run" \
 && wget -O /tmp/mplabx-installer.tar "http://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v${MPLABX_VERSION}-linux-installer.tar" \
 && wget -O /tmp/plib.tar "http://ww1.microchip.com/downloads/en//softwarelibrary/pic32%20peripheral%20library/pic32%20legacy%20peripheral%20libraries%20linux%20(2).tar" \
 \
 && chmod a+x /tmp/xc32.run \
 && /tmp/xc32.run --mode unattended --unattendedmodeui none \
    --netservername localhost --LicenseType FreeMode \
 && rm /tmp/xc32.run \
 \
 && tar xf /tmp/mplabx-installer.tar && rm /tmp/mplabx-installer.tar \
 && USER=root ./MPLABX-v${MPLABX_VERSION}-linux-installer.sh --nox11 \
    -- --unattendedmodeui none --mode unattended \
 && rm ./MPLABX-v${MPLABX_VERSION}-linux-installer.sh \
 \
 && tar xf /tmp/plib.tar -C /tmp \
 && rm /tmp/plib.tar \
 && mv /tmp/PIC32\ Legacy\ Peripheral\ Libraries.run /tmp/plib.run \
 && USER=root /tmp/plib.run --unattendedmodeui minimal --mode unattended \
    --prefix /opt/microchip/xc32/v${XC32_VERSION}/ \
 && rm /tmp/plib.run \
 \
 && apt-get purge --autoremove -qq \
    wget \
 && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/microchip/xc32/v${XC32_VERSION}/bin:$PATH
ENV PATH=/opt/microchip/mplabx/v${MPLABX_VERSION}/mplab_ide/bin:$PATH
