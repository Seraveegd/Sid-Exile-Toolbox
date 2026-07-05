#NoEnv
#NoTrayIcon
#SingleInstance force
#MaxHotkeysPerInterval 400
SetBatchLines -1
SetKeyDelay, 0

;[讀取記錄區]------------------------------------------------------------------------------------------------------
使用者類型 = 已開源

gosub,讀取當前角色配置
gosub,讀取F7背包定位內容
gosub,背包運算作業
gosub,背包運算作業2
gosub,讀取F1按鍵模式
gosub,讀取F3按鍵模式
gosub,讀取F6按鍵模式
gosub,讀取F6取物定位內容
gosub,讀取F8按鍵模式
gosub,讀取倉庫頁數據
gosub,讀取背包初始顏色
gosub,讀取回復模式
gosub,讀取自動回復內容
gosub,讀取快速交易提醒功能
gosub,讀取快速組隊提醒功能
gosub,讀取連點模式
gosub,讀取滑鼠連點速度
gosub,座標顏色讀取
gosub,讀取地雷設置
gosub,讀取喝水提示開關
gosub,讀取偵測喝水打勾紀錄
gosub,讀取技能連段數據
gosub,讀取循環技能設置
gosub,讀取偵測喝水數據
gosub,讀取藥劑觸發紀錄

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

Menu, 工具介紹副菜單, Add, 工具熱鍵列表, 工具熱鍵列表GUI面板
Menu, 工具介紹副菜單, Add, 完整功能列表, 完整功能
Menu, MyMenu, Add, ★工具介紹★(必看), :工具介紹副菜單
Menu, MyMenu, Add
Menu, MyMenu, Add, 切換角色配置, 切換角色配置GUI面板
Menu, MyMenu, Add, 藥劑觸發設置, 藥劑觸發設置GUI面板
Menu, MyMenu, Add, 偵測喝水設置, 偵測喝水設置GUI面板
Menu, MyMenu, Add, 技能連段設置, 技能連段設置GUI面板
Menu, MyMenu, Add, 循環技能設置, 循環技能設置GUI面板
Menu, MyMenu, Add, 快搜倉庫設置, 倉庫頁快搜工具視窗
Menu, MyMenu, Add
Menu, MyMenu, Add, 滑鼠連點設置, 滑鼠連點設置GUI面板
Menu, MyMenu, Add, 自動引爆地雷設置, 自動引爆地雷設置GUI面板
Menu, MyMenu, Add, 前往查價工具的網址(台服/國際服), 引導查價安裝網址
Menu, MyMenu, Add
Menu, MyMenu, Add, 前往Sid作者的網站, 彈跳網頁
return

呼叫菜單:
menu,mymenu,show
return

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
msgbox,,提示, 工具已結束 ლ(・ω・ლ)摸摸
exitapp
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

#ifwinactive, Path of Exile

#Z::
gosub,呼叫菜單
return

#V::
gosub,查價工具視窗
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

;[完整功能GUI面板]-----------------------------------------------------------------------------------------------------------------------------------------------------

完整功能:
gui,完整功能列表:new,,完整功能列表（本工具已完全開源免費）
Gui, Font, s10, Verdana
Gui, Add,Text,cBlue,[F1] 原始功能/返回角色
Gui, Add,Text,cBlue,[F2] 一鍵暫離/勿擾/自動回復
Gui, Add,Link,cBlue,[F3] 按壓式/自動式/掃描式/掃描快搜清包 = <a href="https://youtu.be/MzIH2rn72NE">示範影片</a>
Gui, Add,Text,cBlue,[F4] 快速使用背包傳卷
Gui, Add,Text,cBlue,[F5] 返回藏身
Gui, Add,Text,cBlue,[F6] 快速一鍵取物
Gui, Add,Text,cBlue,[F7] 背包相關座標定位
Gui, Add,Text,cBlue,[F8] 單次/多次兌換命運卡
Gui, Add,Text,cBlue,[F9] 回復鍵盤功能 (暫停工具)
Gui, Add,Text,cBlue,[F10] 高級喝水模式 (偵測血/魔/場景自動喝水返角)
Gui, Add,Text,cBlue,[End] 快速申請組隊
Gui, Add,Text,cBlue,[Home] 快速申請交易
Gui, Add,Text,cBlue,[PgUp] 快速交易:確認60格欄位
Gui, Add,Text,cBlue,[PgDn] 快速交易:接受交易
Gui, Add,Text,cBlue,[Space] 一鍵喝水 / 循環喝水 / 藥劑防呆
Gui, Add,Text,cBlue,[Insert] 自動循環技能
Gui, Add,Text,cBlue,[Win + V] 快速查價
Gui, Add,Text,cBlue,[Win + Z] 工具菜單與各項設置
Gui, Add,Text,cBlue,[Ctrl + Alt] 快搜倉庫自動翻頁
Gui, Add,Text,cBlue,[Ctrl + Win] 返回倉庫首頁
Gui, Add,Text,cBlue,[滾輪下壓] or [Ctrl + 左鍵] 滑鼠連點
Gui Font
Gui Add, StatusBar,, 所有功能完全免費開源，歡迎分享與改進。
Gui, Show
return

;[工具熱鍵列表GUI面板]------------------------------------------------------------------------------------------------------

工具熱鍵列表GUI面板:
Gui,工具熱鍵列表:new,,工具熱鍵列表
Gui Color, 0xC0C0C0
Gui, Font, s10 Bold, Verdana
Gui, Add,Text,cBlue,【F1 ~ F12】(所有含有" / "符號，表示支援多功能切換，詳情看底部小知識。)
Gui, Font
Gui, Font, s10, Verdana
Gui, Add,Text,cBlue,[F1] = 原始功能 / 返回角色
Gui, Add,Text,cBlue,[F2] = 暫離 / 勿擾 / 自動回復
Gui, Add,Link,cBlue,[F3] = 按壓 / 自動/掃描/掃描快搜清包 / 背包顏色定位。 影片介紹:<a href="https://youtu.be/MzIH2rn72NE">點我</a>
Gui, Add,Text,cBlue,[F4] = 使用傳送券軸
Gui, Add,Text,cBlue,[F5] = 返回藏身處 (城鎮限定)
Gui, Add,Link,cBlue,[F6] = 快速一鍵取物/取物座標定位。 影片介紹:<a href="https://youtu.be/yV8FdhSmz2Y">點我</a>
Gui, Add,Text,cBlue,[F7] = 背包座標定位
Gui, Add,Link,cBlue,[F8] = 單次 / 多次 兌換命運卡。 影片介紹:<a href="https://youtu.be/zBKJ99hFg9Y">點我</a>
Gui, Add,Text,cBlue,[F9] = 回復鍵盤功能 (暫停工具)
Gui, Add,Text,cBlue,[F10] = 開關高級喝水模式
Gui, Add,Text,cBlue,[F11] = 重新啟動工具
Gui, Add,Text,cBlue,[F12] = 結束工具
Gui, Font, s10 Bold, Verdana
Gui, Add,Text,cBlue,【其他熱鍵】(對按鍵名稱不熟的，請自行Google。)
Gui, Font
Gui, Font, s10, Verdana
Gui, Add,Text,cBlue,[End] = 快速申請組隊 / 開關提醒
Gui, Add,Text,cBlue,[Home] = 快速申請交易 / 開關提醒
Gui, Add,Text,cBlue,[PgUp] = 快速交易，確認對方60格欄位
Gui, Add,Text,cBlue,[PgDn] = 快速交易，接受交易
Gui, Add,Text,cBlue,[Space] = 一鍵喝水 / 循環 / 防呆 (Win + Z :藥劑觸發設置)
Gui, Add,Text,cBlue,[Insert] = 自動循環技能開關
Gui, Add,Link,cBlue,[Win + C] = 各式偵測點座標與顏色定位。 影片介紹:<a href="https://youtu.be/dTk3BO54_8Y">點我</a>
Gui, Add,Text,cBlue,[Win + V] = 快速查價 (滑鼠指道具使用)
Gui, Add,Text,cBlue,[Win + End] = 開關組隊提醒
Gui, Add,Link,cBlue,[Ctrl + Alt] = 自動翻頁 (快搜倉庫頁功能)。 影片介紹:<a href="https://youtu.be/StpFz8qbB44">點我</a>
Gui, Add,Text,cBlue,[Ctrl + Win] = 返回倉庫首頁
Gui, Add,Text,cBlue,[滾輪下壓] or [Ctrl + 左鍵] = 滑鼠連點
Gui, Font, underline
Gui, Add,Text,cBlue,開源版本，歡迎自由使用與修改。
Gui, Font
Gui Add, StatusBar,, ▲工具小知識:多功能切換的意思，例如:當使用(Win + F1)時，你會看到有兩個選項，可改變(F1)的功能，以此類推。
Gui, Show
return

;[跳程指令區]---------------------------------------------------------------------------------------------------

