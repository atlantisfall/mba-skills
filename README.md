# mba-skills

**Skills of how MBAs think and do** —— MBA 学习与思维技能集。

一个面向 Claude Code 的插件 marketplace，持续收录把课程与知识**浓缩、复盘、应用**的技能。

## 技能索引

| 技能 | 作用 | 文档 |
|---|---|---|
| [three-pages](docs/three-pages.md) | 把任意课程/学科浓缩成「正文 ≤3 页 + 附录独立成页」的精华参考文档（"三页纸"），含来源引用与覆盖盲区标注 | [three-pages.md](docs/three-pages.md) |

## 安装

本仓库是**自指 marketplace**（配置见 `.claude-plugin/`），技能本体在 `study/<skill>/`。

- **临时体验**（不开插件）：
  ```bash
  claude --plugin-dir /path/to/mba-skills
  ```
- **本地永久安装**：
  ```
  /plugin marketplace add /path/to/mba-skills
  /plugin install mba-skills@mba-skills
  ```
- **远程安装**（推送后，以 GitHub 仓库地址为准）：
  ```
  /plugin marketplace add <owner>/mba-skills
  /plugin install mba-skills@mba-skills
  ```

## 结构

```
mba-skills/
├── study/<skill>/     # 技能本体：SKILL.md + references + scripts + evals + spec
├── docs/<skill>.md    # 面向使用者的技能文档
└── .claude-plugin/    # 插件 / marketplace 配置（plugin.json + marketplace.json）
```

## 开发

新增一个技能（流程对齐 skill-doc-maintainer）：

1. 建 `study/<skill>/SKILL.md`（frontmatter 含 `name` 与 `description`）
2. 写 `docs/<skill>.md`（What it does / When to reach for it / Prerequisites / Common questions / It's working if / Where it fits）
3. 登记进 `.claude-plugin/plugin.json` 的 `skills` 数组，按语义化版本策略升版
4. 更新本 README「技能索引」表
