------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Onyxia"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Onyxia",

	deepbreath_cmd = "deepbreath",
	deepbreath_name = "Deep Breath alert",
	deepbreath_desc = "Warn when Onyxia begins to cast Deep Breath ",

	phase2_cmd = "phase2",
	phase2_name = "Phase 2 alert",
	phase2_desc = "Warn for Phase 2",

	phase3_cmd = "phase3",
	phase3_name = "Phase 3 alert",
	phase3_desc = "Warn for Phase 3",

	onyfear_cmd = "onyfear",
	onyfear_name = "Fear",
	onyfear_bar = "Next Fear",
	onyfear_desc = "Warn for Bellowing Roar in phase 3",

	trigger1 = "%s takes in a deep breath...",
	trigger2 = "from above",
	trigger3 = "It seems you'll need another lesson",
	trigger4 = "Onyxia begins to cast Bellowing Roar.",

	warn1 = "Deep Breath incoming!",
	warn2 = "Phase 2 incoming!",
	warn3 = "Phase 3 incoming!",
	warn4 = "Fear in 3 sec!",
} end )

L:RegisterTranslations("frFR", function() return {
	deepbreath_name = "Alerte Grande inspiration",
	deepbreath_desc = "Pr\195\169viens quand Onyxia se pr\195\169pare \195\160 prendre une grande inspiration.",

	phase2_name = "Alerte Phase 2",
	phase2_desc = "Pr\195\169viens quand Onyxia passe en phase 2.",

	phase3_name = "Alerte Phase 3",
	phase3_desc = "Pr\195\169viens quand Onyxia passe en phase 3.",

	onyfear_name = "Alerte Peur",
	onyfear_bar = "Prochain Fear",
	onyfear_desc = "Pr\195\169viens quand Onyxia utilise son Rugissement puissant en phase 3.",
	
	trigger1 = "%s prend une grande inspiration%.%.%.",
	trigger2 = "Cet exercice dénué de sens m'ennuie. Je vais vous incinérer d'un seul coup !",
	trigger3 = "Il semble que vous ayez besoin d'une autre leçon, mortels !",
	trigger4 = "Onyxia commence à lancer Rugissement puissant.",

	warn1 = "Souffle imminent !",
	warn2 = "Arriv\195\169e de la phase 2 !",
	warn3 = "Arriv\195\169e de la phase 3 !",
	warn4 = "Peur de zone dans 3 sec. !",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsOnyxia = BigWigs:NewModule(boss)
BigWigsOnyxia.zonename = AceLibrary("Babble-Zone-2.2")["Onyxia's Lair"]
BigWigsOnyxia.enabletrigger = boss
BigWigsOnyxia.toggleoptions = {"deepbreath", "phase2", "phase3", "onyfear", "bosskill"}
BigWigsOnyxia.revision = tonumber(string.sub("$Revision: 16941 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsOnyxia:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsOnyxia:CHAT_MSG_MONSTER_EMOTE(msg)
	if (msg == L["trigger1"]) then
		if self.db.profile.deepbreath then self:TriggerEvent("BigWigs_Message", L["warn1"], "Important") end
	end
end

function BigWigsOnyxia:CHAT_MSG_MONSTER_YELL(msg)
	if (string.find(msg, L["trigger2"])) then
		if self.db.profile.phase2 then self:TriggerEvent("BigWigs_Message", L["warn2"], "Urgent") end
	elseif (string.find(msg, L["trigger3"])) then
		if self.db.profile.phase3 then self:TriggerEvent("BigWigs_Message", L["warn3"], "Urgent") end
		self:ScheduleEvent("BigWigs_Message", 4, L["warn4"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, L["onyfear_bar"], 7, "Interface\\Icons\\Spell_Shadow_Charm")
	end
end


function BigWigsOnyxia:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["trigger4"] and self.db.profile.onyfear then
		self:ScheduleEvent("bwronyxiainitfear", self.InitFear, 1.5, self)
	end
end

function BigWigsOnyxia:InitFear()
	self:ScheduleEvent("BigWigs_Message", 25.5, L["warn4"], "Urgent")
	self:TriggerEvent("BigWigs_StartBar", self, L["onyfear_bar"], 28.5, "Interface\\Icons\\Spell_Shadow_Charm")
end