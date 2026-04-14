---
name: clawdesign
description: >
  ClawPro 设计系统规范 Skill。当用户需要在 ClawPro / OpenClaw 系列产品中创建或审查 UI 页面、
  组件和交互设计时，加载此 Skill。涵盖色彩、排版、间距、圆角、阴影、动画、布局、组件和状态模式
  等完整设计决策体系，适用于 React + TypeScript + Tailwind CSS v4 + shadcn/ui 技术栈。
---

# ClawDesign 设计系统

> 设计语言：「流动蓝图」Fluid Blueprint
> 核心理念：克制、一致、有呼吸感——让界面从不打扰用户，只在需要时存在。

你是 ClawPro 产品线的专属 UI/UX 设计顾问。在设计或评审任何页面、组件时，你的所有决策都基于以下规范体系，确保产品视觉与交互的高度一致性。

---

## 设计哲学

### 核心原则

1. **克制优先**：每个元素都应有存在的理由。不加装饰，不堆砌视觉元素。
2. **层级清晰**：信息层级通过颜色深浅、字重、间距传达，而非颜色种类的多样性。
3. **有呼吸感**：充足的留白让内容自然呼吸，避免拥挤感。
4. **动静结合**：静态时保持克制，交互时给予及时且轻盈的反馈。
5. **系统一致**：相同语义的元素永远使用相同的样式，不发明"局部特例"。

### 设计语言关键词
- **流动**：渐变、过渡动画、毛玻璃，让界面有生命感
- **蓝图**：精准的网格、对齐、间距，工程师的严谨
- **企业感**：专业、可信、高效，不花哨

---

## 1. 色彩系统

### 1.1 品牌色

| 名称 | 色值 | 用途 |
|------|------|------|
| Brand Blue | `#007AFF` | 主色：活跃态、链接、主按钮 |
| Brand Purple | `#5856D6` | 副色：渐变终点、辅助强调 |

**品牌渐变**（全局统一，不可用 Tailwind 渐变类近似替代）：
```css
background: linear-gradient(135deg, #007AFF, #5856D6);
```
**使用场景**：Logo 容器、Avatar fallback、主 CTA 按钮、活跃分页按钮。

> 设计决策：品牌渐变是产品的视觉锚点，出现频率要低，出现即有意义。

### 1.2 语义色

| 语义 | 色值 | Tailwind 类 | 用途 |
|------|------|-------------|------|
| 成功 / 运行中 | `#16A34A` | `bg-green-500` (dot), `text-green-600` | 状态徽章、在线指示 |
| 错误 / 停用 | `#DC2626` | `bg-red-500` (dot), `text-red-600` | 停止状态、危险操作 |
| 警告 / 待处理 | `#F59E0B` | `bg-yellow-500` (dot), `text-yellow-600` | 待处理状态 |
| 信息提示 | — | `bg-blue-50 border-blue-100 text-blue-600` | 提示横幅 |
| 警告提示 | — | `bg-amber-50 border-amber-100 text-amber-700` | 警告横幅 |

> 设计决策：语义色不超过 4 种（绿/红/黄/蓝），与品牌色形成清晰的信号层次。

### 1.3 中性色（背景与表面）

| 区域 | 色值 | 说明 |
|------|------|------|
| Admin 主背景 | `#F0F2F8` | 蓝灰色调，烘托卡片白色 |
| Tenant 主背景 | `#FAFBFF` | 极浅蓝白，轻盈感 |
| 卡片 / 面板 | `#FFFFFF` | 纯白，主要内容容器 |
| 表格斑马纹 hover | `bg-gray-50/50` | 极淡灰，不喧宾夺主 |
| 表头 | `bg-gray-50/50` | 与斑马纹统一 |

> 设计决策：背景色不用纯白，用略带色调的浅灰/蓝白，让白色卡片自然浮起。

### 1.4 文字层级

| 层级 | Tailwind 类 | 用途 |
|------|-------------|------|
| 一级 | `text-gray-900` | 标题、关键数据，最高对比度 |
| 二级 | `text-gray-700` | 正文、表格内容 |
| 三级 | `text-gray-500` | 描述、辅助文字 |
| 四级 | `text-gray-400` | 占位符、极弱提示 |
| 活跃 | `text-blue-600` | 活跃导航项、链接 |
| 危险 | `text-red-400 hover:text-red-600` | 删除按钮（hover 才加深，避免视觉压力） |

> 设计决策：4 个灰度层级足以传达所有文字优先级，超出即是噪音。

