# mba-skills

**Skills of how MBAs think and do** —— MBA 学习与思维技能集。

一个面向 Claude Code 的插件 marketplace，持续收录把课程与知识**浓缩、复盘、应用**的技能。

## 技能索引

| 技能 | 作用 | 文档 |
|---|---|---|
| [three-pages](docs/three-pages.md) | 把任意课程/学科浓缩成「正文 ≤3 页 + 附录独立成页」的精华参考文档（"三页纸"），含来源引用与覆盖盲区标注 | [three-pages.md](docs/three-pages.md) |

## 安装

本仓库是**自指 marketplace**（配置见 `.claude-plugin/`），技能本体在 `study/<skill>/`。

> 仓库地址：https://github.com/atlantisfall/mba-skills

### 给同学 / 无编程经验者（一键安装）

**前置**：需要先装好 Claude Code（桌面版或终端版均可）。

然后在 Claude Code 里，把下面两行**逐行复制粘贴**并回车：

```
/plugin marketplace add atlantisfall/mba-skills
/plugin install mba-skills@mba-skills
```

装完输入 `/reload-plugins`（或重启 Claude Code），就可以直接用了，比如对 Claude 说：

> 帮我把《市场营销》做成三页纸复习资料，两周后要考试。

### 给开发者（本地调试）

- **临时体验**（不开插件）：
  ```bash
  claude --plugin-dir /path/to/mba-skills
  ```
- **本地 marketplace**：
  ```
  /plugin marketplace add /path/to/mba-skills
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
