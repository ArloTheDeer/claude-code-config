# 任務清單管理

用於在 Claude Code 中管理任務清單的指導原則，以追蹤完成 PRD 的進度

## Claude Code 任務清單同步

Claude Code 提供內建的 TodoWrite 工具來管理任務，這與 Cursor 等其他編輯器的工作方式不同。為了充分利用 Claude Code 的功能同時保持任務記錄的持久性，我們需要同步機制。對於 TDD 任務，採用簡化的單向同步策略。

### 同步機制

#### 一般任務同步
- **初始載入：** 從 `implementation.md` 讀取任務清單，使用 TodoWrite 工具將其轉換為 Claude Code 內部任務清單
- **雙向同步：** 當 Claude Code 內部任務清單狀態改變時（pending、in_progress、completed），必須同步更新 `implementation.md` 中對應的任務項目
- **格式對應：**
  - Claude Code `pending` → Markdown `[ ]`
  - Claude Code `in_progress` → Markdown `[ ]` (可在旁邊加註 _進行中_)
  - Claude Code `completed` → Markdown `[x]`

#### TDD 任務簡化同步
- **單向讀取：** 從 `implementation.md` 讀取 TDD 任務，在 TodoWrite 中動態展開為 7 個子任務
- **子任務隔離：** TDD 子任務狀態僅在 TodoWrite 中管理，不同步回 `implementation.md`
- **母任務完成：** 只有當所有 7 個子任務標記為 `completed` 後，才將 `implementation.md` 中的母任務標記為 `[x]`
- **狀態檢查：** 母任務完成狀態基於子任務完成數量，而非中間進度

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

## TDD 任務自動分解機制

當在 `implementation.md` 中發現標註「使用 TDD 開發流程」的任務時，Claude Code 必須實施以下自動分解機制，以提供更精細的 TDD 進度追蹤。

### 分解觸發條件

- **檢測標註**：任務標題包含「使用 TDD 開發流程」文字（支援空格變化，如「使用TDD開發流程」）
- **分解時機**：只有當 TDD 任務在 TodoWrite 中標記為 `in_progress` 時才進行分解
- **延遲展開**：未開始的 TDD 任務在 TodoWrite 中保持單一任務形式

### 自動分解規則

當 TDD 任務標記為 `in_progress` 時，自動分解為以下 7 個子任務：

1. **`[任務名稱] - 先跑測試`**
   - 執行現有測試，確保所有測試通過

2. **`[任務名稱] - 寫空介面`**
   - 創建拋出「Not implemented」錯誤的空實現

3. **`[任務名稱] - 寫測試敘述`**
   - 撰寫 describe/it 區塊的測試描述

4. **`[任務名稱] - 實作測試邏輯`**
   - 撰寫實際的測試邏輯和斷言

5. **`[任務名稱] - 跑測試（紅燈階段）`**
   - 執行測試，確保測試失敗

6. **`[任務名稱] - 實作實際程式碼`**
   - 實現真實邏輯替換空實現

7. **`[任務名稱] - 再次跑測試（綠燈階段）`**
   - 執行測試，確保測試通過

### 子任務執行規範

- **順序執行**：子任務必須按照上述順序依次執行
- **狀態限制**：同時只能有一個子任務處於 `in_progress` 狀態
- **完成條件**：所有 7 個子任務標記為 `completed` 後，母任務才能標記為完成
- **同步範圍**：子任務狀態僅在 TodoWrite 中管理，不同步回 `implementation.md`

### 非 TDD 任務相容性

- **無標註任務**：沒有「使用 TDD 開發流程」標註的任務保持原有處理方式
- **混合清單**：TDD 和非 TDD 任務可以共存於同一個任務清單中
- **狀態獨立**：非 TDD 任務的狀態管理不受 TDD 分解機制影響

### 執行範例

```
情境：implementation.md 包含「建立用戶認證系統 - 使用 TDD 開發流程」

1. 檢測階段 → 識別 TDD 標註
2. 用戶標記 in_progress → 自動分解為：
   - 建立用戶認證系統 - 先跑測試 [pending]
   - 建立用戶認證系統 - 寫空介面 [pending]
   - 建立用戶認證系統 - 寫測試敘述 [pending]
   - 建立用戶認證系統 - 實作測試邏輯 [pending]
   - 建立用戶認證系統 - 跑測試（紅燈階段） [pending]
   - 建立用戶認證系統 - 實作實際程式碼 [pending]
   - 建立用戶認證系統 - 再次跑測試（綠燈階段） [pending]
3. 順序執行 → 第一個子任務自動變為 [in_progress]
4. 完成檢查 → 所有子任務 [completed] 後，母任務標記為 [x]
```

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
   - 檢測「使用 TDD 開發流程」標註，自動分解為 7 個子任務（詳見「TDD 任務自動分解機制」章節）
   - 按順序執行子任務，遵循 TDD 工作流程（詳見「TDD 開發流程」章節）

7. **驗收測試任務處理：**
   - 檢測任務標題或描述中包含以下關鍵詞的任務：
     - 「驗收測試」、「acceptance testing」、「驗收」、「validate implementation」
     - 「執行驗收測試」、「進行驗收」、「驗證實作」等相關詞彙
   - 當遇到驗收測試任務時，必須使用 Task tool 啟用 acceptance-tester agent
   - 驗收測試任務應由 acceptance-tester agent 專門處理，不要在主對話中直接執行

8. **工作流程：**
   - 檢查下一個待處理任務，識別是否為 TDD 任務或驗收測試任務
   - 將任務標記為 `in_progress`（TDD 任務將自動分解，驗收測試任務啟用專門 agent）
   - 完成後標記為 `completed` 並同步更新 `implementation.md`
   - 等待用戶核准後再進行下一個任務

## TDD 開發流程

當執行 TDD 子任務時，必須嚴格遵循 Test-Driven Development (TDD) 方法論。每個子任務對應 TDD 流程中的特定階段，確保代碼品質並遵循 red-green-refactor 循環。

### 執行原則

- **嚴格順序**：按照子任務順序執行，不可跳過或重排
- **階段確認**：每個關鍵階段完成後等待開發者確認再進行下一步
- **專注當前**：專注於當前子任務，不要提前實現後續步驟的內容

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

