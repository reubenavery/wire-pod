# syntax=docker/dockerfile:1

FROM debian:bookworm-slim

ARG TZ=America/New_York
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG STT=vosk
ENV STT=${STT}

WORKDIR /app

COPY . .

RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    wget openssl net-tools libsox-dev libopus-dev make iproute2 xz-utils libopusfile-dev pkg-config \
    gcc curl g++ unzip avahi-daemon git libasound2-dev libsodium-dev ca-certificates && \
    ./setup.sh && \
    rm -rf /var/lib/apt/lists/*

# Run the web service on container startup.
WORKDIR /app/chipper
CMD ["./start.sh"]
