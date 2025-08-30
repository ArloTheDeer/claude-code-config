# language: zh-TW
功能: Agents 目錄安裝功能
  作為開發者
  我想要執行 npm run install-config 時能同時安裝 commands 和 agents 目錄的所有檔案
  以便我可以透過單一命令完成所有設定檔的部署

  背景:
    假設 專案根目錄存在 agents 目錄和 commands 目錄
    並且 agents 目錄包含 tdd-developer.md 檔案
    並且 commands 目錄包含多個 .md 檔案

  場景: 成功安裝所有 commands 和 agents 檔案
    假設 ~/.claude 目錄不存在
    當 我執行 "npm run install-config"
    那麼 應該建立 ~/.claude/commands 目錄
    並且 應該建立 ~/.claude/agents 目錄
    並且 所有 commands/*.md 檔案應該被複製到 ~/.claude/commands/
    並且 所有 agents/*.md 檔案應該被複製到 ~/.claude/agents/
    並且 應該顯示成功安裝的訊息
    並且 應該列出所有已安裝的 commands 檔案
    並且 應該列出所有已安裝的 agents 檔案

  場景: 檢測檔案衝突並停止安裝
    假設 ~/.claude/commands 目錄已存在且包含 create-prd.md
    並且 ~/.claude/agents 目錄已存在且包含 tdd-developer.md
    當 我執行 "npm run install-config"
    那麼 應該檢測到 commands 目錄中的檔案衝突
    並且 應該檢測到 agents 目錄中的檔案衝突
    並且 應該顯示衝突檔案清單
    並且 應該提示使用 overwrite 旗標
    並且 不應該複製任何檔案

  場景: 使用 overwrite 旗標覆蓋現有檔案
    假設 ~/.claude/commands 目錄已存在且包含 create-prd.md
    並且 ~/.claude/agents 目錄已存在且包含 tdd-developer.md
    當 我執行 "npm run install-config -- overwrite"
    那麼 應該覆蓋所有衝突的 commands 檔案
    並且 應該覆蓋所有衝突的 agents 檔案
    並且 應該顯示覆蓋警告訊息
    並且 應該顯示成功安裝的訊息
    並且 應該統計被覆蓋的檔案數量

  場景: agents 目錄不存在的處理
    假設 專案根目錄不存在 agents 目錄
    當 我執行 "npm run install-config"
    那麼 應該成功安裝所有 commands 檔案
    並且 應該顯示 agents 目錄不存在的友善提示
    並且 不應該建立 ~/.claude/agents 目錄
    並且 整體安裝應該成功完成

  場景: 跨平台路徑相容性
    假設 系統可能是 Windows、macOS 或 Linux
    當 我執行 "npm run install-config"
    那麼 應該正確解析使用者家目錄路徑
    並且 應該正確建立跨平台相容的目錄結構
    並且 應該正確複製檔案到目標位置

  場景: 部分安裝失敗的處理
    假設 ~/.claude/commands 目錄存在但沒有寫入權限
    當 我執行 "npm run install-config -- overwrite"
    那麼 應該顯示權限錯誤訊息
    並且 應該中止整個安裝程序
    並且 不應該部分安裝 agents 檔案
    並且 應該返回非零退出碼

  場景大綱: 不同目錄狀態的安裝行為
    假設 ~/.claude 目錄狀態為 "<claude_dir_status>"
    並且 agents 目錄狀態為 "<agents_dir_status>"
    當 我執行 "npm run install-config"
    那麼 安裝結果應該是 "<expected_result>"
    並且 應該顯示相應的 "<message_type>" 訊息

    例子:
      | claude_dir_status | agents_dir_status | expected_result | message_type |
      | 不存在            | 存在              | 成功            | 成功安裝     |
      | 存在且為空        | 存在              | 成功            | 成功安裝     |
      | 存在且有檔案      | 存在              | 失敗            | 檔案衝突     |
      | 不存在            | 不存在            | 部分成功        | 友善提示     |