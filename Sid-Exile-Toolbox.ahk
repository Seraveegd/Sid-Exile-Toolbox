#NoEnv
#SingleInstance force
#InstallKeybdHook
#InstallMouseHook
#MaxHotkeysPerInterval 400
SetBatchLines -1
ListLines, Off
Process, Priority,, High
SetKeyDelay, 0
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, 0
SetControlDelay, 0
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetTitleMatchMode, 3
SetWorkingDir, %A_ScriptDir%

if A_IsCompiled
{
	FileCreateDir, %A_ScriptDir%\ui
	FileInstall, ui\ui.html, ui\ui.html, 1
	FileInstall, ui\ui.css, ui\ui.css, 1
	FileInstall, ui\ui.js, ui\ui.js, 1
	FileInstall, ui\bootstrap.min.css, ui\bootstrap.min.css, 1
	FileInstall, ui\bootstrap.min.js, ui\bootstrap.min.js, 1
}

#Include Neutron.ahk

global neutron:= new NeutronWindow()

; 為解決編譯後若檔案路徑包含中文導致 res:// 協定無法載入網頁的問題，
; 改為直接載入由 FileInstall 解壓縮至本地目錄的 ui\ui.html
NeutronLoadLocal(neutron, "ui\ui.html")

NeutronLoadLocal(neutronInstance, fileName) {
	url:= A_ScriptDir "/" fileName
	neutronInstance.wb.Navigate(url)
	while neutronInstance.wb.readyState < 3
		Sleep, 50
	neutronInstance.wnd.neutron:= neutronInstance
	neutronInstance.wnd.ahk:= new neutronInstance.Dispatch(neutronInstance)
	while neutronInstance.wb.readyState < 4
		Sleep, 50
}

; === 腳本最上方（自動執行段） ===
GroupAdd, PoEGames, Path of Exile
GroupAdd, PoEGames, Path of Exile 2
GroupAdd, DualWins, ahk_group PoEGames
GroupAdd, DualWins, % "ahk_id " . neutron.hWnd

;[讀取記錄區]------------------------------------------------------------------------------------------------------

gosub,讀取F7背包定位內容
gosub,背包運算作業
gosub,讀取F1按鍵模式
gosub,讀取F3按鍵模式
gosub,讀取清包保留格
gosub,讀取補充傳送卷軸設置
gosub,讀取倉庫頁數據
gosub,讀取背包初始顏色
gosub,讀取回復模式
gosub,讀取自動回復內容
gosub,讀取快速組隊提醒功能_Label
gosub,讀取連點模式
gosub,讀取滑鼠連點速度
gosub,座標顏色讀取
gosub,讀取地雷設置
gosub,讀取技能連段數據
gosub,讀取循環技能設置
gosub,讀取藥劑觸發紀錄
gosub,讀取自訂快捷鍵
gosub,註冊動態熱鍵
gosub,讀取討價還價定位
gosub,讀取交換寶石定位
gosub,讀取洗詞設置

;[寫入預設值]------------------------------------------------------------------------------------------------------

聲明顯示 = 0
clickStop = false
Toolbutton = 0
Autodrinkbutton = 0
偵測場景顏色 = 變化中
Enter除錯提醒次數 = 0
openI = 0
StopUser = 0
防呆藥水鎖1 = 無
防呆藥水鎖2 = 無
防呆藥水鎖3 = 無
防呆藥水鎖4 = 無
防呆藥水鎖5 = 無
;=探險討價還價參數=
vMouseMoveDelaySpeedMin:= 35
vMouseMoveDelaySpeedMax:= 45
vClickDelaySpeed:= 40
vHagglingScrollSpeedMin:= 20
vHagglingScrollSpeedMax:= 30
vFirstMin:= 14
vFirstMax:= 16
vLastMin:= 5
vLastMax:= 8
;=寶石交換參數=
vGemDelay:= 60
寶石副手切換:= 0
;------------------------------------------------------------------------------------------------------
if 連點模式 = ERROR
{
	連點模式 = 滑鼠滾輪按壓
}
;------------------------------------------------------------------------------------------------------
if 清包模式 = ERROR
{
	清包模式 = 按壓式
}
if 快速組隊提醒 = ERROR
{
	快速組隊提醒 = 開啟
}
if 快速交易提醒 = ERROR
{
	快速交易提醒 = 開啟
}
;------------------------------------------------------------------------------------------------------
if 命運卡兌換模式 = ERROR
{
	命運卡兌換模式 = 單次兌換模式
}
;------------------------------------------------------------------------------------------------------
if 循環技能1 = ERROR
{
	循環技能1 = T
}
if 循環技能2 = ERROR
{
	循環技能2 = T
}
if 循環技能3 = ERROR
{
	循環技能3 = T
}
if 循環技能時間1 = ERROR
{
	循環技能時間1 = Off
}
if 循環技能時間2 = ERROR
{
	循環技能時間2 = Off
}
if 循環技能時間3 = ERROR
{
	循環技能時間3 = Off
}
;------------------------------------------------------------------------------------------------------
if 藥劑觸發模式 = ERROR
{
	藥劑觸發模式 = 無
}
if 使用技能時觸發的藥劑 = ERROR
{
	使用技能時觸發的藥劑 = 12345
}
if 主要技能 = ERROR
{
	主要技能 = Q
}

Loop,5
{
	if 藥劑持續時間%A_Index% = ERROR
	{
		藥劑持續時間%A_Index% = Off
	}
}
;------------------------------------------------------------------------------------------------------
if 技1 = ERROR
{
	技1 = Q
}
if 技2 = ERROR
{
	技2 = Off
}
if 技3 = ERROR
{
	技3 = Off
}
if 技1延遲 = ERROR
{
	技1延遲 = 100
}
if 技2延遲 = ERROR
{
	技2延遲 = 100
}
if 技能連段功能 = ERROR
{
	技能連段功能 = 關閉
}
;------------------------------------------------------------------------------------------------------
if 地雷模式 = ERROR
{
	地雷模式 = 關閉
}
if 地雷杖模式 = ERROR
{
	地雷杖模式 = 關閉
}
if 地雷按鍵 = ERROR
{
	地雷按鍵 = Q
}
if 煙霧地雷 = ERROR
{
	煙霧地雷 = W
}
if 引爆延遲1 = ERROR
{
	引爆延遲1 = 300
}
if 引爆延遲2 = ERROR
{
	引爆延遲2 = 300
}
;------------------------------------------------------------------------------------------------------

Menu, Tray, NoStandard
Menu, Tray, Tip, Sid 流亡超級工具箱
Menu, Tray, Add, 開啟設定面板, 呼叫菜單
Menu, Tray, Add
Menu, Tray, Add, 重新載入 (F11), Tray_Reload
Menu, Tray, Add, 結束工具 (F12), Tray_Exit
Menu, Tray, Default, 開啟設定面板
Menu, Tray, Click, 1

gosub,起始盒子
return

Tray_Reload:
	Reload
return

Tray_Exit:
ExitApp
return

;[菜單設置區]------------------------------------------------------------------------------------------------------

呼叫菜單:
	OpenUISection("intro")
return

OpenUISection(section) {
	try {
		neutron.wnd.syncDataFromAHK()
		neutron.wnd.showSection(section)
	}
	neutron.Show("w960 h680 Center")
}

;[熱鍵設置]------------------------------------------------------------------------------------------------------

#ifwinactive, ahk_group DualWins

	F9::
		Suspend
		ToolTip("工具暫停中，回復原始鍵盤功能，[F9]恢復運作 ")
		Pause,,1
	return

	F11::
		reload
	return

	F12::
		try {
			neutron.wnd.showExitModal()
		}
		neutron.Show("w960 h680 Center")
		SetTimer, 延遲結束工具, -3000
	return

	延遲結束工具:
	ExitApp
	return

	~*esc::
		if (autoCraftActive)
		{
			autoCraftStopRequested := true
			ToolTip("🛑 偵測到 Esc，正在停止自動洗詞...")
		}
		if (捕捉模式 = 1)
		{
			捕捉模式:= 0
			SetTimer, UpdateCaptureOverlay, Off
			HideCaptureOverlay()
		}
		openI:= 0
		Toolbutton:= 0
		if (!autoCraftActive && WinActive("ahk_group PoEGames"))
			ToolTip("(ESC)，關閉面板，返回遊戲模式")
	return

	HK_OpenUI_Label:
		gosub,呼叫菜單
	return

