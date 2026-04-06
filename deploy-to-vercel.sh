#!/bin/bash
# 直接部署到Vercel的脚本

echo "🚀 直接部署到Vercel"
echo "======================"

# 创建临时目录
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# 克隆仓库（使用公开URL，无需认证）
git clone https://github.com/StephenAHua/stephenbiz.git
cd stephenbiz

# 创建vercel.json配置
cat > vercel.json << 'VERCEL'
{
  "version": 2,
  "name": "stephenbiz",
  "builds": [
    {
      "src": "frontend/index.html",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/frontend/index.html"
    }
  ]
}
VERCEL

echo "✅ 配置完成"
echo "🌐 手动部署步骤:"
echo "1. 访问: https://vercel.com/new"
echo "2. 点击 'Import Git Repository'"
echo "3. 选择: StephenAHua/stephenbiz"
echo "4. 项目名称: stephenbiz"
echo "5. 点击: Deploy"
echo ""
echo "📁 项目文件已准备在: $TEMP_DIR"
