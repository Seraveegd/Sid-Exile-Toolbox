#NoEnv
#NoTrayIcon
#SingleInstance force
#MaxHotkeysPerInterval 400
SetBatchLines -1
SetKeyDelay, 0

;[Read Config Section]------------------------------------------------------------------------------------------------------
UserType = OpenSource

gosub,ReadCurrentCharacterConfig
gosub,ReadF7BackpackLocations
gosub,BackpackCalculation
gosub,BackpackCalculation2
gosub,ReadF1KeyMode
gosub,ReadF3KeyMode
gosub,ReadF6KeyMode
gosub,ReadF6PickupLocations
gosub,ReadF8KeyMode
gosub,ReadStashTabData
gosub,ReadBackpackBaseColor
gosub,ReadReplyMode
gosub,ReadAutoReplyContent
gosub,ReadQuickTradeReminder
gosub,ReadQuickPartyReminder
gosub,ReadClickMode
gosub,ReadMouseClickSpeed
gosub,ReadColorCoordinates
gosub,ReadMineSettings
gosub,ReadDrinkAlertSwitch
gosub,ReadDrinkCheckboxRecords
gosub,ReadSkillComboData
gosub,ReadLoopSettings
gosub,ReadDrinkDetectionData
gosub,ReadFlaskTriggerRecords

;[Write Defaults]------------------------------------------------------------------------------------------------------

DisclaimerShown = 0
clickStop = false
Toolbutton = 0
Autodrinkbutton = 0
SceneColorState = Changing
EnterDebugReminderCount = 0
openI = 0
StopUser = 0
FlaskLock1 = None
FlaskLock2 = None
FlaskLock3 = None
FlaskLock4 = None
FlaskLock5 = None
;------------------------------------------------------------------------------------------------------
if ClickMode = ERROR
{
ClickMode = Mouse Middle Button
}
;------------------------------------------------------------------------------------------------------
if ClearMode = ERROR
{
ClearMode = Hold-to-Clear
}
if QuickPartyReminder = ERROR
{
QuickPartyReminder = On
}
if QuickTradeReminder = ERROR
{
QuickTradeReminder = On
}
;------------------------------------------------------------------------------------------------------
if DivinationMode = ERROR
{
DivinationMode = Single Exchange Mode
}
;------------------------------------------------------------------------------------------------------
Loop,3
{
if LoopSkill%A_Index% = ERROR
{
LoopSkill%A_Index% = T
}
if LoopSkillTime%A_Index% = ERROR
{
LoopSkillTime%A_Index% = Off
}
}
;------------------------------------------------------------------------------------------------------
if FlaskTriggerMode = ERROR
{
FlaskTriggerMode = None
}
if FlasksOnSkillUse = ERROR
{
FlasksOnSkillUse = 12345
}
if MainSkill = ERROR
{
MainSkill = Q
}

Loop,5
{
if FlaskDuration%A_Index% = ERROR
{
FlaskDuration%A_Index% = Off
}
}
;------------------------------------------------------------------------------------------------------
if ComboSkill1 = ERROR
{
ComboSkill1 = Q
}
if ComboSkill2 = ERROR
{
ComboSkill2 = Off
}
if ComboSkill3 = ERROR
{
ComboSkill3 = Off
}
if ComboDelay1 = ERROR
{
ComboDelay1 = 100
}
if ComboDelay2 = ERROR
{
ComboDelay2 = 100
}
if SkillComboEnabled = ERROR
{
SkillComboEnabled = Off
}
;------------------------------------------------------------------------------------------------------
if MineMode = ERROR
{
MineMode = Off
}
if MineStaffMode = ERROR
{
MineStaffMode = Off
}
if DetonateDelay1 = ERROR
{
DetonateDelay1 = 300
}
if DetonateDelay2 = ERROR
{
DetonateDelay2 = 300
}
;------------------------------------------------------------------------------------------------------

gosub,StartupBox


;[Menu Configuration]------------------------------------------------------------------------------------------------------

Menu, ToolInfoSubMenu, Add, Hotkey List, HotkeyListGUI
Menu, ToolInfoSubMenu, Add, Full Feature List, FullFeatureList
Menu, MyMenu, Add, ★Tool Info★(Must Read), :ToolInfoSubMenu
Menu, MyMenu, Add
Menu, MyMenu, Add, Switch Character Profile, SwitchProfileGUI
Menu, MyMenu, Add, Flask Trigger Settings, FlaskTriggerSettingsGUI
Menu, MyMenu, Add, Drink Detection Settings, DrinkDetectionSettingsGUI
Menu, MyMenu, Add, Skill Combo Settings, SkillComboSettingsGUI
Menu, MyMenu, Add, Loop Skill Settings, LoopSkillSettingsGUI
Menu, MyMenu, Add, Quick Stash Search Settings, QuickStashSearchGUI
Menu, MyMenu, Add
Menu, MyMenu, Add, Mouse Click Settings, MouseClickSettingsGUI
Menu, MyMenu, Add, Auto Detonate Mines Settings, AutoDetonateMinesGUI
Menu, MyMenu, Add, Go to Price Check Tool URL, PriceCheckToolURL
Menu, MyMenu, Add
Menu, MyMenu, Add, Go to Sid's Website, OpenSidWebsite
return

CallMenu:
menu,mymenu,show
return

;[Hotkey Definitions]------------------------------------------------------------------------------------------------------

F9::
Suspend
ToolTip("Tool paused, keyboard restored. [F9] to resume.")
Pause,,1
return

F11::
reload
return

F12::
msgbox,,Notice, Tool exited ლ(・ω・ლ)摸摸
exitapp
return

~*esc::
IfWinActive,rchin-poe-trade
  WinActivate ,Path of Exile
openI := 0
Toolbutton := 0
ifwinactive, Path of Exile
ToolTip("(ESC) closed panel, back to game mode")
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
gosub,CallMenu
return

#V::
gosub,PriceCheckWindow
return

;[Tooltip Base Setup]------------------------------------------------------------------------------------------------------

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

;[Full Feature List GUI]-----------------------------------------------------------------------------------------------------------------------------------------------------

FullFeatureList:
gui,FullFeatureList:new,,Full Feature List (This tool is fully open-source and free)
Gui, Font, s10, Verdana
Gui, Add,Text,cBlue,[F1] Original Function / Return to Character
Gui, Add,Text,cBlue,[F2] Toggle AFK / DND / Auto-Reply
Gui, Add,Link,cBlue,[F3] Hold/Auto/Scan/Search+Clear modes = <a href="https://youtu.be/MzIH2rn72NE">Demo Video</a>
Gui, Add,Text,cBlue,[F4] Use Portal Scroll from backpack
Gui, Add,Text,cBlue,[F5] Return to Hideout
Gui, Add,Text,cBlue,[F6] Quick Pickup
Gui, Add,Text,cBlue,[F7] Backpack coordinate setup
Gui, Add,Text,cBlue,[F8] Single / Batch Divination Card exchange
Gui, Add,Text,cBlue,[F9] Restore keyboard (pause tool)
Gui, Add,Text,cBlue,[F10] Advanced drink mode (HP/Mana/Scene detection)
Gui, Add,Text,cBlue,[End] Quick party invite
Gui, Add,Text,cBlue,[Home] Quick trade request
Gui, Add,Text,cBlue,[PgUp] Quick trade: check 60 slots
Gui, Add,Text,cBlue,[PgDn] Quick trade: accept
Gui, Add,Text,cBlue,[Space] Quick drink / loop drink / flask lock
Gui, Add,Text,cBlue,[Insert] Toggle loop skills
Gui, Add,Text,cBlue,[Win + V] Quick price check
Gui, Add,Text,cBlue,[Win + Z] Tool menu & settings
Gui, Add,Text,cBlue,[Ctrl + Alt] Quick stash auto-page
Gui, Add,Text,cBlue,[Ctrl + Win] Return to stash first page
Gui, Add,Text,cBlue,[Middle Click] or [Ctrl + LButton] Mouse auto-click
Gui Font
Gui Add, StatusBar,, All features free and open-source, feel free to share and improve.
Gui, Show
return

;[Hotkey List GUI]------------------------------------------------------------------------------------------------------

HotkeyListGUI:
Gui,HotkeyList:new,,Hotkey List
Gui Color, 0xC0C0C0
Gui, Font, s10 Bold, Verdana
Gui, Add,Text,cBlue,[F1 ~ F12] (Keys with "/" support multi‑mode switching, see bottom tips.)
Gui, Font
Gui, Font, s10, Verdana
Gui, Add,Text,cBlue,[F1] = Original / Return to character
Gui, Add,Text,cBlue,[F2] = AFK / DND / Auto-Reply
Gui, Add,Link,cBlue,[F3] = Hold / Auto / Scan / Scan+Search clear / Backpack color mapping. Video:<a href="https://youtu.be/MzIH2rn72NE">click</a>
Gui, Add,Text,cBlue,[F4] = Use portal scroll
Gui, Add,Text,cBlue,[F5] = Return to hideout (town only)
Gui, Add,Link,cBlue,[F6] = Quick pickup / pickup coordinate setup. Video:<a href="https://youtu.be/yV8FdhSmz2Y">click</a>
Gui, Add,Text,cBlue,[F7] = Backpack coordinate setup
Gui, Add,Link,cBlue,[F8] = Single / Batch divination card exchange. Video:<a href="https://youtu.be/zBKJ99hFg9Y">click</a>
Gui, Add,Text,cBlue,[F9] = Restore keyboard (pause tool)
Gui, Add,Text,cBlue,[F10] = Toggle advanced drink mode
Gui, Add,Text,cBlue,[F11] = Restart tool
Gui, Add,Text,cBlue,[F12] = Exit tool
Gui, Font, s10 Bold, Verdana
Gui, Add,Text,cBlue,[Other Hotkeys]
Gui, Font
Gui, Font, s10, Verdana
Gui, Add,Text,cBlue,[End] = Quick party invite / toggle reminder
Gui, Add,Text,cBlue,[Home] = Quick trade request / toggle reminder
Gui, Add,Text,cBlue,[PgUp] = Quick trade check 60 slots
Gui, Add,Text,cBlue,[PgDn] = Quick trade accept
Gui, Add,Text,cBlue,[Space] = Quick drink / loop / lock (Win+Z: Flask settings)
Gui, Add,Text,cBlue,[Insert] = Toggle loop skills
Gui, Add,Link,cBlue,[Win + C] = Coordinate & color mapping for detection points. Video:<a href="https://youtu.be/dTk3BO54_8Y">click</a>
Gui, Add,Text,cBlue,[Win + V] = Quick price check (hover item)
Gui, Add,Text,cBlue,[Win + End] = Toggle party reminder
Gui, Add,Link,cBlue,[Ctrl + Alt] = Auto-page (quick stash search). Video:<a href="https://youtu.be/StpFz8qbB44">click</a>
Gui, Add,Text,cBlue,[Ctrl + Win] = Return to stash first page
Gui, Add,Text,cBlue,[Middle Click] or [Ctrl + LButton] = Mouse auto-click
Gui, Font, underline
Gui, Add,Text,cBlue,Open-source version – free to use and modify.
Gui, Font
Gui Add, StatusBar,, ▲ Tip: Multi‑mode switching means e.g. Win+F1 toggles F1 behavior, etc.
Gui, Show
return

;[Jump Labels]---------------------------------------------------------------------------------------------------

StartupBox:
msgbox,,Sid's PoE Toolbox (Open Source),Tool started. Use (Win+Z) to show menu.`rThis version is fully open-source, all features free to use.
return

StopReminder:
ToolTip("Hold [~] to stop")
if(GetKeyState("~","P"))
settimer,StopReminder,off
return

;---------------------------------------------------------

OpenSidWebsite:
run,https://sid-1996.github.io/sid-automation-lab/index.html,,UseErrorLevel
return

PauseLoopDrink:
SetTimer, Flask1, off
SetTimer, Flask2, off
SetTimer, Flask3, off
SetTimer, Flask4, off
SetTimer, Flask5, off
return

StopDetectionLoops:
settimer,DetectSceneChange,off
settimer,DetectHealthGlobe,OFF
settimer,DetectHealthBar,OFF
settimer,DetectManaGlobe,OFF
settimer,DetectHealthBarReturn,OFF
settimer,DetectChaosPenetration,OFF
settimer,DetectChaosPenetrationReturn,OFF
return

;[Flask Trigger Settings GUI]------------------------------------------------------------------------------------------------------

FlaskTriggerSettingsGUI:
Gui,FlaskTriggerSettings:new,,Flask Trigger Settings
Gui +LabelFlaskTriggerSettings -Resize  -MinimizeBox -MaximizeBox
Gui Color, 0xC0C0C0
Gui Font, s12 Bold
Gui Add, Text, x31 y152 w135 h23, Flask(1) Duration:
Gui Add, Text, x31 y177 w135 h23, Flask(2) Duration:
Gui Add, Text, x31 y202 w135 h23, Flask(3) Duration:
Gui Add, Text, x31 y227 w135 h23, Flask(4) Duration:
Gui Add, Text, x31 y252 w135 h23, Flask(5) Duration:
Gui Add, Text, x30 y97 w100 h23, When using skill:
Gui Add, Text, x171 y97 w111 h23, use flasks:
Gui Add, Text, x30 y8 w145 h23, Flask trigger mode:
Gui Add, Text, x31 y125 w219 h23, Quick drink (Space) uses flasks: 
Gui Add, Button,gSaveFlaskTriggerSettings x298 y204 w384 h67, Save & Close
Gui Font
Gui Font, s12
Gui Add, ComboBox, vFlaskTriggerMode x184 y5 w143 -Theme, None|Pure Flask Lock|Loop Drink|Drink on Skill Use|%FlaskTriggerMode%||
Gui Add, ComboBox, vMainSkill x126 y96 w40 -Theme, Q|W|E|R|T|%MainSkill%||
Gui Font
Gui Font, s10 cBlue
Gui Add, Text, x30 y35 w607 h20, Pure Flask Lock: manual flask use, tool prevents re‑use during duration. Good for intense situations.
Gui Add, Text, x30 y55 w604 h20, Loop Drink: press Space in map to start loop, flasks re‑use after duration ends. Good for zoom zoom builds.
Gui Add, Text, x30 y75 w440 h20, Drink on Skill Use: only drink when you use a skill – avoid wasteful drinking outside combat.
Gui Add, Text, x363 y96 w320 h23 +0x200, Example: enter 12345 = use flasks 1‑5, enter 135 = use 1,3,5.
Gui Add, Text, x295 y152 w210 h23 +0x200, (1s = 1000ms), use "off" to disable.
Gui Add, Text, x295 y177 w150 h23 +0x200, Life flasks usually set to off.
Gui Font
Gui Font, s10
Gui Add, Edit, vFlaskDuration1 x171 y152 w120 h21 -Theme, %FlaskDuration1%
Gui Add, Edit, vFlaskDuration2 x171 y177 w120 h21 -Theme, %FlaskDuration2%
Gui Add, Edit, vFlaskDuration3 x171 y202 w120 h21 -Theme, %FlaskDuration3%
Gui Add, Edit, vFlaskDuration4 x171 y227 w120 h21 -Theme, %FlaskDuration4%
Gui Add, Edit, vFlaskDuration5 x171 y252 w120 h21 -Theme, %FlaskDuration5%
Gui Add, Edit, vFlasksOnSkillUse x281 y96 w78 h21 +Number -Theme, %FlasksOnSkillUse%
Gui Add, Edit, vQuickDrinkFlasks x255 y123 w120 h21 +Number -Theme, %QuickDrinkFlasks%
Gui Font
Gui Add, StatusBar,, ▲ Tip: In Pure Flask Lock mode, manual 1‑5 keys reset the lock timer immediately.
Gui Show, w691 h301, Flask Trigger Settings
Return

;[Flask Trigger GUI Save Button]------------------------------------------------------------------------------------------------------

FlaskTriggerSettingsEscape:
FlaskTriggerSettingsClose:
Msgbox,4,Notice,Settings not saved. Close anyway? (Yes / No)
IfMsgBox No
	Return
Else
	Gui,submit
Return

;[Flask Trigger GUI Save Routine]------------------------------------------------------------------------------------------------------

SaveFlaskTriggerSettings:
Gui,submit
Gosub,SaveFlaskTriggerRecords
Gosub,ReadFlaskTriggerRecords
Return

SaveFlaskTriggerRecords:
if CurrentProfile = 1
{
IniWrite,	% MainSkill,	sidtooldata.ini, FlaskTriggerData, MainSkill
IniWrite,	% FlaskTriggerMode,	sidtooldata.ini, FlaskTriggerData, FlaskTriggerMode
IniWrite,	% FlaskDuration1,	sidtooldata.ini, FlaskTriggerData, FlaskDuration1
IniWrite,	% FlaskDuration2,	sidtooldata.ini, FlaskTriggerData, FlaskDuration2
IniWrite,	% FlaskDuration3,	sidtooldata.ini, FlaskTriggerData, FlaskDuration3
IniWrite,	% FlaskDuration4,	sidtooldata.ini, FlaskTriggerData, FlaskDuration4
IniWrite,	% FlaskDuration5,	sidtooldata.ini, FlaskTriggerData, FlaskDuration5
IniWrite,	% FlasksOnSkillUse,	sidtooldata.ini, FlaskTriggerData, FlasksOnSkillUse
IniWrite,	% QuickDrinkFlasks,	sidtooldata.ini, FlaskTriggerData, QuickDrinkFlasks
}
if CurrentProfile = 2
{
IniWrite,	% MainSkill,	sidtooldata2.ini, FlaskTriggerData, MainSkill
IniWrite,	% FlaskTriggerMode,	sidtooldata2.ini, FlaskTriggerData, FlaskTriggerMode
IniWrite,	% FlaskDuration1,	sidtooldata2.ini, FlaskTriggerData, FlaskDuration1
IniWrite,	% FlaskDuration2,	sidtooldata2.ini, FlaskTriggerData, FlaskDuration2
IniWrite,	% FlaskDuration3,	sidtooldata2.ini, FlaskTriggerData, FlaskDuration3
IniWrite,	% FlaskDuration4,	sidtooldata2.ini, FlaskTriggerData, FlaskDuration4
IniWrite,	% FlaskDuration5,	sidtooldata2.ini, FlaskTriggerData, FlaskDuration5
IniWrite,	% FlasksOnSkillUse,	sidtooldata2.ini, FlaskTriggerData, FlasksOnSkillUse
IniWrite,	% QuickDrinkFlasks,	sidtooldata2.ini, FlaskTriggerData, QuickDrinkFlasks
}
if CurrentProfile = 3
{
IniWrite,	% MainSkill,	sidtooldata3.ini, FlaskTriggerData, MainSkill
IniWrite,	% FlaskTriggerMode,	sidtooldata3.ini, FlaskTriggerData, FlaskTriggerMode
IniWrite,	% FlaskDuration1,	sidtooldata3.ini, FlaskTriggerData, FlaskDuration1
IniWrite,	% FlaskDuration2,	sidtooldata3.ini, FlaskTriggerData, FlaskDuration2
IniWrite,	% FlaskDuration3,	sidtooldata3.ini, FlaskTriggerData, FlaskDuration3
IniWrite,	% FlaskDuration4,	sidtooldata3.ini, FlaskTriggerData, FlaskDuration4
IniWrite,	% FlaskDuration5,	sidtooldata3.ini, FlaskTriggerData, FlaskDuration5
IniWrite,	% FlasksOnSkillUse,	sidtooldata3.ini, FlaskTriggerData, FlasksOnSkillUse
IniWrite,	% QuickDrinkFlasks,	sidtooldata3.ini, FlaskTriggerData, QuickDrinkFlasks
}
Return

