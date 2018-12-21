@echo off
del /Q boot.img
call build.bat
python ..\scripts\importcode.py system.fcf console.fcf dump.fcf test.fcf
..\bin\CSpect.exe -zxnext -brk -exit -esc -w3 ..\files\bootloader.sna