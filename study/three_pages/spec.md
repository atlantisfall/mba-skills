# three_pages 技能规格说明（Spec）

> 状态：**已锁定**（v1 规格，2026-08-09 定稿）
> 来源：`.scratch/three_pages/` 地图 4 张票的决议 + 两份调研（`research/01-trusted-sources.md`、`research/02-search-render-tooling.md`）+ 样张反馈（`prototype/`）。
> 下一步：交 `/skill-creator` 实现。

---

## 1. 背景与目标

用户为南京大学 MBA 学员，两年半集中授课，课程「学完就忘」；当时学习委员用「不超过 3 页 PDF」浓缩每门课帮全班考前复习（戏称"三页纸"）。本技能把这一方法产品化：

> **传入任意课程/学科名 → 产出「阶段一概念框架表」供确认 → 深化为「正文 ≤3 页 + 附录独立成页」的精华参考文档（md / PDF）。**

- **名称**：`three_pages`
- **归属**：`study/` 目录下（学习类技能）
- **定位**：通用学习/复习工具，接受任意课程名（组织行为学、市场营销、会计学…）

---

## 2. 输入与输出

### 输入
| 参数 | 必选 | 说明 |
|---|---|---|
| 课程名 | ✅ | 任意学科/课程名，如「组织行为学」 |
| 面向 | 可选 | `考试复习`（默认） / `工作应用`——影响概念表优先级与内容侧重 |

### 输出（每个产物均征询用户同意后保存）
1. **阶段一**：概念框架表（Markdown）——待用户确认/修正的学科骨架。
2. **阶段二**：精华参考稿（Markdown 源 + 渲染 PDF）——正文 ≤3 页 A4 + 附录独立成页。

---

## 3. 两步工作流

### 阶段一：定大方向（概念框架表）
1. 接收课程名；生成缓存键 `课程名(+面向)`。
2. **查本地缓存** `~/.claude/cache/three-pages/<course-slug>/concept-table.md`：
   - 命中且未过期 → 默认复用，**顶部标注「来自本地缓存 · 日期 X」**；用户可在此基础上直接修改，或选择强制刷新（重新检索覆盖）。
   - 未命中 → 按白名单 query 模板检索（MOOC 课程大纲 / 出版社教材目录 / 大百科条目），合成候选概念表。
3. 输出概念表，列：`子主题 / 核心概念 / 关键理论家 / 优先级(P1/P2/P3)`，三层次骨架（个体→群体→组织）为学科通用模板起点。
4. **用户确认/修正**：可多轮迭代（无硬性上限），每轮只产出修订后的表格；确认后写入缓存（带日期头）。

### 阶段二：深化成稿（三页纸）
1. 以确认的概念表为骨架，按**子主题并行派发 3–6 路 research 子代理**（白名单 + 引用 + 覆盖标注），各写 `research/<course>/<subtopic>.md`。
2. 主代理读取全部产出 → 生成**覆盖矩阵**（概念表每行 ↔ ✅present / ◐partial / ❌missing ↔ 来源）。
3. 依覆盖矩阵写正文：**正文 ≤3 页 A4**，知识块尾部带 `[T1-x]/[T2-x]` 引用标注；未覆盖子主题**显式标注「⚠️ 未覆盖（原因）」**，不硬编。
4. **附录独立成页**（CSS 强制分页）：来源 URL 表（标题 + 访问日期 + 取数方式）+ 延伸阅读清单及链接。
5. 渲染 PDF（`pandoc → HTML → Chrome 无头`），征询用户同意后保存为 md / PDF。

---

## 4. 资料源策略（白名单 / 黑名单 / 分级 / 引用）

调研全文：`research/01-trusted-sources.md`。核心规则：

- **Tier 1 白名单核心（一手权威，默认首选）**：中国大学MOOC `icourse163.org`、国家高等教育智慧教育平台 `higher.smartedu.cn`、爱课程 `icourses.cn`、学堂在线 `xuetangx.com`、教育部 `moe.gov.cn`、权威出版社（机工华章 `cmpbook.com`/`hzbook.com`、人大 `crup.com.cn`、清华 `tup.tsinghua.edu.cn`、高教社 `hep.com.cn`）、中国大百科全书第三版 `zgbk.com`、MIT OCW `ocw.mit.edu`。
- **Tier 2（交叉验证）**：NSSD `ncpssd.cn`（免费全文）、万方 `wanfangdata.com.cn`、CNKI `cnki.net`（摘要层）、维普 `cqvip.com`、HBR 中文版；Google Scholar 与中文维基**大陆不可直连，仅用检索片段**。
- **Tier 3（仅线索，须交叉验证）**：知乎、MBA智库百科 `wiki.mbalib.com`。
- **黑名单（命中即丢弃）**：整个百度系（`baidu.com` 覆盖知道/百家号/文库/百科/贴吧/学术）、自媒体内容农场（搜狐号/头条号/网易号/企鹅号/一点号/大鱼号）、文档付费站（豆丁/道客巴巴/360doc/原创力/人人文库）、问答农场（360问答/搜狗问问/新浪爱问）、SEO 范文站 + 特征规则（无署名/无日期/广告密集/付费墙）。
- **min-source rule**：每个关键知识点须 ≥1 Tier1 或 ≥2 互不隶属 Tier2；无 Tier1/2 支撑 → 正文标注「未找到一手来源，需人工核实」。
- **引用粒度**：文内 `[T1-<site>]`/`[T2-<site>]` + 附录 URL 表（标题/访问日期/取数方式：WebSearch 片段 or curl）。

**环境约束**：WebFetch 工具不可用 → 抓取一律 **WebSearch 片段 + curl（浏览器 UA）**；`crup.com.cn` 用 http。