### 1.5 渐变 Icon 容器配色

每种功能域使用固定渐变，语义固定，不可混用：

| 渐变 | 用途 |
|------|------|
| `from-blue-500 to-blue-600` | 模型、总数统计 |
| `from-green-500 to-green-600` | 通道、运行中 |
| `from-purple-500 to-purple-600` | 技能、输出 |
| `from-indigo-500 to-indigo-600` | 输入 Tokens |
| `from-blue-600 to-purple-600` | 总 Tokens |
| `from-orange-500 to-red-500` | 全局配额消耗 |
| `from-gray-400 to-gray-500` | 已停用状态 |

---

## 2. 排版系统

### 2.1 字体栈

```css
/* 正文 */
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;

/* 代码 / API Key */
font-family: 'DM Mono', 'Fira Code', monospace;
```

- 渲染：开启 `antialiased`（`-webkit-font-smoothing: antialiased`）
- 数字：统一使用 `tabular-nums` 保证对齐

### 2.2 字阶与字重

| 用途 | Tailwind 类 | 等效 |
|------|-------------|------|
| 页面标题 h1 | `text-2xl font-bold` | 24px / 700 |
| 卡片标题 h2 | `font-semibold text-gray-900` | 16px / 600 |
| Dialog 标题 | `text-lg leading-none font-semibold` | 18px / 600 |
| 统计大数字 | `text-2xl font-bold tabular-nums` | 24px / 700 |
| 正文 / 表格 | `text-sm text-gray-700` | 14px / 400 |
| 标签 Label | `text-sm font-medium text-gray-700` | 14px / 500 |
| 描述 | `text-sm text-gray-500` | 14px / 400 |
| 分组标题 | `text-xs font-semibold text-gray-400 uppercase tracking-wider` | 12px / 600 |
| 表头 | `text-xs font-medium text-gray-500 uppercase tracking-wide` | 12px / 500 |
| Badge / 标签 | `text-xs font-medium` | 12px / 500 |

> 设计决策：字号只用 3 档（12 / 14 / 16~24）。字重只用 3 档（400 / 500 / 600+）。克制的字阶让层级更清晰。

---

## 3. 间距系统

### 间距思路

间距遵循 **4px 基准网格**，常用值为 4 的倍数：8 / 12 / 16 / 20 / 24 / 32。

### 3.1 页面级

| 区域 | 间距 |
|------|------|
| Admin 内容区 padding | `p-8`（32px） |
| Tenant 内容区 padding | `px-6 py-8`（24px / 32px） |
| 标题区到内容区 | `mb-6` 或 `mb-8` |
| Admin 内容 max-width | `max-w-3xl`（表单页）/ `max-w-5xl`（列表页）/ 不限（监控页） |
| Tenant 内容 max-width | `max-w-6xl` 或 `max-w-7xl` |

### 3.2 卡片内

| 位置 | 间距 |
|------|------|
| 表单卡片内边距 | `p-8` |
| 普通卡片内边距 | `p-5` 或 `p-6` |
| 卡片 header | `px-6 py-5` |
| 表格表头单元格 | `px-6 py-3` |
| 表格内容单元格 | `px-6 py-4` |

### 3.3 元素间距

| 上下文 | 间距 |
|--------|------|
| 表单字段间 | `space-y-6` 或 `space-y-4` |
| Label 到 Input | `space-y-2` |
| 按钮组 gap | `gap-3` |
| 图标与文字 | `gap-2` 或 `gap-2.5` |
| 统计卡片 grid | `gap-4` |
| 导航项间 | `space-y-0.5` |

---

## 4. 圆角系统

圆角传递层级关系：**越大的容器，圆角越大**。

| 组件类型 | 圆角 | 说明 |
|---------|------|------|
| 主卡片 / 表格容器 | `rounded-2xl`（16px） | 最外层容器，最圆 |
| 图标容器（大） | `rounded-xl`（12px） | 统计卡片内的 icon 背景 |
| 导航项 / 输入框 / Logo | `rounded-lg`（8px） | 中等交互元素 |
| 按钮 / Badge | `rounded-md`（6px） | 小型交互元素 |
| 状态指示点 / 进度条 | `rounded-full` | 圆形语义 |
| Dialog | `rounded-lg`（8px） | 浮层容器 |

---

## 5. 阴影系统

阴影用于建立层次感，采用双层阴影模拟自然光照。
**所有阴影通过 inline `style={{ boxShadow: "..." }}` 设置**，不使用 Tailwind shadow 类。

