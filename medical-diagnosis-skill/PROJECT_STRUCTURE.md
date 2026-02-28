# 项目结构说明

## 📁 目录结构

```
medical-diagnosis-skill/
│
├── 📄 SKILL.md                               # 🌟 主技能文档（AI使用）
│   ├── 技能触发规则
│   ├── 鉴别诊断排除流程 ⭐ v1.1
│   ├── 渐进式问诊流程 ⭐ v1.2
│   ├── 结构化问诊树
│   ├── TNSS评分系统
│   ├── 阶梯治疗决策
│   ├── 安全用药规则
│   ├── AI工作流程
│   └── 回复模板
│
├── 📄 README.md                              # 📖 项目说明（开发者阅读）
│   ├── 功能特性
│   ├── 文件结构
│   ├── 核心算法
│   ├── 使用示例
│   └── 安全保障
│
├── 📄 QUICKSTART.md                          # 🚀 快速入门（新用户）
│   ├── 5分钟快速上手
│   ├── 典型使用场景
│   ├── 技能触发关键词
│   ├── 测试技能
│   └── 配置文件说明
│
├── 📄 PROGRESSIVE_QUESTIONING.md             # 🎯 渐进式问诊设计 ⭐ v1.2
│   ├── 设计原则
│   ├── 6个问诊阶段详细设计
│   ├── 智能决策逻辑
│   ├── 完整对话示例
│   └── 问题数量统计
│
├── 📄 CHANGELOG.md                           # 📝 更新日志（版本历史）
│   ├── v1.1 (2026-02-28) ⭐ 当前版本
│   │   ├── 逐步鉴别诊断流程
│   │   ├── 智能购药流程
│   │   └── 增强用药随访
│   └── v1.0 (2026-02-28)
│       └── 初始版本
│
├── 📄 OPTIMIZATION_SUMMARY.md                # 📊 优化总结（本次更新详情）
│   ├── 优化目标
│   ├── 核心优化：逐步鉴别诊断
│   ├── 购药流程优化
│   ├── 随访管理优化
│   ├── 测试验证
│   └── 技术亮点
│
├── 📄 PROJECT_STRUCTURE.md                   # 📁 本文件（项目结构说明）
│
├── 📄 疾病试做内容.pdf                       # 📚 参考文档
│   └── AI临床思维总逻辑-过敏性鼻炎（示例）
│
├── 📂 scripts/                               # 💻 代码实现
│   └── 📄 ar_diagnosis.py                    # Python诊断算法
│       ├── Symptoms 类（症状评分）
│       ├── ARDiagnostic 类（诊断分类）
│       │   ├── classify_severity() - 严重程度
│       │   ├── classify_pattern() - 病程分型
│       │   └── differential_diagnosis() ⭐ 鉴别诊断（重构）
│       ├── TreatmentPlanner 类（治疗方案）
│       │   ├── generate_treatment_plan() - 生成方案
│       │   ├── _pregnancy_plan() - 孕妇方案
│       │   └── _lactation_plan() - 哺乳期方案
│       ├── DangerSignalDetector 类（危险信号）
│       └── 6个测试示例 ⭐ 新增
│
├── 📂 references/                            # 📚 参考数据
│   ├── 📄 medication_database.json           # 药物数据库
│   │   ├── nasal_corticosteroids（鼻用激素）
│   │   ├── oral_antihistamines（口服抗组胺）
│   │   ├── nasal_antihistamines（鼻用抗组胺）
│   │   ├── leukotriene_antagonists（白三烯拮抗剂）
│   │   ├── decongestants（减充血剂）
│   │   └── saline_irrigation（鼻腔冲洗）
│   │
│   └── 📄 contraindications.json             # 禁忌症与安全规则
│       ├── special_populations（特殊人群）
│       │   ├── pregnancy（孕妇）
│       │   ├── lactation（哺乳期）
│       │   ├── children（儿童）
│       │   └── elderly（老年人）
│       ├── comorbidities（合并疾病）
│       │   ├── glaucoma（青光眼）
│       │   ├── benign_prostatic_hyperplasia（前列腺增生）
│       │   ├── hypertension（高血压）
│       │   ├── diabetes（糖尿病）
│       │   ├── heart_disease（心脏病）
│       │   ├── asthma（哮喘）
│       │   ├── liver_disease（肝病）
│       │   └── kidney_disease（肾病）
│       ├── drug_interactions（药物相互作用）
│       ├── adverse_reactions（不良反应）
│       └── emergency_conditions（紧急情况）
│
└── 📂 examples/                              # 📖 示例文档
    ├── 📄 conversation_examples.md           # 对话示例
    │   ├── 普通成人患者
    │   ├── 孕妇患者
    │   ├── 儿童患者
    │   ├── 合并哮喘患者
    │   └── 危险信号处理
    │
    └── 📄 differential_diagnosis_examples.md # 鉴别诊断示例 ⭐ 新增
        ├── 示例1：排除感冒 → 确诊AR
        ├── 示例2：识别感冒，不进入AR流程
        ├── 示例3：识别鼻窦炎，提示就医
        ├── 示例4：识别血管运动性鼻炎
        └── 鉴别诊断逻辑流程图
```

