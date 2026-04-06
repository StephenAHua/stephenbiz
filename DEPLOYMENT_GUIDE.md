# stephenbiz 手动部署指南

## 第一步：创建 Supabase 项目
1. 访问 https://supabase.com
2. 点击 "Start your project"
3. 使用 GitHub 账号登录
4. 创建新项目:
   - Name: `stephenbiz-production`
   - Database Password: 设置强密码
   - Region: `East US (North Virginia)`
   - 点击 "Create new project"
5. 等待项目创建完成 (1-2分钟)
6. 获取连接信息:
   - 进入 Project Settings → API
   - 复制:
     - `Project URL`: `https://xxxxxxxxxxxx.supabase.co`
     - `anon/public` key: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

## 第二步：运行数据库迁移
1. 在 Supabase 控制台，左侧菜单点击 "SQL Editor"
2. 点击 "+ New query"
3. 复制并粘贴以下 SQL 脚本:

```sql
-- 完整脚本位于: supabase/migrations/202504062239_initial_tables.sql
-- 或从 GitHub 获取: https://raw.githubusercontent.com/StephenAHua/stephenbiz/main/supabase/migrations/202504062239_initial_tables.sql
```

4. 点击 "Run" (或按 Cmd/Ctrl + Enter)
5. 验证成功: 左侧 Table Editor 应显示所有表

## 第三步：配置 Vercel 部署
1. 访问 https://vercel.com
2. 使用 GitHub 账号登录
3. 点击 "Add New..." → "Project"
4. 导入仓库:
   - 选择 `StephenAHua/stephenbiz`
   - Framework Preset: `Vite`
   - Root Directory: `frontend`
   - 点击 "Deploy"
5. 配置环境变量:
   - 项目部署后，进入 Settings → Environment Variables
   - 添加:
     - `VITE_SUPABASE_URL`: (您的 Supabase URL)
     - `VITE_SUPABASE_ANON_KEY`: (您的 Supabase anon key)
   - 点击 "Save"
6. 重新部署:
   - 进入 Deployments
   - 点击最新部署旁边的 "Redeploy"

## 第四步：验证部署
1. 访问您的网站: `https://stephenbiz.vercel.app`
2. 测试功能:
   - 浏览产品列表
   - 点击 "Request Quote" 按钮
   - 填写测试询盘表单
   - 提交表单
3. 检查数据库:
   - 回到 Supabase 控制台
   - 进入 Table Editor → quotes
   - 确认您的测试询盘已保存

## 故障排除
1. **前端无法连接**:
   - 检查环境变量是否正确
   - 确认 Supabase 项目 URL 可访问

2. **数据库错误**:
   - 重新运行 SQL 迁移脚本
   - 检查表名是否冲突

3. **部署失败**:
   - 查看 Vercel 构建日志
   - 检查依赖安装问题

## 成功标志
- ✅ 网站加载时间 < 3秒
- ✅ 产品列表显示正常
- ✅ 询盘表单可提交
- ✅ 数据正确存储到数据库
- ✅ 移动端响应式正常

## 支持
如遇问题，请提供:
1. 错误截图
2. 控制台错误信息
3. 您执行到的步骤

预计部署时间: 15-20分钟
