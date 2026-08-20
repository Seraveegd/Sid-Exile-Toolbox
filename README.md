# Sid's Exile Super Toolbox (Open Source Edition) / Sid 流亡超級工具箱 (開源版)

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/Sid-1996/Sid-Exile-Toolbox/total)

> 🌐 [**English**](#english) | [**繁體中文**](#chinese)

---

<h2 id="english">English</h2>

**Target game**: Path of Exile 1  
**Language**: AutoHotkey  
**License**: GNU AGPLv3 (open source, protects user freedom; derivatives must use the same license)

---

## ✨ Feature Overview

This toolbox provides a variety of auxiliary features to help players enjoy Path of Exile more easily. All features are unlocked and free of charge.

| Category | Feature | Hotkey |
|----------|---------|--------|
| Combat | One-key flask / cyclic flask / flask anti-fail | Space (configured via Win+Z) |
|        | Manual logout (F1 toggle to logout mode) | F1 (toggle with Win+F1 first) |
|        | Skill combo | Q/W/E/R/T (configuration required) |
|        | Auto detonate mines | Q/W/E/R/T (configuration required) |
|        | Cycling skills | Insert |
| Inventory | One-key cleanup (hold / auto / scan / quick scan) | F3 |
| Trade & Party | Quick party request (with reminder) | End |
|        | Party reminder panel | Win+End |
| Stash Search | Quick search aut-paging | Ctrl+Alt |
|        | Back to stash first page | Ctrl+Win |
| Price Check | Open external price-check window | Win+V |
| Mouse | Auto-click (wheel button / Ctrl+Left) | MButton / Ctrl+LButton |
|        | Auto-click speed panel | Win+Z → Mouse auto-click settings |
| System | AFK / Do-Not-Disturb / Auto-reply (3 modes) | F2 (select mode with Win+F2 first) |
|        | Pause tool (restore keyboard) | F9 |
|        | Reload tool / Exit tool | F11 / F12 |
| Mode Detection | Text / game mode auto switch | Enter / Ctrl+F / paste item / hold left click |
|        | Esc auto returns to POE window when price-checking | Esc |

**Advanced Settings**:
- **Win + Z**: Open the full feature menu for parameter adjustments
  - Tool intro (full feature list / hotkey list)
  - Flask trigger settings
  - Skill combo settings
  - Cycling skill settings
  - Quick stash search settings
  - Mouse auto-click settings
  - Auto detonate mines settings
  - Links to price-check tool (TW server / international server)
  - Links to author Sid's website
- **Win + C**: Set screen detection points (HP bar, mana orb, dialog box, etc.)
- **Win + F1**: F1 hotkey toggle (original keyboard / logout mode)
- **Win + F2**: F2 hotkey toggle (AFK / Do-Not-Disturb / Auto-reply)
- **Win + F3**: F3 hotkey toggle (hold / auto / scan / quick-scan cleanup)
- **F7**: Locate stash, trade window, and divination card exchange coordinates

## 📺 Tutorials

For detailed video tutorials and step-by-step image guides, visit the official website:
> **https://sid-1996.github.io/sid-automation-lab/sidexiletoolbox.html**

The website contains more in-depth information than this README, including setup walkthroughs and visual references.

## ⚠️ Disclaimer

This software is an external tool developed for educational and learning purposes. It only interacts with the game through screenshots and simulated keyboard input; it does not modify any game files or code, nor does it read game memory.

This software is for personal study and exchange only, limited to personal game accounts, and must not be used for any commercial or profit-making purposes. The development team reserves the right of final interpretation of this project. Any issues arising from the use of this software are unrelated to the project and its developers. If you find merchants using this software for paid power-leveling, that is the merchant's own behavior; this software is not authorized for power-leveling services, and any resulting issues are unrelated to this software. This software is not authorized for resale by anyone; resold software may contain malicious code that could lead to the theft of game accounts or computer data, which is unrelated to this software.

**Important reminder**: According to Grinding Gear Games' Path of Exile terms of service, the game may prohibit the use of any third-party automation tools. Using this tool carries account risk; please evaluate carefully.

### Risk Warnings

1. **Account risk**: Using this tool may result in account banning. Please understand the risks before use.
2. **Personal responsibility**: Any account issues caused by using this tool are the user's own responsibility.
3. **Compliant use**: Please ensure that you use this tool within the scope permitted by local laws.

---

## 📖 Quick Start

### 1. Requirements
- Install [AutoHotkey v1.1](https://www.autohotkey.com/)
- > ⚠️ This tool is built on AHK **v1.1**; do not install v2, as the syntax is incompatible.
- This tool only supports **Path of Exile windowed mode** (fullscreen windowed or windowed)

### 2. Download and Run
Click `Code` in the top-right → `Download ZIP`, or clone with Git:

```bash
git clone https://github.com/Sid-1996/Sid-Exile-Toolbox.git
```

After extracting, double-click `Sid-Exile-Toolbox(en).ahk` to start.

### 3. Initial Setup
1. Press **Win + Z** to open the feature menu, then enter "Detection flask settings" and "Flask trigger settings" to adjust your preferences
2. Press **Win + C** to set the screen detection points
3. Press **F7** to locate your stash, trade window, and other coordinates

---

## 🔍 Detection Point Settings (Win + C)

| # | Description |
|---|-------------|
| 1 | HP bar above character (color when out of HP) |
| 2 | Logout point on HP bar above character (color when out of HP) |
| 3 | Bottom-right mana orb (color when full) |
| 4 | Scene detection point (black time area above flask bar) |
| 5 | Enter dialog box (1) black area |
| 6 | Enter dialog box (2) black area |
| 7 | HP detection point for chaos damage penetrating ES |
| 8 | Logout point for chaos damage penetrating ES |
| 9 | Bottom-left life pool (color when full) |

Settings are stored in `sidtooldata.ini`, with support for up to three character profiles.

---

## 📁 File Description

| File | Purpose |
|------|---------|
| `Sid-Exile-Toolbox.ahk` | Main program script |
| `sidtooldata.ini` | Settings file (auto-generated) |

> ⚠️ `.ini` files are included in `.gitignore`; personal coordinate data will not be uploaded.

---

## 💬 Author's Note

In the pre-AI era, every line was hand-typed.

Changed again and again, broken then fixed—a 4,000-line script accumulated character by character.
When I ran into problems, no one could answer my questions; I could only study old forum threads on my own.
When my reasoning was wrong, I thought it through again!

Eight years.

Later, POE2 came out, and I haven't touched this for a long time.
Rather than letting it gather dust, I'd rather open-source it—
let those still playing continue to improve it.

— Sid

---

## 🙏 Acknowledgements

Original author: **Sid**  
Independently developed in full. Thank you for your continued support and love, fellow exiles.

If you like this tool, please give it a ⭐ Star and share it with other players!

---

<h2 id="chinese">繁體中文</h2>

**適用遊戲**：Path of Exile 1（流亡黯道 一代）  
**開發語言**：AutoHotkey  
**授權**：GNU AGPLv3（開源、保障使用者自由，衍生軟體需以同授權釋出）

---

## ✨ 功能總覽

本工具提供多樣化的輔助功能，協助玩家更輕鬆地遊玩《流亡黯道》。所有功能皆已解鎖，無須付費。

| 類別 | 功能 | 熱鍵 |
|------|------|------|
| 戰鬥輔助 | 一鍵喝水/循環喝水/藥劑防呆 | Space (搭配 Win+Z 設定) |
|          | 手動返角 (F1 切換至返角模式) | F1 (需先用 Win+F1 切換) |
|          | 技能連段 | Q/W/E/R/T (需設定) |
|          | 自動引爆地雷 | Q/W/E/R/T (需設定) |
|          | 循環使用技能 | Insert |
| 背包管理 | 一鍵清包 (按壓/自動/掃描/掃描快搜) | F3 |
| 交易組隊 | 快速申請組隊 (含確認提醒) | End |
|          | 組隊提醒開關設定面板 | Win+End |
| 倉庫搜尋 | 快搜倉庫自動翻頁 | Ctrl+Alt |
|          | 返回倉庫首頁 | Ctrl+Win |
| 查價工具 | 呼叫外部查價視窗 | Win+V |
| 滑鼠輔助 | 滑鼠連點 (滾輪下壓/Ctrl+左鍵) | MButton / Ctrl+LButton |
|          | 滑鼠連點速度設定面板 | Win+Z → 滑鼠連點設置 |
| 系統控制 | 暫離/勿擾/自動回復 (三模式切換) | F2 (需先用 Win+F2 選擇模式) |
|          | 暫停工具 (回復鍵盤) | F9 |
|          | 重新載入工具 / 結束工具 | F11 / F12 |
| 模式偵測 | 文字/遊戲模式自動切換 | Enter / Ctrl+F / 貼上物品 / 長按左鍵 |
|          | 查價時 Esc 自動返回 POE 視窗 | Esc |

**進階設定**：  
- **Win + Z**：開啟完整功能菜單，可進行各項參數調整  
  - 工具介紹（完整功能列表 / 熱鍵列表）  
  - 藥劑觸發設置  
  - 技能連段設置  
  - 循環技能設置  
  - 快搜倉庫設置  
  - 滑鼠連點設置  
  - 自動引爆地雷設置  
  - 前往查價工具的網址（台服/國際服）  
  - 前往 Sid 作者網站  
- **Win + C**：設定畫面偵測點（血條、魔球、對話框等）  
- **Win + F1**：F1 熱鍵切換（原始鍵盤 / 返角模式）  
- **Win + F2**：F2 熱鍵切換（暫離 / 勿擾 / 自動回復）  
- **Win + F3**：F3 熱鍵切換（按壓 / 自動 / 掃描 / 掃描快搜清包）  
- **F7**：定位背包、交易欄位、命運卡兌換座標  

## 📺 教學影片與圖片

更詳細的教學影片與步驟圖解請至官方網站：
> **https://sid-1996.github.io/sid-automation-lab/sidexiletoolbox.html**

網站包含比 README 更深入的資訊，含設定教學與圖文對照。

## ⚠️ 免責聲明

本軟體是一個外部工具，專為教育和學習目的而開發。它僅通過螢幕截圖和模擬鍵盤輸入與遊戲交互，不會修改任何遊戲文件或代碼，也不會讀取遊戲記憶體。

本軟體僅供個人學習交流使用，僅限於個人遊戲帳號，不得用於任何商業或營利性目的。開發者團隊擁有本項目的最終解釋權。使用本軟體產生的所有問題與本項目及開發者團隊無關。若您發現商家使用本軟體進行代練並收費，這是商家的個人行為，本軟體不授權用於代練服務，產生的問題及後果與本軟體無關。本軟體不授權任何人進行售賣，售賣的軟體可能被加入惡意代碼，導致遊戲帳號或電腦資料被盜，與本軟體無關。

**重要提醒**：根據 Grinding Gear Games 的《Path of Exile》服務條款，遊戲可能禁止使用任何第三方自動化工具。使用此工具存在帳號風險，請謹慎評估。

### 風險警告

1. **帳號風險**：使用本工具可能導致帳號被封。請在了解風險後再使用。
2. **個人責任**：任何因使用本工具導致的帳號問題，均由使用者自行承擔。
3. **合規使用**：請確保在當地法律允許的範圍內使用本工具。

---

## 📖 快速入門

### 1. 環境需求
- 安裝 [AutoHotkey v1.1](https://www.autohotkey.com/)
- > ⚠️ 本工具基於 AHK **v1.1**，請勿安裝 v2，兩者語法不相容。
- 本工具僅支援 **Path of Exile 視窗模式**（全螢幕視窗化或視窗化）

### 2. 下載與執行
點選右上角 `Code` → `Download ZIP`，或使用 Git 克隆：

```bash
git clone https://github.com/Sid-1996/Sid-Exile-Toolbox.git
```

解壓後雙擊 `Sid-Exile-Toolbox(zh).ahk` 即可啟動。

### 3. 初始設定
1. 按 **Win + Z** 打開功能選單，進入「偵測喝水設置」與「藥劑觸發設置」調整偏好
2. 按 **Win + C** 設定畫面偵測點
3. 按 **F7** 定位背包、交易視窗等座標

---

## 🔍 偵測點設定 (Win + C)

| 代號 | 說明 |
|------|------|
| 1 | 人物頭上血條（沒血時的顏色） |
| 2 | 人物頭上血條返角點（沒血時的顏色） |
| 3 | 右下魔力球（滿魔時的顏色） |
| 4 | 場景偵測點（藥劑欄上方黑色時間區域） |
| 5 | Enter 對話框 (1) 黑色區域 |
| 6 | Enter 對話框 (2) 黑色區域 |
| 7 | 混傷穿透 ES 的血條偵測點 |
| 8 | 混傷穿透 ES 的血條返角點 |
| 9 | 左下血球池（滿血時的顏色） |

設定儲存於 `sidtooldata.ini`。

---

## 📁 檔案說明

| 檔案 | 用途 |
|------|------|
| `Sid-Exile-Toolbox.ahk` | 主程式腳本 |
| `sidtooldata.ini` | 設定檔（自動產生） |

> ⚠️ `.ini` 檔案已納入 `.gitignore`，不會上傳個人座標資訊。

---

## 💬 作者感言

沒有 AI 的年代，每一行都是手打的。

改了又改、壞了再修，4000 行就這樣一個字一個字積出來。
遇到問題沒有人問，只能對著 AHK 論壇的過去文檔自己研究。
想錯了，再想!

八年。

後來 POE2 出了，我也很久沒再碰它了。
與其讓它就這樣躺著，不如開源——
讓還在玩的人自己接著改。

— Sid

---

## 🙏 致謝

原創作者：**Sid**  
完全獨立開發，感謝一直以來支持與厚愛，謝謝各位流亡者們。

如果你喜歡這個工具，歡迎給顆 ⭐ Star，並分享給其他玩家！
