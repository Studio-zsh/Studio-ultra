# Studio Ultra Code Wiki

## 1. 文档说明

本文档基于仓库当前磁盘内容生成，目标是帮助开发者快速理解这个项目的代码组织、运行方式、模块职责、关键函数、依赖关系与主要流程。

分析范围包含以下文件：

- `README.md`
- `index.html`
- `index.`
- `package.`
- `Studio Pro v11.6.0.html`
- `studio ultra V13.2(new).html`

当前仓库并不是一个标准的多目录工程，而是一个以单文件前端为主体的仓库，外加一个独立的 Node.js Bot 脚本和两个历史版本 HTML 快照。

---

## 2. 项目概览

### 2.1 项目定位

从 `README.md` 的描述可以确认，这个项目是一个“多 AI + 审判 AI”的辩论平台。当前主实现位于 `index.html`，其核心能力包括：

- 多模型聊天
- 模型能力增强胶囊
- 强度滑块
- 双倍检查 / 自检复核
- 多 Agent 辩论
- API Key 管理
- 模型用量统计
- 外观与背景个性化设置

此外，仓库中还包含一个独立 Node.js 脚本 `index.`，用于连接 QQ Bot 网关并调用 DeepSeek 生成回复。

### 2.2 仓库形态

仓库采用“扁平文件结构”，没有常见的 `src/`、`components/`、`server/`、`tests/` 等目录分层。业务边界主要通过 `index.html` 内部的大块注释分区来体现，而不是通过目录结构体现。

---

## 3. 仓库结构

### 3.1 根目录文件

| 文件 | 角色 |
| --- | --- |
| `README.md` | 项目简介 |
| `index.html` | 当前主应用，前端核心实现 |
| `index.` | 独立 Node.js QQ Bot 脚本 |
| `package.` | Node 侧依赖声明 |
| `Studio Pro v11.6.0.html` | 历史版本快照 |
| `studio ultra V13.2(new).html` | 历史版本快照 |

### 3.2 辅助目录

| 路径 | 角色 |
| --- | --- |
| `.trae-html-share-packages/` | HTML 文件的压缩分享包，不是源码主入口 |

### 3.3 结构结论

这个仓库本质上可以拆成三部分：

1. `index.html`：当前生产形态的前端单文件应用
2. `index.` + `package.`：独立运行的 Node.js Bot 脚本
3. 两个历史 HTML 快照：用于保留旧版本实现

---

## 4. 技术栈与外部依赖

### 4.1 前端技术栈

前端主应用 `index.html` 使用的是原生 Web 技术：

- HTML
- CSS
- 原生 JavaScript
- 浏览器原生 `fetch`
- 浏览器原生 `localStorage`
- 浏览器原生 `AbortController`
- 浏览器原生 `FileReader`
- 浏览器原生 `Canvas`

没有发现以下工程化或框架依赖：

- React
- Vue
- Svelte
- Angular
- Vite
- Webpack
- Next.js
- TypeScript

### 4.2 模型与 API 平台

前端目前接入了四个模型平台：

| 平台 | 用途 |
| --- | --- |
| DeepSeek | 聊天、辩论、余额查询、复核 |
| 智谱 | 聊天、辩论 |
| 通义千问 | 聊天、辩论 |
| 豆包 | 聊天、辩论，自定义接入点 |

### 4.3 Node 侧依赖

`package.` 中只声明了两个依赖：

| 依赖 | 用途 |
| --- | --- |
| `ws` | 建立 QQ Bot 网关 WebSocket 连接 |
| `node-fetch` | 发送 HTTP 请求 |

### 4.4 外部系统依赖

项目依赖以下外部服务可访问：

- DeepSeek Chat Completions API
- DeepSeek Balance API
- 智谱 Chat Completions API
- 通义千问兼容接口
- 豆包 Ark Chat Completions API
- QQ Bot App Access Token 接口
- QQ Bot Gateway 接口
- QQ Channel 消息发送接口

---

## 5. 整体架构

### 5.1 架构总览

仓库可抽象为下面的结构：