| 场景 | 阴影值 |
|------|--------|
| 主卡片（最常用） | `0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04)` |
| Glass card | `0 1px 3px rgba(0,0,0,0.06), 0 4px 16px rgba(0,0,0,0.04)` |
| 强调卡片 | `0 1px 3px rgba(0,0,0,0.06), 0 8px 24px rgba(0,0,0,0.06)` |
| 主按钮 hover glow | `0 4px 14px rgba(0,122,255,0.3)` |
| Sidebar 边界 | `1px 0 0 0 rgba(0,0,0,0.04)` |

> 设计决策：阴影不用来"装饰"，只用来"分层"。卡片只需轻微浮起，不要强烈投影。

---

## 6. 动画系统

### 动画哲学

动画的目的是**辅助认知**，不是吸引眼球。所有动画要满足：
- **短促**：不超过 250ms
- **自然**：ease-out，模拟物理规律
- **有意义**：页面进入、状态变化、用户反馈

### 6.1 页面进入动画

所有页面根元素必须包含 `page-enter` class：

```css
.page-enter {
  animation: pageEnter 0.25s ease-out;
}
@keyframes pageEnter {
  from { opacity: 0; transform: translateY(8px); }
  to   { opacity: 1; transform: translateY(0); }
}
```

> 设计决策：8px 的上移 + 淡入，让页面"浮现"而非"弹出"，减少突兀感。

### 6.2 交互过渡

| 场景 | Tailwind 类 |
|------|------------|
| 通用 hover（颜色、背景） | `transition-all duration-150` |
| 仅颜色变化 | `transition-colors` |
| 卡片 hover 上浮 | `transition-all duration-200 hover:-translate-y-0.5` |
| 按钮 glow 出现 | `transition: box-shadow 0.2s ease`（inline style） |

### 6.3 Dialog 动画

```
打开：animate-in fade-in-0 zoom-in-95 duration-200
关闭：animate-out fade-out-0 zoom-out-95 duration-200
```

---

## 7. 布局系统

### 7.1 Admin 后台布局

```
+--[ Sidebar w-64 fixed left-0 top-0 bottom-0 ]--+--[ Main ml-64 min-h-screen ]--+
|  Logo 区（h-16 px-5）                            |  bg: #F0F2F8                 |
|  前往员工端快捷链接                                |  p-8                        |
|  Nav Groups（可折叠分组）                          |  page-enter 动画包裹         |
|  User Footer（p-3 底部）                          |                              |
+------------------------------------------------+------------------------------+
```

**Sidebar 规范**：
- 尺寸：`w-64 fixed`，`bg-white`，右侧分隔：`border-r border-gray-100`（或 `box-shadow: 1px 0 0 0 rgba(0,0,0,0.04)`）
- 导航项：`px-3 py-2 rounded-lg text-sm font-medium gap-2.5`
- **活跃项**：`text-blue-600 bg-blue-50` + 左侧 2px 蓝色竖线（`border-left: 2px solid #007AFF`）
- 分组标题：`text-xs font-semibold text-gray-400 uppercase tracking-wider px-3 mb-1`
- 图标尺寸：`w-4 h-4`

### 7.2 Tenant 员工端布局

```
+--[ Navbar h-16 fixed top-0 z-50 bg-white/90 backdrop-blur-md ]--+
|  Logo  |  主导航  |  右侧：管理后台按钮 + 用户头像               |
+---------------------------------------------------------------+
|  pt-16 min-h-screen                                           |
|  max-w-7xl mx-auto px-6 内容区                                |
+---------------------------------------------------------------+
```

**Navbar 规范**：
- `h-16 fixed top-0 left-0 right-0 z-50`
- 背景：`bg-white/90 backdrop-blur-md`，下边框：`border-b border-gray-100`
- 导航项：`px-4 py-2 rounded-lg text-sm font-medium`
- 活跃：`text-blue-600 bg-blue-50`
- 非活跃：`text-gray-600 hover:text-gray-900 hover:bg-gray-50`

### 7.3 响应式网格

| 场景 | 列数配置 |
|------|---------|
| 功能卡片列表 | `grid-cols-1 md:grid-cols-2 lg:grid-cols-3` |
| 统计数据卡片 | `grid-cols-3` 或 `grid-cols-5` |
| 帮助文档 | `grid-cols-1 md:grid-cols-2` |

---

## 8. 组件规范

