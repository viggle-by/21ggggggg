# ---- Builder stage ----
FROM ubuntu:resolute AS builder

ARG ROOTFS_URL="https://cdimage.ubuntu.com/releases/resolute/snapshot-4/ubuntu-26.04-snapshot4-wsl-amd64.wsl"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /rootfs

# Download and extract gzip archive
RUN curl -L "$ROOTFS_URL" -o rootfs.tar.gz && \
    mkdir extracted && \
    tar -xzf rootfs.tar.gz -C extracted

# ---- Final stage ----
FROM scratch

COPY --from=builder /rootfs/extracted/ /

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["/bin/bash"]
