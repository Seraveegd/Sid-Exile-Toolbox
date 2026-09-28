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
            clearBagMode: 'clearBagMode',
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
            } else if (key === 'clearBagMode') {
                var val = safeValue(data[key]);
                if (val && val.indexOf('快搜') !== -1) {
                    el.value = '掃描快搜';
                } else {
                    el.value = val;
                }
            } else {
                el.value = safeValue(data[key]);
            }
        });

        var hkFields = ['hk_F1', 'hk_F2', 'hk_F3', 'hk_WinZ', 'hk_Space', 'hk_Insert', 'hk_End'];
        hkFields.forEach(function (id) {
            var el = document.getElementById(id);
            if (el && data[id]) {
                el.setAttribute('data-ahk', data[id]);
                el.value = parseAHKHotkeyToDisplay(data[id]);
            }
        });

        // 同步畫面偵測點 (5~6) 與背包定位點 (1, 2)
        [5, 6].forEach(function (c) {
            updateAnchorPoint('color', c, data['color' + c + '_X'], data['color' + c + '_Y'], data['color' + c + '_C']);
        });
        [1, 2].forEach(function (b) {
            updateAnchorPoint('bag', b, data['bag' + b + '_X'], data['bag' + b + '_Y'], data['bag' + b + '_C']);
        });

        // 同步探險討價還價定位點 (1: 確認按鈕, 2: 重骰按鈕)
        updateAnchorPoint('haggle', 1, data['haggleConfirm_X'], data['haggleConfirm_Y'], '');
        updateAnchorPoint('haggle', 2, data['haggleReroll_X'], data['haggleReroll_Y'], '');

        // 同步探險關南賭博定位點 (1: 重骰, 2: 左上, 3: 右下) 與過濾文字
        updateAnchorPoint('gwennen', 1, data['gwennenReroll_X'], data['gwennenReroll_Y'], '');
        updateAnchorPoint('gwennen', 2, data['gwennenLeft_X'], data['gwennenLeft_Y'], '');
        updateAnchorPoint('gwennen', 3, data['gwennenRight_X'], data['gwennenRight_Y'], '');

        var elFilter = document.getElementById('gwennenFilter');
        if (elFilter && data['gwennenFilter'] !== undefined) {
            elFilter.value = data['gwennenFilter'];
        }

        // 同步交換寶石定位點 (1: 裝備插槽, 2: 背包寶石) 與副手切換開關
        updateAnchorPoint('gemSwap', 1, data['gem1_X'], data['gem1_Y'], '');
        updateAnchorPoint('gemSwap', 2, data['gem2_X'], data['gem2_Y'], '');

        var elGemSwap = document.getElementById('gemWeaponSwap');
        if (elGemSwap && data['gemWeaponSwap'] !== undefined) {
            elGemSwap.checked = (data['gemWeaponSwap'] === '1' || data['gemWeaponSwap'] === 1 || data['gemWeaponSwap'] === true || data['gemWeaponSwap'] === 'true');
        }

    } catch (err) {
        // Log error
    }
}

