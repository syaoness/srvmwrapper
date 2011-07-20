#!/bin/bash

echo "Removing old data"
rm -rf ScummVMwrapper.app

echo "Cloning app bundle"
ditto ../wrapper/ScummVMwrapper.app ./ScummVMwrapper.app

echo "Adding scummvm executable"
cp /Applications/ScummVM.app/Contents/MacOS/scummvm ScummVMwrapper.app/Contents/MacOS/

echo "Adding config tool"
ditto ../configtool/ScummVMwrapperConfig/build/Release/ScummVMwrapperConfig.app ScummVMwrapper.app/ScummVMwrapperConfig.app

echo "Removing extra files"
find ./ -iname .empty -type f -exec rm -f '{}' \;

