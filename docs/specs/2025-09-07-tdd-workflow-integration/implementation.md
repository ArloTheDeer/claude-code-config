# 實作計畫

## PRD 參考

**PRD 文件路徑：** `docs/specs/2025-09-07-tdd-workflow-integration/prd.md`

> **重要提醒：** 實作過程中請經常參考 PRD 文件以了解：
>
> - 功能的商業目標和用戶價值
> - 完整的用戶故事和使用場景
> - 非功能性需求（性能、安全性等）
> - 系統架構和技術決策的背景脈絡

## 相關檔案

- `commands/process-task-list.md` - 需要整合 TDD 工作流程的主要命令檔案
- `commands/create-impl-plan.md` - 需要更新 TDD 標註格式的命令檔案
- `agents/tdd-developer.md` - 需要移除但保留內容的原 TDD agent 檔案
- `CLAUDE.md` - 需要更新 TDD agent 引用的主要文檔檔案
- `acceptance.feature` - Gherkin 格式的驗收測試場景

## 任務

- [x] 1. 整合 TDD 工作流程到 process-task-list.md
  - 1.1 讀取 agents/tdd-developer.md 的完整 TDD 工作流程內容
  - 1.2 在 process-task-list.md 中新增「TDD 開發流程」章節，取代原有的 agent 調用機制
  - 1.3 保留原有的 7 個 TDD 階段和所有核心規則
  - 1.4 更新任務識別邏輯，從檢測「使用 tdd-developer agent 進行開發」改為「使用 TDD 開發流程」
  - 1.5 確保語言設定保持一致（代碼和註解用英文，討論用繁體中文）

- [x] 2. 更新 create-impl-plan.md 的標註格式
  - 2.1 將第 26 行的建議文字從「使用 tdd-developer agent」改為「使用 TDD 開發流程」
  - 2.2 更新第 141 行的 TDD 開發標註說明
  - 2.3 將範例中的標註格式（第 144、153 行）從「使用 tdd-developer agent 進行開發」改為「使用 TDD 開發流程」
  - 2.4 更新相關的說明文字，移除對獨立 agent 的引用

- [x] 3. 更新系統文檔中的引用
  - 3.1 修改 CLAUDE.md 中第 32 行關於 tdd-developer agent 的描述
  - 3.2 搜尋並更新其他可能存在的 tdd-developer agent 引用
  - 3.3 確保所有文檔描述與新的整合架構一致

- [ ] 4. 移除 tdd-developer agent 檔案
  - 4.1 備份 agents/tdd-developer.md 的內容（已整合到 process-task-list.md）
  - 4.2 刪除 agents/tdd-developer.md 檔案
  - 4.3 確認移除後不會影響其他系統功能