var defaultHotkeys = {
    hk_F1: '*F1',
    hk_F2: 'F2',
    hk_F3: 'F3',
    hk_WinZ: '`',
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
        case 9: return 'Tab';
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
        'hk_F1', 'hk_F2', 'hk_F3', 'hk_WinZ',
        'hk_Space', 'hk_Insert', 'hk_End'
    ];

    var values = {};
    var counts = {};
    var labelMap = {
        hk_F1: '返回角色',
        hk_F2: '暫離 / 勿擾',
        hk_F3: '清包切換',
        hk_WinZ: '開啟菜單視窗',
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
        values.hk_F1, values.hk_F2, values.hk_F3,
        values.hk_WinZ,
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

//儲存清包模式設定
function saveClearBagConfig() {
    if (typeof ahk === 'undefined') return;
    ahk.NeutronSaveClearBagConfig(
        document.getElementById('clearBagMode').value
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

//格式化 0xRRGGBB / 0xBBGGRR 色碼為 HTML #RRGGBB 供預覽色塊使用
function formatHexColor(cStr) {
    if (!cStr || cStr === 'error' || cStr === '未設定' || cStr === '-') return '#333';
    var hex = cStr.toString().replace(/^0x/i, '');
    while (hex.length < 6) hex = '0' + hex;
    return '#' + hex;
}

//觸發定位點抓取 (隱藏 UI 視窗，提示使用者按 F7)
function captureAnchorPoint(type, id) {
    if (typeof ahk === 'undefined') return;
    ahk.StartAnchorCapture(type, id);
}

//由 AHK 抓取完成後回呼更新 UI 表格項目
function updateAnchorPoint(type, id, x, y, color) {
    var prefix = (type === 'color') ? 'c' : ((type === 'bag') ? 'b' : ((type === 'haggle') ? 'h' : ((type === 'gwennen') ? 'g' : 'gem')));
    var elX = document.getElementById(prefix + id + '_x');
    var elY = document.getElementById(prefix + id + '_y');
    var elC = document.getElementById(prefix + id + '_c');
    var elBox = document.getElementById(prefix + id + '_box');

    var valX = (x !== undefined && x !== null && x !== 'error' && x !== '' && x !== '0' && x !== 0) ? x : '未設定';
    var valY = (y !== undefined && y !== null && y !== 'error' && y !== '' && y !== '0' && y !== 0) ? y : '未設定';
    var valC = (color !== undefined && color !== null && color !== 'error' && color !== '') ? color : '未設定';

    if (elX) elX.textContent = valX;
    if (elY) elY.textContent = valY;
    if (elC) elC.textContent = valC;
    if (elBox) elBox.style.backgroundColor = formatHexColor(valC);
}

// 自動儲存關南過濾文字
function autoSaveGwennenFilter() {
    var el = document.getElementById('gwennenFilter');
    if (!el || typeof ahk === 'undefined') return;
    ahk.NeutronSaveGwennenFilter(el.value);
}

// 一鍵複製關南過濾文字至剪貼簿
function copyGwennenFilter() {
    var input = document.getElementById('gwennenFilter');
    if (!input) return;
    var text = input.value;
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(function () {
            showCopyFeedback();
        }).catch(function () {
            fallbackCopy(text);
        });
    } else {
        fallbackCopy(text);
    }
}

function fallbackCopy(text) {
    var input = document.getElementById('gwennenFilter');
    if (!input) return;
    input.select();
    input.setSelectionRange(0, 99999);
    try {
        document.execCommand('copy');
        showCopyFeedback();
    } catch (err) {
        alert('複製失敗，請手動複製');
    }
}

function showCopyFeedback() {
    var btn = document.getElementById('btnCopyGwennenFilter');
    if (btn) {
        var origText = btn.innerHTML;
        btn.innerHTML = '✅ 已複製！';
        btn.classList.remove('btn-outline-info');
        btn.classList.add('btn-success');
        setTimeout(function () {
            btn.innerHTML = origText;
            btn.classList.remove('btn-success');
            btn.classList.add('btn-outline-info');
        }, 1500);
    }
}

// 儲存寶石副手切換設定
function saveGemSwapConfig() {
    var el = document.getElementById('gemWeaponSwap');
    if (!el || typeof ahk === 'undefined') return;
    ahk.NeutronSaveGemSwapConfig(el.checked ? 1 : 0);
}

function showStartupModal() {
    var el = document.getElementById('startupModal');
    if (el) {
        el.style.display = 'block';
        el.classList.add('show');
        el.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
    }
}

function hideStartupModal() {
    var el = document.getElementById('startupModal');
    if (el) {
        el.classList.remove('show');
        el.style.display = 'none';
    }
}

function showExitModal() {
    var el = document.getElementById('exitModal');
    if (el) {
        el.style.display = 'block';
        el.classList.add('show');
        el.style.backgroundColor = 'rgba(0, 0, 0, 0.7)';
    }
}

function hideExitModal() {
    var el = document.getElementById('exitModal');
    if (el) {
        el.classList.remove('show');
        el.style.display = 'none';
    }
}

//載入時同步資料
window.onload = function () {
    initHotkeyRecorder();
    setTimeout(syncDataFromAHK, 200);
};