---

## 5. 技术底座

调研全文：`research/02-search-render-tooling.md`。核心结论：

- **检索**：WebSearch（标注 US-only，不能假设用户环境可用 → 备 curl 回退）+ 白名单过滤 + 多源交叉。
- **派发**：`/research` 形态的子代理（后台 → 一手源 → 写带引用 md 文件）为检索单元；按子主题并行 3–6 路；收敛靠「共享文件 schema + 主代理覆盖矩阵」。主路径用 Agent 并行即可；Workflow（`.claude/workflows/`）为可选升级。
- **渲染（推荐默认，零安装）**：`pandoc -f gfm -t html5 -H 样式(含 @page A4 + 字号) → Chrome --headless --print-to-pdf`。CJK 实测内嵌 PingFang SC 正常；`@page` 控制 A4 与页数。兜底：`npx md-to-pdf` / `brew install typst`。
- **明确排除**：wkhtmltopdf（弃用 + 未修复 CVE）；不默认引入 LaTeX。
- **降级路径**：概念表即 gap 检测器；未覆盖子主题渲染为「⚠️ 未覆盖（原因）」块 + 附录待补清单；关键结论标注来源分级与置信度；**整条链路全挂 → 降级为「模型知识底稿 + 未在线核验横幅」**，并做启动自检（WebSearch 试跑 / curl 白名单探活）。

---

## 6. 版式规格（样张定案）

- **「3 页」口径**：正文 **≤3 页 A4**；**附录独立成页**（`page-break-before: always`），不占正文篇幅。
- **字号**：密度档默认 **9.2pt**（标准档 9.6pt），作为渲染参数暴露（行距/页边距同参数）。
- **正文结构**：课程地图（三层次概览）→ 分层次知识点（P1 核心优先）→ 高频考点速查表（理论家→理论→一句话要点）→ ⚠️ 覆盖盲区 → 附录。
- **引用与盲区格式**：`[T1-x]/[T2-x]` 逐知识块；「⚠️ 未覆盖（原因：…）」显式块；缓存内容标注「来自本地缓存 · 日期 X」。
- **样张参考**：`prototype/OB-阶段一-概念框架表.md`、`prototype/OB-三页纸-样张.md`（含 `pandoc-header.html` 排版样式）。

---

## 7. 缓存设计（v1）

| 项 | 决定 |
|---|---|
| 缓存内容 | 阶段一**已确认的概念框架表**（检索源不额外缓存——`research/<course>/<subtopic>.md` 已落盘自然复用） |
| 位置 | 用户本地 `~/.claude/cache/three-pages/<course-slug>/concept-table.md` |
| 缓存键 | 课程名（+ 面向参数，若暴露则纳入） |
| 复用 | 默认复用 + 标注日期；用户可强制刷新（重新检索覆盖） |
| 失效 | 缓存头记录生成日期；超 12 个月自动提示「建议重新验证来源」 |
| 透明 | 文档顶部标注「部分内容来自本地缓存 · 日期 X」 |

---

## 8. 错误处理与降级

1. **某子主题检索失败 / 来源仅二手** → 子代理在产出文件标注盲区与原因；主代理渲染「⚠️ 未覆盖（原因）」块，不静默丢弃。
2. **关键知识点不满足 min-source rule** → 正文标注「未找到一手来源，需人工核实」。
3. **WebSearch 不可用 / 网络受限** → 降级 curl 直取白名单；再失败 → 「模型知识底稿 + 未在线核验横幅」。
4. **渲染缺 Chrome** → 回退 `npx md-to-pdf` 或 typst。
5. **阶段一被驳回** → 按反馈修订，可多轮迭代，无硬性上限。

---

## 9. v1 范围决定（已锁定）

- **面向参数**：暴露，默认「考试复习」。
- **课程→框架模板**：v1 **不内置**任何课程预置骨架，纯「检索 + 概念表确认」驱动；常见课程模板（组织行为学等）作为后续增强。
- **范围排除**：整合用户私有课堂笔记/讲义（course-agnostic 工具不拥有这些资料）；代写课程内容本身；无目的漫游搜索。

---

## 10. 实现提示（给 skill-creator）

- 建议产出：`study/three_pages/SKILL.md`（含白名单/黑名单清单、query 模板、两级流程、渲染与缓存指令）+ 可选的 `study/three_pages/references/`（来源策略与渲染样式，可复制自 `research/` 与 `prototype/pandoc-header.html`）。
- SKILL.md 结构建议：`description`（触发词：课程浓缩/三页纸/考前复习）→ 阶段一流程（含缓存读写）→ 阶段二流程（含并行派发与覆盖矩阵）→ 来源规则（白/黑名单 + min-source）→ 渲染与版式 → 错误处理。
- 派发检索时，将 `research/01` 的 query 模板与白名单规则注入子代理 prompt。
- 渲染命令（已在样张验证）：
  ```
  pandoc -s -f gfm -t html5 -H pandoc-header.html --metadata title="<标题>" <in.md> -o <out.html>
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --headless --disable-gpu \
    --print-to-pdf=<out.pdf> --no-pdf-header-footer <out.html>
  ```
- 缓存目录 `~/.claude/cache/three-pages/` 需按课程 slug 分目录；写文件带日期/版本头。

---

## 11. 参考产物索引

- 地图与决议：`.scratch/three_pages/map.md`、`issues/01..04`
- 调研：`research/01-trusted-sources.md`、`research/02-search-render-tooling.md`
- 样张：`prototype/OB-阶段一-概念框架表.md`、`prototype/OB-三页纸-样张.{md,html,pdf}`、`prototype/pandoc-header.html`
