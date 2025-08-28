# 實作計畫

## PRD 參考

**PRD 文件路徑：** `docs/specs/2025-08-28-fix-overwrite-flag/prd.md`

> **重要提醒：** 實作過程中請經常參考 PRD 文件以了解：
>
> - 功能的商業目標和用戶價值
> - 完整的用戶故事和使用場景
> - 非功能性需求（性能、安全性等）
> - 系統架構和技術決策的背景脈絡

## 相關檔案

- `package.json` - npm 腳本配置，需要修改 install-config 腳本定義
- `scripts/install-config.js` - 主要安裝腳本，目前邏輯正確但參數接收有問題
- `commands/*.md` - 需要安裝的命令檔案（create-impl-plan.md、create-prd.md、process-task-list.md、research.md）
- `acceptance.feature` - Gherkin 格式的驗收測試場景

## 任務

- [x] 1. 分析參數傳遞問題的根本原因
  - 1.1 測試目前的參數傳遞機制，確認 `process.argv` 中的參數內容
  - 1.2 研究 npm CLI 對於 `--` 後參數的處理方式
  - 1.3 識別 "Unknown cli config" 警告的具體來源
  - 1.4 確認參數無法正確傳遞到腳本的確切原因

- [x] 2. 修復參數傳遞機制
  - 2.1 修改 `package.json` 中的 `install-config` 腳本配置，確保參數能正確傳遞
  - 2.2 如果需要，調整 `scripts/install-config.js` 中的參數解析方式
  - 2.3 消除 npm "Unknown cli config" 警告訊息
  - 2.4 確保 `--overwrite` 參數能正確設定 `hasOverwriteFlag` 變數

- [ ] 3. 執行驗收測試
  - 3.1 使用 AI 讀取 acceptance.feature 檔案
  - 3.2 透過終端指令執行每個場景
  - 3.3 驗證所有場景通過並記錄結果