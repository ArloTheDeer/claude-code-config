# language: zh-TW
功能: Process-Task-List 命令 TDD 任務分解增強功能
  作為 Claude Code 使用者
  我想要將標註 TDD 的任務自動分解為詳細步驟
  以便更好地追蹤 TDD 開發流程的進度

  背景:
    假設 存在 implementation.md 檔案包含任務清單
    並且 Claude Code 環境已安裝更新後的 process-task-list 命令

  場景: TDD 任務識別和分解
    假設 implementation.md 包含任務 "建立用戶認證功能 - 使用 TDD 開發流程"
    當 執行 process-task-list 命令並將任務標記為 in_progress
    那麼 TodoWrite 中應該出現 7 個子任務
    並且 子任務名稱包含 "建立用戶認證功能 - 先跑測試"
    並且 子任務名稱包含 "建立用戶認證功能 - 寫空介面"
    並且 子任務名稱包含 "建立用戶認證功能 - 寫測試敘述"
    並且 子任務名稱包含 "建立用戶認證功能 - 實作測試邏輯"
    並且 子任務名稱包含 "建立用戶認證功能 - 跑測試（紅燈階段）"
    並且 子任務名稱包含 "建立用戶認證功能 - 實作實際程式碼"
    並且 子任務名稱包含 "建立用戶認證功能 - 再次跑測試（綠燈階段）"

  場景: 非 TDD 任務保持原有行為
    假設 implementation.md 包含任務 "設定開發環境"（沒有 TDD 標註）
    當 執行 process-task-list 命令並將任務標記為 in_progress
    那麼 TodoWrite 中應該只有 1 個任務
    並且 任務名稱為 "設定開發環境"
    並且 不應該出現子任務分解

  場景: 動態任務展開機制
    假設 implementation.md 包含兩個 TDD 任務："任務A - 使用 TDD 開發流程" 和 "任務B - 使用 TDD 開發流程"
    當 只將 "任務A" 標記為 in_progress
    那麼 TodoWrite 中應該包含 7 個 "任務A" 的子任務
    並且 "任務B" 應該保持未展開狀態
    並且 "任務B" 在 TodoWrite 中顯示為單一任務

  場景: 子任務順序執行限制
    假設 TDD 任務已展開為 7 個子任務
    當 第一個子任務標記為 in_progress
    那麼 其他 6 個子任務應該保持 pending 狀態
    當 第一個子任務標記為 completed
    那麼 第二個子任務可以標記為 in_progress
    並且 其他 5 個子任務保持 pending 狀態

  場景: 母任務完成狀態同步
    假設 TDD 任務的 7 個子任務都已標記為 completed
    當 檢查任務狀態
    那麼 implementation.md 中的母任務應該標記為 [x]
    並且 implementation.md 中不應該包含 TDD 子任務的詳細狀態

  場景: 混合任務清單處理
    假設 implementation.md 包含："一般任務1"、"TDD任務 - 使用 TDD 開發流程"、"一般任務2"
    當 執行 process-task-list 命令
    那麼 TodoWrite 應該包含 3 個主要項目
    當 將 "TDD任務" 標記為 in_progress
    那麼 TodoWrite 應該包含 "一般任務1"、7個TDD子任務、"一般任務2"
    並且 一般任務保持原有的單一任務格式

  場景大綱: TDD 標註變體識別
    假設 implementation.md 包含任務 "<task_title>"
    當 執行 process-task-list 命令並將任務標記為 in_progress
    那麼 應該識別為 "<task_type>" 任務
    並且 子任務數量為 "<subtask_count>"

    例子:
      | task_title | task_type | subtask_count |
      | 實作API接口 - 使用 TDD 開發流程 | TDD | 7 |
      | 建立資料庫模型 - 使用TDD開發流程 | TDD | 7 |
      | 設定CI/CD流程 | 一般 | 1 |
      | 撰寫文件 | 一般 | 1 |