#ifwinactive, ahk_group PoEGames

	;[提示窗口基礎設定]------------------------------------------------------------------------------------------------------

	ToolTip(label)
	{
		ToolTip, %label%, 0, 40
		SetTimer, RemoveToolTip, 3000
		if WinActive("ahk_group DualWins")
			WinActivate
		return

		RemoveToolTip:
		SetTimer, RemoveToolTip, Off
		ToolTip
		Return
	}

	;[跳程指令區]---------------------------------------------------------------------------------------------------

	起始盒子:
		try {
			neutron.wnd.syncDataFromAHK()
			neutron.wnd.showStartupModal()
		}
		neutron.Show("w960 h680 Center")
		SetTimer, 自動關閉起始視窗, -3000
	return

	自動關閉起始視窗:
		try {
			neutron.wnd.hideStartupModal()
		}
		neutron.Hide()
	return

	;---------------------------------------------------------

	彈跳網頁:
		run,https://sid-1996.github.io/sid-automation-lab/index.html,,UseErrorLevel
	return

	暫停讀秒循環喝水_Label:
		SetTimer, 藥劑1, off
		SetTimer, 藥劑2, off
		SetTimer, 藥劑3, off
		SetTimer, 藥劑4, off
		SetTimer, 藥劑5, off
	return

	儲存藥劑觸發紀錄:
		IniWrite,% 主要技能, sidtooldata.ini, 藥劑觸發數據, 主要技能
		IniWrite,% 藥劑觸發模式, sidtooldata.ini, 藥劑觸發數據, 藥劑觸發模式
		IniWrite,% 藥劑持續時間1, sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間1
		IniWrite,% 藥劑持續時間2, sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間2
		IniWrite,% 藥劑持續時間3, sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間3
		IniWrite,% 藥劑持續時間4, sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間4
		IniWrite,% 藥劑持續時間5, sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間5
		IniWrite,% 使用技能時觸發的藥劑, sidtooldata.ini, 藥劑觸發數據, 使用技能時觸發的藥劑
		IniWrite,% 一鍵喝水時觸發的藥劑, sidtooldata.ini, 藥劑觸發數據, 一鍵喝水時觸發的藥劑
	Return

	讀取藥劑觸發紀錄:
		Iniread,	 主要技能,	sidtooldata.ini, 藥劑觸發數據, 主要技能
		Iniread,	 藥劑觸發模式,	sidtooldata.ini, 藥劑觸發數據, 藥劑觸發模式
		Iniread,	 藥劑持續時間1,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間1
		Iniread,	 藥劑持續時間2,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間2
		Iniread,	 藥劑持續時間3,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間3
		Iniread,	 藥劑持續時間4,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間4
		Iniread,	 藥劑持續時間5,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間5
		Iniread,	 使用技能時觸發的藥劑,	sidtooldata.ini, 藥劑觸發數據, 使用技能時觸發的藥劑
		Iniread,	 一鍵喝水時觸發的藥劑,	sidtooldata.ini, 藥劑觸發數據, 一鍵喝水時觸發的藥劑
	Return

	Return

	座標顏色讀取:
		DialogValidOffsets := {1: "", 2: ""}
		loop,9
		{
			IniRead,顏色%A_Index%_X,sidtooldata.ini,顏色座標,顏色%A_Index%_X
			IniRead,顏色%A_Index%_Y,sidtooldata.ini,顏色座標,顏色%A_Index%_Y
			IniRead,顏色%A_Index%_C,sidtooldata.ini,顏色座標,顏色%A_Index%_C
		}
	return

	;[藥劑防呆區]------------------------------------------------------------------------------------------

	IsGameInputAllowed()
	{
		global Toolbutton
		return (Toolbutton = 0 && WinActive("ahk_group PoEGames"))
	}

	UseFlaskSlot(slotIdx)
	{
		global 藥劑持續時間1, 藥劑持續時間2, 藥劑持續時間3, 藥劑持續時間4, 藥劑持續時間5
		global 防呆藥水鎖1, 防呆藥水鎖2, 防呆藥水鎖3, 防呆藥水鎖4, 防呆藥水鎖5
		if (!IsGameInputAllowed())
			return
		dur := 藥劑持續時間%slotIdx%
		if (dur = "off")
		{
			Send, {%slotIdx%}
		}
		else if (防呆藥水鎖%slotIdx% = "無")
		{
			Send, {%slotIdx%}
			防呆藥水鎖%slotIdx% := "有"
			SetTimer, 防呆藥水%slotIdx%計時器, %dur%
		}
	}

	使用藥劑1:
		UseFlaskSlot(1)
	return

	使用藥劑2:
		UseFlaskSlot(2)
	return

	使用藥劑3:
		UseFlaskSlot(3)
	return

	使用藥劑4:
		UseFlaskSlot(4)
	return

	使用藥劑5:
		UseFlaskSlot(5)
	return

	防呆藥水1計時器:
		if 防呆藥水鎖1 = 無
			settimer,防呆藥水1計時器,off
		if 防呆藥水鎖1 = 有
			防呆藥水鎖1 = 無
	return

	防呆藥水2計時器:
		if 防呆藥水鎖2 = 無
			settimer,防呆藥水2計時器,off
		if 防呆藥水鎖2 = 有
			防呆藥水鎖2 = 無
	return

	防呆藥水3計時器:
		if 防呆藥水鎖3 = 無
			settimer,防呆藥水3計時器,off
		if 防呆藥水鎖3 = 有
			防呆藥水鎖3 = 無
	return

	防呆藥水4計時器:
		if 防呆藥水鎖4 = 無
			settimer,防呆藥水4計時器,off
		if 防呆藥水鎖4 = 有
			防呆藥水鎖4 = 無
	return

	防呆藥水5計時器:
		if 防呆藥水鎖5 = 無
			settimer,防呆藥水5計時器,off
		if 防呆藥水鎖5 = 有
			防呆藥水鎖5 = 無
	return

	;[1|2|3|4|5藥劑按鍵區]---------------------------------------------------------------

	~*1::
		settimer,防呆藥水1計時器,off
		防呆藥水鎖1 = 無
	return

	~*2::
		settimer,防呆藥水2計時器,off
		防呆藥水鎖2 = 無
	return

	~*3::
		settimer,防呆藥水3計時器,off
		防呆藥水鎖3 = 無
	return

	~*4::
		settimer,防呆藥水4計時器,off
		防呆藥水鎖4 = 無
	return

	~*5::
		settimer,防呆藥水5計時器,off
		防呆藥水鎖5 = 無
	return

	;[Q|W|E|R|T技能按鍵區]---------------------------------------------------------------

	HandleSkillKey(keyName)
	{
		global 藥劑觸發模式, 主要技能, 使用技能時觸發的藥劑
		global 技能連段功能, 技1
		global 地雷模式, 地雷按鍵, 引爆延遲1, 地雷杖模式, 煙霧地雷, 引爆延遲2
		if (!IsGameInputAllowed())
			return
		if (藥劑觸發模式 = "使用技能時喝水" && 主要技能 = keyName)
		{
			Loop, 5
			{
				if (!IsGameInputAllowed())
					return
				if InStr(使用技能時觸發的藥劑, A_Index)
					UseFlaskSlot(A_Index)
			}
		}
		if (技能連段功能 = "開啟" && 技1 = keyName)
			gosub, 技能連段
		if (地雷模式 = "開啟")
		{
			if (地雷按鍵 = keyName)
			{
				Sleep, %引爆延遲1%
				if (!IsGameInputAllowed())
					return
				Send, {d}
				if (地雷杖模式 = "開啟")
					Send, {d down}
			}
			if (煙霧地雷 = keyName)
			{
				if (!IsGameInputAllowed())
					return
				Send, {d up}
				Sleep, %引爆延遲2%
				if (!IsGameInputAllowed())
					return
				Send, {d}
			}
		}
	}

	~*Q::
		HandleSkillKey("Q")
	return

	~*W::
		HandleSkillKey("W")
	return

	~*E::
		HandleSkillKey("E")
	return

	~*R::
		HandleSkillKey("R")
	return

	~*T::
		HandleSkillKey("T")
	return

	;[技能連段指令]-------------------------------------------------------------------------------------------------

	技能連段:
		if (isComboRunning || !IsGameInputAllowed())
			return
		isComboRunning := true

		k1 := Format("{:U}", Trim(技1))
		k2 := Format("{:U}", Trim(技2))
		k3 := Format("{:U}", Trim(技3))
		d1 := (技1延遲 > 0) ? 技1延遲 : 100
		d2 := (技2延遲 > 0) ? 技2延遲 : 100

		if k1 in Q,W,E,R,T
		{
			if k2 in Q,W,E,R,T
			{
				sleep %d1%
				if (!IsGameInputAllowed())
				{
					isComboRunning := false
					return
				}
				Send {%k2%}
			}
			if k3 in Q,W,E,R,T
			{
				sleep %d2%
				if (!IsGameInputAllowed())
				{
					isComboRunning := false
					return
				}
				Send {%k3%}
			}
			sleep 50
		}

		isComboRunning := false
	return

	儲存並讀取技能連段數據:
		IniWrite, % 技1, sidtooldata.ini, 連段設置, 技1
		IniWrite, % 技2, sidtooldata.ini, 連段設置, 技2
		IniWrite, % 技3, sidtooldata.ini, 連段設置, 技3
		IniWrite, % 技1延遲, sidtooldata.ini, 連段設置, 技1延遲
		IniWrite, % 技2延遲, sidtooldata.ini, 連段設置, 技2延遲
		IniWrite, % 技能連段功能, sidtooldata.ini, 連段設置, 技能連段功能
		gosub, 讀取技能連段數據
	Return

	讀取技能連段數據:
		IniRead, 技1		, sidtooldata.ini, 連段設置, 技1
		IniRead, 技2		, sidtooldata.ini, 連段設置, 技2
		IniRead, 技3		, sidtooldata.ini, 連段設置, 技3
		IniRead, 技1延遲	, sidtooldata.ini, 連段設置, 技1延遲
		IniRead, 技2延遲	, sidtooldata.ini, 連段設置, 技2延遲
		IniRead, 技能連段功能	, sidtooldata.ini, 連段設置, 技能連段功能
	Return

	儲存並讀取地雷設置:
		IniWrite, % 地雷模式, sidtooldata.ini, 地雷設置, 地雷模式
		IniWrite, % 地雷杖模式, sidtooldata.ini, 地雷設置, 地雷杖模式
		IniWrite, % 地雷按鍵, sidtooldata.ini, 地雷設置, 地雷按鍵
		IniWrite, % 引爆延遲1, sidtooldata.ini, 地雷設置, 引爆延遲1
		IniWrite, % 煙霧地雷, sidtooldata.ini, 地雷設置, 煙霧地雷
		IniWrite, % 引爆延遲2, sidtooldata.ini, 地雷設置, 引爆延遲2
		gosub, 讀取地雷設置
	Return

	讀取地雷設置:
		IniRead, 地雷模式,	sidtooldata.ini, 地雷設置, 地雷模式
		IniRead,地雷杖模式,	sidtooldata.ini, 地雷設置, 地雷杖模式
		IniRead, 地雷按鍵,	sidtooldata.ini, 地雷設置, 地雷按鍵
		IniRead, 引爆延遲1,	sidtooldata.ini, 地雷設置, 引爆延遲1
		IniRead, 煙霧地雷,	sidtooldata.ini, 地雷設置, 煙霧地雷
		IniRead, 引爆延遲2,	sidtooldata.ini, 地雷設置, 引爆延遲2
	Return

	;[快搜倉庫頁區(熱鍵)]---------------------------------------------------------------------------------

	^LWin::
		Gosub,返回首頁
	return

	返回首頁:
		clipboard =
		Send {left %返回頁數%}
		當前倉庫頁 = 0
	return

	~^alt::
		gosub,快搜倉庫頁
	return

	快搜倉庫頁:
		clipboard =
		倉庫匹配狀態 = 倉庫匹配中
		Send, ^c
		ClipWait, 0.2
		if ErrorLevel = 1
			return

		暫存複製內容 = %Clipboard%

		if 倉庫匹配狀態 = 倉庫匹配中
			IfInString,暫存複製內容,物品種類: 可堆疊通貨	,gosub,前往可堆疊通貨
				if 倉庫匹配狀態 = 倉庫匹配中
					if 暫存複製內容 contains 培育器,孵育器
						gosub,前往培育器
		if 倉庫匹配狀態 = 倉庫匹配中
			IfInString,暫存複製內容,物品種類: 劫盜	,gosub,前往劫盜裝
				if 倉庫匹配狀態 = 倉庫匹配中
					if 暫存複製內容 contains 釋界之邀,阿茲瓦特史記,區域被異界尊師控制
						gosub,前往特殊地圖
		if 倉庫匹配狀態 = 倉庫匹配中
			IfInString,暫存複製內容,物品種類: 珠寶	,gosub,二次判定珠寶
				if 倉庫匹配狀態 = 倉庫匹配中
					IfInString,暫存複製內容,物品種類: 深淵珠寶,gosub,前往深淵珠
						if 倉庫匹配狀態 = 倉庫匹配中
							IfInString,暫存複製內容,裂痕戒指	,gosub,前往裂痕戒指
								if 倉庫匹配狀態 = 倉庫匹配中
									IfInString,暫存複製內容,(enchant)	,gosub,二次判定附魔裝
										if 倉庫匹配狀態 = 倉庫匹配中
											if 暫存複製內容 contains 塑者之物,尊師之物,總督軍物品,救贖者物品,狩獵者物品,聖戰軍王物品
												gosub,二次判斷勢力裝
		if 倉庫匹配狀態 = 倉庫匹配中
			IfInString,暫存複製內容,未鑑定		,gosub,二次判定未鑑定物品
				if 倉庫匹配狀態 = 倉庫匹配中
					if 暫存複製內容 contains 戒指,之戒
						gosub,二次判斷傳奇戒指
		if 倉庫匹配狀態 = 倉庫匹配中
			IfInString,暫存複製內容,稀有度: 傳奇	,gosub,前往傳奇裝
				return

	;[快搜倉庫頁區(指令)]-----------------------------------------------------------------------------------------------------------------------------

	倉庫頁計算:
		計算值:=  abs(當前倉庫頁 - 搜索到的倉庫頁)

		if (搜索到的倉庫頁 > 當前倉庫頁)
		{
			Send {right %計算值%}
			return
		}
		if (搜索到的倉庫頁 < 當前倉庫頁)
		{
			Send {left %計算值%}
			return
		}
	return

	二次判定未鑑定物品:
		IfInString,暫存複製內容,稀有度: 稀有	,gosub,三次判定未鑑定物品
			return

	二次判定珠寶:
		if 暫存複製內容 contains 稀有度: 普通,稀有度: 魔法,稀有度: 稀有
		{
			IfInString,暫存複製內容,星團珠寶	,gosub,前往星團珠
				if 暫存複製內容 contains 鈷藍珠寶,翠綠珠寶,赤紅珠寶
					gosub,前往普通珠
		}
	return

	二次判定附魔裝:
		if 暫存複製內容 contains 物品種類: 手套,物品種類: 頭部,物品種類: 鞋子
			gosub,前往附魔裝
	return

	三次判定未鑑定物品:
		IfInString,暫存複製內容,物品種類: 頭部	,gosub,前往未鑑定稀有頭盔
			IfInString,暫存複製內容,物品種類: 胸甲	,gosub,前往未鑑定稀有衣服
				IfInString,暫存複製內容,物品種類: 腰帶	,gosub,前往未鑑定稀有腰帶
					IfInString,暫存複製內容,物品種類: 手套	,gosub,前往未鑑定稀有手套
						IfInString,暫存複製內容,物品種類: 鞋子	,gosub,前往未鑑定稀有鞋子
							IfInString,暫存複製內容,物品種類: 戒指	,gosub,前往未鑑定稀有飾品
								IfInString,暫存複製內容,物品種類: 項鍊	,gosub,前往未鑑定稀有飾品
									if 暫存複製內容 contains 物品種類: 爪,物品種類: 匕首,物品種類: 法杖,物品種類: 單手劍,物品種類: 細劍,物品種類: 單手斧,物品種類: 單手錘,物品種類: 權杖,物品種類: 符紋匕首,物品種類: 弓,物品種類: 長杖,物品種類: 雙手劍,物品種類: 雙手斧,物品種類: 雙手錘,物品種類: 征戰長杖
										gosub,前往未鑑定稀有武器
	return

	前往未鑑定稀有頭盔:
		搜索到的倉庫頁:= 未鑑定稀有頭盔
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 未鑑定稀有頭盔
	return

	前往未鑑定稀有衣服:
		搜索到的倉庫頁:= 未鑑定稀有衣服
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 未鑑定稀有衣服
	return

	前往未鑑定稀有腰帶:
		搜索到的倉庫頁:= 未鑑定稀有腰帶
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 未鑑定稀有腰帶
	return

	前往未鑑定稀有手套:
		搜索到的倉庫頁:= 未鑑定稀有手套
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 未鑑定稀有手套
	return

	前往未鑑定稀有鞋子:
		搜索到的倉庫頁:= 未鑑定稀有鞋子
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 未鑑定稀有鞋子
	return

	前往未鑑定稀有飾品:
		搜索到的倉庫頁:= 未鑑定稀有飾品
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 未鑑定稀有飾品
	return

	前往未鑑定稀有武器:
		搜索到的倉庫頁:= 未鑑定稀有武器
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 未鑑定稀有武器
	return

	二次判斷傳奇戒指:
		IfInString,暫存複製內容,稀有度: 傳奇	,gosub,前往傳奇戒
			return

	二次判斷勢力裝:
		if 暫存複製內容 contains 稀有度: 稀有,稀有度: 普通,稀有度: 魔法
			gosub,前往勢力裝頁
	return

	前往星團珠:
		搜索到的倉庫頁:= 星團珠
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 星團珠
	return

	前往普通珠:
		搜索到的倉庫頁:= 普通珠
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 普通珠
	return

	前往深淵珠:
		搜索到的倉庫頁:= 深淵珠
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 深淵珠
	return

	前往培育器:
		搜索到的倉庫頁:= 培育器
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 培育器
	return

	前往勢力裝頁:
		搜索到的倉庫頁:= 勢力裝頁
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 勢力裝頁
	return

	前往傳奇裝:
		搜索到的倉庫頁:= 傳奇裝
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 傳奇裝
		快搜配對 = 需按Shift
	return

	前往附魔裝:
		搜索到的倉庫頁:= 附魔裝
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 附魔裝
		快搜配對 = 需按Shift
	return

	前往劫盜裝:
		搜索到的倉庫頁:= 劫盜裝
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 劫盜裝
	return

	前往傳奇戒:
		{
			搜索到的倉庫頁:= 傳奇戒
			gosub,倉庫頁計算
			倉庫匹配狀態 = 成功
			當前倉庫頁:= 傳奇戒
			快搜配對 = 需按Shift
			return
		}
	return

	前往特殊地圖:
		搜索到的倉庫頁:= 特殊地圖
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 特殊地圖
		快搜配對 = 需按Shift
	return

	前往裂痕戒指:
		搜索到的倉庫頁:= 裂痕戒指
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 裂痕戒指
	return

	前往可堆疊通貨:
		搜索到的倉庫頁:= 0
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁:= 0
	return

	;[快搜倉庫頁數據儲存指令]----------------------------------------------------------------------------------------------------------------

	儲存並讀取倉庫頁數據:
		iniWrite,% 附魔裝, sidtooldata.ini, 各倉庫頁數, 附魔裝
		iniWrite,% 傳奇裝, sidtooldata.ini, 各倉庫頁數, 傳奇裝
		iniWrite,% 傳奇戒, sidtooldata.ini, 各倉庫頁數, 傳奇戒
		iniWrite,% 劫盜裝, sidtooldata.ini, 各倉庫頁數, 劫盜裝
		iniWrite,% 移除2, sidtooldata.ini, 各倉庫頁數, 移除2
		iniWrite,% 培育器, sidtooldata.ini, 各倉庫頁數, 培育器
		iniWrite,% 深淵珠, sidtooldata.ini, 各倉庫頁數, 深淵珠
		iniWrite,% 星團珠, sidtooldata.ini, 各倉庫頁數, 星團珠
		iniWrite,% 普通珠, sidtooldata.ini, 各倉庫頁數, 普通珠
		iniWrite,% 勢力裝頁, sidtooldata.ini, 各倉庫頁數, 勢力裝頁
		iniWrite,% 特殊地圖, sidtooldata.ini, 各倉庫頁數, 特殊地圖
		iniWrite,% 裂痕戒指, sidtooldata.ini, 各倉庫頁數, 裂痕戒指
		iniWrite,% 返回頁數, sidtooldata.ini, 各倉庫頁數, 返回頁數
		iniWrite,% 未鑑定稀有頭盔, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有頭盔
		iniWrite,% 未鑑定稀有衣服, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有衣服
		iniWrite,% 未鑑定稀有腰帶, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有腰帶
		iniWrite,% 未鑑定稀有手套, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有手套
		iniWrite,% 未鑑定稀有鞋子, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有鞋子
		iniWrite,% 未鑑定稀有飾品, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有飾品
		iniWrite,% 未鑑定稀有武器, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有武器
		iniread, 附魔裝, sidtooldata.ini, 各倉庫頁數, 附魔裝
		iniread, 傳奇裝, sidtooldata.ini, 各倉庫頁數, 傳奇裝
		iniread, 傳奇戒, sidtooldata.ini, 各倉庫頁數, 傳奇戒
		iniread, 劫盜裝, sidtooldata.ini, 各倉庫頁數, 劫盜裝
		iniread, 移除2, sidtooldata.ini, 各倉庫頁數, 移除2
		iniread, 培育器, sidtooldata.ini, 各倉庫頁數, 培育器
		iniread, 深淵珠, sidtooldata.ini, 各倉庫頁數, 深淵珠
		iniread, 星團珠, sidtooldata.ini, 各倉庫頁數, 星團珠
		iniread, 普通珠, sidtooldata.ini, 各倉庫頁數, 普通珠
		iniread, 勢力裝頁, sidtooldata.ini, 各倉庫頁數, 勢力裝頁
		iniread, 特殊地圖, sidtooldata.ini, 各倉庫頁數, 特殊地圖
		iniread, 裂痕戒指, sidtooldata.ini, 各倉庫頁數, 裂痕戒指
		iniread, 返回頁數, sidtooldata.ini, 各倉庫頁數, 返回頁數
		iniread, 未鑑定稀有頭盔, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有頭盔
		iniread, 未鑑定稀有衣服, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有衣服
		iniread, 未鑑定稀有腰帶, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有腰帶
		iniread, 未鑑定稀有手套, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有手套
		iniread, 未鑑定稀有鞋子, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有鞋子
		iniread, 未鑑定稀有飾品, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有飾品
		iniread, 未鑑定稀有武器, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有武器
	Return

	讀取倉庫頁數據:
		iniread, 附魔裝, sidtooldata.ini, 各倉庫頁數, 附魔裝
		iniread, 傳奇裝, sidtooldata.ini, 各倉庫頁數, 傳奇裝
		iniread, 傳奇戒, sidtooldata.ini, 各倉庫頁數, 傳奇戒
		iniread, 劫盜裝, sidtooldata.ini, 各倉庫頁數, 劫盜裝
		iniread, 移除2, sidtooldata.ini, 各倉庫頁數, 移除2
		iniread, 培育器, sidtooldata.ini, 各倉庫頁數, 培育器
		iniread, 深淵珠, sidtooldata.ini, 各倉庫頁數, 深淵珠
		iniread, 星團珠, sidtooldata.ini, 各倉庫頁數, 星團珠
		iniread, 普通珠, sidtooldata.ini, 各倉庫頁數, 普通珠
		iniread, 勢力裝頁, sidtooldata.ini, 各倉庫頁數, 勢力裝頁
		iniread, 特殊地圖, sidtooldata.ini, 各倉庫頁數, 特殊地圖
		iniread, 裂痕戒指, sidtooldata.ini, 各倉庫頁數, 裂痕戒指
		iniread, 返回頁數, sidtooldata.ini, 各倉庫頁數, 返回頁數
		iniread, 未鑑定稀有頭盔, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有頭盔
		iniread, 未鑑定稀有衣服, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有衣服
		iniread, 未鑑定稀有腰帶, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有腰帶
		iniread, 未鑑定稀有手套, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有手套
		iniread, 未鑑定稀有鞋子, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有鞋子
		iniread, 未鑑定稀有飾品, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有飾品
		iniread, 未鑑定稀有武器, sidtooldata.ini, 各倉庫頁數, 未鑑定稀有武器
	Return

	;[查價工具視窗指令]------------------------------------------------------------------------------------------------------

	引導查價安裝網址:
		run,https://forum.gamer.com.tw/C.php?bsn=18966&snA=123938,,UseErrorLevel
	return

	;[Space空白一鍵喝水區(熱鍵)]------------------------------------------------------------------------------------------

	HK_Space_Label:
		if Toolbutton = 0
		{
			dialogState := IsPoEDialogActive(20)
			if (dialogState > 0)
			{
				Toolbutton := 1
				ToolTip("偵測到對話框(" . dialogState . ")，暫停 Space 喝水，切換為文字模式")
				return
			}
			ToolTip("觸發一鍵喝水，打字誤觸建議您使用[F9]暫停工具。 ")
			if 一鍵喝水時觸發的藥劑 = error
			{
				msgbox,16,錯誤,尚未設定(Space)一鍵喝水所需藥劑! (``) => 藥劑觸發設置。
				OpenUISection("flask")
				return
			}
			else if (藥劑觸發模式 = "無")
			{
				send %一鍵喝水時觸發的藥劑%
			}
			if (藥劑觸發模式 = "讀秒循環喝水")
			{
				if 一鍵喝水時觸發的藥劑 contains 1
				{
					send {1}
					SetTimer, 藥劑1, off
					SetTimer, 藥劑1, %藥劑持續時間1%
				}
				if 一鍵喝水時觸發的藥劑 contains 2
				{
					send {2}
					SetTimer, 藥劑2, off
					SetTimer, 藥劑2, %藥劑持續時間2%
				}
				if 一鍵喝水時觸發的藥劑 contains 3
				{
					send {3}
					SetTimer, 藥劑3, off
					SetTimer, 藥劑3, %藥劑持續時間3%
				}
				if 一鍵喝水時觸發的藥劑 contains 4
				{
					send {4}
					SetTimer, 藥劑4, off
					SetTimer, 藥劑4, %藥劑持續時間4%
				}
				if 一鍵喝水時觸發的藥劑 contains 5
				{
					send {5}
					SetTimer, 藥劑5, off
					SetTimer, 藥劑5, %藥劑持續時間5%
				}
				return
			}
			if (藥劑觸發模式 = "純藥劑防呆")
			{
				if 一鍵喝水時觸發的藥劑 contains 1
					gosub,使用藥劑1
				if 一鍵喝水時觸發的藥劑 contains 2
					gosub,使用藥劑2
				if 一鍵喝水時觸發的藥劑 contains 3
					gosub,使用藥劑3
				if 一鍵喝水時觸發的藥劑 contains 4
					gosub,使用藥劑4
				if 一鍵喝水時觸發的藥劑 contains 5
					gosub,使用藥劑5
			}
			if (藥劑觸發模式 = "使用技能時喝水")
			{
				防呆藥水鎖1 = 無
				防呆藥水鎖2 = 無
				防呆藥水鎖3 = 無
				防呆藥水鎖4 = 無
				防呆藥水鎖5 = 無
				if 一鍵喝水時觸發的藥劑 contains 1
					gosub,使用藥劑1
				if 一鍵喝水時觸發的藥劑 contains 2
					gosub,使用藥劑2
				if 一鍵喝水時觸發的藥劑 contains 3
					gosub,使用藥劑3
				if 一鍵喝水時觸發的藥劑 contains 4
					gosub,使用藥劑4
				if 一鍵喝水時觸發的藥劑 contains 5
					gosub,使用藥劑5
			}

		}
	return

	;[Space讀秒循環喝水計時器指令]-------------------------------------------------------------------------------------------------

	藥劑1:
		if (Toolbutton = 0 && WinActive("ahk_group PoEGames"))
			send {1}
	return

	藥劑2:
		if (Toolbutton = 0 && WinActive("ahk_group PoEGames"))
			send {2}
	return

	藥劑3:
		if (Toolbutton = 0 && WinActive("ahk_group PoEGames"))
			send {3}
	return

	藥劑4:
		if (Toolbutton = 0 && WinActive("ahk_group PoEGames"))
			send {4}
	return

	藥劑5:
		if (Toolbutton = 0 && WinActive("ahk_group PoEGames"))
			send {5}
	return

	;[Enter偵測對話框區(熱鍵)]------------------------------------------------------------------------------------------

	~enter::
		if (顏色5_X = "error" or 顏色5_Y = "error" or 顏色6_X = "error" or 顏色6_Y = "error" or 顏色5_X = "" or 顏色5_Y = "" or 顏色6_X = "" or 顏色6_Y = "")
		{
			if Enter除錯提醒次數 = 0
			{
				msgbox,16,錯誤,尚未設定偵測對話框(1)&(2)黑幕！非常重要，不然打字會誤觸喝水與技能熱鍵。`r若您第一次使用，請按下確認查看教學圖片。`r確定後，請點擊右下角系統匣圖示開啟設定面板，至「座標定位」點選「抓取」，依指示按 F7 設定對話框(1)與(2)！
				run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/editor/1847905122_2.png,,UseErrorLevel
				Enter除錯提醒次數:= 1
			}
			return
		}

		; 短暫延遲等待遊戲 UI 渲染完成 (約 90ms)
		Sleep, 90

		dialogState := IsPoEDialogActive(20)
		if (dialogState > 0)
		{
			; 首次以 Enter 開啟對話框時進行框內有效採樣點校準快取
			if (dialogState = 1 && !IsObject(DialogValidOffsets[1]))
				CalibrateDialogOffsets(1, 顏色5_X, 顏色5_Y, 顏色5_C, 20)
			else if (dialogState = 2 && !IsObject(DialogValidOffsets[2]))
				CalibrateDialogOffsets(2, 顏色6_X, 顏色6_Y, 顏色6_C, 20)

			Toolbutton := 1
			ToolTip("偵測到對話框(" . dialogState . ")，已切換為文字模式")
			gosub,暫停讀秒循環喝水_Label
		}
		else
		{
			Toolbutton := 0
			ToolTip("對話框已關閉，已切換為遊戲模式")
		}
	return

	;[Ctrl + F 強調物品區(熱鍵)]--------------------------------------------------------------------------------------------

	~*<^F::
		if Toolbutton = 0
		{
			Toolbutton:= 1,ToolTip("偵測到使用Ctrl + F ,已切換為文字模式")
			gosub,暫停讀秒循環喝水_Label
		}
	return

	;[滑鼠區(熱鍵)]---------------------------------------------------------------------------------------------------------

	~*LButton::
		If 開始時間
			return
		開始時間:= A_TickCount
		Hotkey, LButton up, 左鍵彈起標籤, On
	return

	左鍵彈起標籤:
		Hotkey, LButton up, 左鍵彈起標籤, Off
		時間長度:= A_TickCount - 開始時間
		if (時間長度 >= 100)
		{
			if Toolbutton = 1
				Toolbutton:= 0,ToolTip("偵測左鍵有長時間的按壓彈起,因此切換為遊戲模式")
		}
		開始時間:= ""
	return

	~<!<^LButton::
		if Toolbutton = 0
		{
			Toolbutton:= 1,ToolTip("偵測到物品貼上,已切換為文字模式")
			gosub,暫停讀秒循環喝水_Label
		}
	return

	;[滑鼠連點區(熱鍵)]------------------------------------------------------------------------------------------------------

	~*^LButton::
		if (連點模式 = "[Ctrl + 左鍵]" || 連點模式 = "[Ctrl / Shift + 左鍵]")
			RunAutoClickLoop()
	return

	~*+LButton::
		if (連點模式 = "[Shift + 左鍵]" || 連點模式 = "[Ctrl / Shift + 左鍵]")
			RunAutoClickLoop()
	return

	~*^LButton Up::
	~*+LButton Up::
		clickStop := true
	return

	~*MButton::
		if (連點模式 = "滑鼠滾輪按壓")
		{
			Loop
			{
				if (!WinActive("ahk_group PoEGames") || !(GetKeyState("MButton") || GetKeyState("MButton", "P")))
					break
				Click
				Sleep, % 滑鼠連點速度
			}
		}
	return

	;[滑鼠連點設置數據讀取]------------------------------------------------------------------------------------------------------

	讀取滑鼠連點速度:
		Iniread, 滑鼠連點速度, sidtooldata.ini, 按鍵模式切換, 滑鼠連點速度
		if 滑鼠連點速度 = error
			滑鼠連點速度 = 25
	Return

	讀取連點模式:
		Iniread, 連點模式, sidtooldata.ini, 按鍵模式切換, 連點模式
	Return

	;[Ins循環技能區(熱鍵)]------------------------------------------------------------------------------------------

	HK_Insert_Label:
	if (Toolbutton = 1)
	{
		ToolTip("您現在是文字模式，已忽略循環技能切換")
		return
	}
