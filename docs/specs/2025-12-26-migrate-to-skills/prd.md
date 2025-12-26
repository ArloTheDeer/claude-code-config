# 產品需求文件：Slash Commands 遷移至 Skills 格式

## 簡介/概述

本專案旨在將 claude-code-config 現有的四個 Slash Commands 和一個 Agent 遷移至 Claude Code 的 Skills 格式。基於 `docs/research/2025-12-26-skills-vs-slash-commands.md` 的研究發現，Skills 提供更靈活的目錄結構、支援漸進式揭露（Progressive Disclosure），並且與業界趨勢一致（如 GitHub Copilot 已開始支援 Agent Skills）。

遷移後，這些 workflow skills 將：
- 支援手動調用（`/skill-name`）和 Claude 自動判斷調用
- 採用目錄結構組織，可將大型指令拆分成多個檔案
- 遵循 Agent Skills 規範的漸進式揭露原則

## 目標

1. **完整遷移**：將四個 Slash Commands（research、create-prd、create-impl-plan、process-task-list）和一個 Agent（acceptance-tester）轉換為 Skills 格式
2. **結構優化**：根據內容複雜度，將較大的指令檔案拆分成多個檔案，實現漸進式揭露
3. **安裝腳本更新**：修改 `install-config.js` 以支援 Skills 目錄複製，完全取代 Commands 支援
4. **清理舊結構**：移除專案中的 `commands/` 和 `agents/` 目錄

## 使用者故事

### US-1：手動調用 Skill
作為一個開發者，我想要使用 `/research` 調用研究 skill，以便進行深入的技術研究和分析。

### US-2：Claude 自動判斷調用
作為一個開發者，當我詢問「幫我分析這個技術問題」時，我希望 Claude 能自動判斷並調用適當的 skill（如 research），以便獲得結構化的研究結果。

### US-3：安裝 Skills
作為一個開發者，我想要執行 `npm run install-config` 將 skills 安裝到 `~/.claude/skills/`，以便在所有專案中使用這些 workflow skills。

### US-4：強制覆寫安裝
作為一個開發者，我想要使用 `npm run install-config -- overwrite` 強制覆寫現有的 skills，以便更新到最新版本。

### US-5：自動清理舊 Commands
作為一個開發者，當我安裝新的 skills 時，系統應該自動檢查 `~/.claude/commands/` 是否存在同名的舊 slash commands，並自動刪除它們，以避免新舊格式衝突。

## 功能需求

### FR-1：Skills 目錄結構
系統必須在專案中建立以下 skills 目錄結構：
```
skills/
├── research/
│   └── SKILL.md
├── create-prd/
│   └── SKILL.md
├── create-impl-plan/
│   ├── SKILL.md
│   └── [拆分出的參考檔案]
├── process-task-list/
│   ├── SKILL.md
│   └── [拆分出的參考檔案]
└── acceptance-tester/
    └── SKILL.md
```

### FR-2：SKILL.md Frontmatter
每個 SKILL.md 必須包含符合規範的 frontmatter：
- `name`：小寫字母、數字和連字符，最多 64 字元
- `description`：說明 skill 的功能和使用時機，包含觸發關鍵詞，最多 1024 字元

### FR-3：漸進式揭露設計
Skills 必須遵循三層漸進式揭露原則：
- **Metadata（約 100 tokens）**：name 和 description，啟動時載入
- **Instructions（建議 < 5000 tokens）**：SKILL.md 主體，skill 被選中時載入
- **Resources（按需載入）**：scripts/、references/ 等目錄中的檔案

### FR-4：description 撰寫策略
description 必須：
- 清楚說明 skill 做什麼
- 包含使用時機的觸發關鍵詞
- 描述與其他 skills 的關係（如工作流程順序）

### FR-5：大檔案拆分
對於內容較多的 skills（如 create-impl-plan、process-task-list），應將詳細參考資料拆分到獨立檔案，主 SKILL.md 透過連結引用。

### FR-6：安裝腳本更新
`install-config.js` 必須：
- 支援複製整個 skill 目錄（而非單一檔案）
- 目標位置為 `~/.claude/skills/`
- 支援衝突檢測和 overwrite 選項
- 移除對 commands 和 agents 的支援

### FR-7：自動清理舊 Commands
安裝腳本必須：
- 檢查 `~/.claude/commands/` 是否存在與 skills 同名的 `.md` 檔案
- 對於每個要安裝的 skill，檢查是否存在對應的 `~/.claude/commands/[skill-name].md`
- 如果存在，自動刪除該舊 command 檔案
- 顯示清理訊息告知使用者哪些舊 commands 被移除

### FR-8：舊結構清理
遷移完成後，專案必須：
- 移除 `commands/` 目錄
- 移除 `agents/` 目錄

### FR-9：acceptance-tester 遷移
將 `agents/acceptance-tester.md` 遷移為 `skills/acceptance-tester/SKILL.md`，保留原有功能但改為 skill 格式。

## 非目標（超出範圍）

1. **不新增功能**：本次遷移專注於格式轉換，不新增 workflow 功能
2. **不建立 spec-driven-workflow skill**：不需要建立描述整體流程的獨立 skill
3. **不修改工作流程邏輯**：research → create-prd → create-impl-plan → process-task-list 的流程保持不變
4. **不設定 disable-model-invocation**：保留預設的雙向調用行為

## 技術考量

### 遷移來源檔案
- `commands/research.md`（217 行）
- `commands/create-prd.md`（約 100 行）
- `commands/create-impl-plan.md`（419 行）- 需要拆分
- `commands/process-task-list.md`（256 行）- 可能需要拆分
- `agents/acceptance-tester.md`（108 行）

### 拆分判斷依據
根據 Agent Skills 規範，SKILL.md 建議控制在 500 行以內。對於超過此限制或包含獨立邏輯區塊的檔案，應考慮拆分。

### 安裝腳本技術
- 使用 shelljs 進行跨平台目錄操作
- 需要遞迴複製目錄結構
- 保留現有的衝突檢測邏輯

## 開放問題

1. **拆分細節**：create-impl-plan 和 process-task-list 的具體拆分方式將在實作規劃階段決定
2. **description 內容**：各 skill 的 description 具體措辭將在實作時確定

## 參考資料

- 研究文件：`docs/research/2025-12-26-skills-vs-slash-commands.md`
- Agent Skills 規範：https://agentskills.io/specification
- Claude Code Skills 官方文檔：https://code.claude.com/docs/en/skills
- GitHub Issue #10246：https://github.com/anthropics/claude-code/issues/10246
