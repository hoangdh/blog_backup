@echo off
title Convert GHO file to VMDK file - Script by HoangDH - MediTech JSC,.
echo Images in current folder:
dir *.gho /-S
set /p id=Enter name ghost file:
ghost32 -clone,mode=restore,src=%id%,dst=%id%.vmdk -batch -sure
REM -pwd=password: Neu file co pass
exit