ReadFlaskTriggerRecords:
if CurrentProfile = 1
{
 Iniread,	 MainSkill,	sidtooldata.ini, FlaskTriggerData, MainSkill
 Iniread,	 FlaskTriggerMode,	sidtooldata.ini, FlaskTriggerData, FlaskTriggerMode
 Iniread,	 FlaskDuration1,	sidtooldata.ini, FlaskTriggerData, FlaskDuration1
 Iniread,	 FlaskDuration2,	sidtooldata.ini, FlaskTriggerData, FlaskDuration2
 Iniread,	 FlaskDuration3,	sidtooldata.ini, FlaskTriggerData, FlaskDuration3
 Iniread,	 FlaskDuration4,	sidtooldata.ini, FlaskTriggerData, FlaskDuration4
 Iniread,	 FlaskDuration5,	sidtooldata.ini, FlaskTriggerData, FlaskDuration5
 Iniread,	 FlasksOnSkillUse,	sidtooldata.ini, FlaskTriggerData, FlasksOnSkillUse
 Iniread,	 QuickDrinkFlasks,	sidtooldata.ini, FlaskTriggerData, QuickDrinkFlasks
}
if CurrentProfile = 2
{
 Iniread,	 MainSkill,	sidtooldata2.ini, FlaskTriggerData, MainSkill
 Iniread,	 FlaskTriggerMode,	sidtooldata2.ini, FlaskTriggerData, FlaskTriggerMode
 Iniread,	 FlaskDuration1,	sidtooldata2.ini, FlaskTriggerData, FlaskDuration1
 Iniread,	 FlaskDuration2,	sidtooldata2.ini, FlaskTriggerData, FlaskDuration2
 Iniread,	 FlaskDuration3,	sidtooldata2.ini, FlaskTriggerData, FlaskDuration3
 Iniread,	 FlaskDuration4,	sidtooldata2.ini, FlaskTriggerData, FlaskDuration4
 Iniread,	 FlaskDuration5,	sidtooldata2.ini, FlaskTriggerData, FlaskDuration5
 Iniread,	 FlasksOnSkillUse,	sidtooldata2.ini, FlaskTriggerData, FlasksOnSkillUse
 Iniread,	 QuickDrinkFlasks,	sidtooldata2.ini, FlaskTriggerData, QuickDrinkFlasks
}
if CurrentProfile = 3
{
 Iniread,	 MainSkill,	sidtooldata3.ini, FlaskTriggerData, MainSkill
 Iniread,	 FlaskTriggerMode,	sidtooldata3.ini, FlaskTriggerData, FlaskTriggerMode
 Iniread,	 FlaskDuration1,	sidtooldata3.ini, FlaskTriggerData, FlaskDuration1
 Iniread,	 FlaskDuration2,	sidtooldata3.ini, FlaskTriggerData, FlaskDuration2
 Iniread,	 FlaskDuration3,	sidtooldata3.ini, FlaskTriggerData, FlaskDuration3
 Iniread,	 FlaskDuration4,	sidtooldata3.ini, FlaskTriggerData, FlaskDuration4
 Iniread,	 FlaskDuration5,	sidtooldata3.ini, FlaskTriggerData, FlaskDuration5
 Iniread,	 FlasksOnSkillUse,	sidtooldata3.ini, FlaskTriggerData, FlasksOnSkillUse
 Iniread,	 QuickDrinkFlasks,	sidtooldata3.ini, FlaskTriggerData, QuickDrinkFlasks
}
Return



;[Drink Detection Settings GUI]------------------------------------------------------------------------------------------------------

DrinkDetectionSettingsGUI:
gosub,ConvertDrinkCheckboxRecords
Gui,DrinkDetectionSettings:new,,Drink Detection Settings
Gui +LabelDrinkDetectionSettings -Resize  -MinimizeBox -MaximizeBox
Gui Font, s12
Gui Add, Text, x10 y25 w275 h16, Use flask when health bar below detection point (1)
Gui Add, Text, x360 y25 w243 h16, , and return to character below detection point (2).
Gui Add, Text, x10 y165 w280 h16, Use flask when health globe below detection point (9)
Gui Add, Text, x10 y85 w275 h16, Use flask when mana globe below detection point (3)
Gui Add, Text, x10 y125 w280 h16, Use flask when chaos penetration below point (7)
Gui Add, Text, x360 y125 w275 h16, , and return to character below point (8).
Gui Add, Text, x9 y185 w142 h16, Detection interval (ms)
Gui Add, Text, x213 y185 w352 h16, , adjust based on instant / recovery flasks.
Gui Add, Text, x470 y70 w120 h16, Drink alerts:
Gui Add, DropDownList, vDrinkAlertSwitch x578 y68 w60 -Theme, On|Off|%DrinkAlertSwitch%||
Gui Font, s11 cRed
Gui Add, Text, x14 y45 h14, Example: only flask1 -> enter 1. Two flasks -> 12. Mining -> 16, skill -> 16R.
Gui Font
Gui Font, s12 c0x0080FF
Gui Add, CheckBox, hWndcheckbox1 vHealthBarDrinkCheck x10 y4 w165 h18 %HealthBarDrinkChecked%, Enable Health Bar Drink↓
Gui Add, CheckBox, hWndcheckbox2 vHealthBarReturnCheck x360 y4 w165 h18 %HealthBarReturnChecked%, Enable Health Bar Return↓
Gui Add, CheckBox, hWndcheckbox3 vManaGlobeDrinkCheck x10 y64 w165 h18 %ManaGlobeDrinkChecked%, Enable Mana Globe Drink↓
Gui Add, CheckBox, hWndcheckbox4 vChaosPenetrationCheck x10 y104 w165 h18 %ChaosPenetrationChecked%, Enable Chaos Penetration Drink↓
Gui Add, CheckBox, hWndcheckbox5 vChaosPenetrationReturnCheck x360 y105 w200 h18 %ChaosPenetrationReturnChecked%, Enable Chaos Penetration Return↓
Gui Add, CheckBox, hWndcheckbox6 vHealthGlobeCheck x10 y144 w150 h18 %HealthGlobeChecked%, Enable Health Globe Drink↓
Gui, Add,Link,cRed x548 y4, Click <a href="https://youtu.be/dTk3BO54_8Y">Video Demo</a>
Gui Font
Gui Add, Button, gSaveDrinkDetectionSettings x578 y182 w80 h23 -Theme, Save & Close
Gui Add, StatusBar,, ▲ Tip: Enable both [Health Bar Return] and [Health Globe] to greatly reduce false return triggers. ㊣ Made By Sid
Gui Font
Gui Add, Edit, vFlaskKey1 x293 y23 w60 h20  -Theme,%FlaskKey1%
Gui Add, Edit, vFlaskKey2 x293 y81 w60 h20  -Theme,%FlaskKey2%
Gui Add, Edit, vFlaskKey3 x293 y123 w60 h20  -Theme,%FlaskKey3%
Gui Add, Edit, vFlaskKey4 x293 y163 w60 h20  -Theme,%FlaskKey4%
Gui Add, ComboBox, vDetectionInterval x157 y183 w50 -Theme, 100|300|500|800|1000|2000|3000|%DetectionInterval%||
Gui Show, w668 h234, Drink Detection Settings (works only in F10 advanced mode)
Return

;[Drink Detection GUI Save Button]------------------------------------------------------------------------------------------------------

DrinkDetectionSettingsEscape:
DrinkDetectionSettingsClose:
Msgbox,4,Notice,Settings not saved. Close anyway? (Yes / No)
IfMsgBox No
	Return
Else
	Gui,submit
Return


;[Drink Detection GUI Save Routine]------------------------------------------------------------------------------------------------------


ConvertDrinkCheckboxRecords:
	if HealthBarDrinkChecked = +checked
	{
	HealthBarDrinkChecked = +checked
	}
	else
	{
	HealthBarDrinkChecked = -checked
	}

	if HealthBarReturnChecked = +checked
	{
	HealthBarReturnChecked = +checked
	}
	else
	{
	HealthBarReturnChecked = -checked
	}

	if ManaGlobeDrinkChecked = +checked
	{
	ManaGlobeDrinkChecked = +checked
	}
	else
	{
	ManaGlobeDrinkChecked = -checked
	}

	if ChaosPenetrationChecked = +checked
	{
	ChaosPenetrationChecked = +checked
	}
	else
	{
	ChaosPenetrationChecked = -checked
	}

	if ChaosPenetrationReturnChecked = +checked
	{
	ChaosPenetrationReturnChecked = +checked
	}
	else
	{
	ChaosPenetrationReturnChecked = -checked
	}

	if HealthGlobeChecked = +checked
	{
	HealthGlobeChecked = +checked
	}
	else
	{
	HealthGlobeChecked = -checked
	}
return

SaveDrinkDetectionSettings:
Gui,submit
If HealthBarDrinkCheck = 1
HealthBarDrinkChecked = +Checked
If HealthBarDrinkCheck = 0
HealthBarDrinkChecked = -Checked
If HealthBarReturnCheck = 1
HealthBarReturnChecked = +Checked
If HealthBarReturnCheck = 0
HealthBarReturnChecked = -Checked
If ManaGlobeDrinkCheck = 1
ManaGlobeDrinkChecked = +Checked
If ManaGlobeDrinkCheck = 0
ManaGlobeDrinkChecked = -Checked
If ChaosPenetrationCheck = 1
ChaosPenetrationChecked = +Checked
If ChaosPenetrationCheck = 0
ChaosPenetrationChecked = -Checked
If ChaosPenetrationReturnCheck = 1
ChaosPenetrationReturnChecked = +Checked
If ChaosPenetrationReturnCheck = 0
ChaosPenetrationReturnChecked = -Checked
If HealthGlobeCheck = 1
HealthGlobeChecked = +Checked
If HealthGlobeCheck = 0
HealthGlobeChecked = -Checked
gosub,SaveDrinkCheckboxRecords
gosub,SaveDrinkDetectionData
gosub,SaveDrinkAlertSwitch
gosub,ReadDrinkCheckboxRecords
gosub,ReadDrinkDetectionData
gosub,ReadDrinkAlertSwitch
if Autodrinkbutton = 1
{
Autodrinkbutton := 0
msgbox,48,Notice,You just changed settings. F10 advanced mode has been turned off.`rTurn it on again to apply changes.
}
Return

SaveDrinkAlertSwitch:
IniWrite,	% DrinkAlertSwitch,	sidtooldata.ini, DrinkDetectionData, DrinkAlertSwitch
Return

ReadDrinkAlertSwitch:
 Iniread,	 DrinkAlertSwitch,	sidtooldata.ini, DrinkDetectionData, DrinkAlertSwitch
	if DrinkAlertSwitch = error
	{
	ToolTipOff = 0
	DrinkAlertSwitch = On
	}
	if DrinkAlertSwitch = On
	{
	ToolTipOff = 0
	}
	if DrinkAlertSwitch = Off
	{
	ToolTipOff = 1
	}
Return

SaveDrinkCheckboxRecords:
if CurrentProfile = 1
{
IniWrite,	% ChaosPenetrationReturnChecked,	sidtooldata.ini, DrinkDetectionData, ChaosPenetrationReturnChecked
IniWrite,	% HealthBarDrinkChecked,	sidtooldata.ini, DrinkDetectionData, HealthBarDrinkChecked
IniWrite,	% HealthBarReturnChecked,	sidtooldata.ini, DrinkDetectionData, HealthBarReturnChecked
IniWrite,	% ManaGlobeDrinkChecked,	sidtooldata.ini, DrinkDetectionData, ManaGlobeDrinkChecked
IniWrite,	% ChaosPenetrationChecked,	sidtooldata.ini, DrinkDetectionData, ChaosPenetrationChecked
IniWrite,	% HealthGlobeChecked,	sidtooldata.ini, DrinkDetectionData, HealthGlobeChecked
}
if CurrentProfile = 2
{
IniWrite,	% ChaosPenetrationReturnChecked,	sidtooldata2.ini, DrinkDetectionData, ChaosPenetrationReturnChecked
IniWrite,	% HealthBarDrinkChecked,	sidtooldata2.ini, DrinkDetectionData, HealthBarDrinkChecked
IniWrite,	% HealthBarReturnChecked,	sidtooldata2.ini, DrinkDetectionData, HealthBarReturnChecked
IniWrite,	% ManaGlobeDrinkChecked,	sidtooldata2.ini, DrinkDetectionData, ManaGlobeDrinkChecked
IniWrite,	% ChaosPenetrationChecked,	sidtooldata2.ini, DrinkDetectionData, ChaosPenetrationChecked
IniWrite,	% HealthGlobeChecked,	sidtooldata2.ini, DrinkDetectionData, HealthGlobeChecked
}
if CurrentProfile = 3
{
IniWrite,	% ChaosPenetrationReturnChecked,	sidtooldata3.ini, DrinkDetectionData, ChaosPenetrationReturnChecked
IniWrite,	% HealthBarDrinkChecked,	sidtooldata3.ini, DrinkDetectionData, HealthBarDrinkChecked
IniWrite,	% HealthBarReturnChecked,	sidtooldata3.ini, DrinkDetectionData, HealthBarReturnChecked
IniWrite,	% ManaGlobeDrinkChecked,	sidtooldata3.ini, DrinkDetectionData, ManaGlobeDrinkChecked
IniWrite,	% ChaosPenetrationChecked,	sidtooldata3.ini, DrinkDetectionData, ChaosPenetrationChecked
IniWrite,	% HealthGlobeChecked,	sidtooldata3.ini, DrinkDetectionData, HealthGlobeChecked
}
Return

ReadDrinkCheckboxRecords:
if CurrentProfile = 1
{
 Iniread,	ChaosPenetrationReturnChecked,	sidtooldata.ini, DrinkDetectionData, ChaosPenetrationReturnChecked
 Iniread,	HealthBarDrinkChecked,	sidtooldata.ini, DrinkDetectionData, HealthBarDrinkChecked
 Iniread,	HealthBarReturnChecked,	sidtooldata.ini, DrinkDetectionData, HealthBarReturnChecked
 Iniread,	ManaGlobeDrinkChecked,	sidtooldata.ini, DrinkDetectionData, ManaGlobeDrinkChecked
 Iniread,	ChaosPenetrationChecked,	sidtooldata.ini, DrinkDetectionData, ChaosPenetrationChecked
 Iniread,	HealthGlobeChecked,	sidtooldata.ini, DrinkDetectionData, HealthGlobeChecked
}
if CurrentProfile = 2
{
 Iniread,	ChaosPenetrationReturnChecked,	sidtooldata2.ini, DrinkDetectionData, ChaosPenetrationReturnChecked
 Iniread,	HealthBarDrinkChecked,	sidtooldata2.ini, DrinkDetectionData, HealthBarDrinkChecked
 Iniread,	HealthBarReturnChecked,	sidtooldata2.ini, DrinkDetectionData, HealthBarReturnChecked
 Iniread,	ManaGlobeDrinkChecked,	sidtooldata2.ini, DrinkDetectionData, ManaGlobeDrinkChecked
 Iniread,	ChaosPenetrationChecked,	sidtooldata2.ini, DrinkDetectionData, ChaosPenetrationChecked
 Iniread,	HealthGlobeChecked,	sidtooldata2.ini, DrinkDetectionData, HealthGlobeChecked
}
if CurrentProfile = 3
{
 Iniread,	ChaosPenetrationReturnChecked,	sidtooldata3.ini, DrinkDetectionData, ChaosPenetrationReturnChecked
 Iniread,	HealthBarDrinkChecked,	sidtooldata3.ini, DrinkDetectionData, HealthBarDrinkChecked
 Iniread,	HealthBarReturnChecked,	sidtooldata3.ini, DrinkDetectionData, HealthBarReturnChecked
 Iniread,	ManaGlobeDrinkChecked,	sidtooldata3.ini, DrinkDetectionData, ManaGlobeDrinkChecked
 Iniread,	ChaosPenetrationChecked,	sidtooldata3.ini, DrinkDetectionData, ChaosPenetrationChecked
 Iniread,	HealthGlobeChecked,	sidtooldata3.ini, DrinkDetectionData, HealthGlobeChecked
}
Return

SaveDrinkDetectionData:
if CurrentProfile = 1
{
IniWrite,	% FlaskKey1,	sidtooldata.ini, DrinkDetectionData, FlaskKey1
IniWrite,	% FlaskKey2,	sidtooldata.ini, DrinkDetectionData, FlaskKey2
IniWrite,	% FlaskKey3,	sidtooldata.ini, DrinkDetectionData, FlaskKey3
IniWrite,	% FlaskKey4,	sidtooldata.ini, DrinkDetectionData, FlaskKey4
IniWrite,	% DetectionInterval,	sidtooldata.ini, DrinkDetectionData, DetectionInterval
}
if CurrentProfile = 2
{
IniWrite,	% FlaskKey1,	sidtooldata2.ini, DrinkDetectionData, FlaskKey1
IniWrite,	% FlaskKey2,	sidtooldata2.ini, DrinkDetectionData, FlaskKey2
IniWrite,	% FlaskKey3,	sidtooldata2.ini, DrinkDetectionData, FlaskKey3
IniWrite,	% FlaskKey4,	sidtooldata2.ini, DrinkDetectionData, FlaskKey4
IniWrite,	% DetectionInterval,	sidtooldata2.ini, DrinkDetectionData, DetectionInterval
}
if CurrentProfile = 3
{
IniWrite,	% FlaskKey1,	sidtooldata3.ini, DrinkDetectionData, FlaskKey1
IniWrite,	% FlaskKey2,	sidtooldata3.ini, DrinkDetectionData, FlaskKey2
IniWrite,	% FlaskKey3,	sidtooldata3.ini, DrinkDetectionData, FlaskKey3
IniWrite,	% FlaskKey4,	sidtooldata3.ini, DrinkDetectionData, FlaskKey4
IniWrite,	% DetectionInterval,	sidtooldata3.ini, DrinkDetectionData, DetectionInterval
}
Return

ReadDrinkDetectionData:
if CurrentProfile = 1
{
 Iniread,	FlaskKey1,	sidtooldata.ini, DrinkDetectionData, FlaskKey1
 Iniread,	FlaskKey2,	sidtooldata.ini, DrinkDetectionData, FlaskKey2
 Iniread,	FlaskKey3,	sidtooldata.ini, DrinkDetectionData, FlaskKey3
 Iniread,	FlaskKey4,	sidtooldata.ini, DrinkDetectionData, FlaskKey4
 Iniread,	DetectionInterval,	sidtooldata.ini, DrinkDetectionData, DetectionInterval
}
if CurrentProfile = 2
{
 Iniread,	FlaskKey1,	sidtooldata2.ini, DrinkDetectionData, FlaskKey1
 Iniread,	FlaskKey2,	sidtooldata2.ini, DrinkDetectionData, FlaskKey2
 Iniread,	FlaskKey3,	sidtooldata2.ini, DrinkDetectionData, FlaskKey3
 Iniread,	FlaskKey4,	sidtooldata2.ini, DrinkDetectionData, FlaskKey4
 Iniread,	DetectionInterval,	sidtooldata2.ini, DrinkDetectionData, DetectionInterval
}
if CurrentProfile = 3
{
 Iniread,	FlaskKey1,	sidtooldata3.ini, DrinkDetectionData, FlaskKey1
 Iniread,	FlaskKey2,	sidtooldata3.ini, DrinkDetectionData, FlaskKey2
 Iniread,	FlaskKey3,	sidtooldata3.ini, DrinkDetectionData, FlaskKey3
 Iniread,	FlaskKey4,	sidtooldata3.ini, DrinkDetectionData, FlaskKey4
 Iniread,	DetectionInterval,	sidtooldata3.ini, DrinkDetectionData, DetectionInterval
}
Return

;[Advanced Drink Mode Toggle]----------------------------------------------------------
~F10::
(Autodrinkbutton = 0 ? (Autodrinkbutton := 1,ToolTip("Advanced drink mode ON")) : (Autodrinkbutton := 0,ToolTip("Advanced drink mode OFF")))
if Autodrinkbutton = 0
	{
	iniWrite,Off, sidtooldata.ini, AdvancedDrinkState, AdvancedDrinkState
	iniread,AdvancedDrinkState, sidtooldata.ini, AdvancedDrinkState, AdvancedDrinkState
	gosub,PauseLoopDrink
	gosub,StopDetectionLoops
	return
	}
if Autodrinkbutton = 1
	{
	if (Color4_X = "error" or Color4_Y = "error")
		{
		Autodrinkbutton := 0
		msgbox,16,Error,Scene detection point not set (click OK to see tutorial image)!`rF10 advanced mode has been turned off.
		run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/1163223583_2.png,,UseErrorLevel
		return
		}
	gosub,ReadColorCoordinates
	if HealthBarReturnChecked = +checked
	settimer,DetectHealthBarReturn,21
	if ChaosPenetrationReturnChecked = +checked
	settimer,DetectChaosPenetrationReturn,23,-1
	if HealthBarDrinkChecked = +checked
	settimer,DetectHealthBar,31,-1
	if ManaGlobeDrinkChecked = +checked
	settimer,DetectManaGlobe,51,-1
	if ChaosPenetrationChecked = +checked
	settimer,DetectChaosPenetration,37,-1
	if HealthGlobeChecked = +checked
	settimer,DetectHealthGlobe,41,-1
	settimer,DetectSceneChange,57,-1
	}
