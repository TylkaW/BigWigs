assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsFlashNShake")

-- Frames
local flasher = nil
local elapsed = 0

L:RegisterTranslations("enUS", function() return {
	["FlashNShake"] = true,
	["Flash'N'Shake"] = true,
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = true,

	["Flash"] = true,
	["Toggle Flash on or off."] = true,

	["Shake"] = true,
	["Toggle Shake on or off."] = true,

	["Test"] = true,
	["Perform a Flash/Shake test."] = true,

	flash_warning = "Screen Shake failed. This is usually caused when nameplates are on.\nTurn off nameplates and reload UI or turn off BigWigs 'Shake'. (Flash is NOT affected)",
} end)

L:RegisterTranslations("koKR", function() return {
	["FlashNShake"] = "번쩍임N진동",
	["Flash'N'Shake"] = "번쩍임과 진동",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "당신에게 직접적으로 중요한 무언가가 영향을 미칠때 화면을 흔들거나 파란색으로 번쩍입니다.",

	["Flash"] = "번쩍임",
	["Toggle Flash on or off."] = "번쩍임을 켜거나 끕니다.",

	["Shake"] = "진동",
	["Toggle Shake on or off."] = "진동을 켜거나 끕니다.",

	["Test"] = "테스트",
	["Perform a Flash/Shake test."] = "번쩍임/진동 테스트를 실행합니다.",

	flash_warning = "화면 번쩍임은 실패했습니다. 이것은 보통 nameplates(이름표 표시)가 켜져 있을 때 일어납니다.\n nameplates(이름표 표시)를 끄고 UI를 다시 로딩을 하거나 BigWigs의 '진동'을 끄세요. (번쩍임은 영향 받지 않습니다)",
} end)

L:RegisterTranslations("frFR", function() return {
	["Flash'N'Shake"] = "Flash",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "Secoue et/ou fais flasher l'écran en bleu quand quelque chose d'important vous affecte directement.",

	["Flash"] = "Flash",
	["Toggle Flash on or off."] = "Fais flasher ou non l'écran.",

	["Shake"] = "Secousse",
	["Toggle Shake on or off."] = "Fais secouer ou non l'écran.",

	["Test"] = "Test",
	["Perform a Flash/Shake test."] = "Effectue un test du flash.",

	flash_warning = "Échec de la secousse de l'écran. Ceci arrive habituellement quand les \"nameplates\" (l'affichage des noms et des barres de vie au dessus des personnages dans le champ de jeu) sont activés.\nDésactivez-les et rechargez l'IU, ou désactivez la 'Secousse' de BigWigs (le flash n'est PAS affecté).",
} end)

L:RegisterTranslations("zhCN", function() return {
	["FlashNShake"] = "屏幕闪烁/震动",
	["Flash'N'Shake"] = "屏幕闪烁/震动",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "如有重要事件发生，屏幕将会蓝色闪烁/震动告知玩家。",

	["Flash"] = "闪烁",
	["Toggle Flash on or off."] = "启用或禁用屏幕闪烁通知。",

	["Shake"] = "震动",
	["Toggle Shake on or off."] = "启用或禁用屏幕震动通知。",

	["Test"] = "测试",
	["Perform a Flash/Shake test."] = "屏幕闪烁/震动测试。",

	flash_warning = "屏幕震动失效。通常因为标示已经开启。\n关闭标示并重置 UI 或关闭 BigWigs“震动”模块。（屏幕闪烁无效）",
} end)

L:RegisterTranslations("zhTW", function() return {
	["FlashNShake"] = "螢幕閃爍/震動",
	["Flash'N'Shake"] = "螢幕閃爍/震動",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "如有重要事件發生，螢幕將會閃爍藍光/震動告知玩家。",

	["Flash"] = "閃爍",
	["Toggle Flash on or off."] = "啟用或關閉螢幕閃爍",

	["Shake"] = "震動",
	["Toggle Shake on or off."] = "啟用或關閉螢幕閃震動",

	["Test"] = "測試",
	["Perform a Flash/Shake test."] = "測試螢幕閃爍/震動",
} end)

