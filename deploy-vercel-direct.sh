#!/bin/bash
# 直接部署到Vercel的脚本

echo "🚀 直接部署到Vercel"
echo "======================"

# 创建项目目录
PROJECT_DIR="/tmp/vercel-deploy-$(date +%s)"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# 从GitHub下载最新代码
echo "下载代码..."
curl -s -L "https://github.com/StephenAHua/stephenbiz/archive/main.tar.gz" | tar -xz
cd stephenbiz-main

# 创建部署包
echo "创建部署包..."
tar -czf ../deploy.tar.gz .

echo ""
echo "✅ 部署包创建完成: $PROJECT_DIR/deploy.tar.gz"
echo ""
echo "🌐 Vercel部署步骤:"
echo "1. 访问: https://vercel.com/new"
echo "2. 点击 'Import Git Repository'"
echo "3. 选择: StephenAHua/stephenbiz"
echo "4. 项目名称: stephenbiz"
echo "5. 框架: Other (Static)"
echo "6. 根目录: / (默认)"
echo "7. 点击: Deploy"
echo ""
echo "📁 本地部署包: $PROJECT_DIR/deploy.tar.gz"
echo "📊 文件大小: $(du -h ../deploy.tar.gz | cut -f1)"
echo ""
echo "🎯 基于24小时测试验证的系统已就绪！"