```text
+------------------------------------------------------+
|                  Studio Ultra 仓库                    |
+------------------------------------------------------+
|                                                      |
|  前端单文件应用                                      |
|  index.html                                          |
|  - UI 视图层                                         |
|  - 状态层                                            |
|  - Markdown 渲染层                                   |
|  - 统一请求层                                        |
|  - 聊天引擎                                          |
|  - 自检复核引擎                                      |
|  - 多 Agent 辩论引擎                                 |
|  - 设置 / 本地持久化                                 |
|                                                      |
|  独立 Bot 脚本                                       |
|  index.                                              |
|  - QQ Bot 鉴权                                       |
|  - Gateway WebSocket                                 |
|  - 收消息 -> 调用 DeepSeek -> 回发消息               |
|                                                      |
|  历史版本快照                                        |
|  Studio Pro v11.6.0.html                             |
|  studio ultra V13.2(new).html                        |
|                                                      |
+------------------------------------------------------+
```

### 5.2 前端主应用内部架构

`index.html` 内部可进一步拆分为：

| 层次 | 主要内容 |
| --- | --- |
| 展示层 | 侧边栏、聊天页、辩论页、设置页、悬浮助手、Toast |
| 配置层 | 模型定义、平台定义、裁判模板、能力胶囊配置 |
| 状态层 | 当前会话、当前模型、辩论配置、用量、主题、背景等 |
| 工具层 | Markdown 渲染、Toast、下拉组件、背景与头像处理 |
| 请求层 | `streamCompletion()` 统一流式请求 |
| 业务层 | `sendMessage()`、`runSelfCheck()`、`startDebate()` |
| 初始化层 | DOM 事件绑定、默认值恢复、首次渲染 |

### 5.3 核心设计思想

这个项目的核心设计思想非常清晰：

- 用一个统一请求函数封装所有模型调用
- 用本地状态 + `localStorage` 实现“无后端”的前端应用
- 用注释块在单文件内人为建立模块边界
- 用聊天与辩论两个主业务场景复用统一模型调用能力
- 用“自检复核”机制增强回答稳定性

---

## 6. 主模块职责

## 6.1 UI 视图模块

### 聊天视图 `chatView`

职责：

- 展示对话消息
- 接收用户输入
- 控制发送 / 停止生成
- 提供强度滑块和能力胶囊
- 渲染 API 未配置提示

### 辩论视图 `debateView`

职责：

- 配置辩题与标签
- 配置最多 4 位参赛选手
- 配置裁判模型与裁判风格
- 设置辩论轮数
- 输出每轮辩论与最终裁决

### 设置视图 `settingsView`

职责：

- 配置各平台 API Key
- 配置豆包接入点
- 测试 Key 有效性
- 展示模型用量与免费额度
- 切换深色模式
- 管理头像、背景、助手名称
- 设置自检重试次数
- 清空对话记录

### 侧边栏与导航

职责：

- 展示对话列表
- 新建对话
- 删除对话
- 切换“聊天 / 辩论 / 设置”视图

### 悬浮助手

职责：

- 支持拖动
- 点击弹出状态面板
- 显示各平台是否已配置
- 对 DeepSeek 额外读取余额信息

---

## 6.2 配置模块

### `STRENGTH_MAP`

职责：

- 定义五档强度配置
- 绑定显示标签、颜色、粒子速度、`reasoning_effort`

### `API_CONFIG`

职责：

- 维护供应商到 API 地址、本地存储键名、展示名称的映射

### `MODELS`

职责：

- 定义所有可选模型
- 描述其所属平台、展示名、是否免费、温度参数、免费额度、是否支持细分档位

### `MAX_OF`

职责：

- 为每个厂商指定“Max 复核模型”
- 在低档位开启双倍检查时自动切换到该模型

### `JUDGE_TEMPLATES`

职责：

- 定义辩论裁判风格模板
- 将最终裁决分为学术严谨、决策权衡、审稿找茬三种风格

### `CAPS`

职责：

- 定义能力胶囊
- 将 UI 选项转化为系统提示词

---

## 6.3 状态管理模块

项目没有使用状态管理库，而是直接使用内存变量 + `localStorage`。

核心状态如下：

