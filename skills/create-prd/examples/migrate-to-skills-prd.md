# 產品需求文件：Slash Commands 遷移至 Skills 格式

> 此為 PRD 範例，展示 `/create-prd` skill 的輸出格式。
> 原始文件位置：`docs/specs/2025-12-26-migrate-to-skills/prd.md`

## 簡介/概述

本專案旨在將 claude-code-config 現有的四個 Slash Commands 和一個 Agent 遷移至 Claude Code 的 Skills 格式。基於 `docs/research/2025-12-26-skills-vs-slash-commands.md` 的研究發現，Skills 提供更靈活的目錄結構、支援漸進式揭露（Progressive Disclosure），並且與業界趨勢一致。

遷移後，這些 workflow skills 將：
- 支援手動調用（`/skill-name`）和 Claude 自動判斷調用
- 採用目錄結構組織，可將大型指令拆分成多個檔案
- 遵循 Agent Skills 規範的漸進式揭露原則

## 目標

1. **完整遷移**：將四個 Slash Commands 和一個 Agent 轉換為 Skills 格式
2. **結構優化**：根據內容複雜度，將較大的指令檔案拆分成多個檔案
3. **安裝腳本更新**：修改安裝腳本以支援 Skills 目錄複製
4. **清理舊結構**：移除專案中的 `commands/` 和 `agents/` 目錄

## 使用者故事

### US-1：手動調用 Skill
作為一個開發者，我想要使用 `/research` 調用研究 skill，以便進行深入的技術研究和分析。

### US-2：Claude 自動判斷調用
作為一個開發者，當我詢問「幫我分析這個技術問題」時，我希望 Claude 能自動判斷並調用適當的 skill。

### US-3：安裝 Skills
作為一個開發者，我想要執行 `npm run install-config` 將 skills 安裝到 `~/.claude/skills/`。

### US-4：強制覆寫安裝
作為一個開發者，我想要使用 `npm run install-config -- overwrite` 強制覆寫現有的 skills。

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
└── process-task-list/
    └── SKILL.md
```

### FR-2：SKILL.md Frontmatter
每個 SKILL.md 必須包含符合規範的 frontmatter：
- `name`：小寫字母、數字和連字符，最多 64 字元
- `description`：說明 skill 的功能和使用時機，最多 1024 字元

### FR-3：漸進式揭露設計
Skills 必須遵循三層漸進式揭露原則：
- **Metadata**：name 和 description，啟動時載入
- **Instructions**：SKILL.md 主體，skill 被選中時載入
- **Resources**：scripts/、references/ 等目錄中的檔案，按需載入

## 非目標（超出範圍）

1. **不新增功能**：本次遷移專注於格式轉換，不新增 workflow 功能
2. **不修改工作流程邏輯**：現有流程保持不變

## 技術考量

### 遷移來源檔案
- `commands/research.md`（217 行）
- `commands/create-prd.md`（約 100 行）
- `commands/create-impl-plan.md`（419 行）- 需要拆分
- `commands/process-task-list.md`（256 行）

### 拆分判斷依據
根據 Agent Skills 規範，SKILL.md 建議控制在 500 行以內。對於超過此限制的檔案，應考慮拆分。

## 開放問題

1. **拆分細節**：create-impl-plan 的具體拆分方式將在實作規劃階段決定
2. **description 內容**：各 skill 的 description 具體措辭將在實作時確定

## 參考資料

- 研究文件：`docs/research/2025-12-26-skills-vs-slash-commands.md`
- Agent Skills 規範：https://agentskills.io/specification
- Claude Code Skills 官方文檔：https://code.claude.com/docs/en/skills