return

;[Detection Loops (HP/Mana/Scene)]---------------------------------------------------------------------------------------------------

DetectHealthBar:
IfWinActive,Path of Exile
{
if (HealthBarDrinkChecked = "+Checked" and Autodrinkbutton = "1")
 {
   if (Color1_Y = "error" or FlaskKey1 = "error")
   {
   Autodrinkbutton := 0
   gosub,StopDetectionLoops
   ToolTip("Advanced drink mode OFF")
   msgbox,16,Error,Health bar detection point or flask key not set. Turned off F10.`r (Win+Z) -> Drink Detection Settings -> set flasks and interval.`rSet Health Bar point: use Righteous Fire to burn HP then [Win+C] capture code "1".
   return
   }
   else
   {
	PixelGetColor,HealthBlackBar, %Color1_X%, %Color1_Y%
	if HealthBlackBar = %Color1_C%
	{
		if ToolTipOff = 0
		ToolTip("Health bar detection -> drinking flask " . FlaskKey1)
		if Toolbutton = 0
		{
		send %FlaskKey1%
		sleep %DetectionInterval%
		}
	}
   }
 }
}
return


DetectHealthBarReturn:
IfWinActive,Path of Exile
{
if (HealthBarReturnChecked = "+Checked" and Autodrinkbutton = "1")
   {
    if Color2_Y = "error"
    {
   	Autodrinkbutton := 0
   	gosub,StopDetectionLoops
   	ToolTip("Advanced drink mode OFF")
   	msgbox,16,Error,Health bar return point not set. Turned off F10.`r(Win+Z) -> Drink Detection Settings -> disable if unused.`rSet Health Bar return point: burn HP then [Win+C] capture code "2".
   	return
    }
    else
    {
	PixelGetColor,HealthBlackBar2, %Color2_X%, %Color2_Y%
	if HealthGlobeChecked = +checked
	{
		if HealthGlobe = %Color9_C%
		{

		}
		else
		{
   			if HealthBlackBar2 = %Color2_C%
				{
					if ToolTipOff = 0
					ToolTip("Health bar and globe both low -> returning to character")
					Critical
					if Toolbutton = 0
					gosub,ReturnToCharacter
				}
		}
	}
	else
	{
		if HealthBlackBar2 = %Color2_C%
		{
			if ToolTipOff = 0
			ToolTip("Health bar low -> returning to character")
			Critical
			if Toolbutton = 0
			gosub,ReturnToCharacter
		}
	}
    }
   }
}
return


DetectManaGlobe:
IfWinActive,Path of Exile
{
if (ManaGlobeDrinkChecked = "+Checked" and Autodrinkbutton = "1")
 {
   if (Color3_Y = "error" or FlaskKey2 = "error")
   {
   Autodrinkbutton := 0
   gosub,StopDetectionLoops
   ToolTip("Advanced drink mode OFF")
   msgbox,16,Error,Mana globe detection point or flask key not set. Turned off F10.`r(Win+Z) -> Drink Detection Settings -> set flasks and interval.`rSet Mana Globe point: [Win+C] capture code "3" when mana is full.
   return
   }
   else
   {
	PixelGetColor,ManaPool, %Color3_X%, %Color3_Y%
	if ManaPool = %Color3_C%
	{
	}
	else
	{
	if SceneColorState = Stable
	   {
		PixelGetColor,ManaPool, %Color3_X%, %Color3_Y%
		if ManaPool = %Color3_C%
		{
		}
		else
		{
		if ToolTipOff = 0
		ToolTip("Mana globe low -> drinking flask " . FlaskKey2)
			if Toolbutton = 0
			{
			send %FlaskKey2%
			sleep %DetectionInterval%
			}
		}
	   }
	}
   }
 }
}
return

DetectChaosPenetration:
IfWinActive,Path of Exile
{
if (ChaosPenetrationChecked = "+Checked" and Autodrinkbutton = "1")
 {
   if (Color7_Y = "error" or FlaskKey3 = "error")
   {
   Autodrinkbutton := 0
   gosub,StopDetectionLoops
   ToolTip("Advanced drink mode OFF")
   msgbox,16,Error,Chaos penetration point or flask key not set. Turned off F10.`r(Win+Z) -> Drink Detection Settings -> set flasks and interval.`rSet point: use RF to drain HP while ES full then [Win+C] capture code "7".
   return
   }
   else
   {
	PixelGetColor,HealthBlackBar3, %Color7_X%, %Color7_Y%
	if HealthBlackBar3 = %Color7_C%
	{
		if ToolTipOff = 0
		ToolTip("Chaos penetration detected -> drinking flask " . FlaskKey3)
		if Toolbutton = 0
		{
		send %FlaskKey3%
		sleep %DetectionInterval%
		}
	}
   }
 }
}
return

DetectChaosPenetrationReturn:
IfWinActive,Path of Exile
{
if (ChaosPenetrationReturnChecked = "+Checked" and Autodrinkbutton = "1")
   {
    if Color8_Y = "error"
    {
   	Autodrinkbutton := 0
   	gosub,StopDetectionLoops
   	ToolTip("Advanced drink mode OFF")
   	msgbox,16,Error,Chaos penetration return point not set. Turned off F10.`r(Win+Z) -> Drink Detection Settings -> disable if unused.`rSet point: use RF to drain HP with ES full then [Win+C] capture code "8".
   	return
    }
    else
    {
	PixelGetColor,HealthBlackBar4, %Color8_X%, %Color8_Y%
	if HealthGlobeChecked = +checked
	{
		if HealthGlobe = %Color9_C%
		{

		}
		else
		{
   			if HealthBlackBar4 = %Color8_C%
				{
					if ToolTipOff = 0
					ToolTip("Chaos penetration + health globe low -> returning")
					Critical
					if Toolbutton = 0
					gosub,ReturnToCharacter
				}
		}
	}
	else
	{
		if HealthBlackBar4 = %Color8_C%
		{
			if ToolTipOff = 0
			ToolTip("Chaos penetration health bar low -> returning")
			Critical
			if Toolbutton = 0
			gosub,ReturnToCharacter
		}
	}
    }
   }
}
return

