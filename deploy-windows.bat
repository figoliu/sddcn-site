@echo off
setlocal

echo ================================
echo SDD中文网站部署脚本
echo 部署到服务器: 8.140.22.103
echo ================================

REM 设置变量
set SERVER_IP=8.140.22.103
set SERVER_USER=root
set TEMP_DIR=temp_deploy
set ZIP_FILE=sddchinese-deploy.zip

echo.
echo 1. 创建网站打包文件...

REM 创建临时目录
if exist %TEMP_DIR% rmdir /s /q %TEMP_DIR%
mkdir %TEMP_DIR%

REM 复制网站文件到临时目录
copy "*.html" %TEMP_DIR%\ >nul
copy "*.css" %TEMP_DIR%\ >nul
copy "*.js" %TEMP_DIR%\ >nul
copy "sddchinese.nginx.conf" %TEMP_DIR%\ >nul

REM 创建zip包
echo    正在创建压缩包...
powershell -command "Compress-Archive -Path %TEMP_DIR%\* -DestinationPath %ZIP_FILE% -Force"

REM 清理临时目录
rmdir /s /q %TEMP_DIR%

echo    网站文件已打包为 %ZIP_FILE%

echo.
echo 2. 传输文件到服务器 %SERVER_IP% ...
scp %ZIP_FILE% %SERVER_USER%@%SERVER_IP%:/tmp/

echo.
echo 3. 在服务器上执行部署命令...
ssh %SERVER_USER%@%SERVER_IP% "bash -s" < deploy-commands.sh

echo.
echo 4. 清理本地打包文件...
del %ZIP_FILE%

echo.
echo 部署完成！
echo 网站应该可以通过 http://%SERVER_IP% 直接访问
echo.
pause