---

## 📋 文件说明

### 核心文档（必读）

#### 1. SKILL.md - 主技能文档 🌟
**用途**：AI使用的完整指南  
**内容**：
- 技能触发规则（关键词、场景）
- **鉴别诊断排除流程**（v1.1新增）
- 结构化问诊树（症状、病程、诱因等）
- TNSS评分系统（0-12分）
- 分型分度规则（间歇性/持续性、轻/中/重）
- 阶梯治疗决策树
- 安全用药规则（禁忌症、特殊人群）
- AI工作流程（6个Phase）
- 回复模板

**适用对象**：AI系统、技能开发者

---

#### 2. README.md - 项目说明 📖
**用途**：项目概览和快速理解  
**内容**：
- 功能特性一览
- 文件结构说明
- 核心算法介绍（鉴别诊断、TNSS评分、分型分度）
- 使用示例
- 安全保障机制
- 技能优势对比
- 开发者指南

**适用对象**：新接触项目的开发者、贡献者

---

#### 3. QUICKSTART.md - 快速入门 🚀
**用途**：5分钟上手指南  
**内容**：
- 技能自动激活规则
- 基本对话流程图
- 核心功能一览表
- 典型使用场景（4个）
- 技能触发关键词表
- 测试技能方法
- 配置文件说明
- 常见问题FAQ

**适用对象**：新用户、快速测试者

---

### 更新文档

#### 4. CHANGELOG.md - 更新日志 📝
**用途**：版本历史记录  
**内容**：
- v1.1版本（2026-02-28）
  - 新增功能：鉴别诊断、购药流程、随访管理
  - 功能优化：文档、代码、测试
  - 测试结果：6个示例
  - 关键改进点
- v1.0版本（初始）

**适用对象**：维护者、用户（了解更新内容）

---

#### 5. OPTIMIZATION_SUMMARY.md - 优化总结 📊
**用途**：本次优化详细说明  
**内容**：
- 优化目标（逐步鉴别诊断）
- 核心优化详解（鉴别诊断流程设计）
- 购药流程优化（5类用户偏好）
- 随访管理优化（4种调整策略）
- 测试验证（6个测试用例）
- 文件更新清单
- 优化效果对比表
- 符合PDF文档要求检查

**适用对象**：技术人员、审核者

---

#### 6. PROJECT_STRUCTURE.md - 项目结构 📁
**用途**：本文件，项目结构导航  
**内容**：
- 目录结构树状图
- 文件说明
- 使用指南
- 开发工作流

**适用对象**：所有人（快速定位文件）

---

### 代码实现

#### 7. scripts/ar_diagnosis.py - 诊断算法 💻
**用途**：Python实现的诊断逻辑  
**内容**：
- `Symptoms` 类：症状评分（TNSS）
- `ARDiagnostic` 类：诊断分类
  - `classify_severity()` - 分度（轻/中/重）
  - `classify_pattern()` - 分型（间歇/持续）
  - **`differential_diagnosis()` - 鉴别诊断**（v1.1重构）
- `TreatmentPlanner` 类：治疗方案生成
  - `generate_treatment_plan()` - 通用方案
  - `_pregnancy_plan()` - 孕妇方案
  - `_lactation_plan()` - 哺乳期方案
- `DangerSignalDetector` 类：危险信号检测
- 6个测试示例（v1.1新增）

**运行测试**：
```bash
cd /Users/alfredhuang/Documents/UGit/AI_Project/my_skills/medical-diagnosis-skill
python3 scripts/ar_diagnosis.py
```

**适用对象**：开发者、测试人员

---

### 参考数据

#### 8. references/medication_database.json - 药物数据库 📚
**用途**：药物信息库  
**内容**：
- 鼻用糖皮质激素（3种）
- 口服抗组胺药（4种）
- 鼻用抗组胺药（1种）
- 白三烯受体拮抗剂（1种）
- 减充血剂（1种）
- 生理盐水鼻腔冲洗

每种药物包含：
- 名称（中文 + 通用名）
- 用法用量（成人/儿童）
- 起效时间
- 安全性分级
- 价格区间

**适用对象**：治疗方案生成模块

---

#### 9. references/contraindications.json - 禁忌症规则 📚
**用途**：安全用药规则库  
**内容**：
- 特殊人群（孕妇、哺乳期、儿童、老年人）
- 合并疾病（青光眼、前列腺增生、高血压等8种）
- 药物相互作用
- 不良反应列表
- 紧急情况处理

**适用对象**：安全检查模块

---

### 示例文档

#### 10. examples/conversation_examples.md - 对话示例 📖
**用途**：典型对话流程展示  
**内容**：
- 普通成人患者完整问诊
- 孕妇特殊人群处理
- 儿童患者用药调整
- 合并哮喘患者管理
- 危险信号立即响应

**适用对象**：理解AI对话流程的用户

---