DetectHealthGlobe:
IfWinActive,Path of Exile
{
if (HealthGlobeChecked = "+checked" and Autodrinkbutton = "1")
 {
   if (Color9_Y = "error" or FlaskKey4 = "error")
   {
   Autodrinkbutton := 0
   gosub,StopDetectionLoops
   ToolTip("Advanced drink mode OFF")
   msgbox,16,Error,Health globe detection point or flask key not set. Turned off F10.`rSet point: [Win+C] capture code "9" when full.
   return
   }
   else
   {
	PixelGetColor,HealthGlobe, %Color9_X%, %Color9_Y%
	if HealthGlobe = %Color9_C%
	{
	}
	else
	{
	if SceneColorState = Stable
	   {
		PixelGetColor,HealthGlobe, %Color9_X%, %Color9_Y%
		if HealthGlobe = %Color9_C%
		{
		}
		else if Toolbutton = 0
		{
		if ToolTipOff = 0
		ToolTip("Health globe low -> drinking flask " . FlaskKey4)
		send %FlaskKey4%
		sleep %DetectionInterval%
		}
	   }
	}
   }
 }
}
return

DetectSceneChange:
IfWinActive,Path of Exile
 {
 if Autodrinkbutton = 1
  {
   Tolerance := 25 
   PixelSearch, FoundX, FoundY, Color4_X, Color4_Y, Color4_X, Color4_Y, %Color4_C%, %Tolerance%, RGB
   if (ErrorLevel = 0)
	{
	if SceneColorState = Changing
	   {
	   SceneColorState = Intermediate
	   sleep 1000
	   SceneColorState = Stable
	   }
	if SceneColorState = Stable
	   {
	   SceneColorState = Stable
	   }
	}
    else
	{
	gosub,PauseLoopDrink
	Toolbutton := 0
	openI := 0
	SceneColorState = Changing
	ToolTip("Scene changing – paused loops (if persists, re‑set with Win+C)")
	CurrentStashPage = 0
	}
  }
}
return


;[Detection Point Setup ( Win + C )]-----------------------------------------------------------------------------------
#c::
MouseGetPos, thisPosX, thisPosY
PixelGetColor, colorabc, %thisPosX%, %thisPosY%
PosX := ["Color1_X","Color2_X","Color3_X","Color4_X","Color5_X","Color6_X","Color7_X","Color8_X","Color9_X"]
PosY := ["Color1_Y","Color2_Y","Color3_Y","Color4_Y","Color5_Y","Color6_Y","Color7_Y","Color8_Y","Color9_Y"]
CosA := ["Color1_C","Color2_C","Color3_C","Color4_C","Color5_C","Color6_C","Color7_C","Color8_C","Color9_C"]
InputBox, ColorID,Detection Point Recorder, Color [ %colorabc% ] at [ %thisPosX% `, %thisPosY% ]`r`r1 = Health bar drink point (capture empty color)`r2 = Health bar return point (capture empty color)`r3 = Mana globe drink point (capture full mana color)`r4 = Dark area above flasks (any black)`r5 = Enter dialog black area (1)`r6 = Enter dialog black area (2) (after info shift)`r7 = Chaos penetration health bar drink point (ES full, HP low)`r8 = Chaos penetration health bar return point`r9 = Health globe drink point (capture full HP color)`r`rEnter corresponding number (1~9)... ,,410,350
	if not ErrorLevel
	{
		checkColorID := RegExMatch(ColorID, "[1-9]$")
		if checkColorID = 1
		{
		 if CurrentProfile = 1
		 {
		 iniWrite,% thisPosX, sidtooldata.ini, ColorCoordinates, % PosX[ColorID]
		 iniWrite,% thisPosY, sidtooldata.ini, ColorCoordinates, % PosY[ColorID]
		 iniwrite,% colorabc, sidtooldata.ini, ColorCoordinates, % CosA[ColorID]
		 }
		 if CurrentProfile = 2
		 {
		 iniWrite,% thisPosX, sidtooldata2.ini, ColorCoordinates, % PosX[ColorID]
		 iniWrite,% thisPosY, sidtooldata2.ini, ColorCoordinates, % PosY[ColorID]
		 iniwrite,% colorabc, sidtooldata2.ini, ColorCoordinates, % CosA[ColorID]
		 }
		 if CurrentProfile = 3
		 {
		 iniWrite,% thisPosX, sidtooldata3.ini, ColorCoordinates, % PosX[ColorID]
		 iniWrite,% thisPosY, sidtooldata3.ini, ColorCoordinates, % PosY[ColorID]
		 iniwrite,% colorabc, sidtooldata3.ini, ColorCoordinates, % CosA[ColorID]
		 }
		}
		else
		{
		MsgBox,16,Error,Please enter a valid number (1~9)
		}
		gosub,ReadColorCoordinates
	}

		return

ReadColorCoordinates:
if CurrentProfile = 1
{
 loop,9
 {
 IniRead,Color%A_Index%_X,sidtooldata.ini,ColorCoordinates,Color%A_Index%_X
 IniRead,Color%A_Index%_Y,sidtooldata.ini,ColorCoordinates,Color%A_Index%_Y
 IniRead,Color%A_Index%_C,sidtooldata.ini,ColorCoordinates,Color%A_Index%_C
 }
}
if CurrentProfile = 2
{
 loop,9
 {
 IniRead,Color%A_Index%_X,sidtooldata2.ini,ColorCoordinates,Color%A_Index%_X
 IniRead,Color%A_Index%_Y,sidtooldata2.ini,ColorCoordinates,Color%A_Index%_Y
 IniRead,Color%A_Index%_C,sidtooldata2.ini,ColorCoordinates,Color%A_Index%_C
 }
}
if CurrentProfile = 3
{
 loop,9
 {
 IniRead,Color%A_Index%_X,sidtooldata3.ini,ColorCoordinates,Color%A_Index%_X
 IniRead,Color%A_Index%_Y,sidtooldata3.ini,ColorCoordinates,Color%A_Index%_Y
 IniRead,Color%A_Index%_C,sidtooldata3.ini,ColorCoordinates,Color%A_Index%_C
 }
}
return


;[Flask Lock Section]------------------------------------------------------------------------------------------

UseFlask1:
if FlaskDuration1 = off
send {1}
else if FlaskLock1 = None
{
send {1}
FlaskLock1 = Locked
settimer,FlaskLock1Timer,%FlaskDuration1%
}
return

UseFlask2:
if FlaskDuration2 = off
send {2}
else if FlaskLock2 = None
{
send {2}
FlaskLock2 = Locked
settimer,FlaskLock2Timer,%FlaskDuration2%
}
return

UseFlask3:
if FlaskDuration3 = off
send {3}
else if FlaskLock3 = None
{
send {3}
FlaskLock3 = Locked
settimer,FlaskLock3Timer,%FlaskDuration3%
}
return

UseFlask4:
if FlaskDuration4 = off
send {4}
else if FlaskLock4 = None
{
send {4}
FlaskLock4 = Locked
settimer,FlaskLock4Timer,%FlaskDuration4%
}
return

UseFlask5:
if FlaskDuration5 = off
send {5}
else if FlaskLock5 = None
{
send {5}
FlaskLock5 = Locked
settimer,FlaskLock5Timer,%FlaskDuration5%
}
return

FlaskLock1Timer:
if FlaskLock1 = None
settimer,FlaskLock1Timer,off
if FlaskLock1 = Locked
FlaskLock1 = None
return

FlaskLock2Timer:
if FlaskLock2 = None
settimer,FlaskLock2Timer,off
if FlaskLock2 = Locked
FlaskLock2 = None
return

FlaskLock3Timer:
if FlaskLock3 = None
settimer,FlaskLock3Timer,off
if FlaskLock3 = Locked
FlaskLock3 = None
return

FlaskLock4Timer:
if FlaskLock4 = None
settimer,FlaskLock4Timer,off
if FlaskLock4 = Locked
FlaskLock4 = None
return

FlaskLock5Timer:
if FlaskLock5 = None
settimer,FlaskLock5Timer,off
if FlaskLock5 = Locked
FlaskLock5 = None
return

;[1|2|3|4|5 Flask Keys]---------------------------------------------------------------

~*1::
settimer,FlaskLock1Timer,off
FlaskLock1 = None
return

~*2::
settimer,FlaskLock2Timer,off
FlaskLock2 = None
return

~*3::
settimer,FlaskLock3Timer,off
FlaskLock3 = None
return

~*4::
settimer,FlaskLock4Timer,off
FlaskLock4 = None
return

~*5::
settimer,FlaskLock5Timer,off
FlaskLock5 = None
return

;[Q|W|E|R|T Skill Keys]---------------------------------------------------------------

~*Q::
if Toolbutton = 1
{
settimer,DetectDialog1,25
settimer,DetectDialog2,25
}
if Toolbutton = 0
{
	if (Autodrinkbutton = "1" and FlaskTriggerMode = "Drink on Skill Use" and MainSkill = "Q")
	{
		if FlasksOnSkillUse contains 1
		gosub,UseFlask1
		if FlasksOnSkillUse contains 2
		gosub,UseFlask2
		if FlasksOnSkillUse contains 3
		gosub,UseFlask3
		if FlasksOnSkillUse contains 4
		gosub,UseFlask4
		if FlasksOnSkillUse contains 5
		gosub,UseFlask5
	}
	if (Autodrinkbutton = "1" and ComboSkill1 = "Q" and SkillComboEnabled = "On")
	{
	gosub,SkillCombo
	}
	if MineMode = On
	{
		if MineKey = Q
       		{
		sleep %DetonateDelay1%
		send {d}
		if MineStaffMode = On
		send {d down}
       		}
		if SmokeMineKey = Q
      		{
		send {d up}
		sleep %DetonateDelay2%
		send {d}
       		}
	}
}
return

~*W::
if Toolbutton = 1
{
settimer,DetectDialog1,25
settimer,DetectDialog2,25
}
if Toolbutton = 0
{
	if (Autodrinkbutton = "1" and FlaskTriggerMode = "Drink on Skill Use" and MainSkill = "W")
	{
		if FlasksOnSkillUse contains 1
		gosub,UseFlask1
		if FlasksOnSkillUse contains 2
		gosub,UseFlask2
		if FlasksOnSkillUse contains 3
		gosub,UseFlask3
		if FlasksOnSkillUse contains 4
		gosub,UseFlask4
		if FlasksOnSkillUse contains 5
		gosub,UseFlask5
	}
	if (Autodrinkbutton = "1" and ComboSkill1 = "W" and SkillComboEnabled = "On")
	{
	gosub,SkillCombo
	}
	if MineMode = On
	{
		if MineKey = W
       		{
		sleep %DetonateDelay1%
		send {d}
		if MineStaffMode = On
		send {d down}
       		}
		if SmokeMineKey = W
      		{
		send {d up}
		sleep %DetonateDelay2%
		send {d}
       		}
	}
}
return

~*E::
if Toolbutton = 1
{
settimer,DetectDialog1,25
settimer,DetectDialog2,25
}
if Toolbutton = 0
{
	if (Autodrinkbutton = "1" and FlaskTriggerMode = "Drink on Skill Use" and MainSkill = "E")
	{
		if FlasksOnSkillUse contains 1
		gosub,UseFlask1
		if FlasksOnSkillUse contains 2
		gosub,UseFlask2
		if FlasksOnSkillUse contains 3
		gosub,UseFlask3
		if FlasksOnSkillUse contains 4
		gosub,UseFlask4
		if FlasksOnSkillUse contains 5
		gosub,UseFlask5
	}
	if (Autodrinkbutton = "1" and ComboSkill1 = "E" and SkillComboEnabled = "On")
	{
	gosub,SkillCombo
	}
	if MineMode = On
	{
		if MineKey = E
       		{
		sleep %DetonateDelay1%
		send {d}
		if MineStaffMode = On
		send {d down}
       		}
		if SmokeMineKey = E
      		{
		send {d up}
		sleep %DetonateDelay1%
		send {d}
       		}
	}
}
return

~*R::
if Toolbutton = 1
{
settimer,DetectDialog1,25
settimer,DetectDialog2,25
}
if Toolbutton = 0
{
	if (Autodrinkbutton = "1" and FlaskTriggerMode = "Drink on Skill Use" and MainSkill = "R")
	{
		if FlasksOnSkillUse contains 1
		gosub,UseFlask1
		if FlasksOnSkillUse contains 2
		gosub,UseFlask2
		if FlasksOnSkillUse contains 3
		gosub,UseFlask3
		if FlasksOnSkillUse contains 4
		gosub,UseFlask4
		if FlasksOnSkillUse contains 5
		gosub,UseFlask5
	}
	if (Autodrinkbutton = "1" and ComboSkill1 = "R" and SkillComboEnabled = "On")
	{
	gosub,SkillCombo
	}
	if MineMode = On
	{
		if MineKey = R
       		{
		sleep %DetonateDelay1%
		send {d}
		if MineStaffMode = On
		send {d down}
       		}
		if SmokeMineKey = R
      		{
		send {d up}
		sleep %DetonateDelay1%
		send {d}
       		}
	}
}
return

~*T::
if Toolbutton = 1
{
settimer,DetectDialog1,25
settimer,DetectDialog2,25
}
if Toolbutton = 0
{
	if (Autodrinkbutton = "1" and FlaskTriggerMode = "Drink on Skill Use" and MainSkill = "T")
	{
		if FlasksOnSkillUse contains 1
		gosub,UseFlask1
		if FlasksOnSkillUse contains 2
		gosub,UseFlask2
		if FlasksOnSkillUse contains 3
		gosub,UseFlask3
		if FlasksOnSkillUse contains 4
		gosub,UseFlask4
		if FlasksOnSkillUse contains 5
		gosub,UseFlask5
	}
	if (Autodrinkbutton = "1" and ComboSkill1 = "T" and SkillComboEnabled = "On")
	{
	gosub,SkillCombo
	}
	if MineMode = On
	{
		if MineKey = T
       		{
		sleep %DetonateDelay1%
		send {d}
		if MineStaffMode = On
		send {d down}
       		}
		if SmokeMineKey = T
      		{
		send {d up}
		sleep %DetonateDelay1%
		send {d}
       		}
	}
}
return

;[Skill Combo Routine]-------------------------------------------------------------------------------------------------

SkillCombo:
if ComboSkill1 in Q,W,E,R,T
{
if ComboSkill2 in Q,W,E,R,T
{
	sleep %ComboDelay1%
	Send {%ComboSkill2%}
}
if ComboSkill3 in Q,W,E,R,T
{
	sleep %ComboDelay2%
	Send {%ComboSkill3%}
}
sleep 100
}
return

;[Skill Combo Settings GUI]-------------------------------------------------------------------------------------------------

SkillComboSettingsGUI:
Gui,SkillComboSettings:NEW,,Skill Combo Settings:
Gui +LabelSkillComboSettings -Resize  -MinimizeBox -MaximizeBox
Gui Font, cBlack
Gui Color, 0xFF80C0
Gui Font, s10 cBlue
Gui Add, Text, x5 y5 w80 h25, Skill Combo
Gui Add, DropDownList, vSkillComboEnabled x90 y2 w60 -Theme, %SkillComboEnabled%||On|Off|
Gui Add, Text, x5 y30 w40 h25, When using
Gui Add, DropDownList, vComboSkill1 x50 y25 w60 -Theme, %ComboSkill1%||Q|W|E|R|T|
Gui Add, Text, x115 y30 w70 h25, skill delay
Gui Add, Edit, vComboDelay1 x186 y25 w80 h20, %ComboDelay1%
Gui Add, Text, x270 y30 w80 h25, (ms) then use
Gui Add, DropDownList, vComboSkill2 x350 y25 w60 -Theme, %ComboSkill2%||Q|W|E|R|T|Off|
Gui Add, Text, x414 y30 w70 h25, skill delay
Gui Add, Edit, vComboDelay2 x485 y25 w80 h20 -Theme, %ComboDelay2%
Gui Add, Text, x568 y30 w80 h25, (ms) then use
Gui Add, DropDownList, vComboSkill3 x650 y25 w60 -Theme, %ComboSkill3%||Q|W|E|R|T|Off|
Gui Font
Gui Add, Button,  gSaveAndReadComboData x5 y55 w706 h20, Save & Close
Gui Show, w720 h82, Skill Combo Settings (works only in F10 advanced mode)
Return

SkillComboSettingsEscape:
SkillComboSettingsClose:
Msgbox,4,Notice,Settings not saved. Close anyway? (Yes / No)
IfMsgBox No
	Return
Else
	Gui,submit
Return

;[Skill Combo GUI Save Routine]-------------------------------------------------------------------------------------------------

SaveAndReadComboData:
Gui,submit
if CurrentProfile = 1
{
iniWrite,% ComboSkill1		, sidtooldata.ini, ComboSettings, ComboSkill1
iniWrite,% ComboSkill2		, sidtooldata.ini, ComboSettings, ComboSkill2
iniWrite,% ComboSkill3		, sidtooldata.ini, ComboSettings, ComboSkill3
iniWrite,% ComboDelay1	, sidtooldata.ini, ComboSettings, ComboDelay1
iniWrite,% ComboDelay2	, sidtooldata.ini, ComboSettings, ComboDelay2
iniWrite,% SkillComboEnabled	, sidtooldata.ini, ComboSettings, SkillComboEnabled
IniRead, ComboSkill1		, sidtooldata.ini, ComboSettings, ComboSkill1
IniRead, ComboSkill2		, sidtooldata.ini, ComboSettings, ComboSkill2
IniRead, ComboSkill3		, sidtooldata.ini, ComboSettings, ComboSkill3
IniRead, ComboDelay1	, sidtooldata.ini, ComboSettings, ComboDelay1
IniRead, ComboDelay2	, sidtooldata.ini, ComboSettings, ComboDelay2
IniRead, SkillComboEnabled	, sidtooldata.ini, ComboSettings, SkillComboEnabled
}
if CurrentProfile = 2
{
iniWrite,% ComboSkill1		, sidtooldata2.ini, ComboSettings, ComboSkill1
iniWrite,% ComboSkill2		, sidtooldata2.ini, ComboSettings, ComboSkill2
iniWrite,% ComboSkill3		, sidtooldata2.ini, ComboSettings, ComboSkill3
iniWrite,% ComboDelay1	, sidtooldata2.ini, ComboSettings, ComboDelay1
iniWrite,% ComboDelay2	, sidtooldata2.ini, ComboSettings, ComboDelay2
iniWrite,% SkillComboEnabled	, sidtooldata2.ini, ComboSettings, SkillComboEnabled
IniRead, ComboSkill1		, sidtooldata2.ini, ComboSettings, ComboSkill1
IniRead, ComboSkill2		, sidtooldata2.ini, ComboSettings, ComboSkill2
IniRead, ComboSkill3		, sidtooldata2.ini, ComboSettings, ComboSkill3
IniRead, ComboDelay1	, sidtooldata2.ini, ComboSettings, ComboDelay1
IniRead, ComboDelay2	, sidtooldata2.ini, ComboSettings, ComboDelay2
IniRead, SkillComboEnabled	, sidtooldata2.ini, ComboSettings, SkillComboEnabled
}
if CurrentProfile = 3
{
iniWrite,% ComboSkill1		, sidtooldata3.ini, ComboSettings, ComboSkill1
iniWrite,% ComboSkill2		, sidtooldata3.ini, ComboSettings, ComboSkill2
iniWrite,% ComboSkill3		, sidtooldata3.ini, ComboSettings, ComboSkill3
iniWrite,% ComboDelay1	, sidtooldata3.ini, ComboSettings, ComboDelay1
iniWrite,% ComboDelay2	, sidtooldata3.ini, ComboSettings, ComboDelay2
iniWrite,% SkillComboEnabled	, sidtooldata3.ini, ComboSettings, SkillComboEnabled
IniRead, ComboSkill1		, sidtooldata3.ini, ComboSettings, ComboSkill1
IniRead, ComboSkill2		, sidtooldata3.ini, ComboSettings, ComboSkill2
IniRead, ComboSkill3		, sidtooldata3.ini, ComboSettings, ComboSkill3
IniRead, ComboDelay1	, sidtooldata3.ini, ComboSettings, ComboDelay1
IniRead, ComboDelay2	, sidtooldata3.ini, ComboSettings, ComboDelay2
IniRead, SkillComboEnabled	, sidtooldata3.ini, ComboSettings, SkillComboEnabled
}
Return

ReadSkillComboData:
if CurrentProfile = 1
{
IniRead, ComboSkill1		, sidtooldata.ini, ComboSettings, ComboSkill1
IniRead, ComboSkill2		, sidtooldata.ini, ComboSettings, ComboSkill2
IniRead, ComboSkill3		, sidtooldata.ini, ComboSettings, ComboSkill3
IniRead, ComboDelay1	, sidtooldata.ini, ComboSettings, ComboDelay1
IniRead, ComboDelay2	, sidtooldata.ini, ComboSettings, ComboDelay2
IniRead, SkillComboEnabled	, sidtooldata.ini, ComboSettings, SkillComboEnabled
}
if CurrentProfile = 2
{
IniRead, ComboSkill1		, sidtooldata2.ini, ComboSettings, ComboSkill1
IniRead, ComboSkill2		, sidtooldata2.ini, ComboSettings, ComboSkill2
IniRead, ComboSkill3		, sidtooldata2.ini, ComboSettings, ComboSkill3
IniRead, ComboDelay1	, sidtooldata2.ini, ComboSettings, ComboDelay1
IniRead, ComboDelay2	, sidtooldata2.ini, ComboSettings, ComboDelay2
IniRead, SkillComboEnabled	, sidtooldata2.ini, ComboSettings, SkillComboEnabled
}
if CurrentProfile = 3
{
IniRead, ComboSkill1		, sidtooldata3.ini, ComboSettings, ComboSkill1
IniRead, ComboSkill2		, sidtooldata3.ini, ComboSettings, ComboSkill2
IniRead, ComboSkill3		, sidtooldata3.ini, ComboSettings, ComboSkill3
IniRead, ComboDelay1	, sidtooldata3.ini, ComboSettings, ComboDelay1
IniRead, ComboDelay2	, sidtooldata3.ini, ComboSettings, ComboDelay2
IniRead, SkillComboEnabled	, sidtooldata3.ini, ComboSettings, SkillComboEnabled
}
Return

;[Auto Detonate Mines Settings GUI]--------------------------------------------------------------------------------------

AutoDetonateMinesGUI:
Gui AutoDetonateMines: New,,Auto Detonate Mines Settings
Gui +LabelAutoDetonateMines -Resize  -MinimizeBox -MaximizeBox
Gui Font, s12 cRed
Gui Add, Text, x15 y10 w100 h20, Auto Detonate
Gui Add, Text, x180 y10 w100 h20, Mine Staff Mode
Gui Add, Button,gSaveAndReadMineSettings x15 y101 w539 h23, Save & Close
Gui Font
Gui Add, ComboBox, vMineMode x118 y9 w60 -Theme, On|Off|%MineMode%||
Gui Add, ComboBox, vMineStaffMode x264 y9 w60 -Theme, On|Off|%MineStaffMode%||
Gui Add, ComboBox, vMineKey x103 y39 w41 -Theme, Q|W|E|R|T|%MineKey%||
Gui Add, ComboBox, vDetonateDelay1 x264 y37 w46 -Theme, 50|100|200|300|400|500|%DetonateDelay1%||
Gui Add, ComboBox, vSmokeMineKey x103 y69 w41 -Theme, Q|W|E|R|T|%SmokeMineKey%||
Gui Add, ComboBox, vDetonateDelay2 x264 y69 w46 -Theme, 50|100|200|300|400|500|%DetonateDelay2%||
Gui Font, s12
Gui Add, Text, x15 y40 w86 h20, When using key
Gui Add, Text, x147 y40 w115 h20, mine skill delay
Gui Add, Text, x314 y40 w243 h20, (ms) then auto detonate (default D)
Gui Add, Text, x15 y70 w86 h20, When using key
Gui Add, Text, x147 y70 w115 h20, smoke mine delay
Gui Add, Text, x314 y70 w243 h20, (ms) then auto detonate (default D)
Gui Font
Gui Add, StatusBar,, ▲ Tip: Auto detonate uses the game default key [D].
Gui Show, w570 h156, Auto Detonate Mines Settings
Return

AutoDetonateMinesEscape:
AutoDetonateMinesClose:
Msgbox,4,Notice,Settings not saved. Close anyway? (Yes / No)
IfMsgBox No
	Return
Else
	Gui,submit
Return

;[Auto Detonate Mines GUI Save Routine]--------------------------------------------------------------------------------------

SaveAndReadMineSettings:
Gui,submit
if CurrentProfile = 1
{
iniWrite,% MineMode,	sidtooldata.ini, MineSettings, MineMode
iniWrite,% MineStaffMode,	sidtooldata.ini, MineSettings, MineStaffMode
iniWrite,% MineKey,	sidtooldata.ini, MineSettings, MineKey
iniWrite,% DetonateDelay1,	sidtooldata.ini, MineSettings, DetonateDelay1
iniWrite,% SmokeMineKey,	sidtooldata.ini, MineSettings, SmokeMineKey
iniWrite,% DetonateDelay2,	sidtooldata.ini, MineSettings, DetonateDelay2
IniRead, MineMode,	sidtooldata.ini, MineSettings, MineMode
IniRead,MineStaffMode,	sidtooldata.ini, MineSettings, MineStaffMode
IniRead, MineKey,	sidtooldata.ini, MineSettings, MineKey
IniRead, DetonateDelay1,	sidtooldata.ini, MineSettings, DetonateDelay1
IniRead, SmokeMineKey,	sidtooldata.ini, MineSettings, SmokeMineKey
IniRead, DetonateDelay2,	sidtooldata.ini, MineSettings, DetonateDelay2
}
if CurrentProfile = 2
{
iniWrite,% MineMode,	sidtooldata2.ini, MineSettings, MineMode
iniWrite,% MineStaffMode,	sidtooldata.ini, MineSettings, MineStaffMode
iniWrite,% MineKey,	sidtooldata2.ini, MineSettings, MineKey
iniWrite,% DetonateDelay1,	sidtooldata2.ini, MineSettings, DetonateDelay1
iniWrite,% SmokeMineKey,	sidtooldata2.ini, MineSettings, SmokeMineKey
iniWrite,% DetonateDelay2,	sidtooldata2.ini, MineSettings, DetonateDelay2
IniRead, MineMode,	sidtooldata2.ini, MineSettings, MineMode
IniRead,MineStaffMode,	sidtooldata.ini, MineSettings, MineStaffMode
IniRead, MineKey,	sidtooldata2.ini, MineSettings, MineKey
IniRead, DetonateDelay1,	sidtooldata2.ini, MineSettings, DetonateDelay1
IniRead, SmokeMineKey,	sidtooldata2.ini, MineSettings, SmokeMineKey
IniRead, DetonateDelay2,	sidtooldata2.ini, MineSettings, DetonateDelay2
}
if CurrentProfile = 3
{
iniWrite,% MineMode,	sidtooldata3.ini, MineSettings, MineMode
iniWrite,% MineStaffMode,	sidtooldata.ini, MineSettings, MineStaffMode
iniWrite,% MineKey,	sidtooldata3.ini, MineSettings, MineKey
iniWrite,% DetonateDelay1,	sidtooldata3.ini, MineSettings, DetonateDelay1
iniWrite,% SmokeMineKey,	sidtooldata3.ini, MineSettings, SmokeMineKey
iniWrite,% DetonateDelay2,	sidtooldata3.ini, MineSettings, DetonateDelay2
IniRead, MineMode,	sidtooldata3.ini, MineSettings, MineMode
IniRead,MineStaffMode,	sidtooldata.ini, MineSettings, MineStaffMode
IniRead, MineKey,	sidtooldata3.ini, MineSettings, MineKey
IniRead, DetonateDelay1,	sidtooldata3.ini, MineSettings, DetonateDelay1
IniRead, SmokeMineKey,	sidtooldata3.ini, MineSettings, SmokeMineKey
IniRead, DetonateDelay2,	sidtooldata3.ini, MineSettings, DetonateDelay2
}
Return

ReadMineSettings:
if CurrentProfile = 1
{
IniRead, MineMode,	sidtooldata.ini, MineSettings, MineMode
IniRead,MineStaffMode,	sidtooldata.ini, MineSettings, MineStaffMode
IniRead, MineKey,	sidtooldata.ini, MineSettings, MineKey
IniRead, DetonateDelay1,	sidtooldata.ini, MineSettings, DetonateDelay1
IniRead, SmokeMineKey,	sidtooldata.ini, MineSettings, SmokeMineKey
IniRead, DetonateDelay2,	sidtooldata.ini, MineSettings, DetonateDelay2
}
if CurrentProfile = 2
{
IniRead, MineMode,	sidtooldata2.ini, MineSettings, MineMode
IniRead,MineStaffMode,	sidtooldata.ini, MineSettings, MineStaffMode
IniRead, MineKey,	sidtooldata2.ini, MineSettings, MineKey
IniRead, DetonateDelay1,	sidtooldata2.ini, MineSettings, DetonateDelay1
IniRead, SmokeMineKey,	sidtooldata2.ini, MineSettings, SmokeMineKey
IniRead, DetonateDelay2,	sidtooldata2.ini, MineSettings, DetonateDelay2
}
if CurrentProfile = 3
{
IniRead, MineMode,	sidtooldata3.ini, MineSettings, MineMode
IniRead,MineStaffMode,	sidtooldata.ini, MineSettings, MineStaffMode
IniRead, MineKey,	sidtooldata3.ini, MineSettings, MineKey
IniRead, DetonateDelay1,	sidtooldata3.ini, MineSettings, DetonateDelay1
IniRead, SmokeMineKey,	sidtooldata3.ini, MineSettings, SmokeMineKey
IniRead, DetonateDelay2,	sidtooldata3.ini, MineSettings, DetonateDelay2
}
Return

;[Quick Stash Search (Hotkeys)]---------------------------------------------------------------------------------

QuickStashSearchSetup:
gosub,QuickStashSearchGUI
return

^LWin::
Gosub,GoFirstPage
return



GoFirstPage:
clipboard =
Send {left %ReturnPage%}
CurrentStashPage = 0
return

~^alt::
gosub,QuickStashSearch
return

QuickStashSearch:
clipboard =
StashMatchStatus = Searching
Send, ^c
ClipWait, 1
if ErrorLevel = 1
return

TempClipContent = %Clipboard%

if StashMatchStatus = Searching
IfInString,TempClipContent,Item Class: Stackable Currency	,gosub,GotoStackableCurrency
if StashMatchStatus = Searching
if TempClipContent contains Incubator
gosub,GotoIncubator
if StashMatchStatus = Searching
IfInString,TempClipContent,Item Class: Heist Equipment	,gosub,GotoHeist
if StashMatchStatus = Searching
if TempClipContent contains Maven's Invitation,Chronicle of Atziri,Influenced by The Elder
gosub,GotoSpecialMaps
if StashMatchStatus = Searching
IfInString,TempClipContent,Item Class: Jewel	,gosub,SecondCheckJewel
if StashMatchStatus = Searching
IfInString,TempClipContent,Item Class: Abyss Jewel,gosub,GotoAbyssJewel
if StashMatchStatus = Searching
IfInString,TempClipContent,Breach Ring	,gosub,GotoBreachRing
if StashMatchStatus = Searching
IfInString,TempClipContent,(enchant)	,gosub,SecondCheckEnchant
if StashMatchStatus = Searching
if TempClipContent contains Shaper Item,Elder Item,Warlord Item,Hunter Item,Redeemer Item,Crusader Item
gosub,SecondCheckInfluenced
if StashMatchStatus = Searching
IfInString,TempClipContent,Unidentified		,gosub,SecondCheckUnidentified
if StashMatchStatus = Searching
if TempClipContent contains Ring
gosub,SecondCheckUniqueRing
if StashMatchStatus = Searching
IfInString,TempClipContent,Rarity: Unique	,gosub,GotoUniqueGear
return

;[Quick Stash Search Routines]-----------------------------------------------------------------------------------------------------------------------------

StashPageCalc:
CalcValue :=  abs(CurrentStashPage - FoundStashPage)

if (FoundStashPage > CurrentStashPage)
{
Send {right %CalcValue%}
return
}
if (FoundStashPage < CurrentStashPage)
{
Send {left %CalcValue%}
return
}
return


SecondCheckUnidentified:
IfInString,TempClipContent,Rarity: Rare	,gosub,ThirdCheckUnidentified
return

SecondCheckJewel:
if TempClipContent contains Rarity: Normal,Rarity: Magic,Rarity: Rare
{
IfInString,TempClipContent,Cluster Jewel	,gosub,GotoClusterJewel
if TempClipContent contains Cobalt Jewel,Viridian Jewel,Crimson Jewel
gosub,GotoNormalJewel
}
return

SecondCheckEnchant:
if TempClipContent contains Item Class: Gloves,Item Class: Helmet,Item Class: Boots
gosub,GotoEnchantGear
return

ThirdCheckUnidentified:
IfInString,TempClipContent,Item Class: Helmet	,gosub,GotoUnidentifiedRareHelmet
IfInString,TempClipContent,Item Class: Body Armour	,gosub,GotoUnidentifiedRareBody
IfInString,TempClipContent,Item Class: Belt	,gosub,GotoUnidentifiedRareBelt
IfInString,TempClipContent,Item Class: Gloves	,gosub,GotoUnidentifiedRareGloves
IfInString,TempClipContent,Item Class: Boots	,gosub,GotoUnidentifiedRareBoots
IfInString,TempClipContent,Item Class: Ring	,gosub,GotoUnidentifiedRareAccessory
IfInString,TempClipContent,Item Class: Amulet	,gosub,GotoUnidentifiedRareAccessory
if TempClipContent contains Item Class: Claw,Item Class: Dagger,Item Class: Wand,Item Class: One Hand Sword,Item Class: Rapier,Item Class: One Hand Axe,Item Class: One Hand Mace,Item Class: Sceptre,Item Class: Rune Dagger,Item Class: Bow,Item Class: Staff,Item Class: Two Hand Sword,Item Class: Two Hand Axe,Item Class: Two Hand Mace,Item Class: Warstaff
gosub,GotoUnidentifiedRareWeapon
return

GotoUnidentifiedRareHelmet:
FoundStashPage := UnidentifiedRareHelmet
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := UnidentifiedRareHelmet
return

GotoUnidentifiedRareBody:
FoundStashPage := UnidentifiedRareBody
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := UnidentifiedRareBody
return

GotoUnidentifiedRareBelt:
FoundStashPage := UnidentifiedRareBelt
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := UnidentifiedRareBelt
return

GotoUnidentifiedRareGloves:
FoundStashPage := UnidentifiedRareGloves
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := UnidentifiedRareGloves
return

GotoUnidentifiedRareBoots:
FoundStashPage := UnidentifiedRareBoots
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := UnidentifiedRareBoots
return

GotoUnidentifiedRareAccessory:
FoundStashPage := UnidentifiedRareAccessory
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := UnidentifiedRareAccessory
return

GotoUnidentifiedRareWeapon:
FoundStashPage := UnidentifiedRareWeapon
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := UnidentifiedRareWeapon
return

SecondCheckUniqueRing:
IfInString,TempClipContent,Rarity: Unique	,gosub,GotoUniqueRing
return

SecondCheckInfluenced:
if TempClipContent contains Rarity: Rare,Rarity: Normal,Rarity: Magic
gosub,GotoInfluencedPage
return

GotoClusterJewel:
FoundStashPage := ClusterJewel
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := ClusterJewel
return

GotoNormalJewel:
FoundStashPage := NormalJewel
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := NormalJewel
return

GotoAbyssJewel:
FoundStashPage := AbyssJewel
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := AbyssJewel
return

GotoIncubator:
FoundStashPage := Incubator
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := Incubator
return

GotoInfluencedPage:
FoundStashPage := InfluencedPage
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := InfluencedPage
return

GotoUniqueGear:
FoundStashPage := UniqueGear
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := UniqueGear
MatchType = ShiftNeeded
return

GotoEnchantGear:
FoundStashPage := EnchantGear
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := EnchantGear
MatchType = ShiftNeeded
return

GotoHeist:
FoundStashPage := Heist
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := Heist
return

GotoUniqueRing:
{
FoundStashPage := UniqueRing
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := UniqueRing
MatchType = ShiftNeeded
return
}
return

GotoSpecialMaps:
FoundStashPage := SpecialMaps
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := SpecialMaps
MatchType = ShiftNeeded
return

GotoBreachRing:
FoundStashPage := BreachRing
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := BreachRing
return

GotoStackableCurrency:
FoundStashPage := 0
gosub,StashPageCalc
StashMatchStatus = Success
CurrentStashPage := 0
return

;[Quick Stash Search Settings GUI]----------------------------------------------------------------------------------------------------------------

QuickStashSearchGUI:
Gui QuickStashSearch: New,,Quick Stash Search Settings (Ctrl+Alt auto-page, Ctrl+Win back to first)
Gui +LabelQuickStashSearch -Resize  -MinimizeBox -MaximizeBox
Gui Color, 0x00FFFF
Gui Add, Text, x79 y32 w46 h0 +0x200, Text
Gui Font
Gui Font, s10 Bold cRed
Gui Add, Text, x7 y6 w526 h23 +0x200, Currency tab should be first page. Example: first=0, second=1, etc.
Gui Font
Gui Font, s13 Norm cRed
Gui, Add, Link, x390 y40 w140 h30, Video<a href="https://youtu.be/StpFz8qbB44">click</a>
Gui Font
Gui Font, s10 Norm cBlue
Gui Add, Text, x4 y40 w50 h20, % " Enchant :"
Gui Add, Text, x4 y65 w50 h20, % " Unique :"
Gui Add, Text, x4 y90 w50 h20, % " UniqueRing :"
Gui Add, Text, x4 y115 w50 h20, % " Heist :"
Gui Add, Text, x4 y140 w50 h20, % " (unused) :"
Gui Add, Text, x4 y165 w50 h20, % " Incubator :"
Gui Add, Text, x4 y190 w50 h20, % " AbyssJewel :"
Gui Add, Text, x4 y215 w50 h20, % " Cluster :"
Gui Add, Text, x4 y240 w50 h20, % " NormalJewel :"
Gui Add, Text, x100 y40 w130 h20,  % " Unid Rare Helm :"
Gui Add, Text, x100 y65 w130 h20,  % " Unid Rare Body :"
Gui Add, Text, x100 y90 w130 h20,  % " Unid Rare Belt :"
Gui Add, Text, x100 y115 w130 h20, % " Unid Rare Gloves :"
Gui Add, Text, x100 y140 w130 h20, % " Unid Rare Boots :"
Gui Add, Text, x100 y165 w130 h20, % " Unid Rare Acc :"
Gui Add, Text, x100 y190 w130 h20, % " Unid Rare Weapon :"
Gui Add, Text, x100 y215 w130 h20, % " Influenced Page :"
Gui Add, Text, x100 y240 w180 h20, % " Special Maps :"
Gui Add, Text, x260 y40 w70 h20,  % " Breach Ring :"
Gui Font
Gui Font, s10 cBlue
Gui Add, Text, x6 y265 w251 h25, % " [Ctrl+Win] return to first page (enter max page) :"
Gui Font
Gui Font, cRed
Gui Add, Edit, vEnchantGear x58 y35 w35 h20 +Number -Theme	,% EnchantGear
Gui Add, Edit, vUniqueGear x58 y60 w35 h20 +Number -Theme	,% UniqueGear
Gui Add, Edit, vUniqueRing x58 y85 w35 h20 +Number -Theme	,% UniqueRing
Gui Add, Edit, vHeist x58 y110 w35 h20 +Number -Theme	,% Heist
Gui Add, Edit, vRemove2 x58 y135 w35 h20 +Number -Theme	,% Remove2
Gui Add, Edit, vIncubator x58 y160 w35 h20 +Number -Theme	,% Incubator
Gui Add, Edit, vAbyssJewel x58 y185 w35 h20 +Number -Theme	,% AbyssJewel
Gui Add, Edit, vClusterJewel x58 y210 w35 h20 +Number -Theme	,% ClusterJewel
Gui Add, Edit, vNormalJewel x58 y235 w35 h20 +Number -Theme	,% NormalJewel
Gui Add, Edit, vUnidentifiedRareHelmet x220 y35 w35 h20 +Number -Theme	,% UnidentifiedRareHelmet
Gui Add, Edit, vUnidentifiedRareBody x220 y60 w35 h20 +Number -Theme	,% UnidentifiedRareBody
Gui Add, Edit, vUnidentifiedRareBelt x220 y85 w35 h20 +Number -Theme	,% UnidentifiedRareBelt
Gui Add, Edit, vUnidentifiedRareGloves x220 y110 w35 h20 +Number -Theme	,% UnidentifiedRareGloves
Gui Add, Edit, vUnidentifiedRareBoots x220 y135 w35 h20 +Number -Theme	,% UnidentifiedRareBoots
Gui Add, Edit, vUnidentifiedRareAccessory x220 y160 w35 h20 +Number -Theme	,% UnidentifiedRareAccessory
Gui Add, Edit, vUnidentifiedRareWeapon x220 y185 w35 h20 +Number -Theme	,% UnidentifiedRareWeapon
Gui Add, Edit, vInfluencedPage x220 y210 w35 h20 +Number -Theme	,% InfluencedPage
Gui Add, Edit, vSpecialMaps x220 y235 w35 h20 +Number -Theme	,% SpecialMaps
Gui Add, Edit, vBreachRing x330 y35 w35 h20 +Number -Theme	,% BreachRing
Gui Add, Edit, vReturnPage x259 y261 w35 h20 +Number -Theme	,% ReturnPage
Gui Add, StatusBar,, Made by Sid. Enter 0 for unused tabs, avoid saving Error.
Gui Add, Button, gSaveAndReadStashData x400 y261 w90 h23, Save & Close
Gui Show, x697 y320 w500 h310
Return

QuickStashSearchEscape:
QuickStashSearchClose:
Msgbox,4,Notice,Settings not saved. Close anyway? (Yes / No)
IfMsgBox No
	Return
Else
	Gui,submit
Return

;[Quick Stash Search GUI Save Routine]----------------------------------------------------------------------------------------------------------------

SaveAndReadStashData:
Gui,submit
iniWrite,% EnchantGear, sidtooldata.ini, StashTabNumbers, EnchantGear
iniWrite,% UniqueGear, sidtooldata.ini, StashTabNumbers, UniqueGear
iniWrite,% UniqueRing, sidtooldata.ini, StashTabNumbers, UniqueRing
iniWrite,% Heist, sidtooldata.ini, StashTabNumbers, Heist
iniWrite,% Remove2, sidtooldata.ini, StashTabNumbers, Remove2
iniWrite,% Incubator, sidtooldata.ini, StashTabNumbers, Incubator
iniWrite,% AbyssJewel, sidtooldata.ini, StashTabNumbers, AbyssJewel
iniWrite,% ClusterJewel, sidtooldata.ini, StashTabNumbers, ClusterJewel
iniWrite,% NormalJewel, sidtooldata.ini, StashTabNumbers, NormalJewel
iniWrite,% InfluencedPage, sidtooldata.ini, StashTabNumbers, InfluencedPage
iniWrite,% SpecialMaps, sidtooldata.ini, StashTabNumbers, SpecialMaps
iniWrite,% BreachRing, sidtooldata.ini, StashTabNumbers, BreachRing
iniWrite,% ReturnPage, sidtooldata.ini, StashTabNumbers, ReturnPage
iniWrite,% UnidentifiedRareHelmet, sidtooldata.ini, StashTabNumbers, UnidentifiedRareHelmet
iniWrite,% UnidentifiedRareBody, sidtooldata.ini, StashTabNumbers, UnidentifiedRareBody
iniWrite,% UnidentifiedRareBelt, sidtooldata.ini, StashTabNumbers, UnidentifiedRareBelt
iniWrite,% UnidentifiedRareGloves, sidtooldata.ini, StashTabNumbers, UnidentifiedRareGloves
iniWrite,% UnidentifiedRareBoots, sidtooldata.ini, StashTabNumbers, UnidentifiedRareBoots
iniWrite,% UnidentifiedRareAccessory, sidtooldata.ini, StashTabNumbers, UnidentifiedRareAccessory
iniWrite,% UnidentifiedRareWeapon, sidtooldata.ini, StashTabNumbers, UnidentifiedRareWeapon
 iniread, EnchantGear, sidtooldata.ini, StashTabNumbers, EnchantGear
 iniread, UniqueGear, sidtooldata.ini, StashTabNumbers, UniqueGear
 iniread, UniqueRing, sidtooldata.ini, StashTabNumbers, UniqueRing
 iniread, Heist, sidtooldata.ini, StashTabNumbers, Heist
 iniread, Remove2, sidtooldata.ini, StashTabNumbers, Remove2
 iniread, Incubator, sidtooldata.ini, StashTabNumbers, Incubator
 iniread, AbyssJewel, sidtooldata.ini, StashTabNumbers, AbyssJewel
 iniread, ClusterJewel, sidtooldata.ini, StashTabNumbers, ClusterJewel
 iniread, NormalJewel, sidtooldata.ini, StashTabNumbers, NormalJewel
 iniread, InfluencedPage, sidtooldata.ini, StashTabNumbers, InfluencedPage
 iniread, SpecialMaps, sidtooldata.ini, StashTabNumbers, SpecialMaps
 iniread, BreachRing, sidtooldata.ini, StashTabNumbers, BreachRing
 iniread, ReturnPage, sidtooldata.ini, StashTabNumbers, ReturnPage
 iniread, UnidentifiedRareHelmet, sidtooldata.ini, StashTabNumbers, UnidentifiedRareHelmet
 iniread, UnidentifiedRareBody, sidtooldata.ini, StashTabNumbers, UnidentifiedRareBody
 iniread, UnidentifiedRareBelt, sidtooldata.ini, StashTabNumbers, UnidentifiedRareBelt
 iniread, UnidentifiedRareGloves, sidtooldata.ini, StashTabNumbers, UnidentifiedRareGloves
 iniread, UnidentifiedRareBoots, sidtooldata.ini, StashTabNumbers, UnidentifiedRareBoots
 iniread, UnidentifiedRareAccessory, sidtooldata.ini, StashTabNumbers, UnidentifiedRareAccessory
 iniread, UnidentifiedRareWeapon, sidtooldata.ini, StashTabNumbers, UnidentifiedRareWeapon
Return

ReadStashTabData:
iniread, EnchantGear, sidtooldata.ini, StashTabNumbers, EnchantGear
iniread, UniqueGear, sidtooldata.ini, StashTabNumbers, UniqueGear
iniread, UniqueRing, sidtooldata.ini, StashTabNumbers, UniqueRing
iniread, Heist, sidtooldata.ini, StashTabNumbers, Heist
iniread, Remove2, sidtooldata.ini, StashTabNumbers, Remove2
iniread, Incubator, sidtooldata.ini, StashTabNumbers, Incubator
iniread, AbyssJewel, sidtooldata.ini, StashTabNumbers, AbyssJewel
iniread, ClusterJewel, sidtooldata.ini, StashTabNumbers, ClusterJewel
iniread, NormalJewel, sidtooldata.ini, StashTabNumbers, NormalJewel
iniread, InfluencedPage, sidtooldata.ini, StashTabNumbers, InfluencedPage
iniread, SpecialMaps, sidtooldata.ini, StashTabNumbers, SpecialMaps
iniread, BreachRing, sidtooldata.ini, StashTabNumbers, BreachRing
iniread, ReturnPage, sidtooldata.ini, StashTabNumbers, ReturnPage
iniread, UnidentifiedRareHelmet, sidtooldata.ini, StashTabNumbers, UnidentifiedRareHelmet
iniread, UnidentifiedRareBody, sidtooldata.ini, StashTabNumbers, UnidentifiedRareBody
iniread, UnidentifiedRareBelt, sidtooldata.ini, StashTabNumbers, UnidentifiedRareBelt
iniread, UnidentifiedRareGloves, sidtooldata.ini, StashTabNumbers, UnidentifiedRareGloves
iniread, UnidentifiedRareBoots, sidtooldata.ini, StashTabNumbers, UnidentifiedRareBoots
iniread, UnidentifiedRareAccessory, sidtooldata.ini, StashTabNumbers, UnidentifiedRareAccessory
iniread, UnidentifiedRareWeapon, sidtooldata.ini, StashTabNumbers, UnidentifiedRareWeapon
Return

;[Price Check Window]------------------------------------------------------------------------------------------------------

PriceCheckToolURL:
run,https://forum.gamer.com.tw/C.php?bsn=18966&snA=123938,,UseErrorLevel
return

PriceCheckWindow:
MouseGetPos, thisPosX, thisPosY
if DisclaimerShown = 0
{
MsgBox,64,Only shown once per session, close then use Win+V again.,Please install and pre‑open [rchin-poe-trade] tool, press Home to return to game, then Win+V works.`r`rIf not installed, you can find the URL in Win+Z menu.`r`rDisclaimer: This price check tool is not made by Sid, and no fee is charged for this feature.`r`rJust for promotion and sharing – please support the original author.
DisclaimerShown = 1
WinActivate ,Path of Exile
return
}
if DisclaimerShown = 1
{
ToolTip("Sid tool supports [Esc] to quickly return to POE after price check")
Send ^C
WinActivate ,rchin-poe-trade
}
return

;[Space Quick Drink]------------------------------------------------------------------------------------------

~*space::
settimer,DetectDialog1,25
settimer,DetectDialog2,25
if Toolbutton = 0
{
	ToolTip("Quick drink triggered. If typing accidentally, use F9 to pause.")
	if QuickDrinkFlasks = error
	{
	msgbox,16,Error,Quick drink flasks not set! Win+Z -> Flask Trigger Settings.
	gosub,FlaskTriggerSettingsGUI
	return
	}
	else if	(Autodrinkbutton = "0" or FlaskTriggerMode = "None")
	{
	send %QuickDrinkFlasks%
	}
	if (Autodrinkbutton = "1" and FlaskTriggerMode = "Loop Drink")
	{
		if QuickDrinkFlasks contains 1
		{
		send {1}
		SetTimer, Flask1, off
		SetTimer, Flask1, %FlaskDuration1%
		}
 		if QuickDrinkFlasks contains 2
		{
		send {2}
		SetTimer, Flask2, off
		SetTimer, Flask2, %FlaskDuration2%
		}
		if QuickDrinkFlasks contains 3
		{
		send {3}
		SetTimer, Flask3, off
		SetTimer, Flask3, %FlaskDuration3%
		}
		if QuickDrinkFlasks contains 4
		{
		send {4}
		SetTimer, Flask4, off
		SetTimer, Flask4, %FlaskDuration4%
		}
		if QuickDrinkFlasks contains 5
		{
		send {5}
		SetTimer, Flask5, off
		SetTimer, Flask5, %FlaskDuration5%
		}
		return
	}
	if (Autodrinkbutton = "1" and FlaskTriggerMode = "Pure Flask Lock")
	{
		if QuickDrinkFlasks contains 1
		gosub,UseFlask1
		if QuickDrinkFlasks contains 2
		gosub,UseFlask2
		if QuickDrinkFlasks contains 3
		gosub,UseFlask3
		if QuickDrinkFlasks contains 4
		gosub,UseFlask4
		if QuickDrinkFlasks contains 5
		gosub,UseFlask5
	}
	if (Autodrinkbutton = "1" and FlaskTriggerMode = "Drink on Skill Use")
	{
		FlaskLock1 = None
		FlaskLock2 = None
		FlaskLock3 = None
		FlaskLock4 = None
		FlaskLock5 = None
		if QuickDrinkFlasks contains 1
		gosub,UseFlask1
		if QuickDrinkFlasks contains 2
		gosub,UseFlask2
		if QuickDrinkFlasks contains 3
		gosub,UseFlask3
		if QuickDrinkFlasks contains 4
		gosub,UseFlask4
		if QuickDrinkFlasks contains 5
		gosub,UseFlask5
	}

}
return

;[Space Loop Drink Timers]-------------------------------------------------------------------------------------------------

Flask1:
if Toolbutton = 0
send {1}
return

Flask2:
if Toolbutton = 0
send {2}
return

Flask3:
if Toolbutton = 0
send {3}
return

Flask4:
if Toolbutton = 0
send {4}
return

Flask5:
if Toolbutton = 0
send {5}
return

;[Enter Dialog Detection]------------------------------------------------------------------------------------------

~enter::
if (Color5_X = "error" or Color5_Y = "error" or Color6_X = "error" or Color6_Y = "error")
{
   if EnterDebugReminderCount = 0
   {
	msgbox,16,Error,Dialog detection points (1)&(2) not set! Very important to avoid accidental key presses while typing.`rIf first time, click OK to open tutorial image.`rFollow image to position mouse then press [Win+C] enter code (5) or (6).
	run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/editor/1847905122_2.png,,UseErrorLevel
	EnterDebugReminderCount := 1
   }
}
else
{
(Toolbutton = 0 ? (Toolbutton := 1,ToolTip("Switched to text mode")) : (Toolbutton := 0,ToolTip("Switched to game mode")))
if Toolbutton = 0
{
settimer,DetectDialog1,25
settimer,DetectDialog2,25
}
if Toolbutton = 1
		{
		gosub,PauseLoopDrink
		}
}
return

DetectDialog1:
if (Color5_X = "error" or Color5_Y = "error")
{
settimer,DetectDialog1,off
settimer,DetectDialog2,off
msgbox,16,Error,Did you forget to set dialog detection?`rFirst time enter will show tutorial.`rDialog detection is crucial to avoid accidental hotkey presses while typing.
}
else
{
	PixelGetColor,Dialog1, %Color5_X%, %Color5_Y%
	if Dialog1 = %Color5_C%
	{
	Toolbutton = 1
	ToolTip("Dialog1 detected -> text mode")
	gosub,PauseLoopDrink
	settimer,DetectDialog1,off
	}
	else
	{
	settimer,DetectDialog1,off
	}
}
return

DetectDialog2:
if (Color6_X = "error" or Color6_Y = "error")
{
settimer,DetectDialog1,off
settimer,DetectDialog2,off
msgbox,16,Error,Did you forget to set dialog detection?`rFirst time enter will show tutorial.`rDialog detection is crucial to avoid accidental hotkey presses while typing.
}
else
{
	PixelGetColor,Dialog2, %Color6_X%, %Color6_Y%
	if Dialog2 = %Color6_C%
	{
	Toolbutton = 1
	ToolTip("Dialog2 detected -> text mode")
	gosub,PauseLoopDrink
	settimer,DetectDialog2,off
	}
	else
	{
	settimer,DetectDialog2,off
	}
}
return

;[Ctrl+F Highlight Item]--------------------------------------------------------------------------------------------

~*<^F::
if Toolbutton = 0
Toolbutton := 1,ToolTip("Ctrl+F used – switched to text mode")
return

;[Mouse Area]---------------------------------------------------------------------------------------------------------

~*LButton::
If StartTime
    return
StartTime := A_TickCount
Hotkey, LButton up, LButtonUpLabel, On
return

LButtonUpLabel:
Hotkey, LButton up, LButtonUpLabel, Off
TimeHeld := A_TickCount - StartTime
if (TimeHeld < 100)
{

}
else if (TimeHeld >= 100)
{
	if Toolbutton = 1
	Toolbutton := 0,ToolTip("Long left‑click released – switched to game mode")
}
StartTime := ""
return

~<!<^LButton::
if Toolbutton = 0
Toolbutton := 1,ToolTip("Item paste detected – switched to text mode")
return

;[Mouse Auto‑Click]------------------------------------------------------------------------------------------------------

~*^LButton::
if ClickMode = [Ctrl + LButton]
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
		sleep %MouseClickSpeed%
		}
	}
 }

}
return

