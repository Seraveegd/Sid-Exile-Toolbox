#NoEnv
#NoTrayIcon
#SingleInstance force
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

global neutron := new NeutronWindow()

; 為解決編譯後若檔案路徑包含中文導致 res:// 協定無法載入網頁的問題，
; 改為直接載入由 FileInstall 解壓縮至本地目錄的 ui\ui.html
NeutronLoadLocal(neutron, "ui\ui.html")

NeutronLoadLocal(neutronInstance, fileName) {
	url := A_ScriptDir "/" fileName
	neutronInstance.wb.Navigate(url)
	while neutronInstance.wb.readyState < 3
		Sleep, 50
	neutronInstance.wnd.neutron := neutronInstance
	neutronInstance.wnd.ahk := new neutronInstance.Dispatch(neutronInstance)
	while neutronInstance.wb.readyState < 4
		Sleep, 50
}

; === 腳本最上方（自動執行段） ===
GroupAdd, DualWins, Path of Exile
GroupAdd, DualWins, Path of Exile 2
GroupAdd, DualWins, % "ahk_id " . neutron.hWnd

;[讀取記錄區]------------------------------------------------------------------------------------------------------
使用者類型 = 已開源

gosub,讀取F7背包定位內容
gosub,背包運算作業
gosub,讀取F1按鍵模式
gosub,讀取F3按鍵模式
gosub,讀取倉庫頁數據
gosub,讀取背包初始顏色
gosub,讀取回復模式
gosub,讀取自動回復內容
gosub,讀取快速組隊提醒功能
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
vMouseMoveDelaySpeedMin := 35 
vMouseMoveDelaySpeedMax := 45 
vClickDelaySpeed := 40
vHagglingScrollSpeedMin := 20 
vHagglingScrollSpeedMax := 30
vFirstMin := 14
vFirstMax := 16
vLastMin := 5
vLastMax := 8
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
Loop,3
{
	if 循環技能%A_Index% = ERROR
	{
		循環技能%A_Index% = T
	}
	if 循環技能時間%A_Index% = ERROR
	{
		循環技能時間%A_Index% = Off
	}
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
if 引爆延遲1 = ERROR
{
	引爆延遲1 = 300
}
if 引爆延遲2 = ERROR
{
	引爆延遲2 = 300
}
;------------------------------------------------------------------------------------------------------

gosub,起始盒子

;[菜單設置區]------------------------------------------------------------------------------------------------------

Menu, MyMenu, Add, ★工具介紹★, 菜單_工具介紹
Menu, MyMenu, Add
Menu, MyMenu, Add, 藥劑觸發設置, 菜單_藥劑觸發
Menu, MyMenu, Add, 技能連段設置, 菜單_技能連段
Menu, MyMenu, Add, 循環技能設置, 菜單_循環技能
Menu, MyMenu, Add, 快搜倉庫設置, 菜單_快搜倉庫
Menu, MyMenu, Add
Menu, MyMenu, Add, 滑鼠連點設置, 菜單_滑鼠連點
Menu, MyMenu, Add, 自動引爆地雷設置, 菜單_自動地雷
Menu, MyMenu, Add, 外部連結與網站, 菜單_外部連結
return

呼叫菜單:
	OpenUISection("intro")
return

菜單_工具介紹:
	OpenUISection("intro")
return
菜單_藥劑觸發:
	OpenUISection("flask")
return
菜單_技能連段:
	OpenUISection("combo")
return
菜單_循環技能:
	OpenUISection("loop")
return
菜單_快搜倉庫:
	OpenUISection("stash")
return
菜單_滑鼠連點:
	OpenUISection("clicker")
return
菜單_自動地雷:
	OpenUISection("mine")
return
菜單_外部連結:
	OpenUISection("links")
return

OpenUISection(section) {
	try {
		neutron.wnd.syncDataFromAHK()
		neutron.wnd.showSection(section)
	}
	neutron.Show("w960 h680 Center")
}

;[熱鍵設置]------------------------------------------------------------------------------------------------------

F9::
	Suspend
	ToolTip("工具暫停中，回復原始鍵盤功能，[F9]恢復運作。")
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
	IfWinActive,rchin-poe-trade
		WinActivate ,Path of Exile
	openI := 0
	Toolbutton := 0
	ifwinactive, Path of Exile
		ToolTip("(ESC)，關閉面板，返回遊戲模式")
return

GetDriveTailSerial()
{
	for objItem in ComObjGet("winmgmts:\\.\root\cimv2").ExecQuery("Select * from Win32_PhysicalMedia")
	{
		serial := objItem.SerialNumber
		if (serial != "" && !InStr(serial, "00000000"))
		{
			clean := RegExReplace(serial, "[^a-zA-Z0-9]")
			if (StrLen(clean) >= 12)
				return SubStr(clean, -11)
			else
				return clean
		}
	}
	return "UNKNOWN"
}

#ifwinactive, ahk_group DualWins

	HK_WinZ_Label:
		gosub,呼叫菜單
	return

	;[提示窗口基礎設定]------------------------------------------------------------------------------------------------------

	ToolTip(label)
	{
		ToolTip, %label%, 0, 40
		SetTimer, RemoveToolTip, 3000
		WinActivate ,Path of Exile
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

	提醒停止按鍵:
		ToolTip("提醒:長按[ ~ ]停止運作")
		if(GetKeyState("~","P"))
			settimer,提醒停止按鍵,off
	return

	;---------------------------------------------------------

	彈跳網頁:
		run,https://sid-1996.github.io/sid-automation-lab/index.html,,UseErrorLevel
	return

	暫停讀秒循環喝水:
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
		loop,9
		{
			IniRead,顏色%A_Index%_X,sidtooldata.ini,顏色座標,顏色%A_Index%_X
			IniRead,顏色%A_Index%_Y,sidtooldata.ini,顏色座標,顏色%A_Index%_Y
			IniRead,顏色%A_Index%_C,sidtooldata.ini,顏色座標,顏色%A_Index%_C
		}
	return

	;[藥劑防呆區]------------------------------------------------------------------------------------------

	使用藥劑1:
		if 藥劑持續時間1 = off
			send {1}
		else if 防呆藥水鎖1 = 無
		{
			send {1}
			防呆藥水鎖1 = 有
			settimer,防呆藥水1計時器,%藥劑持續時間1%
		}
	return

	使用藥劑2:
		if 藥劑持續時間2 = off
			send {2}
		else if 防呆藥水鎖2 = 無
		{
			send {2}
			防呆藥水鎖2 = 有
			settimer,防呆藥水2計時器,%藥劑持續時間2%
		}
	return

	使用藥劑3:
		if 藥劑持續時間3 = off
			send {3}
		else if 防呆藥水鎖3 = 無
		{
			send {3}
			防呆藥水鎖3 = 有
			settimer,防呆藥水3計時器,%藥劑持續時間3%
		}
	return

	使用藥劑4:
		if 藥劑持續時間4 = off
			send {4}
		else if 防呆藥水鎖4 = 無
		{
			send {4}
			防呆藥水鎖4 = 有
			settimer,防呆藥水4計時器,%藥劑持續時間4%
		}
	return

	使用藥劑5:
		if 藥劑持續時間5 = off
			send {5}
		else if 防呆藥水鎖5 = 無
		{
			send {5}
			防呆藥水鎖5 = 有
			settimer,防呆藥水5計時器,%藥劑持續時間5%
		}
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

	~*Q::
		if Toolbutton = 0
		{
			if (Autodrinkbutton = "1" and 藥劑觸發模式 = "使用技能時喝水" and 主要技能 = "Q")
			{
				if 使用技能時觸發的藥劑 contains 1
					gosub,使用藥劑1
				if 使用技能時觸發的藥劑 contains 2
					gosub,使用藥劑2
				if 使用技能時觸發的藥劑 contains 3
					gosub,使用藥劑3
				if 使用技能時觸發的藥劑 contains 4
					gosub,使用藥劑4
				if 使用技能時觸發的藥劑 contains 5
					gosub,使用藥劑5
			}
			if (Autodrinkbutton = "1" and 技1 = "Q" and 技能連段功能 = "開啟")
			{
				gosub,技能連段
			}
			if 地雷模式 = 開啟
			{
				if 地雷按鍵 = Q
				{
					sleep %引爆延遲1%
					send {d}
					if 地雷杖模式 = 開啟
						send {d down}
				}
				if 煙霧地雷 = Q
				{
					send {d up}
					sleep %引爆延遲2%
					send {d}
				}
			}
		}
	return

	~*W::
		if Toolbutton = 0
		{
			if (Autodrinkbutton = "1" and 藥劑觸發模式 = "使用技能時喝水" and 主要技能 = "W")
			{
				if 使用技能時觸發的藥劑 contains 1
					gosub,使用藥劑1
				if 使用技能時觸發的藥劑 contains 2
					gosub,使用藥劑2
				if 使用技能時觸發的藥劑 contains 3
					gosub,使用藥劑3
				if 使用技能時觸發的藥劑 contains 4
					gosub,使用藥劑4
				if 使用技能時觸發的藥劑 contains 5
					gosub,使用藥劑5
			}
			if (Autodrinkbutton = "1" and 技1 = "W" and 技能連段功能 = "開啟")
			{
				gosub,技能連段
			}
			if 地雷模式 = 開啟
			{
				if 地雷按鍵 = W
				{
					sleep %引爆延遲1%
					send {d}
					if 地雷杖模式 = 開啟
						send {d down}
				}
				if 煙霧地雷 = W
				{
					send {d up}
					sleep %引爆延遲2%
					send {d}
				}
			}
		}
	return

	~*E::
		if Toolbutton = 0
		{
			if (Autodrinkbutton = "1" and 藥劑觸發模式 = "使用技能時喝水" and 主要技能 = "E")
			{
				if 使用技能時觸發的藥劑 contains 1
					gosub,使用藥劑1
				if 使用技能時觸發的藥劑 contains 2
					gosub,使用藥劑2
				if 使用技能時觸發的藥劑 contains 3
					gosub,使用藥劑3
				if 使用技能時觸發的藥劑 contains 4
					gosub,使用藥劑4
				if 使用技能時觸發的藥劑 contains 5
					gosub,使用藥劑5
			}
			if (Autodrinkbutton = "1" and 技1 = "E" and 技能連段功能 = "開啟")
			{
				gosub,技能連段
			}
			if 地雷模式 = 開啟
			{
				if 地雷按鍵 = E
				{
					sleep %引爆延遲1%
					send {d}
					if 地雷杖模式 = 開啟
						send {d down}
				}
				if 煙霧地雷 = E
				{
					send {d up}
					sleep %引爆延遲1%
					send {d}
				}
			}
		}
	return

	~*R::
		if Toolbutton = 0
		{
			if (Autodrinkbutton = "1" and 藥劑觸發模式 = "使用技能時喝水" and 主要技能 = "R")
			{
				if 使用技能時觸發的藥劑 contains 1
					gosub,使用藥劑1
				if 使用技能時觸發的藥劑 contains 2
					gosub,使用藥劑2
				if 使用技能時觸發的藥劑 contains 3
					gosub,使用藥劑3
				if 使用技能時觸發的藥劑 contains 4
					gosub,使用藥劑4
				if 使用技能時觸發的藥劑 contains 5
					gosub,使用藥劑5
			}
			if (Autodrinkbutton = "1" and 技1 = "R" and 技能連段功能 = "開啟")
			{
				gosub,技能連段
			}
			if 地雷模式 = 開啟
			{
				if 地雷按鍵 = R
				{
					sleep %引爆延遲1%
					send {d}
					if 地雷杖模式 = 開啟
						send {d down}
				}
				if 煙霧地雷 = R
				{
					send {d up}
					sleep %引爆延遲1%
					send {d}
				}
			}
		}
	return

	~*T::
		if Toolbutton = 0
		{
			if (Autodrinkbutton = "1" and 藥劑觸發模式 = "使用技能時喝水" and 主要技能 = "T")
			{
				if 使用技能時觸發的藥劑 contains 1
					gosub,使用藥劑1
				if 使用技能時觸發的藥劑 contains 2
					gosub,使用藥劑2
				if 使用技能時觸發的藥劑 contains 3
					gosub,使用藥劑3
				if 使用技能時觸發的藥劑 contains 4
					gosub,使用藥劑4
				if 使用技能時觸發的藥劑 contains 5
					gosub,使用藥劑5
			}
			if (Autodrinkbutton = "1" and 技1 = "T" and 技能連段功能 = "開啟")
			{
				gosub,技能連段
			}
			if 地雷模式 = 開啟
			{
				if 地雷按鍵 = T
				{
					sleep %引爆延遲1%
					send {d}
					if 地雷杖模式 = 開啟
						send {d down}
				}
				if 煙霧地雷 = T
				{
					send {d up}
					sleep %引爆延遲1%
					send {d}
				}
			}
		}
	return

	;[技能連段指令]-------------------------------------------------------------------------------------------------

	技能連段:
		if 技1 in Q,W,E,R,T
		{
			if 技2 in Q,W,E,R,T
			{
				sleep %技1延遲%
				Send {%技2%}
			}
			if 技3 in Q,W,E,R,T
			{
				sleep %技2延遲%
				Send {%技3%}
			}
			sleep 100
		}
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

	快捷切換倉庫頁設置:
		OpenUISection("stash")
	return

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
		計算值 :=  abs(當前倉庫頁 - 搜索到的倉庫頁)

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
		搜索到的倉庫頁 := 未鑑定稀有頭盔
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 未鑑定稀有頭盔
	return

	前往未鑑定稀有衣服:
		搜索到的倉庫頁 := 未鑑定稀有衣服
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 未鑑定稀有衣服
	return

	前往未鑑定稀有腰帶:
		搜索到的倉庫頁 := 未鑑定稀有腰帶
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 未鑑定稀有腰帶
	return

	前往未鑑定稀有手套:
		搜索到的倉庫頁 := 未鑑定稀有手套
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 未鑑定稀有手套
	return

	前往未鑑定稀有鞋子:
		搜索到的倉庫頁 := 未鑑定稀有鞋子
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 未鑑定稀有鞋子
	return

	前往未鑑定稀有飾品:
		搜索到的倉庫頁 := 未鑑定稀有飾品
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 未鑑定稀有飾品
	return

	前往未鑑定稀有武器:
		搜索到的倉庫頁 := 未鑑定稀有武器
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 未鑑定稀有武器
	return

	二次判斷傳奇戒指:
		IfInString,暫存複製內容,稀有度: 傳奇	,gosub,前往傳奇戒
			return

	二次判斷勢力裝:
		if 暫存複製內容 contains 稀有度: 稀有,稀有度: 普通,稀有度: 魔法
			gosub,前往勢力裝頁
	return

	前往星團珠:
		搜索到的倉庫頁 := 星團珠
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 星團珠
	return

	前往普通珠:
		搜索到的倉庫頁 := 普通珠
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 普通珠
	return

	前往深淵珠:
		搜索到的倉庫頁 := 深淵珠
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 深淵珠
	return

	前往培育器:
		搜索到的倉庫頁 := 培育器
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 培育器
	return

	前往勢力裝頁:
		搜索到的倉庫頁 := 勢力裝頁
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 勢力裝頁
	return

	前往傳奇裝:
		搜索到的倉庫頁 := 傳奇裝
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 傳奇裝
		快搜配對 = 需按Shift
	return

	前往附魔裝:
		搜索到的倉庫頁 := 附魔裝
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 附魔裝
		快搜配對 = 需按Shift
	return

	前往劫盜裝:
		搜索到的倉庫頁 := 劫盜裝
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 劫盜裝
	return

	前往傳奇戒:
		{
			搜索到的倉庫頁 := 傳奇戒
			gosub,倉庫頁計算
			倉庫匹配狀態 = 成功
			當前倉庫頁 := 傳奇戒
			快搜配對 = 需按Shift
			return
		}
	return

	前往特殊地圖:
		搜索到的倉庫頁 := 特殊地圖
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 特殊地圖
		快搜配對 = 需按Shift
	return

	前往裂痕戒指:
		搜索到的倉庫頁 := 裂痕戒指
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 裂痕戒指
	return

	前往可堆疊通貨:
		搜索到的倉庫頁 := 0
		gosub,倉庫頁計算
		倉庫匹配狀態 = 成功
		當前倉庫頁 := 0
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
			ToolTip("觸發一鍵喝水，打字誤觸建議您使用[F9]暫停工具。")
			if (顏色5_X != "error" && 顏色5_Y != "error" && 顏色5_C != "error")
			{
				PixelGetColor, dialogCheck1, %顏色5_X%, %顏色5_Y%, Fast RGB
				if (dialogCheck1 = %顏色5_C%)
				{
					Toolbutton := 1
					ToolTip("偵測到對話框，暫停 Space 喝水，切換為文字模式")
					SetTimer,偵測對話框1,off
					SetTimer,偵測對話框2,off
					return
				}
			}
			if (顏色6_X != "error" && 顏色6_Y != "error" && 顏色6_C != "error")
			{
				PixelGetColor, dialogCheck2, %顏色6_X%, %顏色6_Y%, Fast RGB
				if (dialogCheck2 = %顏色6_C%)
				{
					Toolbutton := 1
					ToolTip("偵測到對話框，暫停 Space 喝水，切換為文字模式")
					SetTimer,偵測對話框1,off
					SetTimer,偵測對話框2,off
					return
				}
			}
			if 一鍵喝水時觸發的藥劑 = error
			{
				msgbox,16,錯誤,尚未設定(Space)一鍵喝水所需藥劑! (``) => 藥劑觸發設置。
				OpenUISection("flask")
				return
			}
			else if	(Autodrinkbutton = "0" or 藥劑觸發模式 = "無")
			{
				send %一鍵喝水時觸發的藥劑%
			}
			if (Autodrinkbutton = "1" and 藥劑觸發模式 = "讀秒循環喝水")
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
			if (Autodrinkbutton = "1" and 藥劑觸發模式 = "純藥劑防呆")
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
			if (Autodrinkbutton = "1" and 藥劑觸發模式 = "使用技能時喝水")
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
		if Toolbutton = 0
			send {1}
	return

	藥劑2:
		if Toolbutton = 0
			send {2}
	return

	藥劑3:
		if Toolbutton = 0
			send {3}
	return

	藥劑4:
		if Toolbutton = 0
			send {4}
	return

	藥劑5:
		if Toolbutton = 0
			send {5}
	return

	;[Enter偵測對話框區(熱鍵)]------------------------------------------------------------------------------------------

	~enter::
		if (顏色5_X = "error" or 顏色5_Y = "error" or 顏色6_X = "error" or 顏色6_Y = "error")
		{
			if Enter除錯提醒次數 = 0
			{
				msgbox,16,錯誤,尚未設定偵測對話框(1)&(2)黑幕!非常重要，不然打字會瞎雞巴亂按。`r若你第一次看到此視窗，按下確認後將跳轉教學圖片網址。`r此彈跳網頁只會顯示一次，請勿在未設置成功前關閉教學圖片。`r確定後，請依圖片，將滑鼠指定座標，再按[Win + C]，輸入代號(5)或(6)!
				run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/editor/1847905122_2.png,,UseErrorLevel
				Enter除錯提醒次數 := 1
			}
		}
		else
		{
(Toolbutton = 0 ? (Toolbutton := 1,ToolTip("已切換為文字模式")) : (Toolbutton := 0,ToolTip("已切換為遊戲模式")))
if Toolbutton = 0
{
偵測對話框計數 := 0
settimer,偵測對話框1,25
settimer,偵測對話框2,25
}
if Toolbutton = 1
		{
		gosub,暫停讀秒循環喝水
		}
}
return

偵測對話框1:
偵測對話框計數++
if (偵測對話框計數 >= 20)
{
	settimer,偵測對話框1,off
	settimer,偵測對話框2,off
	偵測對話框計數 := 0
	return
}
if (顏色5_X = "error" or 顏色5_Y = "error")
{
settimer,偵測對話框1,off
settimer,偵測對話框2,off
msgbox,16,錯誤,提醒，你是否忘記設置偵測對話框了呢?`r首次使用enter可彈跳教學圖片。`r抓取對話框非常重要，不然打字會瞎雞巴亂按熱鍵。
}
else
{
	PixelGetColor,對話框1, %顏色5_X%, %顏色5_Y%, Fast RGB
	if 對話框1 = %顏色5_C%
	{
	Toolbutton = 1
	ToolTip("偵測到對話框1，變更為文字模式")
	gosub,暫停讀秒循環喝水
	settimer,偵測對話框1,off
	settimer,偵測對話框2,off
	}
}
return

偵測對話框2:
if (顏色6_X = "error" or 顏色6_Y = "error")
{
settimer,偵測對話框1,off
settimer,偵測對話框2,off
msgbox,16,錯誤,提醒，你是否忘記設置偵測對話框了呢?`r首次使用enter可彈跳教學圖片。`r抓取對話框非常重要，不然打字會瞎雞巴亂按熱鍵。
}
else
{
	PixelGetColor,對話框2, %顏色6_X%, %顏色6_Y%, Fast RGB
	if 對話框2 = %顏色6_C%
	{
	Toolbutton = 1
	ToolTip("偵測到對話框2，變更為文字模式")
	gosub,暫停讀秒循環喝水
	settimer,偵測對話框1,off
	settimer,偵測對話框2,off
	}
}
return

;[Ctrl + F 強調物品區(熱鍵)]--------------------------------------------------------------------------------------------

~*<^F::
if Toolbutton = 0
Toolbutton := 1,ToolTip("偵測到使用Ctrl + F ,已切換為文字模式")
return

;[滑鼠區(熱鍵)]---------------------------------------------------------------------------------------------------------

~*LButton::
If 開始時間
    return
開始時間 := A_TickCount
Hotkey, LButton up, 左鍵彈起標籤, On
return

左鍵彈起標籤:
Hotkey, LButton up, 左鍵彈起標籤, Off
時間長度 := A_TickCount - 開始時間
if (時間長度 < 100)
{

}
else if (時間長度 >= 100)
{
	if Toolbutton = 1
	Toolbutton := 0,ToolTip("偵測左鍵有長時間的按壓彈起,因此切換為遊戲模式")
}
開始時間 := ""
return

~<!<^LButton::
if Toolbutton = 0
Toolbutton := 1,ToolTip("偵測到物品貼上,已切換為文字模式")
return

;[滑鼠連點區(熱鍵)]------------------------------------------------------------------------------------------------------

~*^LButton::
if 連點模式 = [Ctrl + 左鍵]
{

Sleep 100
GetKeyState, stateShift, Shift
GetKeyState, stateCtrl , Ctrl
if (stateCtrl = "D" or stateShift = "D")
 {
	Loop
	{
		If ( clickStop = true )
		{
			clickStop := false
			return
		}
		Click
		sleep %滑鼠連點速度%
	}
 }

}
return

~*^LButton UP::
if 連點模式 = [Ctrl + 左鍵]
clickStop := true
return

~*MButton::
if 連點模式 = 滑鼠滾輪按壓
{
	Loop
	{
	If ( clickStop = true )
		{
		clickStop := false
		return
		}
		Else
		{
		 Click
		 sleep %滑鼠連點速度%
		}
	}
}
return

~*MButton Up::
if 連點模式 = 滑鼠滾輪按壓
clickStop := true
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

掃描開始左上2_X := % 對方背包左上_X
掃描開始左上2_Y := % 對方背包左上_Y
掃描開始右下2_X := % 對方背包右下_X
掃描開始右下2_Y := % 對方背包右下_Y
掃描水平數量2 := 12
掃描垂直數量2 := 5
背包每格寬2 := floor((掃描開始右下2_X - 掃描開始左上2_X) / 掃描水平數量2)
背包每格高2 := floor((掃描開始右下2_Y - 掃描開始左上2_Y) / 掃描垂直數量2)
return

;[Ins循環技能區(熱鍵)]------------------------------------------------------------------------------------------

HK_Insert_Label:
(StopUser = 0 ? (StopUser := 1,ToolTip("循環技能已開啟")) : (StopUser := 0,ToolTip("循環技能已關閉")))
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
  Gosub,關閉循環技能
  return
  }
return

循環技能1:
IfWinActive,Path of Exile
{
if Toolbutton = 0
 {
if 循環技能時間1 = OFF
{
 Return
}
if not(GetKeyState("Ctrl","P"))
if not(GetKeyState("Shift","P"))
send %循環技能1%
send {BS}
 }
}
Return

循環技能2:
IfWinActive,Path of Exile
{
if Toolbutton = 0
 {
if 循環技能時間2 = OFF
{
 Return
}
if not(GetKeyState("Ctrl","P"))
if not(GetKeyState("Shift","P"))
send %循環技能2%
send {BS}
 }
}
Return

循環技能3:
IfWinActive,Path of Exile
{
if Toolbutton = 0
 {
if 循環技能時間3 = OFF
{
 Return
}
if not(GetKeyState("Ctrl","P"))
if not(GetKeyState("Shift","P"))
send %循環技能3%
send {BS}
 }
}
Return

關閉循環技能:
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
	WinActivate ,Path of Exile
	WinWait ,Path of Exile
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
	WinActivate ,Path of Exile
	WinWait ,Path of Exile
	Clipboard = /invite %移除後完好的ID%
	send {enter}
	Send ^{V}
	sleep 1
	Send {enter}
	}
   else
	{
	WinActivate ,Path of Exile
	WinWait ,Path of Exile
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
移除後完好的ID := Trim(對方ID, OmitChars := "@")
return

HK_WinEnd_ModeLabel:
	if (快速組隊提醒 = "開啟")
		快速組隊提醒 := "關閉"
	else
		快速組隊提醒 := "開啟"
	IniWrite, % 快速組隊提醒, sidtooldata.ini, 按鍵模式切換, 快速組隊提醒
	ToolTip("快速組隊提醒功能已變更為: " . 快速組隊提醒)
Return

讀取快速組隊提醒功能:
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
	cleanF1Key := CleanKeyName(快捷鍵_F1)
	send {%cleanF1Key%}
	}
}
return

HK_WinF1_ModeLabel:
	if (F1模式 = "返角模式")
		F1模式 := "原始鍵盤模式"
	else
		F1模式 := "返角模式"
	IniWrite, % F1模式, sidtooldata.ini, 按鍵模式切換, F1模式
	ToolTip("F1按鍵已變更為: " . F1模式)
return

;[F1返回角色(指令)]------------------------------------------------------------------------------------------------------

返角:
Critical
	gosub,暫停讀秒循環喝水
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
        Send {Enter}
return



讀取F1按鍵模式:
 Iniread, F1模式, sidtooldata.ini, 按鍵模式切換, F1模式
Return

;[F2回復模式(熱鍵)]------------------------------------------------------------------------------------------------------

F2::
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
	  Gosub,關閉循環技能
	  ToolTip("已關閉[Ins]技能循環，進入暫離狀態。")
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
		回復模式 := "勿擾"
	else if (回復模式 = "勿擾")
		回復模式 := "自動回復"
	else
		回復模式 := "暫離"
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
		自動回復內容 := 輸入內容
		iniWrite,% 自動回復內容, sidtooldata.ini, 設定自動回復內容, 自動回復內容
		ToolTip("自動回復內容已更新！")
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
		msgbox,16,錯誤,尚未設定 [背包左上角第一格中心點] 與 [背包右下角最末格中心點]，請開啟設定選單(Win+Z)進行定位點抓取。
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
		if (藥劑類 = "error" or 傳奇裝 = "error" or 傳奇戒 = "error" or 守望石 = "error" or 勢力裝頁 = "error")
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
		清包模式 := "自動式"
	else if (清包模式 = "自動式")
		清包模式 := "掃描式"
	else if (清包模式 = "掃描式")
		清包模式 := "掃描快搜"
	else
		清包模式 := "按壓式"
	IniWrite, % 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
	ToolTip("F3清包模式已變更為: " . 清包模式)
	try {
		neutron.wnd.syncDataFromAHK()
	}
return

讀取F3按鍵模式:
 Iniread, 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
Return

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
	迴圈狀態 := 0
	掃描顏色Array := []
	ToolTip, 開始掃描背包顏色..., 0, 0, 1
	loop % 掃描水平數量
	{
		PosX := (掃描開始左上_X+(背包每格寬/2)) + ((背包每格寬/2)*((A_Index-1)*2))
		loop % 掃描垂直數量
		{
			PosY := (掃描開始左上_Y+(背包每格高/2)) + ((背包每格高/2)*((A_Index-1)*2))
			PixelGetColor, pcol, % PosX, % PosY, Fast RGB
			掃描顏色Array.Push(pcol)
			迴圈狀態 := 迴圈狀態 + 1
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
send {ctrl down}
loop % 掃描水平數量
{
PosX := (掃描開始左上_X+(背包每格寬/2)) + ((背包每格寬/2)*((A_Index-1)*2))
	if (InStr(清包模式, "按壓"))
	{
		cleanF3Key := CleanKeyName(快捷鍵_F3)
		if not(GetKeyState(cleanF3Key,"P"))
		{
		send {ctrl up}
		send {F3 up}
		ToolTip,,,,3
		return
		}
	}
	if (InStr(清包模式, "自動"))
	{
		if (GetKeyState("~","P"))
		{
		send {F3 up}
		send {ctrl up}
		ToolTip,,,,3
		return
		}
	}
loop % 掃描垂直數量
{
PosY := (掃描開始左上_Y+(背包每格高/2)) + ((背包每格高/2)*((A_Index-1)*2))
MouseClick,, % PosX, % PosY,1,0
	if (InStr(清包模式, "按壓"))
	{
		cleanF3Key := CleanKeyName(快捷鍵_F3)
		ToolTip, % "鬆開[" . cleanF3Key . "]停止。", 0,22,3
		if not(GetKeyState(cleanF3Key,"P"))
		{
		send {ctrl up}
		send {F3 up}
		ToolTip,,,,3
		return
		}
	}
	if (InStr(清包模式, "自動"))
	{
		ToolTip, % "長按[~]停止。", 0,22,3
		if (GetKeyState("~","P"))
		{
		send {F3 up}
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
global 存倉掃描顏色Array := []
{
 存倉掃描顏色Array := []
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
	PosX := (掃描開始左上_X+(背包每格寬/2)) + ((背包每格寬/2)*((A_Index-1)*2))
	loop % 掃描垂直數量
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
		PosY := (掃描開始左上_Y+(背包每格高/2)) + ((背包每格高/2)*((A_Index-1)*2))
		ToolTip, % "掃描: " PosX "/" PosY "，長按[~]停止。", 0,0,1
		PixelGetColor, pcol2, % PosX, % PosY, Fast RGB
		存倉掃描顏色Array.Push(pcol2)
		迴圈狀態:= 迴圈狀態 +1
		ToolTip, % "掃描格子數: " 迴圈狀態 " /60 ，長按[~]停止。"  , 0,22,2
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
 ToolTip("背包已淨空或停止。")
 send {ctrl up}
}
return

;[F7座標定位區]------------------------------------------------------------------------------------------------------

HK_WinF7_ModeLabel:
Msgbox,16,提醒,本工具的 [Win + F7] 沒有多功能切換哦~ ^0^
return

HK_F7_Label:
F7背包定位:
	if (捕捉模式 = 1)
	{
		MouseGetPos, capX, capY
		PixelGetColor, capC, %capX%, %capY%
		ToolTip("")
		if (捕捉類型 = "color")
		{
			PosX := ["","","","","顏色5_X","顏色6_X"]
			PosY := ["","","","","顏色5_Y","顏色6_Y"]
			CosA := ["","","","","顏色5_C","顏色6_C"]
			iniWrite,% capX, sidtooldata.ini, 顏色座標, % PosX[捕捉代號]
			iniWrite,% capY, sidtooldata.ini, 顏色座標, % PosY[捕捉代號]
			iniWrite,% capC, sidtooldata.ini, 顏色座標, % CosA[捕捉代號]
			gosub,座標顏色讀取
		}
		else if (捕捉類型 = "bag")
		{
			PosX := ["背包左上_X","背包右下_X"]
			PosY := ["背包左上_Y","背包右下_Y"]
			CosA := ["背包左上_C","背包右下_C"]
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
				確認按鈕_X := capX
				確認按鈕_Y := capY
				iniWrite,% capX, sidtooldata.ini, 討價還價定位, 確認按鈕_X
				iniWrite,% capY, sidtooldata.ini, 討價還價定位, 確認按鈕_Y
				ToolTip("已設定討價還價【確認按鈕】座標: " . capX . ", " . capY)
			}
			else if (捕捉代號 = 2)
			{
				重骰按鈕_X := capX
				重骰按鈕_Y := capY
				iniWrite,% capX, sidtooldata.ini, 討價還價定位, 重骰按鈕_X
				iniWrite,% capY, sidtooldata.ini, 討價還價定位, 重骰按鈕_Y
				ToolTip("已設定討價還價【重骰按鈕】座標: " . capX . ", " . capY)
			}
			gosub,讀取討價還價定位
		}
		try {
			neutron.wnd.updateAnchorPoint(捕捉類型, 捕捉代號, capX, capY, capC)
		} catch {
			neutron.wnd.eval("updateAnchorPoint('" . 捕捉類型 . "'," . 捕捉代號 . "," . capX . "," . capY . ",'" . capC . "')")
		}
		try {
			neutron.wnd.syncDataFromAHK()
		}
		neutron.Show()
		捕捉模式 := 0
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

背包運算作業:
掃描開始左上_X := % 背包左上_X
掃描開始左上_Y := % 背包左上_Y
掃描開始右下_X := % 背包右下_X
掃描開始右下_Y := % 背包右下_Y
掃描水平數量 := 12
掃描垂直數量 := 5
背包每格寬 := floor((掃描開始右下_X - 掃描開始左上_X) / 掃描水平數量)
背包每格高 := floor((掃描開始右下_Y - 掃描開始左上_Y) / 掃描垂直數量)
return

;[Neutron 介面溝通 bridge 函數]--------------------------------------------------------------------------------------

NeutronRunLabel(neutron, labelName) {
	if IsLabel(labelName)
		gosub %labelName%
}

NeutronSaveFlaskConfig(neutron, triggerMode, skillKey, skillFlasks, spaceFlasks, dur1, dur2, dur3, dur4, dur5) {
	global
	藥劑觸發模式 := triggerMode
	主要技能 := skillKey
	使用技能時觸發的藥劑 := skillFlasks
	一鍵喝水時觸發的藥劑 := spaceFlasks
	藥劑持續時間1 := dur1
	藥劑持續時間2 := dur2
	藥劑持續時間3 := dur3
	藥劑持續時間4 := dur4
	藥劑持續時間5 := dur5
	gosub, 儲存藥劑觸發紀錄
	gosub, 讀取藥劑觸發紀錄
	ToolTip("藥劑觸發設置已儲存！")
}

NeutronSaveSkillComboConfig(neutron, status, key1, delay1, key2, delay2, key3) {
	global
	技能連段功能 := status
	技1 := key1
	技1延遲 := delay1
	技2 := key2
	技2延遲 := delay2
	技3 := key3
	gosub, 儲存並讀取技能連段數據
	ToolTip("技能連段設置已儲存！")
}

NeutronSaveLoopSkillConfig(neutron, s1, t1, s2, t2, s3, t3) {
	global
	循環技能1 := s1
	循環技能時間1 := t1
	循環技能2 := s2
	循環技能時間2 := t2
	循環技能3 := s3
	循環技能時間3 := t3
	gosub, 儲存循環技能設置
	gosub, 讀取循環技能設置
	ToolTip("循環技能設置已儲存！")
}

NeutronSaveMineConfig(neutron, mode, staffMode, key, delay1, smokeKey, delay2) {
	global
	地雷模式 := mode
	地雷杖模式 := staffMode
	地雷按鍵 := key
	引爆延遲1 := delay1
	煙霧地雷 := smokeKey
	引爆延遲2 := delay2
	gosub, 儲存並讀取地雷設置
	ToolTip("自動引爆地雷設置已儲存！")
}

NeutronSaveClickerConfig(neutron, mode, speed) {
	global
	連點模式 := mode
	滑鼠連點速度 := speed
	IniWrite,% 連點模式, sidtooldata.ini, 按鍵模式切換, 連點模式
	IniWrite,% 滑鼠連點速度, sidtooldata.ini, 按鍵模式切換, 滑鼠連點速度
	gosub, 讀取連點模式
	gosub, 讀取滑鼠連點速度
	ToolTip("滑鼠連點設置已儲存！")
}

NeutronSaveClearBagConfig(neutron, mode) {
	global
	清包模式 := mode
	IniWrite,% 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
	ToolTip("清包模式已儲存為: " . 清包模式)
}

NeutronSaveWarehouseConfig(neutron, enchant, legendary, legendaryRing, thief, remove2, incubator, abyssJewel, clusterJewel, normalJewel, faction, specialMap, riftRing, uniqueHelmet, uniqueArmour, uniqueBelt, uniqueGloves, uniqueBoots, uniqueAccessory, uniqueWeapon, returnPage) {
	global
	附魔裝 := enchant
	傳奇裝 := legendary
	傳奇戒 := legendaryRing
	劫盜裝 := thief
	移除2 := remove2
	培育器 := incubator
	深淵珠 := abyssJewel
	星團珠 := clusterJewel
	普通珠 := normalJewel
	勢力裝頁 := faction
	特殊地圖 := specialMap
	裂痕戒指 := riftRing
	未鑑定稀有頭盔 := uniqueHelmet
	未鑑定稀有衣服 := uniqueArmour
	未鑑定稀有腰帶 := uniqueBelt
	未鑑定稀有手套 := uniqueGloves
	未鑑定稀有鞋子 := uniqueBoots
	未鑑定稀有飾品 := uniqueAccessory
	未鑑定稀有武器 := uniqueWeapon
	返回頁數 := returnPage
	gosub, 儲存並讀取倉庫頁數據
	ToolTip("倉庫頁面設置已儲存！")
}

StartAnchorCapture(neutron, type, id) {
	global
	捕捉類型 := type
	捕捉代號 := id
	捕捉模式 := 1
	hkF7Val := (快捷鍵_F7 != "" && 快捷鍵_F7 != "ERROR") ? 快捷鍵_F7 : "*F7"
	try {
		Hotkey, %hkF7Val%, HK_F7_Label, On
	}
	neutron.Hide()
	ToolTip("📍 請將滑鼠游標移至目標位置，按下 F7 完成抓取與儲存")
}

NeutronGetSettings(neutron) {
	global
	json := "{"
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
	json .= """hk_F1"":""" . 快捷鍵_F1 . ""","
	json .= """hk_F2"":""" . 快捷鍵_F2 . ""","
	json .= """hk_F3"":""" . 快捷鍵_F3 . ""","
	json .= """hk_F7"":""" . 快捷鍵_F7 . ""","
	json .= """hk_WinZ"":""" . 快捷鍵_WinZ . ""","
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
	json .= """haggleReroll_Y"":""" . 重骰按鈕_Y . """"
	json .= "}"
	return json
}

;[自訂快捷鍵相關函數與邏輯]----------------------------------------------------------------------------------

CleanKeyName(hk) {
	clean := RegExReplace(hk, "i)^[~*$^!+#]+", "")
	return clean
}

讀取自訂快捷鍵:
Iniread, 快捷鍵_F1, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_F1, *F1
Iniread, 快捷鍵_F2, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_F2, F2
Iniread, 快捷鍵_F3, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_F3, F3
Iniread, 快捷鍵_F7, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_F7, *F7
Iniread, 快捷鍵_WinZ, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_WinZ, ``
Iniread, 快捷鍵_Space, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_Space, ~*space
Iniread, 快捷鍵_Insert, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_Insert, *Insert
Iniread, 快捷鍵_End, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_End, End
Return

註冊動態熱鍵:
Hotkey, IfWinActive, ahk_group DualWins
keysList := "F1,F2,F3,F7,WinZ,Space,Insert,End"
Loop, parse, keysList, % ","
{
    kName := A_LoopField
    hkVal := 快捷鍵_%kName%
    lbl := "HK_" . kName . "_Label"
    if (hkVal != "" && hkVal != "ERROR")
    {
        try {
            Hotkey, %hkVal%, %lbl%, On
        }
    }

    if (kName = "F1" || kName = "F2" || kName = "F3" || kName = "F7" || kName = "End")
    {
        cleanK := CleanKeyName(hkVal)
        if (cleanK != "")
        {
            winHk := "#" . cleanK
            winLbl := "HK_Win" . kName . "_ModeLabel"
            try {
                Hotkey, %winHk%, %winLbl%, On
            }
        }
    }
}
Hotkey, IfWinActive
Return

解開動態熱鍵:
Hotkey, IfWinActive, ahk_group DualWins
keysList := "F1,F2,F3,F7,WinZ,Space,Insert,End"
Loop, parse, keysList, % ","
{
    kName := A_LoopField
    hkVal := 快捷鍵_%kName%
    if (hkVal != "" && hkVal != "ERROR")
    {
        try {
            Hotkey, %hkVal%, Off
        }
    }
    if (kName = "F1" || kName = "F2" || kName = "F3" || kName = "F7" || kName = "End")
    {
        cleanK := CleanKeyName(hkVal)
        if (cleanK != "")
        {
            winHk := "#" . cleanK
            try {
                Hotkey, %winHk%, Off
            }
        }
    }
}
Hotkey, IfWinActive
Return

NeutronSaveCustomHotkeys(neutron, hkF1, hkF2, hkF3, hkWinZ, hkSpace, hkInsert, hkEnd) {
	global
	gosub, 解開動態熱鍵
	快捷鍵_F1 := hkF1
	快捷鍵_F2 := hkF2
	快捷鍵_F3 := hkF3
	快捷鍵_WinZ := hkWinZ
	快捷鍵_Space := hkSpace
	快捷鍵_Insert := hkInsert
	快捷鍵_End := hkEnd

	keysList := "F1,F2,F3,WinZ,Space,Insert,End"
	Loop, parse, keysList, % ","
	{
		kName := A_LoopField
		IniWrite, % 快捷鍵_%kName%, sidtooldata.ini, 自訂快捷鍵, 快捷鍵_%kName%
	}
	gosub, 註冊動態熱鍵
	ToolTip("自訂快捷鍵設置已儲存並生效！")
}

;[探險討價還價(圖貞 Haggle) 快捷鍵]--------------------------------------------------------------------------------------

$1::
if (!GetKeyState("capslock","T") || Toolbutton = 1 || WinActive("ahk_id " . neutron.hWnd))
{
	Send, 1
}
else
{
	if (確認按鈕_X = "" || 確認按鈕_X = 0 || 確認按鈕_Y = "" || 確認按鈕_Y = 0)
	{
		ToolTip("尚未設定【確認按鈕】座標！請先在菜單設置中進行定位抓取。")
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
if (!GetKeyState("capslock","T") || Toolbutton = 1 || WinActive("ahk_id " . neutron.hWnd))
{
	Send, 2
}
else
{
	if (重骰按鈕_X = "" || 重骰按鈕_X = 0 || 重骰按鈕_Y = "" || 重骰按鈕_Y = 0)
	{
		ToolTip("尚未設定【重骰按鈕】座標！請先在菜單設置中進行定位抓取。")
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

