# three_pages 资料源策略（白名单 / 黑名单 / 分级 / 引用）

> 依据 `research/01-trusted-sources.md` 定稿。本文件是三页纸技能的**来源唯一依据**——所有检索、过滤、引用都按此执行。

## 0. 快速结论
- 一手权威（Tier 1）为主：MOOC 课程大纲、教育部、权威出版社、大百科全书。
- 二手权威（Tier 2）交叉验证：NSSD、万方、CNKI/维普（摘要）、HBR 中文版。
- 黑名单命中即丢弃：百度系、自媒体内容农场、文档付费站、问答农场、SEO 范文站。
- 每个关键知识点 ≥1 Tier1 或 ≥2 Tier2；无支撑 → 标注「需人工核实」。
- 抓取：WebFetch 不可用 → **WebSearch 片段 + curl**。

---

## 1. 白名单

### Tier 1 —— 一手权威（默认首选，课程骨架来源）
| 来源 | 域名 | 用途 |
|---|---|---|
| 中国大学MOOC | `icourse163.org` | **首选课程大纲来源**（课程概述/章节/参考教材） |
| 国家高等教育智慧教育平台 | `higher.smartedu.cn` | 国家级一流课程、课程介绍 |
| 爱课程 | `icourses.cn` | 国家精品课程 |
| 学堂在线 | `xuetangx.com` | 清华等名校经管 MOOC（JS 渲染→用 WebSearch 片段） |
| 教育部 | `moe.gov.cn` | 专业目录、教学指导文件 |
| 机工社/华章 | `cmpbook.com` `hzbook.com` `ebooks.cmpbook.com` | 经管教材（罗宾斯、科特勒等） |
| 人大社 | `crup.com.cn` | 经济管理类核心教材（**用 http**） |
| 清华社 | `tup.tsinghua.edu.cn` `tup.com.cn` | MBA/工商管理教材 |
| 高教社 | `hep.com.cn` | 国家规划教材 |
| 中国大百科全书第三版 | `zgbk.com` | 概念/术语权威定义 |
| MIT OCW | `ocw.mit.edu` | 国际一流商学院课程（英文一手） |

### Tier 2 —— 二手权威（交叉验证 / 学术脉络）
| 来源 | 域名 | 用法与限制 |
|---|---|---|
| NSSD（社科院） | `ncpssd.cn` `ncpssd.org` | **免费全文**，中文经管学术首选入口 |
| 万方 | `wanfangdata.com.cn` `s.wanfangdata.com.cn` | 摘要检索可用 |
| 知网 CNKI | `cnki.net` `kns.cnki.net` `wap.cnki.net` | 摘要/题录可见，**全文付费墙**；仅线索 |
| 维普 | `cqvip.com` | 反爬重，靠检索片段 |
| Google Scholar | `scholar.google.com` | **大陆不可直连**，仅 WebSearch 片段 |
| 中文维基百科 | `zh.wikipedia.org` | **大陆不可直连**，仅 WebSearch 片段；众包不作课程权威 |
| HBR 中文版 | `hbrchina.org` | 二手解读，仅补充 |

### Tier 3 —— 仅线索（必须与 Tier1/2 交叉验证才能进正文）
- 知乎 `zhihu.com`（登录墙 + 未审）；MBA智库百科 `wiki.mbalib.com`（官方自认未专家审查）。

---

## 2. 黑名单（命中即丢弃）
```
baidu.com            # 覆盖 知道/百家号/文库/百科/贴吧/学术 全部子域
sohu.com  mp.sohu.com
toutiao.com  mp.toutiao.com
dy.163.com
om.qq.com            # 企鹅号
yidianzixun.com
dayu.com  mp.uc.cn
docin.com  doc88.com  360doc.com  book118.com  renrendoc.com  mayiwenku.com
wenda.so.com  wenwen.sogou.com  iask.sina.com.cn
csdn.net  jianshu.com  cnblogs.com
liuxue86.com  exam8.com  51test.net  xuexila.com
# 特征规则：无机构署名 / 无作者 / 无发布日期 / 广告密集 / 付费墙 / 登录墙 → 一律拒绝
```

---

## 3. 检索 query 模板（WebSearch 用）
```
# 课程大纲（默认首选）
site:icourse163.org {课程名}
site:xuetangx.com {课程名}
site:icourses.cn {课程名}
site:smartedu.cn {课程名}
{课程名} 课程大纲 site:edu.cn

# 教材体系（锁定权威教材与版本）
{课程名} 教材 出版社 site:crup.com.cn
{课程名} 教材 site:cmpbook.com
{课程名} site:tup.tsinghua.edu.cn

# 概念/术语权威定义
{概念名} site:zgbk.com
{概念名} 中国大百科全书

# 学术脉络 / 交叉验证（摘要级）
site:ncpssd.cn {课程名} 综述
site:cnki.net {课程名} 核心概念
site:wanfangdata.com.cn {课程名}

# 兜底（再用白名单过滤）
{课程名} 核心概念 框架
```

## 4. 结果过滤规则
1. 解析返回 URL 的 host。
2. host ∈ 黑名单 → **直接丢弃**。
3. host ∈ Tier1 → 采用，标 `T1-<站点>`。
4. host ∈ Tier2 → 摘要/交叉验证，标 `T2-<站点>`；Google Scholar/维基仅保留片段文本。
5. host ∈ Tier3 → 标 `T3`，仅线索，不落正文。
6. host 未知 → 套特征规则拒绝；无法判定则降级 Tier3。
7. 每知识点按 min-source 校验，不满足则进回退。

## 5. min-source rule（质量闸门）
每个**关键知识点**须满足其一：
- 1 个 Tier1 来源；或
- 2 个互不隶属的 Tier2 来源；或
- 1 个 Tier2 + 1 个 Tier3，且内容一致。
- 无 Tier1/2 支撑 → 正文标注「未找到一手来源，需人工核实」，不得杜撰。
- 多源冲突：以 Tier1 为准；Tier1 间冲突 → 并列呈现并标注差异。

## 6. 引用格式
- 文内：每个知识块/事实句尾附 `[T1-<site>]` / `[T2-<site>]`。
- 附录 URL 表：来源码 → 标题 + URL + 访问日期 + 取数方式（WebSearch 片段 / curl）。

## 7. 抓取与回退路径
1. WebSearch 结果片段（最稳，绕反爬/登录墙）
2. `curl -A "浏览器 UA"` 直取白名单页（MOOC 课程页、出版社书目页、NSSD）
3. 放弃直连，回到片段
- 逐级回退：Tier1 课程大纲 → 出版社教材目录 → 学术库摘要（NSSD→万方→CNKI/维普）→ 标注「需人工核实」。
- 环境备忘：`crup.com.cn` 走 http；学堂在线/大百科部分页 JS 渲染，curl 取不到正文时用 WebSearch 片段。
