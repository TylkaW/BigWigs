------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Prophet Skeram"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	aetrigger = "The Prophet Skeram begins to cast Arcane Explosion.",
	mctrigger = "The Prophet Skeram begins to cast True Fulfillment.",
	splittrigger = "The Prophet Skeram casts Summon Images.",
	aewarn = "Casting Arcane Explosion!",
	mcwarn = "Casting Mind Control!",
	mcplayer = "^([^%s]+) ([^%s]+) afflicted by True Fulfillment.$",
	mcplayerwarn = "%s is mindcontrolled!",
	mcbar = "MC: %s",
	mcyou = "You",
	mcare = "are",
	
	splitwarn = "Splitting!",

	cmd = "Skeram",
	mc_cmd = "mc",
	mc_name = "Mind Control Alert",
	mc_desc = "Warn for Mind Control",

	ae_cmd = "ae",
	ae_name = "Arcane Explosion Alert",
	ae_desc = "Warn for Arcane Explosion",
	
--	split_cmd = "split",
--	split_name = "Split Alert",
--	split_desc = "Warn before Create Image",
} end )

L:RegisterTranslations("frFR", function() return {
	aetrigger = "Le Proph\195\168te Skeram commence \195\160 lancer Explosion des arcanes.",
	mctrigger = "Le Proph\195\168te Skeram commence \195\160 lancer Accomplissement v\195\169ritable.",
	splittrigger = "Le Proph\195\168te Skeram lance Invocation des Images.",
	aewarn = "Incantation d'Explosion des arcanes !",
	mcwarn = "Incantation de Controle Mental !",
	mcplayer = "([^%s]+) ([^%s]+) les effets de Accomplissement v\195\169ritable%.",
	mcplayerwarn = "%s est sous controle mental !",
	mcbar = "CM: %s",
	mcyou = "Vous",
	mcare = "subissez",
	
	splitwarn = "D\195\169multiplication !",

	mc_name = "Alerte Contr\195\180le mental",
	mc_desc = "Pr\195\169viens en cas de contr\195\180le mental.",

	ae_name = "Alerte Explosion des arcanes",
	ae_desc = "Pr\195\169viens lorsque Skeram lance Explosion des arcanes.",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsSkeram = BigWigs:NewModule(boss)
BigWigsSkeram.zonename = AceLibrary("Babble-Zone-2.2")["Ahn'Qiraj"]
BigWigsSkeram.enabletrigger = boss
BigWigsSkeram.toggleoptions = {"ae", "mc", "bosskill"}
BigWigsSkeram.revision = tonumber(string.sub("$Revision: 16639 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsSkeram:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "MindCrontrol")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "MindCrontrol")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
end

------------------------------
--      Event Handlers      --
------------------------------

-- Note that we do not sync the MC at the moment, since you really only care
-- about people that are MC'ed close to you anyway.
function BigWigsSkeram:MindCrontrol(msg)
	local _,_, player, type = string.find(msg, L["mcplayer"])
	if player and type then
		if player == L["mcyou"] and type == L["mcare"] then
			player = UnitName("player")
		end
		if self.db.profile.mc then
			self:TriggerEvent("BigWigs_Message", string.format(L["mcplayerwarn"], player), "Important")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["mcbar"], player), 20, "Interface\\Icons\\Spell_Shadow_ShadowWordDominate")
		end
	end
end

function BigWigsSkeram:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == "Tremblez mortels ! L'âge des ténèbres arrive.") then
		self:TriggerEvent("BigWigs_StartBar", self, "Prochaine Explosion des arcanes", 10, "Interface\\Icons\\Spell_Nature_WispSplode")
	end
end

function BigWigsSkeram:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg == L["aetrigger"] and self.db.profile.ae then
		self:TriggerEvent("BigWigs_Message", L["aewarn"], "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, "Prochaine Explosion des arcanes", 10, "Interface\\Icons\\Spell_Nature_WispSplode")
	elseif msg == L["mctrigger"] and self.db.profile.mc then
		self:TriggerEvent("BigWigs_Message", L["mcwarn"], "Urgent")
	elseif msg == L["splittrigger"] and self.db.profile.split then
		self:TriggerEvent("BigWigs_Message", L["splitwarn"], "Important")
	end
end

