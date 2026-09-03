# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    audio.deep_buffer.media=true \
    audio.offload.buffer.size.kb=64 \
    audio.offload.gapless.enabled=true \
    audio.offload.min.duration.secs=30 \
    audio.offload.pcm.16bit.enable=false \
    audio.offload.pcm.24bit.enable=true \
    audio.offload.video=true \
    av.streaming.offload.enable=true \
    media.aac_51_output_enabled=true \
    persist.audio.fluence.speaker=true \
    persist.audio.fluence.voicecall=true \
    persist.audio.fluence.voicerec=false \
    ro.qc.sdk.audio.fluencetype=none \
    ro.qc.sdk.audio.ssr=false \
    use.voice.path.for.pcm.voip=true \
    sys.audio.init=false \
    audio.dolby.ds2.enabled=true

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.bluetooth.modem_nv_support=true \
    persist.bluetooth.avrcpversion=avrcp16 \
    persist.bt.enable.splita2dp=false \
    net.bt.name=Android

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    camera2.portability.force_api=1 \
    media.stagefright.enable-player=true \
    media.stagefright.enable-http=true \
    media.stagefright.enable-aac=true \
    media.stagefright.enable-qcp=true \
    media.stagefright.enable-fma2dp=true \
    media.stagefright.enable-scan=true \
    mmp.enable.3g2=true \
    media.aac_51_output_enabled=true \
    media.settings.xml=/vendor/etc/media_profiles_vendor.xml \
    mm.enable.qcom_parser=256 \
    media.stagefright.use-awesome=false \
    persist.camera.longshot.stages=1 \
    persist.vendor.qti.telephony.vt_cam_interface=1

# CNE
PRODUCT_PROPERTY_OVERRIDES += \
    persist.cne.feature=1

# Dalvik
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapsize=36m \
    dalvik.vm.zygotemaxfailedboots=5 \
    persist.sys.dalvik.vm.lib.2=libart.so \
    dalvik.vm.isa.arm.variant=cortex-a7 \
    dalvik.vm.isa.arm.features=default \
    dalvik.vm.systemservercompilerfilter=speed-profile \
    dalvik.vm.stack-trace-dir=/data/anr

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.enable_hwc_vds=1 \
    debug.sf.hw=1 \
    debug.egl.hw=1 \
    debug.sf.latch_unsignaled=1 \
    debug.sf.disable_backpressure=1 \
    debug.hwc.dynThreshold=3.1 \
    debug.mdpcomp.logs=0 \
    dev.pm.dyn_samplingrate=1 \
    persist.demo.hdmirotationlock=false \
    debug.sdm.support_writeback=0 \
    sdm.debug.disable_skip_validate=1 \
    debug.sf.recomputecrop=0 \
    debug.sf.swaprect=1 \
    debug.sf.hwc.canUseABC=1 \
    sys.hwc.gpu_perf_mode=1 \
    vendor.display.enable_default_color_mode=1 \
    ro.qcom.screencolor=1 \
    persist.tuning.qdcm=1 \
    persist.sys.synaptics_dsx.qhd=false \
    ro.hwui.text_large_cache_height=2048 \
    persist.debug.wfd.enable=0 \
    persist.hwc.enable_vds=1

# FM Radio
PRODUCT_PROPERTY_OVERRIDES += \
    ro.fm.transmitter=false

# SD Card
PRODUCT_PROPERTY_OVERRIDES += \
    persist.fuse_sdcard=true

# Radio
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/vendor/lib/libril-qc-qmi-1.so \
    rild.libargs=-d /dev/smd0 \
    ril.subscription.types=NV,RUIM \
    ro.telephony.default_network=9 \
    telephony.lteOnCdmaDevice=0 \
    ro.vendor.qti.sys.fw.bservice_enable=true \
    ro.vendor.qti.sys.fw.bservice_limit=5 \
    ro.vendor.qti.sys.fw.bservice_age=5000

# Lockscreen
PRODUCT_PROPERTY_OVERRIDES += \
    ro.lockscreen.disable.default=true

# Data
PRODUCT_PROPERTY_OVERRIDES += \
    ro.use_data_netmgrd=true \
    persist.data.netmgrd.qos.enable=true \
    persist.data.mode=concurrent

# Time
PRODUCT_PROPERTY_OVERRIDES += \
    persist.timed.enable=true

# USB Mass Storage
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sys.umsdirtyratio=20

# Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.max_starting_bg=8 \
    ro.vendor.qti.sys.fw.use_trim_settings=true \
    ro.vendor.qti.sys.fw.empty_app_percent=50 \
    ro.vendor.qti.sys.fw.trim_empty_percent=100 \
    ro.vendor.qti.sys.fw.trim_cache_percent=100 \
    ro.vendor.qti.sys.fw.trim_enable_memory=1073741824 \
    ro.vendor.qti.am.reschedule_service=true \
    ro.vendor.qti.config.zram=true \
    ro.cutoff_voltage_mv=3200 \
    ro.vendor.qti.core_ctl_min_cpu=2 \
    ro.vendor.qti.core_ctl_max_cpu=4 \

# eMMC
PRODUCT_PROPERTY_OVERRIDES += \
    ro.emmc_size=8GB

# Location
PRODUCT_PROPERTY_OVERRIDES += \
    ro.location.network_number=eJwz5DQ0AAELSwsDzmpjZ3NHQzMjc103QwsLXWM3A1ddQwNHF10jAxMDC1MDAzMzI5daAA3RCtg

# Misc
PRODUCT_PROPERTY_OVERRIDES += \
    sys.qcom.feature_phone=true \
    ro.config.media_vol_default=7 \
    ro.treble.enabled=true \
    ro.expect.recovery_id=0xad1c9362c07483cb7e81c3eb05effba2e5986761000000000000000000000000