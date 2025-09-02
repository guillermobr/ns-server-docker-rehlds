FROM debian:bullseye-slim

# Install dependencies
RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y wget tar unzip git lib32gcc-s1 lib32stdc++6 libc6-i386 curl && \
    rm -rf /var/lib/apt/lists/*

# Create steam user
RUN groupadd -r steam && \
    useradd -r -g steam -m -d /opt/steam steam

# Install SteamCMD
RUN mkdir -p /steamcmd && cd /steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

WORKDIR /hlds

# --- Install base HLDS with SteamCMD ---
RUN /steamcmd/steamcmd.sh +force_install_dir /hlds +login anonymous +app_update 90 validate +quit

# --- Setup Steam SDK directories and steam_appid.txt ---
RUN mkdir -p /opt/steam/.steam && \
    ln -s /hlds /opt/steam/.steam/sdk32 && \
    echo 70 > /hlds/steam_appid.txt

# Copy startup script
RUN chown -R steam:steam /hlds && \
    mkdir -p /tmp/dumps && \
    chown steam:steam /tmp/dumps
COPY start_server.sh /hlds/start_server.sh
RUN chmod +x /hlds/start_server.sh

# Switch to steam user
USER steam

# --- Install HLDS (ReHLDS) overlay ---
RUN wget https://github.com/rehlds/ReHLDS/releases/download/3.14.0.857/rehlds-bin-3.14.0.857.zip && \
    unzip rehlds-bin-3.14.0.857.zip && \
    chmod +x bin/linux32/hlds_linux && \
    rm rehlds-bin-3.14.0.857.zip

# --- Install Natural Selection ---
RUN mkdir -p /hlds/ns
RUN wget https://github.com/ENSL/NS/releases/download/v3.3b9/ns_v33b9_full.zip
RUN unzip ns_v33b9_full.zip -d /hlds && rm ns_v33b9_full.zip

# --- Install ENSL Plugin Package ---
RUN cd /hlds/ns && \
    cp /hlds/ns/liblist.gam /hlds/ns/liblist.bak && \
    wget https://github.com/ENSL/ensl-plugin/releases/download/1.4-extra/ENSL_SrvPkg-1.4-extra.zip -O srv.zip && \
    unzip -o srv.zip && \
    touch /hlds/ns/server.cfg && \
    rm srv.zip

# Copy own configs including AMX configurations
ADD overlay /hlds/ns/

# Fix ownership of copied overlay files
USER root
RUN chown -R steam:steam /hlds/ns/ && \
    chmod -R 755 /hlds/ns/
USER steam

# Expose HLDS port
EXPOSE 27015/udp 27015/tcp

# Start NS server
CMD ["./start_server.sh"]
# CMD ["bash"]
