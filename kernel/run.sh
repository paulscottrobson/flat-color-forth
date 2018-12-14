rm boot.img
sh build.sh
python ../scripts/importcode.py test.fcf
wine ../bin/CSpect.exe -zxnext -brk -esc -w3 ../files/bootloader.sna
