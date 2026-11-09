# 後壁農產品牌開發懶人包

以後壁自耕農為案例，從供應盤點、競品查價、詢價到同批收益比較。包括洋香瓜公開市調、稻米方案 A 與可重用的 Codex 技能。

## 安裝 Codex 技能

在 PowerShell 輸入。需要支援 `gh skill` 的 GitHub CLI。

```powershell
gh skill install kymco2000/houbi-agri-brand houbi-agri-market --agent codex --scope user
```

重新開啟 Codex 後輸入 `$houbi-agri-market 幫我比較後壁自產稻米現行出售與品牌白米`。

## Windows 一次設定

需要 Git、GitHub CLI、Windows PowerShell 及 WinGet。下載和執行前可先查看 [setup.ps1](setup.ps1)。

```powershell
git clone https://github.com/kymco2000/houbi-agri-brand.git
Set-Location houbi-agri-brand
powershell -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1 -OpenObsidian
```

腳本安裝技能，檢查並在需要時從 WinGet 下載與安裝 Obsidian。它會把公開個案筆記複製到獨立範例 Vault `local-vault`，保留使用者已編輯的檔案。若 Obsidian 尚未註冊這個 Vault，在 Obsidian 選「開啟資料夾作為儲存庫」並選擇 `local-vault`。可用 `-VaultPath` 指定自己的 Vault，資料會放在其下的 `後壁農產品牌開發`。

## NotebookLM 協作

使用社群維護的 [NotebookLM MCP CLI](https://github.com/jacob-bd/notebooklm-mcp-cli) 接上自己的 Google 帳號。以下腳本會在缺少工具時安裝 uv 與 CLI，接著註冊 Codex MCP，並在需要時開啟登入流程。重新開啟 Codex 以載入 MCP。

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1 -SkipSkill -ConnectNotebookLM
nlm notebook list
nlm notebook create "後壁農產品牌開發"
powershell -NoProfile -ExecutionPolicy Bypass -File .\setup.ps1 -SkipSkill -NotebookId YOUR_NOTEBOOK_UUID
```

已有筆記本時使用 `nlm notebook list` 的 UUID。同步只讀取 `references` 的四篇公開 Markdown，來源標題含內容雜湊以跳過已存在的版本。個案二的價格與公式工作簿請在 Excel 開啟，NotebookLM 使用同一個案的文字摘要。在 Codex 可請技能查詢該筆記本並核對引用，再把可重用結論寫進自己的 Vault。筆記本分享由帳號擁有人在 NotebookLM 設定。

## 內容

- [技能與資料入口](skills/houbi-agri-market/SKILL.md)
- [洋香瓜市調](skills/houbi-agri-market/references/個案一_後壁洋香瓜_初步市調.md)
- [洋香瓜詢價名單](skills/houbi-agri-market/references/個案一_後壁洋香瓜_詢價名單.md)
- [稻米方案 A](skills/houbi-agri-market/references/個案二_後壁稻米_方案A.md)
- [稻米競品與收益 Excel](skills/houbi-agri-market/assets/個案二_後壁米競品與收益試算.xlsx)

市調價格為 2026-11-09 公開頁面快照。稻米個案的農戶與碾米廠資料待確認。Obsidian 可從[官方下載頁](https://obsidian.md/download)手動安裝。
