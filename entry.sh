#!/bin/bash

set -e

# 原目录
cd /src

# 设置环境
. build/envsetup.sh

# 设置构建目标
lunch redroid_x86_64-userdebug

# 开始构建
m

# 跳转到构建目标目录
cd /src/out/target/product/redroid_x86_64

# 挂载镜像
sudo mount system.img system -o ro
sudo mount vendor.img vendor -o ro

# 打包为 tar 文件
sudo rm -rf redroid.tar
sudo tar --xattrs -c vendor -C system --exclude="./vendor" . > redroid.tar

# 卸载镜像
sudo umount system vendor