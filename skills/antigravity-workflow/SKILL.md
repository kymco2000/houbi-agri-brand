---
name: antigravity-workflow
description: AntiGravity 開工/收工/新專案初始化流程。說「開工」「收工」「初始化專案」時載入。
---

# 開工 / 收工 / 新專案初始化

## 開工
1. 讀取 `ANTIGRAVITY.md`
2. 讀取專案筆記重點
3. `git status` + 最近 commit
4. 回報狀態與建議下一步
5. 不自動 pull/commit/push

## 收工
1. 檢查敏感資料（API key、token、學生真名等）
2. 更新專案筆記（完成事項、下一步、踩坑）
3. 將本次有長期價值的知識、決策與可重用流程同步到使用者指定的 Obsidian vault；依領域路由，保留來源、日期、假設與限制，讀回驗證。專案原始檔與工作狀態仍以專案正式來源及 HANDOFF.md 為準。
4. 收工必須將本次新增或修訂、且已獲授權同步的專案資料與衍生筆記上傳至對應的既有 NotebookLM 筆記本；先檢查來源避免重複，明示學生推導／草稿及未核定部分，確認 ready 並讀回關鍵內容。未明確授權的敏感原件不得隨摘要擴大上傳。找不到對應筆記本時先查既有專案路由，不自行混入其他課程或工程。
5. 沒有新增或修訂內容時，檢查後註明無需同步；登入失效、路由不明或上傳失敗時，保留本地筆記並明示未完成與原因，不得回報同步成功。將筆記路徑、NotebookLM 筆記本／source ID 與驗證結果記入交接。
6. 只在規則改變時更新 ANTIGRAVITY.md
7. 檢查 git status + diff
8. 只 stage 本次相關檔案（不用 `git add .`），不混入他人或先前未確認的修改
9. 確認後 commit + push
10. 分別回報本地交接、Obsidian、NotebookLM及Git狀態。依專案約定同步至 Obsidian 與 NotebookLM。Git 提交或公開發布需有相應授權。

## 新專案初始化
先問：名稱、用途、資料夾、是否 GitHub repo、公開/私有、是否部署。
建立：ANTIGRAVITY.md、README.md、.gitignore、Git repo、GitHub repo、專案筆記。
若已存在 → 盤點後只補缺口，不覆蓋。
