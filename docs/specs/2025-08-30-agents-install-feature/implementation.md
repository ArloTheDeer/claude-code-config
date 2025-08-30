# 實作計畫

## PRD 參考

**PRD 文件路徑：** `docs/specs/2025-08-30-agents-install-feature/prd.md`

> **重要提醒：** 實作過程中請經常參考 PRD 文件以了解：
>
> - 功能的商業目標和用戶價值
> - 完整的用戶故事和使用場景
> - 非功能性需求（性能、安全性等）
> - 系統架構和技術決策的背景脈絡

## 相關檔案

- `scripts/install-config.js` - 現有的安裝腳本，需要擴展以支援 agents 目錄
- `agents/tdd-developer.md` - 現有的 agent 檔案，用於測試安裝功能
- `commands/*.md` - 現有的 command 檔案，用於參考安裝行為
- `package.json` - 包含 npm run install-config 腳本設定
- `acceptance.feature` - Gherkin 格式的驗收測試場景

## 任務

- [ ] 1. 重構共通安裝邏輯
  - 1.1 分析現有 `scripts/install-config.js` 中可重用的邏輯模塊
  - 1.2 建立 `installDirectoryFiles` 通用函數來處理單一目錄的安裝
  - 1.3 建立 `checkFileConflicts` 通用函數來檢測檔案衝突
  - 1.4 建立 `createTargetDirectory` 通用函數來建立目標目錄
  - 1.5 建立 `copyFilesWithLogging` 通用函數來複製檔案並記錄進度

- [ ] 2. 擴展主安裝流程以支援 agents 目錄
  - 2.1 修改主 `installConfig` 函數來處理多個目錄類型
  - 2.2 新增 agents 目錄的檔案掃描和列表生成
  - 2.3 整合 commands 和 agents 的衝突檢測邏輯
  - 2.4 實作統一的 overwrite 旗標處理機制
  - 2.5 更新安裝進度日誌以區分不同目錄類型

- [ ] 3. 實作 agents 目錄安裝功能
  - 3.1 新增對 `agents/*.md` 檔案的掃描和驗證
  - 3.2 實作 `~/.claude/agents` 目錄的建立邏輯
  - 3.3 實作 agents 檔案的複製和錯誤處理
  - 3.4 新增 agents 檔案安裝的成功/失敗統計
  - 3.5 實作與 commands 安裝一致的日誌格式和訊息

- [ ] 4. 整合錯誤處理和用戶反饋
  - 4.1 實作統一的錯誤處理策略（全成功或全失敗）
  - 4.2 新增詳細的安裝摘要報告，分別顯示 commands 和 agents 結果
  - 4.3 實作當 agents 目錄不存在或為空時的友善提示
  - 4.4 確保跨平台路徑處理的一致性
  - 4.5 新增適當的警告訊息和使用說明

- [ ] 5. 測試和品質保證
  - 5.1 測試在不同平台（Windows/macOS/Linux）的安裝行為
  - 5.2 測試 overwrite 旗標在兩種目錄類型中的行為一致性
  - 5.3 驗證檔案衝突檢測在混合安裝情境下的正確性
  - 5.4 測試當某個目錄缺失時的處理邏輯
  - 5.5 驗證所有日誌訊息和錯誤提示的準確性

- [ ] 6. 執行驗收測試
  - 6.1 使用 AI 讀取 acceptance.feature 檔案
  - 6.2 透過指令執行每個場景
  - 6.3 驗證所有場景通過並記錄結果