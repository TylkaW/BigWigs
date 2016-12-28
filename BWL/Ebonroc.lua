------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Ebonroc"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	wingbuffet_trigger = "Ebonroc begins to cast Wing Buffet",
	shadowflame_trigger = "Ebonroc begins to cast Shadow Flame.",
	shadowcurse_trigger = "^([^%s]+) ([^%s]+) afflicted by Shadow of Ebonroc",

	you = "You",
	are = "are",

	wingbuffet_message = "Wing Buffet! 30sec to next!",
	wingbuffet_warning = "3sec to Wing Buffet!",
	shadowflame_warning = "Shadow Flame incoming!",
	shadowflame_message_you = "You have Shadow of Ebonroc!",
	shadowflame_message_other = " has Shadow of Ebonroc!",

	wingbuffet_bar = "Wing Buffet",
	shadowcurse_bar = "%s - Shadow of Ebonroc",

	cmd = "Ebonroc",

	wingbuffet_cmd = "wingbuffet",
	wingbuffet_name = "Wing Buffet alert",
	wingbuffet_desc = "Warn for Wing Buffet",

	shadowflame_cmd = "shadowflame",
	shadowflame_name = "Shadow Flame alert",
	shadowflame_desc = "Warn for Shadow Flame",

	youcurse_cmd = "youcurse",
	youcurse_name = "Shadow of Ebonroc on you alert",
	youcurse_desc = "Warn when you got Shadow of Ebonroc",

	elsecurse_cmd = "elsecurse",
	elsecurse_name = "Shadow of Ebonroc on others alert",
	elsecurse_desc = "Warn when others got Shadow of Ebonroc",

	shadowbar_cmd = "cursebar",
	shadowbar_name = "Shadow of Ebonroc timer bar",
	shadowbar_desc = "Shows a timer bar when someone gets Shadow of Ebonroc",
} end)

L:RegisterTranslations("deDE", function() return {
	wingbuffet_trigger = "Schattenschwinge beginnt Fl\195\188gelsto\195\159 zu wirken.",
	shadowflame_trigger = "Schattenschwinge beginnt Schattenflamme zu wirken.",
	shadowcurse_trigger = "^([^%s]+) (%w+) von Schattenschwinges Schatten betroffen.",

	you = "Ihr",
	are = "seid",

	wingbuffet_message = "Fl\195\188gelsto\195\159!",
	wingbuffet_warning = "Fl\195\188gelsto\195\159 in 3 Sekunden!",
	shadowflame_warning = "Schattenflamme!",
	shadowflame_message_you = "Du hast Schattenschwinges Schatten!",
	shadowflame_message_other = " hat Schattenschwinges Schatten!",

	wingbuffet_bar = "Fl\195\188gelsto\195\159! N\195\164chster in 30 Sekunden!",
	shadowcurse_bar = "%s - Schattenschwinges Schatten",

	wingbuffet_name = "Fl\195\188gelsto\195\159",
	wingbuffet_desc = "Warnung, wenn Schattenschwinge Fl\195\188gelsto\195\159 wirkt.",

	shadowflame_name = "Schattenflamme",
	shadowflame_desc = "Warnung, wenn Schattenschwinge Schattenflamme wirkt.",

	youcurse_name = "Schatten auf Dir",
	youcurse_desc = "Warnung, wenn Du Schattenschwinges Schatten hast.",

	elsecurse_name = "Schatten auf Anderen",
	elsecurse_desc = "Warnung, wenn andere Spieler Schattenschwinges Schatten haben.",

	shadowbar_name = "Schattenschwinges Schatten",
	shadowbar_desc = "Zeigt einen Anzeigebalken wenn jemand Schattenschwinges Schatten hat.",
} end)