(StopUser = 0 ? (StopUser:= 1,ToolTip("循環技能已開啟")) : (StopUser:= 0,ToolTip("循環技能已關閉")))
if (循環技能1 = "error" or 循環技能2 = "error" or 循環技能3 = "error" or 循環技能時間1 = "error" or 循環技能時間2 = "error" or 循環技能時間3 = "error")
{
  StopUser = 0
  msgbox,16,錯誤,尚未設定循環技能設置! 即將前往設置!
  OpenUISection("loop")
  return
}
  if StopUser = 1
  {
  Settimer,循環技能1,off
  Settimer,循環技能2,off
  Settimer,循環技能3,off
  Gosub,循環技能1
  Gosub,循環技能2
  Gosub,循環技能3
  Settimer,循環技能1,%循環技能時間1%,-1
  Settimer,循環技能2,%循環技能時間2%,-1
  Settimer,循環技能3,%循環技能時間3%,-1
  return
  }
  if StopUser = 0
  {
  Gosub,關閉循環技能_Label
  return
  }
return

循環技能1:
if (IsGameInputAllowed())
{
if (循環技能時間1 = "OFF" || 循環技能時間1 = "Off")
{
 Return
}
if (!GetKeyState("Ctrl","P") && !GetKeyState("Shift","P"))
{
send %循環技能1%
send {BS}
}
}
Return

循環技能2:
if (IsGameInputAllowed())
{
if (循環技能時間2 = "OFF" || 循環技能時間2 = "Off")
{
 Return
}
if (!GetKeyState("Ctrl","P") && !GetKeyState("Shift","P"))
{
send %循環技能2%
send {BS}
}
}
Return

循環技能3:
if (IsGameInputAllowed())
{
if (循環技能時間3 = "OFF" || 循環技能時間3 = "Off")
{
 Return
}
if (!GetKeyState("Ctrl","P") && !GetKeyState("Shift","P"))
{
send %循環技能3%
send {BS}
}
}
Return

關閉循環技能_Label:
Settimer,循環技能1,off
Settimer,循環技能2,off
Settimer,循環技能3,off
send {%循環技能1% up}
send {%循環技能2% up}
send {%循環技能3% up}
Return

	;[Ins循環技能數據儲存與讀取]------------------------------------------------------------------------------------------

	儲存循環技能設置:
iniWrite,% 循環技能1,	sidtooldata.ini, 循環技能, 循環技能1
iniWrite,% 循環技能2,	sidtooldata.ini, 循環技能, 循環技能2
iniWrite,% 循環技能3,	sidtooldata.ini, 循環技能, 循環技能3
iniWrite,% 循環技能時間1, sidtooldata.ini, 循環技能, 循環技能時間1
iniWrite,% 循環技能時間2, sidtooldata.ini, 循環技能, 循環技能時間2
iniWrite,% 循環技能時間3, sidtooldata.ini, 循環技能, 循環技能時間3
Return

讀取循環技能設置:
iniread,循環技能1 , sidtooldata.ini, 循環技能, 循環技能1
iniread,循環技能2 , sidtooldata.ini, 循環技能, 循環技能2
iniread,循環技能3 , sidtooldata.ini, 循環技能, 循環技能3
iniread,循環技能時間1 , sidtooldata.ini, 循環技能, 循環技能時間1
iniread,循環技能時間2 , sidtooldata.ini, 循環技能, 循環技能時間2
iniread,循環技能時間3 , sidtooldata.ini, 循環技能, 循環技能時間3
Return

;[End快速組隊(熱鍵)]------------------------------------------------------------------------------------------------------------

HK_End_Label:
if (快速組隊提醒 = "關閉")
{
	Gosub,獲取對方id
	WinActivate, ahk_group PoEGames
	WinWaitActive, ahk_group PoEGames, , 1
	Clipboard = /invite %移除後完好的ID%
	send {enter}
	Send ^{V}
	sleep 1
	Send {enter}
}
if 快速組隊提醒 = 開啟
{
   Gosub,獲取對方id
   msgbox,4,提醒,即將組隊的玩家是" %移除後完好的ID% " 確定嗎?`r按鍵[ Enter ] 立即組隊，按鍵[ N ]取消。`r不需提醒可使用[Win + End]關閉。
   IfMsgBox Yes
	{
	WinActivate, ahk_group PoEGames
	WinWaitActive, ahk_group PoEGames, , 1
	Clipboard = /invite %移除後完好的ID%
	send {enter}
	Send ^{V}
	sleep 1
	Send {enter}
	}
   else
	{
	WinActivate, ahk_group PoEGames
	WinWaitActive, ahk_group PoEGames, , 1
	}
}
Return

獲取對方id:
Send ^{enter}
sleep 1
Send ^{A}
sleep 1
Send ^{C}
sleep 1
Send {enter}
暫存對方ID = %Clipboard%
對方ID = %暫存對方ID%
gosub,清除目標ID前面@
return

清除目標ID前面@:
移除後完好的ID:= Trim(對方ID, OmitChars:= "@")
return

HK_WinEnd_ModeLabel:
	if (快速組隊提醒 = "開啟")
		快速組隊提醒:= "關閉"
	else
		快速組隊提醒:= "開啟"
	IniWrite, % 快速組隊提醒, sidtooldata.ini, 按鍵模式切換, 快速組隊提醒
	ToolTip("快速組隊提醒功能已變更為: " . 快速組隊提醒)
Return

讀取快速組隊提醒功能_Label:
 Iniread, 快速組隊提醒, sidtooldata.ini, 按鍵模式切換, 快速組隊提醒
Return

;[F1返回角色(熱鍵)]------------------------------------------------------------------------------------------------------------

