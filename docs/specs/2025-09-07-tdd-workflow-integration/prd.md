# TDD 開發流程整合重構

## 簡介/概述

將獨立的 `tdd-developer.md` agent 整合到 `process-task-list.md` 命令中，解決 TDD 開發流程中 context 不連續導致的開發不順暢問題。目標是保持 TDD 開發流程的完整性，同時確保開發過程中的脈絡連續性。

## 目標

1. **消除 context 不連續問題**：將 TDD 流程從獨立 agent 整合到主要工作流程中
2. **保持 TDD 流程完整性**：完全保留原有的 red-green-refactor 循環和測試優先原則
3. **簡化工作流程**：減少獨立 agent 調用，提供更流暢的開發體驗
4. **更新標註格式**：將任務標註從「使用 tdd-developer agent 進行開發」改為「使用 TDD 開發流程」
5. **清理相依性**：移除所有對 tdd-developer agent 的引用

## 使用者故事

1. **作為開發者**，我希望在執行 `/process-task-list` 時，當遇到標註為「使用 TDD 開發流程」的任務時，能夠自動啟用 TDD 開發模式，而不需要切換到獨立的 agent context。

2. **作為開發者**，我希望在 TDD 開發過程中能夠保持對前面步驟的記憶，包括測試結果、代碼狀態和開發進度，以確保開發流程的連續性。

3. **作為系統維護者**，我希望能夠移除 `agents/tdd-developer.md` 檔案，並更新所有相關的引用和標註格式，保持系統架構的一致性。

## 功能需求

1. **TDD 流程整合**：在 `process-task-list.md` 中新增專門處理 TDD 任務的章節
2. **標註格式更新**：將 `create-impl-plan.md` 中的任務標註格式從「使用 tdd-developer agent 進行開發」改為「使用 TDD 開發流程」
3. **TDD 工作流程保留**：完全保留原 `tdd-developer.md` 中的所有 TDD 工作流程和規則
4. **檔案清理**：移除 `agents/tdd-developer.md` 檔案
5. **相依性更新**：更新所有相關文件中對 tdd-developer agent 的引用
6. **任務識別邏輯**：當 `process-task-list` 命令識別到任務標題包含「使用 TDD 開發流程」時，自動啟用 TDD 模式
7. **語言支援**：保持原有的語言設定（代碼和註解用英文，討論用繁體中文）

## 非目標（超出範圍）

1. **修改 TDD 核心流程**：不改變原有的 red-green-refactor 循環
2. **向後相容性**：不需要支援舊的「使用 tdd-developer agent 進行開發」標註格式
3. **新增額外功能**：只專注於整合現有功能，不添加新的 TDD 特性
4. **其他 agent 整合**：此次重構僅針對 tdd-developer agent

## 設計考量

1. **章節結構**：在 `process-task-list.md` 中新增「TDD 任務處理」章節，包含完整的 TDD 工作流程說明
2. **標註檢測**：使用字串匹配來識別任務是否需要 TDD 流程
3. **工作流程整合**：將 TDD 的七個階段（運行現有測試、創建空實現、撰寫測試描述等）直接嵌入到 process-task-list 的處理邏輯中

## 技術考量

1. **相依性檢查**：需要檢查並更新以下文件中的 tdd-developer 引用：
   - `commands/create-impl-plan.md` （第 26、141、144、153 行）
   - `commands/process-task-list.md` （多處引用）
   - `CLAUDE.md` （第 32 行）
   - 其他可能的引用

2. **安裝腳本影響**：需要確認 `scripts/install-config.js` 是否需要更新以處理 agents 目錄的變化

## 開放問題

1. 現有的 implementation.md 檔案中是否有使用舊標註格式的任務需要手動更新？
2. 是否需要在文檔中記錄這次架構變更的原因和影響？

## 參考資料

- `agents/tdd-developer.md` - 原有 TDD agent 實現
- `commands/create-impl-plan.md` - TDD 標註格式定義
- `commands/process-task-list.md` - 目前的任務處理流程