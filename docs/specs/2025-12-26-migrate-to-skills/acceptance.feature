# language: zh-TW
功能: Slash Commands 遷移至 Skills 格式
  作為 開發者
  我想要 將現有的 Slash Commands 遷移到 Skills 格式
  以便 獲得更靈活的檔案組織結構並與業界標準一致

  背景:
    假設 專案已完成 Skills 遷移
    並且 安裝腳本已更新

  場景: 手動調用 research skill
    假設 Skills 已安裝到 ~/.claude/skills/
    當 在 Claude Code 中輸入 "/research"
    那麼 應該看到 research skill 被載入
    並且 skill 應該正常執行研究流程

  場景: 手動調用 create-prd skill
    假設 Skills 已安裝到 ~/.claude/skills/
    當 在 Claude Code 中輸入 "/create-prd"
    那麼 應該看到 create-prd skill 被載入
    並且 skill 應該正常執行 PRD 產生流程

  場景: 手動調用 create-impl-plan skill
    假設 Skills 已安裝到 ~/.claude/skills/
    當 在 Claude Code 中輸入 "/create-impl-plan"
    那麼 應該看到 create-impl-plan skill 被載入
    並且 skill 應該能夠存取拆分出的參考檔案

  場景: 手動調用 process-task-list skill
    假設 Skills 已安裝到 ~/.claude/skills/
    當 在 Claude Code 中輸入 "/process-task-list"
    那麼 應該看到 process-task-list skill 被載入
    並且 skill 應該正常執行任務處理流程

  場景: 手動調用 acceptance-tester skill
    假設 Skills 已安裝到 ~/.claude/skills/
    當 在 Claude Code 中輸入 "/acceptance-tester"
    那麼 應該看到 acceptance-tester skill 被載入
    並且 skill 應該正常執行驗收測試流程

  場景: 安裝 Skills 到個人目錄
    假設 專案 skills/ 目錄已建立
    當 執行 "npm run install-config"
    那麼 應該看到 Skills 被複製到 ~/.claude/skills/
    並且 每個 skill 目錄結構應該完整（包含 SKILL.md 和子目錄）
    並且 應該顯示安裝成功的訊息

  場景: 強制覆寫安裝
    假設 ~/.claude/skills/ 已存在舊版本的 skills
    當 執行 "npm run install-config -- overwrite"
    那麼 應該看到 Skills 被覆寫
    並且 應該顯示覆寫成功的訊息

  場景: 自動清理舊 Commands
    假設 ~/.claude/commands/ 存在 research.md 檔案
    並且 ~/.claude/commands/ 存在 create-prd.md 檔案
    當 執行 "npm run install-config"
    那麼 應該看到 ~/.claude/commands/research.md 被刪除
    並且 應該看到 ~/.claude/commands/create-prd.md 被刪除
    並且 應該顯示清理訊息告知使用者哪些舊 commands 被移除

  場景: 專案舊目錄已清理
    假設 遷移已完成
    當 檢查專案目錄結構
    那麼 不應該存在 commands/ 目錄
    並且 不應該存在 agents/ 目錄
    並且 應該存在 skills/ 目錄

  場景: SKILL.md 格式正確
    假設 遷移已完成
    當 檢查任一 SKILL.md 檔案
    那麼 應該包含有效的 YAML frontmatter
    並且 frontmatter 應該包含 name 欄位
    並且 frontmatter 應該包含 description 欄位
    並且 description 應該包含使用時機的觸發關鍵詞