HK_F1_Label:
if Toolbutton = 1
{
ToolTip("您現在是文字模式，請嘗試點擊一小段路 或 Enter")
}
else
{
	if F1模式 = error
	{
	msgbox,48,提醒,第一次使用F1的小朋友你好呀!試試 Win + F1 進行第一次的選擇吧!`r熱鍵隨時切換復原，愛上你的Windows鍵吧!!!!
	return
	}
	if F1模式 = 返角模式
	gosub,返角
	if F1模式 = 原始鍵盤模式
	{
	cleanF1Key:= CleanKeyName(快捷鍵_F1)
	send {%cleanF1Key%}
	}
}
return

HK_WinF1_ModeLabel:
	if (F1模式 = "返角模式")
		F1模式:= "原始鍵盤模式"
	else
		F1模式:= "返角模式"
	IniWrite, % F1模式, sidtooldata.ini, 按鍵模式切換, F1模式
	ToolTip("F1按鍵已變更為: " . F1模式)
return

;[F1返回角色(指令)]------------------------------------------------------------------------------------------------------

返角:
Critical
	gosub,暫停讀秒循環喝水_Label
	BlockInput On
        Send {Enter}
        Sleep 100
        Send {NumpadDiv}
        Send {Shift down}
	Send exit
        Send {Shift up}
        Send {Enter}
	BlockInput Off
	ToolTip("3秒後自動Enter登入")
	Sleep 1000
	ToolTip("2秒後自動Enter登入")
	Sleep 1000
	ToolTip("1秒後自動Enter登入")
	Sleep 1000
	ToolTip("0秒後自動Enter登入")
	if WinActive("ahk_group PoEGames")
		Send {Enter}
return

讀取F1按鍵模式:
 Iniread, F1模式, sidtooldata.ini, 按鍵模式切換, F1模式
Return

;[F2回復模式(熱鍵)]------------------------------------------------------------------------------------------------------

HK_F2_Label:
if Toolbutton = 1
{
ToolTip("您現在是文字模式，請嘗試點擊一小段路 或 Enter")
}
else
{
	if 回復模式 = error
	{
	msgbox,48,提醒,第一次使用F2的洨朋友你好呀!試試 Win + F2 進行選擇吧!`r熱鍵隨時切換，愛上我超讚的設計吧!!!!
	return
	}
	if 回復模式 = 暫離
	{
	  if StopUser = 0
	  {
	  Gosub,暫離
	  }
	  if StopUser = 1
	  {
	  StopUser = 0
	  Gosub,關閉循環技能_Label
	  ToolTip("已關閉[Ins]技能循環，進入暫離狀態。 ")
	  Gosub,暫離
	  }
	}
	if 回復模式 = 勿擾
	Gosub,勿擾
	if 回復模式 = 自動回復
	{
		if 自動回復內容 = error
		{
		gosub,設定自動回復
		return
		}
		else
		{
		Gosub,自動回復
		}
	}
	return

}
return

暫離:
BlockInput On
send {enter}
sleep 25
Clipboard = /afk
Send ^{V}
sleep 25
send {enter}
BlockInput Off
return

勿擾:
BlockInput On
send {enter}
sleep 25
Clipboard = /dnd
Send ^{V}
sleep 25
send {enter}
BlockInput Off
Return

自動回復:
BlockInput On
send {enter}
sleep 25
Clipboard = /autoreply %自動回復內容%
Send ^{V}
sleep 25
send {enter}
BlockInput Off
Return

HK_WinF2_ModeLabel:
	if (回復模式 = "暫離")
		回復模式:= "勿擾"
	else if (回復模式 = "勿擾")
		回復模式:= "自動回復"
	else
		回復模式:= "暫離"
	IniWrite, % 回復模式, sidtooldata.ini, 按鍵模式切換, 回復模式
	ToolTip("F2回復模式已切換為: " . 回復模式)
return

讀取回復模式:
 Iniread, 回復模式, sidtooldata.ini, 按鍵模式切換, 回復模式
Return

設定自動回復:
	InputBox, 輸入內容, 設定自動回復內容, 請輸入自動回復文字內容：,,,,,,,, %自動回復內容%
	if (!ErrorLevel && 輸入內容 != "")
	{
		自動回復內容:= 輸入內容
		iniWrite,% 自動回復內容, sidtooldata.ini, 設定自動回復內容, 自動回復內容
		ToolTip("自動回復內容已更新！ ")
	}
Return

讀取自動回復內容:
iniread, 自動回復內容, sidtooldata.ini, 設定自動回復內容, 自動回復內容
Return

;[F3清空背包區(熱鍵)]------------------------------------------------------------------------------------------------------------

HK_F3_Label:
if Toolbutton = 1
{
ToolTip("您現在是文字模式，請嘗試點擊一小段路 或 Enter")
}
else
{
Critical
	if (背包左上_X = "error" or 背包右下_X = "error" or 背包左上_X = "ERROR" or 背包右下_X = "ERROR" or 背包左上_X = "" or 背包右下_X = "" or 背包左上_X = "未設定" or 背包右下_X = "未設定" or !RegExMatch(背包左上_X, "^\d+$") or !RegExMatch(背包右下_X, "^\d+$"))
	{
		msgbox,16,錯誤,尚未設定 [背包左上角第一格中心點] 與 [背包右下角最末格中心點]，請點擊右下角系統匣圖示開啟設定選單進行定位點抓取。
		return
	}
	if (清包模式 != "變更顏色定位" && (補充傳送卷軸 = 1 || 補充傳送卷軸 = "1" || 補充傳送卷軸 = "true"))
	{
		if (!RefillPortalScroll())
			return
	}
	if (InStr(清包模式, "按壓"))
	{
	gosub,一鍵清包
	}
	if (InStr(清包模式, "自動"))
	{
	gosub,一鍵清包
	}
	if (InStr(清包模式, "掃描") && !InStr(清包模式, "快搜") && !InStr(清包模式, "翻頁"))
	{
		if (背包初始顏色1 = "error" and 背包初始顏色2 = "error")
		{
		msgbox,16,提醒,請先更改為背包顏色定位模式，並打開背包保持60格無任何物品，按下[F3]定位背包顏色。
		}
		else
		{
		gosub,快速掃描並存倉
		}
	}
	if (InStr(清包模式, "快搜") || 清包模式 = "掃描快搜翻頁")
	{
		if (背包初始顏色1 = "error" and 背包初始顏色2 = "error")
		{
		msgbox,16,提醒,請先更改為背包顏色定位模式，並打開背包保持60格無任何物品，按下[F3]定位背包顏色。
		return
		}
		if (傳奇裝 = "error" or 傳奇戒 = "error" or 勢力裝頁 = "error")
		{
		msgbox,16,提醒,工具讀取到您的"快搜倉庫頁設置"並不完全，請前往設置。
		return
		}
		else
		{
		gosub,快速掃描並存倉
		}
	}
	if 清包模式 = 變更顏色定位
	{
	gosub,快速掃描背包顏色並儲存
	return
	}
return
}
return

HK_WinF3_ModeLabel:
	if (清包模式 = "按壓式")
		清包模式:= "自動式"
	else if (清包模式 = "自動式")
		清包模式:= "掃描式"
	else if (清包模式 = "掃描式")
		清包模式:= "掃描快搜"
	else
		清包模式:= "按壓式"
	IniWrite, % 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
	ToolTip("F3清包模式已變更為: " . 清包模式)
	try {
		neutron.wnd.syncDataFromAHK()
	}
return

讀取F3按鍵模式:
 Iniread, 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
Return

