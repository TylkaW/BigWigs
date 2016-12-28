------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Azuregos"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Azuregos",

	teleport_cmd = "teleport",
	teleport_name = "Teleport Alert",
	teleport_desc = "Warn for teleport",

	shield_cmd = "shield",
	shield_name = "Shield Alert",
	shield_desc = "Warn for shield",

	trigger1 = "Come, little ones",
	trigger2 = "^Reflection fades from Azuregos",
	trigger3 = "^Azuregos gains Reflection",

	warn1 = "Teleport!",
	warn2 = "Magic Shield down!",
	warn3 = "Magic Shield UP!",

	shieldbar = "Magic Shield",
} end )

L:RegisterTranslations("frFR", function() return {
	teleport_name = "Alerte T\195\169l\195\169portation",
	teleport_desc = "Pr\195\169viens quans Azuregos t\195\169l\195\169porte quelqu'un.",

	shield_name = "Alerte Bouclier",
	shield_desc = "Pr\195\169viens quand Azuregos est prot\195\169g\195\169 par un bouclier magique.",

	trigger1 = "mes petits",
	trigger2 = "^Renvoi sur Azuregos vient de se dissiper.",
	trigger3 = "^Azuregos gagne Renvoi.",

	warn1 = "T\195\169l\195\169portation !",
	warn2 = "Bouclier magique dissip\195\169 !",
	warn3 = "Bouclier magique en place !",

	shieldbar = "Bouclier magique",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsAzuregos = BigWigs:NewModule(boss)
BigWigsAzuregos.zonename = { AceLibrary("AceLocale-2.2"):new("BigWigs")["Outdoor Raid Bosses Zone"], AceLibrary("Babble-Zone-2.2")["Azshara"] }
BigWigsAzuregos.enabletrigger = boss
BigWigsAzuregos.toggleoptions = {"teleport", "shield", "bosskill"}
BigWigsAzuregos.revision = tonumber(string.sub("$Revision: 17179 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsAzuregos:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

function BigWigsAzuregos:CHAT_MSG_MONSTER_YELL( msg )
	if self.db.profile.teleport and string.find(msg, L["trigger1"]) then
		self:TriggerEvent("BigWigs_Message", L["warn1"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, "Prochaine Téléportation", 30, "Interface\\Icons\\Spell_Arcane_PortalIronforge")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_AURA_GONE_OTHER( msg )
	if self.db.profile.shield and string.find(msg, L["trigger2"]) then
		self:TriggerEvent("BigWigs_Message", L["warn2"], "Attention")
	end
end

function BigWigsAzuregos:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if self.db.profile.shield and string.find(arg1, L["trigger3"]) then
		self:TriggerEvent("BigWigs_Message", L["warn3"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, L["shieldbar"], 10, "Interface\\Icons\\Spell_Frost_FrostShock")
	end
end
