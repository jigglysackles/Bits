@echo on
setlocal

for /f "tokens=*" %%a in (C:\Temp\ListKB\OrderedList.txt) do (type nul>"%%a.txt")