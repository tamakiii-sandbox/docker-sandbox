FROM debian:10.5 AS mainline

# --

FROM mainline AS bsd

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bmake \
      && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# --
