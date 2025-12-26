# 實作計畫

## PRD 參考

**PRD 文件路徑：** `docs/specs/2025-12-26-migrate-to-skills/prd.md`
**相關研究文件：** `docs/research/2025-12-26-skills-vs-slash-commands.md`

## 任務概要

- [x] 建立 Skills 目錄結構和基礎 SKILL.md
- [ ] 遷移 research 和 create-prd Skills
- [ ] 遷移並拆分 create-impl-plan Skill
- [ ] 遷移並拆分 process-task-list Skill
- [ ] 遷移 acceptance-test Skill
- [ ] 更新安裝腳本支援 Skills
- [ ] 清理舊的 commands 和 agents 目錄
- [ ] 執行驗收測試
- [ ] 更新專案文件

## 任務細節

### 建立 Skills 目錄結構和基礎 SKILL.md

**實作要點**
- 在專案根目錄建立 `skills/` 目錄
- 建立五個子目錄：`research/`、`create-prd/`、`create-impl-plan/`、`process-task-list/`、`acceptance-test/`
- 為每個 skill 建立空的 `SKILL.md` 檔案，包含基本的 frontmatter 結構
- frontmatter 必須包含 `name` 和 `description` 欄位
- `description` 需遵循 Progressive Disclosure 原則：清楚說明功能、使用時機、觸發關鍵詞

**相關檔案**
- `skills/research/SKILL.md` - 新建
- `skills/create-prd/SKILL.md` - 新建
- `skills/create-impl-plan/SKILL.md` - 新建
- `skills/process-task-list/SKILL.md` - 新建
- `skills/acceptance-test/SKILL.md` - 新建

**完成檢查**
- 確認 `skills/` 目錄結構正確建立，包含五個子目錄
- 確認每個 SKILL.md 都有有效的 YAML frontmatter（name 和 description）

**實作備註**
[方向調整] 原計畫使用 `acceptance-tester` 名稱，但因 agent 轉為 skill 後名稱應反映功能而非角色，改用 `acceptance-test`。

---

### 遷移 research 和 create-prd Skills

**實作要點**
- 將 `commands/research.md` 內容遷移到 `skills/research/SKILL.md`
  - 在檔案開頭加入 frontmatter（name: research, description: 包含觸發關鍵詞）
  - 保留原有內容不變
- 將 `commands/create-prd.md` 內容遷移到 `skills/create-prd/SKILL.md`
  - 在檔案開頭加入 frontmatter（name: create-prd, description: 包含觸發關鍵詞）
  - 保留原有內容不變
- 這兩個檔案較小（216 行、110 行），無需拆分
- description 撰寫策略：
  - research: 包含「研究」「分析」「技術問題」「調查」等關鍵詞
  - create-prd: 包含「PRD」「產品需求」「需求文件」「功能需求」等關鍵詞

**相關檔案**
- `commands/research.md` - 來源（216 行）
- `commands/create-prd.md` - 來源（110 行）
- `skills/research/SKILL.md` - 目標
- `skills/create-prd/SKILL.md` - 目標

**完成檢查**
- 確認兩個 SKILL.md 都有完整的 frontmatter 和原始內容
- 確認 frontmatter 格式正確（YAML 語法）

**實作備註**
<!-- 執行過程中填寫重要的技術決策、障礙和需要傳遞的上下文 -->

---

### 遷移並拆分 create-impl-plan Skill

**實作要點**
- 分析 `commands/create-impl-plan.md`（418 行）的結構，識別可拆分的獨立區塊
- 建議拆分結構：
  - `SKILL.md`：主要指令（目標、流程、工作流程脈絡）
  - `references/output-format.md`：輸出格式範例（implementation.md 和 acceptance.feature 範例）
  - `references/completion-check-guide.md`：完成檢查生成指引
  - `references/acceptance-test-guide.md`：驗收測試撰寫指引（視角區分等）
