@echo off
pushd ..\kernel
call build.bat
popd
copy ..\files\bootloader.sna .
copy ..\files\boot.img .
python ..\scripts\makesprites.py
python ..\scripts\mzc.py spritedata.mz test.mz
if errorlevel 1 goto exit
..\bin\CSpect.exe -zxnext -cur -brk -exit -w3 bootloader.sna 
:exit

