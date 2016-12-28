------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Flamegor"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started
local _, class = UnitClass("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Flamegor begins to cast Wing Buffet",
	shadowflame_trigger = "Flamegor begins to cast Shadow Flame.",
	frenzy_trigger = "%s goes into a frenzy!",

	wingbuffet_message = "Wing Buffet! 30sec to next!",
	wingbuffet_warning = "3sec to Wing Buffet!",
	shadowflame_warning = "Shadow Flame incoming!",
	frenzy_message = "Frenzy - Tranq Shot!",

	wingbuffet_bar = "Wing Buffet",

	cmd = "Flamegor",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn for Wing Buffet",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy alert",
	frenzy_desc = "Warn when for frenzy",
} end)

L:RegisterTranslations("deDE", function() return {
	wingbuffet_trigger = "Flammenmaul beginnt Fl\195\188gelsto\195\159 zu wirken.",
	shadowflame_trigger = "Flammenmaul beginnt Schattenflamme zu wirken.",
	frenzy_trigger = "%s ger\195\164t in Raserei!",

	wingbuffet_message = "Fl\195\188gelsto\195\159! N\195\164chster in 30 Sekunden!",
	wingbuffet_warning = "Fl\195\188gelsto\195\159 in 3 Sekunden!",
	shadowflame_warning = "Schattenflamme!",
	frenzy_message = "Raserei - Einlullender Schuss!",

	wingbuffet_bar = "Fl\195\188gelsto\195\159",

	wingbuffet_name = "Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Flammenmaul Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_name = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Flammenmaul Schattenflamme wirkt.",

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Flammenmaul in Raserei ger\195\164t.",
} end)

L:RegisterTranslations("frFR", function() return {
	wingbuffet_trigger = "Flamegor commence \195\160 lancer Frappe des ailes.",
	shadowflame_trigger = "Flamegor commence \195\160 lancer Flamme d'ombre.",
	frenzy_trigger = "est pris de frénésie !",

	wingbuffet_message = "Frappe des ailes ! 30 sec. avant la prochaine !",
	wingbuffet_warning = "3 sec. avant la Frappe des ailes !",
	shadowflame_warning = "Flamme d'ombre imminente !",
	frenzy_message = "Fr\195\169n\195\169sie - Tir tranquillisant !",

	wingbuffet_bar = "Frappe des ailes",

	wingbuffet_name = "Alerte Frappe des ailes",
	wingbuffet_desc = "Pr\195\169viens quand Flamegor effectue sa Frappe des ailes.",

	shadowflame_name = "Alerte Flamme d'ombre",
	shadowflame_desc = "Pr\195\169viens quand l'incantation de la Flamme d'ombre est imminente.",

	frenzy_name = "Alerte Fr\195\169n\195\169sie",
	frenzy_desc = "Pr\195\169viens quand Flamegor est pris de fr\195\169n\195\169sie.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFlamegor = BigWigs:NewModule(boss)
BigWigsFlamegor.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsFlamegor.enabletrigger = boss
BigWigsFlamegor.toggleoptions = {"wingbuffet", "shadowflame", "frenzy", "bosskill"}
BigWigsFlamegor.revision = tonumber(string.sub("$Revision: 16639 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFlamegor:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorWingBuffet2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "FlamegorShadowflame", 10)
	
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFlamegor:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["wingbuffet_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorWingBuffet2")
	elseif msg == L["shadowflame_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "FlamegorShadowflame")
	end
end

function BigWigsFlamegor:BigWigs_RecvSync(sync)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		self:ScheduleEvent("BigWigs_Message", 27, L["wingbuffet_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 30, "Interface\\Icons\\inv_misc_monsterscales_14")
	elseif sync == "FlamegorWingBuffet2" and self.db.profile.wingbuffet then
		self:TriggerEvent("BigWigs_Message", L["wingbuffet_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 27, L["wingbuffet_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 30, "Interface\\Icons\\inv_misc_monsterscales_14")
	elseif sync == "FlamegorShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, "Prochaine Flamme d'ombre", 16, "Interface\\Icons\\spell_fire_incinerate")
	end
end

function BigWigsFlamegor:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L["frenzy_trigger"] and self.db.profile.frenzy then
		if class == "HUNTER" then
			self:TriggerEvent("BigWigs_Message", L["frenzy_message"], "Personal", true, "Long")
		else
			self:TriggerEvent("BigWigs_Message", L["frenzy_message"], "Important")
		end
		self:TriggerEvent("BigWigs_StartBar", self, "Prochaine frénésie", 10, "Interface\\Icons\\ability_druid_challangingroar")
	end
end
