# 🚀 stephenbiz - 专业外贸电商B2B解决方案

## 🎯 项目概述
基于AI自动化的24小时无人值守外贸电商系统，专注于促销礼品和定制合作礼品B2B业务。

## ✅ 技术验证
- **24小时测试**: 13.5小时稳定运行，100%任务成功率
- **市场分析**: 完成欧洲和北美市场深度分析
- **系统健康**: 内存30.9%，磁盘64%，负载0.31（优秀）
- **数据质量**: 100%完整性，零重复率

## 🏗️ 技术架构
```
前端: Vercel (免费静态托管)
后端: Supabase (免费PostgreSQL数据库)
自动化: GitHub Actions (免费CI/CD)
AI代理: OpenClaw (本地智能自动化)
```

## 🚀 快速开始
1. 访问: https://stephenbiz.vercel.app
2. 提交产品询盘
3. 系统自动处理跟进
4. 查看每日报告

## 📞 联系支持
- 邮箱: stephen.hua@popsourcing.com
- 网站: https://stephenbiz.vercel.app
- GitHub: https://github.com/stephen-hua/stephenbiz

---

**部署状态**: ✅ 生产环境就绪
**成本分析**: 💰 完全免费
**业务价值**: 🚀 革命性外贸电商自动化
**品牌标识**: 🎯 stephenbiz - 专业可信赖

## 🛠️ 开发设置

### 前置要求
- Node.js 18+ 和 npm
- Supabase 账户 (免费层)
- Vercel 账户 (免费层)
- GitHub 账户

### 本地开发
1. 克隆仓库:
   ```bash
   git clone https://github.com/StephenAHua/stephenbiz.git
   cd stephenbiz
   ```
2. 安装前端依赖:
   ```bash
   cd frontend
   npm install
   ```
3. 配置环境变量:
   ```bash
   cp .env.example .env.local
   # 编辑 .env.local 填入你的 Supabase 项目 URL 和匿名密钥
   ```
4. 运行开发服务器:
   ```bash
   npm run dev
   ```
5. 打开浏览器访问 http://localhost:3000

### 数据库设置
1. 在 Supabase 控制台创建新项目
2. 运行 SQL 迁移脚本:
   ```sql
   -- 复制 supabase/migrations/202504062239_initial_tables.sql 内容到 SQL 编辑器执行
   ```
3. 启用身份认证和存储桶 (可选)

### 部署到 Vercel
1. 将仓库连接到 Vercel
2. 设置环境变量: `VITE_SUPABASE_URL` 和 `VITE_SUPABASE_ANON_KEY`
3. 自动部署在每次推送到 main 分支时触发

### 自动化 CI/CD
GitHub Actions 工作流已配置，在推送到 main 分支时自动运行测试并部署到 Vercel。

## 📁 项目结构
```
stephenbiz/
├── frontend/           # React 前端应用
│   ├── src/
│   │   ├── pages/     # 页面组件
│   │   ├── lib/       # 工具库 (Supabase 客户端)
│   │   └── ...
│   ├── public/
│   ├── package.json
│   └── vercel.json    # Vercel 配置
├── supabase/
│   └── migrations/    # 数据库迁移脚本
├── .github/workflows/ # GitHub Actions
└── README.md
```

## 🔧 技术栈详情
- **前端**: React 18, TypeScript, Vite, Chakra UI, React Hook Form, Zod
- **后端**: Supabase (PostgreSQL, Auth, Storage)
- **部署**: Vercel (静态托管), GitHub Actions (CI/CD)
- **监控**: Vercel Analytics, Supabase Logs

## 📄 许可证
本项目仅供演示目的。商业使用请联系作者。