| 状态变量 | 作用 |
| --- | --- |
| `sessions` | 所有聊天会话 |
| `currentId` | 当前打开的会话 ID |
| `currentView` | 当前视图 |
| `chatModel` | 当前聊天模型 |
| `streaming` | 是否正在生成聊天回答 |
| `chatAborter` | 当前聊天请求中止控制器 |
| `debating` | 是否正在执行辩论 |
| `debateCfg` | 辩论配置 |
| `usageStats` | 模型 token 使用统计 |
| `enabledCaps` | 已启用能力胶囊 |
| `selfCheckOn` | 是否开启双倍检查 |
| `retryLimit` | 请求重试上限 |
| `assistantAvatarSrc` | 助手头像 |
| `assistantName` | 助手名字 |
| `bgImageSrc` | 自定义背景图片 |
| `bgOpacity` | 背景透明度 |

### 本地存储键

主要 `localStorage` 键如下：

| Key | 含义 |
| --- | --- |
| `autoPro_sessions` | 会话列表 |
| `autoPro_current` | 当前会话 ID |
| `autoPro_debateCfg` | 辩论配置 |
| `autoPro_usageStats` | 用量统计 |
| `autoPro_caps` | 能力胶囊配置 |
| `autoPro_selfCheck` | 双倍检查开关 |
| `autoPro_retryCount` | 重试次数 |
| `autoPro_dark` | 主题模式 |
| `autoPro_avatar` | 头像 |
| `autoPro_assistantName` | 助手名 |
| `autoPro_key_deepseek` | DeepSeek Key |
| `autoPro_key_zhipu` | 智谱 Key |
| `autoPro_key_qwen` | 千问 Key |
| `autoPro_key_doubao` | 豆包 Key |
| `autoPro_doubao_ep` | 豆包接入点 |
| `autoPro_bgImage` | 背景图片 |
| `autoPro_bgOpacity` | 背景透明度 |
| `autoPro_judgeStyle` | 裁判风格 |

---

## 7. 关键类与函数说明

## 7.1 前端核心类

### `class Particle`

位置：`index.html`

职责：

- 表示一个粒子对象
- 管理粒子的随机初始状态
- 实现粒子位置更新与绘制
- 服务于背景粒子动画效果

关键方法：

| 方法 | 说明 |
| --- | --- |
| `constructor()` | 构造时立即初始化 |
| `reset()` | 重置粒子位置、速度、透明度、寿命 |
| `update()` | 更新粒子运动轨迹 |
| `draw()` | 在 canvas 上绘制粒子 |

这是全文件中唯一显式定义的类。

---

## 7.2 前端基础函数

### `resolveModel(modelId)`

职责：

- 解析模型所属平台
- 获取实际模型名
- 获取请求 URL 与 Key 存储键
- 对豆包使用本地自定义 endpoint

输入：

- 模型 ID

输出：

- `{ p, name, url, keyLS }`

这是所有模型调用前的标准解析入口。

### `renderMarkdown(src)`

职责：

- 将模型输出的 Markdown 渲染成 HTML
- 支持代码块、表格、标题、引用、列表、段落、行内样式

特点：

- 是手写解析器，不依赖第三方 Markdown 库
- 兼顾简单功能和较好的展示效果

### `recordUsage(modelId, usage)`

职责：

- 记录单次 API 返回中的 `usage`
- 按模型聚合输入、输出、总 token
- 持久化到 `localStorage`

### `renderUsageList()`

职责：

- 渲染设置页里的用量统计
- 对免费模型估算剩余额度

### `checkModelFor(modelId)`

职责：

- 在双倍检查开启且强度低时，自动提升到厂商对应 Max 模型做复核

这是“低档位 + 双倍检查自动升级 Max”能力的关键入口。

### `refreshHints()`

职责：

- 更新档位提示
- 更新双倍检查提示
- 更新状态角标

### `updateSliderUI(val)`

职责：

- 更新强度滑块显示
- 修改粒子颜色与速度
- 切换当前档位

---

## 7.3 会话与导航函数

### `persistSessions()`

职责：

- 把当前会话与当前会话 ID 写回本地存储

### `renderSessions()`

职责：

- 渲染左侧会话列表
- 显示标题、模型、时间、标签

### `openSession(id)`

职责：

- 切换当前会话
- 同步会话对应模型
- 刷新聊天区与会话列表

### `newSession()`

职责：

- 创建新会话
- 清理空白会话
- 自动切回聊天视图

### `renderChat()`

职责：

- 把当前会话消息渲染到聊天区
- 区分用户消息与助手消息
- 对助手消息使用 Markdown 渲染
- 展示双倍检查标记

### `switchView(v)`

职责：

- 在聊天、辩论、设置三视图之间切换
- 在进入设置页时顺带刷新平台状态与用量统计

