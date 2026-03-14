#!/bin/bash
# HarmonyOS开发环境自动配置脚本
# 基于华为官方文档：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-commandline-get

set -e  # 遇到错误立即退出

echo "🚀 开始配置HarmonyOS开发环境..."

# 检查系统类型
OS_TYPE=$(uname -s)
echo "📱 检测到操作系统: $OS_TYPE"

# 1. 检查DevEco Studio安装
if [ -d "/Applications/DevEco-Studio.app" ]; then
    echo "✅ 找到DevEco Studio安装"
else
    echo "❌ 未找到DevEco Studio，请先安装DevEco Studio"
    echo "下载地址: https://developer.huawei.com/consumer/cn/deveco-studio/"
    exit 1
fi

# 2. 下载Command Line Tools
echo "📦 准备下载Command Line Tools..."
CMD_TOOLS_URL="https://developer.huawei.com/repo/harmonyos/command-line-tools/600/commandline-tools-mac-6.0.0.zip"
CMD_TOOLS_FILE="$HOME/commandline-tools-mac.zip"

echo "⚠️  需要手动下载Command Line Tools:"
echo "1. 访问: https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-commandline-get"
echo "2. 下载 macOS 版本的 Command Line Tools"
echo "3. 解压到 $HOME/command-line-tools"
echo ""
read -p "是否已下载并解压Command Line Tools? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ 请先完成Command Line Tools的下载和安装"
    exit 1
fi

CMD_TOOLS_PATH="$HOME/command-line-tools"
if [ ! -d "$CMD_TOOLS_PATH" ]; then
    echo "❌ 未找到Command Line Tools目录: $CMD_TOOLS_PATH"
    exit 1
fi

# 3. 配置环境变量
echo "🔧 配置环境变量..."

SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
else
    SHELL_CONFIG="$HOME/.zshrc"
fi

# 检查是否已经配置
if grep -q "command-line-tools/bin" "$SHELL_CONFIG" 2>/dev/null; then
    echo "✅ 环境变量已配置"
else
    echo "" >> "$SHELL_CONFIG"
    echo "# HarmonyOS Command Line Tools" >> "$SHELL_CONFIG"
    echo "export COMMANDLINE_TOOL_DIR=\"$CMD_TOOLS_PATH\"" >> "$SHELL_CONFIG"
    echo "export PATH=\"\$COMMANDLINE_TOOL_DIR/command-line-tools/bin:\$PATH\"" >> "$SHELL_CONFIG"
    echo "✅ 环境变量配置完成"
fi

# 4. 设置当前shell环境
export COMMANDLINE_TOOL_DIR="$CMD_TOOLS_PATH"
export PATH="$COMMANDLINE_TOOL_DIR/command-line-tools/bin:$PATH"

# 5. 验证工具安装
echo "🔍 验证工具安装..."

# 检查hvigorw
if command -v hvigorw &> /dev/null; then
    echo "✅ hvigorw 已安装"
    hvigorw -v
else
    echo "❌ hvigorw 未找到"
fi

# 检查hdc
if command -v hdc &> /dev/null; then
    echo "✅ hdc 已安装"
    hdc --version
else
    echo "❌ hdc 未找到"
fi

# 检查ohpm
if command -v ohpm &> /dev/null; then
    echo "✅ ohpm 已安装"
    ohpm -v
else
    echo "❌ ohpm 未找到"
fi

echo ""
echo "🎉 配置完成！"
echo ""
echo "📋 后续步骤:"
echo "1. 重新启动终端或运行: source $SHELL_CONFIG"
echo "2. 进入项目目录: cd $(pwd)"
echo "3. 安装依赖: npm install"
echo "4. 构建项目: hvigorw assembleHap"
echo ""
echo "🚀 开始开发吧!"