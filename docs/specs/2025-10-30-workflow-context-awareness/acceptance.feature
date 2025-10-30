# language: zh-TW
功能: Slash Command 工作流程認知增強
  作為 claude-code-config 的使用者
  我想要各個 slash command 都能理解整體工作流程
  以便每個階段都能專注於自己的職責範圍，不會產出超出範圍的內容

  背景:
    假設 claude-code-config 專案已經安裝在本機
    並且 命令檔案位於 commands/ 目錄

  場景: create-prd.md 包含完整的工作流程脈絡章節
    假設 我開啟 commands/create-prd.md 檔案
    當 我檢視檔案內容
    那麼 應該在「目標」章節之後看到「工作流程脈絡」章節
    並且 「工作流程脈絡」章節應該包含「整體開發流程」子章節
    並且 「工作流程脈絡」章節應該包含「當前階段的輸入與輸出」子章節
    並且 「工作流程脈絡」章節應該包含「當前階段的職責範圍」子章節
    並且 「工作流程脈絡」章節應該包含「與其他階段的關係」子章節
    並且 目標讀者應該明確定義為「產品經理、業務人員、專案管理者」而非「初級開發者」

  場景: create-prd.md 清楚定義職責範圍
    假設 我檢視 commands/create-prd.md 的「工作流程脈絡」章節
    當 我閱讀「當前階段的職責範圍」子章節
    那麼 應該有「應該包含」清單，列出 PRD 應該包含的內容類型
    並且 應該有「不應該包含」清單，明確排除詳細程式碼範例、具體 API 設計、詳細 Gherkin 場景、技術選型深入分析
    並且 應該說明「高層次技術方向」的具體含義和範例

  場景: create-prd.md 說明如何處理 research 文件引用
    假設 我檢視 commands/create-prd.md 的「工作流程脈絡」章節
    當 我閱讀「與其他階段的關係」子章節中關於 research 的部分
    那麼 應該明確說明要「引用」研究發現，而非「複製」技術細節
    並且 應該提供好的引用範例（如「基於 research 文件的分析，建議採用事件驅動架構」）
    並且 應該說明 research 中的程式碼範例、架構決策會在 implementation.md 階段處理

  場景: create-impl-plan.md 包含完整的工作流程脈絡章節
    假設 我開啟 commands/create-impl-plan.md 檔案
    當 我檢視檔案內容
    那麼 應該在「目標」章節之後看到「工作流程脈絡」章節
    並且 「工作流程脈絡」章節結構應該與 create-prd.md 保持一致
    並且 目標讀者應該明確定義為「開發者（初級到中級）」
    並且 應該強調「實作參考資訊」章節是技術細節的「承接點」

  場景: process-task-list.md 包含完整的工作流程脈絡章節
    假設 我開啟 commands/process-task-list.md 檔案
    當 我檢視檔案內容
    那麼 應該在適當位置看到「工作流程脈絡」章節
    並且 應該包含「各參考文件的角色」子章節
    並且 應該說明 implementation.md、prd.md、acceptance.feature、research 文件各自的用途
    並且 應該強調參考 PRD 理解「為什麼」，參考 implementation.md 理解「怎麼做」

  場景: research.md 增強了 PRD 整合指導
    假設 我開啟 commands/research.md 檔案
    當 我找到「與 PRD 和實作的整合」章節中的「PRD 撰寫參考」部分
    那麼 應該看到關於「引用 vs 複製」的詳細說明
    並且 應該說明 PRD 讀者是產品經理和業務人員
    並且 應該說明 `/create-impl-plan` 會自動提取技術細節到「實作參考資訊」章節

  場景: CLAUDE.md 記錄了此次改進
    假設 我開啟 CLAUDE.md 檔案
    當 我檢視檔案內容
    那麼 應該看到關於「工作流程脈絡」改進的說明
    並且 應該強調職責分離原則
    並且 應該更新相關的工作流程模式或最佳實踐章節

  場景: 所有工作流程脈絡章節使用一致的術語和結構
    假設 我檢視所有四個 command 檔案的「工作流程脈絡」章節
    當 我比較它們的結構和用詞
    那麼 四個階段的描述應該使用一致的術語
    並且 整體開發流程的描述應該完全一致
    並且 各階段的角色定位應該清晰且不重疊

  場景大綱: 實際使用各 slash command 驗證改進效果
    假設 我使用 <command> 指令處理一個包含技術細節的 <input>
    當 我檢視生成的 <output>
    那麼 產出內容應該符合 <expected_scope>
    並且 不應該包含 <excluded_content>

    例子:
      | command          | input                    | output      | expected_scope                     | excluded_content                   |
      | /create-prd      | 引用包含程式碼的 research | prd.md      | 高層次需求和技術方向                | 詳細程式碼範例、具體 API 設計      |
      | /create-impl-plan| 包含商業背景的 PRD        | implementation.md | 詳細任務和技術細節            | 重複的商業背景說明                 |
      | /process-task-list| implementation.md        | 程式碼變更   | 實際實作                          | 任意修改任務範圍                   |