---

## 7.4 请求与生成函数

### `streamCompletion(opts)`

职责：

- 统一发起模型流式请求
- 构造请求体
- 对支持细分档位的模型附加 `reasoning_effort`
- 处理 SSE 风格返回流
- 解析 `delta.content`
- 捕获 `usage`
- 处理 429 限流与重试
- 统一输出完整生成结果

这是前端主应用最关键的基础设施函数，也是聊天、辩论、自检三条主流程共同依赖的底座。

输入能力：

- 模型 ID
- 消息数组
- `signal`
- `onDelta`
- `onUsage`
- `effort`

输出：

- 最终完整文本

### `runSelfCheck(answer, history, mdEl, modelId, signal)`

职责：

- 对首轮回答进行二次自检复核
- 构造带 `CHECK_SYS` 的复核上下文
- 流式覆盖原消息 DOM
- 追加“已双倍检查”标记

特点：

- 当低档位开启双倍检查时，会自动选厂商的 Max 模型
- 若复核失败，保留原答案

### `sendMessage()`

职责：

- 聊天主流程控制器
- 校验当前模型 Key
- 写入用户消息与空 assistant 消息
- 构造历史上下文
- 注入能力胶囊系统提示
- 调用 `streamCompletion()`
- 生成结束后调用 `runSelfCheck()`
- 将最终结果写回会话

这是聊天场景的业务主入口。

### `testKey(p)`

职责：

- 测试某个平台 Key 是否可用
- 快速检查认证、余额、限流等状态

---

## 7.5 能力与辩论函数

### `buildCapSystem()`

职责：

- 把已启用的能力胶囊转成系统提示词

### `renderCaps()`

职责：

- 更新能力胶囊 UI 状态

### `updateEstimate()`

职责：

- 根据参与选手数和轮数计算预估 API 调用次数

### `debateRoundCard(round, list)`

职责：

- 构造单轮辩论卡片 DOM
- 为每位选手预留输出区域

### `startDebate()`

职责：

- 辩论主引擎
- 校验辩题、模型与 Key
- 组装参与选手列表
- 逐轮并发请求各选手发言
- 累积完整 transcript
- 调用裁判模型输出最终裁决
- 支持复制裁决和保存裁决到对话

这是项目中最复杂的业务函数。

---

## 7.6 Node Bot 函数

### `getToken()`

位置：`index.`

职责：

- 调用 QQ Bot 接口获取 access token

### `startBot()`

职责：

- 获取网关地址
- 建立 WebSocket 连接
- 处理 `open` / `close` / `message`
- 收到频道消息后调用 DeepSeek
- 把结果再发回频道

这是 Node 脚本的主入口函数。

---

## 8. 关键依赖关系

### 8.1 前端内部调用关系

```text
sendMessage()
  -> buildCapSystem()
  -> streamCompletion()
  -> runSelfCheck()
       -> checkModelFor()
       -> streamCompletion()
  -> persistSessions()

startDebate()
  -> updateEstimate()   [配置阶段]
  -> debateRoundCard()
  -> Promise.all(streamCompletion() for debaters)
  -> streamCompletion() for judge
  -> persistSessions()  [保存裁决到会话时]

streamCompletion()
  -> resolveModel()
  -> getKey()
  -> recordUsage()
       -> renderUsageList()
```

### 8.2 模块依赖图

```text
配置常量
  -> 状态初始化
  -> 下拉组件
  -> 请求层
  -> 辩论引擎

状态层
  -> 聊天渲染
  -> 会话列表渲染
  -> 设置页渲染

Markdown 渲染层
  -> 聊天消息显示
  -> 辩论发言显示
  -> 裁判结果显示

统一请求层
  -> 聊天流程
  -> 自检流程
  -> 辩论流程

本地存储
  -> 启动初始化
  -> UI 状态恢复
  -> Key 恢复
  -> 历史会话恢复
```

### 8.3 前端与 Bot 的关系

前端主应用和 Node Bot 脚本在代码层是完全分离的：

- 没有共享模块
- 没有共享函数
- 没有统一配置中心
- 没有统一启动入口

它们只是被放在同一个仓库里。

---

## 9. 核心业务流程

## 9.1 聊天流程

