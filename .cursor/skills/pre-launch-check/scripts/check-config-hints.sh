#!/usr/bin/env bash
# 辅助检查上线前配置与依赖线索（仅作 pre-launch-check 技能输入）
# 用法：在项目根目录执行 ./scripts/check-config-hints.sh [扫描根目录，默认当前目录]

set -u
ROOT="${1:-.}"

echo "========== 1) Maven: pom.xml 中使用 LATEST / RELEASE 等非锁定版本 =========="
grep -rn --include='pom.xml' -E 'LATEST|RELEASE' "$ROOT" 2>/dev/null || echo "(无匹配)"

echo ""
echo "========== 2) YAML/Properties: 含 password/secret 字样的键（需确认是否明文，勿提交真实密钥）=========="
grep -rn --include='*.yml' --include='*.yaml' --include='*.properties' -E 'password:|secret|secretKey|accessKey' "$ROOT" 2>/dev/null | head -50 || echo "(无匹配或已限制条数)"

echo ""
echo "========== 3) 压测/影子相关关键字（仅供参考，需结合架构判断）=========="
grep -rn --include='*.java' --include='*.yml' --include='*.yaml' -E 'shadow|Shadow|test.flag|Test-Flag|压测' "$ROOT" 2>/dev/null | head -30 || echo "(无匹配或已限制条数)"

echo ""
echo "扫描结束。涉及环境与安全项须人工确认，禁止仅凭脚本结果上线。"
