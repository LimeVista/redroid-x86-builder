LOCAL_PATH := $(call my-dir)

#include $(CLEAR_VARS)
#LOCAL_MODULE := move_widevine_data.sh
#LOCAL_SRC_FILES := prebuilts/bin/move_widevine_data.sh
#LOCAL_MODULE_TAGS := optional
#LOCAL_MODULE_STEM := move_widevine_data
#LOCAL_MODULE_SUFFIX := .sh
#LOCAL_MODULE_CLASS := EXECUTABLES
#include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MULTILIB := 64
LOCAL_MODULE := libwvhidl
LOCAL_MODULE_SUFFIX :=.so
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_PROPRIETARY_MODULE := true
LOCAL_CHECK_ELF_FILES := false
LOCAL_SRC_FILES_64 := prebuilts/lib64/libwvhidl.so
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.drm@1.4-service-lazy.widevine
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_SRC_FILES := prebuilts/bin/hw/android.hardware.drm@1.4-service-lazy.widevine
LOCAL_INIT_RC := prebuilts/etc/init/android.hardware.drm@1.4-service-lazy.widevine.rc
LOCAL_VINTF_FRAGMENTS := prebuilts/etc/vintf/manifest/manifest_android.hardware.drm@1.4-service.widevine.xml
LOCAL_CHECK_ELF_FILES := false
LOCAL_REQUIRED_MODULES := libwvhidl
include $(BUILD_PREBUILT)
