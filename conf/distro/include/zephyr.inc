SANITY_TESTED_DISTROS = " \
            Ubuntu-14.04 \n \
            Ubuntu-15.04 \n \
            "

DISTRO = "zephyr"
DISTRO_CODENAME = "zephyr"
DISTRO_NAME = "Zephyr Yocto Toolchain"
MAINTAINER = "Intel Yocto team"

SSTATE_DIR ?= "${TOPDIR}/../zephyr-cache/sstate-cache"
CACHE_forcevariable = "${TOPDIR}/../zephyr-cache/cache"
PERSISTENT_DIR = "${TOPDIR}/../zephyr-cache/persistent"