起始盒子:
msgbox,,Sid流亡工具箱（開源版）,工具已啟動，使用 ( Win + Z ) 顯示工具清單。`r本版本已完全開源，所有功能均可免費使用。
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

停止循環偵測:
settimer,偵測場景變化,off
settimer,偵測血球,OFF
settimer,偵測血條,OFF
settimer,偵測魔力球,OFF
settimer,偵測血條返角,OFF
settimer,偵測混傷穿透血條,OFF
settimer,偵測混傷穿透血條返角,OFF
return

;[藥劑觸發設置GUI面板]------------------------------------------------------------------------------------------------------

藥劑觸發設置GUI面板:
Gui,藥劑觸發設置:new,,藥劑觸發設置
Gui +Label藥劑觸發設置 -Resize  -MinimizeBox -MaximizeBox
Gui Color, 0xC0C0C0
Gui Font, s12 Bold
Gui Add, Text, x31 y152 w135 h23, 藥劑(1)持續時間:
Gui Add, Text, x31 y177 w135 h23, 藥劑(2)持續時間:
Gui Add, Text, x31 y202 w135 h23, 藥劑(3)持續時間:
Gui Add, Text, x31 y227 w135 h23, 藥劑(4)持續時間:
Gui Add, Text, x31 y252 w135 h23, 藥劑(5)持續時間:
Gui Add, Text, x30 y97 w100 h23, 當使用技能:
Gui Add, Text, x171 y97 w111 h23, 時，使用藥劑:
Gui Add, Text, x30 y8 w145 h23, 藥劑觸發模式選擇:
Gui Add, Text, x31 y125 w219 h23, 一鍵喝水(Space)，使用藥劑: 
Gui Add, Button,g儲存藥劑觸發設置 x298 y204 w384 h67, 儲存並關閉
Gui Font
Gui Font, s12
Gui Add, ComboBox, v藥劑觸發模式 x184 y5 w143 -Theme, 無|純藥劑防呆|讀秒循環喝水|使用技能時喝水|%藥劑觸發模式%||
Gui Add, ComboBox, v主要技能 x126 y96 w40 -Theme, Q|W|E|R|T|%主要技能%||
Gui Font
Gui Font, s10 cBlue
Gui Add, Text, x30 y35 w607 h20, 純藥劑防呆 : 玩家手動喝水，工具幫助您鎖定藥劑持續時間內，不會再次誤觸。適合需高強度控水的場合。
Gui Add, Text, x30 y55 w604 h20, 讀秒循環喝水 : 進圖後使用[Space]空白鍵觸發循環，藥劑持續時間結束後再次使用。適合速刷走路流派。
Gui Add, Text, x30 y75 w440 h20, 使用技能時喝水 : 只有在使用技能時才喝水，可避免非戰鬥時多餘的喝水。
Gui Add, Text, x363 y96 w320 h23 +0x200, 舉例 : 輸入 12345 = 使用12345罐，輸入 135 = 使用135罐。
Gui Add, Text, x295 y152 w210 h23 +0x200, (1秒=1000毫秒)，不使用請輸入 off 。
Gui Add, Text, x295 y177 w150 h23 +0x200, 生命藥劑通常輸入 off 。
Gui Font
Gui Font, s10
Gui Add, Edit, v藥劑持續時間1 x171 y152 w120 h21 -Theme, %藥劑持續時間1%
Gui Add, Edit, v藥劑持續時間2 x171 y177 w120 h21 -Theme, %藥劑持續時間2%
Gui Add, Edit, v藥劑持續時間3 x171 y202 w120 h21 -Theme, %藥劑持續時間3%
Gui Add, Edit, v藥劑持續時間4 x171 y227 w120 h21 -Theme, %藥劑持續時間4%
Gui Add, Edit, v藥劑持續時間5 x171 y252 w120 h21 -Theme, %藥劑持續時間5%
Gui Add, Edit, v使用技能時觸發的藥劑 x281 y96 w78 h21 +Number -Theme, %使用技能時觸發的藥劑%
Gui Add, Edit, v一鍵喝水時觸發的藥劑 x255 y123 w120 h21 +Number -Theme, %一鍵喝水時觸發的藥劑%
Gui Font
Gui Add, StatusBar,, ▲工具小知識: 純藥劑防呆模式下支援一鍵喝水(Space)，水沒了卻還在防呆時間內?試試手動1~5吧，立即重置防呆冷卻。
Gui Show, w691 h301, 藥劑觸發設置
Return

;[藥劑觸發GUI儲存按鈕]------------------------------------------------------------------------------------------------------

藥劑觸發設置Escape:
藥劑觸發設置Close:
Msgbox,4,提醒視窗,您尚未儲存設定，確定是否要直接關閉?(是 或 否)
IfMsgBox No
	Return
Else
	Gui,submit
Return

;[藥劑觸發GUI儲存指令]------------------------------------------------------------------------------------------------------

儲存藥劑觸發設置:
Gui,submit
Gosub,儲存藥劑觸發紀錄
Gosub,讀取藥劑觸發紀錄
Return

儲存藥劑觸發紀錄:
if 當前角色配置 = 1
{
IniWrite,	% 主要技能,	sidtooldata.ini, 藥劑觸發數據, 主要技能
IniWrite,	% 藥劑觸發模式,	sidtooldata.ini, 藥劑觸發數據, 藥劑觸發模式
IniWrite,	% 藥劑持續時間1,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間1
IniWrite,	% 藥劑持續時間2,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間2
IniWrite,	% 藥劑持續時間3,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間3
IniWrite,	% 藥劑持續時間4,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間4
IniWrite,	% 藥劑持續時間5,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間5
IniWrite,	% 使用技能時觸發的藥劑,	sidtooldata.ini, 藥劑觸發數據, 使用技能時觸發的藥劑
IniWrite,	% 一鍵喝水時觸發的藥劑,	sidtooldata.ini, 藥劑觸發數據, 一鍵喝水時觸發的藥劑
}
if 當前角色配置 = 2
{
IniWrite,	% 主要技能,	sidtooldata2.ini, 藥劑觸發數據, 主要技能
IniWrite,	% 藥劑觸發模式,	sidtooldata2.ini, 藥劑觸發數據, 藥劑觸發模式
IniWrite,	% 藥劑持續時間1,	sidtooldata2.ini, 藥劑觸發數據, 藥劑持續時間1
IniWrite,	% 藥劑持續時間2,	sidtooldata2.ini, 藥劑觸發數據, 藥劑持續時間2
IniWrite,	% 藥劑持續時間3,	sidtooldata2.ini, 藥劑觸發數據, 藥劑持續時間3
IniWrite,	% 藥劑持續時間4,	sidtooldata2.ini, 藥劑觸發數據, 藥劑持續時間4
IniWrite,	% 藥劑持續時間5,	sidtooldata2.ini, 藥劑觸發數據, 藥劑持續時間5
IniWrite,	% 使用技能時觸發的藥劑,	sidtooldata2.ini, 藥劑觸發數據, 使用技能時觸發的藥劑
IniWrite,	% 一鍵喝水時觸發的藥劑,	sidtooldata2.ini, 藥劑觸發數據, 一鍵喝水時觸發的藥劑
}
if 當前角色配置 = 3
{
IniWrite,	% 主要技能,	sidtooldata3.ini, 藥劑觸發數據, 主要技能
IniWrite,	% 藥劑觸發模式,	sidtooldata3.ini, 藥劑觸發數據, 藥劑觸發模式
IniWrite,	% 藥劑持續時間1,	sidtooldata3.ini, 藥劑觸發數據, 藥劑持續時間1
IniWrite,	% 藥劑持續時間2,	sidtooldata3.ini, 藥劑觸發數據, 藥劑持續時間2
IniWrite,	% 藥劑持續時間3,	sidtooldata3.ini, 藥劑觸發數據, 藥劑持續時間3
IniWrite,	% 藥劑持續時間4,	sidtooldata3.ini, 藥劑觸發數據, 藥劑持續時間4
IniWrite,	% 藥劑持續時間5,	sidtooldata3.ini, 藥劑觸發數據, 藥劑持續時間5
IniWrite,	% 使用技能時觸發的藥劑,	sidtooldata3.ini, 藥劑觸發數據, 使用技能時觸發的藥劑
IniWrite,	% 一鍵喝水時觸發的藥劑,	sidtooldata3.ini, 藥劑觸發數據, 一鍵喝水時觸發的藥劑
}
Return

讀取藥劑觸發紀錄:
if 當前角色配置 = 1
{
 Iniread,	 主要技能,	sidtooldata.ini, 藥劑觸發數據, 主要技能
 Iniread,	 藥劑觸發模式,	sidtooldata.ini, 藥劑觸發數據, 藥劑觸發模式
 Iniread,	 藥劑持續時間1,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間1
 Iniread,	 藥劑持續時間2,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間2
 Iniread,	 藥劑持續時間3,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間3
 Iniread,	 藥劑持續時間4,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間4
 Iniread,	 藥劑持續時間5,	sidtooldata.ini, 藥劑觸發數據, 藥劑持續時間5
 Iniread,	 使用技能時觸發的藥劑,	sidtooldata.ini, 藥劑觸發數據, 使用技能時觸發的藥劑
 Iniread,	 一鍵喝水時觸發的藥劑,	sidtooldata.ini, 藥劑觸發數據, 一鍵喝水時觸發的藥劑
}
if 當前角色配置 = 2
{
 Iniread,	 主要技能,	sidtooldata2.ini, 藥劑觸發數據, 主要技能
 Iniread,	 藥劑觸發模式,	sidtooldata2.ini, 藥劑觸發數據, 藥劑觸發模式
 Iniread,	 藥劑持續時間1,	sidtooldata2.ini, 藥劑觸發數據, 藥劑持續時間1
 Iniread,	 藥劑持續時間2,	sidtooldata2.ini, 藥劑觸發數據, 藥劑持續時間2
 Iniread,	 藥劑持續時間3,	sidtooldata2.ini, 藥劑觸發數據, 藥劑持續時間3
 Iniread,	 藥劑持續時間4,	sidtooldata2.ini, 藥劑觸發數據, 藥劑持續時間4
 Iniread,	 藥劑持續時間5,	sidtooldata2.ini, 藥劑觸發數據, 藥劑持續時間5
 Iniread,	 使用技能時觸發的藥劑,	sidtooldata2.ini, 藥劑觸發數據, 使用技能時觸發的藥劑
 Iniread,	 一鍵喝水時觸發的藥劑,	sidtooldata2.ini, 藥劑觸發數據, 一鍵喝水時觸發的藥劑
}
if 當前角色配置 = 3
{
 Iniread,	 主要技能,	sidtooldata3.ini, 藥劑觸發數據, 主要技能
 Iniread,	 藥劑觸發模式,	sidtooldata3.ini, 藥劑觸發數據, 藥劑觸發模式
 Iniread,	 藥劑持續時間1,	sidtooldata3.ini, 藥劑觸發數據, 藥劑持續時間1
 Iniread,	 藥劑持續時間2,	sidtooldata3.ini, 藥劑觸發數據, 藥劑持續時間2
 Iniread,	 藥劑持續時間3,	sidtooldata3.ini, 藥劑觸發數據, 藥劑持續時間3
 Iniread,	 藥劑持續時間4,	sidtooldata3.ini, 藥劑觸發數據, 藥劑持續時間4
 Iniread,	 藥劑持續時間5,	sidtooldata3.ini, 藥劑觸發數據, 藥劑持續時間5
 Iniread,	 使用技能時觸發的藥劑,	sidtooldata3.ini, 藥劑觸發數據, 使用技能時觸發的藥劑
 Iniread,	 一鍵喝水時觸發的藥劑,	sidtooldata3.ini, 藥劑觸發數據, 一鍵喝水時觸發的藥劑
}
Return



;[偵測喝水設置GUI面板]------------------------------------------------------------------------------------------------------

偵測喝水設置GUI面板:
gosub,偵測喝水打勾紀錄轉換
Gui,偵測喝水設置:new,,偵測喝水設置
Gui +Label偵測喝水設置 -Resize  -MinimizeBox -MaximizeBox
Gui Font, s12
Gui Add, Text, x10 y25 w275 h16, 角色頭上血條低於偵測點(1)時使用藥劑
Gui Add, Text, x360 y25 w243 h16, ，血條低於偵測點(2)時返回角色。
Gui Add, Text, x10 y165 w280 h16, 當左下角血球低於偵測點(9)時使用藥劑
Gui Add, Text, x10 y85 w275 h16, 當右下角魔球低於偵測點(3)時使用藥劑
Gui Add, Text, x10 y125 w280 h16, 血條混傷穿透低於偵測點(7)時使用藥劑
Gui Add, Text, x360 y125 w275 h16, ，混傷穿透低於偵測點(8)時返回角色。
Gui Add, Text, x9 y185 w142 h16, 偵測喝水間隔(毫秒)
Gui Add, Text, x213 y185 w352 h16, ，斟酌調整，依據藥劑立即回復或快速回復設置。
Gui Add, Text, x470 y70 w120 h16, 偵測喝水提示:
Gui Add, DropDownList, v喝水提示開關 x578 y68 w60 -Theme, 開啟|關閉|%喝水提示開關%||
Gui Font, s11 cRed
Gui Add, Text, x14 y45 h14, 舉例:只喝第1罐請輸入1。喝2瓶，可輸入12。挖礦時補血+開燈可輸入16，使用技能輸入16R。
Gui Font
Gui Font, s12 c0x0080FF
Gui Add, CheckBox, hWndcheckbox1 v偵測血條喝水開關 x10 y4 w165 h18 %偵測血條喝水打勾紀錄%, 開啟偵測血條喝水↓
Gui Add, CheckBox, hWndcheckbox2 v偵測血條返角開關 x360 y4 w165 h18 %偵測血條返角打勾紀錄%, 開啟偵測血條返角↓
Gui Add, CheckBox, hWndcheckbox3 v偵測魔球喝水開關 x10 y64 w165 h18 %偵測魔球喝水打勾紀錄%, 開啟偵測魔球喝水↓
Gui Add, CheckBox, hWndcheckbox4 v偵測血條穿透開關 x10 y104 w165 h18 %偵測血條穿透打勾紀錄%, 開啟偵測血條穿透↓
Gui Add, CheckBox, hWndcheckbox5 v偵測血條穿透返角開關 x360 y105 w200 h18 %偵測血條穿透返角打勾紀錄%, 開啟偵測血條穿透返角↓
Gui Add, CheckBox, hWndcheckbox6 v偵測血球池開關 x10 y144 w150 h18 %偵測血球池打勾紀錄%, 開啟偵測血球池↓
Gui, Add,Link,cRed x548 y4, 點我 <a href="https://youtu.be/dTk3BO54_8Y">影片示範</a>
Gui Font
Gui Add, Button, g儲存偵測喝水設置 x578 y182 w80 h23 -Theme, 儲存並關閉
Gui Add, StatusBar,, ▲ 工具小知識: 同時開啟 [ 偵測血條返角 ] 與 [ 偵測血球池 ] 可以大幅度降低返角誤判情況。 ㊣ 工具製作 By Sid の 一人團隊
Gui Font
Gui Add, Edit, v藥劑按鍵1 x293 y23 w60 h20  -Theme,%藥劑按鍵1%
Gui Add, Edit, v藥劑按鍵2 x293 y81 w60 h20  -Theme,%藥劑按鍵2%
Gui Add, Edit, v藥劑按鍵3 x293 y123 w60 h20  -Theme,%藥劑按鍵3%
Gui Add, Edit, v藥劑按鍵4 x293 y163 w60 h20  -Theme,%藥劑按鍵4%
Gui Add, ComboBox, v偵測喝水間隔 x157 y183 w50 -Theme, 100|300|500|800|1000|2000|3000|%偵測喝水間隔%||
Gui Show, w668 h234, 偵測喝水設置 (此功能只會在F10高級模式下運作)
Return

;[偵測喝水GUI儲存按鈕]------------------------------------------------------------------------------------------------------

偵測喝水設置Escape:
偵測喝水設置Close:
Msgbox,4,提醒視窗,您尚未儲存設定，確定是否要直接關閉?(是 或 否)
IfMsgBox No
	Return
Else
	Gui,submit
Return


;[偵測喝水GUI儲存指令]------------------------------------------------------------------------------------------------------


偵測喝水打勾紀錄轉換:
	if 偵測血條喝水打勾紀錄 = +checked
	{
	偵測血條喝水打勾紀錄 = +checked
	}
	else
	{
	偵測血條喝水打勾紀錄 = -checked
	}

	if 偵測血條返角打勾紀錄 = +checked
	{
	偵測血條返角打勾紀錄 = +checked
	}
	else
	{
	偵測血條返角打勾紀錄 = -checked
	}

	if 偵測魔球喝水打勾紀錄 = +checked
	{
	偵測魔球喝水打勾紀錄 = +checked
	}
	else
	{
	偵測魔球喝水打勾紀錄 = -checked
	}

	if 偵測血條穿透打勾紀錄 = +checked
	{
	偵測血條穿透打勾紀錄 = +checked
	}
	else
	{
	偵測血條穿透打勾紀錄 = -checked
	}

	if 偵測血條穿透返角打勾紀錄 = +checked
	{
	偵測血條穿透返角打勾紀錄 = +checked
	}
	else
	{
	偵測血條穿透返角打勾紀錄 = -checked
	}

	if 偵測血球池打勾紀錄 = +checked
	{
	偵測血球池打勾紀錄 = +checked
	}
	else
	{
	偵測血球池打勾紀錄 = -checked
	}
return

儲存偵測喝水設置:
Gui,submit
If 偵測血條喝水開關 = 1
偵測血條喝水打勾紀錄 = +Checked
If 偵測血條喝水開關 = 0
偵測血條喝水打勾紀錄 = -Checked
If 偵測血條返角開關 = 1
偵測血條返角打勾紀錄 = +Checked
If 偵測血條返角開關 = 0
偵測血條返角打勾紀錄 = -Checked
If 偵測魔球喝水開關 = 1
偵測魔球喝水打勾紀錄 = +Checked
If 偵測魔球喝水開關 = 0
偵測魔球喝水打勾紀錄 = -Checked
If 偵測血條穿透開關 = 1
偵測血條穿透打勾紀錄 = +Checked
If 偵測血條穿透開關 = 0
偵測血條穿透打勾紀錄 = -Checked
If 偵測血條穿透返角開關 = 1
偵測血條穿透返角打勾紀錄 = +Checked
If 偵測血條穿透返角開關 = 0
偵測血條穿透返角打勾紀錄 = -Checked
If 偵測血球池開關 = 1
偵測血球池打勾紀錄 = +Checked
If 偵測血球池開關 = 0
偵測血球池打勾紀錄 = -Checked
gosub,儲存偵測喝水打勾紀錄
gosub,儲存偵測喝水數據
gosub,儲存喝水提示開關
gosub,讀取偵測喝水打勾紀錄
gosub,讀取偵測喝水數據
gosub,讀取喝水提示開關
if Autodrinkbutton = 1
{
Autodrinkbutton := 0
msgbox,48,提醒,您剛剛重新調整了設定，已自動關閉[F10]高級模式。`r請重新開啟[F10]使其生效。
}
Return

儲存喝水提示開關:
IniWrite,	% 喝水提示開關,	sidtooldata.ini, 偵測喝水數據, 喝水提示開關
Return

讀取喝水提示開關:
 Iniread,	 喝水提示開關,	sidtooldata.ini, 偵測喝水數據, 喝水提示開關
	if 喝水提示開關 = error
	{
	ToolTipOff = 0
	喝水提示開關 = 開啟
	}
	if 喝水提示開關 = 開啟
	{
	ToolTipOff = 0
	}
	if 喝水提示開關 = 關閉
	{
	ToolTipOff = 1
	}
Return

儲存偵測喝水打勾紀錄:
if 當前角色配置 = 1
{
IniWrite,	% 偵測血條穿透返角打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測血條穿透返角打勾紀錄
IniWrite,	% 偵測血條喝水打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測血條喝水打勾紀錄
IniWrite,	% 偵測血條返角打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測血條返角打勾紀錄
IniWrite,	% 偵測魔球喝水打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測魔球喝水打勾紀錄
IniWrite,	% 偵測血條穿透打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測血條穿透打勾紀錄
IniWrite,	% 偵測血球池打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測血球池打勾紀錄
}
if 當前角色配置 = 2
{
IniWrite,	% 偵測血條穿透返角打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測血條穿透返角打勾紀錄
IniWrite,	% 偵測血條喝水打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測血條喝水打勾紀錄
IniWrite,	% 偵測血條返角打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測血條返角打勾紀錄
IniWrite,	% 偵測魔球喝水打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測魔球喝水打勾紀錄
IniWrite,	% 偵測血條穿透打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測血條穿透打勾紀錄
IniWrite,	% 偵測血球池打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測血球池打勾紀錄
}
if 當前角色配置 = 3
{
IniWrite,	% 偵測血條穿透返角打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測血條穿透返角打勾紀錄
IniWrite,	% 偵測血條喝水打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測血條喝水打勾紀錄
IniWrite,	% 偵測血條返角打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測血條返角打勾紀錄
IniWrite,	% 偵測魔球喝水打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測魔球喝水打勾紀錄
IniWrite,	% 偵測血條穿透打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測血條穿透打勾紀錄
IniWrite,	% 偵測血球池打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測血球池打勾紀錄
}
Return

讀取偵測喝水打勾紀錄:
if 當前角色配置 = 1
{
 Iniread,	偵測血條穿透返角打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測血條穿透返角打勾紀錄
 Iniread,	偵測血條喝水打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測血條喝水打勾紀錄
 Iniread,	偵測血條返角打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測血條返角打勾紀錄
 Iniread,	偵測魔球喝水打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測魔球喝水打勾紀錄
 Iniread,	偵測血條穿透打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測血條穿透打勾紀錄
 Iniread,	偵測血球池打勾紀錄,	sidtooldata.ini, 偵測喝水數據, 偵測血球池打勾紀錄
}
if 當前角色配置 = 2
{
 Iniread,	偵測血條穿透返角打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測血條穿透返角打勾紀錄
 Iniread,	偵測血條喝水打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測血條喝水打勾紀錄
 Iniread,	偵測血條返角打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測血條返角打勾紀錄
 Iniread,	偵測魔球喝水打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測魔球喝水打勾紀錄
 Iniread,	偵測血條穿透打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測血條穿透打勾紀錄
 Iniread,	偵測血球池打勾紀錄,	sidtooldata2.ini, 偵測喝水數據, 偵測血球池打勾紀錄
}
if 當前角色配置 = 3
{
 Iniread,	偵測血條穿透返角打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測血條穿透返角打勾紀錄
 Iniread,	偵測血條喝水打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測血條喝水打勾紀錄
 Iniread,	偵測血條返角打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測血條返角打勾紀錄
 Iniread,	偵測魔球喝水打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測魔球喝水打勾紀錄
 Iniread,	偵測血條穿透打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測血條穿透打勾紀錄
 Iniread,	偵測血球池打勾紀錄,	sidtooldata3.ini, 偵測喝水數據, 偵測血球池打勾紀錄
}
Return

儲存偵測喝水數據:
if 當前角色配置 = 1
{
IniWrite,	% 藥劑按鍵1,	sidtooldata.ini, 偵測喝水數據, 藥劑按鍵1
IniWrite,	% 藥劑按鍵2,	sidtooldata.ini, 偵測喝水數據, 藥劑按鍵2
IniWrite,	% 藥劑按鍵3,	sidtooldata.ini, 偵測喝水數據, 藥劑按鍵3
IniWrite,	% 藥劑按鍵4,	sidtooldata.ini, 偵測喝水數據, 藥劑按鍵4
IniWrite,	% 偵測喝水間隔,	sidtooldata.ini, 偵測喝水數據, 偵測喝水間隔
}
if 當前角色配置 = 2
{
IniWrite,	% 藥劑按鍵1,	sidtooldata2.ini, 偵測喝水數據, 藥劑按鍵1
IniWrite,	% 藥劑按鍵2,	sidtooldata2.ini, 偵測喝水數據, 藥劑按鍵2
IniWrite,	% 藥劑按鍵3,	sidtooldata2.ini, 偵測喝水數據, 藥劑按鍵3
IniWrite,	% 藥劑按鍵4,	sidtooldata2.ini, 偵測喝水數據, 藥劑按鍵4
IniWrite,	% 偵測喝水間隔,	sidtooldata2.ini, 偵測喝水數據, 偵測喝水間隔
}
if 當前角色配置 = 3
{
IniWrite,	% 藥劑按鍵1,	sidtooldata3.ini, 偵測喝水數據, 藥劑按鍵1
IniWrite,	% 藥劑按鍵2,	sidtooldata3.ini, 偵測喝水數據, 藥劑按鍵2
IniWrite,	% 藥劑按鍵3,	sidtooldata3.ini, 偵測喝水數據, 藥劑按鍵3
IniWrite,	% 藥劑按鍵4,	sidtooldata3.ini, 偵測喝水數據, 藥劑按鍵4
IniWrite,	% 偵測喝水間隔,	sidtooldata3.ini, 偵測喝水數據, 偵測喝水間隔
}
Return

讀取偵測喝水數據:
if 當前角色配置 = 1
{
 Iniread,	藥劑按鍵1,	sidtooldata.ini, 偵測喝水數據, 藥劑按鍵1
 Iniread,	藥劑按鍵2,	sidtooldata.ini, 偵測喝水數據, 藥劑按鍵2
 Iniread,	藥劑按鍵3,	sidtooldata.ini, 偵測喝水數據, 藥劑按鍵3
 Iniread,	藥劑按鍵4,	sidtooldata.ini, 偵測喝水數據, 藥劑按鍵4
 Iniread,	偵測喝水間隔,	sidtooldata.ini, 偵測喝水數據, 偵測喝水間隔
}
if 當前角色配置 = 2
{
 Iniread,	藥劑按鍵1,	sidtooldata2.ini, 偵測喝水數據, 藥劑按鍵1
 Iniread,	藥劑按鍵2,	sidtooldata2.ini, 偵測喝水數據, 藥劑按鍵2
 Iniread,	藥劑按鍵3,	sidtooldata2.ini, 偵測喝水數據, 藥劑按鍵3
 Iniread,	藥劑按鍵4,	sidtooldata2.ini, 偵測喝水數據, 藥劑按鍵4
 Iniread,	偵測喝水間隔,	sidtooldata2.ini, 偵測喝水數據, 偵測喝水間隔
}
if 當前角色配置 = 3
{
 Iniread,	藥劑按鍵1,	sidtooldata3.ini, 偵測喝水數據, 藥劑按鍵1
 Iniread,	藥劑按鍵2,	sidtooldata3.ini, 偵測喝水數據, 藥劑按鍵2
 Iniread,	藥劑按鍵3,	sidtooldata3.ini, 偵測喝水數據, 藥劑按鍵3
 Iniread,	藥劑按鍵4,	sidtooldata3.ini, 偵測喝水數據, 藥劑按鍵4
 Iniread,	偵測喝水間隔,	sidtooldata3.ini, 偵測喝水數據, 偵測喝水間隔
}
Return

