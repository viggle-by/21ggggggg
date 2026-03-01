# ---- Builder stage ----
FROM ubuntu:resolute AS builder

ARG ROOTFS_URL="https://cdimage.ubuntu.com/releases/resolute/snapshot-4/ubuntu-26.04-snapshot4-wsl-amd64.wsl"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        xz-utils && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rootfs

# Download the WSL image (it's a tar.xz archive with .wsl extension)
RUN curl -L "$ROOTFS_URL" -o rootfs.tar.xz && \
    mkdir extracted && \
    tar -xJf rootfs.tar.xz -C extracted

# ---- Final stage ----
FROM scratch

# Copy extracted root filesystem into /
COPY --from=builder /rootfs/extracted/ /

# Set a default command
CMD ["/bin/bash"]
