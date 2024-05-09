FROM ubuntu:20.04

# 定义参数
ARG userid
ARG groupid
ARG username

# 复制执行文件
COPY entry.sh entry.sh

# 增加补丁
COPY vendor/google/proprietary/widevine-prebuilt /src/vendor/google/proprietary/widevine-prebuilt
COPY vendor/intel/proprietary/houdini /src/vendor/intel/proprietary/houdini

# 设置环境
ENV DEBIAN_FRONTEND noninteractive

# 设置执行权限
RUN ["chmod", "+x", "/entry.sh"]

# 添加构件库
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y apt-utils \
    && echo "install package for building AOSP" \
    && apt-get install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev \
        gcc-multilib g++-multilib libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev \
        libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig procps \
    && echo "install utils" \
    && apt-get install -y sudo rsync \
    && echo "install packages for build mesa3d or meson related" \
    && apt-get install -y python3-pip pkg-config python3-dev ninja-build \
    && pip3 install mako meson \
    && echo "packages for legacy mesa3d (< 22.0.0)" \
    && apt-get install -y python2 python-mako python-is-python2 python-enum34 gettext

# 添加用户
RUN groupadd -g $groupid $username \
    && useradd -m -u $userid -g $groupid $username \
    && echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
    && echo $username >/root/username \
    && echo "$username:$username" | chpasswd && adduser $username sudo

# 设置用户环境
ENV HOME=/home/$username \
    USER=$username \
    PATH=/src/.repo/repo:/src/prebuilts/jdk/jdk8/linux-x86/bin/:$PATH

# 执行构建命令
ENTRYPOINT chroot --userspec=$(cat /root/username):$(cat /root/username) / /entry.sh
