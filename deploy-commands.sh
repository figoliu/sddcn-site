#!/bin/bash

echo "在服务器 8.140.22.103 上开始部署SDD中文网站..."

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

# 安装unzip工具（如果尚未安装）
if ! command -v unzip &> /dev/null; then
    echo "安装unzip工具..."
    apt install -y unzip
fi

# 创建网站目录
echo "创建网站目录..."
mkdir -p /var/www/sddchinese

# 解压网站文件
echo "解压网站文件..."
unzip -o /tmp/sddchinese-deploy.zip -d /var/www/sddchinese

# 设置文件权限
echo "设置文件权限..."
chown -R www-data:www-data /var/www/sddchinese
chmod -R 755 /var/www/sddchinese

# 更新Nginx配置
echo "配置Nginx..."

# 创建Nginx配置文件
cat > /etc/nginx/sites-available/sddchinese << 'EOL'
server {
    listen 80;
    server_name 8.140.22.103;

    # 根目录指向网站文件所在位置
    root /var/www/sddchinese;
    index index.html index.htm;

    # 网站根路径配置
    location / {
        try_files $uri $uri/ =404;
    }

    # 静态资源缓存配置
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # gzip压缩配置
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;

    # 安全头配置
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # 日志配置
    access_log /var/log/nginx/sddchinese.access.log;
    error_log /var/log/nginx/sddchinese.error.log;
}
EOL

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

echo "部署完成！网站可以通过 http://8.140.22.103 直接访问"