```text
用户输入消息
  -> sendMessage()
  -> 校验当前模型 Key
  -> 创建或更新会话
  -> 构造历史消息
  -> 注入能力胶囊 system prompt
  -> streamCompletion() 流式生成
  -> renderMarkdown() 实时渲染
  -> runSelfCheck() 二次复核
  -> 保存最终消息
  -> 刷新会话列表与聊天视图
```

### 关键特点

- 首次发送时可自动创建会话
- 聊天过程支持中止
- 模型回答边生成边渲染
- 生成完成后可以自动再做一轮自检

---

## 9.2 双倍检查流程

```text
初稿答案生成完成
  -> runSelfCheck()
  -> 根据当前模型和档位执行 checkModelFor()
  -> 构造复核 messages
  -> streamCompletion() 再生成一次
  -> 用复核输出覆盖原 assistant 内容
  -> 给消息打上双倍检查标记
```

### 关键特点

- 低档位下会自动切到厂商 Max 模型复核
- 如果复核失败，不会丢失原答案
- UI 会展示“复核中 / 完成 / 失败”状态

---

## 9.3 多 Agent 辩论流程

```text
用户配置辩题、模型、轮数、裁判风格
  -> startDebate()
  -> 校验至少两位选手
  -> 校验每个模型是否有 Key
  -> 对每一轮:
       -> 创建回合卡片
       -> 并发请求所有选手发言
       -> 累积 transcript
  -> 调用裁判模型总结全文
  -> 输出最终裁决
  -> 可复制结论
  -> 可保存为普通聊天会话
```

### 关键特点

- 支持 2 到 4 名选手
- C、D 选手可以设置为不参与
- 每轮选手是并发请求，提高响应速度
- 裁判输出要求固定为结构化 Markdown

---

## 9.4 设置与持久化流程

```text
用户在设置页修改配置
  -> 写入 localStorage
  -> 局部刷新 UI
  -> 页面重开后自动恢复
```

覆盖的持久化内容包括：

- 会话
- API Key
- 模型使用统计
- 背景与头像
- 深色模式
- 辩论配置
- 裁判风格
- 助手名称
- 自检开关

---

## 9.5 QQ Bot 流程

```text
启动脚本
  -> getToken()
  -> 获取 QQ Bot access token
  -> 请求 gateway 地址
  -> 建立 WebSocket 连接
  -> 收到频道消息
  -> 提取用户文本
  -> 调用 DeepSeek
  -> 将回复发送回频道
  -> 连接关闭时 5 秒后重连
```

---

## 10. 运行方式

## 10.1 前端主应用运行方式

### 可确认结论

当前主应用是单文件 HTML 应用，所有样式与脚本都内嵌在 `index.html` 中，没有发现构建脚本或前端打包配置。

### 最直接的运行方式

只要使用浏览器打开 `index.html` 即可加载界面。

### 运行前提

用户需要在设置页中手动配置至少一个可用平台的 API Key，否则无法实际调用模型。

### 运行依赖

- 现代浏览器
- 可访问外部模型 API
- 浏览器支持 `fetch`、`localStorage`、`AbortController`、`FileReader`

### 注意事项

由于项目直接从前端调用外部模型接口，因此 API Key 会存储在本地浏览器中。这种设计适合个人工具或本地使用场景，不适合高安全要求的生产环境。

---

## 10.2 Node Bot 运行方式

### 可确认结论

Node 脚本以 ESM 模式编写，依赖 `ws` 和 `node-fetch`。

### 理论运行条件

需要具备：

- Node.js 环境
- 可用的 QQ Bot AppID / AppSecret
- 可用的 DeepSeek API Key
- 安装 `ws` 与 `node-fetch`

### 当前仓库中的实际问题

存在一个明显不一致：

- `package.` 中 `main` 写的是 `index.js`
- 仓库里实际文件是 `index.`

因此，按当前仓库内容，Node 侧入口声明与实际文件名不一致。

### 凭据配置方式

当前脚本把敏感凭据直接写在源码顶部常量中：

- `APP_ID`
- `APP_SECRET`
- `DEEPSEEK_KEY`

这意味着它不是环境变量驱动的配置方式，而是源码内硬编码配置。

---

## 10.3 构建与测试现状

当前仓库没有发现以下内容：

- `scripts`
- 构建命令
- 测试命令
- 单元测试
- 集成测试
- CI 配置
- Docker 配置