~*^LButton UP::
if ClickMode = [Ctrl + LButton]
clickStop := true
return

~*MButton::
if ClickMode = Mouse Middle Button
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
		 sleep %MouseClickSpeed%
		}
	}
}
return

~*MButton Up::
if ClickMode = Mouse Middle Button
clickStop := true
return

;[Mouse Click Settings GUI]------------------------------------------------------------------------------------------------------

MouseClickSettingsGUI:
Gui,MouseClickSettings:new,,Mouse Click Settings
Gui +LabelMouseClickSettings -Resize  -MinimizeBox -MaximizeBox
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,gMiddleClickTrigger w200 hwndHBT17 ,Middle Button
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT17,BT1Options)
Gui, Add, Button,gCtrlLeftClickTrigger w200 hwndHBT18 ,[Ctrl + LButton]
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT18,BT1Options)
Gui, Add, Button,gClickSpeedAdjust w200 hwndHBT24 ,Click Speed
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT24,BT1Options)
Gui, font
Gui Add, StatusBar,, % "Made by Sid – Current click mode = "ClickMode " . "
Gui, Show
return

MouseClickSettingsEscape:
MouseClickSettingsClose:
Gui,submit
Return

MiddleClickTrigger:
Gui,submit
ClickMode = Mouse Middle Button
IniWrite,% ClickMode, sidtooldata.ini, KeyModeSwitch, ClickMode
 Iniread, ClickMode, sidtooldata.ini, KeyModeSwitch, ClickMode
