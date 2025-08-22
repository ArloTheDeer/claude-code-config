# 實作計畫

## PRD 參考

**PRD 文件路徑：** `docs/specs/2025-08-20-install-config-script/prd.md`

> **重要提醒：** 實作過程中請經常參考 PRD 文件以了解：
>
> - 功能的商業目標和用戶價值
> - 完整的用戶故事和使用場景
> - 非功能性需求（性能、安全性等）
> - 系統架構和技術決策的背景脈絡

## 相關檔案

- `package.json` - 專案配置檔案，包含 npm scripts 和相依套件
- `scripts/install-config.js` - 安裝腳本的主要實作檔案
- `commands/*.md` - 需要複製的指令文件來源
- `acceptance.feature` - Gherkin 格式的驗收測試場景

## 技術參考

### ShellJS 主要 API 使用說明

根據 ShellJS 文檔（`llm-docs/shelljs.md`），本專案會使用以下 API：

- **`shell.test()`** - 檢查檔案或目錄是否存在
  - `shell.test('-f', path)` 檢查是否為檔案
  - `shell.test('-d', path)` 檢查是否為目錄
  - `shell.test('-e', path)` 檢查路徑是否存在
  
- **`shell.mkdir()`** - 建立目錄
  - `shell.mkdir('-p', targetDir)` 遞迴建立目錄（包含父目錄）
  - 跨平台相容，自動處理 Windows/Unix 差異
  
- **`shell.cp()`** - 複製檔案
  - `shell.cp('source', 'dest')` 複製單一檔案
  - `shell.cp('-r', 'source/*', 'dest/')` 遞迴複製
  - `shell.cp('-f', 'source', 'dest')` 強制覆蓋
  
- **`shell.ls()`** - 列出檔案
  - `shell.ls('*.md')` 列出所有 .md 檔案
  - 返回 ShellString 陣列，可用 forEach 迭代
  
- **`shell.error()`** - 檢查錯誤
  - 在執行命令後檢查是否有錯誤發生
  - 返回錯誤訊息或 null

### Inquirer.js 主要 API 使用說明

根據 Inquirer.js 文檔（`llm-docs/inquirerjs.txt`），本專案會使用：

- **基本安裝**
  ```bash
  npm install inquirer
  ```

- **confirm 提示** - 用於詢問使用者是否覆蓋檔案
  ```javascript
  import inquirer from 'inquirer';
  
  const answers = await inquirer.prompt([{
    type: 'confirm',
    name: 'overwrite',
    message: '發現以下檔案已存在，是否要覆蓋？',
    default: false
  }]);
  ```

- **錯誤處理**
  ```javascript
  inquirer.prompt([/* questions */])
    .then((answers) => {
      // 處理回答
    })
    .catch((error) => {
      if (error.isTtyError) {
        // 提示無法在當前環境渲染
      } else {
        // 其他錯誤
      }
    });
  ```

### 程式碼範例結構

```javascript
const shell = require('shelljs');
const path = require('path');
const os = require('os');
const inquirer = require('inquirer');

async function installConfig() {
  try {
    // 設定目標路徑
    const targetDir = path.join(os.homedir(), '.claude', 'commands');
    
    // 檢查並建立目錄
    if (!shell.test('-d', targetDir)) {
      shell.mkdir('-p', targetDir);
      if (shell.error()) {
        throw new Error(`無法建立目錄: ${shell.error()}`);
      }
    }
    
    // 取得檔案清單
    const files = shell.ls('commands/*.md');
    
    // 檢查衝突檔案
    const conflicts = [];
    files.forEach(file => {
      const filename = path.basename(file);
      const targetPath = path.join(targetDir, filename);
      if (shell.test('-f', targetPath)) {
        conflicts.push(filename);
      }
    });
    
    // 如果有衝突，詢問使用者
    if (conflicts.length > 0) {
      const { overwrite } = await inquirer.prompt([{
        type: 'confirm',
        name: 'overwrite',
        message: `發現以下檔案已存在：${conflicts.join(', ')}\n是否要覆蓋現有檔案？`,
        default: false
      }]);
      
      if (!overwrite) {
        console.log('安裝已取消，未修改任何檔案');
        return;
      }
    }
    
    // 複製檔案
    files.forEach(file => {
      shell.cp(file, targetDir);
      if (shell.error()) {
        console.error(`錯誤：無法複製 ${file}`);
      }
    });
    
    console.log(`✅ 安裝成功！已安裝 ${files.length} 個檔案到 ${targetDir}`);
    
  } catch (error) {
    console.error(`錯誤：${error.message}`);
    process.exit(1);
  }
}

// 執行安裝
installConfig();
```

