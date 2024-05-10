#!/bin/sh

ANDROID_VER="android-13.0.0_r83"
MANIFEST_VER="13.0.0"

ROOT_DIR=$(cd "$(dirname "$0")";pwd)
BUILD_DIR="${ROOT_DIR}/build"
REDROID_DIR="${BUILD_DIR}/redroid"
PATCHS_DIR="${BUILD_DIR}/patches"

# 遇到错误立即终止
set -e

while getopts 'c' OPT; do
    case $OPT in
        c) ARG_CLEAN="1";;
    esac
done

# 跳转到构建目录
echo "============= 初始化源 ============="
mkdir -p ${REDROID_DIR} && cd ${REDROID_DIR}

# 添加源码 https://android.googlesource.com/platform/manifest 
# 如果是中国可以使用 https://mirrors.bfsu.edu.cn/git/AOSP/platform/manifest 但请勿将其设置为默认
repo init -u https://android.googlesource.com/platform/manifest --git-lfs --depth=1 -b ${ANDROID_VER}

# 添加 redroid 模块
rm -rf .repo/local_manifests
git clone https://github.com/remote-android/local_manifests.git .repo/local_manifests -b ${MANIFEST_VER}

# 添加附加模块
cp -f ${ROOT_DIR}/manifest/*.xml .repo/local_manifests/

# 清理之前的构建
if [ -d "${REDROID_DIR}/out" ] && [ -n "$ARG_CLEAN" ]; then
  echo "============= 清除构建 ============="
  rm -rf "${REDROID_DIR}/out"
fi

# 同步代码
echo "============= 同步源码 ============="
# 判断是否已经同步过，如果同步过则删除本地补丁
if [ -d "${REDROID_DIR}/vendor" ]; then
  repo forall -vc "git reset --hard" >/dev/null
fi
repo sync -c -j8

# 应用 redroid 补丁
echo "============= 应用补丁 ============="
cd ${BUILD_DIR}
rm -rf ${PATCHS_DIR}
git clone https://github.com/remote-android/redroid-patches.git ${PATCHS_DIR}
${PATCHS_DIR}/apply-patch.sh ${REDROID_DIR}

# 修改构建文件
cp -f ${ROOT_DIR}/patches/device.mk ${REDROID_DIR}/device/redroid/redroid_x86_64/device.mk

# 构建用于构建 redroid 的镜像
echo "============= 准备构建 ============="
cd ${ROOT_DIR}
docker build --build-arg userid=$(id -u) --build-arg groupid=$(id -g) --build-arg username=$(id -un) -t redroid-builder .

# 执行构建镜像
echo "============= 开始构建 ============="
docker run -it --privileged --rm \
  --hostname redroid-builder \
  --name redroid-builder \
  -v ${REDROID_DIR}:/src \
  -v ${ROOT_DIR}/vendor/google/proprietary/widevine-prebuilt:/src/vendor/google/proprietary/widevine-prebuilt \
  -v ${ROOT_DIR}/patches/widevine/widevine.mk:/src/vendor/google/proprietary/widevine-prebuilt/widevine.mk \
  -v ${ROOT_DIR}/patches/widevine/Android.mk:/src/vendor/google/proprietary/widevine-prebuilt/Android.mk \
  -v ${ROOT_DIR}/patches:/patches \
  redroid-builder

# 创建 redroid 镜像
echo "============= 创建镜像 ============="

cd ${REDROID_DIR}/out/target/product/redroid_x86_64
cat redroid.tar | docker import -c 'ENTRYPOINT ["/init", "androidboot.hardware=redroid"]' - redroid

cd ${ROOT_DIR}
echo "============= 执行完成 ============="
