#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake      \
    libdecor   \
    libvpx     \
    sdl2       \
    sdl2_image \
    sdl2_mixer

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#export CXXFLAGS="${CXXFLAGS:-} -Wno-error=format-security"
#make-aur-package akhenaten-git

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
echo "Making nightly build of Akhenaten..."
echo "---------------------------------------------------------------"
REPO="https://github.com/dalerank/Akhenaten"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./Akhenaten
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./Akhenaten
cp -r data ../AppDir/bin
cp -r mods ../AppDir/bin
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
mv -v akhenaten ../../AppDir/bin
