------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Firemaw"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Firemaw begins to cast Wing Buffet",
	shadowflame_trigger = "Firemaw begins to cast Shadow Flame.",

	wingbuffet_message = "Wing Buffet! 30sec to next!",
	wingbuffet_warning = "3sec to Wing Buffet!",
	shadowflame_warning = "Shadow Flame Incoming!",

	wingbuffet_bar = "Wing Buffet",

	cmd = "Firemaw",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn for Wing Buffet",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",
} end)

L:RegisterTranslations("deDE", function() return {
	wingbuffet_trigger = "Feuerschwinge beginnt Fl\195\188gelsto\195\159 zu wirken.",
	shadowflame_trigger = "Feuerschwinge beginnt Schattenflamme zu wirken.",

	wingbuffet_message = "Fl\195\188gelsto\195\159! N\195\164chster in 30 Sekunden!",
	wingbuffet_warning = "Fl\195\188gelsto\195\159 in 3 Sekunden!",
	shadowflame_warning = "Schattenflamme!",

	wingbuffet_bar = "Fl\195\188gelsto\195\159",

	wingbuffet_name = "Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Feuerschwinge Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_name = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Feuerschwinge Schattenflamme wirkt.",
} end)

L:RegisterTranslations("frFR", function() return {
	wingbuffet_trigger = "Gueule-de-feu commence \195\160 lancer Frappe des ailes.",
	shadowflame_trigger = "Gueule-de-feu commence \195\160 lancer Flamme d'ombre.",

	wingbuffet_message = "Frappe des ailes ! 30 sec. avant la prochaine !",
	wingbuffet_warning = "3 sec. avant la Frappe des ailes !",
	shadowflame_warning = "Flamme d'ombre imminente !",

	wingbuffet_bar = "Frappe des ailes",

	wingbuffet_name = "Alerte Frappe des ailes",
	wingbuffet_desc = "Pr\195\169viens quand Gueule-de-feu effectue sa Frappe des ailes.",

	shadowflame_name = "Alerte Flamme d'ombre",
	shadowflame_desc = "Pr\195\169viens quand l'incantation de la Flamme d'ombre est imminente.",
} end)


----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsFiremaw = BigWigs:NewModule(boss)
BigWigsFiremaw.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsFiremaw.enabletrigger = boss
BigWigsFiremaw.toggleoptions = {"wingbuffet", "shadowflame", "bosskill"}
BigWigsFiremaw.revision = tonumber(string.sub("$Revision: 16639 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsFiremaw:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "FiremawWingBuffet2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "FiremawShadowflame", 10)
	
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsFiremaw:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if string.find(msg, L["wingbuffet_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "FiremawWingBuffet2")
	elseif msg == L["shadowflame_trigger"] then 
		self:TriggerEvent("BigWigs_SendSync", "FiremawShadowflame")
	end
end

function BigWigsFiremaw:CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE(msg)
	local _, _, stacks = string.find(msg, "Vous subissez les effets de Rafale de flammes %((%d+)%).");
	if stacks then
		stacks = tonumber(stacks)
		if stacks >= 8 then
			self:TriggerEvent("BigWigs_Message", string.format("VOUS AVEZ %d STACKS !",stacks), "Personal", true, "Long")
			if UnitHealthMax("player") < 7000 then
				SendChatMessage(string.format("J'ai %d stacks je suis un débile !",stacks), "SAY")
			end
		elseif stacks >= 6 then
			self:TriggerEvent("BigWigs_Message", string.format("vous avez %d stacks !",stacks), "Personal", true, "Long")
		end
	end
end

function BigWigsFiremaw:BigWigs_RecvSync(sync, rest, nick)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		self:ScheduleEvent("BigWigs_Message", 27, L["wingbuffet_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 30, "Interface\\Icons\\inv_misc_monsterscales_14")
	elseif sync == "FiremawWingBuffet2" and self.db.profile.wingbuffet then
		self:TriggerEvent("BigWigs_Message", L["wingbuffet_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 27, L["wingbuffet_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 30, "Interface\\Icons\\inv_misc_monsterscales_14")
	elseif sync == "FiremawShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Important")
	end
end