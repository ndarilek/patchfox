@echo off
cd .\dist
call web-ext build --overwrite-dest
move .\web-ext-artifacts ..\
cd ..
