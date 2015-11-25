#!/bin/sh
#
# The folder "toolchains" should contain several individually installable toolchains.
# This script merges the toolchains into a single installable file.
#
# Ideally the script would do:
#   build toolchain x86 -> copy to ./toolchains
#   build toolchain ARM -> copy to ./toolchains
#   build toolchain ARC -> copy to ./toolchains
#   build host tools    -> copy to ./toolchains
#   merge toolchains (using makeself)
#
# At present copying is done manually.
#
# SDK should follow a vM.m versioning scheme
#
# Major versions for big interface/usage changes
# Minor versions for additions of interfaces, transparent changes
#
# Default installation directory should be /opt/zephyr-sdk/
#
# Naming scheme: 1st drop
#    zephyr-sdk-0.1-i686-setup.run
#
# After that (with additional content/fixes)
#    zephyr-sdk-0.2-i686-setup.run
#
# ….
#
# Once the toolchain/SDK is ”feature complete”
#
#    zephyr-sdk-1.0-i686-setup.run
#
# ….
#

# Edit as needed:
version_major=0
version_minor=7

if [ "$1" != "" ] ; then
    product_name=$1
  else
    product_name=zephyr-sdk
fi

# Create ./setup.sh

sdk_version=$version_major.$version_minor
setup=toolchains/setup.sh
default_dir=/opt/${product_name}/
toolchain_name=${product_name}-${sdk_version}-i686-setup.run

# Identify files present in toolchains folder

function parse_toolchain_name()
{
    local varname=$1
    local arch=$2
    local num
    local filename

    num=$(ls toolchains | grep $arch | wc -l)
    if [ "$num" -gt "1" ]; then
        echo "Error: Multiple toolchains for \"$arch\" "
        exit 1
    fi

    if [ "$num" -eq "0" ]; then
        echo "Warning: Missing toolchain for \"$arch\" "
    fi

    filename=$(ls toolchains | grep $arch)
    eval "$varname=\$filename"
}

parse_toolchain_name file_gcc_arm arm
parse_toolchain_name file_gcc_arc arc
parse_toolchain_name file_gcc_x86 i586
parse_toolchain_name file_gcc_iamcu iamcu
parse_toolchain_name file_gcc_mips mips32r2
parse_toolchain_name file_hosttools hosttools

# Host tools are non-optional
if  [ -z "$file_hosttools" ]; then
  echo "Error: Missing host tools!"
  exit 1
fi

echo '#!/bin/bash' > $setup
echo "DEFAULT_INSTALL_DIR=$default_dir" >> $setup
echo "TOOLCHAIN_NAME=$toolchain_name" >> $setup
cat template_dir >>$setup

if [ -n "$file_gcc_x86" ]; then
  echo "./$file_gcc_x86 -R -y -d \$target_sdk_dir > /dev/null &" >> $setup
  echo "spinner \$! \"Installing x86 tools...\"" >> $setup
  echo "[ \$? -ne 0 ] && echo \"Error(s) encountered during installation.\" && exit 1" >>$setup
  echo "echo \"\"" >>$setup
fi

if [ -n "$file_gcc_arm" ]; then
  echo "./$file_gcc_arm -R -y -d \$target_sdk_dir > /dev/null &" >> $setup
  echo "spinner \$! \"Installing arm tools...\"" >> $setup
  echo "[ \$? -ne 0 ] && echo \"Error(s) encountered during installation.\" && exit 1" >>$setup
  echo "echo \"\"" >>$setup
fi

if [ -n "$file_gcc_arc" ]; then
  echo "./$file_gcc_arc -R -y -d \$target_sdk_dir > /dev/null &" >> $setup
  echo "spinner \$!  \"Installing arc tools...\"" >> $setup
  echo "[ \$? -ne 0 ] && echo \"Error(s) encountered during installation.\" && exit 1" >>$setup
  echo "echo \"\"" >>$setup
fi

if [ -n "$file_gcc_iamcu" ]; then
  echo "./$file_gcc_iamcu -R -y -d \$target_sdk_dir > /dev/null &" >> $setup
  echo "spinner \$!  \"Installing iamcu tools...\"" >> $setup
  echo "[ \$? -ne 0 ] && echo \"Error(s) encountered during installation.\" && exit 1" >>$setup
  echo "echo \"\"" >>$setup
fi

if [ -n "$file_gcc_mips" ]; then
  echo "./$file_gcc_mips -R -y -d \$target_sdk_dir > /dev/null &" >> $setup
  echo "spinner \$!  \"Installing mips tools...\"" >> $setup
  echo "[ \$? -ne 0 ] && echo \"Error(s) encountered during installation.\" && exit 1" >>$setup
  echo "echo \"\"" >>$setup
fi

if [ -n "$file_hosttools" ]; then
  echo "./$file_hosttools -y -d \$target_sdk_dir > /dev/null &" >> $setup
  echo "spinner \$! \"Installing additional host tools...\"" >> $setup
  echo "[ \$? -ne 0 ] && echo \"Error(s) encountered during installation.\" && exit 1" >>$setup
  echo "echo \"\"" >>$setup
fi


echo "" >>$setup
echo "do_cleanup"  >>$setup
echo "" >>$setup

echo "echo \"Success installing SDK. SDK is ready to be used.\"" >>$setup
chmod 777 $setup

makeself toolchains/ $toolchain_name  "SDK for Zephyr" ./setup.sh
