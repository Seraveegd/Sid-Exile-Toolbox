> 🌐 Language: **English** | [繁體中文](README.zh-TW.md)

# Sid's Exile Super Toolbox (Open Source Edition)

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/Sid-1996/Sid-Exile-Toolbox/total)


**Target game**: Path of Exile 1  
**Language**: AutoHotkey  
**License**: GNU AGPLv3 (open source, protects user freedom; derivatives must use the same license)

---

## ✨ Feature Overview

This toolbox provides a variety of auxiliary features to help players enjoy Path of Exile more easily. All features are unlocked and free of charge.

| Category | Feature | Hotkey |
|----------|---------|--------|
| Combat | One-key flask / cyclic flask / flask anti-fail | Space (configured via Win+Z) |
|        | Auto flask (detects life/mana) | F10 (requires Win+C detection points) |
|        | Auto logout (returns to character select at low HP) | same as above |
|        | Manual logout (F1 toggle to logout mode) | F1 (toggle with Win+F1 first) |
|        | Skill combo | Q/W/E/R/T (configuration required) |
|        | Auto detonate mines | Q/W/E/R/T (configuration required) |
|        | Cycling skills | Insert |
| Inventory | One-key cleanup (hold / auto / scan / quick scan) | F3 |
|        | Quick pickup (one-key currency / coordinate location) | F6 (toggle mode with Win+F6 first) |
|        | Quick open portal scroll | F4 |
|        | Divination card exchange (single / multiple) | F8 |
| Trade & Party | Quick trade (confirm 60 slots / accept) | PgUp / PgDn |
|        | Quick trade request (with reminder) | Home |
|        | Quick party request (with reminder) | End |
|        | Trade reminder panel | Win+Home |
|        | Party reminder panel | Win+End |
| Stash Search | Quick search aut-paging | Ctrl+Alt |
|        | Back to stash first page | Ctrl+Win |
| Price Check | Open external price-check window | Win+V |
| Mouse | Auto-click (wheel button / Ctrl+Left) | MButton / Ctrl+LButton |
|        | Auto-click speed panel | Win+Z → Mouse auto-click settings |
| System | Quick return to hideout | F5 |
|        | AFK / Do-Not-Disturb / Auto-reply (3 modes) | F2 (select mode with Win+F2 first) |
|        | Pause tool (restore keyboard) | F9 |
|        | Reload tool / Exit tool | F11 / F12 |
| Mode Detection | Text / game mode auto switch | Enter / Ctrl+F / paste item / hold left click |
|        | Esc auto returns to POE window when price-checking | Esc |

**Advanced Settings**:
- **Win + Z**: Open the full feature menu for parameter adjustments
  - Tool intro (full feature list / hotkey list)
  - Switch character profile
  - Flask trigger settings
  - Detection flask settings
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
- **Win + F6**: F6 hotkey toggle (quick pickup / pickup coordinate location)
- **Win + F8**: F8 hotkey toggle (single / multiple divination card exchanges)
- **F7**: Locate stash, trade window, and divination card exchange coordinates

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

After extracting, double-click `Sid流亡超級工具箱(開源版).ahk` to start.

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
| `Sid流亡超級工具箱(開源版).ahk` | Main program script |
| `sidtooldata.ini` | Settings file (auto-generated) |
| `sidtooldata2.ini` | Second character profile |
| `sidtooldata3.ini` | Third character profile |

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