讀取清包保留格:
	IniRead, 清包保留格, sidtooldata.ini, 清包設置, 清包保留格, %A_Space%
	if (清包保留格 = "ERROR")
		清包保留格:= ""
	清包保留格:= Trim(清包保留格)
	global 清包保留Array:= {}
	Loop, 60
		清包保留Array[A_Index] := 0
	if (清包保留格 != "")
	{
		Loop, Parse, 清包保留格, `,
		{
			idx:= Trim(A_LoopField)
			if (idx >= 1 && idx <= 60)
				清包保留Array[idx] := 1
		}
	}
return

儲存清包保留格:
	IniWrite, % 清包保留格, sidtooldata.ini, 清包設置, 清包保留格
return

讀取補充傳送卷軸設置:
	IniRead, 補充傳送卷軸, sidtooldata.ini, 清包設置, 補充傳送卷軸, 0
	IniRead, 傳送卷軸_X, sidtooldata.ini, 清包設置, 傳送卷軸_X, 0
	IniRead, 傳送卷軸_Y, sidtooldata.ini, 清包設置, 傳送卷軸_Y, 0
return

RefillPortalScroll()
{
	global 傳送卷軸_X, 傳送卷軸_Y
	if (傳送卷軸_X <= 0 || 傳送卷軸_Y <= 0)
	{
		ToolTip("⚠️ 已啟用補充傳送卷軸，請先於「清包設置」抓取傳送卷軸座標！")
		return false
	}
	MouseMove, %傳送卷軸_X%, %傳送卷軸_Y%, 0
	Sleep, 40
	Send, {Ctrl down}
	Sleep, 30
	Click
	Sleep, 60
	Send, {Ctrl up}
	Sleep, 50
	return true
}

;[F3快速掃描背包區].............................................................................................................................

讀取背包初始顏色:
	IniRead, colorSection, sidtooldata.ini, 快速掃描顏色
	if (colorSection != "" && colorSection != "ERROR")
	{
		Loop, Parse, colorSection, `n, `r
		{
			if (RegExMatch(A_LoopField, "^背包初始顏色(\d+)=(.*)$", m))
				背包初始顏色%m1% := m2
		}
	}
return

快速掃描背包顏色並儲存:
	迴圈狀態:= 0
	掃描顏色Array:= []
	ToolTip, 開始掃描背包顏色..., 0, 0, 1
	loop % 掃描水平數量
	{
		colIdx:= A_Index
		PosX:= Round(掃描開始左上_X + (colIdx - 1) * 背包步長_X)
		loop % 掃描垂直數量
		{
			rowIdx:= A_Index
			PosY:= Round(掃描開始左上_Y + (rowIdx - 1) * 背包步長_Y)
			PixelGetColor, pcol, % PosX, % PosY, Fast RGB
			掃描顏色Array.Push(pcol)
			迴圈狀態:= 迴圈狀態 + 1
			背包初始顏色%迴圈狀態% := pcol
		}
		ToolTip, % "掃描進度: " . 迴圈狀態 . " / 60", 0, 22, 2
	}
	ToolTip,,,,2
	ToolTip,,,,1
	; 掃描完成後批次寫入 INI
	for idx, val in 掃描顏色Array
		iniWrite, % val, sidtooldata.ini, 快速掃描顏色, 背包初始顏色%idx%
	msgbox % "掃瞄並儲存完畢，請繼續[Win + F3]切換為掃描式。"
return

一鍵清包:
cleanF3Key:= CleanKeyName(快捷鍵_F3)
send {ctrl down}
loop % 掃描水平數量
{
colIdx:= A_Index
PosX:= Round(掃描開始左上_X + (colIdx - 1) * 背包步長_X)
	if (InStr(清包模式, "按壓"))
	{
		if not(GetKeyState(cleanF3Key,"P"))
		{
		send {ctrl up}
		send {%cleanF3Key% up}
		ToolTip,,,,3
		return
		}
	}
	if (InStr(清包模式, "自動"))
	{
		if (GetKeyState("~","P"))
		{
		send {%cleanF3Key% up}
		send {ctrl up}
		ToolTip,,,,3
		return
		}
	}
loop % 掃描垂直數量
{
rowIdx:= A_Index
slotIdx:= (colIdx - 1) * 掃描垂直數量 + rowIdx
if (清包保留Array[slotIdx])
	continue
PosY:= Round(掃描開始左上_Y + (rowIdx - 1) * 背包步長_Y)
MouseClick,, % PosX, % PosY,1,0
	if (InStr(清包模式, "按壓"))
	{
		ToolTip, % "鬆開[" . cleanF3Key . "]停止。", 0,22,3
		if not(GetKeyState(cleanF3Key,"P"))
		{
		send {ctrl up}
		send {%cleanF3Key% up}
		ToolTip,,,,3
		return
		}
	}
	if (InStr(清包模式, "自動"))
	{
		ToolTip, % "長按[~]停止。", 0,22,3
		if (GetKeyState("~","P"))
		{
		send {%cleanF3Key% up}
		send {ctrl up}
		ToolTip,,,,3
		return
		}
	}
}
}
ToolTip,,,,3
send {ctrl up}
return

快速掃描並存倉:
迴圈狀態:= 0
CoordMode, Pixel, Screen
global 存倉掃描顏色Array:= []
{
 存倉掃描顏色Array:= []
 if (InStr(清包模式, "快搜") || 清包模式 = "掃描快搜翻頁")
 Gosub,返回首頁
 send {ctrl down}
 loop % 掃描水平數量
	{
	if (GetKeyState("~","P"))
	{
	send {ctrl up}
	send {Shift up}
	ToolTip,,,,3
	ToolTip,,,,2
	ToolTip,,,,1
	Break
	Return
	}
	colIdx:= A_Index
	PosX:= Round(掃描開始左上_X + (colIdx - 1) * 背包步長_X)
	loop % 掃描垂直數量
		{
		rowIdx:= A_Index
		if (GetKeyState("~","P"))
		{
		send {ctrl up}
		send {Shift up}
		ToolTip,,,,3
		ToolTip,,,,2
		ToolTip,,,,1
		Break
		Return
		}
		PosY:= Round(掃描開始左上_Y + (rowIdx - 1) * 背包步長_Y)
		ToolTip, % "掃描: " PosX "/" PosY "，長按[~]停止。", 0,0,1
		PixelGetColor, pcol2, % PosX, % PosY, Fast RGB
		存倉掃描顏色Array.Push(pcol2)
		迴圈狀態:= 迴圈狀態 +1
		ToolTip, % "掃描格子數: " 迴圈狀態 " /60 ，長按[~]停止。"  , 0,22,2
			if (清包保留Array[迴圈狀態])
				continue
			If not pcol2 = 背包初始顏色%迴圈狀態%
			{
				if (InStr(清包模式, "快搜") || 清包模式 = "掃描快搜翻頁")
				{
				Gosub,返回首頁
				Mousemove, % PosX, % PosY,0
				sleep 10
				gosub,快搜倉庫頁
				ToolTip, % "即時: "快搜配對 " / 頁數 " 計算值 "自動翻頁存倉擁多步驟因此較慢，長按[~]停止。", 0,42,3
				sleep 10
				if 快搜配對 = 需按Shift
				send {Shift Down}
				}
			MouseClick,, % PosX, % PosY,1,0
			快搜配對 = 0
			send {Shift Up}
			}
		}
	}
 ToolTip,,,,3
 ToolTip,,,,2
 ToolTip,,,,1
 ToolTip("背包已淨空或停止。 ")
 send {ctrl up}
}
return

;[F7座標定位區]------------------------------------------------------------------------------------------------------

HK_WinF7_ModeLabel:
Msgbox,16,提醒,本工具的 [Win + F7] 沒有多功能切換哦~ ^0^
return

HK_F7_Label:
	if (捕捉模式 = 1)
	{
		SetTimer, UpdateCaptureOverlay, Off
		HideCaptureOverlay()
		MouseGetPos, capX, capY
		PixelGetColor, capC, %capX%, %capY%, RGB
		ToolTip("")
		if (捕捉類型 = "color")
		{
			if (捕捉代號 = 5 || 捕捉代號 = 6)
			{
				; F7 抓點當下探測左右同色安全寬度，確保基準點未貼邊或點到雜訊
				leftSpan := 0
				Loop, 20
				{
					testX := capX - (A_Index * 6)
					if (testX < 0)
						break
					PixelGetColor, testC, %testX%, %capY%, Fast RGB
					if !IsColorWithinTolerance(testC, capC, 20)
						break
					leftSpan += 6
				}
				rightSpan := 0
				Loop, 20
				{
					testX := capX + (A_Index * 6)
					PixelGetColor, testC, %testX%, %capY%, Fast RGB
					if !IsColorWithinTolerance(testC, capC, 20)
						break
					rightSpan += 6
				}
				totalSpan := leftSpan + rightSpan
				if (totalSpan < 24)
				{
					ToolTip("⚠️ 偵測到的背景同色寬度過窄 (" . totalSpan . "px)，可能點到邊框或雜訊，建議重抓輸入框內側！")
				}
				else
				{
					; 若基準點過度貼近單側邊緣，自動向內側安全區微調
					if (leftSpan < 18 && rightSpan >= 36)
						capX += 24
					else if (rightSpan < 18 && leftSpan >= 36)
						capX -= 24
					ToolTip("已設定對話框(" . (捕捉代號 - 4) . ")偵測點，安全寬度約 " . totalSpan . "px")
				}
			}
			PosX:= ["","","","","顏色5_X","顏色6_X"]
			PosY:= ["","","","","顏色5_Y","顏色6_Y"]
			CosA:= ["","","","","顏色5_C","顏色6_C"]
			iniWrite,% capX, sidtooldata.ini, 顏色座標, % PosX[捕捉代號]
			iniWrite,% capY, sidtooldata.ini, 顏色座標, % PosY[捕捉代號]
			iniWrite,% capC, sidtooldata.ini, 顏色座標, % CosA[捕捉代號]
			gosub,座標顏色讀取
		}
		else if (捕捉類型 = "bag")
		{
			PosX:= ["背包左上_X","背包右下_X"]
			PosY:= ["背包左上_Y","背包右下_Y"]
			CosA:= ["背包左上_C","背包右下_C"]
			iniWrite,% capX, sidtooldata.ini, 背包定位, % PosX[捕捉代號]
			iniWrite,% capY, sidtooldata.ini, 背包定位, % PosY[捕捉代號]
			iniWrite,% capC, sidtooldata.ini, 背包定位, % CosA[捕捉代號]
			gosub,讀取F7背包定位內容
			gosub,背包運算作業
		}
		else if (捕捉類型 = "haggle")
		{
			if (捕捉代號 = 1)
			{
				確認按鈕_X:= capX
				確認按鈕_Y:= capY
				iniWrite,% capX, sidtooldata.ini, 討價還價定位, 確認按鈕_X
				iniWrite,% capY, sidtooldata.ini, 討價還價定位, 確認按鈕_Y
				ToolTip("已設定討價還價【確認按鈕】座標: " . capX . ", " . capY)
			}
			else if (捕捉代號 = 2)
			{
				重骰按鈕_X:= capX
				重骰按鈕_Y:= capY
				iniWrite,% capX, sidtooldata.ini, 討價還價定位, 重骰按鈕_X
				iniWrite,% capY, sidtooldata.ini, 討價還價定位, 重骰按鈕_Y
				ToolTip("已設定討價還價【重骰按鈕】座標: " . capX . ", " . capY)
			}
			gosub,讀取討價還價定位
		}
		else if (捕捉類型 = "gemSwap")
		{
			if (捕捉代號 = 1)
			{
				寶石1_X:= capX
				寶石1_Y:= capY
				iniWrite,% capX, sidtooldata.ini, 交換寶石定位, 寶石1_X
				iniWrite,% capY, sidtooldata.ini, 交換寶石定位, 寶石1_Y
				ToolTip("已設定【交換寶石1】座標: " . capX . ", " . capY)
			}
			else if (捕捉代號 = 2)
			{
				寶石2_X:= capX
				寶石2_Y:= capY
				iniWrite,% capX, sidtooldata.ini, 交換寶石定位, 寶石2_X
				iniWrite,% capY, sidtooldata.ini, 交換寶石定位, 寶石2_Y
				ToolTip("已設定【交換寶石2】座標: " . capX . ", " . capY)
			}
			gosub,讀取交換寶石定位
		}
		else if (捕捉類型 = "craft")
		{
			craftKeys := ["洗詞目標", "洗詞改造", "洗詞增幅", "洗詞蛻變", "洗詞重鑄", "洗詞混沌", "洗詞點金", "洗詞瓦爾"]
			craftNames := ["目標裝備/地圖格", "改造石", "增幅石", "蛻變石", "重鑄石", "混沌石", "點金石", "瓦爾寶珠"]
			cKey := craftKeys[捕捉代號]
			cName := craftNames[捕捉代號]
			if (cKey != "")
			{
				iniWrite, % capX, sidtooldata.ini, 自動洗詞定位, % cKey . "_X"
				iniWrite, % capY, sidtooldata.ini, 自動洗詞定位, % cKey . "_Y"
				ToolTip("已設定【" . cName . "】座標: " . capX . ", " . capY)
			}
			gosub, 讀取洗詞設置
		}
		else if (捕捉類型 = "portalScroll")
		{
			傳送卷軸_X := capX
			傳送卷軸_Y := capY
			iniWrite, % capX, sidtooldata.ini, 清包設置, 傳送卷軸_X
			iniWrite, % capY, sidtooldata.ini, 清包設置, 傳送卷軸_Y
			ToolTip("已設定【傳送卷軸】座標: " . capX . ", " . capY)
			gosub, 讀取補充傳送卷軸設置
		}
		try {
			neutron.wnd.updateAnchorPoint(捕捉類型, 捕捉代號, capX, capY, capC)
		} catch {
			neutron.wnd.eval("updateAnchorPoint('" . 捕捉類型 . "'," . 捕捉代號 . "," . capX . "," . capY . ",'" . capC . "')")
		}
		try {
			neutron.wnd.syncDataFromAHK()
		}
		if (捕捉類型 = "color" && (捕捉代號 = 5 || 捕捉代號 = 6))
		{
			; 短暫於最終採樣座標顯示亮青色鎖定框，讓使用者確認實際檢測區塊落點
			ShowCaptureOverlay(capX, capY, "00E5FF")
			Sleep, 1000
			HideCaptureOverlay()
		}
		neutron.Show()
		捕捉模式:= 0
	}
	return

讀取F7背包定位內容:
iniread,背包左上_X, sidtooldata.ini, 背包定位, 背包左上_X
iniread,背包左上_Y, sidtooldata.ini, 背包定位, 背包左上_Y
iniread,背包左上_C, sidtooldata.ini, 背包定位, 背包左上_C
iniread,背包右下_X, sidtooldata.ini, 背包定位, 背包右下_X
iniread,背包右下_Y, sidtooldata.ini, 背包定位, 背包右下_Y
iniread,背包右下_C, sidtooldata.ini, 背包定位, 背包右下_C
return

讀取討價還價定位:
iniread, 確認按鈕_X, sidtooldata.ini, 討價還價定位, 確認按鈕_X, 0
iniread, 確認按鈕_Y, sidtooldata.ini, 討價還價定位, 確認按鈕_Y, 0
iniread, 重骰按鈕_X, sidtooldata.ini, 討價還價定位, 重骰按鈕_X, 0
iniread, 重骰按鈕_Y, sidtooldata.ini, 討價還價定位, 重骰按鈕_Y, 0
return

讀取交換寶石定位:
iniread, 寶石1_X, sidtooldata.ini, 交換寶石定位, 寶石1_X, 0
iniread, 寶石1_Y, sidtooldata.ini, 交換寶石定位, 寶石1_Y, 0
iniread, 寶石2_X, sidtooldata.ini, 交換寶石定位, 寶石2_X, 0
iniread, 寶石2_Y, sidtooldata.ini, 交換寶石定位, 寶石2_Y, 0
iniread, 寶石副手切換, sidtooldata.ini, 交換寶石定位, 副手切換, 0
return

背包運算作業:
掃描開始左上_X:= 背包左上_X
掃描開始左上_Y:= 背包左上_Y
掃描開始右下_X:= 背包右下_X
掃描開始右下_Y:= 背包右下_Y
掃描水平數量:= 12
掃描垂直數量:= 5
背包步長_X:= (掃描水平數量 > 1) ? (掃描開始右下_X - 掃描開始左上_X) / (掃描水平數量 - 1) : 0
背包步長_Y:= (掃描垂直數量 > 1) ? (掃描開始右下_Y - 掃描開始左上_Y) / (掃描垂直數量 - 1) : 0
背包每格寬:= 背包步長_X
背包每格高:= 背包步長_Y
return

;[Neutron 介面溝通 bridge 函數]--------------------------------------------------------------------------------------

NeutronRunLabel(neutron, labelName) {
	if IsLabel(labelName)
		gosub %labelName%
}

NeutronSaveFlaskConfig(neutron, triggerMode, skillKey, skillFlasks, spaceFlasks, dur1, dur2, dur3, dur4, dur5) {
	global
	藥劑觸發模式:= triggerMode
	主要技能:= skillKey
	使用技能時觸發的藥劑:= skillFlasks
	一鍵喝水時觸發的藥劑:= spaceFlasks
	藥劑持續時間1:= dur1
	藥劑持續時間2:= dur2
	藥劑持續時間3:= dur3
	藥劑持續時間4:= dur4
	藥劑持續時間5:= dur5
	gosub, 儲存藥劑觸發紀錄
	gosub, 讀取藥劑觸發紀錄
	ToolTip("藥劑觸發設置已儲存！ ")
}

NeutronSaveSkillComboConfig(neutron, status, key1, delay1, key2, delay2, key3) {
	global
	技能連段功能:= status
	技1:= key1
	技1延遲:= delay1
	技2:= key2
	技2延遲:= delay2
	技3:= key3
	gosub, 儲存並讀取技能連段數據
	ToolTip("技能連段設置已儲存！ ")
}

NeutronSaveLoopSkillConfig(neutron, s1, t1, s2, t2, s3, t3) {
	global
	循環技能1:= s1
	循環技能時間1:= t1
	循環技能2:= s2
	循環技能時間2:= t2
	循環技能3:= s3
	循環技能時間3:= t3
	gosub, 儲存循環技能設置
	gosub, 讀取循環技能設置
	ToolTip("循環技能設置已儲存！ ")
}

NeutronSaveMineConfig(neutron, mode, staffMode, key, delay1, smokeKey, delay2) {
	global
	地雷模式:= mode
	地雷杖模式:= staffMode
	地雷按鍵:= key
	引爆延遲1:= delay1
	煙霧地雷:= smokeKey
	引爆延遲2:= delay2
	gosub, 儲存並讀取地雷設置
	ToolTip("自動引爆地雷設置已儲存！ ")
}

NeutronSaveClickerConfig(neutron, mode, speed) {
	global
	連點模式:= mode
	滑鼠連點速度:= speed
	IniWrite,% 連點模式, sidtooldata.ini, 按鍵模式切換, 連點模式
	IniWrite,% 滑鼠連點速度, sidtooldata.ini, 按鍵模式切換, 滑鼠連點速度
	gosub, 讀取連點模式
	gosub, 讀取滑鼠連點速度
	ToolTip("滑鼠連點設置已儲存！ ")
}

NeutronSaveClearBagConfig(neutron, mode, ignoredSlots:="__NOT_PASSED__", refillPortal:="__NOT_PASSED__", silent:=0) {
	global
	清包模式:= mode
	IniWrite,% 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
	if (ignoredSlots != "__NOT_PASSED__")
	{
		清包保留格:= ignoredSlots
		gosub, 儲存清包保留格
		gosub, 讀取清包保留格
	}
	if (refillPortal != "__NOT_PASSED__")
	{
		補充傳送卷軸 := (refillPortal = 1 || refillPortal = "1" || refillPortal = "true" || refillPortal = "+checked") ? 1 : 0
		IniWrite, % 補充傳送卷軸, sidtooldata.ini, 清包設置, 補充傳送卷軸
		gosub, 讀取補充傳送卷軸設置
	}
	if (!silent)
		ToolTip("清包設置已儲存！ ")
}

NeutronSaveWarehouseConfig(neutron, enchant, legendary, legendaryRing, thief, remove2, incubator, abyssJewel, clusterJewel, normalJewel, faction, specialMap, riftRing, uniqueHelmet, uniqueArmour, uniqueBelt, uniqueGloves, uniqueBoots, uniqueAccessory, uniqueWeapon, returnPage) {
	global
	附魔裝:= enchant
	傳奇裝:= legendary
	傳奇戒:= legendaryRing
	劫盜裝:= thief
	移除2:= remove2
	培育器:= incubator
	深淵珠:= abyssJewel
	星團珠:= clusterJewel
	普通珠:= normalJewel
	勢力裝頁:= faction
	特殊地圖:= specialMap
	裂痕戒指:= riftRing
	未鑑定稀有頭盔:= uniqueHelmet
	未鑑定稀有衣服:= uniqueArmour
	未鑑定稀有腰帶:= uniqueBelt
	未鑑定稀有手套:= uniqueGloves
	未鑑定稀有鞋子:= uniqueBoots
	未鑑定稀有飾品:= uniqueAccessory
	未鑑定稀有武器:= uniqueWeapon
	返回頁數:= returnPage
	gosub, 儲存並讀取倉庫頁數據
	ToolTip("倉庫頁面設置已儲存！ ")
}

StartAnchorCapture(neutron, type, id) {
	global
	捕捉類型:= type
	捕捉代號:= id
	捕捉模式:= 1
	hkF7Val:= (快捷鍵_F7 != "" && 快捷鍵_F7 != "ERROR") ? 快捷鍵_F7: "*F7"
	Hotkey, IfWinActive, ahk_group PoEGames
	try {
		Hotkey, %hkF7Val%, HK_F7_Label, On
	}
	Hotkey, IfWinActive
	neutron.Hide()
	if (type = "color" && (id = 5 || id = 6))
	{
		SetTimer, UpdateCaptureOverlay, 30
		ToolTip("📍 請將滑鼠框對準對話框黑幕（綠框=安全、紅框=貼邊），按 F7 完成抓取")
	}
	else
	{
		ToolTip("📍 請將滑鼠游標移至目標位置，按下 F7 完成抓取與儲存")
	}
}

NeutronGetSettings(neutron) {
	global
	json:= "{"
	json .= """flaskMode"":""" . 藥劑觸發模式 . ""","
	json .= """mainSkill"":""" . 主要技能 . ""","
	json .= """skillFlasks"":""" . 使用技能時觸發的藥劑 . ""","
	json .= """spaceFlasks"":""" . 一鍵喝水時觸發的藥劑 . ""","
	json .= """dur1"":""" . 藥劑持續時間1 . ""","
	json .= """dur2"":""" . 藥劑持續時間2 . ""","
	json .= """dur3"":""" . 藥劑持續時間3 . ""","
	json .= """dur4"":""" . 藥劑持續時間4 . ""","
	json .= """dur5"":""" . 藥劑持續時間5 . ""","
	json .= """comboStatus"":""" . 技能連段功能 . ""","
	json .= """comboKey1"":""" . 技1 . ""","
	json .= """comboDelay1"":""" . 技1延遲 . ""","
	json .= """comboKey2"":""" . 技2 . ""","
	json .= """comboDelay2"":""" . 技2延遲 . ""","
	json .= """comboKey3"":""" . 技3 . ""","
	json .= """loop1"":""" . 循環技能1 . ""","
	json .= """loopT1"":""" . 循環技能時間1 . ""","
	json .= """loop2"":""" . 循環技能2 . ""","
	json .= """loopT2"":""" . 循環技能時間2 . ""","
	json .= """loop3"":""" . 循環技能3 . ""","
	json .= """loopT3"":""" . 循環技能時間3 . ""","
	json .= """mineMode"":""" . 地雷模式 . ""","
	json .= """mineStaffMode"":""" . 地雷杖模式 . ""","
	json .= """mineKey"":""" . 地雷按鍵 . ""","
	json .= """mineDelay1"":""" . 引爆延遲1 . ""","
	json .= """smokeKey"":""" . 煙霧地雷 . ""","
	json .= """mineDelay2"":""" . 引爆延遲2 . ""","
	json .= """clickMode"":""" . 連點模式 . ""","
	json .= """clickSpeed"":""" . 滑鼠連點速度 . ""","
	json .= """clearBagMode"":""" . 清包模式 . ""","
	json .= """clearBagIgnoreSlots"":""" . 清包保留格 . ""","
	json .= """clearBagRefillPortal"":""" . 補充傳送卷軸 . ""","
	json .= """portalScroll_X"":""" . 傳送卷軸_X . ""","
	json .= """portalScroll_Y"":""" . 傳送卷軸_Y . ""","
	json .= """hk_F1"":""" . 快捷鍵_F1 . ""","
	json .= """hk_F2"":""" . 快捷鍵_F2 . ""","
	json .= """hk_F3"":""" . 快捷鍵_F3 . ""","
	json .= """hk_F7"":""" . 快捷鍵_F7 . ""","
	json .= """hk_Space"":""" . 快捷鍵_Space . ""","
	json .= """hk_Insert"":""" . 快捷鍵_Insert . ""","
	json .= """hk_End"":""" . 快捷鍵_End . ""","
	json .= """color5_X"":""" . 顏色5_X . ""","
	json .= """color5_Y"":""" . 顏色5_Y . ""","
	json .= """color5_C"":""" . 顏色5_C . ""","
	json .= """color6_X"":""" . 顏色6_X . ""","
	json .= """color6_Y"":""" . 顏色6_Y . ""","
	json .= """color6_C"":""" . 顏色6_C . ""","
	json .= """bag1_X"":""" . 背包左上_X . ""","
	json .= """bag1_Y"":""" . 背包左上_Y . ""","
	json .= """bag1_C"":""" . 背包左上_C . ""","
	json .= """bag2_X"":""" . 背包右下_X . ""","
	json .= """bag2_Y"":""" . 背包右下_Y . ""","
	json .= """bag2_C"":""" . 背包右下_C . ""","
	json .= """haggleConfirm_X"":""" . 確認按鈕_X . ""","
	json .= """haggleConfirm_Y"":""" . 確認按鈕_Y . ""","
	json .= """haggleReroll_X"":""" . 重骰按鈕_X . ""","
	json .= """haggleReroll_Y"":""" . 重骰按鈕_Y . ""","
	json .= """gem1_X"":""" . 寶石1_X . ""","
	json .= """gem1_Y"":""" . 寶石1_Y . ""","
	json .= """gem2_X"":""" . 寶石2_X . ""","
	json .= """gem2_Y"":""" . 寶石2_Y . ""","
	json .= """gemWeaponSwap"":""" . 寶石副手切換 . ""","
	json .= """hk_F6"":""" . 快捷鍵_F6 . ""","
	json .= """hk_OpenUI"":""" . 快捷鍵_OpenUI . ""","
	json .= """craftScope"":""" . EscapeJsonStr(洗詞範圍) . ""","
	json .= """craftMode"":""" . EscapeJsonStr(洗詞模式) . ""","
	json .= """craftMatchLogic"":""" . EscapeJsonStr(洗詞匹配邏輯) . ""","
	json .= """craftUseVaal"":""" . 洗詞使用瓦爾 . ""","
	json .= """craftMaxTries"":""" . 洗詞最大次數 . ""","
	json .= """craftDelay"":""" . 洗詞延遲 . ""","
	json .= """craftWhitelist"":""" . EscapeJsonStr(洗詞白名單) . ""","
	json .= """craftBlacklist"":""" . EscapeJsonStr(洗詞黑名單) . ""","
	json .= """craft1_X"":""" . 洗詞目標_X . ""","
	json .= """craft1_Y"":""" . 洗詞目標_Y . ""","
	json .= """craft2_X"":""" . 洗詞改造_X . ""","
	json .= """craft2_Y"":""" . 洗詞改造_Y . ""","
	json .= """craft3_X"":""" . 洗詞增幅_X . ""","
	json .= """craft3_Y"":""" . 洗詞增幅_Y . ""","
	json .= """craft4_X"":""" . 洗詞蛻變_X . ""","
	json .= """craft4_Y"":""" . 洗詞蛻變_Y . ""","
	json .= """craft5_X"":""" . 洗詞重鑄_X . ""","
	json .= """craft5_Y"":""" . 洗詞重鑄_Y . ""","
	json .= """craft6_X"":""" . 洗詞混沌_X . ""","
	json .= """craft6_Y"":""" . 洗詞混沌_Y . ""","
	json .= """craft7_X"":""" . 洗詞點金_X . ""","
	json .= """craft7_Y"":""" . 洗詞點金_Y . ""","
	json .= """craft8_X"":""" . 洗詞瓦爾_X . ""","
	json .= """craft8_Y"":""" . 洗詞瓦爾_Y . ""","
	json .= """craftPresets"":" . BuildCraftPresetsJson()
	json .= "}"
	return json
}

;[自訂快捷鍵相關函數與邏輯]----------------------------------------------------------------------------------

CleanKeyName(hk) {
	clean:= RegExReplace(hk, "i)^[~*$^!+#]+", "")
	return clean
}

讀取自訂快捷鍵:
Iniread, 快捷鍵_F1, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_F1, *F1
Iniread, 快捷鍵_F2, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_F2, F2
Iniread, 快捷鍵_F3, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_F3, F3
Iniread, 快捷鍵_F6, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_F6, F6
Iniread, 快捷鍵_F7, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_F7, *F7
Iniread, 快捷鍵_OpenUI, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_OpenUI, ERROR
if (快捷鍵_OpenUI = "ERROR" || 快捷鍵_OpenUI = "")
{
	Iniread, legacyOpenUI, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_WinZ, ``
	快捷鍵_OpenUI := (legacyOpenUI != "ERROR" && legacyOpenUI != "") ? legacyOpenUI : "``"
}
Iniread, 快捷鍵_Space, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_Space, ~*space
Iniread, 快捷鍵_Insert, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_Insert, *Insert
Iniread, 快捷鍵_End, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_End, End
Return

註冊動態熱鍵:
keysList:= "F1,F2,F3,F6,F7,OpenUI,Space,Insert,End"
Loop, parse, keysList, % ","
{
    kName:= A_LoopField
    hkVal:= 快捷鍵_%kName%
    lbl:= "HK_" . kName . "_Label"
    if (hkVal != "" && hkVal != "ERROR")
    {
        if (kName = "OpenUI")
            Hotkey, IfWinActive, ahk_group DualWins
        else
            Hotkey, IfWinActive, ahk_group PoEGames
        try {
            Hotkey, %hkVal%, %lbl%, On
        }
    }

    if (kName = "F1" || kName = "F2" || kName = "F3" || kName = "F7" || kName = "End")
    {
        cleanK:= CleanKeyName(hkVal)
        if (cleanK != "")
        {
            winHk:= "#" . cleanK
            winLbl:= "HK_Win" . kName . "_ModeLabel"
            Hotkey, IfWinActive, ahk_group PoEGames
            try {
                Hotkey, %winHk%, %winLbl%, On
            }
        }
    }
}
Hotkey, IfWinActive
Return

解開動態熱鍵:
keysList:= "F1,F2,F3,F6,F7,OpenUI,Space,Insert,End"
Loop, parse, keysList, % ","
{
    kName:= A_LoopField
    hkVal:= 快捷鍵_%kName%
    if (hkVal != "" && hkVal != "ERROR")
    {
        if (kName = "OpenUI")
            Hotkey, IfWinActive, ahk_group DualWins
        else
            Hotkey, IfWinActive, ahk_group PoEGames
        try {
            Hotkey, %hkVal%, Off
        }
    }
    if (kName = "F1" || kName = "F2" || kName = "F3" || kName = "F7" || kName = "End")
    {
        cleanK:= CleanKeyName(hkVal)
        if (cleanK != "")
        {
            winHk:= "#" . cleanK
            Hotkey, IfWinActive, ahk_group PoEGames
            try {
                Hotkey, %winHk%, Off
            }
        }
    }
}
Hotkey, IfWinActive
Return

NeutronSaveCustomHotkeys(neutron, hkF1, hkF2, hkF3, hkSpace, hkInsert, hkEnd, hkF6 := "F6", hkOpenUI := "``") {
	global
	gosub, 解開動態熱鍵
	快捷鍵_F1:= hkF1
	快捷鍵_F2:= hkF2
	快捷鍵_F3:= hkF3
	快捷鍵_F6:= hkF6
	快捷鍵_OpenUI:= hkOpenUI
	快捷鍵_Space:= hkSpace
	快捷鍵_Insert:= hkInsert
	快捷鍵_End:= hkEnd

	keysList:= "F1,F2,F3,F6,OpenUI,Space,Insert,End"
	Loop, parse, keysList, % ","
	{
		kName:= A_LoopField
		IniWrite, % 快捷鍵_%kName%, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_%kName%
	}
	gosub, 註冊動態熱鍵
	ToolTip("自訂快捷鍵設置已儲存並生效！ ")
}

NeutronSaveCraftConfig(neutron, scope, mode, matchLogic, useVaal, maxTries, delayMs, whitelist, blacklist, silent := 0) {
	global
	洗詞範圍:= scope
	洗詞模式:= mode
	洗詞匹配邏輯:= matchLogic
	洗詞使用瓦爾:= useVaal
	洗詞最大次數:= (maxTries > 0) ? maxTries : 200
	洗詞延遲:= (delayMs >= 40) ? delayMs : 120
	洗詞白名單:= StrReplace(whitelist, "`r", "")
	洗詞黑名單:= StrReplace(blacklist, "`r", "")

	IniWrite, % 洗詞範圍, sidtooldata.ini, 自動洗詞設置, 洗詞範圍
	IniWrite, % 洗詞模式, sidtooldata.ini, 自動洗詞設置, 洗詞模式
	IniWrite, % 洗詞匹配邏輯, sidtooldata.ini, 自動洗詞設置, 洗詞匹配邏輯
	IniWrite, % 洗詞使用瓦爾, sidtooldata.ini, 自動洗詞設置, 洗詞使用瓦爾
	IniWrite, % 洗詞最大次數, sidtooldata.ini, 自動洗詞設置, 洗詞最大次數
	IniWrite, % 洗詞延遲, sidtooldata.ini, 自動洗詞設置, 洗詞延遲
	IniWrite, % StrReplace(洗詞白名單, "`n", "§NL§"), sidtooldata.ini, 自動洗詞設置, 洗詞白名單
	IniWrite, % StrReplace(洗詞黑名單, "`n", "§NL§"), sidtooldata.ini, 自動洗詞設置, 洗詞黑名單
	if (!silent)
		ToolTip("自動洗詞設置已儲存！ ")
}

