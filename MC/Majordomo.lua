------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Majordomo Executus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	disabletrigger = "Impossible! Stay your attack, mortals... I submit! I submit!",

	trigger1 = "gains Magic Reflection",
	trigger2 = "gains Damage Shield",
	trigger3 = "Magic Reflection fades",
	trigger4 = "Damage Shield fades",

	warn1 = "Magic Reflection for 10 seconds!",
	warn2 = "Damage Shield for 10 seconds!",
	warn3 = "5 seconds until powers!",
	warn4 = "Magic Reflection down!",
	warn5 = "Damage Shield down!",
	bosskill = "Majordomo Executus has been defeated!",

	bar1text = "Magic Reflection",
	bar2text = "Damage Shield",
	bar3text = "New powers",

	cmd = "Majordomo",
	
	magic_cmd = "magic",
	magic_name = "Magic Reflection alert",
	magic_desc = "Warn for Magic Reflection",
	
	dmg_cmd = "dmg",
	dmg_name = "Damage Shields alert",
	dmg_desc = "Warn for Damage Shields",
} end)

L:RegisterTranslations("frFR", function() return {
	disabletrigger = "Impossible ! Retenez vos coups, mortels ! Je me rends ! Je me rends",
	trigger1 = "gagne Renvoi de la magie",
	trigger2 = "gagne Bouclier de dégâts",
	trigger3 = "Renvoi de la magie sur (.+) Attise%-flammes vient de se dissiper",
	trigger4 = "Bouclier de d\195\169g\195\162ts sur (.+) Attise%-flammes vient de se dissiper",

	warn1 = "Bouclier sorts pendant 10 secondes !",
	warn2 = "Bouclier d\195\169g\195\162ts pendant 10 secondes !",
	warn3 = "5 secondes avant le bouclier !",
	warn4 = "Bouclier sorts termin\195\169 !",
	warn5 = "Bouclier d\195\169g\195\162ts termin\195\169 !",
	bosskill = "Chambellant Executus a \195\169t\195\169 vaincu !",

	bar1text = "Renvoi de la magie",
	bar2text = "Bouclier de d\195\169g\195\162ts",
	bar3text = "Nouveau Bouclier",

	magic_name = "Alerte Bouclier de Sorts",
	magic_desc = "Pr\195\169viens des boucliers de sorts.",

	dmg_name = "Alerte Bouclier de D\195\169g\195\162ts",
	dmg_desc = "Pr\195\169viens des boucliers de d\195\169g\195\162ts.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsMajordomo = BigWigs:NewModule(boss)
BigWigsMajordomo.zonename = AceLibrary("Babble-Zone-2.2")["Molten Core"]
BigWigsMajordomo.enabletrigger = boss
BigWigsMajordomo.toggleoptions = {"magic", "dmg", "bosskill"}
BigWigsMajordomo.revision = tonumber(string.sub("$Revision: 16639 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsMajordomo:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MajordomoAuraGainMagic", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MajordomoAuraGainDmg", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "MajordomoAuraFadeMagic", 8)
	self:TriggerEvent("BigWigs_ThrottleSync", "MajordomoAuraFadeDmg", 8)
end

function BigWigsMajordomo:VerifyEnable(unit)
	return UnitCanAttack("player", unit)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsMajordomo:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L["disabletrigger"]) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s has been defeated"], self:ToString()), "Bosskill", nil, "Victory") end
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsMajordomo:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS(msg)
	if string.find(msg, L["trigger1"]) then
		self:TriggerEvent("BigWigs_SendSync", "MajordomoAuraGainMagic")
	elseif string.find(msg, L["trigger2"]) then
		self:TriggerEvent("BigWigs_SendSync", "MajordomoAuraGainDmg")
	end
end

function BigWigsMajordomo:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if string.find(msg, L["trigger3"]) then
		self:TriggerEvent("BigWigs_SendSync", "MajordomoAuraFadeMagic")
	elseif string.find(msg, L["trigger4"]) then
		self:TriggerEvent("BigWigs_SendSync", "MajordomoAuraFadeDmg")
	end
end

function BigWigsMajordomo:BigWigs_RecvSync(sync)
	if (sync == "MajordomoAuraFadeMagic" and self.db.profile.magic) then
		self:TriggerEvent("BigWigs_Message", L["warn4"], "Attention")
	elseif (sync == "MajordomoAuraFadeDmg" and self.db.profile.dmg) then
		self:TriggerEvent("BigWigs_Message", L["warn5"], "Attention")
	elseif (sync == "MajordomoAuraGainMagic" and self.db.profile.magic) then
		self:TriggerEvent("BigWigs_Message", L["warn1"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar3text"], 15, "Interface\\Icons\\Spell_Frost_Wisp")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar1text"], 10, "Interface\\Icons\\Spell_Frost_FrostShock")
		self:ScheduleEvent("BigWigs_Message", 25, L["warn3"], "Urgent")
	elseif (sync == "MajordomoAuraGainDmg" and self.db.profile.dmg) then
		self:TriggerEvent("BigWigs_Message", L["warn2"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar3text"], 15, "Interface\\Icons\\Spell_Frost_Wisp")
		self:TriggerEvent("BigWigs_StartBar", self, L["bar2text"], 10, "Interface\\Icons\\Spell_Shadow_AntiShadow")
		self:ScheduleEvent("BigWigs_Message", 25, L["warn3"], "Urgent")
	end
end