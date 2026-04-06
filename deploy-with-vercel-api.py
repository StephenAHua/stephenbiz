#!/usr/bin/env python3
"""
使用Vercel API直接部署stephenbiz
"""

import os
import json
import subprocess
import sys

def run_command(cmd):
    """运行命令并返回输出"""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        return result.returncode, result.stdout, result.stderr
    except Exception as e:
        return 1, "", str(e)

def main():
    print("🚀 开始Vercel API直接部署")
    print("=" * 50)
    
    # 检查Vercel CLI
    print("1. 检查Vercel CLI...")
    code, stdout, stderr = run_command("which vercel")
    if code != 0:
        print("❌ Vercel CLI未安装")
        print("   安装命令: npm install -g vercel")
        return 1
    
    print("✅ Vercel CLI已安装")
    
    # 检查是否登录
    print("\n2. 检查Vercel登录状态...")
    code, stdout, stderr = run_command("vercel whoami")
    if code != 0:
        print("⚠️  Vercel未登录")
        print("   登录命令: vercel login")
        print("   或使用Token: echo 'YOUR_TOKEN' | vercel login --token")
    else:
        print(f"✅ 已登录: {stdout.strip()}")
    
    # 创建部署
    print("\n3. 开始部署...")
    
    # 方法1: 使用Vercel CLI部署
    print("   尝试Vercel CLI部署...")
    deploy_cmd = "vercel --prod --yes --token=${VERCEL_TOKEN} 2>&1" if os.getenv("VERCEL_TOKEN") else "vercel --prod --yes 2>&1"
    code, stdout, stderr = run_command(deploy_cmd)
    
    if code == 0:
        # 提取部署URL
        for line in stdout.split('\n'):
            if 'https://' in line and '.vercel.app' in line:
                deploy_url = line.strip()
                print(f"✅ 部署成功: {deploy_url}")
                
                # 保存部署信息
                with open('deployment-info.json', 'w') as f:
                    json.dump({
                        "status": "success",
                        "url": deploy_url,
                        "method": "vercel_cli",
                        "timestamp": os.popen('date -u +"%Y-%m-%dT%H:%M:%SZ"').read().strip()
                    }, f, indent=2)
                return 0
    
    print("❌ Vercel CLI部署失败")
    print(f"   错误: {stderr}")
    
    # 方法2: 使用GitHub Pages作为备用
    print("\n4. 启用备用方案: GitHub Pages")
    
    # 检查GitHub Pages状态
    pages_status_cmd = f"curl -s -H 'Authorization: token {os.getenv('GITHUB_TOKEN', '')}' https://api.github.com/repos/StephenAHua/stephenbiz/pages"
    code, stdout, stderr = run_command(pages_status_cmd)
    
    if code == 0:
        try:
            pages_data = json.loads(stdout)
            if pages_data.get('status') in ['built', 'building']:
                pages_url = pages_data.get('html_url', '')
                print(f"✅ GitHub Pages已启用: {pages_url}")
                
                with open('deployment-info.json', 'w') as f:
                    json.dump({
                        "status": "success",
                        "url": pages_url,
                        "method": "github_pages",
                        "timestamp": os.popen('date -u +"%Y-%m-%dT%H:%M:%SZ"').read().strip()
                    }, f, indent=2)
                return 0
        except:
            pass
    
    print("❌ 所有部署方法失败")
    print("\n📋 手动部署指南:")
    print("   1. 访问: https://vercel.com/new")
    print("   2. 导入: StephenAHua/stephenbiz")
    print("   3. 项目名称: stephenbiz")
    print("   4. 点击: Deploy")
    
    return 1

if __name__ == "__main__":
    sys.exit(main())
