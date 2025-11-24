#!/bin/bash

# SDD中文网站部署脚本
# 部署到指定服务器 8.140.22.103

# 服务器信息
SERVER_IP="8.140.22.103"             # 指定的服务器IP
SERVER_USER="root"                   # 使用root用户（请根据实际情况修改）
SERVER_PATH="/var/www/sddchinese"    # 服务器上的网站路径

# 域名信息（如果需要配置域名）
DOMAIN="sddchinese.example.com"      # 请替换为您的实际域名

echo "开始部署SDD中文网站到服务器 $SERVER_IP ..."

# 1. 创建打包文件
echo "1. 创建网站打包文件..."
cd /d "d:\code\sddchinese"

# 创建临时目录并复制文件
mkdir temp_deploy 2>nul
copy "*.html" temp_deploy\ >nul
copy "*.css" temp_deploy\ >nul
copy "*.js" temp_deploy\ >nul
copy "sddchinese.nginx.conf" temp_deploy\ >nul

# 使用PowerShell创建压缩包
powershell -command "Compress-Archive -Path temp_deploy\* -DestinationPath sddchinese-deploy.zip -Force"

# 清理临时目录
rmdir /s /q temp_deploy

echo "网站文件已打包为 sddchinese-deploy.zip"

# 2. 传输文件到服务器
echo "2. 传输文件到服务器 $SERVER_IP ..."
scp sddchinese-deploy.zip $SERVER_USER@$SERVER_IP:/tmp/

# 3. 在服务器上执行部署命令
echo "3. 在服务器上执行部署命令..."
ssh $SERVER_USER@$SERVER_IP << 'EOF'
    echo "在服务器 $SERVER_IP 上开始部署..."
    
    # 更新系统包列表
    echo "更新系统包..."
    apt update
    
    # 安装Nginx（如果尚未安装）
    if ! command -v nginx &> /dev/null; then
        echo "安装Nginx..."
        apt install -y nginx
    else
        echo "Nginx已安装"
    fi
    
    # 创建网站目录
    echo "创建网站目录..."
    mkdir -p /var/www/sddchinese
    
    # 安装unzip工具（如果尚未安装）
    if ! command -v unzip &> /dev/null; then
        echo "安装unzip工具..."
        apt install -y unzip
    fi
    
    # 解压网站文件
    echo "解压网站文件..."
    unzip -o /tmp/sddchinese-deploy.zip -d /var/www/sddchinese
    
    # 设置文件权限
    echo "设置文件权限..."
    chown -R www-data:www-data /var/www/sddchinese
    chmod -R 755 /var/www/sddchinese
    
    # 更新Nginx配置文件中的域名
    echo "更新Nginx配置..."
    sed -i "s/your-domain.com/$DOMAIN/g" /var/www/sddchinese/sddchinese.nginx.conf
    sed -i "s/www.your-domain.com/www.$DOMAIN/g" /var/www/sddchinese/sddchinese.nginx.conf
    
    # 复制Nginx配置文件到正确位置
    cp /var/www/sddchinese/sddchinese.nginx.conf /etc/nginx/sites-available/sddchinese
    
    # 创建软链接启用站点
    ln -sf /etc/nginx/sites-available/sddchinese /etc/nginx/sites-enabled/
    
    # 删除默认站点配置（如果存在）
    rm -f /etc/nginx/sites-enabled/default
    
    # 测试Nginx配置
    echo "测试Nginx配置..."
    nginx -t
    
    # 重启Nginx
    echo "重启Nginx..."
    systemctl restart nginx
    
    # 检查Nginx状态
    if systemctl is-active --quiet nginx; then
        echo "Nginx运行正常"
    else
        echo "Nginx启动失败，请检查配置"
        exit 1
    fi
    
    # 启用Nginx开机自启
    systemctl enable nginx
    
    # 清理临时文件
    rm /tmp/sddchinese-deploy.zip
    
    echo "部署完成！网站应该可以通过 http://8.140.22.103 访问"
EOF

# 4. 清理本地打包文件
echo "4. 清理本地打包文件..."
del sddchinese-deploy.zip

echo "部署脚本执行完成！"
echo "网站应该可以通过 http://8.140.22.103 直接访问"
echo "如果需要使用域名访问，请将域名解析指向 8.140.22.103"