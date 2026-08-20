//讓AutoHotkey能夠讀取這個ui.js
//顯示選單內容
function showSection(sectionId) {
    var items = document.querySelectorAll('.menu-item');
    for (var i = 0; i < items.length; i++) {
        items[i].className = items[i].className.replace(/\bactive\b/g, '').replace(/\s+/g, ' ').replace(/^\s+|\s+$/g, '');
    }

    var panels = document.querySelectorAll('.panel');
    for (var j = 0; j < panels.length; j++) {
        panels[j].className = panels[j].className.replace(/\bactive\b/g, '').replace(/\s+/g, ' ').replace(/^\s+|\s+$/g, '');
    }

    var targetPanel = document.getElementById(sectionId);
    if (targetPanel) {
        targetPanel.className += ' active';
    }

    for (var k = 0; k < items.length; k++) {
        var onclickAttr = items[k].getAttribute('onclick') || '';
        if (onclickAttr.indexOf("'" + sectionId + "'") !== -1 || onclickAttr.indexOf('"' + sectionId + '"') !== -1) {
            items[k].className += ' active';
        }
    }
}

//安全取得 AHK 同步欄位值，避免 literal "null" / "undefined" 造成 UI 顯示錯誤
function safeValue(value) {
    if (value === null || value === undefined) return '';
    if (typeof value === 'string' && (value.toLowerCase() === 'null' || value.toLowerCase() === 'undefined')) return '';
    return value;
}

//與AutoHotkey同步資料
function syncDataFromAHK() {
    try {
        if (typeof ahk === 'undefined') return;
        var jsonStr = ahk.NeutronGetSettings();
        if (!jsonStr) return;
        var data = JSON.parse(jsonStr);

        var fieldMap = {
            flaskMode: 'flaskMode',
            mainSkill: 'mainSkill',
            skillFlasks: 'skillFlasks',
            spaceFlasks: 'spaceFlasks',
            dur1: 'dur1',
            dur2: 'dur2',
            dur3: 'dur3',
            dur4: 'dur4',
            dur5: 'dur5',
            comboStatus: 'comboStatus',
            comboKey1: 'comboKey1',
            comboDelay1: 'comboDelay1',
            comboKey2: 'comboKey2',
            comboDelay2: 'comboDelay2',
            comboKey3: 'comboKey3',
            loop1: 'loop1',
            loopT1: 'loopT1',
            loop2: 'loop2',
            loopT2: 'loopT2',
            loop3: 'loop3',
            loopT3: 'loopT3',
            clickMode: 'clickMode',
            clickSpeed: 'clickSpeed',
            mineMode: 'mineMode',
            mineStaffMode: 'mineStaffMode',
            mineKey: 'mineKey',
            mineDelay1: 'mineDelay1',
            smokeKey: 'smokeKey',
            mineDelay2: 'mineDelay2',

            pageEnchant: 'pageEnchant',
            pageLegendary: 'pageLegendary',
            pageLegendaryRing: 'pageLegendaryRing',
            pageThief: 'pageThief',
            pageRemove2: 'pageRemove2',
            pageIncubator: 'pageIncubator',
            pageAbyssJewel: 'pageAbyssJewel',
            pageClusterJewel: 'pageClusterJewel',
            pageNormalJewel: 'pageNormalJewel',
            pageFaction: 'pageFaction',
            pageSpecialMap: 'pageSpecialMap',
            pageRiftRing: 'pageRiftRing',
            pageUniqueHelmet: 'pageUniqueHelmet',
            pageUniqueArmour: 'pageUniqueArmour',
            pageUniqueBelt: 'pageUniqueBelt',
            pageUniqueGloves: 'pageUniqueGloves',
            pageUniqueBoots: 'pageUniqueBoots',
            pageUniqueAccessory: 'pageUniqueAccessory',
            pageUniqueWeapon: 'pageUniqueWeapon',
            pageReturn: 'pageReturn'
        };

        Object.keys(fieldMap).forEach(function (key) {
            var el = document.getElementById(fieldMap[key]);
            if (!el) return;
            if (el.type === 'checkbox') {
                el.checked = safeValue(data[key]) === '+checked' || safeValue(data[key]) === '+Checked' || safeValue(data[key]) === '1';
            } else {
                el.value = safeValue(data[key]);
            }
        });

        var hkFields = ['hk_F1', 'hk_F2', 'hk_F3', 'hk_F7', 'hk_WinZ', 'hk_WinV', 'hk_WinC', 'hk_Space', 'hk_Insert', 'hk_End'];
        hkFields.forEach(function (id) {
            var el = document.getElementById(id);
            if (el && data[id]) {
                el.setAttribute('data-ahk', data[id]);
                el.value = parseAHKHotkeyToDisplay(data[id]);
            }
        });

    } catch (err) {
        // Log error
    }
}

