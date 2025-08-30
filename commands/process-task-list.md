# 任務清單管理

用於在 Claude Code 中管理任務清單的指導原則，以追蹤完成 PRD 的進度

## Claude Code 任務清單同步

Claude Code 提供內建的 TodoWrite 工具來管理任務，這與 Cursor 等其他編輯器的工作方式不同。為了充分利用 Claude Code 的功能同時保持任務記錄的持久性，我們需要雙向同步機制。

### 同步機制

- **初始載入：** 從 `implementation.md` 讀取任務清單，使用 TodoWrite 工具將其轉換為 Claude Code 內部任務清單
- **雙向同步：** 當 Claude Code 內部任務清單狀態改變時（pending、in_progress、completed），必須同步更新 `implementation.md` 中對應的任務項目
- **格式對應：**
  - Claude Code `pending` → Markdown `[ ]`
  - Claude Code `in_progress` → Markdown `[ ]` (可在旁邊加註 _進行中_)
  - Claude Code `completed` → Markdown `[x]`

### 為什麼需要同步

1. **持久化：** TodoWrite 的任務只存在於當前對話，implementation.md 提供永久記錄
2. **可見性：** 用戶可以直接在檔案中查看任務進度
3. **協作：** 其他開發者可以透過 implementation.md 了解專案狀態
4. **版本控制：** implementation.md 可以透過 Git 追蹤歷史變更

## 任務實作

- **一次一個任務：** 完成一個任務後，在請求用戶許可並獲得「yes」或「y」回應之前，**不要**開始下一個任務
- **完成協議：**
  1. 實作任務時，參考任務說明中的所有實作要點
  2. 完成任務後，請按照以下順序操作：
  - **暫存變更**：執行 `git add .`
  - **清理**：在提交前移除任何臨時檔案和臨時程式碼
  - **提交**：使用描述性的提交訊息，該訊息應：
    - 使用慣例提交格式（`feat:`、`fix:`、`refactor:` 等）
    - 總結任務中完成的內容
    - 列出關鍵變更和新增內容
    - 引用任務編號和 PRD 上下文
  3. 提交後，將任務標記為 `[x]` 已完成，並在 TodoWrite 和 implementation.md 中都更新任務狀態

- 每個任務完成後停止並等待用戶的許可。

## 任務清單維護

1. **工作時更新任務清單：**
   - 使用 TodoWrite 工具管理內部任務狀態
   - 同步更新 implementation.md 中的任務標記（`[ ]` → `[x]`）
   - 隨著新任務出現而新增它們到兩個地方

2. **維護「相關檔案」部分：**
   - 列出每個創建或修改的檔案
   - 為每個檔案提供一行描述其用途的說明
   - 此部分只在 implementation.md 中維護，不需要在 TodoWrite 中記錄

## AI 指示（Claude Code）

處理任務清單時，Claude Code 必須：

1. **首次載入任務：**
   - 讀取 `implementation.md` 檔案
   - 使用 TodoWrite 工具將任務清單轉換為內部任務格式
   - 保持任務 ID 與原始清單的對應關係

2. **任務狀態管理：**
   - 使用 TodoWrite 工具管理任務狀態（pending、in_progress、completed）
   - 一次只能有一個任務處於 `in_progress` 狀態
   - 完成任務時立即更新為 `completed`

3. **同步更新 implementation.md：**
   - 每當 TodoWrite 中的任務狀態改變時，立即更新 `implementation.md`
   - 將完成的任務標記為 `[x]`
   - 使用 Edit 或 MultiEdit 工具更新檔案

4. **新增任務：**
   - 當發現新任務時，同時更新：
     - TodoWrite 內部清單
     - `implementation.md` 檔案

5. **保持「相關檔案」的準確和最新。**

6. **TDD 任務處理：**
   - 當任務標題包含「使用 tdd-developer agent 進行開發」標註時
   - 使用 Task 工具啟動 tdd-developer agent 來處理該任務
   - 將完整的任務內容（包括所有子任務）傳遞給 agent

7. **工作流程：**
   - 開始工作前，從 TodoWrite 檢查下一個待處理任務
   - 檢查任務是否標註需要使用 tdd-developer agent
   - 將任務標記為 `in_progress`
   - 根據任務類型選擇處理方式：
     - 一般任務：直接實作
     - TDD 標註任務：使用 tdd-developer agent
   - 完成後標記為 `completed` 並同步更新 `implementation.md`
   - 暫停等待用戶核准後再進行下一個任務