NeutronSaveCraftPreset(neutron, presetName, whitelist, blacklist, matchLogic) {
	global
	cleanName := Trim(StrReplace(StrReplace(StrReplace(presetName, "=", "_"), "`r", ""), "`n", ""))
	if (cleanName = "")
		return
	cleanWL := StrReplace(whitelist, "`r", "")
	cleanBL := StrReplace(blacklist, "`r", "")
	wlEnc := StrReplace(cleanWL, "`n", "§NL§")
	blEnc := StrReplace(cleanBL, "`n", "§NL§")
	val := matchLogic . "§PSEP§" . wlEnc . "§PSEP§" . blEnc
	IniWrite, % val, sidtooldata.ini, 自動洗詞群組, % cleanName

	; 同步更新目前使用中的白/黑名單與匹配方式，確保立即生效
	洗詞匹配邏輯 := matchLogic
	洗詞白名單 := cleanWL
	洗詞黑名單 := cleanBL
	IniWrite, % 洗詞匹配邏輯, sidtooldata.ini, 自動洗詞設置, 洗詞匹配邏輯
	IniWrite, % wlEnc, sidtooldata.ini, 自動洗詞設置, 洗詞白名單
	IniWrite, % blEnc, sidtooldata.ini, 自動洗詞設置, 洗詞黑名單

	gosub, 讀取洗詞群組
	try {
		neutron.wnd.refreshCraftPresets(BuildCraftPresetsJson(), cleanName)
	}
	ToolTip("已儲存/更新洗詞群組：【" . cleanName . "】")
}

NeutronDeleteCraftPreset(neutron, presetName) {
	global
	cleanName := Trim(StrReplace(StrReplace(StrReplace(presetName, "=", "_"), "`r", ""), "`n", ""))
	if (cleanName = "")
		return
	IniDelete, sidtooldata.ini, 自動洗詞群組, % cleanName
	gosub, 讀取洗詞群組
	try {
		neutron.wnd.refreshCraftPresets(BuildCraftPresetsJson(), "")
	}
	ToolTip("已刪除洗詞群組：【" . cleanName . "】")
}

NeutronSaveGemSwapConfig(neutron, weaponSwap) {
	global 寶石副手切換
	寶石副手切換:= weaponSwap
	iniWrite, %weaponSwap%, sidtooldata.ini, 交換寶石定位, 副手切換
}

IsPoE1Active()
{
	return WinActive("Path of Exile") && !WinActive("Path of Exile 2")
}

RunAutoClickLoop()
{
	global clickStop, 連點模式, 滑鼠連點速度
	clickStop := false
	Sleep, 100
	if (clickStop || !WinActive("ahk_group PoEGames") || !IsAutoClickModifierHeld(連點模式))
	{
		clickStop := false
		return
	}
	Loop
	{
		if (clickStop || !WinActive("ahk_group PoEGames") || !IsAutoClickModifierHeld(連點模式))
		{
			clickStop := false
			return
		}
		Click
		Sleep, % 滑鼠連點速度
	}
}

IsAutoClickModifierHeld(mode)
{
	ctrlHeld := GetKeyState("Ctrl") || GetKeyState("Ctrl", "P")
	shiftHeld := GetKeyState("Shift") || GetKeyState("Shift", "P")
	if (mode = "[Ctrl + 左鍵]")
		return ctrlHeld
	if (mode = "[Shift + 左鍵]")
		return shiftHeld
	if (mode = "[Ctrl / Shift + 左鍵]")
		return (ctrlHeld || shiftHeld)
	return false
}

IsColorWithinTolerance(c1, c2, tolerance := 20)
{
	r1 := (c1 >> 16) & 0xFF
	g1 := (c1 >> 8) & 0xFF
	b1 := c1 & 0xFF

	r2 := (c2 >> 16) & 0xFF
	g2 := (c2 >> 8) & 0xFF
	b2 := c2 & 0xFF

	return (Abs(r1 - r2) <= tolerance && Abs(g1 - g2) <= tolerance && Abs(b1 - b2) <= tolerance)
}

CalibrateDialogOffsets(slot, targetX, targetY, savedColor, tolerance := 20)
{
	global DialogValidOffsets
	if !IsObject(DialogValidOffsets)
		DialogValidOffsets := {1: "", 2: ""}
	candidates := [-30, -24, -18, -12, -6, 0, 6, 12, 18, 24, 30]
	validList := []
	for _, off in candidates
	{
		checkX := targetX + off
		if (checkX < 0)
			continue
		PixelGetColor, curColor, %checkX%, %targetY%, Fast RGB
		if IsColorWithinTolerance(curColor, savedColor, tolerance)
			validList.Push(off)
	}
	if (validList.Length() >= 3)
		DialogValidOffsets[slot] := validList
}

CheckDialogColorMatch(targetX, targetY, savedColor, tolerance := 20, slot := 0)
{
	global DialogValidOffsets
	if (targetX = "" || targetX = "error" || targetX = "ERROR" || targetY = "" || targetY = "error" || targetY = "ERROR" || savedColor = "" || savedColor = "error" || savedColor = "ERROR")
		return false

	; 1. 若已有 Enter 校準後的框內有效採樣點快取，僅採樣框內點（100% 不超框）
	if (slot > 0 && IsObject(DialogValidOffsets) && IsObject(DialogValidOffsets[slot]) && DialogValidOffsets[slot].Length() >= 3)
	{
		validOffsets := DialogValidOffsets[slot]
		total := validOffsets.Length()
		reqHits := (total >= 3) ? 3 : total
		hits := 0
		for idx, off in validOffsets
		{
			checkX := targetX + off
			PixelGetColor, curColor, %checkX%, %targetY%, Fast RGB
			if IsColorWithinTolerance(curColor, savedColor, tolerance)
			{
				hits++
				if (hits >= reqHits)
					return true
			}
			; 若剩餘點數已不足以達成門檻，提早結束
			if (hits + (total - idx) < reqHits)
				return false
		}
		return false
	}

	; 2. 尚未校準前的保底機制：雙向分段共識（左側組 + 中心 / 右側組 + 中心）
	PixelGetColor, centerColor, %targetX%, %targetY%, Fast RGB
	centerHit := IsColorWithinTolerance(centerColor, savedColor, tolerance) ? 1 : 0

	leftOffsets := [-6, -12, -18, -24]
	leftHits := centerHit
	for idx, off in leftOffsets
	{
		checkX := targetX + off
		if (checkX >= 0)
		{
			PixelGetColor, curColor, %checkX%, %targetY%, Fast RGB
			if IsColorWithinTolerance(curColor, savedColor, tolerance)
			{
				leftHits++
				if (leftHits >= 3)
					return true
			}
		}
		if (leftHits + (4 - idx) < 3)
			break
	}

	rightOffsets := [6, 12, 18, 24]
	rightHits := centerHit
	for idx, off in rightOffsets
	{
		checkX := targetX + off
		PixelGetColor, curColor, %checkX%, %targetY%, Fast RGB
		if IsColorWithinTolerance(curColor, savedColor, tolerance)
		{
			rightHits++
			if (rightHits >= 3)
				return true
		}
		if (rightHits + (4 - idx) < 3)
			break
	}

	return false
}

IsPoEDialogActive(tolerance := 20)
{
	global 顏色5_X, 顏色5_Y, 顏色5_C, 顏色6_X, 顏色6_Y, 顏色6_C
	if CheckDialogColorMatch(顏色5_X, 顏色5_Y, 顏色5_C, tolerance, 1)
		return 1
	if CheckDialogColorMatch(顏色6_X, 顏色6_Y, 顏色6_C, tolerance, 2)
		return 2
	return 0
}

