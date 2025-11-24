@echo off
echo 正在打包SDD中文网站文件...

REM 创建临时目录
mkdir temp_deploy 2>nul

REM 复制网站文件到临时目录
copy "*.html" temp_deploy\ >nul
copy "*.css" temp_deploy\ >nul
copy "*.js" temp_deploy\ >nul
copy "sddchinese.nginx.conf" temp_deploy\ >nul

REM 创建zip包
powershell -command "Compress-Archive -Path temp_deploy\* -DestinationPath sddchinese-website.zip -Force"

REM 清理临时目录
rmdir /s /q temp_deploy

echo 网站文件已打包为 sddchinese-website.zip
echo 您可以将此文件传输到Ubuntu服务器进行部署
pause