# 實作計畫

## PRD 參考

**PRD 文件路徑：** `docs/specs/2025-09-19-implementation-context-transfer/prd.md`
**相關研究文件：** `docs/research/2025-09-19-claude-code-config-workflow-problems.md`

> **重要提醒：** 實作過程中請經常參考 PRD 文件以了解：
>
> - 功能的商業目標和用戶價值
> - 完整的用戶故事和使用場景
> - 非功能性需求（性能、安全性等）
> - 系統架構和技術決策的背景脈絡
> - 研究文件中的深入分析和建議（如適用）

## 相關檔案

- `commands/create-impl-plan.md` - 需要修改的主要指令文件，新增實作資訊萃取功能和輸出格式更新
- `commands/process-task-list.md` - 需要修改的任務執行指令文件，新增 PRD 文件參考和 acceptance-tester 文件傳遞功能
- `docs/specs/2025-09-19-implementation-context-transfer/acceptance.feature` - Gherkin 格式的驗收測試場景
- `reference/2025-09-13-notes-navigation-sidebar/implementation.md` - 高品質實作計畫的參考範例

## 任務

- [x] 1. 修改 create-impl-plan.md 新增實作參考資訊萃取功能
  - 1.1 更新流程第 2 步「分析 PRD」，新增實作資訊識別和萃取指導
  - 1.2 在 implementation.md 輸出格式中新增「實作參考資訊」章節模板（位於任務清單後）
  - 1.3 新增三個子章節結構：研究文件技術洞察、PRD 實作細節、關鍵技術決策
  - 1.4 在 AI 指示中新增實作資訊萃取和組織的具體指導
  - 1.5 確保支援有/無 research 文件兩種情境的處理邏輯

- [x] 2. 修改 process-task-list.md 新增文件參考功能
  - 2.1 在 AI 指示第 136 行後新增讀取 PRD 文件的要求
  - 2.2 新增讀取 research 文件的條件判斷（當 PRD 引用時）
  - 2.3 確保任務執行前能夠提供 PRD 背景資訊和技術脈絡
  - 2.4 維持與現有 TodoWrite 工具和 Git 工作流程的相容性

- [x] 3. 修改 process-task-list.md 新增 acceptance-tester 文件傳遞功能
  - 3.1 更新第 165-167 行關於 acceptance-tester agent 調用的指示
  - 3.2 明確指定 Task tool 的 prompt 參數必須包含三個文件的相對路徑
  - 3.3 提供具體的文件路徑格式範例（基於專案根目錄的相對路徑）
  - 3.4 確保 acceptance-tester agent 能夠讀取所有必要文件進行驗收測試

- [x] 4. 驗證修改後的指令功能
  - 4.1 檢查 create-impl-plan.md 的流程邏輯和輸出格式完整性
  - 4.2 驗證 process-task-list.md 的文件參考和 agent 調用功能
  - 4.3 確認修改不會破壞現有的工作流程和向後相容性
  - 4.4 測試有/無 research 文件兩種情境下的正常運作


## 實作參考資訊

### 來自研究文件的技術洞察
> **文件路徑：** `docs/research/2025-09-19-claude-code-config-workflow-problems.md`

- **實作脈絡遺失問題的具體表現**：research 文件或 PRD 中的實作範例、技術討論和具體解決方案沒有被有效傳遞到 implementation.md，導致開發者無法接觸到這些寶貴的實作思路
- **檔案參考機制的缺失**：process-task-list.md 第 135-173 行的 AI 指示中完全沒有要求讀取或參考 PRD 文件，僅要求讀取 implementation.md
- **agent 調用的文件傳遞問題**：process-task-list.md:165-167 行提到使用 acceptance-tester agent，但沒有指定要傳遞哪些文件，而 acceptance-tester.md:13 行明確列出需要三個文件
- **真實案例驗證**：`reference/2025-09-13-notes-navigation-sidebar/` 案例顯示當 PRD 詳細且技術導向時，現有機制能產生高品質的 implementation.md

### 來自 PRD 的實作細節
> **PRD 文件路徑：** `docs/specs/2025-09-19-implementation-context-transfer/prd.md`

- **實作參考資訊章節設計**：採用清晰的三層結構（研究洞察 → PRD 細節 → 技術決策總結），每個子章節都包含文件路徑參考，使用條列式組織
- **資訊萃取策略**：重點識別實作相關的技術內容，排除純理論討論；保留程式碼範例的完整性和可執行性；確保技術決策包含足夠的背景脈絡
- **現有系統整合要求**：修改 `commands/create-impl-plan.md` 的流程第 2 步和輸出格式；修改 `commands/process-task-list.md` 的 AI 指示部分；保持與現有 TodoWrite 工具和 Git 工作流程的相容性
- **檔案處理機制**：支援相對路徑和絕對路徑的檔案引用；處理 research 文件不存在的情況；確保檔案讀取錯誤不會中斷整個流程

### 關鍵技術決策

- **章節位置設計**：將「實作參考資訊」章節放置在任務清單後面，避免冗長的參考資訊影響任務清單的可讀性
- **相對路徑使用**：acceptance-tester agent 調用時使用基於專案根目錄的相對路徑，提升可攜性和跨環境相容性
- **向後相容性保證**：所有修改都不改變現有文件的基本結構和工作流程，確保既有功能繼續正常運作
- **語言一致性維持**：程式碼範例和技術內容使用英文，文件結構和說明文字使用對話語言（繁體中文）