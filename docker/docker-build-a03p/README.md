> tesla toolchain requires license so we did not containerize it
> For more details and information, especially steps after build completes, please look at the README in each `poc` folder

## build docker image

Copy this file to `docker-build-a03p/`:
```
\\10.6.64.30\dhtsys-home\android\Freescale\Yocto\fsl-imx-fb-glibc-x86_64-meta-toolchain-cortexa9hf-vfp-neon-toolchain-3.14.52-1.1.0.sh
```

```sh
cd docker-build-a03p
docker  build -t  build-a03p .
```

## usage

Clone A03p repo and export its path as `${SOURCE_FOLDER}`.

```sh
# folder for build output
export TMPDIR=`mktemp -d`
docker run -it \
  -v ${SOURCE_FOLDER}:/input \
  -v ${TMPDIR}:/output \
  --name build-a03p \
  build-a03p bash
# you are logged in the container and can call `Runme.sh` in `/input` to build the projects
# build `phandle` before `usbm`

# TODO:
# build script should copy dist artifacts to `/output`
# release script can copy dist artifacts from ${TMPDIR}
rm -rf ${TMPDIR} # remove after use
```

## `RunMe.sh` usage

> RunMe of usbm or phandle?

```sh
./RunMe.sh build_uboot               clean, reconfigure and build uboot
./RunMe.sh config_kernel_EVK         clean kernel and reconfigure kernel for EVK board
./RunMe.sh config_kernel_POC         clean kernel and reconfigure kernel for POC board
./RunMe.sh menuconfig_kernel         menuconfig kernel
./RunMe.sh build_kernel_EVK          build kernel for EVK board
./RunMe.sh build_kernel_POC          build kernel for POC board
./RunMe.sh clean_apps                clean all apps
./RunMe.sh build_apps                build all apps
./RunMe.sh repack_rootfs             patch the apps & scripts to rootfs and repack a new tarball

# Build Uboot
cd /input/aircraft-a03p-usbm-poc
./RunMe.sh build_uboot

# Config_kernel_EVK && POC
./RunMe.sh config_kernel_EVK
./RunMe.sh config_kernel_POC
./RunMe.sh menuconfig_kernel

#  build kernel for EVK board && POC board
./RunMe.sh build_kernel_EVK
./RunMe.sh build_kernel_POC

# Clean && Build Apps
./RunMe.sh clean_apps
./RunMe.sh build_apps

# Patch the apps
./RunMe.sh repack_rootfs
```