ToolTip("Mouse click mode: " . ClickMode . " . ")
Return

CtrlLeftClickTrigger:
Gui,submit
ClickMode = [Ctrl + LButton]
IniWrite,% ClickMode, sidtooldata.ini, KeyModeSwitch, ClickMode
 Iniread, ClickMode, sidtooldata.ini, KeyModeSwitch, ClickMode
ToolTip("Mouse click mode: " . ClickMode . " . ")
Return

ClickSpeedAdjust:
Gui,submit
InputBox, MouseClickSpeed,Click Speed,Enter 0~50 (lower = faster).,,,,,,,,%MouseClickSpeed%
if MouseClickSpeed not between 0 and 50
{
msgbox,16,Error,Please enter a number between 0 and 50.
gosub,ClickSpeedAdjust
return
}
else
{
IniWrite,% MouseClickSpeed, sidtooldata.ini, KeyModeSwitch, MouseClickSpeed
 Iniread, MouseClickSpeed, sidtooldata.ini, KeyModeSwitch, MouseClickSpeed
}
return

ReadMouseClickSpeed:
 Iniread, MouseClickSpeed, sidtooldata.ini, KeyModeSwitch, MouseClickSpeed
 if MouseClickSpeed = error
 MouseClickSpeed = 25
Return

ReadClickMode:
 Iniread, ClickMode, sidtooldata.ini, KeyModeSwitch, ClickMode
Return


;[PgUp/PgDn Clear Area]------------------------------------------------------------------------------------------

PgUp::
Critical
	if (OtherBackpackTL_X = "error" or OtherBackpackBR_X = "error")
	{
	msgbox,16,Error,Quick trade check 60 slots not set.`rOpen any NPC sell window and use F7 to set coordinates.`rOK to open tutorial image.
	run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/editor/1029564595_2.jpg,,UseErrorLevel
		return
	}
	else
	{
	gosub,ClearOtherBackpackHold
	return
	}
return

PgDn::
Critical
	if (AcceptTrade_X = "error" or AcceptTrade_X = "error")
	{
	msgbox,16,Error,Quick trade accept button not set.`rOpen any NPC sell window and use F7 to set coordinates.`rOK to open tutorial image.
	run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/editor/1029564595_2.jpg,,UseErrorLevel
		return
	}
	else
	{
	MouseClick, Left,AcceptTrade_X,AcceptTrade_Y,1,0
	return
	}
return

;[PgUp/PgDn Clear Routines]------------------------------------------------------------------------------------------

ClearOtherBackpackHold:
loop % ScanHorizontalCount2
{
	PosX := (ScanStartTL2_X+(SlotWidth2/2)) + ((SlotWidth2/2)*((A_Index-1)*2))
	if not(GetKeyState("PgUp","P"))
	return
	loop % ScanVerticalCount2
	{
		PosY := (ScanStartTL2_Y+(SlotHeight2/2)) + ((SlotHeight2/2)*((A_Index-1)*2))
		MouseMove, % PosX, % PosY,0
		if not(GetKeyState("PgUp","P"))
		return
	}
}
return

BackpackCalculation2:
ScanStartTL2_X := % OtherBackpackTL_X
ScanStartTL2_Y := % OtherBackpackTL_Y
ScanStartBR2_X := % OtherBackpackBR_X
ScanStartBR2_Y := % OtherBackpackBR_Y
ScanHorizontalCount2 := 12
ScanVerticalCount2 := 5
SlotWidth2 := floor((ScanStartBR2_X - ScanStartTL2_X) / ScanHorizontalCount2)
SlotHeight2 := floor((ScanStartBR2_Y - ScanStartTL2_Y) / ScanVerticalCount2)
return


;[Insert Loop Skills]------------------------------------------------------------------------------------------

*Insert::
(StopUser = 0 ? (StopUser := 1,ToolTip("Loop skills ON")) : (StopUser := 0,ToolTip("Loop skills OFF")))
if (LoopSkill1 = "error" or LoopSkill2 = "error" or LoopSkill3 = "error" or LoopSkillTime1 = "error" or LoopSkillTime2 = "error" or LoopSkillTime3 = "error")
{
  StopUser = 0
  msgbox,16,Error,Loop skills not set! Going to settings.
  Gosub,LoopSkillSettingsGUI
  return
}
  if StopUser = 1
  {
  Settimer,LoopSkill1,off
  Settimer,LoopSkill2,off
  Settimer,LoopSkill3,off
  Gosub,LoopSkill1
  Gosub,LoopSkill2
  Gosub,LoopSkill3
  Settimer,LoopSkill1,%LoopSkillTime1%,-1
  Settimer,LoopSkill2,%LoopSkillTime2%,-1
  Settimer,LoopSkill3,%LoopSkillTime3%,-1
  return
  }
  if StopUser = 0
  {
  Gosub,StopLoopSkills
  return
  }
return

LoopSkill1:
IfWinActive,Path of Exile
{
if Toolbutton = 0
 {
if LoopSkillTime1 = OFF
{
 Return
}
if not(GetKeyState("Ctrl","P"))
if not(GetKeyState("Shift","P"))
send %LoopSkill1%
send {BS}
 }
}
Return

LoopSkill2:
IfWinActive,Path of Exile
{
if Toolbutton = 0
 {
if LoopSkillTime2 = OFF
{
 Return
}
if not(GetKeyState("Ctrl","P"))
if not(GetKeyState("Shift","P"))
send %LoopSkill2%
send {BS}
 }
}
Return

LoopSkill3:
IfWinActive,Path of Exile
{
if Toolbutton = 0
 {
if LoopSkillTime3 = OFF
{
 Return
}
if not(GetKeyState("Ctrl","P"))
if not(GetKeyState("Shift","P"))
send %LoopSkill3%
send {BS}
 }
}
Return

StopLoopSkills:
Settimer,LoopSkill1,off
Settimer,LoopSkill2,off
Settimer,LoopSkill3,off
send {%LoopSkill1% up}
send {%LoopSkill2% up}
send {%LoopSkill3% up}
Return

;[Loop Skill Settings GUI]------------------------------------------------------------------------------------------

LoopSkillSettingsGUI:
Gui,LoopSkillSettings:new,,Loop Skill Settings
Gui +LabelLoopSkillSettings -Resize  -MinimizeBox -MaximizeBox
Gui Font, s10
Gui Add, Text, x2 y6 w236 h20 +0x200, Set skill and interval (ms), Off = disable
Gui Add, Text, x10 y105 w215 h20, After save, press Insert to start loop
Gui Font
Gui Add, ComboBox, vLoopSkill1 x5 y30 w90, Q|W|E|R|T|%LoopSkill1%||
Gui Add, ComboBox, vLoopSkill2 x5 y55 w90, Q|W|E|R|T|%LoopSkill2%||
Gui Add, ComboBox, vLoopSkill3 x5 y80 w90, Q|W|E|R|T|%LoopSkill3%||
Gui Add, ComboBox, vLoopSkillTime1 x105 y30 w120 , Off|1000|2000|3000|4000|5000|6000|7000|8000|9000|10000|%LoopSkillTime1%||
Gui Add, ComboBox, vLoopSkillTime2 x105 y55 w120 , Off|1000|2000|3000|4000|5000|6000|7000|8000|9000|10000|%LoopSkillTime2%||
Gui Add, ComboBox, vLoopSkillTime3 x105 y80 w120 , Off|1000|2000|3000|4000|5000|6000|7000|8000|9000|10000|%LoopSkillTime3%||
Gui Add, Button, gSaveAndReadLoopSettings x5 y126 w218 h23, Save & Close
Gui Show, w231 h156,Loop Skill Settings
Return

LoopSkillSettingsEscape:
LoopSkillSettingsClose:
Msgbox,4,Notice,Settings not saved. Close anyway? (Yes / No)
IfMsgBox No
	Return
Else
	Gui,submit
Return

;[Loop Skill GUI Save Routine]------------------------------------------------------------------------------------------------------

SaveAndReadLoopSettings:
Gui,submit
gosub,SaveLoopSettings
gosub,ReadLoopSettings
if StopUser = 1
{
StopUser := 0
Gosub,StopLoopSkills
msgbox,48,Notice,Settings changed – Loop skills turned off.`rPress Insert again to restart.
}
Return

SaveLoopSettings:
if CurrentProfile = 1
{
iniWrite,% LoopSkill1,	sidtooldata.ini, LoopSkills, LoopSkill1
iniWrite,% LoopSkill2,	sidtooldata.ini, LoopSkills, LoopSkill2
iniWrite,% LoopSkill3,	sidtooldata.ini, LoopSkills, LoopSkill3
iniWrite,% LoopSkillTime1, sidtooldata.ini, LoopSkills, LoopSkillTime1
iniWrite,% LoopSkillTime2, sidtooldata.ini, LoopSkills, LoopSkillTime2
iniWrite,% LoopSkillTime3, sidtooldata.ini, LoopSkills, LoopSkillTime3
}
if CurrentProfile = 2
{
iniWrite,% LoopSkill1,	sidtooldata2.ini, LoopSkills, LoopSkill1
iniWrite,% LoopSkill2,	sidtooldata2.ini, LoopSkills, LoopSkill2
iniWrite,% LoopSkill3,	sidtooldata2.ini, LoopSkills, LoopSkill3
iniWrite,% LoopSkillTime1, sidtooldata2.ini, LoopSkills, LoopSkillTime1
iniWrite,% LoopSkillTime2, sidtooldata2.ini, LoopSkills, LoopSkillTime2
iniWrite,% LoopSkillTime3, sidtooldata2.ini, LoopSkills, LoopSkillTime3
}
if CurrentProfile = 3
{
iniWrite,% LoopSkill1,	sidtooldata3.ini, LoopSkills, LoopSkill1
iniWrite,% LoopSkill2,	sidtooldata3.ini, LoopSkills, LoopSkill2
iniWrite,% LoopSkill3,	sidtooldata3.ini, LoopSkills, LoopSkill3
iniWrite,% LoopSkillTime1, sidtooldata3.ini, LoopSkills, LoopSkillTime1
iniWrite,% LoopSkillTime2, sidtooldata3.ini, LoopSkills, LoopSkillTime2
iniWrite,% LoopSkillTime3, sidtooldata3.ini, LoopSkills, LoopSkillTime3
}
Return

ReadLoopSettings:
if CurrentProfile = 1
{
iniread,LoopSkill1 , sidtooldata.ini, LoopSkills, LoopSkill1
iniread,LoopSkill2 , sidtooldata.ini, LoopSkills, LoopSkill2
iniread,LoopSkill3 , sidtooldata.ini, LoopSkills, LoopSkill3
iniread,LoopSkillTime1 , sidtooldata.ini, LoopSkills, LoopSkillTime1
iniread,LoopSkillTime2 , sidtooldata.ini, LoopSkills, LoopSkillTime2
iniread,LoopSkillTime3 , sidtooldata.ini, LoopSkills, LoopSkillTime3
}
if CurrentProfile = 2
{
iniread,LoopSkill1 , sidtooldata2.ini, LoopSkills, LoopSkill1
iniread,LoopSkill2 , sidtooldata2.ini, LoopSkills, LoopSkill2
iniread,LoopSkill3 , sidtooldata2.ini, LoopSkills, LoopSkill3
iniread,LoopSkillTime1 , sidtooldata2.ini, LoopSkills, LoopSkillTime1
iniread,LoopSkillTime2 , sidtooldata2.ini, LoopSkills, LoopSkillTime2
iniread,LoopSkillTime3 , sidtooldata2.ini, LoopSkills, LoopSkillTime3
}
if CurrentProfile = 3
{
iniread,LoopSkill1 , sidtooldata3.ini, LoopSkills, LoopSkill1
iniread,LoopSkill2 , sidtooldata3.ini, LoopSkills, LoopSkill2
iniread,LoopSkill3 , sidtooldata3.ini, LoopSkills, LoopSkill3
iniread,LoopSkillTime1 , sidtooldata3.ini, LoopSkills, LoopSkillTime1
iniread,LoopSkillTime2 , sidtooldata3.ini, LoopSkills, LoopSkillTime2
iniread,LoopSkillTime3 , sidtooldata3.ini, LoopSkills, LoopSkillTime3
}
Return

;[Home Quick Trade]-----------------------------------------------------------------------------------------------------------

Home::
if (QuickTradeReminder = "Off")
{
	Gosub,GetTargetID
	WinActivate ,Path of Exile
	WinWait ,Path of Exile
	Clipboard = /tradewith %CleanedID%
	send {enter}
	Send ^{V}
	sleep 1
	Send {enter}
}
if QuickTradeReminder = On
{
   Gosub,GetTargetID
   msgbox,4,Notice,Target player: " %CleanedID% " – proceed?`r[Enter] to trade, [N] to cancel.`rUse Win+Home to toggle reminder.
   IfMsgBox Yes
	{
	WinActivate ,Path of Exile
	WinWait ,Path of Exile
	Clipboard = /tradewith %CleanedID%
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
gosub,HomeQuickTradeSettings
Return

;[Home Quick Trade Settings GUI]-------------------------------------------------------------------------------------------------------

HomeQuickTradeSettings:
Gui,HomeQuickTradeSettings:new,,Home Quick Trade Settings
Gui +LabelHomeQuickTradeSettings -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,gEnableTradeReminder w200 hwndHBT28 ,Enable Reminder
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT28,BT1Options)
Gui, Add, Button,gDisableTradeReminder w200 hwndHBT29 ,Disable Reminder
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT29,BT1Options)
Gui, font
Gui Add, StatusBar,, % "Made by Sid – Current trade reminder = "QuickTradeReminder " . "
Gui, Show
return

HomeQuickTradeSettingsEscape:
HomeQuickTradeSettingsClose:
Gui,submit
Return

EnableTradeReminder:
Gui,submit
QuickTradeReminder = On
IniWrite,% QuickTradeReminder, sidtooldata.ini, KeyModeSwitch, QuickTradeReminder
 Iniread, QuickTradeReminder, sidtooldata.ini, KeyModeSwitch, QuickTradeReminder
ToolTip("Quick trade reminder: " . QuickTradeReminder . " . ")
Return

DisableTradeReminder:
Gui,submit
QuickTradeReminder = Off
IniWrite,% QuickTradeReminder, sidtooldata.ini, KeyModeSwitch, QuickTradeReminder
 Iniread, QuickTradeReminder, sidtooldata.ini, KeyModeSwitch, QuickTradeReminder
ToolTip("Quick trade reminder: " . QuickTradeReminder . " . ")
Return

ReadQuickTradeReminder:
 Iniread, QuickTradeReminder, sidtooldata.ini, KeyModeSwitch, QuickTradeReminder
Return

;[End Quick Party]------------------------------------------------------------------------------------------------------------

End::
if (QuickPartyReminder = "Off")
{
	Gosub,GetTargetID
	WinActivate ,Path of Exile
	WinWait ,Path of Exile
	Clipboard = /invite %CleanedID%
	send {enter}
	Send ^{V}
	sleep 1
	Send {enter}
}
if QuickPartyReminder = On
{
   Gosub,GetTargetID
   msgbox,4,Notice,Target player: " %CleanedID% " – proceed?`r[Enter] to invite, [N] to cancel.`rUse Win+End to toggle reminder.
   IfMsgBox Yes
	{
	WinActivate ,Path of Exile
	WinWait ,Path of Exile
	Clipboard = /invite %CleanedID%
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
gosub,EndQuickPartySettings
Return

;[End Quick Party Routines]------------------------------------------------------------------------------------------------------------

GetTargetID:
Send ^{enter}
sleep 1
Send ^{A}
sleep 1
Send ^{C}
sleep 1
Send {enter}
TempTarget = %Clipboard%
Target = %TempTarget%
gosub,CleanTargetID
return

CleanTargetID:
CleanedID :=  Trim(Target, OmitChars := "@")
return

;[End Quick Party Settings GUI]-------------------------------------------------------------------------------------------------

EndQuickPartySettings:
Gui,EndQuickPartySettings:new,,End Quick Party Settings
Gui +LabelEndQuickPartySettings -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,gEnablePartyReminder w200 hwndHBT15 ,Enable Reminder
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT15,BT1Options)
Gui, Add, Button,gDisablePartyReminder w200 hwndHBT16 ,Disable Reminder
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT16,BT1Options)
Gui, font
Gui Add, StatusBar,, % "Made by Sid – Current party reminder = "QuickPartyReminder " . "
Gui, Show
return

EndQuickPartySettingsEscape:
EndQuickPartySettingsClose:
Gui,submit
Return

EnablePartyReminder:
Gui,submit
QuickPartyReminder = On
IniWrite,% QuickPartyReminder, sidtooldata.ini, KeyModeSwitch, QuickPartyReminder
 Iniread, QuickPartyReminder, sidtooldata.ini, KeyModeSwitch, QuickPartyReminder
ToolTip("Quick party reminder: " . QuickPartyReminder . " . ")
Return

DisablePartyReminder:
Gui,submit
QuickPartyReminder = Off
IniWrite,% QuickPartyReminder, sidtooldata.ini, KeyModeSwitch, QuickPartyReminder
 Iniread, QuickPartyReminder, sidtooldata.ini, KeyModeSwitch, QuickPartyReminder
ToolTip("Quick party reminder: " . QuickPartyReminder . " . ")
Return

ReadQuickPartyReminder:
 Iniread, QuickPartyReminder, sidtooldata.ini, KeyModeSwitch, QuickPartyReminder
Return

;[F1 Return to Character]------------------------------------------------------------------------------------------------------------

*F1::
if Toolbutton = 1
{
ToolTip("You are in text mode, click or press Enter to switch back")
}
else
{
	if F1Mode = error
	{
	msgbox,48,Notice,First time using F1? Try Win+F1 to select mode!`rSwitch anytime – enjoy!
	return
	}
	if F1Mode = ReturnMode
	gosub,ReturnToCharacter
	if F1Mode = OriginalKeyMode
	send {F1}
}
return