var defaultHotkeys = {
    hk_F1: '*F1',
    hk_F2: 'F2',
    hk_F3: 'F3',
    hk_F7: '*F7',
    hk_WinZ: '`',
    hk_WinV: '#v',
    hk_WinC: '#c',
    hk_Space: '~*space',
    hk_Insert: '*Insert',
    hk_End: 'End'
};

function parseAHKHotkeyToDisplay(ahkStr) {
    if (!ahkStr) return '';
    var str = ahkStr.replace(/^[~*$]+/g, '');
    var mods = [];
    if (str.indexOf('#') !== -1) mods.push('Win');
    if (str.indexOf('^') !== -1) mods.push('Ctrl');
    if (str.indexOf('!') !== -1) mods.push('Alt');
    if (str.indexOf('+') !== -1) mods.push('Shift');

    var key = str.replace(/[#^!+]/g, '');
    if (key.toLowerCase() === 'space') key = 'Space';
    if (key.toLowerCase() === 'pgup') key = 'PgUp';
    if (key.toLowerCase() === 'pgdn') key = 'PgDn';
    if (key.length === 1 && key >= 'a' && key <= 'z') key = key.toUpperCase();

    if (mods.length > 0) {
        return mods.join(' + ') + ' + ' + key;
    }
    return key;
}

function getRawKeyNameFromEvent(e) {
    var keyCode = e.keyCode || e.which || 0;

    if (keyCode >= 48 && keyCode <= 57) {
        return String.fromCharCode(keyCode);
    }
    if (keyCode >= 65 && keyCode <= 90) {
        return String.fromCharCode(keyCode).toLowerCase();
    }
    if (keyCode >= 112 && keyCode <= 123) {
        return 'F' + (keyCode - 111);
    }
    if (keyCode >= 96 && keyCode <= 105) {
        return 'Numpad' + (keyCode - 96);
    }

    switch (keyCode) {
        case 32: return 'space';
        case 33: return 'PgUp';
        case 34: return 'PgDn';
        case 35: return 'End';
        case 36: return 'Home';
        case 37: return 'Left';
        case 38: return 'Up';
        case 39: return 'Right';
        case 40: return 'Down';
        case 45: return 'Insert';
        case 27: return 'Escape';
        case 9:  return 'Tab';
        case 192: return '`';
        case 189: return '-';
        case 187: return '=';
        case 219: return '[';
        case 221: return ']';
        case 220: return '\\';
        case 186: return ';';
        case 222: return "'";
        case 188: return ',';
        case 190: return '.';
        case 191: return '/';
    }

    if (e.key && e.key.length === 1 && e.key.charCodeAt(0) >= 32) {
        return e.key.toLowerCase();
    }

    return '';
}

function initHotkeyRecorder() {
    var inputs = document.querySelectorAll('.hotkey-input');
    Array.prototype.forEach.call(inputs, function (input) {
        input.addEventListener('keydown', function (e) {
            e = e || window.event;
            e.preventDefault();
            e.stopPropagation();

            var key = e.key || '';
            var keyCode = e.keyCode || e.which || 0;

            // 清除按鍵
            if (key === 'Backspace' || key === 'Delete' || keyCode === 8 || keyCode === 46) {
                input.value = '';
                input.setAttribute('data-ahk', '');
                return;
            }

            // 忽略單獨按下修飾鍵
            if (['Control', 'Alt', 'Shift', 'Meta', 'OS'].indexOf(key) !== -1 || keyCode === 16 || keyCode === 17 || keyCode === 18 || keyCode === 91 || keyCode === 92 || keyCode === 225) {
                return;
            }

            var modifiers = [];
            if (e.ctrlKey) modifiers.push('^');
            if (e.altKey) modifiers.push('!');
            if (e.shiftKey) modifiers.push('+');
            if (e.metaKey) modifiers.push('#');

            var keyName = getRawKeyNameFromEvent(e);
            if (!keyName) return;

            var ahkVal = modifiers.join('') + keyName;
            input.value = parseAHKHotkeyToDisplay(ahkVal);
            input.setAttribute('data-ahk', ahkVal);
        });
    });
}

function saveCustomHotkeys() {
    if (typeof ahk === 'undefined') return;

    var hkFields = [
        'hk_F1', 'hk_F2', 'hk_F3', 'hk_F7', 'hk_WinZ', 'hk_WinV', 'hk_WinC',
        'hk_Space', 'hk_Insert', 'hk_End'
    ];

    var values = {};
    var counts = {};
    var labelMap = {
        hk_F1: '返回角色',
        hk_F2: '暫離 / 勿擾',
        hk_F3: '清包切換',
        hk_F7: '背包座標定位',
        hk_WinZ: '開啟菜單視窗',
        hk_WinV: '快速查價',
        hk_WinC: '座標與顏色偵測',
        hk_Space: '一鍵喝水',
        hk_Insert: '自動循環技能',
        hk_End: '快速申請組隊'
    };

    var conflictFound = false;

    hkFields.forEach(function (id) {
        var el = document.getElementById(id);
        var val = el ? (el.getAttribute('data-ahk') || el.value) : '';
        var normVal = val.replace(/^[~*$]+/g, '').toLowerCase();
        values[id] = val;

        if (normVal) {
            if (!counts[normVal]) {
                counts[normVal] = [labelMap[id]];
            } else {
                counts[normVal].push(labelMap[id]);
                conflictFound = true;
            }
        }
    });

    if (conflictFound) {
        var conflictMsgs = [];
        Object.keys(counts).forEach(function (k) {
            if (counts[k].length > 1) {
                conflictMsgs.push('「' + counts[k].join('」與「') + '」設定了重複按鍵 [' + parseAHKHotkeyToDisplay(k) + ']');
            }
        });
        alert('⚠️ 按鍵衝突，無法儲存！\n\n' + conflictMsgs.join('\n'));
        return;
    }

    ahk.NeutronSaveCustomHotkeys(
        values.hk_F1, values.hk_F2, values.hk_F3, values.hk_F7,
        values.hk_WinZ, values.hk_WinV, values.hk_WinC,
        values.hk_Space, values.hk_Insert, values.hk_End
    );
}

function resetDefaultHotkeys() {
    Object.keys(defaultHotkeys).forEach(function (id) {
        var el = document.getElementById(id);
        if (el) {
            var defVal = defaultHotkeys[id];
            el.value = parseAHKHotkeyToDisplay(defVal);
            el.setAttribute('data-ahk', defVal);
        }
    });
}

//儲存喝水設定
function saveFlaskConfig() {
    if (typeof ahk === 'undefined') return;
    ahk.NeutronSaveFlaskConfig(
        document.getElementById('flaskMode').value,
        document.getElementById('mainSkill').value,
        document.getElementById('skillFlasks').value,
        document.getElementById('spaceFlasks').value,
        document.getElementById('dur1').value,
        document.getElementById('dur2').value,
        document.getElementById('dur3').value,
        document.getElementById('dur4').value,
        document.getElementById('dur5').value
    );
}

//儲存技能連段設定
function saveComboConfig() {
    if (typeof ahk === 'undefined') return;
    ahk.NeutronSaveSkillComboConfig(
        document.getElementById('comboStatus').value,
        document.getElementById('comboKey1').value,
        document.getElementById('comboDelay1').value,
        document.getElementById('comboKey2').value,
        document.getElementById('comboDelay2').value,
        document.getElementById('comboKey3').value
    );
}

//儲存循環技能設定
function saveLoopConfig() {
    if (typeof ahk === 'undefined') return;
    ahk.NeutronSaveLoopSkillConfig(
        document.getElementById('loop1').value,
        document.getElementById('loopT1').value,
        document.getElementById('loop2').value,
        document.getElementById('loopT2').value,
        document.getElementById('loop3').value,
        document.getElementById('loopT3').value
    );
}

//儲存滑鼠連點設定
function saveClickerConfig() {
    if (typeof ahk === 'undefined') return;
    ahk.NeutronSaveClickerConfig(
        document.getElementById('clickMode').value,
        document.getElementById('clickSpeed').value
    );
}

//儲存地雷設置
function saveMineConfig() {
    if (typeof ahk === 'undefined') return;
    ahk.NeutronSaveMineConfig(
        document.getElementById('mineMode').value,
        document.getElementById('mineStaffMode').value,
        document.getElementById('mineKey').value,
        document.getElementById('mineDelay1').value,
        document.getElementById('smokeKey').value,
        document.getElementById('mineDelay2').value
    );
}



//儲存倉庫頁面設置
function saveWarehouseConfig() {
    if (typeof ahk === 'undefined') return;
    ahk.NeutronSaveWarehouseConfig(
        document.getElementById('pageEnchant').value,
        document.getElementById('pageLegendary').value,
        document.getElementById('pageLegendaryRing').value,
        document.getElementById('pageThief').value,
        document.getElementById('pageRemove2').value,
        document.getElementById('pageIncubator').value,
        document.getElementById('pageAbyssJewel').value,
        document.getElementById('pageClusterJewel').value,
        document.getElementById('pageNormalJewel').value,
        document.getElementById('pageFaction').value,
        document.getElementById('pageSpecialMap').value,
        document.getElementById('pageRiftRing').value,
        document.getElementById('pageUniqueHelmet').value,
        document.getElementById('pageUniqueArmour').value,
        document.getElementById('pageUniqueBelt').value,
        document.getElementById('pageUniqueGloves').value,
        document.getElementById('pageUniqueBoots').value,
        document.getElementById('pageUniqueAccessory').value,
        document.getElementById('pageUniqueWeapon').value,
        document.getElementById('pageReturn').value
    );
}

//載入時同步資料
window.onload = function () {
    initHotkeyRecorder();
    setTimeout(syncDataFromAHK, 200);
};