FROM buildpack-deps:trusty
MAINTAINER CONSTANT CHEN <constantchen@astri.org>

# Install dependencies\
# most of these are already available in `buildpack-deps:14.04`
# requiring only a 9MB download
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    automake build-essential cmake realpath \
    bc lzop nasm && \ 
    rm -rf /var/lib/apt/lists/*

# Install arm gcc complier 4.9.2
COPY fsl-imx-fb-glibc-x86_64-meta-toolchain-cortexa9hf-vfp-neon-toolchain-3.14.52-1.1.0.sh /tmp
RUN /tmp/fsl-imx-fb-glibc-x86_64-meta-toolchain-cortexa9hf-vfp-neon-toolchain-3.14.52-1.1.0.sh

# Export the complier's path
ENV COMPILER_PATH=/opt/fsl-imx-fb/3.14.52-1.1.0/sysroots

# Set the working Directory
WORKDIR /input

VOLUME ["/input", "/output"]

CMD ["/bin/bash"]