#F1::
gosub,F1ModeSwitch
return

;[F1 Return Routine]------------------------------------------------------------------------------------------------------

ReturnToCharacter:
Critical
	gosub,PauseLoopDrink
	BlockInput On
        Send {Enter}
        Sleep 100
        Send {NumpadDiv}
        Send {Shift down}
	Send exit
        Send {Shift up}
        Send {Enter}
	BlockInput Off
	ToolTip("Logging in in 3s")
	Sleep 1000
	ToolTip("Logging in in 2s")
	Sleep 1000
	ToolTip("Logging in in 1s")
	Sleep 1000
	ToolTip("Logging in now")
        Send {Enter}
return

;[F1 Mode Switch GUI]--------------------------------------------------------------------------------------

F1ModeSwitch:
Gui,F1ModeSwitch:new,,F1 Mode Switch
Gui +LabelF1ModeSwitch -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,gSetOriginalKey1 w200 hwndHBT5 ,Original Key
BT1Options:= [{BC: "99D1D3|FFFFFF", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT5,BT1Options)
Gui, Add, Button,gSetReturnMode w200 hwndHBT6 ,Return Mode
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT6,BT1Options)
Gui, font
Gui Add, StatusBar,, % "Made by Sid – Current F1 mode = "F1Mode " . "
Gui, Show
return

F1ModeSwitchEscape:
F1ModeSwitchClose:
Gui,submit
Return

SetOriginalKey1:
Gui,submit
F1Mode = OriginalKeyMode
IniWrite,% F1Mode, sidtooldata.ini, KeyModeSwitch, F1Mode
 Iniread, F1Mode, sidtooldata.ini, KeyModeSwitch, F1Mode
ToolTip("F1 mode: " . F1Mode . " . ")
Return

SetReturnMode:
Gui,submit
F1Mode = ReturnMode
IniWrite,% F1Mode, sidtooldata.ini, KeyModeSwitch, F1Mode
 Iniread, F1Mode, sidtooldata.ini, KeyModeSwitch, F1Mode
ToolTip("F1 mode: " . F1Mode . " . ")
Return

ReadF1KeyMode:
 Iniread, F1Mode, sidtooldata.ini, KeyModeSwitch, F1Mode
Return



;[F2 Reply Mode]------------------------------------------------------------------------------------------------------