;[高級喝水模式切換按鍵]----------------------------------------------------------
~F10::
(Autodrinkbutton = 0 ? (Autodrinkbutton := 1,ToolTip("已開啟高級喝水模式")) : (Autodrinkbutton := 0,ToolTip("已關閉高級喝水模式")))
if Autodrinkbutton = 0
	{
	iniWrite,關閉, sidtooldata.ini, 高級喝水狀態, 高級喝水狀態
	iniread,高級喝水狀態, sidtooldata.ini, 高級喝水狀態, 高級喝水狀態
	gosub,暫停讀秒循環喝水
	gosub,停止循環偵測
	return
	}
if Autodrinkbutton = 1
	{
	if (顏色4_X = "error" or 顏色4_Y = "error")
		{
		Autodrinkbutton := 0
		msgbox,16,錯誤,尚未設置場景偵測點(按下確認後將彈跳教學圖片)!`r已先自動關閉F10高級喝水模式!
		run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/1163223583_2.png,,UseErrorLevel
		return
		}
	gosub,座標顏色讀取
	if 偵測血條返角打勾紀錄 = +checked
	settimer,偵測血條返角,21
	if 偵測血條穿透返角打勾紀錄 = +checked
	settimer,偵測混傷穿透血條返角,23,-1
	if 偵測血條喝水打勾紀錄 = +checked
	settimer,偵測血條,31,-1
	if 偵測魔球喝水打勾紀錄 = +checked
	settimer,偵測魔力球,51,-1
	if 偵測血條穿透打勾紀錄 = +checked
	settimer,偵測混傷穿透血條,37,-1
	if 偵測血球池打勾紀錄 = +checked
	settimer,偵測血球,41,-1
	settimer,偵測場景變化,57,-1
	}
return

;[偵測區(血/魔/場景)]---------------------------------------------------------------------------------------------------

偵測血條:
IfWinActive,Path of Exile
{
if (偵測血條喝水打勾紀錄 = "+Checked" and Autodrinkbutton = "1")
 {
   if (顏色1_Y = "error" or 藥劑按鍵1 = "error")
   {
   Autodrinkbutton := 0
   gosub,停止循環偵測
   ToolTip("已關閉高級喝水模式")
   msgbox,16,錯誤,尚未設置偵測頭上血條座標或需要喝的藥劑，已自動關閉高級喝水功能[F10]。`r (Win + Z) 呼叫菜單 => 偵測喝水設置面板 => 設定藥劑與間隔。`r設置偵測血條座標 => 使用正火燒乾血量後[Win + C]抓取代號 " 1 " 。
   return
   }
   else
   {
	PixelGetColor,血量黑條, %顏色1_X%, %顏色1_Y%
	if 血量黑條 = %顏色1_C%
	{
		if ToolTipOff = 0
		ToolTip("偵測人物上方血條，偵測到需要喝第 " . 藥劑按鍵1 . " 罐藥劑")
		if Toolbutton = 0
		{
		send %藥劑按鍵1%
		sleep %偵測喝水間隔%
		}
	}
   }
 }
}
return


偵測血條返角:
IfWinActive,Path of Exile
{
if (偵測血條返角打勾紀錄 = "+Checked" and Autodrinkbutton = "1")
   {
    if 顏色2_Y = "error"
    {
   	Autodrinkbutton := 0
   	gosub,停止循環偵測
   	ToolTip("已關閉高級喝水模式")
   	msgbox,16,錯誤,尚未設置殘血返角之頭上血條座標，已自動關閉高級喝水功能[F10]。`r(Win + Z) 呼叫菜單 => 偵測喝水設置面板 => 若無使用可關閉功能。`r設置偵測血條座標 => 使用正火燒乾血量後[Win + C]抓取代號 " 2 " 。
   	return
    }
    else
    {
	PixelGetColor,血量黑條2, %顏色2_X%, %顏色2_Y%
	if 偵測血球池打勾紀錄 = +checked
	{
		if 血球池 = %顏色9_C%
		{

		}
		else
		{
   			if 血量黑條2 = %顏色2_C%
				{
					if ToolTipOff = 0
					ToolTip("偵測人物上方血條與血球池，皆過低返回角色")
					Critical
					if Toolbutton = 0
					gosub,返角
				}
		}
	}
	else
	{
		if 血量黑條2 = %顏色2_C%
		{
			if ToolTipOff = 0
			ToolTip("偵測人物上方血條，血量過低返回角色")
			Critical
			if Toolbutton = 0
			gosub,返角
		}
	}
    }
   }
}
return


偵測魔力球:
IfWinActive,Path of Exile
{
if (偵測魔球喝水打勾紀錄 = "+Checked" and Autodrinkbutton = "1")
 {
   if (顏色3_Y = "error" or 藥劑按鍵2 = "error")
   {
   Autodrinkbutton := 0
   gosub,停止循環偵測
   ToolTip("已關閉高級喝水模式")
   msgbox,16,錯誤,尚未設置偵測右下魔力池座標或需要喝的藥劑，已自動關閉高級喝水功能[F10]。`r(Win + Z) 呼叫菜單 => 偵測喝水設置面板 => 設定藥劑與間隔，若無使用可關閉功能。`r設置偵測魔球座標 => 指定右下魔力球低於滑鼠當前座標時喝水[Win + C]抓取代號 " 3 " 。
   return
   }
   else
   {
	PixelGetColor,魔力池, %顏色3_X%, %顏色3_Y%
	if 魔力池 = %顏色3_C%
	{
	}
	else
	{
	if 偵測場景顏色 = 穩定
	   {
		PixelGetColor,魔力池, %顏色3_X%, %顏色3_Y%
		if 魔力池 = %顏色3_C%
		{
		}
		else
		{
		if ToolTipOff = 0
		ToolTip("偵測右下魔球，偵測到需要喝第 " . 藥劑按鍵2 . " 罐藥劑")
			if Toolbutton = 0
			{
			send %藥劑按鍵2%
			sleep %偵測喝水間隔%
			}
		}
	   }
	}
   }
 }
}
return

偵測混傷穿透血條:
IfWinActive,Path of Exile
{
if (偵測血條穿透打勾紀錄 = "+Checked" and Autodrinkbutton = "1")
 {
   if (顏色7_Y = "error" or 藥劑按鍵3 = "error")
   {
   Autodrinkbutton := 0
   gosub,停止循環偵測
   ToolTip("已關閉高級喝水模式")
   msgbox,16,錯誤,尚未設置混傷穿透頭上血條座標或需要喝的藥劑，已自動關閉高級喝水功能[F10]。`r (Win + Z) 呼叫菜單 => 偵測喝水設置面板 => 設定藥劑與間隔。`r設置偵測血條座標 => 使用正火燒乾血量後滿ES狀態[Win + C]抓取代號 " 7 " 。
   return
   }
   else
   {
	PixelGetColor,血量黑條3, %顏色7_X%, %顏色7_Y%
	if 血量黑條3 = %顏色7_C%
	{
		if ToolTipOff = 0
		ToolTip("偵測人物上方血條承受混傷，偵測到需要喝第 " . 藥劑按鍵3 . " 罐藥劑")
		if Toolbutton = 0
		{
		send %藥劑按鍵3%
		sleep %偵測喝水間隔%
		}
	}
   }
 }
}
return

偵測混傷穿透血條返角:
IfWinActive,Path of Exile
{
if (偵測血條穿透返角打勾紀錄 = "+Checked" and Autodrinkbutton = "1")
   {
    if 顏色8_Y = "error"
    {
   	Autodrinkbutton := 0
   	gosub,停止循環偵測
   	ToolTip("已關閉高級喝水模式")
   	msgbox,16,錯誤,尚未設置混傷穿透殘血返角之頭上血條座標，已自動關閉高級喝水功能[F10]。`r(Win + Z) 呼叫菜單 => 偵測喝水設置面板 => 若無使用可關閉功能。`r設置偵測血條座標 => 使用正火燒乾血量後滿ES狀態[Win + C]抓取代號 " 8 " 。
   	return
    }
    else
    {
	PixelGetColor,血量黑條4, %顏色8_X%, %顏色8_Y%
	if 偵測血球池打勾紀錄 = +checked
	{
		if 血球池 = %顏色9_C%
		{

		}
		else
		{
   			if 血量黑條4 = %顏色8_C%
				{
					if ToolTipOff = 0
					ToolTip("混傷穿透護盾頭上血條與血球池，血量皆過低返回角色")
					Critical
					if Toolbutton = 0
					gosub,返角
				}
		}
	}
	else
	{
		if 血量黑條4 = %顏色8_C%
		{
			if ToolTipOff = 0
			ToolTip("混傷穿透護盾，頭上血條過低返回角色")
			Critical
			if Toolbutton = 0
			gosub,返角
		}
	}
    }
   }
}
return

偵測血球:
IfWinActive,Path of Exile
{
if (偵測血球池打勾紀錄 = "+checked" and Autodrinkbutton = "1")
 {
   if (顏色9_Y = "error" or 藥劑按鍵4 = "error")
   {
   Autodrinkbutton := 0
   gosub,停止循環偵測
   ToolTip("已關閉高級喝水模式")
   msgbox,16,錯誤,尚未設置偵測血球池座標與需要喝的藥劑，已自動關閉高級喝水功能[F10]。`r高級喝水設置 => 偵測自動喝水 => 設定損血時需要的藥劑。`r設置偵測血球池座標 => [Win + C]抓取代號 " 9 " 。
   return
   }
   else
   {
	PixelGetColor,血球池, %顏色9_X%, %顏色9_Y%
	if 血球池 = %顏色9_C%
	{
	}
	else
	{
	if 偵測場景顏色 = 穩定
	   {
		PixelGetColor,血球池, %顏色9_X%, %顏色9_Y%
		if 血球池 = %顏色9_C%
		{
		}
		else if Toolbutton = 0
		{
		if ToolTipOff = 0
		ToolTip("偵測左下血球，偵測到需要喝第 " . 藥劑按鍵4 . " 罐藥劑")
		send %藥劑按鍵4%
		sleep %偵測喝水間隔%
		}
	   }
	}
   }
 }
}
return

偵測場景變化:
IfWinActive,Path of Exile
 {
 if Autodrinkbutton = 1
  {
   ; 設定容許度（0-255），數值越大容許範圍越寬，這裡先設 10
   容許度 := 25 
   
   ; 利用 PixelSearch 搜尋同一個點，並加入容許度與 RGB 模式
   PixelSearch, FoundX, FoundY, 顏色4_X, 顏色4_Y, 顏色4_X, 顏色4_Y, %顏色4_C%, %容許度%, RGB
   
   ; ErrorLevel = 0 代表顏色在容許範圍內（場景沒變）
   if (ErrorLevel = 0)
	{
	if 偵測場景顏色 = 變化中
	   {
	   偵測場景顏色 = 中繼
	   sleep 1000
	   偵測場景顏色 = 穩定
	   }
	if 偵測場景顏色 = 穩定
	   {
	   偵測場景顏色 = 穩定
	   }
	}
    else ; ErrorLevel = 1 代表顏色超出容許範圍（場景改變了）
	{
	gosub,暫停讀秒循環喝水
	Toolbutton := 0
	openI := 0
	偵測場景顏色 = 變化中
	ToolTip("切換場景中，已暫停部分循環(若持續顯示請 Win + C 重設)")
	當前倉庫頁 = 0
	}
  }
}
return


;[偵測點設置區 ( Win + C )]-----------------------------------------------------------------------------------
#c::
MouseGetPos, thisPosX, thisPosY
PixelGetColor, colorabc, %thisPosX%, %thisPosY%
PosX := ["顏色1_X","顏色2_X","顏色3_X","顏色4_X","顏色5_X","顏色6_X","顏色7_X","顏色8_X","顏色9_X"]
PosY := ["顏色1_Y","顏色2_Y","顏色3_Y","顏色4_Y","顏色5_Y","顏色6_Y","顏色7_Y","顏色8_Y","顏色9_Y"]
CosA := ["顏色1_C","顏色2_C","顏色3_C","顏色4_C","顏色5_C","顏色6_C","顏色7_C","顏色8_C","顏色9_C"]
InputBox, ColorID,偵測點記錄工具, 顏色編號 [ %colorabc% ] ，座標 [ %thisPosX% `, %thisPosY% ]`r`r1 = 人物上方血條偵測點 (抓取沒血的顏色)`r2 = 人物上方血條返角偵測點 (抓取沒血的顏色)`r3 = 右下魔力球偵測點 (抓取滿魔的顏色)`r4 = 左下藥劑欄上方"時間"任意黑色域`r5 = Enter對話框(1)黑色域`r6 = Enter對話框(2)黑色域 (先開啟資訊後位移的對話框)`r7 = 人物上方混傷穿透ES的血條偵測點`r8 = 人物上方混傷穿透ES的血條返角偵測點`r9 = 左下血球池的偵測點 (抓取滿血的顏色)`r`r請依指示輸入對應的座標代號... ( 1 ~ 9 ),,410,350
	if not ErrorLevel
	{
		checkColorID := RegExMatch(ColorID, "[1-9]$")
		if checkColorID = 1
		{
		 if 當前角色配置 = 1
		 {
		 iniWrite,% thisPosX, sidtooldata.ini, 顏色座標, % PosX[ColorID]
		 iniWrite,% thisPosY, sidtooldata.ini, 顏色座標, % PosY[ColorID]
		 iniwrite,% colorabc, sidtooldata.ini, 顏色座標, % CosA[ColorID]
		 }
		 if 當前角色配置 = 2
		 {
		 iniWrite,% thisPosX, sidtooldata2.ini, 顏色座標, % PosX[ColorID]
		 iniWrite,% thisPosY, sidtooldata2.ini, 顏色座標, % PosY[ColorID]
		 iniwrite,% colorabc, sidtooldata2.ini, 顏色座標, % CosA[ColorID]
		 }
		 if 當前角色配置 = 3
		 {
		 iniWrite,% thisPosX, sidtooldata3.ini, 顏色座標, % PosX[ColorID]
		 iniWrite,% thisPosY, sidtooldata3.ini, 顏色座標, % PosY[ColorID]
		 iniwrite,% colorabc, sidtooldata3.ini, 顏色座標, % CosA[ColorID]
		 }
		}
		else
		{
		MsgBox,16,錯誤,請輸入正確的代號( 1 ~ 9 )
		}
		gosub,座標顏色讀取
	}

		return

座標顏色讀取:
if 當前角色配置 = 1
{
 loop,9
 {
 IniRead,顏色%A_Index%_X,sidtooldata.ini,顏色座標,顏色%A_Index%_X
 IniRead,顏色%A_Index%_Y,sidtooldata.ini,顏色座標,顏色%A_Index%_Y
 IniRead,顏色%A_Index%_C,sidtooldata.ini,顏色座標,顏色%A_Index%_C
 }
}
if 當前角色配置 = 2
{
 loop,9
 {
 IniRead,顏色%A_Index%_X,sidtooldata2.ini,顏色座標,顏色%A_Index%_X
 IniRead,顏色%A_Index%_Y,sidtooldata2.ini,顏色座標,顏色%A_Index%_Y
 IniRead,顏色%A_Index%_C,sidtooldata2.ini,顏色座標,顏色%A_Index%_C
 }
}
if 當前角色配置 = 3
{
 loop,9
 {
 IniRead,顏色%A_Index%_X,sidtooldata3.ini,顏色座標,顏色%A_Index%_X
 IniRead,顏色%A_Index%_Y,sidtooldata3.ini,顏色座標,顏色%A_Index%_Y
 IniRead,顏色%A_Index%_C,sidtooldata3.ini,顏色座標,顏色%A_Index%_C
 }
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
if Toolbutton = 1
{
settimer,偵測對話框1,25
settimer,偵測對話框2,25
}
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
if Toolbutton = 1
{
settimer,偵測對話框1,25
settimer,偵測對話框2,25
}
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
if Toolbutton = 1
{
settimer,偵測對話框1,25
settimer,偵測對話框2,25
}
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
if Toolbutton = 1
{
settimer,偵測對話框1,25
settimer,偵測對話框2,25
}
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
if Toolbutton = 1
{
settimer,偵測對話框1,25
settimer,偵測對話框2,25
}
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

;[技能連段設置GUI面板]-------------------------------------------------------------------------------------------------

技能連段設置GUI面板:
Gui,技能連段設置:NEW,,技能連段設置:
Gui +Label技能連段設置 -Resize  -MinimizeBox -MaximizeBox
Gui Font, cBlack
Gui Color, 0xFF80C0
Gui Font, s10 cBlue
Gui Add, Text, x5 y5 w80 h25, 技能連段功能
Gui Add, DropDownList, v技能連段功能 x90 y2 w60 -Theme, %技能連段功能%||開啟|關閉|
Gui Add, Text, x5 y30 w40 h25, 當使用
Gui Add, DropDownList, v技1 x50 y25 w60 -Theme, %技1%||Q|W|E|R|T|
Gui Add, Text, x115 y30 w70 h25, 技能時延遲
Gui Add, Edit, v技1延遲 x186 y25 w80 h20, %技1延遲%
Gui Add, Text, x270 y30 w80 h25, (毫秒)後按下
Gui Add, DropDownList, v技2 x350 y25 w60 -Theme, %技2%||Q|W|E|R|T|Off|
Gui Add, Text, x414 y30 w70 h25, 技能時延遲
Gui Add, Edit, v技2延遲 x485 y25 w80 h20 -Theme, %技2延遲%
Gui Add, Text, x568 y30 w80 h25, (毫秒)後按下
Gui Add, DropDownList, v技3 x650 y25 w60 -Theme, %技3%||Q|W|E|R|T|Off|
Gui Font
Gui Add, Button,  g儲存並讀取技能連段數據 x5 y55 w706 h20, 儲存並關閉
Gui Show, w720 h82, 技能連段設置(此功能只在[F10]高級模式下運作)
Return

技能連段設置Escape:
技能連段設置Close:
Msgbox,4,提醒視窗,您尚未儲存設定，確定是否要直接關閉?(是 或 否)
IfMsgBox No
	Return
Else
	Gui,submit
Return

;[技能連段GUI儲存指令]-------------------------------------------------------------------------------------------------

儲存並讀取技能連段數據:
Gui,submit
if 當前角色配置 = 1
{
iniWrite,% 技1		, sidtooldata.ini, 連段設置, 技1
iniWrite,% 技2		, sidtooldata.ini, 連段設置, 技2
iniWrite,% 技3		, sidtooldata.ini, 連段設置, 技3
iniWrite,% 技1延遲	, sidtooldata.ini, 連段設置, 技1延遲
iniWrite,% 技2延遲	, sidtooldata.ini, 連段設置, 技2延遲
iniWrite,% 技能連段功能	, sidtooldata.ini, 連段設置, 技能連段功能
IniRead, 技1		, sidtooldata.ini, 連段設置, 技1
IniRead, 技2		, sidtooldata.ini, 連段設置, 技2
IniRead, 技3		, sidtooldata.ini, 連段設置, 技3
IniRead, 技1延遲	, sidtooldata.ini, 連段設置, 技1延遲
IniRead, 技2延遲	, sidtooldata.ini, 連段設置, 技2延遲
IniRead, 技能連段功能	, sidtooldata.ini, 連段設置, 技能連段功能
}
if 當前角色配置 = 2
{
iniWrite,% 技1		, sidtooldata2.ini, 連段設置, 技1
iniWrite,% 技2		, sidtooldata2.ini, 連段設置, 技2
iniWrite,% 技3		, sidtooldata2.ini, 連段設置, 技3
iniWrite,% 技1延遲	, sidtooldata2.ini, 連段設置, 技1延遲
iniWrite,% 技2延遲	, sidtooldata2.ini, 連段設置, 技2延遲
iniWrite,% 技能連段功能	, sidtooldata2.ini, 連段設置, 技能連段功能
IniRead, 技1		, sidtooldata2.ini, 連段設置, 技1
IniRead, 技2		, sidtooldata2.ini, 連段設置, 技2
IniRead, 技3		, sidtooldata2.ini, 連段設置, 技3
IniRead, 技1延遲	, sidtooldata2.ini, 連段設置, 技1延遲
IniRead, 技2延遲	, sidtooldata2.ini, 連段設置, 技2延遲
IniRead, 技能連段功能	, sidtooldata2.ini, 連段設置, 技能連段功能
}
if 當前角色配置 = 3
{
iniWrite,% 技1		, sidtooldata3.ini, 連段設置, 技1
iniWrite,% 技2		, sidtooldata3.ini, 連段設置, 技2
iniWrite,% 技3		, sidtooldata3.ini, 連段設置, 技3
iniWrite,% 技1延遲	, sidtooldata3.ini, 連段設置, 技1延遲
iniWrite,% 技2延遲	, sidtooldata3.ini, 連段設置, 技2延遲
iniWrite,% 技能連段功能	, sidtooldata3.ini, 連段設置, 技能連段功能
IniRead, 技1		, sidtooldata3.ini, 連段設置, 技1
IniRead, 技2		, sidtooldata3.ini, 連段設置, 技2
IniRead, 技3		, sidtooldata3.ini, 連段設置, 技3
IniRead, 技1延遲	, sidtooldata3.ini, 連段設置, 技1延遲
IniRead, 技2延遲	, sidtooldata3.ini, 連段設置, 技2延遲
IniRead, 技能連段功能	, sidtooldata3.ini, 連段設置, 技能連段功能
}
Return

讀取技能連段數據:
if 當前角色配置 = 1
{
IniRead, 技1		, sidtooldata.ini, 連段設置, 技1
IniRead, 技2		, sidtooldata.ini, 連段設置, 技2
IniRead, 技3		, sidtooldata.ini, 連段設置, 技3
IniRead, 技1延遲	, sidtooldata.ini, 連段設置, 技1延遲
IniRead, 技2延遲	, sidtooldata.ini, 連段設置, 技2延遲
IniRead, 技能連段功能	, sidtooldata.ini, 連段設置, 技能連段功能
}
if 當前角色配置 = 2
{
IniRead, 技1		, sidtooldata2.ini, 連段設置, 技1
IniRead, 技2		, sidtooldata2.ini, 連段設置, 技2
IniRead, 技3		, sidtooldata2.ini, 連段設置, 技3
IniRead, 技1延遲	, sidtooldata2.ini, 連段設置, 技1延遲
IniRead, 技2延遲	, sidtooldata2.ini, 連段設置, 技2延遲
IniRead, 技能連段功能	, sidtooldata2.ini, 連段設置, 技能連段功能
}
if 當前角色配置 = 3
{
IniRead, 技1		, sidtooldata3.ini, 連段設置, 技1
IniRead, 技2		, sidtooldata3.ini, 連段設置, 技2
IniRead, 技3		, sidtooldata3.ini, 連段設置, 技3
IniRead, 技1延遲	, sidtooldata3.ini, 連段設置, 技1延遲
IniRead, 技2延遲	, sidtooldata3.ini, 連段設置, 技2延遲
IniRead, 技能連段功能	, sidtooldata3.ini, 連段設置, 技能連段功能
}
Return

;[自動引爆地雷設置GUI面板]--------------------------------------------------------------------------------------

自動引爆地雷設置GUI面板:
Gui 自動引爆地雷設置: New,,自動引爆地雷設置
Gui +Label自動引爆地雷設置 -Resize  -MinimizeBox -MaximizeBox
Gui Font, s12 cRed
Gui Add, Text, x15 y10 w100 h20, 自動引爆地雷
Gui Add, Text, x180 y10 w100 h20, 地雷杖模式
Gui Add, Button,g儲存並讀取地雷設置 x15 y101 w539 h23, 儲存並關閉
Gui Font
Gui Add, ComboBox, v地雷模式 x118 y9 w60 -Theme, 開啟|關閉|%地雷模式%||
Gui Add, ComboBox, v地雷杖模式 x264 y9 w60 -Theme, 開啟|關閉|%地雷杖模式%||
Gui Add, ComboBox, v地雷按鍵 x103 y39 w41 -Theme, Q|W|E|R|T|%地雷按鍵%||
Gui Add, ComboBox, v引爆延遲1 x264 y37 w46 -Theme, 50|100|200|300|400|500|%引爆延遲1%||
Gui Add, ComboBox, v煙霧地雷 x103 y69 w41 -Theme, Q|W|E|R|T|%煙霧地雷%||
Gui Add, ComboBox, v引爆延遲2 x264 y69 w46 -Theme, 50|100|200|300|400|500|%引爆延遲2%||
Gui Font, s12
Gui Add, Text, x15 y40 w86 h20, 當使用按鍵
Gui Add, Text, x147 y40 w115 h20, 地雷技能時延遲
Gui Add, Text, x314 y40 w243 h20, (毫秒)後自動引爆地雷(遊戲預設D)
Gui Add, Text, x15 y70 w86 h20, 當使用按鍵
Gui Add, Text, x147 y70 w115 h20, 煙霧地雷時延遲
Gui Add, Text, x314 y70 w243 h20, (毫秒)後自動引爆地雷(遊戲預設D)
Gui Font
Gui Add, StatusBar,, ▲ 工具小知識: 自動引爆地雷是使用遊戲預設按鍵[D]來執行的。
Gui Show, w570 h156, 自動引爆地雷設置
Return

自動引爆地雷設置Escape:
自動引爆地雷設置Close:
Msgbox,4,提醒視窗,您尚未儲存設定，確定是否要直接關閉?(是 或 否)
IfMsgBox No
	Return
Else
	Gui,submit
Return

;[自動引爆地雷GUI儲存指令]--------------------------------------------------------------------------------------

儲存並讀取地雷設置:
Gui,submit
if 當前角色配置 = 1
{
iniWrite,% 地雷模式,	sidtooldata.ini, 地雷設置, 地雷模式
iniWrite,% 地雷杖模式,	sidtooldata.ini, 地雷設置, 地雷杖模式
iniWrite,% 地雷按鍵,	sidtooldata.ini, 地雷設置, 地雷按鍵
iniWrite,% 引爆延遲1,	sidtooldata.ini, 地雷設置, 引爆延遲1
iniWrite,% 煙霧地雷,	sidtooldata.ini, 地雷設置, 煙霧地雷
iniWrite,% 引爆延遲2,	sidtooldata.ini, 地雷設置, 引爆延遲2
IniRead, 地雷模式,	sidtooldata.ini, 地雷設置, 地雷模式
IniRead,地雷杖模式,	sidtooldata.ini, 地雷設置, 地雷杖模式
IniRead, 地雷按鍵,	sidtooldata.ini, 地雷設置, 地雷按鍵
IniRead, 引爆延遲1,	sidtooldata.ini, 地雷設置, 引爆延遲1
IniRead, 煙霧地雷,	sidtooldata.ini, 地雷設置, 煙霧地雷
IniRead, 引爆延遲2,	sidtooldata.ini, 地雷設置, 引爆延遲2
}
if 當前角色配置 = 2
{
iniWrite,% 地雷模式,	sidtooldata2.ini, 地雷設置, 地雷模式
iniWrite,% 地雷杖模式,	sidtooldata.ini, 地雷設置, 地雷杖模式
iniWrite,% 地雷按鍵,	sidtooldata2.ini, 地雷設置, 地雷按鍵
iniWrite,% 引爆延遲1,	sidtooldata2.ini, 地雷設置, 引爆延遲1
iniWrite,% 煙霧地雷,	sidtooldata2.ini, 地雷設置, 煙霧地雷
iniWrite,% 引爆延遲2,	sidtooldata2.ini, 地雷設置, 引爆延遲2
IniRead, 地雷模式,	sidtooldata2.ini, 地雷設置, 地雷模式
IniRead,地雷杖模式,	sidtooldata.ini, 地雷設置, 地雷杖模式
IniRead, 地雷按鍵,	sidtooldata2.ini, 地雷設置, 地雷按鍵
IniRead, 引爆延遲1,	sidtooldata2.ini, 地雷設置, 引爆延遲1
IniRead, 煙霧地雷,	sidtooldata2.ini, 地雷設置, 煙霧地雷
IniRead, 引爆延遲2,	sidtooldata2.ini, 地雷設置, 引爆延遲2
}
if 當前角色配置 = 3
{
iniWrite,% 地雷模式,	sidtooldata3.ini, 地雷設置, 地雷模式
iniWrite,% 地雷杖模式,	sidtooldata.ini, 地雷設置, 地雷杖模式
iniWrite,% 地雷按鍵,	sidtooldata3.ini, 地雷設置, 地雷按鍵
iniWrite,% 引爆延遲1,	sidtooldata3.ini, 地雷設置, 引爆延遲1
iniWrite,% 煙霧地雷,	sidtooldata3.ini, 地雷設置, 煙霧地雷
iniWrite,% 引爆延遲2,	sidtooldata3.ini, 地雷設置, 引爆延遲2
IniRead, 地雷模式,	sidtooldata3.ini, 地雷設置, 地雷模式
IniRead,地雷杖模式,	sidtooldata.ini, 地雷設置, 地雷杖模式
IniRead, 地雷按鍵,	sidtooldata3.ini, 地雷設置, 地雷按鍵
IniRead, 引爆延遲1,	sidtooldata3.ini, 地雷設置, 引爆延遲1
IniRead, 煙霧地雷,	sidtooldata3.ini, 地雷設置, 煙霧地雷
IniRead, 引爆延遲2,	sidtooldata3.ini, 地雷設置, 引爆延遲2
}
Return

讀取地雷設置:
if 當前角色配置 = 1
{
IniRead, 地雷模式,	sidtooldata.ini, 地雷設置, 地雷模式
IniRead,地雷杖模式,	sidtooldata.ini, 地雷設置, 地雷杖模式
IniRead, 地雷按鍵,	sidtooldata.ini, 地雷設置, 地雷按鍵
IniRead, 引爆延遲1,	sidtooldata.ini, 地雷設置, 引爆延遲1
IniRead, 煙霧地雷,	sidtooldata.ini, 地雷設置, 煙霧地雷
IniRead, 引爆延遲2,	sidtooldata.ini, 地雷設置, 引爆延遲2
}
if 當前角色配置 = 2
{
IniRead, 地雷模式,	sidtooldata2.ini, 地雷設置, 地雷模式
IniRead,地雷杖模式,	sidtooldata.ini, 地雷設置, 地雷杖模式
IniRead, 地雷按鍵,	sidtooldata2.ini, 地雷設置, 地雷按鍵
IniRead, 引爆延遲1,	sidtooldata2.ini, 地雷設置, 引爆延遲1
IniRead, 煙霧地雷,	sidtooldata2.ini, 地雷設置, 煙霧地雷
IniRead, 引爆延遲2,	sidtooldata2.ini, 地雷設置, 引爆延遲2
}
if 當前角色配置 = 3
{
IniRead, 地雷模式,	sidtooldata3.ini, 地雷設置, 地雷模式
IniRead,地雷杖模式,	sidtooldata.ini, 地雷設置, 地雷杖模式
IniRead, 地雷按鍵,	sidtooldata3.ini, 地雷設置, 地雷按鍵
IniRead, 引爆延遲1,	sidtooldata3.ini, 地雷設置, 引爆延遲1
IniRead, 煙霧地雷,	sidtooldata3.ini, 地雷設置, 煙霧地雷
IniRead, 引爆延遲2,	sidtooldata3.ini, 地雷設置, 引爆延遲2
}
Return

;[快搜倉庫頁區(熱鍵)]---------------------------------------------------------------------------------

快捷切換倉庫頁設置:
gosub,倉庫頁快搜工具視窗
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
ClipWait, 1
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

;[快搜倉庫頁設置GUI面板]----------------------------------------------------------------------------------------------------------------

倉庫頁快搜工具視窗:
Gui 倉庫頁快搜工具: New,,快搜倉庫頁設置(Ctrl + Alt 自動翻頁，Ctrl + Win 返回首頁)
Gui +Label倉庫頁快搜工具 -Resize  -MinimizeBox -MaximizeBox
Gui Color, 0x00FFFF
Gui Add, Text, x79 y32 w46 h0 +0x200, Text
Gui Font
Gui Font, s10 Bold cRed
Gui Add, Text, x7 y6 w526 h23 +0x200, 通貨頁擺至首頁，代碼舉例:首頁= 0，第二頁 = 1，以此類推。
Gui Font
Gui Font, s13 Norm cRed
Gui, Add, Link, x390 y40 w140 h30, 影片介紹<a href="https://youtu.be/StpFz8qbB44">點我</a>
Gui Font
Gui Font, s10 Norm cBlue
Gui Add, Text, x4 y40 w50 h20, % " 附魔裝 :"
Gui Add, Text, x4 y65 w50 h20, % " 傳奇裝 :"
Gui Add, Text, x4 y90 w50 h20, % " 傳奇戒 :"
Gui Add, Text, x4 y115 w50 h20, % " 劫盜裝 :"
Gui Add, Text, x4 y140 w50 h20, % " 待新增 :"
Gui Add, Text, x4 y165 w50 h20, % " 培育器 :"
Gui Add, Text, x4 y190 w50 h20, % " 深淵珠 :"
Gui Add, Text, x4 y215 w50 h20, % " 星團珠 :"
Gui Add, Text, x4 y240 w50 h20, % " 普通珠 :"
Gui Add, Text, x100 y40 w130 h20,  % " (未鑑定)稀有頭盔 :"
Gui Add, Text, x100 y65 w130 h20,  % " (未鑑定)稀有衣服 :"
Gui Add, Text, x100 y90 w130 h20,  % " (未鑑定)稀有腰帶 :"
Gui Add, Text, x100 y115 w130 h20, % " (未鑑定)稀有手套 :"
Gui Add, Text, x100 y140 w130 h20, % " (未鑑定)稀有鞋子 :"
Gui Add, Text, x100 y165 w130 h20, % " (未鑑定)稀有飾品 :"
Gui Add, Text, x100 y190 w130 h20, % " (未鑑定)稀有武器 :"
Gui Add, Text, x100 y215 w130 h20, % " 勢力裝(不限等)頁 :"
Gui Add, Text, x100 y240 w180 h20, % " 特殊地圖(邀/尊/廟) :"
Gui Add, Text, x260 y40 w70 h20,  % " 裂痕戒指 :"
Gui Font
Gui Font, s10 cBlue
Gui Add, Text, x6 y265 w251 h25, % " [Ctrl + win] 返回首頁(輸入以上最大的頁數) :"
Gui Font
Gui Font, cRed
Gui Add, Edit, v附魔裝 x58 y35 w35 h20 +Number -Theme	,% 附魔裝
Gui Add, Edit, v傳奇裝 x58 y60 w35 h20 +Number -Theme	,% 傳奇裝
Gui Add, Edit, v傳奇戒 x58 y85 w35 h20 +Number -Theme	,% 傳奇戒
Gui Add, Edit, v劫盜裝 x58 y110 w35 h20 +Number -Theme	,% 劫盜裝
Gui Add, Edit, v移除2 x58 y135 w35 h20 +Number -Theme	,% 移除2
Gui Add, Edit, v培育器 x58 y160 w35 h20 +Number -Theme	,% 培育器
Gui Add, Edit, v深淵珠 x58 y185 w35 h20 +Number -Theme	,% 深淵珠
Gui Add, Edit, v星團珠 x58 y210 w35 h20 +Number -Theme	,% 星團珠
Gui Add, Edit, v普通珠 x58 y235 w35 h20 +Number -Theme	,% 普通珠
Gui Add, Edit, v未鑑定稀有頭盔 x220 y35 w35 h20 +Number -Theme	,% 未鑑定稀有頭盔
Gui Add, Edit, v未鑑定稀有衣服 x220 y60 w35 h20 +Number -Theme	,% 未鑑定稀有衣服
Gui Add, Edit, v未鑑定稀有腰帶 x220 y85 w35 h20 +Number -Theme	,% 未鑑定稀有腰帶
Gui Add, Edit, v未鑑定稀有手套 x220 y110 w35 h20 +Number -Theme	,% 未鑑定稀有手套
Gui Add, Edit, v未鑑定稀有鞋子 x220 y135 w35 h20 +Number -Theme	,% 未鑑定稀有鞋子
Gui Add, Edit, v未鑑定稀有飾品 x220 y160 w35 h20 +Number -Theme	,% 未鑑定稀有飾品
Gui Add, Edit, v未鑑定稀有武器 x220 y185 w35 h20 +Number -Theme	,% 未鑑定稀有武器
Gui Add, Edit, v勢力裝頁 x220 y210 w35 h20 +Number -Theme	,% 勢力裝頁
Gui Add, Edit, v特殊地圖 x220 y235 w35 h20 +Number -Theme	,% 特殊地圖
Gui Add, Edit, v裂痕戒指 x330 y35 w35 h20 +Number -Theme	,% 裂痕戒指
Gui Add, Edit, v返回頁數 x259 y261 w35 h20 +Number -Theme	,% 返回頁數
Gui Add, StatusBar,, 製作By Sid ，沒使用到的頁數請輸入 " 0 "，不要保存 Error 狀態避免工具異常。
Gui Add, Button, g儲存並讀取倉庫頁數據 x400 y261 w90 h23, 儲存並關閉
Gui Show, x697 y320 w500 h310
Return

倉庫頁快搜工具Escape:
倉庫頁快搜工具Close:
Msgbox,4,提醒視窗,您尚未儲存設定，確定是否要直接關閉?(是 或 否)
IfMsgBox No
	Return
Else
	Gui,submit
Return

;[快搜倉庫頁GUI儲存指令]----------------------------------------------------------------------------------------------------------------

儲存並讀取倉庫頁數據:
Gui,submit
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

查價工具視窗:
MouseGetPos, thisPosX, thisPosY
if 聲明顯示 = 0
{
MsgBox,64,每次開起工具僅顯示一次，關閉後請再次使用 Win + V 即可。,請記得安裝並預先開啟【rchin-poe-trade】工具，並點擊 Home 返回遊戲， Win + V 才可正常運作。`r`r如未安裝，您可在 Win + Z 菜單中找到*前往查價工具的網址*的欄位`r`r申明:此查價工具並非Sid製作，也未對此功能進行任何收費。`r`r僅抱持著推廣與分享目的提供使用，請多支持原創作者。
聲明顯示 = 1
WinActivate ,Path of Exile
return
}
if 聲明顯示 = 1
{
ToolTip("Sid工具支援查價時 [ Esc ] 快速返回 POE 視窗")
Send ^C
WinActivate ,rchin-poe-trade
}
return

;[Space空白一鍵喝水區(熱鍵)]------------------------------------------------------------------------------------------

~*space::
settimer,偵測對話框1,25
settimer,偵測對話框2,25
if Toolbutton = 0
{
	ToolTip("觸發一鍵喝水，打字誤觸建議您使用[F9]暫停工具。")
	if 一鍵喝水時觸發的藥劑 = error
	{
	msgbox,16,錯誤,尚未設定(Space)一鍵喝水所需藥劑! Win+Z => 藥劑觸發設置。
	gosub,藥劑觸發設置GUI面板
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
if (顏色5_X = "error" or 顏色5_Y = "error")
{
settimer,偵測對話框1,off
settimer,偵測對話框2,off
msgbox,16,錯誤,提醒，你是否忘記設置偵測對話框了呢?`r首次使用enter可彈跳教學圖片。`r抓取對話框非常重要，不然打字會瞎雞巴亂按熱鍵。
}
else
{
	PixelGetColor,對話框1, %顏色5_X%, %顏色5_Y%
	if 對話框1 = %顏色5_C%
	{
	Toolbutton = 1
	ToolTip("偵測到對話框1，變更為文字模式")
	gosub,暫停讀秒循環喝水
	settimer,偵測對話框1,off
	}
	else
	{
	settimer,偵測對話框1,off
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
	PixelGetColor,對話框2, %顏色6_X%, %顏色6_Y%
	if 對話框2 = %顏色6_C%
	{
	Toolbutton = 1
	ToolTip("偵測到對話框2，變更為文字模式")
	gosub,暫停讀秒循環喝水
	settimer,偵測對話框2,off
	}
	else
	{
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
		Else
		{
		send {ctrl down}
		Click
		send {ctrl up}
		sleep %滑鼠連點速度%
		}
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

;[滑鼠連點設置GUI面板]------------------------------------------------------------------------------------------------------

滑鼠連點設置GUI面板:
Gui,滑鼠連點設置:new,,滑鼠連點設置
Gui +Label滑鼠連點設置 -Resize  -MinimizeBox -MaximizeBox
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,g滑鼠滾輪觸發連點 w200 hwndHBT17 ,滑鼠滾輪按壓
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT17,BT1Options)
Gui, Add, Button,gCtrl左鍵觸發連點 w200 hwndHBT18 ,[Ctrl + 左鍵]
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT18,BT1Options)
Gui, Add, Button,g滑鼠連點速度調整 w200 hwndHBT24 ,連點速度調整
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT24,BT1Options)
Gui, font
Gui Add, StatusBar,, % "製作By Sid 當前滑鼠連點 = "連點模式 " 。 "
Gui, Show
return

滑鼠連點設置Escape:
滑鼠連點設置Close:
Gui,submit
Return

滑鼠滾輪觸發連點:
Gui,submit
連點模式 = 滑鼠滾輪按壓
IniWrite,% 連點模式, sidtooldata.ini, 按鍵模式切換, 連點模式
 Iniread, 連點模式, sidtooldata.ini, 按鍵模式切換, 連點模式
ToolTip("滑鼠連點為: " . 連點模式 . " 。 ")
Return

Ctrl左鍵觸發連點:
Gui,submit
連點模式 = [Ctrl + 左鍵]
IniWrite,% 連點模式, sidtooldata.ini, 按鍵模式切換, 連點模式
 Iniread, 連點模式, sidtooldata.ini, 按鍵模式切換, 連點模式
ToolTip("滑鼠連點為: " . 連點模式 . " 。 ")
Return

滑鼠連點速度調整:
Gui,submit
InputBox, 滑鼠連點速度,滑鼠連點速度調整, 請輸入0 ~ 50，越小越快。,,,,,,,,%滑鼠連點速度%
if 滑鼠連點速度 not between 0 and 50
{
msgbox,16,錯誤,請輸入正確的數字範圍( 0 ~ 50 )"
gosub,滑鼠連點速度調整
return
}
else
{
IniWrite,% 滑鼠連點速度, sidtooldata.ini, 按鍵模式切換, 滑鼠連點速度
 Iniread, 滑鼠連點速度, sidtooldata.ini, 按鍵模式切換, 滑鼠連點速度
}
return

讀取滑鼠連點速度:
 Iniread, 滑鼠連點速度, sidtooldata.ini, 按鍵模式切換, 滑鼠連點速度
 if 滑鼠連點速度 = error
 滑鼠連點速度 = 25
Return

讀取連點模式:
 Iniread, 連點模式, sidtooldata.ini, 按鍵模式切換, 連點模式
Return


;[PgUp/PgDn清包區(熱鍵)]------------------------------------------------------------------------------------------

PgUp::
Critical
	if (對方背包左上_X = "error" or 對方背包右下_X = "error")
	{
	msgbox,16,錯誤,尚未設定快速交易，確認對方背包60格欄位座標。`r請隨意尋找 NPC 點擊「販賣物品」打開，使用F7設定。`r確定後，將跳轉圖片教學。
	run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/editor/1029564595_2.jpg,,UseErrorLevel
		return
	}
	else
	{
	gosub,清對方背包按壓式
	return
	}
return

PgDn::
Critical
	if (接受交易_X = "error" or 接受交易_X = "error")
	{
	msgbox,16,錯誤,尚未設定快速交易，「接受」交易座標。`r請隨意尋找 NPC 點擊「販賣物品」打開，使用F7設定。`r確定後，將跳轉圖片教學。
	run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/editor/1029564595_2.jpg,,UseErrorLevel
		return
	}
	else
	{
	MouseClick, Left,接受交易_X,接受交易_Y,1,0
	return
	}
return

;[PgUp/PgDn清包區(指令)]------------------------------------------------------------------------------------------

清對方背包按壓式:
loop % 掃描水平數量2
{
	PosX := (掃描開始左上2_X+(背包每格寬2/2)) + ((背包每格寬2/2)*((A_Index-1)*2))
	if not(GetKeyState("PgUp","P"))
	return
	loop % 掃描垂直數量2
	{
		PosY := (掃描開始左上2_Y+(背包每格高2/2)) + ((背包每格高2/2)*((A_Index-1)*2))
		MouseMove, % PosX, % PosY,0
		if not(GetKeyState("PgUp","P"))
		return
	}
}
return

背包運算作業2:
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

*Insert::
(StopUser = 0 ? (StopUser := 1,ToolTip("循環技能已開啟")) : (StopUser := 0,ToolTip("循環技能已關閉")))
if (循環技能1 = "error" or 循環技能2 = "error" or 循環技能3 = "error" or 循環技能時間1 = "error" or 循環技能時間2 = "error" or 循環技能時間3 = "error")
{
  StopUser = 0
  msgbox,16,錯誤,尚未設定循環技能設置! 即將前往設置!
  Gosub,循環技能設置GUI面板
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

;[Ins循環技能設置GUI面板]------------------------------------------------------------------------------------------

循環技能設置GUI面板:
Gui,循環技能設置:new,,循環技能設置
Gui +Label循環技能設置 -Resize  -MinimizeBox -MaximizeBox
Gui Font, s10
Gui Add, Text, x2 y6 w236 h20 +0x200, 設定技能與幾豪秒使用一次(Off : 關閉)
Gui Add, Text, x10 y105 w215 h20, 儲存完成後，使用 Insert 鍵開啟循環
Gui Font
Gui Add, ComboBox, v循環技能1 x5 y30 w90, Q|W|E|R|T|%循環技能1%||
Gui Add, ComboBox, v循環技能2 x5 y55 w90, Q|W|E|R|T|%循環技能2%||
Gui Add, ComboBox, v循環技能3 x5 y80 w90, Q|W|E|R|T|%循環技能3%||
Gui Add, ComboBox, v循環技能時間1 x105 y30 w120 , Off|1000|2000|3000|4000|5000|6000|7000|8000|9000|10000|%循環技能時間1%||
Gui Add, ComboBox, v循環技能時間2 x105 y55 w120 , Off|1000|2000|3000|4000|5000|6000|7000|8000|9000|10000|%循環技能時間2%||
Gui Add, ComboBox, v循環技能時間3 x105 y80 w120 , Off|1000|2000|3000|4000|5000|6000|7000|8000|9000|10000|%循環技能時間3%||
Gui Add, Button, g儲存並讀取循環技能設置 x5 y126 w218 h23, 儲存並關閉
Gui Show, w231 h156,循環技能設置
Return

循環技能設置Escape:
循環技能設置Close:
Msgbox,4,提醒視窗,您尚未儲存設定，確定是否要直接關閉?(是 或 否)
IfMsgBox No
	Return
Else
	Gui,submit
Return

;[Ins循環技能GUI儲存指令]------------------------------------------------------------------------------------------------------

儲存並讀取循環技能設置:
Gui,submit
gosub,儲存循環技能設置
gosub,讀取循環技能設置
if StopUser = 1
{
StopUser := 0
Gosub,關閉循環技能
msgbox,48,提醒,您剛剛重新調整了設定，已自動關閉[Ins]循環使用技能。`r請重新使用熱鍵[Ins]使其生效。
}
Return

儲存循環技能設置:
if 當前角色配置 = 1
{
iniWrite,% 循環技能1,	sidtooldata.ini, 循環技能, 循環技能1
iniWrite,% 循環技能2,	sidtooldata.ini, 循環技能, 循環技能2
iniWrite,% 循環技能3,	sidtooldata.ini, 循環技能, 循環技能3
iniWrite,% 循環技能時間1, sidtooldata.ini, 循環技能, 循環技能時間1
iniWrite,% 循環技能時間2, sidtooldata.ini, 循環技能, 循環技能時間2
iniWrite,% 循環技能時間3, sidtooldata.ini, 循環技能, 循環技能時間3
}
if 當前角色配置 = 2
{
iniWrite,% 循環技能1,	sidtooldata2.ini, 循環技能, 循環技能1
iniWrite,% 循環技能2,	sidtooldata2.ini, 循環技能, 循環技能2
iniWrite,% 循環技能3,	sidtooldata2.ini, 循環技能, 循環技能3
iniWrite,% 循環技能時間1, sidtooldata2.ini, 循環技能, 循環技能時間1
iniWrite,% 循環技能時間2, sidtooldata2.ini, 循環技能, 循環技能時間2
iniWrite,% 循環技能時間3, sidtooldata2.ini, 循環技能, 循環技能時間3
}
if 當前角色配置 = 3
{
iniWrite,% 循環技能1,	sidtooldata3.ini, 循環技能, 循環技能1
iniWrite,% 循環技能2,	sidtooldata3.ini, 循環技能, 循環技能2
iniWrite,% 循環技能3,	sidtooldata3.ini, 循環技能, 循環技能3
iniWrite,% 循環技能時間1, sidtooldata3.ini, 循環技能, 循環技能時間1
iniWrite,% 循環技能時間2, sidtooldata3.ini, 循環技能, 循環技能時間2
iniWrite,% 循環技能時間3, sidtooldata3.ini, 循環技能, 循環技能時間3
}
Return

讀取循環技能設置:
if 當前角色配置 = 1
{
iniread,循環技能1 , sidtooldata.ini, 循環技能, 循環技能1
iniread,循環技能2 , sidtooldata.ini, 循環技能, 循環技能2
iniread,循環技能3 , sidtooldata.ini, 循環技能, 循環技能3
iniread,循環技能時間1 , sidtooldata.ini, 循環技能, 循環技能時間1
iniread,循環技能時間2 , sidtooldata.ini, 循環技能, 循環技能時間2
iniread,循環技能時間3 , sidtooldata.ini, 循環技能, 循環技能時間3
}
if 當前角色配置 = 2
{
iniread,循環技能1 , sidtooldata2.ini, 循環技能, 循環技能1
iniread,循環技能2 , sidtooldata2.ini, 循環技能, 循環技能2
iniread,循環技能3 , sidtooldata2.ini, 循環技能, 循環技能3
iniread,循環技能時間1 , sidtooldata2.ini, 循環技能, 循環技能時間1
iniread,循環技能時間2 , sidtooldata2.ini, 循環技能, 循環技能時間2
iniread,循環技能時間3 , sidtooldata2.ini, 循環技能, 循環技能時間3
}
if 當前角色配置 = 3
{
iniread,循環技能1 , sidtooldata3.ini, 循環技能, 循環技能1
iniread,循環技能2 , sidtooldata3.ini, 循環技能, 循環技能2
iniread,循環技能3 , sidtooldata3.ini, 循環技能, 循環技能3
iniread,循環技能時間1 , sidtooldata3.ini, 循環技能, 循環技能時間1
iniread,循環技能時間2 , sidtooldata3.ini, 循環技能, 循環技能時間2
iniread,循環技能時間3 , sidtooldata3.ini, 循環技能, 循環技能時間3
}
Return

;[Home快速交易(熱鍵)]-----------------------------------------------------------------------------------------------------------

Home::
if (快速交易提醒 = "關閉")
{
	Gosub,獲取對方id
	WinActivate ,Path of Exile
	WinWait ,Path of Exile
	Clipboard = /tradewith %移除後完好的ID%
	send {enter}
	Send ^{V}
	sleep 1
	Send {enter}
}
if 快速交易提醒 = 開啟
{
   Gosub,獲取對方id
   msgbox,4,提醒,即將交易的玩家是" %移除後完好的ID% " 確定嗎?`r按鍵[ Enter ] 立即交易，按鍵[ N ]取消。`r不需提醒可使用[Win + Home]關閉。
   IfMsgBox Yes
	{
	WinActivate ,Path of Exile
	WinWait ,Path of Exile
	Clipboard = /tradewith %移除後完好的ID%
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

#Home::
gosub,Home快速交易設定
Return

;[Home快速交易設定GUI面板]-------------------------------------------------------------------------------------------------------

Home快速交易設定:
Gui,Home快速交易設定:new,,Home快速交易設定
Gui +LabelHome快速交易設定 -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,g開啟快速交易提醒 w200 hwndHBT28 ,開啟提醒
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT28,BT1Options)
Gui, Add, Button,g關閉快速交易提醒 w200 hwndHBT29 ,關閉提醒
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT29,BT1Options)
Gui, font
Gui Add, StatusBar,, % "製作By Sid 當前交易提醒 = "快速交易提醒 " 。 "
Gui, Show
return

Home快速交易設定Escape:
Home快速交易設定Close:
Gui,submit
Return

開啟快速交易提醒:
Gui,submit
快速交易提醒 = 開啟
IniWrite,% 快速交易提醒, sidtooldata.ini, 按鍵模式切換, 快速交易提醒
 Iniread, 快速交易提醒, sidtooldata.ini, 按鍵模式切換, 快速交易提醒
ToolTip("快速交易提醒功能 = : " . 快速交易提醒 . " 。 ")
Return

關閉快速交易提醒:
Gui,submit
快速交易提醒 = 關閉
IniWrite,% 快速交易提醒, sidtooldata.ini, 按鍵模式切換, 快速交易提醒
 Iniread, 快速交易提醒, sidtooldata.ini, 按鍵模式切換, 快速交易提醒
ToolTip("快速交易提醒功能 = : " . 快速交易提醒 . " 。 ")
Return

讀取快速交易提醒功能:
 Iniread, 快速交易提醒, sidtooldata.ini, 按鍵模式切換, 快速交易提醒
Return

;[End快速組隊(熱鍵)]------------------------------------------------------------------------------------------------------------

End::
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

#End::
gosub,End快速組隊設定
Return

;[End快速組隊指令]------------------------------------------------------------------------------------------------------------

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
移除後完好的ID :=  Trim(對方ID, OmitChars := "@")
return

;[End快速組隊設定GUI面板]-------------------------------------------------------------------------------------------------

End快速組隊設定:
Gui,End快速組隊設定:new,,End快速組隊設定
Gui +LabelEnd快速組隊設定 -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,g開啟快速組隊提醒 w200 hwndHBT15 ,開啟提醒
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT15,BT1Options)
Gui, Add, Button,g關閉快速組隊提醒 w200 hwndHBT16 ,關閉提醒
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT16,BT1Options)
Gui, font
Gui Add, StatusBar,, % "製作By Sid 當前組隊提醒 = "快速組隊提醒 " 。 "
Gui, Show
return

End快速組隊設定Escape:
End快速組隊設定Close:
Gui,submit
Return

開啟快速組隊提醒:
Gui,submit
快速組隊提醒 = 開啟
IniWrite,% 快速組隊提醒, sidtooldata.ini, 按鍵模式切換, 快速組隊提醒
 Iniread, 快速組隊提醒, sidtooldata.ini, 按鍵模式切換, 快速組隊提醒
ToolTip("快速組隊提醒功能 = : " . 快速組隊提醒 . " 。 ")
Return

關閉快速組隊提醒:
Gui,submit
快速組隊提醒 = 關閉
IniWrite,% 快速組隊提醒, sidtooldata.ini, 按鍵模式切換, 快速組隊提醒
 Iniread, 快速組隊提醒, sidtooldata.ini, 按鍵模式切換, 快速組隊提醒
ToolTip("快速組隊提醒功能 = : " . 快速組隊提醒 . " 。 ")
Return

讀取快速組隊提醒功能:
 Iniread, 快速組隊提醒, sidtooldata.ini, 按鍵模式切換, 快速組隊提醒
Return

;[F1返回角色(熱鍵)]------------------------------------------------------------------------------------------------------------

*F1::
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
	send {F1}
}
return

#F1::
gosub,F1熱鍵切換
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

;[F1返回角色切換GUI面板]--------------------------------------------------------------------------------------

F1熱鍵切換:
Gui,F1熱鍵切換:new,,F1熱鍵切換
Gui +LabelF1熱鍵切換 -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,g回復原始鍵盤 w200 hwndHBT5 ,回復原始鍵盤
BT1Options:= [{BC: "99D1D3|FFFFFF", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT5,BT1Options)
Gui, Add, Button,g激活返角熱鍵 w200 hwndHBT6 ,激活返角熱鍵
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT6,BT1Options)
Gui, font
Gui Add, StatusBar,, % "製作By Sid 當前F1按鍵為 = "F1模式 " 。 "
Gui, Show
return

F1熱鍵切換Escape:
F1熱鍵切換Close:
Gui,submit
Return

回復原始鍵盤:
Gui,submit
F1模式 = 原始鍵盤模式
IniWrite,% F1模式, sidtooldata.ini, 按鍵模式切換, F1模式
 Iniread, F1模式, sidtooldata.ini, 按鍵模式切換, F1模式
ToolTip("F1按鍵已變更為: " . F1模式 . " 。 ")
Return

激活返角熱鍵:
Gui,submit
F1模式 = 返角模式
IniWrite,% F1模式, sidtooldata.ini, 按鍵模式切換, F1模式
 Iniread, F1模式, sidtooldata.ini, 按鍵模式切換, F1模式
ToolTip("F1按鍵已變更為: " . F1模式 . " 。 ")
Return

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

#F2::
gosub,回復模式及時切換
return

;[F2回復模式切換GUI面板]-------------------------------------------------------------------------------------------------------------

回復模式及時切換:
Gui,回復模式及時切換:new,,F3回復模式及時切換
Gui +Label回復模式及時切換 -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,g變更暫離 w200 hwndHBT7 ,暫離
BT1Options:= [{BC: "99D1D3|FFFFFF", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT7,BT1Options)
Gui, Add, Button,g變更勿擾 w200 hwndHBT8 ,勿擾
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT8,BT1Options)
Gui, Add, Button,g變更自動回復 w200 hwndHBT9 ,自動回復
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT9,BT1Options)
Gui, Add, Button,g設置回復內容 w200 hwndHBT10 ,設置回復內容
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT10,BT1Options)
Gui, font
Gui Add, StatusBar,, % "製作By Sid 當前F2按鍵為 = "回復模式 " 。 "
Gui, Show
return

回復模式及時切換Escape:
回復模式及時切換Close:
Gui,submit
Return

變更暫離:
Gui,submit
回復模式 = 暫離
IniWrite,% 回復模式, sidtooldata.ini, 按鍵模式切換, 回復模式
 Iniread, 回復模式, sidtooldata.ini, 按鍵模式切換, 回復模式
ToolTip("回復模式已變更為: " . 回復模式 . " 。 ")
Return

變更勿擾:
Gui,submit
回復模式 = 勿擾
IniWrite,% 回復模式, sidtooldata.ini, 按鍵模式切換, 回復模式
 Iniread, 回復模式, sidtooldata.ini, 按鍵模式切換, 回復模式
ToolTip("回復模式已變更為: " . 回復模式 . " 。 ")
Return

變更自動回復:
Gui,submit
回復模式 = 自動回復
IniWrite,% 回復模式, sidtooldata.ini, 按鍵模式切換, 回復模式
 Iniread, 回復模式, sidtooldata.ini, 按鍵模式切換, 回復模式
ToolTip("回復模式已變更為: " . 回復模式 . " 。 ")
Return

讀取回復模式:
 Iniread, 回復模式, sidtooldata.ini, 按鍵模式切換, 回復模式
Return

設置回復內容:
Gui,submit
gosub,設定自動回復
Return

設定自動回復:
Gui,設定自動回復內容:new,,設定自動回復內容
Gui +Label設定自動回復內容 -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x000000
Gui Font, s12 Bold c0xFFFFFF
Gui Add, Text, x5 y5 w100 h30 +0x200 +0x1000, ㊣自動回復:
Gui Font
Gui Font, s12 Bold
Gui Add, Edit, v自動回復內容 x110 y5 w500 h30 -VScroll,  %自動回復內容%
Gui Add, Button, g儲存自動回復內容 x615 y5 w50 h30, &儲存
Gui Font
Gui Add, StatusBar,, ▲ 工具小知識: 待定 ▲ HI!因為這邊空白太多所以我這就跳出來說點話。
Gui Show
Return

設定自動回復內容Escape:
設定自動回復內容Close:
Gui,submit
Return

儲存自動回復內容:
Gui,submit
iniWrite,% 自動回復內容, sidtooldata.ini, 設定自動回復內容, 自動回復內容
iniread, 自動回復內容, sidtooldata.ini, 設定自動回復內容, 自動回復內容
Return

讀取自動回復內容:
iniread, 自動回復內容, sidtooldata.ini, 設定自動回復內容, 自動回復內容
Return

;[F3清空背包區(熱鍵)]------------------------------------------------------------------------------------------------------------

F3::
if Toolbutton = 1
{
ToolTip("您現在是文字模式，請嘗試點擊一小段路 或 Enter")
}
else
{
Critical
	if (背包左上_X = "error" or 背包右下_X = "error")
	{
	msgbox,16,錯誤,尚未設定背包位置，請打開背包使用F7設定。
	run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/1127343908_2.png,,UseErrorLevel
	return
	}
	if 清包模式 = 按壓式
	{
	gosub,一鍵清包
	}
	if 清包模式 = 自動式
	{
	gosub,一鍵清包
	}
	if 清包模式 = 掃描式
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
	if 清包模式 = 掃描快搜翻頁
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

#F3::
gosub,背包模式及時切換
return

;[F3背包模式切換GUI面板]--------------------------------------------------------------------------------------

背包模式及時切換:
Gui,背包模式及時切換:new,,F3背包模式及時切換
Gui +Label背包模式及時切換 -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,g變更按壓式 w200 hwndHBT1 ,按壓式清包
BT1Options:= [{BC: "99D1D3|FFFFFF", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT1,BT1Options)

Gui, Add, Button,g變更自動式 w200 hwndHBT2 ,自動式清包
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT2,BT1Options)

Gui, Add, Button,g變更掃描式 w200 hwndHBT3 ,掃描式清包
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT3,BT1Options)

Gui, Add, Button,g變更掃描加翻頁式 w200 hwndHBT12 ,掃描快搜清包
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT12,BT1Options)

Gui, Add, Button,g變更顏色定位 w200 hwndHBT4 ,背包顏色定位
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT4,BT1Options)
Gui, font
Gui Add, StatusBar,, % "製作By Sid 當前F3按鍵為 = "清包模式 " 。 "
Gui, Show
return

背包模式及時切換Escape:
背包模式及時切換Close:
Gui,submit
Return

變更按壓式:
Gui,submit
清包模式 = 按壓式
IniWrite,% 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
 Iniread, 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
ToolTip("清包模式已變更為: " . 清包模式 . " 。 ")
Return

變更自動式:
Gui,submit
清包模式 = 自動式
IniWrite,% 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
 Iniread, 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
ToolTip("清包模式已變更為: " . 清包模式 . " 。 ")
Return

變更掃描式:
Gui,submit
清包模式 = 掃描式
IniWrite,% 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
 Iniread, 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
ToolTip("清包模式已變更為: " . 清包模式 . " 。 ")
Return

變更掃描加翻頁式:
Gui,submit
if (藥劑類 = "error" or 傳奇裝 = "error" or 傳奇戒 = "error" or 守望石 = "error" or 勢力裝頁 = "error")
{
msgbox,16,提醒,工具讀取到您的"快搜倉庫頁設置"並不完全，請前往設置。
}
else
{
清包模式 = 掃描快搜翻頁
IniWrite,% 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
 Iniread, 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
ToolTip("清包模式已變更為: " . 清包模式 . " 。 ")
}
return

變更顏色定位:
Gui,submit
清包模式 = 變更顏色定位
IniWrite,% 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
 Iniread, 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
ToolTip("清包模式已變更為: " . 清包模式 . " 。 ")
msgbox,48,提醒視窗,你正切換為顏色定位模式，請在[F7]背包座標確實抓取後再使用此模式，`r開啟[I]並保持背包淨空，使用[F3]讓工具掃描顏色紀錄數據。
return

讀取F3按鍵模式:
 Iniread, 清包模式, sidtooldata.ini, 按鍵模式切換, 清包模式
Return

;[F3快速掃描背包區].............................................................................................................................


讀取背包初始顏色:
loop,60
{
iniread, 背包初始顏色%A_Index%, sidtooldata.ini, 快速掃描顏色, 背包初始顏色%A_Index%
}
return


快速掃描背包顏色並儲存:
迴圈狀態:= 0
CoordMode, Pixel, Screen
global 掃描顏色Array := []
{
 掃描顏色Array := []
 loop % 掃描水平數量
	{
	PosX := (掃描開始左上_X+(背包每格寬/2)) + ((背包每格寬/2)*((A_Index-1)*2))
	loop % 掃描垂直數量
		{
		PosY := (掃描開始左上_Y+(背包每格高/2)) + ((背包每格高/2)*((A_Index-1)*2))
		ToolTip, % "掃描: " PosX "/" PosY, 0,0,1
		PixelGetColor, pcol, % PosX, % PosY, RGB
		掃描顏色Array.Push(pcol)
		迴圈狀態:= 迴圈狀態 +1
		ToolTip, % "掃描狀態: " pcol " / " 迴圈狀態 " / " PosX "/" PosY , 0,22,2
		iniWrite,% 掃描顏色Array[迴圈狀態], sidtooldata.ini, 快速掃描顏色,背包初始顏色%迴圈狀態%
		iniread, 背包初始顏色%迴圈狀態%, sidtooldata.ini, 快速掃描顏色, 背包初始顏色%迴圈狀態%
		}
	}
 ToolTip,,,,2
 ToolTip,,,,1
}
msgbox % "掃瞄並儲存完畢，請繼續[Win + F3]切換為掃描式。"
return

一鍵清包:
send {ctrl down}
loop % 掃描水平數量
{
PosX := (掃描開始左上_X+(背包每格寬/2)) + ((背包每格寬/2)*((A_Index-1)*2))
	if 清包模式 = 按壓式
	{
		if not(GetKeyState("F3","P"))
		{
		send {ctrl up}
		send {F3 up}
		ToolTip,,,,3
		return
		}
	}
	if 清包模式 = 自動式
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
	if 清包模式 = 按壓式
	{
		ToolTip, % "鬆開[F3]停止。", 0,22,3
		if not(GetKeyState("F3","P"))
		{
		send {ctrl up}
		send {F3 up}
		ToolTip,,,,3
		return
		}
	}
	if 清包模式 = 自動式
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
 if 清包模式 = 掃描快搜翻頁
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
		PixelGetColor, pcol2, % PosX, % PosY, RGB
		存倉掃描顏色Array.Push(pcol2)
		迴圈狀態:= 迴圈狀態 +1
		ToolTip, % "掃描格子數: " 迴圈狀態 " /60 ，長按[~]停止。"  , 0,22,2
			If not pcol2 = 背包初始顏色%迴圈狀態%
			{
				if 清包模式 = 掃描快搜翻頁
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

;[F4快速開傳捲區(熱鍵)]---------------------------------------------------------------------------------------------------

*F4::
if Toolbutton = 1
{
ToolTip("您現在是文字模式，請嘗試點擊一小段路 或 Enter")
}
else
{
gosub,快速開傳捲區
}
return

快速開傳捲區:
if (傳送卷軸_X = "error" or 傳送卷軸_Y = "error")
{
msgbox,16,錯誤,尚未指定傳送卷軸位置!將滑鼠移動到背包中傳捲位置，`r熱鍵 [F7] 指定背包內位置，輸入「8」。
}
else
{
MouseGetPos,F4PosX,F4PosY
BlockInput On
if openI = 0
send {i}
sleep 200
MouseClick, Right,傳送卷軸_X,傳送卷軸_Y,1,1
MouseMove,F4PosX,F4PosY,0
sleep 100
if openI = 0
send {i}
BlockInput Off
sleep 1000
}
return

#F4::
Msgbox,16,提醒,本工具的 [Win + F4] 沒有多功能切換哦~ ^0^
return

~*I UP::
(openI = 0 ? (openI := 1) : (openI := 0))
if (openI = "1" and Toolbutton = "0")
ToolTip("開啟背包(I),如果操作不符合請按(ESC)")
if (openI = "0" and Toolbutton = "0")
ToolTip("關閉背包(I),如果操作不符合請按(ESC)")
return

~*P::
openI := 0
if Toolbutton = 0
ToolTip("天賦(P),如果操作不符合請按(ESC)，[Ctrl + F]強調天賦")
return

~*K::
openI := 0
if Toolbutton = 0
ToolTip("外觀(K),如果操作不符合請按(ESC)。")
return

~*M::
openI := 0
if Toolbutton = 0
ToolTip("商城(M),如果操作不符合請按(ESC)。")
return

~*BS::
Toolbutton = 1
ToolTip("(Back Space)，變更為文字模式。")
return

;[F5一鍵返回藏身區(熱鍵)]---------------------------------------------------------------------------------------------------

F5::
if Toolbutton = 1
{
ToolTip("您現在是文字模式，請嘗試點擊一小段路 或 Enter")
}
else
{
gosub,返回藏身
}
return

返回藏身:
BlockInput On
send {enter}
sleep 25
Clipboard = /hideout
Send ^{V}
sleep 25
send {enter}
BlockInput Off
return

;[F6一鍵取物(熱鍵)]---------------------------------------------------------------------------------------------------

F6::
 if 取物模式 = error
 {
 msgbox,48,提醒,第一次使用F6的朋友你好!請先使用Win + F6 選擇取物座標定位!`r前往通貨頁抓取刷圖日常所需的通貨座標。
 }
 else
 {
	if 取物模式 = 快速一鍵取物
	{
	gosub,F6快速一鍵取物
	}
	if 取物模式 = 取物座標定位
	{
	gosub,F6快速取物定位
	}
 }
Return

#F6::
gosub,一鍵取物模式及時切換
Return



F6快速一鍵取物:
MouseGetPos, thisPosX, thisPosY
send {Ctrl down}
loop,5
{
mouseclick,Left,通貨%A_Index%_X,通貨%A_Index%_Y,1,0
sleep 25
}
send {Ctrl up}
Mousemove, thisPosX, thisPosY
Return

F6快速取物定位:
	MouseGetPos, thisPosX, thisPosY
	PosX := ["通貨1_X","通貨2_X","通貨3_X","通貨4_X","通貨5_X"]
	PosY := ["通貨1_Y","通貨2_Y","通貨3_Y","通貨4_Y","通貨5_Y"]
	InputBox, affixID,F6快速取物定位, 使用熱鍵前的滑鼠座標 [ %thisPosX% `, %thisPosY% ]。`n如尚未指定，請按 ( Cancel )。`r正確指定座標後使用 ( F6 )。`r`r通貨1 = 1 (例:傳捲)`r通貨2 = 2 (例:知識捲)`r以此類推...`r`r請依指示輸入對應的座標代號( 1 ~ 5 ),,300,270
	if not ErrorLevel
	{
		checkAffixID := RegExMatch(affixID, "[1-5]$")
		if checkAffixID = 1
		{
			iniWrite,% thisPosX, sidtooldata.ini, 取物定位, % PosX[affixID]
			iniWrite,% thisPosY, sidtooldata.ini, 取物定位, % PosY[affixID]
			gosub,讀取F6取物定位內容
		}
		else if not (affixID = "1" or affixID = "2" or affixID = "3" or affixID = "4" or affixID = "5")
		{
			MsgBox,16,錯誤,請輸入正確的代號 1 ~ 5
		}
	}
	return

讀取F6取物定位內容:
loop,5
{
iniread,通貨%A_Index%_X, sidtooldata.ini, 取物定位, 通貨%A_Index%_X
iniread,通貨%A_Index%_Y, sidtooldata.ini, 取物定位, 通貨%A_Index%_Y
}
return

;[F6一鍵取物模式切換GUI面板]----------------------------------------------------------------------------------------------

一鍵取物模式及時切換:
Gui,一鍵取物模式及時切換:new,,F6一鍵取物模式及時切換
Gui +Label一鍵取物模式及時切換 -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,g變更取物模式 w200 hwndHBT13 ,快速一鍵取物
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT13,BT1Options)

Gui, Add, Button,g變更取物座標定位 w200 hwndHBT14 ,取物座標定位
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT14,BT1Options)
Gui, font
Gui Add, StatusBar,, % "製作By Sid 當前F6按鍵為 = "取物模式  " 。 "
Gui, Show
return

一鍵取物模式及時切換Escape:
一鍵取物模式及時切換Close:
Gui,submit
Return

變更取物模式:
Gui,submit
if (通貨1_X = "error" or 通貨1_Y = "error" or 通貨2_X = "error" or 通貨2_Y = "error")
{
msgbox,48,提醒視窗,你正切換為快速一鍵取物模式，但工具讀取到您尚未抓取通貨座標，`r請先使用Win + F6 選擇取物座標定位!`r前往通貨頁抓取刷圖日常所需的通貨座標。
gosub,一鍵取物模式及時切換
}
else
{
取物模式 = 快速一鍵取物
IniWrite,% 取物模式 , sidtooldata.ini, 按鍵模式切換, 取物模式
 Iniread, 取物模式 , sidtooldata.ini, 按鍵模式切換, 取物模式
ToolTip("取物模式 已變更為: " . 取物模式  . " 。 ")
}
Return

變更取物座標定位:
Gui,submit
取物模式 = 取物座標定位
IniWrite,% 取物模式 , sidtooldata.ini, 按鍵模式切換, 取物模式
 Iniread, 取物模式 , sidtooldata.ini, 按鍵模式切換, 取物模式
ToolTip("取物模式 已變更為: " . 取物模式  . " 。 ")
msgbox,48,提醒視窗,你已切換為取物座標定位模式，先將滑鼠指定好需拿取刷圖用通貨，按下F6輸入代號進行定位。
return

讀取F6按鍵模式:
 Iniread, 取物模式 , sidtooldata.ini, 按鍵模式切換, 取物模式
Return

;[F7座標定位區]------------------------------------------------------------------------------------------------------

#F7::
Msgbox,16,提醒,本工具的 [Win + F7] 沒有多功能切換哦~ ^0^
return

*F7::
F7背包定位:
MouseGetPos, thisPosX, thisPosY
PixelGetColor, colorabc, %thisPosX%, %thisPosY%
PosX := ["背包左上_X","背包右下_X","對方背包左上_X","對方背包右下_X","接受交易_X","命運卡交易_X","命運卡格子_X","傳送卷軸_X"]
PosY := ["背包左上_Y","背包右下_Y","對方背包左上_Y","對方背包右下_Y","接受交易_Y","命運卡交易_Y","命運卡格子_Y","傳送卷軸_Y"]
CosA := ["背包左上_C","背包右下_C","對方背包左上_C","對方背包右下_C","接受交易_C","命運卡交易_C","命運卡格子_C","傳送卷軸_C"]
InputBox, affixID,F7背包定位工具, 使用[F7]前的滑鼠座標 [ %thisPosX% `, %thisPosY% ]。`n如果尚未指定，請按 ( Cancel )。`r滑鼠正確指定座標後使用 ( F7 )。`r`r1 = 背包左上角`r2 = 背包右下角`r3 = 對方背包左上`r4 = 對方背包右下`r5 = 接受交易`r6 = 命運卡兌換 (點擊交易)`r7 = 命運卡兌換 (兌換欄位)`r8 = 傳送卷軸 (背包內固定位置)`r`r命運卡相關請在未放置任何物品至兌換處時抓取`r請依指示輸入對應的座標代號...( 1 ~ 8 ),,400,380
	if not ErrorLevel
	{
		checkAffixID := RegExMatch(affixID, "[1-8]$")
		if checkAffixID = 1
		{
			iniWrite,% thisPosX, sidtooldata.ini, 背包定位, % PosX[affixID]
			iniWrite,% thisPosY, sidtooldata.ini, 背包定位, % PosY[affixID]
			iniwrite,% colorabc, sidtooldata.ini, 背包定位, % CosA[affixID]
			gosub,讀取F7背包定位內容
			gosub,背包運算作業
			gosub,背包運算作業2
		}
		else if not (affixID = "1" or affixID = "2" or affixID = "3" or affixID = "4" or affixID = "5" or affixID = "6" or affixID = "7" or affixID = "8")
		{
			MsgBox,16,錯誤,請輸入正確的代號 1 ~ 8
		}
	}
	return

讀取F7背包定位內容:
iniread,背包左上_X, sidtooldata.ini, 背包定位, 背包左上_X
iniread,背包左上_Y, sidtooldata.ini, 背包定位, 背包左上_Y
iniread,背包右下_X, sidtooldata.ini, 背包定位, 背包右下_X
iniread,背包右下_Y, sidtooldata.ini, 背包定位, 背包右下_Y
iniread,對方背包左上_X, sidtooldata.ini, 背包定位, 對方背包左上_X
iniread,對方背包左上_Y, sidtooldata.ini, 背包定位, 對方背包左上_Y
iniread,對方背包右下_X, sidtooldata.ini, 背包定位, 對方背包右下_X
iniread,對方背包右下_Y, sidtooldata.ini, 背包定位, 對方背包右下_Y
iniread,接受交易_X, sidtooldata.ini, 背包定位, 接受交易_X
iniread,接受交易_Y, sidtooldata.ini, 背包定位, 接受交易_Y
iniread,命運卡交易_X, sidtooldata.ini, 背包定位, 命運卡交易_X
iniread,命運卡交易_Y, sidtooldata.ini, 背包定位, 命運卡交易_Y
iniread,命運卡交易_C, sidtooldata.ini, 背包定位, 命運卡交易_C
iniread,命運卡格子_X, sidtooldata.ini, 背包定位, 命運卡格子_X
iniread,命運卡格子_Y, sidtooldata.ini, 背包定位, 命運卡格子_Y
iniread,命運卡格子_C, sidtooldata.ini, 背包定位, 命運卡格子_C
iniread,傳送卷軸_X, sidtooldata.ini, 背包定位, 傳送卷軸_X
iniread,傳送卷軸_Y, sidtooldata.ini, 背包定位, 傳送卷軸_Y
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

;[F8命運卡兌換(熱鍵)]---------------------------------------------------------------------------------------------------

F8::
if Toolbutton = 1
{
ToolTip("您現在是文字模式，請嘗試點擊一小段路 或 Enter")
}
else
{
if (命運卡交易_X = "error" or 命運卡格子_Y = "error")
 {
 msgbox,16,錯誤,尚未指定命運卡兌換相關座標位置!`r將滑鼠移動到正確位置，熱鍵 [F7] 指定位置，輸入6和7。`r確認後，將跳轉圖片教學。
 run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/1202643573_2.jpg,,UseErrorLevel
 }
 else
 {
	if 命運卡兌換模式 = 單次兌換模式
	{
	gosub,單次命運卡交易
	return
	}
	if 命運卡兌換模式 = 多次兌換模式
	{
	gosub,多次命運卡交易
	return
	}
 }
}
return

#F8::
gosub,命運卡兌換模式切換
return

;[F8命運卡兌換(指令)]---------------------------------------------------------------------------------------------------

單次命運卡交易:
MouseGetPos,F8PosX,F8PosY
	send {Ctrl Down}
	MouseClick, Left,F8PosX,F8PosY,1,0
	sleep 100
	MouseClick, Left,命運卡交易_X,命運卡交易_Y,1,0
	sleep 100
	MouseClick, Left,命運卡格子_X,命運卡格子_Y,1,0
	send {Ctrl Up}
	MouseMove,F8PosX,F8PosY,0
return

多次命運卡交易:
次數 := 1
SetTimer, 提醒停止按鍵, 500
send {ctrl down}
loop % 掃描水平數量
{
	if (GetKeyState("~","P"))
	{
	send {ctrl up}
	SetTimer, 提醒停止按鍵, Off
	return
	}
	PosX := (掃描開始左上_X+(背包每格寬/2)) + ((背包每格寬/2)*((A_Index-1)*2))
	loop % 掃描垂直數量
	{
			if (GetKeyState("~","P"))
			{
			send {ctrl up}
			SetTimer, 提醒停止按鍵, Off
			return
			}
		PosY := (掃描開始左上_Y+(背包每格高/2)) + ((背包每格高/2)*((A_Index-1)*2))
		MouseClick,, % PosX, % PosY,1,0
		sleep 100
		PixelGetColor,兌換位置顏色,%命運卡格子_X%,%命運卡格子_Y%
		if 兌換位置顏色 = %命運卡格子_C%
		{
		}
		else
		{
		PixelGetColor,不可交易顏色2,%命運卡交易_X%,%命運卡交易_Y%
			if 不可交易顏色2 = %命運卡交易_C%
			{
			失敗次數 := ++次數
			MouseClick,,命運卡格子_X,命運卡格子_Y,1,0
				if 失敗次數 = 10
					{
					send {ctrl up}
					SetTimer, 提醒停止按鍵, Off
					msgbox % "交易失敗10次，停止繼續執行，請整理一下背包欄位。"
					return
					}
			}
			else
			{
			sleep 100
			MouseClick,,命運卡交易_X,命運卡交易_Y,1,0
			Sleep 100
			MouseClick,,命運卡格子_X,命運卡格子_Y,1,0
			}
		}
	}
}
send {ctrl up}
SetTimer, 提醒停止按鍵, Off
return

return

;[F8命運卡兌換模式切換GUI面板]----------------------------------------------------------------------------------------------

命運卡兌換模式切換:
Gui,命運卡兌換模式切換:new,,F8命運卡兌換模式切換
Gui +Label命運卡兌換模式切換 -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,g單次兌換模式 w200 hwndHBT22 ,單次兌換模式
BT1Options:= [{BC: "99D1D3|FFFFFF", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT22,BT1Options)

Gui, Add, Button,g多次兌換模式 w200 hwndHBT23 ,多次兌換模式
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT23,BT1Options)
Gui, font
Gui Add, StatusBar,, % "製作By Sid 當前F8按鍵為 = "命運卡兌換模式  " 。 "
Gui, Show
return

命運卡兌換模式切換Escape:
命運卡兌換模式切換Close:
Gui,submit
Return

單次兌換模式:
Gui,submit
	if (命運卡交易_X = "error" or 命運卡格子_Y = "error")
	{
	msgbox,48,提醒視窗,你正切換為單次兌換命運卡模式，但工具讀取到您尚未抓取座標，`r請先使用[F7] 抓取命運卡兌換相關座標!。
	}
	else
	{
	命運卡兌換模式 = 單次兌換模式
	IniWrite,% 命運卡兌換模式 , sidtooldata.ini, 按鍵模式切換, 命運卡兌換模式
	 Iniread, 命運卡兌換模式 , sidtooldata.ini, 按鍵模式切換, 命運卡兌換模式
	ToolTip("命運卡兌換模式 已變更為: " . 命運卡兌換模式  . " 。 ")
	}
Return

多次兌換模式:
Gui,submit
	if (命運卡交易_X = "error" or 命運卡格子_Y = "error")
	{
	msgbox,48,提醒視窗,你正切換為多次兌換命運卡模式，但工具讀取到您尚未抓取座標，`r請先使用[F7] 抓取命運卡兌換相關座標!。
	}
	else
	{
	命運卡兌換模式 = 多次兌換模式
	IniWrite,% 命運卡兌換模式 , sidtooldata.ini, 按鍵模式切換, 命運卡兌換模式
	 Iniread, 命運卡兌換模式 , sidtooldata.ini, 按鍵模式切換, 命運卡兌換模式
	ToolTip("命運卡兌換模式 已變更為: " . 命運卡兌換模式  . " 。 ")
	}
Return

讀取F8按鍵模式:
Iniread, 命運卡兌換模式 , sidtooldata.ini, 按鍵模式切換, 命運卡兌換模式
Return

;[切換角色配置GUI面板]----------------------------------------------------------------------------------------------

切換角色配置GUI面板:
Gui,切換角色配置:new,,切換角色配置
Gui +Label切換角色配置 -Resize  -MinimizeBox -MaximizeBox
Gui Color, 0xC0C0C0
Gui Font, s12 cBlue, Verdana
Gui Add, Text, x15 y15 w130 h23 +0x200, (1)角色配置名稱:
Gui Add, Text, x15 y45 w130 h23, (2)角色配置名稱:
Gui Add, Text, x15 y75 w130 h23, (3)角色配置名稱:
Gui Font, s8 cRed, Verdana
Gui Add, Text, x18 y101 w338 h23 +0x200, 輸入自己容易辨識的名稱即可，提供給單季多角色的玩家使用。
Gui Font
Gui Add, Edit, v配置名稱1 x150 y14 w120 h21 -Theme, %配置名稱1%
Gui Add, Edit, v配置名稱2 x150 y45 w120 h21 -Theme, %配置名稱2%
Gui Add, Edit, v配置名稱3 x150 y75 w120 h21 -Theme, %配置名稱3%
Gui Add, Button, g切換角色配置1 x280 y13 w80 h23 -Theme, 切換1
Gui Add, Button, g切換角色配置2 x280 y43 w80 h23 -Theme, 切換2
Gui Add, Button, g切換角色配置3 x280 y73 w80 h23 -Theme, 切換3
Gui Add, StatusBar,, 當前角色配置為: %當前角色配置名稱% ，角色配置: %當前角色配置% 。
Gui Show, w368 h153, 切換角色配置:
Return

切換角色配置Escape:
切換角色配置Close:
Msgbox,4,提醒視窗,您尚未儲存設定，確定是否要直接關閉?(是 或 否)`r`r儲存請直接依當前角色使用切換 1 ~ 3 。
IfMsgBox No
	Return
Else
	Gui,submit
Return

切換角色配置1:
Gui,submit
StopUser = 0
Gosub,關閉循環技能
Autodrinkbutton = 0
Gosub,暫停讀秒循環喝水
Gosub,停止循環偵測
當前角色配置名稱 = %配置名稱1%
當前角色配置 = 1
IniWrite,% 配置名稱1 , sidtooldata.ini, 角色配置, 配置名稱1
IniWrite,% 配置名稱2 , sidtooldata.ini, 角色配置, 配置名稱2
IniWrite,% 配置名稱3 , sidtooldata.ini, 角色配置, 配置名稱3
IniWrite,% 當前角色配置名稱 , sidtooldata.ini, 角色配置, 當前角色配置名稱
IniWrite,% 當前角色配置 , sidtooldata.ini, 角色配置, 當前角色配置
Iniread,配置名稱1 , sidtooldata.ini, 角色配置, 配置名稱1
Iniread,配置名稱2 , sidtooldata.ini, 角色配置, 配置名稱2
Iniread,配置名稱3 , sidtooldata.ini, 角色配置, 配置名稱3
Iniread, 當前角色配置 , sidtooldata.ini, 角色配置, 當前角色配置
Iniread,當前角色配置名稱 , sidtooldata.ini, 角色配置, 當前角色配置名稱
gosub,座標顏色讀取
gosub,讀取地雷設置
gosub,讀取技能連段數據
gosub,讀取循環技能設置
gosub,讀取偵測喝水打勾紀錄
gosub,讀取偵測喝水數據
gosub,讀取藥劑觸發紀錄
msgbox,0,提醒視窗,您已使用切換角色配置按鈕，自動關閉[Ins]各項循環與[F10]高級喝水功能。`r`r每位角色各項座標皆不相同，因此請確實檢查並重新抓取偵測點。
Return

切換角色配置2:
Gui,submit
StopUser = 0
Settimer,循環技能1,off
Settimer,循環技能3,off
Settimer,循環技能2,off
Autodrinkbutton = 0
Gosub,暫停讀秒循環喝水
Gosub,停止循環偵測
當前角色配置名稱 = %配置名稱2%
當前角色配置 = 2
IniWrite,% 配置名稱1 , sidtooldata.ini, 角色配置, 配置名稱1
IniWrite,% 配置名稱2 , sidtooldata.ini, 角色配置, 配置名稱2
IniWrite,% 配置名稱3 , sidtooldata.ini, 角色配置, 配置名稱3
IniWrite,% 當前角色配置名稱 , sidtooldata.ini, 角色配置, 當前角色配置名稱
IniWrite,% 當前角色配置 , sidtooldata.ini, 角色配置, 當前角色配置
Iniread,配置名稱1 , sidtooldata.ini, 角色配置, 配置名稱1
Iniread,配置名稱2 , sidtooldata.ini, 角色配置, 配置名稱2
Iniread,配置名稱3 , sidtooldata.ini, 角色配置, 配置名稱3
Iniread, 當前角色配置 , sidtooldata.ini, 角色配置, 當前角色配置
Iniread,當前角色配置名稱 , sidtooldata.ini, 角色配置, 當前角色配置名稱
gosub,座標顏色讀取
gosub,讀取地雷設置
gosub,讀取技能連段數據
gosub,讀取循環技能設置
gosub,讀取偵測喝水打勾紀錄
gosub,讀取偵測喝水數據
gosub,讀取藥劑觸發紀錄
msgbox,0,提醒視窗,您已使用切換角色配置按鈕，自動關閉[Ins]各項循環與[F10]高級喝水功能。`r`r每位角色各項座標皆不相同，因此請確實檢查並重新抓取偵測點。
Return

切換角色配置3:
Gui,submit
StopUser = 0
Settimer,循環技能1,off
Settimer,循環技能3,off
Settimer,循環技能2,off
Autodrinkbutton = 0
Gosub,暫停讀秒循環喝水
Gosub,停止循環偵測
當前角色配置名稱 = %配置名稱3%
當前角色配置 = 3
IniWrite,% 配置名稱1 , sidtooldata.ini, 角色配置, 配置名稱1
IniWrite,% 配置名稱2 , sidtooldata.ini, 角色配置, 配置名稱2
IniWrite,% 配置名稱3 , sidtooldata.ini, 角色配置, 配置名稱3
IniWrite,% 當前角色配置名稱 , sidtooldata.ini, 角色配置, 當前角色配置名稱
IniWrite,% 當前角色配置 , sidtooldata.ini, 角色配置, 當前角色配置
Iniread,配置名稱1 , sidtooldata.ini, 角色配置, 配置名稱1
Iniread,配置名稱2 , sidtooldata.ini, 角色配置, 配置名稱2
Iniread,配置名稱3 , sidtooldata.ini, 角色配置, 配置名稱3
Iniread, 當前角色配置 , sidtooldata.ini, 角色配置, 當前角色配置
Iniread,當前角色配置名稱 , sidtooldata.ini, 角色配置, 當前角色配置名稱
gosub,座標顏色讀取
gosub,讀取地雷設置
gosub,讀取技能連段數據
gosub,讀取循環技能設置
gosub,讀取偵測喝水打勾紀錄
gosub,讀取偵測喝水數據
gosub,讀取藥劑觸發紀錄
msgbox,0,提醒視窗,您已使用切換角色配置按鈕，自動關閉[Ins]各項循環與[F10]高級喝水功能。`r`r每位角色各項座標皆不相同，因此請確實檢查並重新抓取偵測點。
Return

讀取當前角色配置:
Iniread,配置名稱1 , sidtooldata.ini, 角色配置, 配置名稱1
Iniread,配置名稱2 , sidtooldata.ini, 角色配置, 配置名稱2
Iniread,配置名稱3 , sidtooldata.ini, 角色配置, 配置名稱3
Iniread, 當前角色配置 , sidtooldata.ini, 角色配置, 當前角色配置
Iniread,當前角色配置名稱 , sidtooldata.ini, 角色配置, 當前角色配置名稱
if 當前角色配置 = Error
{
當前角色配置 = 1
}
Return


;[漂亮按鈕產生代碼]----------------------------------------------------------------------------------------------

CreateImageButton(HWND, Options, Margins = 0) {
; HTML colors
Static HTML := {BLACK: "000000", GRAY: "808080", SILVER: "C0C0C0", WHITE: "FFFFFF"
, MAROON: "800000", PURPLE: "800080", FUCHSIA: "FF00FF", RED: "FF0000"
, GREEN: "008000", OLIVE: "808000", YELLOW: "FFFF00", LIME: "00FF00"
, NAVY: "000080", TEAL: "008080", AQUA: "00FFFF", BLUE: "0000FF"}

; Windows constants
Static BS_CHECKBOX := 0x2 , BS_RADIOBUTTON := 0x4
, BS_GROUPBOX := 0x7 , BS_AUTORADIOBUTTON := 0x9
, BS_LEFT := 0x100 , BS_RIGHT := 0x200
, BS_CENTER := 0x300 , BS_TOP := 0x400
, BS_BOTTOM := 0x800 , BS_VCENTER := 0xC00
, BS_BITMAP := 0x0080
, SA_LEFT := 0x0 , SA_CENTER := 0x1
, SA_RIGHT := 0x2 , WM_GETFONT := 0x31
, IMAGE_BITMAP := 0x0 , BITSPIXEL := 0xC
, RCBUTTONS := BS_CHECKBOX | BS_RADIOBUTTON | BS_AUTORADIOBUTTON
, BCM_SETIMAGELIST := 0x1602
, BUTTON_IMAGELIST_ALIGN_LEFT := 0
, BUTTON_IMAGELIST_ALIGN_RIGHT := 1
, BUTTON_IMAGELIST_ALIGN_CENTER := 4
; Options
Static OptionKeys := ["TC", "BC", "3D", "G"]
; Defaults
Static Defaults := {TC: "000000", BC: "000000", 3D: 0, G: 0}
; -------------------------------------------------------------------------------------------------------------------
ErrorLevel := ""
; -------------------------------------------------------------------------------------------------------------------
; Check the availability of Gdiplus.dll
GDIPDll := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "Ptr")
VarSetCapacity(SI, 24, 0)
Numput(1, SI)
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", GDIPToken, "Ptr", &SI, "Ptr", 0)
If (!GDIPToken) {
ErrorLevel := "GDIPlus could not be started!`n`nImageButton won't work!"
Return False
}
; -------------------------------------------------------------------------------------------------------------------
; Check HWND
If !(DllCall("User32.dll\IsWindow", "Ptr", HWND)) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Invalid parameter HWND!"
Return False
}
; -------------------------------------------------------------------------------------------------------------------
; Check Options
If !(IsObject(Options)) || (Options.MinIndex() = "") || (Options.MinIndex() > 1) || (Options.MaxIndex() > 6) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Invalid parameter Options!"
Return False
}
; -------------------------------------------------------------------------------------------------------------------
; Check Margins
Margins := SubStr(Margins, 1, 1)
If (Margins = "") || !(Instr("01234", Margins))
Margins := 0
; -------------------------------------------------------------------------------------------------------------------
; Get and check control's class and styles
WinGetClass, BtnClass, ahk_id %HWND%
ControlGet, BtnStyle, Style, , , ahk_id %HWND%
If (BtnClass != "Button") || ((BtnStyle & 0xF ^ BS_GROUPBOX) = 0) || ((BtnStyle & RCBUTTONS) > 1) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "You can use ImageButton only for PushButtons!"
Return False
}
; -------------------------------------------------------------------------------------------------------------------
; Get the button's font
GDIPFont := 0
DC := DllCall("User32.dll\GetDC", "Ptr", HWND, "Ptr")
BPP := DllCall("Gdi32.dll\GetDeviceCaps", "Ptr", DC, "Int", BITSPIXEL)
HFONT := DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", WM_GETFONT, "Ptr", 0, "Ptr", 0, "Ptr")
DllCall("Gdi32.dll\SelectObject", "Ptr", DC, "Ptr", HFONT)
DllCall("Gdiplus.dll\GdipCreateFontFromDC", "Ptr", DC, "PtrP", GDIPFont)
DllCall("User32.dll\ReleaseDC", "Ptr", HWND, "Ptr", DC)
If !(GDIPFont) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Couldn't get button's font!"
Return False
}
; -------------------------------------------------------------------------------------------------------------------
; Get the button's RECT
VarSetCapacity(RECT, 16, 0)
If !(DllCall("User32.dll\GetClientRect", "Ptr", HWND, "Ptr", &RECT)) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Couldn't get button's rectangle!"
Return False
}
W := NumGet(RECT, 8, "Int") - (Margins * 2)
H := NumGet(RECT, 12, "Int") - (Margins * 2)
; -------------------------------------------------------------------------------------------------------------------
; Get the button's caption
BtnCaption := ""
Len := DllCall("User32.dll\GetWindowTextLength", "Ptr", HWND) + 1
If (Len > 1) { ; Button has a caption
VarSetCapacity(BtnCaption, Len * (A_IsUnicode ? 2 : 1), 0)
If !(DllCall("User32.dll\GetWindowText", "Ptr", HWND, "Str", BtnCaption, "Int", Len)) {
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Couldn't get button's caption!"
Return False
}
VarSetCapacity(BtnCaption, -1)
}
; -------------------------------------------------------------------------------------------------------------------
; Create the BitMap(s)
BitMaps := []
While (A_Index <= Options.MaxIndex()) {
If !(Options.HasKey(A_Index))
Continue
Option := Options[A_Index]
; Check mandatory keys
If !(Option.HasKey("BC")) {
GoSub, CreateImageButton_FreeBitmaps
GoSub, CreateImageButton_GDIPShutdown
ErrorLevel := "Missing option BC in Options[" . A_Index . "]!"
Return False
}
; Check for defaults
For Each, K In Defaults {
If !(Option.HasKey(K)) || (Option[K] = "")
Option[K] := Defaults[K]
}
; Check options
BitMap := ""
GC := SubStr(Option.G, 1, 1)
If !InStr("01", GC)
GC := Defaults.G
3D := SubStr(Option.3D, 1, 1)
If !InStr("01239", 3D)
3D := Defaults.3D
If (3D < 4) {
BkgColor := Option.BC
If InStr(BkgColor, "|") {
StringSplit, BkgColor, BkgColor, |
} Else {
BkgColor1 := Option.3D = 0 ? BkgColor : Defaults.BC
BkgColor2 := BkgColor
}
If HTML.HasKey(BkgColor1)
BkgColor1 := HTML[BkgColor1]
If HTML.HasKey(BkgColor2)
BkgColor2 := HTML[BkgColor2]
} Else {
Image := Option.BC
}
TxtColor := Option.TC
If HTML.HasKey(TxtColor)
TxtColor := HTML[TxtColor]
; ----------------------------------------------------------------------------------------------------------------
; Create a GDI+ bitmap
DllCall("Gdiplus.dll\GdipCreateBitmapFromScan0", "Int", W, "Int", H, "Int", 0
, "UInt", 0x26200A, "Ptr", 0, "PtrP", PBITMAP)
; Get the pointer to it's graphics
DllCall("Gdiplus.dll\GdipGetImageGraphicsContext", "Ptr", PBITMAP, "PtrP", PGRAPHICS)
; Set SmoothingMode to system default
DllCall("Gdiplus.dll\GdipSetSmoothingMode", "Ptr", PGRAPHICS, "UInt", 0)
If (3D < 4) { ; Create a BitMap
; Create a PathGradientBrush
VarSetCapacity(POINTS, 4 * 8, 0)
NumPut(W - 1, POINTS, 8, "UInt"), NumPut(W - 1, POINTS, 16, "UInt")
NumPut(H - 1, POINTS, 20, "UInt"), NumPut(H - 1, POINTS, 28, "UInt")
DllCall("Gdiplus.dll\GdipCreatePathGradientI", "Ptr", &POINTS, "Int", 4, "Int", 0, "PtrP", PBRUSH)
; Start and target colors
Color1 := "0xFF" . BkgColor1
Color2 := "0xFF" . BkgColor2
; Set the PresetBlend
VarSetCapacity(COLORS, 12, 0)
NumPut(Color1, COLORS, 0, "UInt"), NumPut(Color2, COLORS, 4, "UInt")
VarSetCapacity(RELINT, 12, 0)
NumPut(0.00, RELINT, 0, "Float"), NumPut(1.00, RELINT, 4, "Float")
DllCall("Gdiplus.dll\GdipSetPathGradientPresetBlend", "Ptr", PBRUSH, "Ptr", &COLORS, "Ptr", &RELINT, "Int", 2)
; Set the FocusScales
DH := H / 2
XScale := (3D = 1 ? (W - DH) / W : 3D = 2 ? 1 : 0)
YScale := (3D = 1 ? (H - DH) / H : 3D = 3 ? 1 : 0)
DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", PBRUSH, "Float", XScale, "Float", YScale)
; Set the GammaCorrection
DllCall("Gdiplus.dll\GdipSetPathGradientGammaCorrection", "Ptr", PBRUSH, "Int", GC)
; Fill button's rectangle
DllCall("Gdiplus.dll\GdipFillRectangleI", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Int", 0, "Int", 0
, "Int", W, "Int", H)
; Free the brush
DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
} Else { ; Create a bitmap from HBITMAP or file
If (Image + 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromHBITMAP", "Ptr", Image, "Ptr", 0, "PtrP", PBM)
Else
DllCall("Gdiplus.dll\GdipCreateBitmapFromFile", "WStr", Image, "PtrP", PBM)
; Draw the bitmap
DllCall("Gdiplus.dll\GdipDrawImageRectI", "Ptr", PGRAPHICS, "Ptr", PBM, "Int", 0, "Int", 0
, "Int", W, "Int", H)
; Free the bitmap
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", PBM)
}
; ----------------------------------------------------------------------------------------------------------------
; Draw the caption
If (BtnCaption) {
; Create a StringFormat object
DllCall("Gdiplus.dll\GdipCreateStringFormat", "Int", 0x5404, "UInt", 0, "PtrP", HFORMAT)
; Text color
DllCall("Gdiplus.dll\GdipCreateSolidFill", "UInt", "0xFF" . TxtColor, "PtrP", PBRUSH)
; Horizontal alignment
HALIGN := (BtnStyle & BS_CENTER) = BS_CENTER ? SA_CENTER
: (BtnStyle & BS_CENTER) = BS_RIGHT ? SA_RIGHT
: (BtnStyle & BS_CENTER) = BS_Left ? SA_LEFT
: SA_CENTER
DllCall("Gdiplus.dll\GdipSetStringFormatAlign", "Ptr", HFORMAT, "Int", HALIGN)
; Vertical alignment
VALIGN := (BtnStyle & BS_VCENTER) = BS_TOP ? 0
: (BtnStyle & BS_VCENTER) = BS_BOTTOM ? 2
: 1
DllCall("Gdiplus.dll\GdipSetStringFormatLineAlign", "Ptr", HFORMAT, "Int", VALIGN)
; Set render quality to system default
DllCall("Gdiplus.dll\GdipSetTextRenderingHint", "Ptr", PGRAPHICS, "Int", 0)
; Set the text's rectangle
NumPut(0.0, RECT, 0, "Float")
NumPut(0.0, RECT, 4, "Float")
NumPut(W, RECT, 8, "Float")
NumPut(H, RECT, 12, "Float")
; Draw the text
DllCall("Gdiplus.dll\GdipDrawString", "Ptr", PGRAPHICS, "WStr", BtnCaption, "Int", -1
, "Ptr", GDIPFont, "Ptr", &RECT, "Ptr", HFORMAT, "Ptr", PBRUSH)
}
; Create a HBITMAP handle from the bitmap
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", PBITMAP, "PtrP", HBITMAP, "UInt", 0X00FFFFFF)
; Free resources
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", PBITMAP)
DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
DllCall("Gdiplus.dll\GdipDeleteStringFormat", "Ptr", HFORMAT)
DllCall("Gdiplus.dll\GdipDeleteGraphics", "Ptr", PGRAPHICS)
BitMaps[A_Index] := HBITMAP
}
; Now free the font object
DllCall("Gdiplus.dll\GdipDeleteFont", "Ptr", GDIPFont)
; -------------------------------------------------------------------------------------------------------------------
; Create the ImageList
HIL := DllCall("Comctl32.dll\ImageList_Create", "UInt", W, "UInt", H, "UInt", BPP, "Int", 6, "Int", 0, "Ptr")
Loop, % (BitMaps.MaxIndex() > 1 ? 6 : 1) {
HBITMAP := BitMaps.HasKey(A_Index) ? BitMaps[A_Index] : BitMaps[1]
DllCall("Comctl32.dll\ImageList_Add", "Ptr", HIL, "Ptr", HBITMAP, "Ptr", 0)
}
; Create a BUTTON_IMAGELIST structure
VarSetCapacity(BIL, 20 + A_PtrSize, 0)
NumPut(HIL, BIL, 0, "Ptr")
Numput(BUTTON_IMAGELIST_ALIGN_CENTER, BIL, A_PtrSize + 16, "UInt")
; Hide buttons's caption
GuiControl, , %HWND% ; WinXP
GuiControl, +%BS_BITMAP%, %HWND%
; Assign the ImageList to the button
SendMessage, BCM_SETIMAGELIST, 0, 0, , ahk_id %HWND%
SendMessage, BCM_SETIMAGELIST, 0, &BIL, , ahk_id %HWND%
; Free the bitmaps
GoSub, CreateImageButton_FreeBitmaps
; -------------------------------------------------------------------------------------------------------------------
; All done successfully
GoSub, CreateImageButton_GDIPShutdown
Return True
; -------------------------------------------------------------------------------------------------------------------
; Free BitMaps
CreateImageButton_FreeBitmaps:
For I, HBITMAP In BitMaps {
DllCall("Gdi32.dll\DeleteObject", "Ptr", HBITMAP)
}
Return
; -------------------------------------------------------------------------------------------------------------------
; Shutdown GDIPlus
CreateImageButton_GDIPShutdown:
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", GDIPToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", GDIPDll)
Return
}