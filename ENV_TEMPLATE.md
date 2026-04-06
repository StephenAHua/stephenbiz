# 环境变量配置

## 前端环境变量 (.env.local)
```env
VITE_SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## Vercel 环境变量
在 Vercel 项目设置中添加:
- `VITE_SUPABASE_URL`: 您的 Supabase URL
- `VITE_SUPABASE_ANON_KEY`: 您的 Supabase anon key

## 获取 Supabase 凭据
1. 登录 Supabase 控制台
2. 进入 Project Settings → API
3. 复制:
   - Project URL
   - anon/public key

## 验证配置
1. 本地测试:
```bash
cd frontend
cp .env.example .env.local
# 编辑 .env.local 填入真实凭据
npm run dev
```

2. 生产验证:
- 访问您的 Vercel 域名
- 检查控制台无错误
- 测试表单提交功能