L:RegisterTranslations("frFR", function() return {
	wingbuffet_trigger = "Roch\195\169b\195\168ne commence \195\160 lancer Frappe des ailes.",
	shadowflame_trigger = "Roch\195\169b\195\168ne commence \195\160 lancer Flamme d'ombre.",
	shadowcurse_trigger = "^([^%s]+) ([^%s]+) les effets de Ombre de Roch\195\169b\195\168ne.",

	you = "Vous",
	are = "subissez",

	wingbuffet_message = "Frappe des ailes ! 30 sec. avant la prochaine !",
	wingbuffet_warning = "3 sec. avant la Frappe des ailes !",
	shadowflame_warning = "Flamme d'ombre imminente !",
	shadowflame_message_you = "Vous avez l'Ombre de Roch\195\169b\195\168ne !",
	shadowflame_message_other = " a l'Ombre de Roch\195\169b\195\168ne !",

	wingbuffet_bar = "Frappe des ailes",
	shadowcurse_bar = "%s - Ombre de Roch\195\169b\195\168ne",

	wingbuffet_name = "Alerte Frappe des ailes",
	wingbuffet_desc = "Pr\195\169viens quand Roch\195\169b\195\168ne effectue sa Frappe des ailes.",

	shadowflame_name = "Alerte Flamme d'ombre",
	shadowflame_desc = "Pr\195\169viens quand l'incantation de la Flamme d'ombre est imminente.",

	youcurse_name = "Alerte Ombre de Roch\195\169b\195\168ne sur vous",
	youcurse_desc = "Pr\195\169viens quand vous subissez l'Ombre de Roch\195\169b\195\168ne.",

	elsecurse_name = "Alerte Ombre de Roch\195\169b\195\168ne sur les autres",
	elsecurse_desc = "Pr\195\169viens quand les autres subissent l'Ombre de Roch\195\169b\195\168ne.",

	shadowbar_name = "Barre Ombre de Roch\195\169b\195\168ne",
	shadowbar_desc = "Affiche une barre temporelle quand quelqu'un subit l'Ombre de Roch\195\169b\195\168ne.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsEbonroc = BigWigs:NewModule(boss)
BigWigsEbonroc.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsEbonroc.enabletrigger = boss
BigWigsEbonroc.toggleoptions = { "youcurse", "elsecurse", "shadowbar", -1, "wingbuffet", "shadowflame", -1, "bosskill" }
BigWigsEbonroc.revision = tonumber(string.sub("$Revision: 16639 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsEbonroc:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "EbonrocWingBuffet2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "EbonrocShadowflame", 10)
	
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsEbonroc:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["shadowflame_trigger"] then
		self:TriggerEvent("BigWigs_SendSync", "EbonrocShadowflame")
	elseif string.find(msg, L["wingbuffet_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "EbonrocWingBuffet2")
	end
end

function BigWigsEbonroc:BigWigs_RecvSync(sync, rest, nick)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		self:ScheduleEvent("BigWigs_Message", 27, L["wingbuffet_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 30, "Interface\\Icons\\inv_misc_monsterscales_14")
	elseif sync == "EbonrocWingBuffet2" and self.db.profile.wingbuffet then
		self:TriggerEvent("BigWigs_Message", L["wingbuffet_message"], "Important")
		self:ScheduleEvent("BigWigs_Message", 27, L["wingbuffet_warning"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["wingbuffet_bar"], 30, "Interface\\Icons\\inv_misc_monsterscales_14")
	elseif sync == "EbonrocShadowflame" and self.db.profile.shadowflame then
		self:TriggerEvent("BigWigs_Message", L["shadowflame_warning"], "Important")
	end
end

function BigWigsEbonroc:Event(msg)
	local _,_, EPlayer, EType = string.find(msg, L["shadowcurse_trigger"])
	if (EPlayer and EType) then
		if (EPlayer == L["you"] and EType == L["are"] and self.db.profile.youcurse) then
			self:TriggerEvent("BigWigs_Message", L["shadowflame_message_you"], "Personal", true, "Long")
			self:TriggerEvent("BigWigs_Message", UnitName("player") ..  L["shadowflame_message_other"], "Attention", nil, nil, true )
		elseif (self.db.profile.elsecurse) then
			self:TriggerEvent("BigWigs_Message", EPlayer .. L["shadowflame_message_other"], "Attention")
			self:TriggerEvent("BigWigs_SendTell", EPlayer, L["shadowflame_message_you"])
		end
		if self.db.profile.shadowbar then
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["shadowcurse_bar"], EPlayer), 8, "Interface\\Icons\\Spell_Shadow_GatherShadows")
		end
	end
end