L:RegisterTranslations("deDE", function() return {
	["FlashNShake"] = "Aufblitzen|Beben",
	["Flash'N'Shake"] = "Aufblitzen'|'Beben",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "Läst den Bildschirm Beben und/oder Blau aufblitzen wenn etwas wichtiges passiert das dich direkt betrifft.",

	["Flash"] = "Aufblitzen",
	["Toggle Flash on or off."] = "Schaltet Aufblitzen an oder aus.",

	["Shake"] = "Beben",
	["Toggle Shake on or off."] = "Schaltet Beben an oder aus.",

	["Test"] = "Test",
	["Perform a Flash/Shake test."] = "Führe einen Aufblitzen/Beben Test durch.",

	flash_warning = "Bildschirmbeben fehlgeschlagen. Dies passiert wenn die Gesundheitsanzeige unter den Namen eingeschaltet ist.\nSchalten sie diese aus und laden sie ihr UI neu oder schalten sie BigWigs 'Beben' aus. (Aufblitzen ist nicht betroffen)",
} end)

L:RegisterTranslations("esES", function() return {
	["FlashNShake"] = "Destello/Temblor",
	["Flash'N'Shake"] = "Destello / Temblor",
	["Shake and/or Flash the screen blue when something important happens that directly affects you."] = "Hacer temblar la pantalla y/o emitir un destello cuando ocurre algo importante que te afecta.",

	["Flash"] = "Destello",
	["Toggle Flash on or off."] = "Activar / Desactivar el destello.",

	["Shake"] = "Temblor",
	["Toggle Shake on or off."] = "Activar / Desactivar el temblor.",

	["Test"] = "Probar",
	["Perform a Flash/Shake test."] = "Efectua una prueba de Destello/Temblor.",

	flash_warning = "Temblor de pantalla fallido. Suele ocurrir cuando las placas de nombre están activadas.\nDesactiva las placas de nombre y reinicia la interfaz o desactiva la función 'Temblor' de BigWigs. (la función de Destello NO se ve afectada)",
} end)
----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFlash = BigWigs:NewModule("Flash")
BigWigsFlash.revision = tonumber(string.sub("$Revision: 11446 $", 12, -3))
BigWigsFlash.defaultDB = {
	flash = true,
}
BigWigsFlash.external = true
BigWigsFlash.consoleCmd = L["FlashNShake"]
BigWigsFlash.consoleOptions = {
	type = "group",
	name = L["Flash'N'Shake"],
	desc = L["Shake and/or Flash the screen blue when something important happens that directly affects you."],
	args = {
		[L["Flash"]] = {
			type = "toggle",
			name = L["Flash"],
			desc = L["Toggle Flash on or off."],
			order = 1,
			get = function() return BigWigsFlash.db.profile.flash end,
			set = function(v)
				BigWigsFlash.db.profile.flash = v
			end,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 3,
		},
		[L["Test"]] = {
			type = "execute",
			name = L["Test"],
			desc = L["Perform a Flash/Shake test."],
			order = 4,
			handler = BigWigsFlash,
			func = "BigWigs_Test",
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsFlash:OnEnable()
	self:RegisterEvent("BigWigs_Message")
end

------------------------------
--      FLASH               --
------------------------------

local originalPoints = nil
local BWFlashAlpha = 0
local elapsed = 0
local start = 0

function flashershow()
	flasher:SetAlpha(0)
	elapsed=0
	start=GetTime()
	-- BWFlashAlpha = 1
end


function flashonupdate()
	-- if flasher:GetAlpha() <= 0 then
		-- flasher:Hide()
		-- return
	-- else
		-- flasher:SetAlpha(flasher:GetAlpha()-0.05)
	-- end
	elapsed = (GetTime()-start)
	if elapsed >= 0.8 then
		flasher:Hide()
		flasher:SetAlpha(0)
		return
	end
	local alpha = elapsed - math.floor(elapsed/0.4)*0.4
	if elapsed > 0.2 then
		alpha = 0.4 - alpha
	end
	if alpha then
		flasher:SetAlpha(alpha * 5)
	end
							-- elapsedd = elapsed
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFlash:BigWigs_Message(msg, color)
	if color and color == "Personal" then
		if self.db.profile.flash then
			if not flasher then --frame creation
				flasher = CreateFrame("Frame", "BWFlash", UIParent)
				flasher:SetFrameStrata("BACKGROUND")
				flasher:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
				flasher:SetBackdropColor(0,0,1,0.55)
				flasher:SetAllPoints( UIParent)
				flasher:SetScript("OnShow", function() flashershow() end)
				flasher:SetScript("OnUpdate", function() flashonupdate() end)
				flasher:Hide()
			end
			flasher:Show()
		end
	end
end

function BigWigsFlash:BigWigs_Test()
	self:TriggerEvent("BigWigs_Message", L["Test"], "Personal", true, "Long")
end

