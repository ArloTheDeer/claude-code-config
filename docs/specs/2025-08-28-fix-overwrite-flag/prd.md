# PRD: 修復 --overwrite 參數無法正常工作的問題

## 簡介/概述

修復 `npm run install-config -- --overwrite` 命令中 `--overwrite` 參數無法正確傳遞到 `scripts/install-config.js` 腳本的問題。目前執行該命令時，npm 會顯示警告訊息並且腳本無法接收到覆蓋模式的指示，導致安裝程序在發現現有檔案時停止執行。

## 目標

1. 確保 `--overwrite` 參數能夠正確傳遞給 `install-config.js` 腳本
2. 消除 npm 的 "Unknown cli config" 警告訊息
3. 讓覆蓋功能按照預期工作，能夠覆蓋 `C:\Users\arlo\.claude\commands` 目錄中的現有檔案
4. 保持首次安裝功能的正常運作

## 使用者故事

作為開發者，我想要能夠使用 `npm run install-config -- --overwrite` 命令來強制覆蓋現有的配置檔案，這樣我就能夠更新到最新版本的命令檔案，而不需要手動刪除舊檔案。

## 功能需求

1. **FR001**: 執行 `npm run install-config -- --overwrite` 命令時，不應該出現 npm 的 "Unknown cli config" 警告
2. **FR002**: `--overwrite` 參數必須能夠正確傳遞到 `install-config.js` 腳本
3. **FR003**: 當 `--overwrite` 參數存在時，腳本必須能夠覆蓋 `C:\Users\arlo\.claude\commands` 目錄中的現有檔案
4. **FR004**: 覆蓋操作完成後，必須驗證新版本的檔案已正確複製到目標位置
5. **FR005**: 首次安裝（沒有現有檔案）的功能必須保持正常運作
6. **FR006**: 當覆蓋操作失敗時，必須顯示清楚的錯誤訊息

## 非目標（超出範圍）

1. 不會修改腳本的基本功能邏輯
2. 不會改變目標安裝目錄的路徑
3. 不會添加除錯誤顯示之外的額外錯誤處理機制
4. 不會影響其他依賴此腳本的功能

## 技術考量

1. **參數傳遞問題**: 目前的問題可能是因為 npm CLI 對 `--` 後的參數處理方式導致
2. **現有實作**: `install-config.js` 腳本已經包含處理 `--overwrite` 參數的邏輯（第8行：`process.argv.includes('--overwrite')`）
3. **npm 腳本配置**: 可能需要調整 `package.json` 中的腳本配置或參數傳遞方式

## 驗收標準

1. **AC001**: 執行 `npm run install-config -- --overwrite` 時不出現 npm 警告
2. **AC002**: 控制台顯示 "Overwrite mode: enabled" 而不是 "Overwrite mode: disabled"
3. **AC003**: 現有檔案能夠被成功覆蓋
4. **AC004**: 覆蓋完成後，目標目錄中的檔案是最新版本
5. **AC005**: 不使用 `--overwrite` 參數時，首次安裝功能正常運作

## 開放問題

1. npm 警告的確切原因是什麼？是 npm 版本相關還是參數傳遞方式的問題？
2. 是否需要考慮其他方式來傳遞覆蓋參數（例如環境變數）？

## 參考資料

- 現有的 `scripts/install-config.js` 腳本實作
- 使用者提供的錯誤訊息和執行結果