# language: zh-TW
功能: TDD 開發流程整合重構
  作為 開發者
  我想要 將 TDD 開發流程從獨立 agent 整合到 process-task-list 命令中
  以便 解決 context 不連續問題並提供更流暢的開發體驗

  背景:
    假設 系統中存在 agents/tdd-developer.md 檔案
    並且 commands/process-task-list.md 引用 tdd-developer agent
    並且 commands/create-impl-plan.md 使用舊的標註格式

  場景: TDD 工作流程成功整合到 process-task-list
    假設 我讀取 agents/tdd-developer.md 的完整內容
    當 我將 TDD 工作流程整合到 commands/process-task-list.md 中
    那麼 process-task-list.md 應該包含完整的 TDD 開發流程章節
    並且 應該包含原有的 7 個 TDD 階段說明
    並且 任務識別邏輯應該檢測「使用 TDD 開發流程」標註
    並且 不再使用 Task 工具調用 tdd-developer agent

  場景: 標註格式成功更新
    假設 commands/create-impl-plan.md 使用舊的「使用 tdd-developer agent 進行開發」標註
    當 我更新 create-impl-plan.md 中的標註格式
    那麼 所有「使用 tdd-developer agent 進行開發」應該改為「使用 TDD 開發流程」
    並且 相關的說明文字應該移除對獨立 agent 的引用
    並且 TDD 開發標註章節應該反映新的整合方式

  場景: 系統文檔引用成功更新
    假設 CLAUDE.md 和其他文檔包含對 tdd-developer agent 的引用
    當 我更新所有相關文檔中的引用
    那麼 CLAUDE.md 不應該包含「tdd-developer agent」的描述
    並且 所有文檔應該與新的整合架構保持一致
    並且 不應該存在任何對已移除 agent 的引用

  場景: 現有範例檔案成功清理
    假設 docs/specs/2025-08-30-agents-install-feature/implementation.md 包含舊標註格式
    當 我檢查並更新現有範例檔案
    那麼 所有範例檔案中的標註應該使用新格式「使用 TDD 開發流程」
    並且 範例檔案應該與新的標註格式保持一致

  場景: tdd-developer agent 檔案成功移除
    假設 agents/tdd-developer.md 檔案存在
    並且 其內容已經整合到 process-task-list.md 中
    當 我移除 agents/tdd-developer.md 檔案
    那麼 agents/tdd-developer.md 檔案應該不存在
    並且 移除後不應該影響其他系統功能
    並且 TDD 工作流程功能應該通過 process-task-list 正常運作

  場景: 安裝腳本相容性驗證
    假設 scripts/install-config.js 支援 agents 目錄安裝
    並且 agents 目錄不再包含 tdd-developer.md 檔案
    當 我執行安裝腳本
    那麼 安裝過程應該正常完成而不出現錯誤
    並且 應該成功安裝 commands 目錄中的檔案
    並且 不應該因為 agents 目錄為空或檔案較少而失敗

  場景大綱: TDD 工作流程功能保留驗證
    假設 新的整合方式已經實施
    並且 任務標註為 "使用 TDD 開發流程"
    當 AI 執行 process-task-list 命令處理該任務
    那麼 應該執行完整的 TDD 工作流程
    並且 應該包含 "<tdd_phase>" 階段
    並且 應該保持原有的語言設定（代碼英文，討論中文）

    例子:
      | tdd_phase |
      | 運行現有測試 |
      | 創建空實現 |
      | 撰寫測試描述 |
      | 實現測試邏輯 |
      | 運行測試（紅燈階段） |
      | 實現實際代碼 |
      | 運行測試（綠燈階段） |

  場景: Context 連續性問題解決驗證
    假設 使用舊的 tdd-developer agent 會出現 context 不連續問題
    並且 新的整合方式已經實施
    當 AI 在 process-task-list 中執行 TDD 任務
    那麼 應該能夠記住之前步驟的測試結果
    並且 應該能夠記住代碼狀態和開發進度
    並且 整個 TDD 流程應該保持脈絡連續性