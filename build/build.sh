#!/bin/bash

rm -rf ScummVMwrapper.app
cp -r ../wrapper/ScummVMwrapper.app ./
cp /Applications/ScummVM.app/Contents/MacOS/scummvm ScummVMwrapper.app/Contents/MacOS/
cp -r ../configtool/ScummVMwrapperConfig/build/Release/ScummVMwrapperConfig.app ScummVMwrapper.app/