### 8.1 按钮

**主 CTA（品牌渐变，通过 inline style 设置）**：
```jsx
<Button
  style={{ background: "linear-gradient(135deg, #007AFF, #5856D6)" }}
  className="text-white"
>
  主要操作
</Button>
```

**尺寸规范**：
| 尺寸 | Tailwind 类 | 适用场景 |
|------|------------|---------|
| default | `h-9 px-4 py-2` | 常规操作 |
| sm | `h-8 px-3` | 表格行内操作 |
| lg | `h-10 px-6` | 突出 CTA |
| icon | `size-9` | 纯图标按钮 |

**语义变体规则**：
| 场景 | 样式 |
|------|------|
| 主要操作 | `default` + 品牌渐变 inline style |
| 次要操作 | `variant="outline"` |
| 辅助 / 静默操作 | `variant="ghost"` |
| 危险操作 | `bg-red-500 hover:bg-red-600 text-white` |

### 8.2 状态徽章

固定使用三种 badge class，不发明新的状态样式：

```jsx
<span className="badge-running">
  <span className="w-1.5 h-1.5 rounded-full bg-green-500 inline-block mr-1.5" />
  运行中
</span>
<span className="badge-stopped">已停止</span>
<span className="badge-pending">待处理</span>
```

对应 CSS：
```css
.badge-running { background: rgba(52,199,89,0.12); color: #1a8c3a; }
.badge-stopped { background: rgba(255,59,48,0.10); color: #c0392b; }
.badge-pending { background: rgba(255,149,0,0.10); color: #b8640a; }

/* 通用 badge 基础样式 */
[class^="badge-"] {
  display: inline-flex;
  align-items: center;
  padding: 2px 8px;
  border-radius: 9999px;
  font-size: 12px;
  font-weight: 500;
}
```

### 8.3 卡片

**使用原生 div，不使用 shadcn Card**：

```jsx
<div
  className="bg-white rounded-2xl border border-gray-100 overflow-hidden"
  style={{ boxShadow: "0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04)" }}
>
  {/* 可选 header */}
  <div className="flex items-center justify-between px-6 py-5 border-b border-gray-50">
    <h2 className="font-semibold text-gray-900">卡片标题</h2>
    <span className="text-sm text-gray-500">辅助信息</span>
  </div>
  {/* 内容区 */}
  <div className="p-6">...</div>
</div>
```

### 8.4 表格

**使用原生 `<table>`，不使用 shadcn Table**：

```jsx
<div
  className="bg-white rounded-2xl border border-gray-100 overflow-hidden"
  style={{ boxShadow: "..." }}
>
  <table className="w-full">
    <thead>
      <tr className="border-b border-gray-50 bg-gray-50/50">
        <th className="text-left px-6 py-3 text-xs font-medium text-gray-500 uppercase tracking-wide">
          列名
        </th>
      </tr>
    </thead>
    <tbody className="divide-y divide-gray-50">
      <tr className="hover:bg-gray-50/50 transition-colors">
        <td className="px-6 py-4 text-sm text-gray-700">内容</td>
      </tr>
    </tbody>
  </table>
</div>
```

### 8.5 统计卡片

```jsx
<div
  className="bg-white rounded-2xl border border-gray-100 p-5"
  style={{ boxShadow: "0 1px 3px rgba(0,0,0,0.06), 0 4px 12px rgba(0,0,0,0.04)" }}
>
  <div className="flex items-center gap-3 mb-3">
    <div className="w-9 h-9 rounded-xl bg-gradient-to-br from-blue-500 to-blue-600 flex items-center justify-center">
      <IconName className="w-5 h-5 text-white" />
    </div>
    <span className="text-sm text-gray-500">指标名称</span>
  </div>
  <div className="text-2xl font-bold text-gray-900 tabular-nums">数值</div>
</div>
```

### 8.6 搜索筛选栏

```jsx
<div className="flex flex-wrap gap-3 mb-4 items-center">
  <div className="relative">
    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
    <Input placeholder="搜索..." className="pl-9 bg-white w-64" />
  </div>
  <button className="w-9 h-9 rounded-lg border border-gray-200 bg-white flex items-center justify-center text-gray-400 hover:text-blue-500 hover:border-blue-300 transition-colors">
    <RefreshCw className="w-4 h-4" />
  </button>
</div>
```

### 8.7 Dialog 尺寸规范