F2::
if Toolbutton = 1
{
ToolTip("You are in text mode, click or press Enter to switch back")
}
else
{
	if ReplyMode = error
	{
	msgbox,48,Notice,First time using F2? Try Win+F2 to select!`rSwitch anytime!
	return
	}
	if ReplyMode = AFK
	{
	  if StopUser = 0
	  {
	  Gosub,AFK
	  }
	  if StopUser = 1
	  {
	  StopUser = 0
	  Gosub,StopLoopSkills
	  ToolTip("Loop skills stopped, entering AFK.")
	  Gosub,AFK
	  }
	}
	if ReplyMode = DND
	Gosub,DND
	if ReplyMode = AutoReply
	{
		if AutoReplyContent = error
		{
		gosub,SetAutoReply
		return
		}
		else
		{
		Gosub,AutoReply
		}
	}
	return

}
return

AFK:
BlockInput On
send {enter}
sleep 25
Clipboard = /afk
Send ^{V}
sleep 25
send {enter}
BlockInput Off
return

DND:
BlockInput On
send {enter}
sleep 25
Clipboard = /dnd
Send ^{V}
sleep 25
send {enter}
BlockInput Off
Return

AutoReply:
BlockInput On
send {enter}
sleep 25
Clipboard = /autoreply %AutoReplyContent%
Send ^{V}
sleep 25
send {enter}
BlockInput Off
Return

#F2::
gosub,ReplyModeSwitch
return

;[F2 Reply Mode Switch GUI]-------------------------------------------------------------------------------------------------------------

ReplyModeSwitch:
Gui,ReplyModeSwitch:new,,F2 Reply Mode Switch
Gui +LabelReplyModeSwitch -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,gSetAFK w200 hwndHBT7 ,AFK
BT1Options:= [{BC: "99D1D3|FFFFFF", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT7,BT1Options)
Gui, Add, Button,gSetDND w200 hwndHBT8 ,DND
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT8,BT1Options)
Gui, Add, Button,gSetAutoReply w200 hwndHBT9 ,AutoReply
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT9,BT1Options)
Gui, Add, Button,gSetReplyContent w200 hwndHBT10 ,Set Reply Content
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT10,BT1Options)
Gui, font
Gui Add, StatusBar,, % "Made by Sid – Current F2 mode = "ReplyMode " . "
Gui, Show
return

ReplyModeSwitchEscape:
ReplyModeSwitchClose:
Gui,submit
Return

SetAFK:
Gui,submit
ReplyMode = AFK
IniWrite,% ReplyMode, sidtooldata.ini, KeyModeSwitch, ReplyMode
 Iniread, ReplyMode, sidtooldata.ini, KeyModeSwitch, ReplyMode
ToolTip("Reply mode: " . ReplyMode . " . ")
Return

SetDND:
Gui,submit
ReplyMode = DND
IniWrite,% ReplyMode, sidtooldata.ini, KeyModeSwitch, ReplyMode
 Iniread, ReplyMode, sidtooldata.ini, KeyModeSwitch, ReplyMode
ToolTip("Reply mode: " . ReplyMode . " . ")
Return

SetAutoReply:
Gui,submit
ReplyMode = AutoReply
IniWrite,% ReplyMode, sidtooldata.ini, KeyModeSwitch, ReplyMode
 Iniread, ReplyMode, sidtooldata.ini, KeyModeSwitch, ReplyMode
ToolTip("Reply mode: " . ReplyMode . " . ")
Return

ReadReplyMode:
 Iniread, ReplyMode, sidtooldata.ini, KeyModeSwitch, ReplyMode
Return

SetReplyContent:
Gui,submit
gosub,SetAutoReplyGUI
Return

SetAutoReplyGUI:
Gui,SetAutoReplyContent:new,,Set Auto‑Reply Content
Gui +LabelSetAutoReplyContent -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x000000
Gui Font, s12 Bold c0xFFFFFF
Gui Add, Text, x5 y5 w100 h30 +0x200 +0x1000, ㊣ AutoReply:
Gui Font
Gui Font, s12 Bold
Gui Add, Edit, vAutoReplyContent x110 y5 w500 h30 -VScroll,  %AutoReplyContent%
Gui Add, Button, gSaveAutoReplyContent x615 y5 w50 h30, &Save
Gui Font
Gui Add, StatusBar,, ▲ Tip: ...
Gui Show
Return

SetAutoReplyContentEscape:
SetAutoReplyContentClose:
Gui,submit
Return

SaveAutoReplyContent:
Gui,submit
iniWrite,% AutoReplyContent, sidtooldata.ini, AutoReplyContent, AutoReplyContent
iniread, AutoReplyContent, sidtooldata.ini, AutoReplyContent, AutoReplyContent
Return

ReadAutoReplyContent:
iniread, AutoReplyContent, sidtooldata.ini, AutoReplyContent, AutoReplyContent
Return

;[F3 Clear Backpack]------------------------------------------------------------------------------------------------------------

F3::
if Toolbutton = 1
{
ToolTip("You are in text mode, click or press Enter to switch back")
}
else
{
Critical
	if (BackpackTL_X = "error" or BackpackBR_X = "error")
	{
	msgbox,16,Error,Backpack position not set. Open backpack and use F7 to set.
	run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/1127343908_2.png,,UseErrorLevel
	return
	}
	if ClearMode = Hold-to-Clear
	{
	gosub,ClearBackpack
	}
	if ClearMode = Auto-Clear
	{
	gosub,ClearBackpack
	}
	if ClearMode = Scan-Clear
	{
		if (BackpackBaseColor1 = "error" and BackpackBaseColor2 = "error")
		{
		msgbox,16,Notice,Please switch to color mapping mode first, open empty backpack (60 slots) and press F3 to map colors.
		}
		else
		{
		gosub,ScanAndStash
		}
	}
	if ClearMode = ScanSearchPage
	{
		if (BackpackBaseColor1 = "error" and BackpackBaseColor2 = "error")
		{
		msgbox,16,Notice,Please switch to color mapping mode first, open empty backpack and press F3 to map colors.
		return
		}
		if (Incubator = "error" or UniqueGear = "error" or UniqueRing = "error" or Watchstone = "error" or InfluencedPage = "error")
		{
		msgbox,16,Notice,Quick stash search settings incomplete – please set them.
		return
		}
		else
		{
		gosub,ScanAndStash
		}
	}
	if ClearMode = ColorMapping
	{
	gosub,ScanBackpackColorsAndSave
	return
	}
return
}
return

#F3::
gosub,ClearModeSwitch
return

;[F3 Clear Mode Switch GUI]--------------------------------------------------------------------------------------

ClearModeSwitch:
Gui,ClearModeSwitch:new,,F3 Clear Mode Switch
Gui +LabelClearModeSwitch -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,gSetHoldClear w200 hwndHBT1 ,Hold-to-Clear
BT1Options:= [{BC: "99D1D3|FFFFFF", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT1,BT1Options)

Gui, Add, Button,gSetAutoClear w200 hwndHBT2 ,Auto-Clear
BT1Options:= [{BC: "99D1D3|FFFF00", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT2,BT1Options)

Gui, Add, Button,gSetScanClear w200 hwndHBT3 ,Scan-Clear
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT3,BT1Options)

Gui, Add, Button,gSetScanSearchPage w200 hwndHBT12 ,Scan+Search Clear
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT12,BT1Options)

Gui, Add, Button,gSetColorMapping w200 hwndHBT4 ,Color Mapping
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT4,BT1Options)
Gui, font
Gui Add, StatusBar,, % "Made by Sid – Current F3 mode = "ClearMode " . "
Gui, Show
return

ClearModeSwitchEscape:
ClearModeSwitchClose:
Gui,submit
Return

SetHoldClear:
Gui,submit
ClearMode = Hold-to-Clear
IniWrite,% ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
 Iniread, ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
ToolTip("Clear mode: " . ClearMode . " . ")
Return

SetAutoClear:
Gui,submit
ClearMode = Auto-Clear
IniWrite,% ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
 Iniread, ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
ToolTip("Clear mode: " . ClearMode . " . ")
Return

SetScanClear:
Gui,submit
ClearMode = Scan-Clear
IniWrite,% ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
 Iniread, ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
ToolTip("Clear mode: " . ClearMode . " . ")
Return

SetScanSearchPage:
Gui,submit
if (Incubator = "error" or UniqueGear = "error" or UniqueRing = "error" or Watchstone = "error" or InfluencedPage = "error")
{
msgbox,16,Notice,Quick stash search settings incomplete – please set them.
}
else
{
ClearMode = ScanSearchPage
IniWrite,% ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
 Iniread, ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
ToolTip("Clear mode: " . ClearMode . " . ")
}
return

SetColorMapping:
Gui,submit
ClearMode = ColorMapping
IniWrite,% ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
 Iniread, ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
ToolTip("Clear mode: " . ClearMode . " . ")
msgbox,48,Notice,Switched to Color Mapping mode. After setting backpack coordinates with F7, open empty backpack and press F3 to scan colors.
return

ReadF3KeyMode:
 Iniread, ClearMode, sidtooldata.ini, KeyModeSwitch, ClearMode
Return

;[F3 Scan Backpack Routines].............................................................................................................................


ReadBackpackBaseColor:
loop,60
{
iniread, BackpackBaseColor%A_Index%, sidtooldata.ini, ScanColors, BackpackBaseColor%A_Index%
}
return


ScanBackpackColorsAndSave:
LoopCount:= 0
CoordMode, Pixel, Screen
global ScanColorArray := []
{
 ScanColorArray := []
 loop % ScanHorizontalCount
	{
	PosX := (ScanStartTL_X+(SlotWidth/2)) + ((SlotWidth/2)*((A_Index-1)*2))
	loop % ScanVerticalCount
		{
		PosY := (ScanStartTL_Y+(SlotHeight/2)) + ((SlotHeight/2)*((A_Index-1)*2))
		ToolTip, % "Scanning: " PosX "/" PosY, 0,0,1
		PixelGetColor, pcol, % PosX, % PosY, RGB
		ScanColorArray.Push(pcol)
		LoopCount:= LoopCount +1
		ToolTip, % "Status: " pcol " / " LoopCount " / " PosX "/" PosY , 0,22,2
		iniWrite,% ScanColorArray[LoopCount], sidtooldata.ini, ScanColors,BackpackBaseColor%LoopCount%
		iniread, BackpackBaseColor%LoopCount%, sidtooldata.ini, ScanColors, BackpackBaseColor%LoopCount%
		}
	}
 ToolTip,,,,2
 ToolTip,,,,1
}
msgbox Scan complete. Switch back to scan mode with Win+F3.
return

ClearBackpack:
send {ctrl down}
loop % ScanHorizontalCount
{
PosX := (ScanStartTL_X+(SlotWidth/2)) + ((SlotWidth/2)*((A_Index-1)*2))
	if ClearMode = Hold-to-Clear
	{
		if not(GetKeyState("F3","P"))
		{
		send {ctrl up}
		send {F3 up}
		ToolTip,,,,3
		return
		}
	}
	if ClearMode = Auto-Clear
	{
		if (GetKeyState("~","P"))
		{
		send {F3 up}
		send {ctrl up}
		ToolTip,,,,3
		return
		}
	}
loop % ScanVerticalCount
{
PosY := (ScanStartTL_Y+(SlotHeight/2)) + ((SlotHeight/2)*((A_Index-1)*2))
MouseClick,, % PosX, % PosY,1,0
	if ClearMode = Hold-to-Clear
	{
		ToolTip, % "Hold F3 to stop.", 0,22,3
		if not(GetKeyState("F3","P"))
		{
		send {ctrl up}
		send {F3 up}
		ToolTip,,,,3
		return
		}
	}
	if ClearMode = Auto-Clear
	{
		ToolTip, % "Hold ~ to stop.", 0,22,3
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

ScanAndStash:
LoopCount:= 0
CoordMode, Pixel, Screen
global StashScanColorArray := []
{
 StashScanColorArray := []
 if ClearMode = ScanSearchPage
 Gosub,GoFirstPage
 send {ctrl down}
 loop % ScanHorizontalCount
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
	PosX := (ScanStartTL_X+(SlotWidth/2)) + ((SlotWidth/2)*((A_Index-1)*2))
	loop % ScanVerticalCount
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
		PosY := (ScanStartTL_Y+(SlotHeight/2)) + ((SlotHeight/2)*((A_Index-1)*2))
		ToolTip, % "Scan: " PosX "/" PosY " , Hold ~ to stop.", 0,0,1
		PixelGetColor, pcol2, % PosX, % PosY, RGB
		StashScanColorArray.Push(pcol2)
		LoopCount:= LoopCount +1
		ToolTip, % "Slot: " LoopCount " /60 , Hold ~ to stop."  , 0,22,2
			If not pcol2 = BackpackBaseColor%LoopCount%
			{
				if ClearMode = ScanSearchPage
				{
				Gosub,GoFirstPage
				Mousemove, % PosX, % PosY,0
				sleep 10
				gosub,QuickStashSearch
				ToolTip, % "Match: "MatchType " / Page " CalcValue " – multi-step, hold ~ to stop.", 0,42,3
				sleep 10
				if MatchType = ShiftNeeded
				send {Shift Down}
				}
			MouseClick,, % PosX, % PosY,1,0
			MatchType = 0
			send {Shift Up}
			}
		}
	}
 ToolTip,,,,3
 ToolTip,,,,2
 ToolTip,,,,1
 ToolTip("Backpack cleared or stopped.")
 send {ctrl up}
}
return

;[F4 Quick Portal Scroll]---------------------------------------------------------------------------------------------------

*F4::
if Toolbutton = 1
{
ToolTip("You are in text mode, click or press Enter to switch back")
}
else
{
gosub,QuickPortalScroll
}
return

QuickPortalScroll:
if (PortalScroll_X = "error" or PortalScroll_Y = "error")
{
msgbox,16,Error,Portal scroll position not set. Move mouse over scroll in backpack and use F7 enter code "8".
}
else
{
MouseGetPos,F4PosX,F4PosY
BlockInput On
if openI = 0
send {i}
sleep 200
MouseClick, Right,PortalScroll_X,PortalScroll_Y,1,1
MouseMove,F4PosX,F4PosY,0
sleep 100
if openI = 0
send {i}
BlockInput Off
sleep 1000
}
return

#F4::
Msgbox,16,Notice,No multi‑mode for Win+F4.
return

~*I UP::
(openI = 0 ? (openI := 1) : (openI := 0))
if (openI = "1" and Toolbutton = "0")
ToolTip("Backpack opened (I), press ESC if unwanted")
if (openI = "0" and Toolbutton = "0")
ToolTip("Backpack closed (I)")
return

~*P::
openI := 0
if Toolbutton = 0
ToolTip("Passive tree (P), press ESC if unwanted, Ctrl+F to highlight")
return

~*K::
openI := 0
if Toolbutton = 0
ToolTip("Cosmetics (K), press ESC if unwanted.")
return

~*M::
openI := 0
if Toolbutton = 0
ToolTip("Shop (M), press ESC if unwanted.")
return

~*BS::
Toolbutton = 1
ToolTip("(Back Space) switched to text mode.")
return

;[F5 Return Hideout]---------------------------------------------------------------------------------------------------

F5::
if Toolbutton = 1
{
ToolTip("You are in text mode, click or press Enter to switch back")
}
else
{
gosub,ReturnHideout
}
return

ReturnHideout:
BlockInput On
send {enter}
sleep 25
Clipboard = /hideout
Send ^{V}
sleep 25
send {enter}
BlockInput Off
return

;[F6 Quick Pickup]---------------------------------------------------------------------------------------------------

F6::
 if PickupMode = error
 {
 msgbox,48,Notice,First time using F6? Use Win+F6 to choose pickup coordinate setup first!`rGo to currency tab and set coordinates for daily currencies.
 }
 else
 {
	if PickupMode = QuickPickup
	{
	gosub,F6QuickPickup
	}
	if PickupMode = PickupCoordSetup
	{
	gosub,F6PickupCoordSetup
	}
 }
Return

#F6::
gosub,PickupModeSwitch
Return



F6QuickPickup:
MouseGetPos, thisPosX, thisPosY
send {Ctrl down}
loop,5
{
mouseclick,Left,Currency%A_Index%_X,Currency%A_Index%_Y,1,0
sleep 25
}
send {Ctrl up}
Mousemove, thisPosX, thisPosY
Return

F6PickupCoordSetup:
	MouseGetPos, thisPosX, thisPosY
	PosX := ["Currency1_X","Currency2_X","Currency3_X","Currency4_X","Currency5_X"]
	PosY := ["Currency1_Y","Currency2_Y","Currency3_Y","Currency4_Y","Currency5_Y"]
	InputBox, affixID,F6 Pickup Coordinate Setup, Current mouse pos [ %thisPosX% `, %thisPosY% ].`nIf not set, press Cancel.`nAfter correct setup use F6.`r`rCurrency1 = 1 (e.g. Portal)`rCurrency2 = 2 (e.g. Wisdom)`r...`r`nEnter number (1~5),,300,270
	if not ErrorLevel
	{
		checkAffixID := RegExMatch(affixID, "[1-5]$")
		if checkAffixID = 1
		{
			iniWrite,% thisPosX, sidtooldata.ini, PickupCoords, % PosX[affixID]
			iniWrite,% thisPosY, sidtooldata.ini, PickupCoords, % PosY[affixID]
			gosub,ReadF6PickupLocations
		}
		else if not (affixID = "1" or affixID = "2" or affixID = "3" or affixID = "4" or affixID = "5")
		{
			MsgBox,16,Error,Please enter a number 1~5
		}
	}
	return

ReadF6PickupLocations:
loop,5
{
iniread,Currency%A_Index%_X, sidtooldata.ini, PickupCoords, Currency%A_Index%_X
iniread,Currency%A_Index%_Y, sidtooldata.ini, PickupCoords, Currency%A_Index%_Y
}
return

;[F6 Pickup Mode Switch GUI]----------------------------------------------------------------------------------------------

PickupModeSwitch:
Gui,PickupModeSwitch:new,,F6 Pickup Mode Switch
Gui +LabelPickupModeSwitch -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,gSetQuickPickup w200 hwndHBT13 ,Quick Pickup
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT13,BT1Options)

Gui, Add, Button,gSetPickupCoordSetup w200 hwndHBT14 ,Pickup Coord Setup
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT14,BT1Options)
Gui, font
Gui Add, StatusBar,, % "Made by Sid – Current F6 mode = "PickupMode  " . "
Gui, Show
return

PickupModeSwitchEscape:
PickupModeSwitchClose:
Gui,submit
Return

SetQuickPickup:
Gui,submit
if (Currency1_X = "error" or Currency1_Y = "error" or Currency2_X = "error" or Currency2_Y = "error")
{
msgbox,48,Notice,Quick Pickup mode selected but coordinates missing.`rUse Win+F6 -> Pickup Coord Setup first.
gosub,PickupModeSwitch
}
else
{
PickupMode = QuickPickup
IniWrite,% PickupMode , sidtooldata.ini, KeyModeSwitch, PickupMode
 Iniread, PickupMode , sidtooldata.ini, KeyModeSwitch, PickupMode
ToolTip("Pickup mode: " . PickupMode  . " . ")
}
Return

SetPickupCoordSetup:
Gui,submit
PickupMode = PickupCoordSetup
IniWrite,% PickupMode , sidtooldata.ini, KeyModeSwitch, PickupMode
 Iniread, PickupMode , sidtooldata.ini, KeyModeSwitch, PickupMode
ToolTip("Pickup mode: " . PickupMode  . " . ")
msgbox,48,Notice,Switched to coordinate setup. Move mouse over currency and press F6 enter number.
return

ReadF6KeyMode:
 Iniread, PickupMode , sidtooldata.ini, KeyModeSwitch, PickupMode
Return

;[F7 Coordinate Setup]------------------------------------------------------------------------------------------------------

#F7::
Msgbox,16,Notice,No multi‑mode for Win+F7.
return

*F7::
F7BackpackSetup:
MouseGetPos, thisPosX, thisPosY
PixelGetColor, colorabc, %thisPosX%, %thisPosY%
PosX := ["BackpackTL_X","BackpackBR_X","OtherBackpackTL_X","OtherBackpackBR_X","AcceptTrade_X","DivinationTrade_X","DivinationSlot_X","PortalScroll_X"]
PosY := ["BackpackTL_Y","BackpackBR_Y","OtherBackpackTL_Y","OtherBackpackBR_Y","AcceptTrade_Y","DivinationTrade_Y","DivinationSlot_Y","PortalScroll_Y"]
CosA := ["BackpackTL_C","BackpackBR_C","OtherBackpackTL_C","OtherBackpackBR_C","AcceptTrade_C","DivinationTrade_C","DivinationSlot_C","PortalScroll_C"]
InputBox, affixID,F7 Backpack Coordinate Setup, Current mouse pos [ %thisPosX% `, %thisPosY% ].`nIf not set, press Cancel.`nAfter correct setup use F7.`r`r1 = Backpack top‑left`r2 = Backpack bottom‑right`r3 = Other backpack top‑left`r4 = Other backpack bottom‑right`r5 = Accept trade`r6 = Divination card trade button`r7 = Divination card slot`r8 = Portal scroll (fixed inside backpack)`r`nEnter number (1~8),,400,380
	if not ErrorLevel
	{
		checkAffixID := RegExMatch(affixID, "[1-8]$")
		if checkAffixID = 1
		{
			iniWrite,% thisPosX, sidtooldata.ini, BackpackCoords, % PosX[affixID]
			iniWrite,% thisPosY, sidtooldata.ini, BackpackCoords, % PosY[affixID]
			iniwrite,% colorabc, sidtooldata.ini, BackpackCoords, % CosA[affixID]
			gosub,ReadF7BackpackLocations
			gosub,BackpackCalculation
			gosub,BackpackCalculation2
		}
		else if not (affixID = "1" or affixID = "2" or affixID = "3" or affixID = "4" or affixID = "5" or affixID = "6" or affixID = "7" or affixID = "8")
		{
			MsgBox,16,Error,Please enter a number 1~8
		}
	}
	return

ReadF7BackpackLocations:
iniread,BackpackTL_X, sidtooldata.ini, BackpackCoords, BackpackTL_X
iniread,BackpackTL_Y, sidtooldata.ini, BackpackCoords, BackpackTL_Y
iniread,BackpackBR_X, sidtooldata.ini, BackpackCoords, BackpackBR_X
iniread,BackpackBR_Y, sidtooldata.ini, BackpackCoords, BackpackBR_Y
iniread,OtherBackpackTL_X, sidtooldata.ini, BackpackCoords, OtherBackpackTL_X
iniread,OtherBackpackTL_Y, sidtooldata.ini, BackpackCoords, OtherBackpackTL_Y
iniread,OtherBackpackBR_X, sidtooldata.ini, BackpackCoords, OtherBackpackBR_X
iniread,OtherBackpackBR_Y, sidtooldata.ini, BackpackCoords, OtherBackpackBR_Y
iniread,AcceptTrade_X, sidtooldata.ini, BackpackCoords, AcceptTrade_X
iniread,AcceptTrade_Y, sidtooldata.ini, BackpackCoords, AcceptTrade_Y
iniread,DivinationTrade_X, sidtooldata.ini, BackpackCoords, DivinationTrade_X
iniread,DivinationTrade_Y, sidtooldata.ini, BackpackCoords, DivinationTrade_Y
iniread,DivinationTrade_C, sidtooldata.ini, BackpackCoords, DivinationTrade_C
iniread,DivinationSlot_X, sidtooldata.ini, BackpackCoords, DivinationSlot_X
iniread,DivinationSlot_Y, sidtooldata.ini, BackpackCoords, DivinationSlot_Y
iniread,DivinationSlot_C, sidtooldata.ini, BackpackCoords, DivinationSlot_C
iniread,PortalScroll_X, sidtooldata.ini, BackpackCoords, PortalScroll_X
iniread,PortalScroll_Y, sidtooldata.ini, BackpackCoords, PortalScroll_Y
return

BackpackCalculation:
ScanStartTL_X := % BackpackTL_X
ScanStartTL_Y := % BackpackTL_Y
ScanStartBR_X := % BackpackBR_X
ScanStartBR_Y := % BackpackBR_Y
ScanHorizontalCount := 12
ScanVerticalCount := 5
SlotWidth := floor((ScanStartBR_X - ScanStartTL_X) / ScanHorizontalCount)
SlotHeight := floor((ScanStartBR_Y - ScanStartTL_Y) / ScanVerticalCount)
return

;[F8 Divination Exchange]---------------------------------------------------------------------------------------------------

F8::
if Toolbutton = 1
{
ToolTip("You are in text mode, click or press Enter to switch back")
}
else
{
if (DivinationTrade_X = "error" or DivinationSlot_Y = "error")
 {
 msgbox,16,Error,Divination exchange coordinates not set!`rPosition mouse then use F7 enter 6 and 7.`rOK to open tutorial image.
 run,https://lelive.weebly.com/uploads/7/7/0/3/77032051/1202643573_2.jpg,,UseErrorLevel
 }
 else
 {
	if DivinationMode = Single Exchange Mode
	{
	gosub,SingleDivinationExchange
	return
	}
	if DivinationMode = Batch Exchange Mode
	{
	gosub,BatchDivinationExchange
	return
	}
 }
}
return

#F8::
gosub,DivinationModeSwitch
return

;[F8 Divination Routines]---------------------------------------------------------------------------------------------------

SingleDivinationExchange:
MouseGetPos,F8PosX,F8PosY
	send {Ctrl Down}
	MouseClick, Left,F8PosX,F8PosY,1,0
	sleep 100
	MouseClick, Left,DivinationTrade_X,DivinationTrade_Y,1,0
	sleep 100
	MouseClick, Left,DivinationSlot_X,DivinationSlot_Y,1,0
	send {Ctrl Up}
	MouseMove,F8PosX,F8PosY,0
return

BatchDivinationExchange:
Count := 1
SetTimer, StopReminder, 500
send {ctrl down}
loop % ScanHorizontalCount
{
	if (GetKeyState("~","P"))
	{
	send {ctrl up}
	SetTimer, StopReminder, Off
	return
	}
	PosX := (ScanStartTL_X+(SlotWidth/2)) + ((SlotWidth/2)*((A_Index-1)*2))
	loop % ScanVerticalCount
	{
			if (GetKeyState("~","P"))
			{
			send {ctrl up}
			SetTimer, StopReminder, Off
			return
			}
		PosY := (ScanStartTL_Y+(SlotHeight/2)) + ((SlotHeight/2)*((A_Index-1)*2))
		MouseClick,, % PosX, % PosY,1,0
		sleep 100
		PixelGetColor,SlotColor,%DivinationSlot_X%,%DivinationSlot_Y%
		if SlotColor = %DivinationSlot_C%
		{
		}
		else
		{
		PixelGetColor,TradeColor2,%DivinationTrade_X%,%DivinationTrade_Y%
			if TradeColor2 = %DivinationTrade_C%
			{
			FailCount := ++Count
			MouseClick,,DivinationSlot_X,DivinationSlot_Y,1,0
				if FailCount = 10
					{
					send {ctrl up}
					SetTimer, StopReminder, Off
					msgbox % "Failed 10 times – stopping. Please clear some inventory space."
					return
					}
			}
			else
			{
			sleep 100
			MouseClick,,DivinationTrade_X,DivinationTrade_Y,1,0
			Sleep 100
			MouseClick,,DivinationSlot_X,DivinationSlot_Y,1,0
			}
		}
	}
}
send {ctrl up}
SetTimer, StopReminder, Off
return

return

;[F8 Divination Mode Switch GUI]----------------------------------------------------------------------------------------------

DivinationModeSwitch:
Gui,DivinationModeSwitch:new,,F8 Divination Mode Switch
Gui +LabelDivinationModeSwitch -Resize  -MinimizeBox -MaximizeBox +AlwaysOnTop
Gui Color, 0x00FFFF
Gui, font, s20, 方正兰亭黑_GBK
Gui, Add, Button,gSetSingleExchange w200 hwndHBT22 ,Single Exchange
BT1Options:= [{BC: "99D1D3|FFFFFF", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT22,BT1Options)

Gui, Add, Button,gSetBatchExchange w200 hwndHBT23 ,Batch Exchange
BT1Options:= [{BC: "FFFF00|FF0000", TC: "Black", 3D: 1, G: 0}]
BT1Options[2] := {BC: "0000FF|FFFF00", TC: "000000", 3D: 0, G: 1}
CreateImageButton(HBT23,BT1Options)
Gui, font
Gui Add, StatusBar,, % "Made by Sid – Current F8 mode = "DivinationMode  " . "
Gui, Show
return

DivinationModeSwitchEscape:
DivinationModeSwitchClose:
Gui,submit
Return

SetSingleExchange:
Gui,submit
	if (DivinationTrade_X = "error" or DivinationSlot_Y = "error")
	{
	msgbox,48,Notice,Single Exchange selected but coordinates missing – use F7 to set.
	}
	else
	{
	DivinationMode = Single Exchange Mode
	IniWrite,% DivinationMode , sidtooldata.ini, KeyModeSwitch, DivinationMode
	 Iniread, DivinationMode , sidtooldata.ini, KeyModeSwitch, DivinationMode
	ToolTip("Divination mode: " . DivinationMode  . " . ")
	}
Return

SetBatchExchange:
Gui,submit
	if (DivinationTrade_X = "error" or DivinationSlot_Y = "error")
	{
	msgbox,48,Notice,Batch Exchange selected but coordinates missing – use F7 to set.
	}
	else
	{
	DivinationMode = Batch Exchange Mode
	IniWrite,% DivinationMode , sidtooldata.ini, KeyModeSwitch, DivinationMode
	 Iniread, DivinationMode , sidtooldata.ini, KeyModeSwitch, DivinationMode
	ToolTip("Divination mode: " . DivinationMode  . " . ")
	}
Return

ReadF8KeyMode:
Iniread, DivinationMode , sidtooldata.ini, KeyModeSwitch, DivinationMode
Return

;[Switch Character Profile GUI]----------------------------------------------------------------------------------------------

SwitchProfileGUI:
Gui,SwitchProfile:new,,Switch Character Profile
Gui +LabelSwitchProfile -Resize  -MinimizeBox -MaximizeBox
Gui Color, 0xC0C0C0
Gui Font, s12 cBlue, Verdana
Gui Add, Text, x15 y15 w130 h23 +0x200, (1) Profile name:
Gui Add, Text, x15 y45 w130 h23, (2) Profile name:
Gui Add, Text, x15 y75 w130 h23, (3) Profile name:
Gui Font, s8 cRed, Verdana
Gui Add, Text, x18 y101 w338 h23 +0x200, Enter recognizable names for multi‑character setups.
Gui Font
Gui Add, Edit, vProfileName1 x150 y14 w120 h21 -Theme, %ProfileName1%
Gui Add, Edit, vProfileName2 x150 y45 w120 h21 -Theme, %ProfileName2%
Gui Add, Edit, vProfileName3 x150 y75 w120 h21 -Theme, %ProfileName3%
Gui Add, Button, gSwitchProfile1 x280 y13 w80 h23 -Theme, Switch 1
Gui Add, Button, gSwitchProfile2 x280 y43 w80 h23 -Theme, Switch 2
Gui Add, Button, gSwitchProfile3 x280 y73 w80 h23 -Theme, Switch 3
Gui Add, StatusBar,, Current profile: %CurrentProfileName% , number %CurrentProfile% .
Gui Show, w368 h153, Switch Character Profile:
Return

SwitchProfileEscape:
SwitchProfileClose:
Msgbox,4,Notice,Settings not saved. Close anyway? (Yes / No)`r`rTo save, use switch buttons 1~3.
IfMsgBox No
	Return
Else
	Gui,submit
Return

SwitchProfile1:
Gui,submit
StopUser = 0
Gosub,StopLoopSkills
Autodrinkbutton = 0
Gosub,PauseLoopDrink
Gosub,StopDetectionLoops
CurrentProfileName = %ProfileName1%
CurrentProfile = 1
IniWrite,% ProfileName1 , sidtooldata.ini, CharacterProfiles, ProfileName1
IniWrite,% ProfileName2 , sidtooldata.ini, CharacterProfiles, ProfileName2
IniWrite,% ProfileName3 , sidtooldata.ini, CharacterProfiles, ProfileName3
IniWrite,% CurrentProfileName , sidtooldata.ini, CharacterProfiles, CurrentProfileName
IniWrite,% CurrentProfile , sidtooldata.ini, CharacterProfiles, CurrentProfile
Iniread,ProfileName1 , sidtooldata.ini, CharacterProfiles, ProfileName1
Iniread,ProfileName2 , sidtooldata.ini, CharacterProfiles, ProfileName2
Iniread,ProfileName3 , sidtooldata.ini, CharacterProfiles, ProfileName3
Iniread, CurrentProfile , sidtooldata.ini, CharacterProfiles, CurrentProfile
Iniread,CurrentProfileName , sidtooldata.ini, CharacterProfiles, CurrentProfileName
gosub,ReadColorCoordinates
gosub,ReadMineSettings
gosub,ReadSkillComboData
gosub,ReadLoopSettings
gosub,ReadDrinkCheckboxRecords
gosub,ReadDrinkDetectionData
gosub,ReadFlaskTriggerRecords
msgbox,0,Notice,Switched profile – all loops and F10 mode turned off.`r`rPlease re‑set detection points as each character may differ.
Return

SwitchProfile2:
Gui,submit
StopUser = 0
Settimer,LoopSkill1,off
Settimer,LoopSkill3,off
Settimer,LoopSkill2,off
Autodrinkbutton = 0
Gosub,PauseLoopDrink
Gosub,StopDetectionLoops
CurrentProfileName = %ProfileName2%
CurrentProfile = 2
IniWrite,% ProfileName1 , sidtooldata.ini, CharacterProfiles, ProfileName1
IniWrite,% ProfileName2 , sidtooldata.ini, CharacterProfiles, ProfileName2
IniWrite,% ProfileName3 , sidtooldata.ini, CharacterProfiles, ProfileName3
IniWrite,% CurrentProfileName , sidtooldata.ini, CharacterProfiles, CurrentProfileName
IniWrite,% CurrentProfile , sidtooldata.ini, CharacterProfiles, CurrentProfile
Iniread,ProfileName1 , sidtooldata.ini, CharacterProfiles, ProfileName1
Iniread,ProfileName2 , sidtooldata.ini, CharacterProfiles, ProfileName2
Iniread,ProfileName3 , sidtooldata.ini, CharacterProfiles, ProfileName3
Iniread, CurrentProfile , sidtooldata.ini, CharacterProfiles, CurrentProfile
Iniread,CurrentProfileName , sidtooldata.ini, CharacterProfiles, CurrentProfileName
gosub,ReadColorCoordinates
gosub,ReadMineSettings
gosub,ReadSkillComboData
gosub,ReadLoopSettings
gosub,ReadDrinkCheckboxRecords
gosub,ReadDrinkDetectionData
gosub,ReadFlaskTriggerRecords
msgbox,0,Notice,Switched profile – all loops and F10 mode turned off.`r`rPlease re‑set detection points as each character may differ.
Return

SwitchProfile3:
Gui,submit
StopUser = 0
Settimer,LoopSkill1,off
Settimer,LoopSkill3,off
Settimer,LoopSkill2,off
Autodrinkbutton = 0
Gosub,PauseLoopDrink
Gosub,StopDetectionLoops
CurrentProfileName = %ProfileName3%
CurrentProfile = 3
IniWrite,% ProfileName1 , sidtooldata.ini, CharacterProfiles, ProfileName1
IniWrite,% ProfileName2 , sidtooldata.ini, CharacterProfiles, ProfileName2
IniWrite,% ProfileName3 , sidtooldata.ini, CharacterProfiles, ProfileName3
IniWrite,% CurrentProfileName , sidtooldata.ini, CharacterProfiles, CurrentProfileName
IniWrite,% CurrentProfile , sidtooldata.ini, CharacterProfiles, CurrentProfile
Iniread,ProfileName1 , sidtooldata.ini, CharacterProfiles, ProfileName1
Iniread,ProfileName2 , sidtooldata.ini, CharacterProfiles, ProfileName2
Iniread,ProfileName3 , sidtooldata.ini, CharacterProfiles, ProfileName3
Iniread, CurrentProfile , sidtooldata.ini, CharacterProfiles, CurrentProfile
Iniread,CurrentProfileName , sidtooldata.ini, CharacterProfiles, CurrentProfileName
gosub,ReadColorCoordinates
gosub,ReadMineSettings
gosub,ReadSkillComboData
gosub,ReadLoopSettings
gosub,ReadDrinkCheckboxRecords
gosub,ReadDrinkDetectionData
gosub,ReadFlaskTriggerRecords
msgbox,0,Notice,Switched profile – all loops and F10 mode turned off.`r`rPlease re‑set detection points as each character may differ.
Return

ReadCurrentCharacterConfig:
Iniread,ProfileName1 , sidtooldata.ini, CharacterProfiles, ProfileName1
Iniread,ProfileName2 , sidtooldata.ini, CharacterProfiles, ProfileName2
Iniread,ProfileName3 , sidtooldata.ini, CharacterProfiles, ProfileName3
Iniread, CurrentProfile , sidtooldata.ini, CharacterProfiles, CurrentProfile
Iniread,CurrentProfileName , sidtooldata.ini, CharacterProfiles, CurrentProfileName
if CurrentProfile = Error
{
CurrentProfile = 1
}
Return


;[Fancy Button Generator]----------------------------------------------------------------------------------------------

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