因此可以判断：

- 前端目前没有显式构建环节
- Node 侧也没有完整可确认的标准启动说明
- 项目更偏向手工维护的原型 / 工具型应用

---

## 11. 主要数据结构

## 11.1 会话对象

聊天会话大致包含以下字段：

| 字段 | 含义 |
| --- | --- |
| `id` | 会话 ID |
| `title` | 会话标题 |
| `model` | 当前会话默认模型 |
| `messages` | 消息数组 |
| `ts` | 更新时间戳 |
| `tags` | 归档标签，可选 |

### 消息对象

| 字段 | 含义 |
| --- | --- |
| `role` | `user` 或 `assistant` |
| `content` | 消息文本 |
| `model` | 助手消息使用的模型 |
| `checked` | 是否经过双倍检查 |

## 11.2 辩论配置对象 `debateCfg`

| 字段 | 含义 |
| --- | --- |
| `a` | 选手 A 模型 |
| `b` | 选手 B 模型 |
| `c` | 选手 C 模型或 `none` |
| `d` | 选手 D 模型或 `none` |
| `j` | 裁判模型 |
| `rounds` | 辩论轮数 |

## 11.3 模型配置对象

`MODELS` 中每个模型都具备类似字段：

| 字段 | 含义 |
| --- | --- |
| `id` | 模型 ID |
| `p` | 供应商标识 |
| `name` | 展示名称 |
| `isFree` | 是否标记为免费模型 |
| `temp` | 默认温度 |
| `freeLimit` | 免费额度估值 |
| `tiered` | 是否支持细分强度档位 |

---

## 12. 历史版本文件的作用

## 12.1 `studio ultra V13.2(new).html`

可以视为主应用的较早快照，说明 v13.2 阶段已经具备：

- 多模型支持
- 用量统计
- 双倍检查体系
- 辩论能力
- 强度滑块

## 12.2 `Studio Pro v11.6.0.html`

可以视为更早的产品阶段，主要价值是：

- 反映产品功能的演进路线
- 对比当前版本的功能扩张
- 说明辩论能力和统一请求能力是在逐步增强的

### 历史版本的代码价值

这两个文件更像“版本快照”或“备份实现”，而不是当前主线的一部分。理解主项目时应以 `index.html` 为准。

---

## 13. 风险与已知问题

## 13.1 工程结构风险

- 前端逻辑全部集中在一个超大 `index.html` 文件里，可维护性有限
- 代码没有模块拆分，后续扩展成本会逐步上升
- 前端 UI、业务逻辑、状态管理、工具函数全部耦合在同一文件中

## 13.2 安全与配置风险

- API Key 存在浏览器 `localStorage`
- Node Bot 的凭据直接硬编码在源码中
- 没有统一的环境变量管理

## 13.3 运行一致性问题

- `package.` 文件名不是标准 `package.json`
- `package.` 的入口声明为 `index.js`
- 实际脚本文件名却是 `index.`

这说明 Node 侧当前仓库状态并不完整或不一致。

## 13.4 质量保障缺口

- 没有自动化测试
- 没有 lint 配置
- 没有类型系统
- 没有 CI

## 13.5 浏览器直连 API 的限制

- 会受跨域、网络波动、浏览器环境影响
- 所有重试与容错只能在前端侧完成

---

## 14. 维护建议

如果后续要继续维护这个仓库，建议优先进行以下改造：

1. 把 `index.html` 拆分为独立的 `HTML / CSS / JS` 文件
2. 进一步把 JS 按模块拆分为：
   - 配置模块
   - 状态模块
   - 渲染模块
   - API 模块
   - 聊天模块
   - 辩论模块
   - 设置模块
3. 把 API Key 与 Bot 密钥改成环境变量方案
4. 修复 Node 入口文件与包清单命名不一致问题
5. 增加最基础的运行说明与启动脚本
6. 为 `streamCompletion()`、`renderMarkdown()`、`startDebate()` 增加针对性测试

---

## 15. 一句话总结

`Studio Ultra` 当前是一个以 `index.html` 为核心的原生前端单文件 AI 工作台：它通过统一流式请求层复用聊天、自检复核和多 Agent 辩论能力，并将状态全部保存在浏览器本地；仓库中同时存在一份独立运行的 QQ Bot Node 脚本，但其入口声明与文件命名当前并不一致。
