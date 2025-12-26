# Skills 與 Slash Commands 研究報告

> 此為研究文件範例，展示 `/research` skill 的輸出格式。
> 原始文件位置：`docs/research/2025-12-26-skills-vs-slash-commands.md`

## 執行摘要

本研究針對 Claude Code 中 Skills 與 Slash Commands 的差異進行深入分析，目的是評估將現有的四個 workflow commands 遷移到 Skills 格式的可行性和價值。

經過調查發現，Claude Code 近期確實在內部將 Slash Commands 統一透過「Skill tool」來調用，這解釋了你觀察到的行為變化。然而，兩者在設計意圖上仍有明確區隔：Slash Commands 強調用戶手動調用，Skills 強調 Claude 自動發現和調用。對於你的 workflow commands 來說，遷移到 Skills 可以獲得更靈活的檔案組織結構，同時保留手動調用的能力。

## 背景與脈絡

你目前維護一個 claude-code-config 專案，提供四個 workflow slash commands：

- `/research`：深入研究技術問題
- `/create-prd`：產生產品需求文件
- `/create-impl-plan`：從 PRD 生成實作任務清單
- `/process-task-list`：執行任務清單

這些 commands 構成一個規範驅動的開發流程，安裝到 `~/.claude/commands/` 供個人使用。最近你觀察到 Claude Code 在調用這些 commands 時，介面顯示「正在呼叫一個 skill」，這引發了對兩者關係的疑問。

## 研究問題與發現過程

最初的問題是：「為什麼 Claude Code 把我的 slash commands 當作 skills？」經過調查後發現，這並非錯誤，而是 Claude Code 內部架構的設計選擇。更深層的問題變成：「Skills 是否比 Slash Commands 更適合這個 workflow 專案？」

## 技術分析：深入理解差異

### 內部機制的統一性

根據 [GitHub Issue #13115](https://github.com/anthropics/claude-code/issues/13115) 的討論，Anthropic 員工 dicksontsai 確認了一個關鍵事實：Skills 和 Slash Commands 在實際運作上幾乎相同。兩者都可以：

- 由用戶使用斜線前綴調用
- 由 Claude 自己調用
- 將指令載入對話中

這解釋了為什麼你看到 Claude 說「正在調用 skill」——因為內部統一使用 Skill tool 來處理這類擴展功能。

### 設計意圖的差異

儘管內部機制相似，兩者的設計意圖仍然不同：

| 面向 | Slash Commands | Skills |
|------|----------------|--------|
| 主要調用者 | 用戶手動輸入 `/command` | Claude 自動判斷使用 |
| 發現方式 | 顯式調用 | 基於描述的語義匹配 |
| 檔案結構 | 單一 `.md` 檔案 | 目錄結構，含 `SKILL.md` + 資源 |
| 適用場景 | 簡單、重複的任務 | 複雜的多步驟工作流程 |

### User-Invocable Skills 的概念

一個重要的發現是：Skills 也可以被用戶手動調用。根據官方文檔，用戶可以使用 `/<skill-name>` 的方式調用 skill，這與 slash commands 的調用方式相同。

## 解決方案評估

### 方案一：維持現狀（Slash Commands）

**優點：**
- 無需任何遷移工作
- 已經穩定運作

**缺點：**
- 單一檔案限制，難以拆分內容
- 可能逐漸被視為過時方式

**風險等級：** 低

### 方案二：遷移到 Skills

**優點：**
- 可將大型 command 檔案拆分成多個邏輯單元
- 保留手動調用能力（user-invocable）
- 與業界趨勢一致（GitHub Copilot 支援）

**缺點：**
- 需要重新設計目錄結構
- 需要更新安裝腳本

**風險等級：** 中

## 建議與決策指引

基於分析結果，建議採用**方案二：遷移到 Skills**。主要考量如下：

1. **檔案組織彈性**：commands 已經相當龐大，拆分成多個檔案可以提高可維護性。
2. **保留手動調用**：Skills 支援 user-invocable，遷移後仍可使用 `/create-prd` 等方式調用。
3. **未來相容性**：GitHub Copilot 等工具開始支援 Skills 格式，保持與業界標準一致。

## 下一步行動計畫

**立即行動：**
1. 建立 PRD 文件，定義遷移的詳細需求
2. 確認 Skills 的 user-invocable 行為

**中期目標：**
1. 更新安裝腳本支援 skills 目錄複製
2. 將四個 commands 轉換為 skills

## 參考資料

### 技術文件
- [Claude Code Skills 官方文檔](https://code.claude.com/docs/en/skills)
- [Claude Code Slash Commands 官方文檔](https://code.claude.com/docs/en/slash-commands)

### 社群討論
- [Consider merging Skills and Slash Commands - GitHub Issue #13115](https://github.com/anthropics/claude-code/issues/13115)

### 業界趨勢
- [GitHub Copilot now supports agent skills](https://github.blog/changelog/2025-12-18-github-copilot-now-supports-agent-skills/)
