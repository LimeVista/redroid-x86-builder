#!/bin/bash

set -e

# 清理构建目录
rm -rf /src/out

# 原目录
cd /src

# 设置环境
. build/envsetup.sh

# 设置构建目标
lunch redroid_x86_64-userdebug

# 开始构建
m
