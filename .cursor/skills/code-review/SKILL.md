---
name: code-review
description: 按 7Fresh/京东规范对当前代码进行编码规范审查，涵盖安全漏洞、JimDB 缓存、分布式锁、BOLA、SQL 注入、日志脱敏等。开发完成或提交前希望做一次规范检查时使用。
disable-model-invocation: true
---

# 编码规范审查 (code-review)

在对话中输入 `/code-review` 触发本技能。请结合用户当前打开或选中的文件/模块进行审查。

## When to Use

- 开发者完成一段核心业务代码或一个需求开发，希望在上线前做一次规范符合性检查时。
- 用户明确要求「帮我做一次 code review」或「检查是否符合京东规范」时。

## Instructions

1. **（推荐）先运行辅助脚本**：在**目标业务项目根目录**执行本技能目录下脚本，将输出一并纳入审查结论（本仓库为规则库时可在包含业务代码的仓库中执行）：
   - `bash .cursor/skills/code-review/scripts/check-red-flags.sh`  
   或复制脚本到业务仓后执行。脚本仅做 **grep 级**粗扫，**有命中需人工判断是否违规**。

2. **确认范围**：若用户未指定，则对当前对话中最近涉及的核心业务代码（Controller、App Service、Domain、Infra 网关实现等）进行审查。

3. **按下列 CheckList 逐项检查**，并给出「通过 / 待整改」及具体位置或建议：

   - **并发与状态**：是否存在单机内存状态（如 `ConcurrentHashMap` 存业务状态）？跨实例竞争是否使用 JimDB 分布式锁？线程池是否用 `ThreadPoolExecutor` 显式创建而非 `Executors`？
   - **缓存与性能**：C 端高频接口是否有 JimDB 缓存与兜底？Key 是否按「应用名:模块名:特征」命名并设置 TTL？是否存在大 Key/大 Value？
   - **依赖与安全**：外部 JSF 调用是否设置 timeout？是否打印入参/出参日志并配置 UMP？基于 ID 的敏感数据操作是否校验当前用户权限（BOLA）？
   - **SQL 与数据**：MyBatis 是否仅用 `#{}`、禁止 `${}` 拼接？是否禁止物理删除、SELECT *、全表更新？是否避免 JOIN/子查询？
   - **日志与异常**：是否使用 `@Slf4j` 与占位符 `{}`？是否禁止 `System.out`/`e.printStackTrace()`？敏感信息是否脱敏？异常是否转化为统一响应而非生吞？
   - **敏感信息**：是否有硬编码密码、Token、数据库地址？是否应使用 DUCC 等配置中心？
   - **幻觉与改动范围**：是否存在明显不存在的 import、包路径或二方 API；是否对无关模块做了大规模重构；新增依赖是否在 `pom` 与团队栈内可解释。

4. **输出形式**：以简洁列表或表格给出每项结论，并标注文件/行号或方法名；对「待整改」项给出修改建议或规则引用（如 `distributed-and-security.mdc`、`logging-exception.mdc`）。若已运行脚本，说明脚本命中项与 CheckList 的对应关系。

## References

- 项目规则：`core-principles.mdc`、`project-structure.mdc`、`distributed-and-security.mdc`、`java-security.mdc`、`database-and-sql.mdc`、`logging-exception.mdc`、`architecture-and-api.mdc`。
