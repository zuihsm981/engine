FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y curl git unzip xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config libgtk-3-dev python3 && \
    apt-get clean

RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git /depot_tools
ENV PATH="/depot_tools:${PATH}"
ENV GCLIENT_METRICS_OPT_IN=0

WORKDIR /workspace

ARG ENGINE_REVISION
RUN if [ -z "$ENGINE_REVISION" ]; then \
        ENGINE_REVISION=$(curl -s https://raw.githubusercontent.com/flutter/flutter/3.24.3/bin/internal/engine.version); \
    fi && \
    echo "Using engine revision: $ENGINE_REVISION" && \
    gclient config --spec='solutions=[{"name":"src/flutter","url":"https://github.com/flutter/engine.git","deps_file":"DEPS","managed":False}]' && \
    gclient sync --no-history --shallow
