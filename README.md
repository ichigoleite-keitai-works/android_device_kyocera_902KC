# Device Tree for Kyocera Digno Keitai 3 (NP902KC)

## Device Specifications

| Feature         | Specification                   |
| --------------- | ------------------------------- |
| CPU             | 1.1GHz quad-core                |
| Chipset         | Qualcomm Snapdragon 210 MSM8909 |
| GPU             | Adreno 304                      |
| Main Display    | 3.4” TFT FWVGA 854×480          |
| Sub Display     | 240x320                         |
| Android Version | Android 8.1 (Go edition)        |
| Languages       | Japanese, English               |

More details on the [Garaho Wiki](https://garahowiki.com/phones:kyocera_digno_keitai_3:start).

## Prebuilt zImage-dtb

The `zImage-dtb` is a single blob: the compressed kernel (`zImage`) with the board's compiled device tree (`msm8909-NATSUME03-rev00.dtb`) appended to the end.

This blob is compiled from Kyocera's released GPL source (Linux 3.18.71, `msm8909-perf_defconfig`). The source didn't compile as provided due to missing uapi headers. These were fetched from upstream Linux 3.18.71 and copied in.

Latest build [1.040AN.0099.a kernel source](http://android-dev.kyocera.co.jp/source/download.php?id=kernel_902KC_1.040AN.0099.a.tar.gz) used.

Retrieved from Kyocera's [Open Source Software Download](http://android-dev.kyocera.co.jp/source/source.html) page.

## Checks

TODO: Run checks.

Functional list to test the device tree. Taken from the [TWRP FAQ](https://twrp.me/faq/OfficialMaintainer.html).

Blocking checks

- [ ] Correct screen/recovery size
- [ ] Working Touch, screen
- [ ] Backup to internal/microSD
- [ ] Restore from internal/microSD
- [ ] reboot to system
- [ ] ADB

Medium checks

- [ ] update.zip sideload
- [ ] UI colors (red/blue inversions)
- [ ] Screen goes off and on
- [ ] F2FS/EXT4 Support, exFAT/NTFS where supported
- [ ] all important partitions listed in mount/backup lists
- [ ] backup/restore to/from external (USB-OTG) storage
- [ ] backup/restore to/from adb
- [ ] decrypt /data
- [ ] Correct date

Minor checks

- [ ] MTP export
- [ ] reboot to bootloader
- [ ] reboot to recovery
- [ ] poweroff
- [ ] battery level
- [ ] temperature
- [ ] encrypted backups
- [ ] input devices via USB (USB-OTG) - keyboard, mouse and disks
- [ ] USB mass storage export
- [ ] set brightness
- [ ] vibrate
- [ ] screenshot
- [ ] partition SD card

## Build

### Clone and Sync the TWRP Manifest

```bash
repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git -b twrp-9.0
repo sync -j"$(nproc --all)"
```

### Clone the Device Tree

```bash
git clone https://github.com/j4ln/android_device_kyocera_902KC.git -b android-9.0 device/kyocera/902KC
```

### Build

```bash
export ALLOW_MISSING_DEPENDENCIES=true
. build/envsetup.sh
lunch omni_902KC-eng
mka recoveryimage
```

## Install

```bash
fastboot boot out/target/product/902KC/recovery.img
```
