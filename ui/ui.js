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

        if (data.profile) {
            var profileEl = document.getElementById('currentProfileDisplay');
            if (profileEl) profileEl.innerText = data.profileName || ('角色配置 ' + data.profile);
        }

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
            drinkBarCheck: 'drinkBarCheck',
            drinkReturnCheck: 'drinkReturnCheck',
            drinkManaCheck: 'drinkManaCheck',
            drinkPenCheck: 'drinkPenCheck',
            drinkPenReturnCheck: 'drinkPenReturnCheck',
            drinkPoolCheck: 'drinkPoolCheck',
            drinkHint: 'drinkHint',
            drinkInterval: 'drinkInterval',
            drinkKey1: 'drinkKey1',
            drinkKey2: 'drinkKey2',
            drinkKey3: 'drinkKey3',
            drinkKey4: 'drinkKey4',
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

    } catch (err) {
        // Log error
    }
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

//儲存偵測喝水設置
function saveDrinkDetectionConfig() {
    if (typeof ahk === 'undefined') return;
    ahk.NeutronSaveDrinkDetectionConfig(
        document.getElementById('drinkBarCheck').checked ? '+Checked' : '-Checked',
        document.getElementById('drinkReturnCheck').checked ? '+Checked' : '-Checked',
        document.getElementById('drinkManaCheck').checked ? '+Checked' : '-Checked',
        document.getElementById('drinkPenCheck').checked ? '+Checked' : '-Checked',
        document.getElementById('drinkPenReturnCheck').checked ? '+Checked' : '-Checked',
        document.getElementById('drinkPoolCheck').checked ? '+Checked' : '-Checked',
        document.getElementById('drinkHint').value,
        document.getElementById('drinkInterval').value,
        document.getElementById('drinkKey1').value,
        document.getElementById('drinkKey2').value,
        document.getElementById('drinkKey3').value,
        document.getElementById('drinkKey4').value
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
    setTimeout(syncDataFromAHK, 200);
};