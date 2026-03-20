---
name: generate-ut
description: 根据用户指定的 Java 类（或当前打开的被测类）生成符合 7Fresh 规范的单元测试壳子，使用 Mockito 隔离外部依赖，遵循 AIR/BCDE 与 AAA 结构。在为核心逻辑补充单测时使用。
disable-model-invocation: true
---

# 单元测试生成 (generate-ut)

在对话中输入 `/generate-ut` 触发本技能。可根据当前打开或用户指定的被测类生成测试类骨架。

## When to Use

- 用户希望为某个 Service、Domain 或工具类快速生成符合团队规范的单元测试时。
- 用户说「给这个类写单测」或「生成 OrderService 的 Test」时。

## Instructions

1. **确定被测类**：若用户未指定，则取当前焦点或最近对话中提到的 Java 类（如 `XxxService`、`XxxDomainService`）。若无法确定，向用户询问被测类的全限定名或路径。

2. **生成测试类**：
   - 测试类命名：`被测类名 + Test`，如 `OrderServiceTest`。
   - 包路径：与被测类同包，但位于 `src/test/java` 下。
   - 使用 **Mockito** 对被测类的依赖（Gateway、Mapper、其他 Service）进行 Mock，不调用真实 DB/JSF。
   - 测试方法命名：能表达场景与预期，如 `testCreateOrder_whenStockInsufficient_shouldThrowException`。
   - 结构采用 **AAA**（Arrange-Act-Assert）：准备数据 → 调用被测方法 → 断言。
   - 至少包含：一个正常路径用例、一个异常或边界用例（若适用）。

3. **遵守项目单测规范**：
   - 禁止在测试中访问真实 MySQL、JimDB、JSF；必须用 Mock 隔离。
   - 使用 `assert`/AssertJ 等进行断言，禁止用 `System.out.println` 人肉验证。
   - 参考 `unit-test.mdc` 中的 AIR、BCDE 原则与覆盖率要求。

4. **输出**：直接给出完整可粘贴的测试类代码，并注明「需根据实际构造参数与断言再微调」。

## References

- 项目规则：`unit-test.mdc`。
- 可选：在 `references/ut-template.txt` 中放置团队统一的测试类模板（若存在）。
