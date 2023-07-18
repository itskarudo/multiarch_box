# docker build -t multiarch_box .
# docker run --rm -v $PWD:/pwd --cap-add=SYS_PTRACE --privileged --security-opt seccomp=unconfined -d --name ctf -i multiarch_box
# docker exec -it ctf /bin/bash

# inside the container: update-binfmts --enable

FROM ubuntu:22.04
ENV LC_CTYPE C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 && \
apt-get update && \
apt-get install -y build-essential jq strace ltrace curl wget rubygems gcc dnsutils netcat gcc-multilib net-tools neovim gdb gdb-multiarch python3 python3-pip python3-dev libssl-dev libffi-dev wget git make procps libpcre3-dev libdb-dev libxt-dev libxaw7-dev python3-pip libc6:i386 libncurses5:i386 libstdc++6:i386 libcapstone4 libnuma1 liburing2 qemu-user file tmux

RUN pip3 install pwntools keystone-engine unicorn capstone ropper

RUN git clone https://github.com/pwndbg/pwndbg && cd pwndbg && ./setup.sh

RUN gem install one_gadget

RUN apt-get install -y gcc-arm-linux-gnueabihf libc6-armhf-cross libc6-mipsel-cross libc6-riscv64-cross

RUN mkdir /etc/qemu-binfmt && \
ln -s /usr/arm-linux-gnueabihf/ /etc/qemu-binfmt/arm && \
ln -s /usr/mipsel-linux-gnu/ /etc/qemu-binfmt/mipsel && \
ln -s /usr/riscv64-linux-gnu/ /etc/qemu-binfmt/riscv64

