#!/bin/bash

rm -rf ScummVMwrapper.app
svn export ../wrapper/ScummVMwrapper.app ./ScummVMwrapper.app
cp /Applications/ScummVM.app/Contents/MacOS/scummvm ScummVMwrapper.app/Contents/MacOS/
cp -r ../configtool/ScummVMwrapperConfig/build/Release/ScummVMwrapperConfig.app ScummVMwrapper.app/
