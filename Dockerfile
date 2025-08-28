FROM debian:bullseye

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
COPY start_server.sh /hlds/start_server.sh
RUN chmod +x /hlds/start_server.sh && \
    chown -R steam:steam /hlds

# Switch to steam user
USER steam

# --- Install HLDS (ReHLDS) overlay ---
RUN wget https://github.com/rehlds/ReHLDS/releases/download/3.14.0.857/rehlds-bin-3.14.0.857.zip && \
    unzip rehlds-bin-3.14.0.857.zip && \
    ls -la && \
    chmod +x bin/linux32/hlds_linux && \
    rm rehlds-bin-3.14.0.857.zip

# --- Install Natural Selection ---
RUN mkdir -p /hlds/ns && \
    wget https://github.com/ENSL/NS/releases/download/v3.3b9/ns_v33b9_full.zip && \
    unzip ns_v33b9_full.zip -d /hlds && rm ns_v33b9_full.zip

# --- Install Metamod-R ---
# RUN mkdir -p /hlds/ns/addons/metamod/dlls && \
#     wget https://github.com/rehlds/Metamod-R/releases/download/1.3.0.149/metamod-bin-1.3.0.149.zip && \
#     unzip metamod-bin-1.3.0.149.zip && \
#     find . -name "*metamod*.so" -exec cp {} /hlds/ns/addons/metamod/dlls/metamod.so \; && \
#     rm -rf metamod-bin-1.3.0.149.zip

# --- Install AMX Mod X ---
# RUN cd /hlds/ns/addons && \
#     wget https://github.com/pierow/amxmodx-ns/releases/download/amxx-ns3.3b9/amxx_1.8.2_lin_ns3.3b9_full.zip && \
#     unzip amxx_1.8.2_lin_ns3.3b9_full.zip && \
#     ls -la && \
#     rm amxx_1.8.2_lin_ns3.3b9_full.zip && \
#     echo "linux addons/amxmodx/dlls/amxmodx_mm_i386.so" >> /hlds/ns/addons/metamod/plugins.ini

# Expose HLDS port
EXPOSE 27015/udp 27015/tcp

# Start NS server
CMD ["./start_server.sh"]
# CMD ["bash"]
