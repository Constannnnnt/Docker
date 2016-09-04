# assuming user is dhtsys with UID 1000
FROM ubuntu
RUN useradd -u 1000 -r dhtsys
# RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# RUN mkdir -p /tmp/test/
VOLUME ["/tmp/test/"]
USER dhtsys
WORKDIR /tmp/test/
