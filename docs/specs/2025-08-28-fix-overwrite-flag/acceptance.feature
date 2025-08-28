# language: zh-TW
功能: 修復 --overwrite 參數無法正常工作的問題
  作為 開發者
  我想要 能夠使用 npm run install-config -- --overwrite 命令來覆蓋現有配置檔案
  以便 更新到最新版本的命令檔案，而不需要手動刪除舊檔案

  背景:
    假設 專案根目錄存在 package.json 和 scripts/install-config.js
    並且 commands 目錄包含 create-impl-plan.md、create-prd.md、process-task-list.md、research.md 檔案

  場景: AC001 - 執行覆蓋命令時不出現 npm 警告
    假設 在專案根目錄下
    當 執行命令 "npm run install-config -- --overwrite"
    那麼 不應該出現 "Unknown cli config" 警告訊息
    並且 命令應該成功執行

  場景: AC002 - 控制台顯示覆蓋模式已啟用
    假設 在專案根目錄下
    當 執行命令 "npm run install-config -- --overwrite"
    那麼 控制台應該顯示 "Overwrite mode: enabled"
    並且 不應該顯示 "Overwrite mode: disabled"

  場景: AC003 - 現有檔案能夠被成功覆蓋
    假設 目標目錄 "C:\Users\arlo\.claude\commands" 存在
    並且 該目錄包含現有的 create-prd.md 檔案
    當 執行命令 "npm run install-config -- --overwrite"
    那麼 現有的 create-prd.md 檔案應該被新版本覆蓋
    並且 控制台應該顯示覆蓋成功訊息

  場景: AC004 - 覆蓋完成後檔案是最新版本
    假設 目標目錄包含舊版本的配置檔案
    當 執行覆蓋命令完成後
    那麼 目標目錄中的檔案內容應該與 commands 目錄中的來源檔案相同
    並且 檔案修改時間應該是最近的時間

  場景: AC005 - 首次安裝功能正常運作
    假設 目標目錄 "C:\Users\arlo\.claude\commands" 不存在
    當 執行命令 "npm run install-config"（不使用 --overwrite 參數）
    那麼 應該建立目標目錄
    並且 所有 .md 檔案應該被複製到目標目錄
    並且 控制台應該顯示安裝成功訊息

  場景: 錯誤處理 - 無覆蓋參數時遇到現有檔案
    假設 目標目錄包含現有的配置檔案
    當 執行命令 "npm run install-config"（不使用 --overwrite 參數）
    那麼 應該顯示現有檔案清單
    並且 提示使用 --overwrite 參數的指示
    並且 程序應該以錯誤狀態結束

  場景大綱: 參數解析驗證
    假設 在專案根目錄下
    當 執行命令 "<command>"
    那麼 控制台應該顯示 "<expected_mode>"

    例子:
      | command                              | expected_mode           |
      | npm run install-config               | Overwrite mode: disabled |
      | npm run install-config -- --overwrite | Overwrite mode: enabled  |