- SKILL.md 主體透過 markdown 連結引用拆分出的參考檔案
- 確保 SKILL.md 主體控制在 200 行以內
- frontmatter description 包含「實作計畫」「任務清單」「implementation」等關鍵詞

**相關檔案**
- `commands/create-impl-plan.md` - 來源（418 行）
- `skills/create-impl-plan/SKILL.md` - 主要指令
- `skills/create-impl-plan/references/output-format.md` - 輸出格式範例
- `skills/create-impl-plan/references/completion-check-guide.md` - 完成檢查指引
- `skills/create-impl-plan/references/acceptance-test-guide.md` - 驗收測試指引

**完成檢查**
- 確認 `SKILL.md` 行數控制在 200 行以內
- 確認所有參考檔案都可透過連結存取
- 確認內容完整未遺失（總行數約等於原始 418 行）

**實作備註**
<!-- 執行過程中填寫重要的技術決策、障礙和需要傳遞的上下文 -->

---

### 遷移並拆分 process-task-list Skill

**實作要點**
- 分析 `commands/process-task-list.md`（255 行）的結構
- 建議拆分結構：
  - `SKILL.md`：主要指令（工作流程脈絡、任務實作流程、AI 指示）
  - `references/implementation-notes-guide.md`：實作備註品質檢查清單和填寫指引
- 255 行相對較小，可考慮不拆分或僅拆分實作備註相關內容
- frontmatter description 包含「任務執行」「process-task」「實作」「commit」等關鍵詞

**相關檔案**
- `commands/process-task-list.md` - 來源（255 行）
- `skills/process-task-list/SKILL.md` - 主要指令
- `skills/process-task-list/references/implementation-notes-guide.md` - 實作備註指引（可選）

**完成檢查**
- 確認 SKILL.md 結構清晰，易於閱讀
- 確認原有功能完整保留

**實作備註**
<!-- 執行過程中填寫重要的技術決策、障礙和需要傳遞的上下文 -->

---

### 遷移 acceptance-test Skill

**實作要點**
- 將 `agents/acceptance-tester.md` 遷移到 `skills/acceptance-test/SKILL.md`
- 修改 frontmatter 格式：
  - 移除 agent 專用欄位（model、color）
  - 保留 name 和 description
  - description 需重新撰寫，包含「驗收測試」「acceptance testing」「Gherkin」等關鍵詞
- 保留原有的測試執行邏輯和報告格式
- 107 行，無需拆分

**相關檔案**
- `agents/acceptance-tester.md` - 來源（107 行）
- `skills/acceptance-test/SKILL.md` - 目標

**完成檢查**
- 確認 frontmatter 只包含 name 和 description（不含 model、color）
- 確認驗收測試執行邏輯完整保留

**實作備註**
<!-- 執行過程中填寫重要的技術決策、障礙和需要傳遞的上下文 -->

---

### 更新安裝腳本支援 Skills

**實作要點**
- 修改 `scripts/install-config.js`，改為安裝 skills
- 新增目錄複製功能（遞迴複製整個 skill 目錄）
- 目標位置：`~/.claude/skills/`
- 保留衝突檢測邏輯（檢測目標目錄是否已存在同名 skill）
- 保留 overwrite 選項（強制覆寫）
- 新增舊 commands 清理功能：
  - 檢查 `~/.claude/commands/` 是否存在同名的 `.md` 檔案
  - 如果存在，自動刪除並顯示訊息
- 移除對 commands 和 agents 目錄的安裝支援
- 更新使用者回饋訊息（改為顯示 skills 相關資訊）

**相關檔案**
- `scripts/install-config.js` - 主要修改目標
- `package.json` - 確認 npm script 指令不需修改

**完成檢查**
- 執行 `node scripts/install-config.js` 確認無錯誤
- 確認 skills 被正確複製到 `~/.claude/skills/`
- 測試 overwrite 選項正常運作
- 測試舊 commands 清理功能

**實作備註**
<!-- 執行過程中填寫重要的技術決策、障礙和需要傳遞的上下文 -->

