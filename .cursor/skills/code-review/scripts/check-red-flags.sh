#!/usr/bin/env bash
# 辅助扫描常见编码红线（仅作 code-review 技能输入，不替代全面人工/工具审查）
# 用法：在项目根目录执行 ./scripts/check-red-flags.sh [扫描根目录，默认当前目录]

set -u
ROOT="${1:-.}"

echo "========== 1) Java: System.out / System.err / printStackTrace =========="
if command -v grep >/dev/null 2>&1; then
  grep -rn --include='*.java' -E 'System\.out\.|System\.err\.|\.printStackTrace\(' "$ROOT" 2>/dev/null || echo "(无匹配或无可扫描文件)"
else
  echo "grep 不可用，跳过"
fi

echo ""
echo "========== 2) MyBatis XML: \${ 动态拼接（需人工判断是否必现场景）=========="
grep -rn --include='*Mapper.xml' --include='*mapper.xml' '\${' "$ROOT" 2>/dev/null || echo "(无匹配或无可扫描文件)"

echo ""
echo "========== 3) Java: Executors. 创建线程池（规范要求 ThreadPoolExecutor）=========="
grep -rn --include='*.java' -E 'Executors\.(newFixedThreadPool|newCachedThreadPool|newSingleThreadExecutor)' "$ROOT" 2>/dev/null || echo "(无匹配)"

echo ""
echo "扫描结束。有输出不代表一定违规，需结合业务与规则人工判断。"
