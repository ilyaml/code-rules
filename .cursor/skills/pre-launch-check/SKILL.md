---
name: pre-launch-check
description: 上线前检查：压测标透传、影子库/影子缓存/影子 Topic、UMP 监控、依赖版本锁定、环境隔离等。在发布前做一次配置与代码符合性检查时使用。
disable-model-invocation: true
---

# 上线前检查 (pre-launch-check)

在对话中输入 `/pre-launch-check` 触发本技能。涉及环境与配置，**仅做检查与提示，不直接修改生产配置**；需人工确认后再执行任何变更。

## When to Use

- 应用即将上线或参与全链路压测前，需要对照规范做一次自查时。
- 用户说「帮我做上线前检查」或「压测前检查」时。

## Instructions

1. **（推荐）先运行辅助脚本**：在**目标应用项目根目录**执行：
   - `bash .cursor/skills/pre-launch-check/scripts/check-config-hints.sh`  
   将输出作为「待确认」线索，**不得**将脚本结果作为唯一上线依据。

2. **确认范围**：针对当前项目（当前仓库）的配置与代码进行检查。不涉及其他系统或环境的具体密码/地址。

3. **按下列 CheckList 逐项提示**（通过 / 待确认 / 待整改）：

   - **环境与配置隔离**：本地/dev 是否未直接连接 pre/prod 的 JED、JimDB、JMQ、JES？敏感配置是否通过 DUCC 或环境变量注入而非写在 `application-*.yml`？
   - **依赖版本**：`pom.xml` 中是否无 `LATEST` 等未锁定版本？新引入的第三方依赖是否有已知高危漏洞（可提示用户自行用漏洞扫描工具确认）？
   - **压测标透传**：核心链路是否识别网关下发的压测标（如 Test-Flag/Shadow-Flag）并在整条链路（含跨线程、RPC）透传？
   - **影子数据隔离**：带压测标的写请求是否路由到影子库/影子表？JimDB 压测数据是否带独立 Prefix？JMQ 压测消息是否走影子 Topic 或带标识，避免触发真实下游？
   - **日志与监控**：压测产生的日志是否与正常业务日志可区分？对外 HTTP/JSF 接口是否已配置 UMP 监控（TP99、QPS、可用率）？
   - **SDK 与版本**：若有 client 模块，是否已按需求更新 SDK 版本号？是否遵循「只增不改、废弃加 @Deprecated」的兼容原则？

4. **输出形式**：按条目列出检查结果；对「待确认」「待整改」项给出对应规则或文档引用（如 `devops-and-deployment.mdc`），并提醒用户**涉及环境/数据操作时需人工确认后再执行**。

## References

- 项目规则：`devops-and-deployment.mdc`、`core-principles.mdc`。