#### 11. examples/differential_diagnosis_examples.md - 鉴别诊断示例 📖
**用途**：鉴别诊断对话展示（v1.1新增）  
**内容**：
- 示例1：排除感冒 → 确诊过敏性鼻炎
- 示例2：识别感冒，不进入AR流程
- 示例3：识别鼻窦炎，提示就医
- 示例4：识别血管运动性鼻炎
- 鉴别诊断逻辑流程图
- 关键要点总结

**适用对象**：理解鉴别诊断逻辑的用户、开发者

---

### 参考文档

#### 12. 疾病试做内容.pdf - 原始需求文档 📚
**用途**：本次优化的依据  
**内容**：
- AI临床思维总逻辑
- 识别主诉规则
- **快速排除规则**（本次优化核心）
- 问诊树设计
- 分型分度规则
- 用药规则
- 购药流程
- 用药调整规则

**适用对象**：了解需求背景的开发者

---

## 🚀 使用指南

### 新用户入门
```
1. 阅读 README.md - 了解项目概况
2. 阅读 QUICKSTART.md - 快速上手
3. 运行测试 - python3 scripts/ar_diagnosis.py
4. 查看示例 - examples/*.md
```

### 开发者指南
```
1. 阅读 SKILL.md - 了解完整逻辑
2. 查看 ar_diagnosis.py - 理解代码实现
3. 阅读 OPTIMIZATION_SUMMARY.md - 了解最新优化
4. 参考 references/*.json - 数据结构
5. 查看 CHANGELOG.md - 版本历史
```

### AI使用指南
```
1. 加载 SKILL.md - 主技能文档
2. 参考 references/*.json - 药物和禁忌症数据
3. 参考 examples/*.md - 对话示例（可选）
```

---

## 🛠️ 开发工作流

### 添加新药物
```
1. 编辑 references/medication_database.json
2. 添加药物信息（名称、剂量、安全性等）
3. 更新 SKILL.md 中的用药列表（如需要）
4. 运行测试验证
```

### 添加新禁忌症
```
1. 编辑 references/contraindications.json
2. 添加疾病或药物相互作用规则
3. 更新 ar_diagnosis.py 中的安全检查逻辑
4. 运行测试验证
```

### 添加新疾病鉴别
```
1. 更新 ar_diagnosis.py - differential_diagnosis()
2. 添加新疾病的评分标准
3. 更新 SKILL.md - 鉴别诊断章节
4. 添加测试用例
5. 更新 examples/differential_diagnosis_examples.md
```

### 扩展新疾病支持
```
1. 复制 medical-diagnosis-skill 为新疾病目录
2. 修改 SKILL.md - 更新疾病名称、症状、评分系统
3. 更新 references/*.json - 替换药物和禁忌症数据
4. 修改 ar_diagnosis.py - 实现新疾病诊断类
5. 添加测试用例
6. 更新文档
```

---

## 📊 关键指标

### 文档覆盖率
- ✅ 用户文档：README.md, QUICKSTART.md
- ✅ 技术文档：SKILL.md, ar_diagnosis.py
- ✅ 示例文档：conversation_examples.md, differential_diagnosis_examples.md
- ✅ 维护文档：CHANGELOG.md, OPTIMIZATION_SUMMARY.md, PROJECT_STRUCTURE.md

### 代码质量
- ✅ 类型注解：100%覆盖
- ✅ 文档字符串：所有函数都有
- ✅ 测试用例：6个典型场景
- ✅ 代码注释：关键逻辑都有说明

### 功能完整性
- ✅ 鉴别诊断：3种疾病排除
- ✅ 症状评分：TNSS 0-12分
- ✅ 分型分度：2x3矩阵
- ✅ 治疗方案：阶梯治疗
- ✅ 安全检查：8种合并疾病 + 4种特殊人群
- ✅ 危险预警：4类紧急情况
- ✅ 购药流程：5类用户偏好
- ✅ 随访管理：4种调整策略

---

## 🎯 版本信息

**当前版本**: v1.1  
**更新日期**: 2026-02-28  
**主要更新**: 逐步鉴别诊断 + 购药流程 + 随访管理  
**基于文档**: AI临床思维总逻辑-过敏性鼻炎（示例）

---

## 📞 帮助与支持

### 快速查找
- 不知道从哪开始？→ 阅读 `README.md`
- 想快速测试？→ 阅读 `QUICKSTART.md`
- 了解最新更新？→ 阅读 `CHANGELOG.md`
- 理解鉴别诊断？→ 阅读 `examples/differential_diagnosis_examples.md`
- 了解优化细节？→ 阅读 `OPTIMIZATION_SUMMARY.md`
- 查看代码实现？→ 查看 `scripts/ar_diagnosis.py`
- 查看完整逻辑？→ 阅读 `SKILL.md`

### 测试运行
```bash
# 进入项目目录
cd /Users/alfredhuang/Documents/UGit/AI_Project/my_skills/medical-diagnosis-skill

# 运行诊断测试
python3 scripts/ar_diagnosis.py

# 预期输出：6个测试示例，包括鉴别诊断、完整流程、特殊人群等
```

---

**文档创建日期**: 2026-02-28  
**维护者**: Medical AI Team  
**最后更新**: v1.1 优化完成
