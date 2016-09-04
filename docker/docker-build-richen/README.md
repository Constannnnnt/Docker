> For more details and information, especially the steps after build completed, please look at the `README` in `richen-imx6-platform`

## clone the repo

Clone the repo under the same directory `docker-build-richen`

```sh
git clone git@10.6.64.28: richen-imx6-platform.git
```

## build docker image

Copy the `arm gcc compiler` file to `docker-build-richen`:

```
\\10.6.64.30\dhtsys-home\richen\compiler\fsl-image-gui-cortexa9hf-vfp-neon-toolchain-3.14.52-1.1.0.sh
```

```sh
cd docker-build-richen
docker build -t build-richen .
```

### usage

Clone richen repo and export its path as `${SOURCE_FOLDER}`.

```sh
# folder for build output
export TMPDIR=`mktemp -d`
docker run -it \
  -v ${SOURCE_FOLDER}:/input-richen \
  -v ${TMPDIR}:/output-richen \
  --name build-richen \
  build-richen bash
# you are logged in the container and can call `Runme.sh` in `/input-richen` to build the projects

# TODO:
# build script should copy dist artifacts to `/output-richen`
# release script can copy dist artifacts from ${TMPDIR}
rm -rf ${TMPDIR} # remove after use
```

## `RunMe.sh` usage

```sh
./RunMe.sh build_uboot               clean, reconfigure and build uboot
./RunMe.sh build_uboot_richen        clean, reconfigure and build uboot for richen board
./RunMe.sh config_kernel             clean kernel and reconfigure kernel
./RunMe.sh config_kernel_richen      clean kernel and reconfigure kernel for richen board
./RunMe.sh build_kernel              build kernel
./RunMe.sh build_kernel_richen       build kernel for richen board
./RunMe.sh menuconfig_kernel         menuconfig kernel
```