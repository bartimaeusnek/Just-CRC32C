#!/bin/bash
cd $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
if [ ! -f "$PWD/fasm/FASM" ]; then
  #needed for win includes
	wget -O fasmw17331.zip https://flatassembler.net/fasmw17331.zip
  unzip -q -o fasmw17331.zip -d ./fasm
	rm fasmw17331.zip
	#actual fasm for linux
  wget -O fasm-1.73.31.tgz https://flatassembler.net/fasm-1.73.31.tgz
  tar -xf fasm-1.73.31.tgz
  rm fasm-1.73.31.tgz
fi

export INCLUDE="$PWD/fasm/INCLUDE"
./fasm/fasm ./JustCRC32C_Native_x64.ASM
./fasm/fasm ./JustCRC32C_Native_x86.ASM
cp ./JustCRC32C_Native_x64.dll ../JustCRC32C/JustCRC32C_Native_x64.dll
cp ./JustCRC32C_Native_x86.dll ../JustCRC32C/JustCRC32C_Native_x86.dll
