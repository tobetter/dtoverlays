### Device Tree Overlays for ODROID

This repository contains the device tree overlay files for ODROID SBC models, it is intended to build and install the device tree overlay files and help ODROID users to build custom device tree overlay file easily.

## Building and installing device tree overlay files
This command will install all device tree overlay files to **/boot/dtbs/...** where the device tree files of current running Linux kernel version is installed.
> $ git clone https://github.com/tobetter/dtoverlays.git
$ cd dtoverlays
$ make
$ sudo make install

If you like to install the device tree overlay files for specific kernel version than current kernel version,
> $ sudo make KERNELRELEASE=6.1.0-odroid-arm64

In order to build and install properly, you need to install Linux header file packages.
> $ sudo make install linux-headers-6.1.0-odroid-arm64

## Adding new device tree overlay file
- Firstly, you need to add new device tree file under 'overlays/**soc**/**model**/**yourfile**.dts' where **soc** is SoC vendor and **model** is Hardkernel's ODROID SBC model.
- Secondly, add the device tree file to **dtbo-y** in 'overlays/**soc**/**model**/Makefile', the Makefile can be created if it is missing.
>     dtbo-y += device_tree_1.dtbo \
>               device_tree_2.dtbo
- Lastly, 'overlays/**soc**' or 'overlays/**soc**/**model**' is missing, you also need to create Makefile and add the directory name to "subdirs-y".

in 'overlays/Makefile':
>     dtbo-y += rockchip
>     dtbo-y += amlogic
'overlays/rockchip/Makefile':
>     dtbo-y += odroidm1
in 'overlays/amlogic/Makefile':
>     dtbo-y += odroidn2