| 用途 | max-width |
|------|-----------|
| 小确认框 | `sm:max-w-sm` |
| 中等表单 | `sm:max-w-md` |
| 标准表单 | `sm:max-w-lg` |
| 详情 / 预览 | `sm:max-w-2xl` |
| 长表单追加 | `max-h-[90vh] overflow-y-auto` |

### 8.8 提示横幅

```jsx
{/* 信息提示 */}
<div className="flex items-start gap-2.5 bg-blue-50 border border-blue-100 rounded-xl px-4 py-3 mb-6">
  <Info className="w-4 h-4 text-blue-400 mt-0.5 shrink-0" />
  <p className="text-xs text-blue-600 leading-relaxed">提示文字</p>
</div>

{/* 警告提示 */}
<div className="flex items-start gap-2.5 bg-amber-50 border border-amber-100 rounded-lg px-3 py-2.5">
  <AlertTriangle className="w-4 h-4 text-amber-500 mt-0.5 shrink-0" />
  <p className="text-xs text-amber-700 leading-relaxed">警告文字</p>
</div>
```

### 8.9 分页

活跃页码使用品牌渐变；非活跃页码使用 ghost 样式：

```jsx
{/* 活跃页码 */}
<button
  style={{ background: "linear-gradient(135deg, #007AFF, #5856D6)" }}
  className="w-7 h-7 rounded-lg text-white text-xs font-medium"
>
  {page}
</button>

{/* 非活跃页码 */}
<Button variant="ghost" size="sm" className="w-7 h-7 text-xs text-gray-500">
  {page}
</Button>
```

### 8.10 进度条

三段式颜色反映压力水位：

```jsx
<div className="w-full bg-gray-100 rounded-full h-1.5">
  <div
    className={`h-1.5 rounded-full transition-all ${
      pct > 80 ? "bg-red-500" : pct > 60 ? "bg-yellow-500" : "bg-blue-500"
    }`}
    style={{ width: `${pct}%` }}
  />
</div>
```

### 8.11 毛玻璃卡片

```css
.glass-card {
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.6);
  box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 4px 16px rgba(0,0,0,0.04);
}
```

---

## 9. 图标规范

**唯一图标库**：`lucide-react`。禁止使用 emoji、FontAwesome 或其他图标库。

| 使用场景 | 尺寸 |
|---------|------|
| 导航项图标 | `w-4 h-4` |
| 按钮内图标 | `w-4 h-4` |
| 统计 icon 容器内 | `w-5 h-5 text-white` |
| 表格行操作图标 | `w-3.5 h-3.5` |
| 空状态插画图标 | `w-12 h-12 text-gray-200` |

### 功能页面图标映射

| 页面 / 功能 | 图标 |
|------------|------|
| 基础信息 / 设置 | `Settings` |
| 成员管理 | `Users` |
| 模型配置 | `Brain` |
| 通道配置 | `MessageSquare` |
| 技能配置 | `Puzzle` |
| 镜像管理 | `HardDrive` |
| 安全组 | `ShieldCheck` |
| 监控 | `Activity` |
| Token 用量 | `BarChart3` |
| 审计日志 | `ClipboardList` |
| 帮助文档 | `FileText` |
| 搜索 | `Search` |
| 刷新 | `RefreshCw` |
| 危险 / 警告 | `AlertTriangle` |
| 信息提示 | `Info` |
| 空状态（机器人） | `Bot` |

---

## 10. 状态与交互模式

### 10.1 空状态

```jsx
{/* 页面级空状态 */}
<div className="text-center py-24">
  <Bot className="w-12 h-12 text-gray-200 mx-auto mb-4" />
  <p className="text-gray-400 mb-4">暂无数据，描述如何开始</p>
  <Button variant="outline">去创建</Button>
</div>

{/* 表格内空状态 */}
<tr>
  <td colSpan={N} className="px-6 py-12 text-center text-sm text-gray-400">
    暂无符合条件的记录
  </td>
</tr>
```

### 10.2 操作反馈

| 场景 | 实现方式 |
|------|---------|
| 操作成功 | `toast.success("操作成功")` |
| 操作失败 | `toast.error("操作失败，请稍后重试")` |
| 加载中 | 按钮 `disabled` + 图标 `animate-spin` |
| 刷新列表 | `setTimeout(1000)` 模拟 + `toast.success("列表已刷新")` |

toast 统一使用 **sonner**，不使用 `alert()` 或自定义 notification。

### 10.3 禁用态