## 任務

- [ ] 1. 初始化 Node.js 專案並安裝相依套件
  - 1.1 使用 `npm init` 初始化專案並建立 package.json
  - 1.2 使用 `npm install shelljs` 安裝跨平台檔案操作套件
  - 1.3 使用 `npm install inquirer` 安裝使用者互動套件
  - 1.4 使用 `npm install chalk` 安裝彩色終端輸出套件（可選）
  - 1.5 確認所有套件都已安裝最新版本並記錄在 package.json

- [ ] 2. 建立安裝腳本的主程式架構
  - 2.1 建立 scripts 資料夾
  - 2.2 建立 install-config.js 檔案
  - 2.3 引入必要的模組（shelljs、inquirer、os、path）
  - 2.4 建立主函數架構與錯誤處理包裝

- [ ] 3. 實作跨平台目標路徑處理
  - 3.1 使用 `process.platform` 偵測作業系統類型（'win32', 'darwin', 'linux'）
  - 3.2 根據作業系統設定正確的目標路徑
    - Windows: `path.join(os.homedir(), '.claude', 'commands')`
    - macOS/Linux: `path.join(os.homedir(), '.claude', 'commands')`
  - 3.3 使用 `os.homedir()` 取得使用者主目錄
  - 3.4 使用 `path.join()` 建構跨平台相容的路徑
  - 3.5 確保路徑處理正確（ShellJS 自動處理路徑分隔符號）

- [ ] 4. 實作檔案衝突檢查與使用者互動
  - 4.1 使用 `shell.ls('commands/*.md')` 取得所有 .md 檔案清單
  - 4.2 使用 `shell.test('-f', targetPath)` 檢查每個檔案是否已存在
  - 4.3 如果發現衝突，使用 inquirer.prompt() 詢問使用者是否覆蓋
    ```javascript
    const { overwrite } = await inquirer.prompt([{
      type: 'confirm',
      name: 'overwrite',
      message: `發現以下檔案已存在：${conflicts.join(', ')}\n是否要覆蓋現有檔案？`,
      default: false
    }]);
    ```
  - 4.4 處理使用者的選擇（覆蓋或取消）
  - 4.5 提供清晰的衝突檔案清單顯示

- [ ] 5. 實作檔案複製與目錄管理
  - 5.1 使用 `shell.test('-d', targetDir)` 檢查目標目錄是否存在
  - 5.2 使用 `shell.mkdir('-p', targetDir)` 遞迴建立目錄結構
  - 5.3 逐一複製檔案到目標路徑
    ```javascript
    files.forEach(file => {
      shell.cp(path.join('commands', file), targetDir);
      if (shell.error()) {
        console.error(`錯誤：無法複製 ${file}`);
      }
    });
    ```
  - 5.4 使用 `shell.error()` 處理檔案複製時的錯誤
  - 5.5 保持檔案的原始名稱和結構

- [ ] 6. 完成 npm script 設定與使用者回饋
  - 6.1 編輯 package.json 的 scripts 區段，新增 "install-config": "node scripts/install-config.js"
  - 6.2 實作安裝成功的訊息顯示
    ```javascript
    console.log(`✅ 安裝成功！已安裝 ${fileCount} 個檔案到 ${targetDir}`);
    ```
  - 6.3 顯示已安裝的檔案數量和路徑
  - 6.4 實作錯誤訊息的友善顯示（捕捉例外並顯示清楚訊息）
  - 6.5 測試各種錯誤情況的處理（權限不足、路徑不存在等）

- [ ] 7. 執行驗收測試
  - 7.1 使用 AI 讀取 acceptance.feature 檔案
  - 7.2 透過指令執行每個測試場景
  - 7.3 驗證所有場景通過並記錄結果