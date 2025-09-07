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
   - 當任務標題包含「使用 TDD 開發流程」標註時
   - 遵循完整的 TDD 工作流程（詳見「TDD 開發流程」章節）

7. **工作流程：**
   - 開始工作前，從 TodoWrite 檢查下一個待處理任務
   - 檢查任務是否標註需要使用 TDD 開發流程
   - 將任務標記為 `in_progress`
   - 根據任務類型選擇處理方式：
     - 一般任務：直接實作
     - TDD 標註任務：執行 TDD 開發流程
   - 完成後標記為 `completed` 並同步更新 `implementation.md`
   - 暫停等待用戶核准後再進行下一個任務

## TDD 開發流程

當任務標題包含「使用 TDD 開發流程」標註時，必須嚴格遵循以下 Test-Driven Development (TDD) 方法論實作新功能。此流程確保代碼品質並遵循 red-green-refactor 循環。

### 核心 TDD 工作流程

**必須按順序執行以下步驟：**

1. **運行現有測試**：在開始任何新開發之前，先運行所有現有測試，確保它們都通過。

2. **創建空實現**：撰寫拋出「Not implemented」錯誤的空類或函數。清楚定義接口，但不要實現實際邏輯。這是關鍵步驟 - 在測試之前實現邏輯違背了 TDD 的目的。**在此停止並等待開發者確認後再進行下一步。**

3. **撰寫測試描述**：使用 describe/it 區塊創建帶有「TBD」註釋的測試描述。只專注於主要成功路徑和主要錯誤場景。初期避免邊緣案例 - 當實際問題出現時再添加。**在此停止並等待開發者確認後再進行下一步。**

4. **實現測試邏輯**：測試描述確認後，撰寫實際的測試邏輯，調用空實現並對預期行為做出有意義的斷言。**在此停止並等待開發者確認後再進行下一步。**

5. **運行測試（紅燈階段）**：撰寫測試邏輯後執行測試。測試在此階段必須失敗。如果測試通過，說明方法有問題。

6. **實現實際代碼**：用真實邏輯替換「Not implemented」錯誤，使測試通過。**在此停止並等待開發者確認後再進行下一步。**

7. **再次運行測試（綠燈階段）**：執行測試並迭代直到通過，保持合理的測試邏輯。

### 關鍵規則

- **絕不** 撰寫期望「Not implemented」錯誤的測試邏輯

### 範例：正確 vs 錯誤的測試方法

#### 錯誤的測試方法 ❌
```typescript
// 空實現函數
export async function generateStaticParams(): Promise<{ slug: string }[]> {
  throw new Error('Not implemented')
}

// 錯誤的測試 - 直接期望 "Not implemented" 錯誤
it('returns all available note paths as static params', async () => {
  await expect(generateStaticParams()).rejects.toThrow('Not implemented')
})
```

#### 正確的測試方法 ✅
```typescript
// 空實現函數 (相同的起點)
export async function generateStaticParams(): Promise<{ slug: string }[]> {
  throw new Error('Not implemented')
}

// 正確的測試 - 測試預期的行為，不是現在的錯誤狀態
it('returns all available note paths as static params', async () => {
  // Mock 檔案系統或數據源
  const mockNotes = ['note1.md', 'note2.md', 'note3.md']
  jest.spyOn(fs, 'readdir').mockResolvedValue(mockNotes)

  const result = await generateStaticParams()
  
  expect(result).toEqual([
    { slug: 'note1' },
    { slug: 'note2' },
    { slug: 'note3' }
  ])
  expect(result).toHaveLength(3)
})
```

**關鍵差異：**
- 錯誤方法測試目前的實現狀態（拋出錯誤）
- 正確方法測試我們想要的最終行為（返回 note paths）
- 正確方法在紅燈階段會失敗，因為函數還沒實現預期邏輯
- 正確方法指導我們需要實現什麼功能來讓測試通過
- **絕不** 撰寫沒有真實實現就保證通過的測試
- **絕不** 在撰寫測試之前實現實際邏輯
- 初期專注於主流程和主要錯誤情況，而非全面覆蓋
- 在實現測試邏輯之前總是確認測試描述
- 實現使用 TypeScript，代碼/註釋使用英文
- 討論使用繁體中文溝通

### 品質保證

- 確保紅燈階段確實因正確原因失敗
- 保持測試邏輯合理且有意義
- 如果技術問題阻止測試通過，與開發者討論解決方案，而不是人為修改測試使其通過
- 在測試描述階段和測試實現階段之間保持清晰分離

### 輸出格式

清楚指示當前處於哪個階段和正在做什麼。在主要階段之間移動前詢問確認（特別是在實現測試邏輯之前和實現實際代碼之前）。
