#!/bin/bash

# SDD中文网站部署脚本
# 请根据您的实际情况修改以下变量

# 服务器信息
SERVER_IP="your-server-ip"           # 请替换为您的服务器IP
SERVER_USER="your-username"          # 请替换为您的服务器用户名
SERVER_PATH="/var/www/sddchinese"    # 服务器上的网站路径

# 域名信息
DOMAIN="your-domain.com"             # 请替换为您的域名

echo "开始部署SDD中文网站到Ubuntu服务器..."

# 1. 创建打包文件
echo "1. 创建网站打包文件..."
cd /d "d:\code\sddchinese"
tar -czf sddchinese.tar.gz *.html *.css *.js

# 2. 传输文件到服务器
echo "2. 传输文件到服务器..."
scp sddchinese.tar.gz $SERVER_USER@$SERVER_IP:/tmp/

# 3. 在服务器上执行部署命令
echo "3. 在服务器上执行部署命令..."
ssh $SERVER_USER@$SERVER_IP << 'EOF'
    echo "在服务器上开始部署..."
    
    # 安装Nginx（如果尚未安装）
    if ! command -v nginx &> /dev/null; then
        echo "安装Nginx..."
        sudo apt update
        sudo apt install -y nginx
    else
        echo "Nginx已安装"
    fi
    
    # 创建网站目录
    echo "创建网站目录..."
    sudo mkdir -p $SERVER_PATH
    
    # 解压网站文件
    echo "解压网站文件..."
    sudo tar -xzf /tmp/sddchinese.tar.gz -C $SERVER_PATH
    
    # 设置文件权限
    echo "设置文件权限..."
    sudo chown -R www-data:www-data $SERVER_PATH
    sudo chmod -R 755 $SERVER_PATH
    
    # 复制Nginx配置文件
    echo "配置Nginx..."
    sudo cp $SERVER_PATH/sddchinese.nginx.conf /etc/nginx/sites-available/sddchinese
    
    # 替换域名配置
    sudo sed -i "s/your-domain.com/$DOMAIN/g" /etc/nginx/sites-available/sddchinese
    
    # 创建软链接启用站点
    sudo ln -sf /etc/nginx/sites-available/sddchinese /etc/nginx/sites-enabled/
    
    # 测试Nginx配置
    echo "测试Nginx配置..."
    sudo nginx -t
    
    # 重启Nginx
    echo "重启Nginx..."
    sudo systemctl restart nginx
    
    # 检查Nginx状态
    if systemctl is-active --quiet nginx; then
        echo "Nginx运行正常"
    else
        echo "Nginx启动失败，请检查配置"
        exit 1
    fi
    
    # 清理临时文件
    rm /tmp/sddchinese.tar.gz
    
    echo "部署完成！"
EOF

# 4. 清理本地打包文件
echo "4. 清理本地打包文件..."
rm sddchinese.tar.gz

echo "部署脚本执行完成！"
echo "请确保您已将脚本中的服务器IP、用户名和域名替换为实际值。"
echo "您可能还需要配置DNS解析指向您的服务器IP。"