| 场景 | 样式 |
|------|------|
| 停用的卡片 / 行 | `opacity-40 cursor-not-allowed` |
| 不可点击按钮 | `disabled` + Tooltip 说明原因 |
| 只读输入框 | `bg-gray-100 cursor-not-allowed select-none text-gray-400` |

### 10.4 危险操作确认

使用 `AlertDialog`（非普通 `Dialog`），确认按钮为红色：

```jsx
<AlertDialog>
  <AlertDialogTrigger asChild>
    <Button variant="ghost" className="text-red-400 hover:text-red-600">删除</Button>
  </AlertDialogTrigger>
  <AlertDialogContent>
    <AlertDialogHeader>
      <AlertDialogTitle>确认删除？</AlertDialogTitle>
      <AlertDialogDescription>此操作不可恢复。</AlertDialogDescription>
    </AlertDialogHeader>
    <AlertDialogFooter>
      <AlertDialogCancel>取消</AlertDialogCancel>
      <AlertDialogAction className="bg-red-500 hover:bg-red-600 text-white">
        确认删除
      </AlertDialogAction>
    </AlertDialogFooter>
  </AlertDialogContent>
</AlertDialog>
```

---

## 11. 图表规范

统一使用 **recharts**，折线图为主要图表类型：

```jsx
<ResponsiveContainer width="100%" height={200}>
  <LineChart data={data}>
    <CartesianGrid strokeDasharray="3 3" stroke="#f0f0f0" />
    <XAxis dataKey="name" tick={{ fontSize: 11, fill: "#9ca3af" }} />
    <YAxis tick={{ fontSize: 11, fill: "#9ca3af" }} />
    <Tooltip />
    <Line dataKey="input"  stroke="#6366f1" strokeWidth={2} dot={false} name="输入" />
    <Line dataKey="output" stroke="#8b5cf6" strokeWidth={2} dot={false} name="输出" />
  </LineChart>
</ResponsiveContainer>
```

---

## 12. 关键约束（设计红线）

以下规则不可违反，违反即破坏设计一致性：

1. **禁止引入新的 CSS 框架或 UI 库**——只用 Tailwind CSS + shadcn/ui + 自定义样式。
2. **卡片用原生 div**——不用 shadcn Card，统一用 `rounded-2xl border border-gray-100` + inline boxShadow。
3. **表格用原生 `<table>`**——不用 shadcn Table。
4. **状态徽章只用三种**——`badge-running` / `badge-stopped` / `badge-pending`，不发明新的。
5. **图标只用 lucide-react**——禁止 emoji 当图标，禁止 FontAwesome 等第三方图标库。
6. **所有页面根元素必须包含 `page-enter` class**——保证页面进入动画统一。
7. **品牌渐变只用 inline style**——不用 Tailwind 渐变类（`from-blue-500 to-purple-600`）近似。
8. **卡片阴影只用 inline style**——使用统一的双层阴影值，不用 Tailwind `shadow-*` 类。
9. **toast 只用 sonner**——`toast.success()` / `toast.error()`，禁止 `alert()`。
10. **页面组件自包 Layout**——每页自己包裹 `<AdminLayout>` 或 `<TenantLayout>`，不在路由层嵌套。
11. **界面文案用简体中文**——所有可见文字均为简体中文。
12. **数据操作用 useState + mock 数据**——不直接调用后端 API。

---

## 13. 新页面设计 Checklist

创建任何新页面或组件前，逐项核对：

**布局层**
- [ ] 选择正确的 Layout（Admin 后台 / Tenant 员工端）
- [ ] 根元素包含 `page-enter` class
- [ ] 内容区 padding 和 max-width 符合规范

**视觉层**
- [ ] 卡片使用 `rounded-2xl border border-gray-100` + 统一 inline boxShadow
- [ ] 图标来自 lucide-react，尺寸符合使用场景
- [ ] 文字层级使用 `gray-900 / 700 / 500 / 400` 四档
- [ ] 品牌渐变通过 inline style 设置

**组件层**
- [ ] 表格使用原生 `<table>` + 规范 thead/tbody 类
- [ ] 按钮使用正确的 variant 和 size
- [ ] 状态徽章使用 `badge-running / stopped / pending`
- [ ] 间距遵循 4px 基准网格

**交互层**
- [ ] 操作反馈使用 `toast.success / error`（sonner）
- [ ] 空状态有友好提示 + 操作引导
- [ ] 危险操作使用 AlertDialog 二次确认
- [ ] 加载态有视觉反馈（按钮 disabled + animate-spin）
