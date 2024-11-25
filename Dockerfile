# Define software versions
ARG HANDBRAKE_VERSION=1.8.2

# Base image
FROM ubuntu:24.04

# Define working directory
WORKDIR /tmp

# Update and install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Essential packages
    build-essential \
    wget \
    curl \
    ca-certificates \
    software-properties-common \
    # Mesa drivers for VAAPI support
    mesa-va-drivers \
    libva2 \
    libva-drm2 \
    libva-glx2 \
    libva-x11-2 \
    vainfo \
    # HandBrake dependencies
    libgtk-3-0 \
    libgudev-1.0-0 \
    libnotify4 \
    libsamplerate0 \
    libass9 \
    libdrm2 \
    jansson \
    xz-utils \
    numactl \
    libturbojpeg0 \
    # Media codecs
    libtheora0 \
    libvorbis0a \
    libvorbisenc2 \
    libopus0 \
    libvpx7 \
    libx264-163 \
    lame \
    # Miscellaneous tools
    pciutils \
    bash \
    coreutils \
    findutils \
    expect \
    lsscsi \
    fonts-cantarell \
    adwaita-icon-theme && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install HandBrake
RUN wget https://github.com/HandBrake/HandBrake/releases/download/${HANDBRAKE_VERSION}/HandBrake-${HANDBRAKE_VERSION}-x86_64.Ubuntu_24.04.deb && \
    dpkg -i HandBrake-${HANDBRAKE_VERSION}-x86_64.Ubuntu_24.04.deb && \
    rm HandBrake-${HANDBRAKE_VERSION}-x86_64.Ubuntu_24.04.deb

# Environment variables for VAAPI
ENV LIBVA_DRIVER_NAME=radeonsi
ENV LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri

# Set internal environment variables
ENV HANDBRAKE_GUI=1
ENV HANDBRAKE_DEBUG=0

# Add files (if any custom files are needed, copy them here)
# COPY your-custom-files /path

# Define volumes
VOLUME ["/storage", "/output", "/watch", "/trash"]

# Set the entrypoint to the HandBrake GUI
ENTRYPOINT ["/usr/bin/ghb"]

# Metadata
LABEL org.label-schema.name="HandBrake" \
      org.label-schema.description="HandBrake Docker Container with Ubuntu 24.04 and Mesa VAAPI support" \
      org.label-schema.version="${HANDBRAKE_VERSION}" \
      org.label-schema.schema-version="1.0"
