# Claude Config - AI 助理工作流程指令集

## 專案簡介

這是一套為 Claude Code 和其他 AI 助理設計的標準化工作流程指令集，提供結構化的方法來處理軟體開發的各個階段，從需求研究、PRD 撰寫到實作任務管理。本專案包含自動化安裝腳本，可以輕鬆將所有指令安裝到您的 Claude Code 環境中。

本專案基於 [snarktank/ai-dev-tasks](https://github.com/snarktank/ai-dev-tasks) 的概念，並根據個人使用需求進行了客製化調整，特別針對繁體中文環境和 Claude Code 的特定功能進行了優化。

## 目錄結構

```
claude-config/
├── commands/                 # 工作流程指令文件
│   ├── research.md          # 研究與分析流程
│   ├── create-prd.md        # PRD 產生流程
│   ├── create-impl-plan.md  # 實作計畫產生流程
│   └── process-task-list.md # 任務清單管理流程
├── scripts/                 # 安裝腳本
│   └── install-config.js    # 自動安裝指令到 Claude Code
├── docs/                    # 產出文件目錄
│   ├── research/            # 研究文件
│   └── specs/               # 產品規格文件
├── package.json             # 專案配置
└── README.md                # 本文件
```

## 核心工作流程

### 1. 研究與分析 (`research.md`)

進行深入的問題研究和分析，為後續的 PRD 撰寫和實作提供基礎。

**主要功能：**

- 問題背景調查
- 程式碼庫分析
- 外部最佳實踐研究
- 解決方案評估與建議

**輸出：** `docs/research/[date]-[topic].md`

### 2. 產品需求文件 (`create-prd.md`)

基於研究結果或使用者需求，產生詳細的產品需求文件。

**主要功能：**

- 澄清需求細節
- 定義功能範圍
- 撰寫使用者故事
- 設定驗收標準

**輸出：** `docs/specs/[date]-[feature-name]/prd.md`

### 3. 實作計畫 (`create-impl-plan.md`)

將 PRD 轉換為可執行的開發任務清單和驗收測試。

**主要功能：**

- 分析 PRD 需求
- 評估現有程式碼
- 產生詳細任務清單
- 建立 Gherkin 格式驗收測試

**輸出：**

- `docs/specs/[prd-slug-name]/implementation.md` - 任務清單
- `docs/specs/[prd-slug-name]/acceptance.feature` - 驗收測試

### 4. 任務管理 (`process-task-list.md`)

管理和追蹤實作任務的完成進度。

**主要功能：**

- Claude Code TodoWrite 工具整合
- 任務狀態同步管理
- Git 提交流程整合
- 進度追蹤與報告

## 安裝

### 將指令安裝到 Claude Code

本專案提供自動化腳本，可以將所有工作流程指令安裝到您的 Claude Code 配置目錄：

```bash
# 首次安裝或更新指令
npm run install-config

# 強制覆蓋現有指令（當指令已存在時）
npm run install-config -- overwrite
```

**安裝位置：**
- Windows: `C:\Users\[username]\.claude\commands`
- macOS/Linux: `~/.claude/commands`

**安裝的指令檔案：**
- `research.md` - 研究與分析流程
- `create-prd.md` - PRD 產生流程  
- `create-impl-plan.md` - 實作計畫產生流程
- `process-task-list.md` - 任務清單管理流程

安裝完成後，您就可以在 Claude Code 中使用這些斜線指令，例如 `/research` 或 `/create-prd`。

## 使用流程

### 完整開發流程

```mermaid
graph LR
    A[使用者需求] --> B[研究分析]
    B --> C[撰寫 PRD]
    C --> D[產生實作計畫]
    D --> E[執行任務]
    E --> F[驗收測試]
```

### 快速開始

0. **安裝指令**（首次使用時）

   ```bash
   npm run install-config
   ```

1. **研究階段**（當需要深入了解問題時）

   ```
   請參考 commands/research.md 進行問題研究
   ```

2. **需求定義**

   ```
   請參考 commands/create-prd.md 產生 PRD
   ```

3. **實作規劃**

   ```
   請參考 commands/create-impl-plan.md 從 PRD 產生任務清單
   ```

4. **任務執行**
   ```
   請參考 commands/process-task-list.md 處理實作任務
   ```

## 特色功能

### Claude Code 專屬優化

- **TodoWrite 工具整合**：自動同步內部任務清單與 Markdown 文件
- **雙向任務同步**：確保任務狀態在不同介面間保持一致
- **智慧提交管理**：整合 Git 工作流程，自動產生語義化提交訊息

### 多語言支援

所有文件產出都會根據使用者的對話語言自動調整：

- 中文對話 → 繁體中文文件
- 英文對話 → 英文文件

### 驗收測試自動化

- 使用 Gherkin 格式定義驗收條件
- AI 可直接執行測試場景
- 支援終端指令和 MCP 瀏覽器操作

## 檔案輸出結構

專案執行後會產生以下結構的文件：

```
docs/
├── research/                        # 研究文件
│   └── [date]-[topic].md
└── specs/                          # 產品規格文件
    └── [date]-[feature-name]/
        ├── prd.md                  # PRD 文件
        ├── implementation.md       # 實作任務清單
        └── acceptance.feature      # 驗收測試場景
```

## 最佳實踐

1. **循序漸進**：依照研究 → PRD → 實作的順序進行
2. **充分澄清**：在每個階段都要詢問釐清問題
3. **持續同步**：保持任務狀態即時更新
4. **版本控制**：每完成一個任務就進行 Git 提交
5. **文件為先**：所有決策和進度都要記錄在文件中

## 適用對象

- 使用 Claude Code 的開發者
- 需要結構化開發流程的團隊
- 希望標準化 AI 助理工作方式的組織

## 授權

本專案採用 Apache 授權條款。
