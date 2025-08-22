# language: zh-TW
功能: 配置安裝腳本
  作為 claude-code-config 的使用者
  我想要 透過 npm script 安裝工作流程指令到 Claude Code 配置目錄
  以便 在我的 Claude Code 環境中使用這些標準化的開發流程

  背景:
    假設 專案已經完成實作並且 package.json 已配置完成
    並且 commands 資料夾包含四個 .md 檔案

  場景: 首次安裝 - Windows 平台
    假設 我在 Windows 系統上
    並且 目標目錄 "C:\Users\[username]\.claude\commands\" 不存在
    當 我執行 "npm run install-config"
    那麼 系統應該自動建立目標目錄
    並且 成功複製所有 4 個 .md 檔案
    並且 顯示 "Installation successful! Installed 4 files to C:\Users\[username]\.claude\commands\"

  場景: 首次安裝 - macOS/Linux 平台
    假設 我在 macOS 或 Linux 系統上
    並且 目標目錄 "~/.claude/commands/" 不存在
    當 我執行 "npm run install-config"
    那麼 系統應該自動建立目標目錄
    並且 成功複製所有 4 個 .md 檔案
    並且 顯示 "Installation successful! Installed 4 files to ~/.claude/commands/"

  場景: 檔案衝突 - 預設停止安裝
    假設 目標目錄已存在
    並且 目標目錄中已有 "create-prd.md" 檔案
    當 我執行 "npm run install-config"
    那麼 系統應該顯示 "❌ Found existing files: create-prd.md"
    並且 顯示 "Use --overwrite flag to overwrite existing files:"
    並且 顯示 "npm run install-config -- --overwrite"
    並且 安裝程序應該停止且不修改任何檔案

  場景: 檔案衝突 - 使用 overwrite 參數覆蓋
    假設 目標目錄已存在
    並且 目標目錄中已有 "research.md" 檔案
    當 我執行 "npm run install-config -- --overwrite"
    那麼 系統應該覆蓋現有檔案
    並且 顯示 "✅ Installation successful! Installed 4 files"
    並且 顯示 "⚠️  Overwritten 1 existing files"

  場景: 多個檔案衝突 - 預設停止
    假設 目標目錄已存在
    並且 目標目錄中已有 "create-prd.md" 和 "create-impl-plan.md" 檔案
    當 我執行 "npm run install-config"
    那麼 系統應該顯示 "❌ Found existing files: create-prd.md, create-impl-plan.md"
    並且 顯示 "Use --overwrite flag to overwrite existing files:"
    並且 顯示 "npm run install-config -- --overwrite"
    並且 安裝程序應該停止且不修改任何檔案
  
  場景: 多個檔案衝突 - 使用 overwrite 參數
    假設 目標目錄已存在
    並且 目標目錄中已有 "create-prd.md" 和 "create-impl-plan.md" 檔案
    當 我執行 "npm run install-config -- --overwrite"
    那麼 系統應該覆蓋所有衝突的檔案
    並且 顯示 "✅ Installation successful! Installed 4 files"
    並且 顯示 "⚠️  Overwritten 2 existing files"

  場景: 權限不足錯誤
    假設 目標目錄存在但沒有寫入權限
    當 我執行 "npm run install-config"
    那麼 系統應該顯示錯誤訊息 "Error: Permission denied"
    並且 安裝過程應該終止

  場景大綱: 跨平台路徑處理
    假設 我在 "<platform>" 系統上
    當 我執行 "npm run install-config"
    那麼 系統應該使用 "<target_path>" 作為安裝目標
    並且 成功安裝所有檔案

    例子:
      | platform | target_path                            |
      | win32    | C:\Users\[username]\.claude\commands\ |
      | darwin   | ~/.claude/commands/                    |
      | linux    | ~/.claude/commands/                    |