---

### 清理舊的 commands 和 agents 目錄

**實作要點**
- 確認所有 skills 已正確建立並測試通過
- 刪除專案中的 `commands/` 目錄
- 刪除專案中的 `agents/` 目錄
- 使用 git rm 確保版本控制正確追蹤刪除

**相關檔案**
- `commands/` - 待刪除目錄
- `agents/` - 待刪除目錄

**完成檢查**
- 確認 `commands/` 和 `agents/` 目錄不再存在
- 確認 git status 顯示正確的刪除記錄

**實作備註**
<!-- 執行過程中填寫重要的技術決策、障礙和需要傳遞的上下文 -->

---

### 執行驗收測試

**實作要點**
- 讀取 acceptance.feature 檔案
- 透過指令執行每個場景
- 驗證所有場景通過並記錄結果
- 如發現問題，記錄詳細的錯誤資訊和重現步驟

**相關檔案**
- `docs/specs/2025-12-26-migrate-to-skills/acceptance.feature` - Gherkin 格式的驗收測試場景
- `docs/specs/2025-12-26-migrate-to-skills/acceptance-report.md` - 詳細的驗收測試執行報告（執行時生成）

**實作備註**
<!-- 執行過程中填寫 -->

---

### 更新專案文件

**實作要點**
- 審查 README.md：
  - 更新安裝說明（從 commands 改為 skills）
  - 更新功能清單和使用方式
  - 更新目錄結構說明
- 審查 CLAUDE.md：
  - 更新專案架構說明（移除 commands/agents，新增 skills）
  - 更新安裝位置說明
  - 更新技術考量

**相關檔案**
- `README.md` - 專案主要說明文件
- `CLAUDE.md` - AI 助手的專案指引文件

**實作備註**
<!-- 執行過程中填寫 -->

---

## 實作參考資訊

### 來自研究文件的技術洞察
> **文件路徑：** `docs/research/2025-12-26-skills-vs-slash-commands.md`

**Skills 目錄結構**
```
~/.claude/skills/
├── skill-name/
│   ├── SKILL.md          # 必需
│   ├── references/       # 可選
│   │   └── guide.md
│   └── scripts/          # 可選
│       └── helper.py
```

**SKILL.md Frontmatter 格式**
```yaml
---
name: skill-name
description: 說明功能和使用時機，包含觸發關鍵詞（最多 1024 字元）
---
```

**Progressive Disclosure 三層結構**
1. Metadata（約 100 tokens）：name 和 description
2. Instructions（建議 < 5000 tokens）：SKILL.md 主體
3. Resources（按需載入）：references/、scripts/ 等

**User-Invocable 證據**
- GitHub Issue #10246 確認 `/skill-name` 語法在 CLI 和 VS Code 都可運作
- `disable-model-invocation: true` 可設定為僅手動調用

### 來自 PRD 的實作細節
> **文件路徑：** 參考上方 PRD 參考章節

**遷移來源檔案行數統計**
| 檔案 | 行數 | 拆分建議 |
|------|------|----------|
| commands/research.md | 216 | 不拆分 |
| commands/create-prd.md | 110 | 不拆分 |
| commands/create-impl-plan.md | 418 | 需拆分 |
| commands/process-task-list.md | 255 | 可選拆分 |
| agents/acceptance-tester.md | 107 | 不拆分 |

**安裝腳本關鍵變更**
- 複製整個目錄（而非單一檔案）
- 目標位置改為 `~/.claude/skills/`
- 新增舊 commands 清理功能

### 關鍵技術決策

1. **拆分閾值**：SKILL.md 建議控制在 500 行以內，本次以 200 行為目標進行拆分
2. **參考檔案路徑**：使用 `references/` 子目錄存放拆分出的參考內容
3. **description 策略**：遵循 Progressive Disclosure，包含功能說明和觸發關鍵詞
4. **舊 commands 清理**：安裝時自動檢測並刪除 `~/.claude/commands/` 下的同名檔案