ShowCaptureOverlay(cx, cy, borderColor := "00FF88")
{
	static lastColor := "", overlayHwnd := 0
	w := 68
	h := 18
	b := 2
	x := cx - (w // 2)
	y := cy - (h // 2)

	if (!overlayHwnd || !WinExist("ahk_id " . overlayHwnd) || lastColor != borderColor)
	{
		Gui, CaptureOverlay:Destroy
		Gui, CaptureOverlay:+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x08000000 -DPIScale +HwndoverlayHwnd
		Gui, CaptureOverlay:Color, FF00FF
		Gui, CaptureOverlay:Margin, 0, 0
		Gui, CaptureOverlay:Add, Progress, % "x0 y0 w" . w . " h" . b . " Background" . borderColor, 0
		Gui, CaptureOverlay:Add, Progress, % "x0 y" . (h - b) . " w" . w . " h" . b . " Background" . borderColor, 0
		Gui, CaptureOverlay:Add, Progress, % "x0 y0 w" . b . " h" . h . " Background" . borderColor, 0
		Gui, CaptureOverlay:Add, Progress, % "x" . (w - b) . " y0 w" . b . " h" . h . " Background" . borderColor, 0
		Gui, CaptureOverlay:Show, % "x" . x . " y" . y . " w" . w . " h" . h . " NoActivate"
		WinSet, TransColor, FF00FF, ahk_id %overlayHwnd%
		lastColor := borderColor
	}
	else
	{
		Gui, CaptureOverlay:Show, % "x" . x . " y" . y . " w" . w . " h" . h . " NoActivate"
	}
}

HideCaptureOverlay()
{
	Gui, CaptureOverlay:Hide
}

UpdateCaptureOverlay:
	if (捕捉模式 != 1 || 捕捉類型 != "color" || (捕捉代號 != 5 && 捕捉代號 != 6))
	{
		SetTimer, UpdateCaptureOverlay, Off
		HideCaptureOverlay()
		return
	}
	MouseGetPos, ovX, ovY
	PixelGetColor, ovCenterC, %ovX%, %ovY%, Fast RGB
	ovSafe := false
	if (ovX - 24 >= 0)
	{
		PixelGetColor, ovLeftC, % (ovX - 24), %ovY%, Fast RGB
		PixelGetColor, ovRightC, % (ovX + 24), %ovY%, Fast RGB
		if (IsColorWithinTolerance(ovLeftC, ovCenterC, 20) && IsColorWithinTolerance(ovRightC, ovCenterC, 20))
			ovSafe := true
	}
	ShowCaptureOverlay(ovX, ovY, ovSafe ? "00FF88" : "FF4444")
return

;[探險討價還價(圖貞 Haggle) 快捷鍵]--------------------------------------------------------------------------------------

$1::
if (!GetKeyState("capslock","T") || Toolbutton = 1 || WinActive("ahk_id " . neutron.hWnd) || !IsPoE1Active())
{
	settimer,防呆藥水1計時器,off
	防呆藥水鎖1 = 無
	Send, 1
}
else
{
	if (確認按鈕_X = "" || 確認按鈕_X = 0 || 確認按鈕_Y = "" || 確認按鈕_Y = 0)
	{
		ToolTip("尚未設定【確認按鈕】座標！請先在菜單設置中進行定位抓取。 ")
		settimer,防呆藥水1計時器,off
		防呆藥水鎖1 = 無
		Send, 1
		return
	}
	MouseClick, left
	Random, FirstH, %vFirstMin%, %vFirstMax%
	Loop, %FirstH%
	{
		Send {WheelDown 1}
		Random, vHagglingScrollSpeed, %vHagglingScrollSpeedMin%, %vHagglingScrollSpeedMax%
		Sleep %vHagglingScrollSpeed%
	}
	MouseGetPos, rCordXX, rCordYY
	BlockInput, MouseMove
	MouseMove, %確認按鈕_X%, %確認按鈕_Y%, 0
	Random, vMouseMoveDelaySpeed, %vMouseMoveDelaySpeedMin%, %vMouseMoveDelaySpeedMax%
	Sleep %vMouseMoveDelaySpeed%
	MouseClick, left
	Random, vMouseMoveDelaySpeed, %vMouseMoveDelaySpeedMin%, %vMouseMoveDelaySpeedMax%
	Sleep %vMouseMoveDelaySpeed%
	Random, LastH, %vLastMin%, %vLastMax%
	Loop, %LastH%
	{
		Send {WheelDown 1}
		Sleep %vHagglingScrollSpeed%
	}
	Random, vMouseMoveDelaySpeed, %vMouseMoveDelaySpeedMin%, %vMouseMoveDelaySpeedMax%
	Sleep %vMouseMoveDelaySpeed%
	MouseClick, left
	Sleep %vClickDelaySpeed%
	MouseClick, left
	MouseMove, %rCordXX%, %rCordYY%, 0
	BlockInput, MouseMoveOff
}
return

$2::
if (!GetKeyState("capslock","T") || Toolbutton = 1 || WinActive("ahk_id " . neutron.hWnd) || !IsPoE1Active())
{
	settimer,防呆藥水2計時器,off
	防呆藥水鎖2 = 無
	Send, 2
}
else
{
	if (重骰按鈕_X = "" || 重骰按鈕_X = 0 || 重骰按鈕_Y = "" || 重骰按鈕_Y = 0)
	{
		ToolTip("尚未設定【重骰按鈕】座標！請先在菜單設置中進行定位抓取。 ")
		settimer,防呆藥水2計時器,off
		防呆藥水鎖2 = 無
		Send, 2
		return
	}
	BlockInput, MouseMove
	MouseGetPos, rCordXX, rCordYY
	MouseMove, %重骰按鈕_X%, %重骰按鈕_Y%, 0
	Sleep %vClickDelaySpeed%
	MouseClick, left
	MouseMove, %rCordXX%, %rCordYY%, 0
	BlockInput, MouseMoveOff
}
return

;[一鍵快速交換寶石(Gem Swap) 快捷鍵]----------------------------------------------------------------------------------

$4::
if (!GetKeyState("capslock","T") || Toolbutton = 1 || WinActive("ahk_id " . neutron.hWnd))
{
	settimer,防呆藥水4計時器,off
	防呆藥水鎖4 = 無
	Send, 4
}
else
{
	if (寶石1_X = "" || 寶石1_X = 0 || 寶石1_Y = "" || 寶石1_Y = 0 || 寶石2_X = "" || 寶石2_X = 0 || 寶石2_Y = "" || 寶石2_Y = 0)
	{
		ToolTip("尚未設定交換寶石座標！請先在菜單設置中進行定位抓取。 ")
		settimer,防呆藥水4計時器,off
		防呆藥水鎖4 = 無
		Send, 4
		return
	}
	gosub, 執行寶石交換
}
return

執行寶石交換:
BlockInput, MouseMove
MouseGetPos, origGemX, origGemY

; 開啟背包
Send, {i}
Sleep, 100

; 移動至【交換寶石1】插槽拔出寶石 (右鍵拔出)
MouseMove, %寶石1_X%, %寶石1_Y%, 0
Sleep, %vGemDelay%
Click, Right
Sleep, %vGemDelay%

; 若有勾選切換副手，切換武器
if (寶石副手切換 = 1 || 寶石副手切換 = "1" || 寶石副手切換 = "true")
{
	Send, {x}
	Sleep, %vGemDelay%
}

; 移動至【交換寶石2】背包對調寶石 (左鍵對調)
MouseMove, %寶石2_X%, %寶石2_Y%, 0
Sleep, %vGemDelay%
Click, Left
Sleep, %vGemDelay%

; 若有切換副手，切換回主手
if (寶石副手切換 = 1 || 寶石副手切換 = "1" || 寶石副手切換 = "true")
{
	Send, {x}
	Sleep, %vGemDelay%
}

; 移動回【交換寶石1】插槽鑲嵌新寶石 (左鍵鑲嵌)
MouseMove, %寶石1_X%, %寶石1_Y%, 0
Sleep, %vGemDelay%
Click, Left
Sleep, %vGemDelay%

; 關閉背包
Send, {i}
Sleep, 50

; 游標還原至原位
MouseMove, %origGemX%, %origGemY%, 0
BlockInput, MouseMoveOff
ToolTip("寶石交換完成！ ")
return

;[自動洗詞系統 (PoE 1 通貨頁 / 批次洗背包地圖)]------------------------------------------------------------------------

EscapeJsonStr(s) {
	s := StrReplace(s, "\", "\\")
	s := StrReplace(s, """", "\""")
	s := StrReplace(s, "`r", "")
	s := StrReplace(s, "`n", "\n")
	return s
}

讀取洗詞設置:
	IniRead, 洗詞範圍, sidtooldata.ini, 自動洗詞設置, 洗詞範圍, 單一目標格
	IniRead, 洗詞模式, sidtooldata.ini, 自動洗詞設置, 洗詞模式, 改造石模式
	IniRead, 洗詞匹配邏輯, sidtooldata.ini, 自動洗詞設置, 洗詞匹配邏輯, OR
	IniRead, 洗詞使用瓦爾, sidtooldata.ini, 自動洗詞設置, 洗詞使用瓦爾, 0
	IniRead, 洗詞最大次數, sidtooldata.ini, 自動洗詞設置, 洗詞最大次數, 200
	IniRead, 洗詞延遲, sidtooldata.ini, 自動洗詞設置, 洗詞延遲, 120
	IniRead, rawWL, sidtooldata.ini, 自動洗詞設置, 洗詞白名單, %A_Space%
	IniRead, rawBL, sidtooldata.ini, 自動洗詞設置, 洗詞黑名單, %A_Space%
	洗詞白名單 := (rawWL = "ERROR") ? "" : StrReplace(rawWL, "§NL§", "`n")
	洗詞黑名單 := (rawBL = "ERROR") ? "" : StrReplace(rawBL, "§NL§", "`n")

	craftKeys := ["洗詞目標", "洗詞改造", "洗詞增幅", "洗詞蛻變", "洗詞重鑄", "洗詞混沌", "洗詞點金", "洗詞瓦爾"]
	for _, cKey in craftKeys
	{
		IniRead, tmpX, sidtooldata.ini, 自動洗詞定位, % cKey . "_X", 0
		IniRead, tmpY, sidtooldata.ini, 自動洗詞定位, % cKey . "_Y", 0
		%cKey%_X := (tmpX = "ERROR" || tmpX = "") ? 0 : tmpX
		%cKey%_Y := (tmpY = "ERROR" || tmpY = "") ? 0 : tmpY
	}

	gosub, 讀取洗詞群組
return

讀取洗詞群組:
	洗詞群組List := []
	IniRead, presetSection, sidtooldata.ini, 自動洗詞群組
	if (presetSection != "" && presetSection != "ERROR")
	{
		Loop, Parse, presetSection, `n, `r
		{
			eqPos := InStr(A_LoopField, "=")
			if (eqPos <= 1)
				continue
			pName := Trim(SubStr(A_LoopField, 1, eqPos - 1))
			pRaw := SubStr(A_LoopField, eqPos + 1)
			parts := StrSplit(pRaw, "§PSEP§")
			pLogic := (parts.Length() >= 1 && parts[1] != "") ? parts[1] : "OR"
			pWL := (parts.Length() >= 2) ? StrReplace(parts[2], "§NL§", "`n") : ""
			pBL := (parts.Length() >= 3) ? StrReplace(parts[3], "§NL§", "`n") : ""
			洗詞群組List.Push({name: pName, logic: pLogic, wl: pWL, bl: pBL})
		}
	}
return

BuildCraftPresetsJson() {
	global 洗詞群組List
	out := "["
	if IsObject(洗詞群組List)
	{
		for idx, p in 洗詞群組List
		{
			if (idx > 1)
				out .= ","
			out .= "{""name"":""" . EscapeJsonStr(p.name) . """,""logic"":""" . EscapeJsonStr(p.logic) . """,""wl"":""" . EscapeJsonStr(p.wl) . """,""bl"":""" . EscapeJsonStr(p.bl) . """}"
		}
	}
	out .= "]"
	return out
}

HK_F6_Label:
	if (autoCraftActive)
	{
		autoCraftStopRequested := true
		ToolTip("正在停止自動洗詞...")
		return
	}
	if !IsPoE1Active()
	{
		ToolTip("自動洗詞目前僅支援在 Path of Exile 1 視窗內執行！ ")
		return
	}
	gosub, 執行自動洗詞
return

執行自動洗詞:
	; 驗證必要座標
	if (洗詞範圍 = "單一目標格" && (洗詞目標_X <= 0 || 洗詞目標_Y <= 0))
	{
		ToolTip("⚠️ 尚未設定【目標裝備/地圖格】座標，請先在自動洗詞設定中抓取！ ")
		return
	}
	if (洗詞範圍 = "批次洗背包地圖" && (背包左上_X = "error" || 背包左上_X = "" || 背包右下_X = "error" || 背包右下_X = "" || 背包步長_X <= 0 || 背包步長_Y <= 0))
	{
		ToolTip("⚠️ 批次洗背包地圖需先於「座標定位」完成背包首末格定位！ ")
		return
	}
	if (洗詞模式 = "改造石模式" || 洗詞模式 = "改造+增幅模式")
	{
		if (洗詞改造_X <= 0 || 洗詞蛻變_X <= 0 || 洗詞重鑄_X <= 0 || 洗詞增幅_X <= 0)
		{
			ToolTip("⚠️ 改造石模式需設定【改造石】、【增幅石】、【蛻變石】與【重鑄石】座標！ ")
			return
		}
	}
	else if (洗詞模式 = "點金+重鑄模式")
	{
		if (洗詞點金_X <= 0 || 洗詞重鑄_X <= 0)
		{
			ToolTip("⚠️ 點金+重鑄模式需設定【點金石】與【重鑄石】座標！ ")
			return
		}
	}
	else if (洗詞模式 = "混沌石模式" && 洗詞混沌_X <= 0)
	{
		ToolTip("⚠️ 混沌石模式需設定【混沌石】座標！ ")
		return
	}
	if ((洗詞使用瓦爾 = 1 || 洗詞使用瓦爾 = "1" || 洗詞使用瓦爾 = "true") && (洗詞瓦爾_X <= 0 || 洗詞瓦爾_Y <= 0))
	{
		ToolTip("⚠️ 已勾選達標後使用瓦爾寶珠，請先設定【瓦爾寶珠】座標！ ")
		return
	}

	autoCraftActive := true
	autoCraftStopRequested := false
	ClipSaved := ClipboardAll

	if (洗詞範圍 = "批次洗背包地圖")
	{
		craftedCount := 0
		skippedCount := 0
		stoppedEarly := false
		Loop, 12
		{
			colIdx := A_Index
			slotX := Round(掃描開始左上_X + (colIdx - 1) * 背包步長_X)
			Loop, 5
			{
				if (IsAutoCraftStopped())
				{
					ToolTip("🛑 已手動或切換視窗停止自動洗詞。")
					stoppedEarly := true
					break
				}
				rowIdx := A_Index
				slotIdx := (colIdx - 1) * 5 + rowIdx
				if (清包保留Array[slotIdx])
					continue
				slotY := Round(掃描開始左上_Y + (rowIdx - 1) * 背包步長_Y)
				ToolTip("🔮 批次洗圖中：第 " . colIdx . " 欄 第 " . rowIdx . " 列 (完成 " . craftedCount . " / 跳過 " . skippedCount . " / 按 Esc 停止)")
				res := CraftSingleTarget(slotX, slotY, true)
				if (res = "STOP")
				{
					stoppedEarly := true
					break
				}
				else if (res = "SUCCESS")
					craftedCount++
				else
					skippedCount++
			}
			if (stoppedEarly)
				break
		}
		if (!stoppedEarly && craftedCount > 0)
			SoundBeep, 750, 200
		if (!stoppedEarly)
			ToolTip("🎉 批次洗圖完成！共洗好 " . craftedCount . " 張地圖，跳過 " . skippedCount . " 格。")
	}
	else
	{
		ToolTip("🔮 自動洗詞啟動中（按 Esc 或再按熱鍵立即停止）...")
		res := CraftSingleTarget(洗詞目標_X, 洗詞目標_Y, false)
		if (res = "SUCCESS")
		{
			SoundBeep, 750, 200
			ToolTip("🎉 自動洗詞達標完成！")
		}
	}

	Clipboard := ClipSaved
	ClipSaved := ""
	autoCraftActive := false
	autoCraftStopRequested := false
return

CopyPoEItemAt(tgtX, tgtY)
{
	MouseMove, %tgtX%, %tgtY%, 0
	Sleep, 30
	Clipboard := ""
	Send, ^!c
	ClipWait, 0.25
	if (ErrorLevel)
		return ""
	return Clipboard
}

UseCurrencyOnTarget(currX, currY, tgtX, tgtY, delayMs)
{
	MouseMove, %currX%, %currY%, 0
	Sleep, 25
	Click, Right
	Sleep, 35
	MouseMove, %tgtX%, %tgtY%, 0
	Sleep, 25
	Click, Left
	Random, jitter, 0, 25
	Sleep, % (delayMs + jitter)
}

ParsePoEItemInfo(itemText)
{
	info := {rarity: "", isCorrupted: false, isUnidentified: false, isMap: false, modText: "", modLineCount: 0, modCount: 0}
	if InStr(itemText, "稀有度: 普通") || InStr(itemText, "Rarity: Normal")
		info.rarity := "Normal"
	else if InStr(itemText, "稀有度: 魔法") || InStr(itemText, "Rarity: Magic")
		info.rarity := "Magic"
	else if InStr(itemText, "稀有度: 稀有") || InStr(itemText, "Rarity: Rare")
		info.rarity := "Rare"
	else if InStr(itemText, "稀有度: 傳奇") || InStr(itemText, "Rarity: Unique")
		info.rarity := "Unique"

	if InStr(itemText, "物品種類: 地圖") || InStr(itemText, "Item Class: Maps")
		info.isMap := true

	; 逐行 Trim 正規化檢查不可洗狀態（已汙染/二次汙染/已腐化/已複製/未鑑定），避免換行或空白影響正則
	normalized := StrReplace(itemText, "`r", "")
	Loop, Parse, normalized, `n
	{
		chkLn := Trim(A_LoopField, " `t")
		if (chkLn = "已腐化" || chkLn = "已汙染" || chkLn = "已污染" || chkLn = "二次汙染" || chkLn = "二次污染" || chkLn = "Corrupted" || chkLn = "Twice Corrupted" || chkLn = "已複製" || chkLn = "Mirrored")
			info.isCorrupted := true
		else if (chkLn = "未鑑定" || chkLn = "Unidentified")
			info.isUnidentified := true
	}

	; 擷取「物品等級 / Item Level」之後的純詞綴段落，排除名稱、基本資訊與 { ... } 進階詞綴標記行
	blocks := StrSplit(normalized, "--------")
	ilvlIdx := 0
	for idx, blk in blocks
	{
		if InStr(blk, "物品等級:") || InStr(blk, "Item Level:")
		{
			ilvlIdx := idx
			break
		}
	}
	startIdx := (ilvlIdx > 0) ? (ilvlIdx + 1) : 2
	modBuf := ""
	lastExplicitCount := 0
	advModCount := 0
	Loop, % blocks.Length()
	{
		if (A_Index < startIdx)
			continue
		blk := Trim(blocks[A_Index], " `n`t")
		if (blk = "" || blk = "已腐化" || blk = "Corrupted" || blk = "未鑑定" || blk = "Unidentified")
			continue
		if InStr(blk, "Note:") || InStr(blk, "分裂之物") || InStr(blk, "Synthesised")
			continue
		isImplicitBlk := InStr(blk, "(implicit)")
		explicitLinesInBlk := 0
		Loop, Parse, blk, `n
		{
			ln := Trim(A_LoopField)
			if (ln = "")
				continue
			if (SubStr(ln, 1, 1) = "{")
			{
				if (!isImplicitBlk && RegExMatch(ln, "i)^\{(Prefix|Suffix|前綴|後綴)"))
					advModCount++
				continue
			}
			modBuf .= (modBuf != "" ? "`n" : "") . ln
			if (!isImplicitBlk)
				explicitLinesInBlk++
		}
		if (!isImplicitBlk && explicitLinesInBlk > 0)
			lastExplicitCount := explicitLinesInBlk
	}
	info.modText := modBuf
	info.modLineCount := lastExplicitCount
	info.modCount := (advModCount > 0) ? advModCount : lastExplicitCount
	return info
}

EvalNumericCondition(val, op, threshold)
{
	v := val + 0.0
	t := threshold + 0.0
	if (op = ">")
		return (v > t)
	if (op = ">=")
		return (v >= t)
	if (op = "<")
		return (v < t)
	if (op = "<=")
		return (v <= t)
	if (op = "=" || op = "==")
		return (v = t)
	return false
}

CraftLineMatchesBase(text, pat)
{
	if (pat = "")
		return false
	if (SubStr(pat, 1, 3) = "re:")
	{
		rePat := SubStr(pat, 4)
		try {
			return (RegExMatch(text, "im)" . rePat) > 0)
		} catch {
			return false
		}
	}
	if InStr(text, pat)
		return true
	if (InStr(pat, ".*") || InStr(pat, "|") || InStr(pat, "\d"))
	{
		try {
			return (RegExMatch(text, "im)" . pat) > 0)
		}
	}
	return false
}

CraftKeywordMatch(text, pattern)
{
	pat := Trim(pattern)
	if (pat = "")
		return false

	; 檢查行尾是否帶有括號數字比較條件，如：攻擊速度提高 (>10) 或 最大生命 (>=90)
	if RegExMatch(pat, "\s*(?:\(|（)\s*(>=|<=|==|>|<|=)\s*(-?\d+(?:\.\d+)?)\s*(?:\)|）)\s*$", m)
	{
		condPos := RegExMatch(pat, "\s*(?:\(|（)\s*(>=|<=|==|>|<|=)\s*(-?\d+(?:\.\d+)?)\s*(?:\)|）)\s*$")
		basePat := Trim(SubStr(pat, 1, condPos - 1))
		op := m1
		threshold := m2
		if (basePat = "")
			return false

		Loop, Parse, text, `n, `r
		{
			line := Trim(A_LoopField)
			if (line = "" || !CraftLineMatchesBase(line, basePat))
				continue

			lineClean := InStr(line, basePat) ? StrReplace(line, basePat, " ") : line
			if !RegExMatch(lineClean, "-?\d+(?:\.\d+)?")
				lineClean := line

			pos := 1
			while (pos := RegExMatch(lineClean, "(-?\d+(?:\.\d+)?)", nm, pos))
			{
				if EvalNumericCondition(nm1, op, threshold)
					return true
				pos += StrLen(nm1)
			}
		}
		return false
	}

	return CraftLineMatchesBase(text, pat)
}

MatchCraftRules(modText, whitelistStr, blacklistStr, matchLogic)
{
	; 1. 黑名單優先過濾（命中任一不要的詞立即重洗）
	Loop, Parse, blacklistStr, `n, `r
	{
		kw := Trim(A_LoopField)
		if (kw != "" && CraftKeywordMatch(modText, kw))
			return "BLACKLIST"
	}

	; 2. 白名單檢查（若白名單留空，代表僅需無黑名單即可停手）
	wlItems := []
	Loop, Parse, whitelistStr, `n, `r
	{
		kw := Trim(A_LoopField)
		if (kw != "")
			wlItems.Push(kw)
	}
	if (wlItems.Length() = 0)
		return "MATCH"

	if (matchLogic = "AND")
	{
		for _, kw in wlItems
		{
			if !CraftKeywordMatch(modText, kw)
				return "NOMATCH"
		}
		return "MATCH"
	}
	else
	{
		for _, kw in wlItems
		{
			if CraftKeywordMatch(modText, kw)
				return "MATCH"
		}
		return "NOMATCH"
	}
}

IsAutoCraftStopped()
{
	global autoCraftStopRequested
	return (autoCraftStopRequested || GetKeyState("Esc", "P") || GetKeyState("Esc") || !IsPoE1Active())
}

CraftSingleTarget(tgtX, tgtY, mapOnly := false)
{
	global autoCraftStopRequested
	global 洗詞模式, 洗詞匹配邏輯, 洗詞使用瓦爾, 洗詞最大次數, 洗詞延遲, 洗詞白名單, 洗詞黑名單
	global 洗詞改造_X, 洗詞改造_Y, 洗詞增幅_X, 洗詞增幅_Y, 洗詞蛻變_X, 洗詞蛻變_Y
	global 洗詞重鑄_X, 洗詞重鑄_Y, 洗詞混沌_X, 洗詞混沌_Y, 洗詞點金_X, 洗詞點金_Y, 洗詞瓦爾_X, 洗詞瓦爾_Y

	maxTries := (洗詞最大次數 > 0) ? 洗詞最大次數 : 200
	delayMs := (洗詞延遲 >= 40) ? 洗詞延遲 : 120
	useVaal := (洗詞使用瓦爾 = 1 || 洗詞使用瓦爾 = "1" || 洗詞使用瓦爾 = "true")
	tries := 0
	unchangedCount := 0
	prevText := ""
	lastAction := ""
	augAttemptedOnCurrent := false

	Loop
	{
		if (IsAutoCraftStopped())
		{
			ToolTip("🛑 已手動或切換視窗停止自動洗詞。")
			return "STOP"
		}

		itemText := CopyPoEItemAt(tgtX, tgtY)
		if (IsAutoCraftStopped())
		{
			ToolTip("🛑 已手動或切換視窗停止自動洗詞。")
			return "STOP"
		}
		if (itemText = "")
		{
			if (mapOnly && tries = 0)
				return "SKIP"
			unchangedCount++
			if (unchangedCount >= 2)
			{
				ToolTip("⚠️ 無法讀取目標物品資訊，已安全停止。")
				return "STOP"
			}
			Sleep, 80
			continue
		}

		info := ParsePoEItemInfo(itemText)
		if (info.rarity = "" || info.rarity = "Unique" || info.isCorrupted || info.isUnidentified)
		{
			if (mapOnly)
				return "SKIP"
			ToolTip("⚠️ 目標為傳奇/未鑑定/已汙染/已腐化/無法洗詞物品，已安全停止。")
			return "STOP"
		}
		if (mapOnly && !info.isMap)
			return "SKIP"

		if (tries > 0 && itemText = prevText)
		{
			; 若上一動作為增幅石且文字未變，表示該裝備為複合詞綴其實已滿 2 詞，改標記為已增幅不誤判為斷水
			if (lastAction = "AUG" && !augAttemptedOnCurrent)
			{
				augAttemptedOnCurrent := true
			}
			else if (lastAction != "AUG")
			{
				unchangedCount++
				if (unchangedCount >= 2)
				{
					ToolTip("⚠️ 物品詞綴連續未變化（通貨可能已用盡），已安全停止。")
					return "STOP"
				}
			}
		}
		else
		{
			unchangedCount := 0
		}
		prevText := itemText

		if (tries >= maxTries)
		{
			ToolTip("⚠️ 已達最大洗詞次數上限 (" . maxTries . ")，已安全停止。")
			return "STOP"
		}

		if (洗詞模式 = "改造石模式" || 洗詞模式 = "改造+增幅模式")
		{
			if (info.rarity = "Rare")
			{
				UseCurrencyOnTarget(洗詞重鑄_X, 洗詞重鑄_Y, tgtX, tgtY, delayMs)
				lastAction := "SCOUR"
				augAttemptedOnCurrent := false
				tries++
				continue
			}
			if (info.rarity = "Normal")
			{
				UseCurrencyOnTarget(洗詞蛻變_X, 洗詞蛻變_Y, tgtX, tgtY, delayMs)
				lastAction := "TRANS"
				augAttemptedOnCurrent := false
				tries++
				continue
			}
			ruleRes := MatchCraftRules(info.modText, 洗詞白名單, 洗詞黑名單, 洗詞匹配邏輯)
			if (ruleRes = "BLACKLIST")
			{
				UseCurrencyOnTarget(洗詞改造_X, 洗詞改造_Y, tgtX, tgtY, delayMs)
				lastAction := "ALT"
				augAttemptedOnCurrent := false
				tries++
				continue
			}

			if (洗詞模式 = "改造石模式")
			{
				if (ruleRes = "MATCH")
				{
					if (info.modCount < 2 && !augAttemptedOnCurrent)
					{
						UseCurrencyOnTarget(洗詞增幅_X, 洗詞增幅_Y, tgtX, tgtY, delayMs)
						lastAction := "AUG"
						augAttemptedOnCurrent := true
						tries++
						continue
					}
					if (useVaal)
						UseCurrencyOnTarget(洗詞瓦爾_X, 洗詞瓦爾_Y, tgtX, tgtY, delayMs)
					return "SUCCESS"
				}
				UseCurrencyOnTarget(洗詞改造_X, 洗詞改造_Y, tgtX, tgtY, delayMs)
				lastAction := "ALT"
				augAttemptedOnCurrent := false
				tries++
				continue
			}
			else
			{
				if (info.modCount < 2 && !augAttemptedOnCurrent)
				{
					UseCurrencyOnTarget(洗詞增幅_X, 洗詞增幅_Y, tgtX, tgtY, delayMs)
					lastAction := "AUG"
					augAttemptedOnCurrent := true
					tries++
					continue
				}
				if (ruleRes = "MATCH")
				{
					if (useVaal)
						UseCurrencyOnTarget(洗詞瓦爾_X, 洗詞瓦爾_Y, tgtX, tgtY, delayMs)
					return "SUCCESS"
				}
				UseCurrencyOnTarget(洗詞改造_X, 洗詞改造_Y, tgtX, tgtY, delayMs)
				lastAction := "ALT"
				augAttemptedOnCurrent := false
				tries++
				continue
			}
		}
		else if (洗詞模式 = "點金+重鑄模式")
		{
			if (info.rarity = "Normal")
			{
				UseCurrencyOnTarget(洗詞點金_X, 洗詞點金_Y, tgtX, tgtY, delayMs)
				tries++
				continue
			}
			if (info.rarity = "Magic")
			{
				UseCurrencyOnTarget(洗詞重鑄_X, 洗詞重鑄_Y, tgtX, tgtY, delayMs)
				tries++
				continue
			}
			ruleRes := MatchCraftRules(info.modText, 洗詞白名單, 洗詞黑名單, 洗詞匹配邏輯)
			if (ruleRes = "MATCH")
			{
				if (useVaal)
					UseCurrencyOnTarget(洗詞瓦爾_X, 洗詞瓦爾_Y, tgtX, tgtY, delayMs)
				return "SUCCESS"
			}
			UseCurrencyOnTarget(洗詞重鑄_X, 洗詞重鑄_Y, tgtX, tgtY, delayMs)
			tries++
			continue
		}
		else if (洗詞模式 = "混沌石模式")
		{
			if (info.rarity = "Normal")
			{
				if (洗詞點金_X > 0 && 洗詞點金_Y > 0)
				{
					UseCurrencyOnTarget(洗詞點金_X, 洗詞點金_Y, tgtX, tgtY, delayMs)
					tries++
					continue
				}
				ToolTip("⚠️ 混沌石模式遇白裝需設定【點金石】座標或手動先點金。")
				return "STOP"
			}
			if (info.rarity = "Magic")
			{
				if (洗詞重鑄_X > 0 && 洗詞點金_X > 0)
				{
					UseCurrencyOnTarget(洗詞重鑄_X, 洗詞重鑄_Y, tgtX, tgtY, delayMs)
					tries++
					continue
				}
				ToolTip("⚠️ 混沌石模式遇藍裝需設定【重鑄石】與【點金石】座標。")
				return "STOP"
			}
			ruleRes := MatchCraftRules(info.modText, 洗詞白名單, 洗詞黑名單, 洗詞匹配邏輯)
			if (ruleRes = "MATCH")
			{
				if (useVaal)
					UseCurrencyOnTarget(洗詞瓦爾_X, 洗詞瓦爾_Y, tgtX, tgtY, delayMs)
				return "SUCCESS"
			}
			UseCurrencyOnTarget(洗詞混沌_X, 洗詞混沌_Y, tgtX, tgtY, delayMs)
			tries++
			continue
		}
	}
}

