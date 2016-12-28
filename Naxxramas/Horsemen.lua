------------------------------
--      Are you local?      --
------------------------------

local thane = AceLibrary("Babble-Boss-2.2")["Thane Korth'azz"]
local mograine = AceLibrary("Babble-Boss-2.2")["Highlord Mograine"]
local zeliek = AceLibrary("Babble-Boss-2.2")["Sir Zeliek"]
local blaumeux = AceLibrary("Babble-Boss-2.2")["Lady Blaumeux"]
local boss = AceLibrary("Babble-Boss-2.2")["The Four Horsemen"]

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local times = nil

local started = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Horsemen",

	mark_cmd = "mark",
	mark_name = "Mark Alerts",
	mark_desc = "Warn for marks",

	shieldwall_cmd  = "shieldwall",
	shieldwall_name = "Shieldwall Alerts",
	shieldwall_desc = "Warn for shieldwall",

	void_cmd = "void",
	void_name = "Void Zone Alerts",
	void_desc = "Warn on Lady Blaumeux casting Void Zone.",

	meteor_cmd = "meteor",
	meteor_name = "Meteor Alerts",
	meteor_desc = "Warn on Thane casting Meteor.",

	wrath_cmd = "wrath",
	wrath_name = "Holy Wrath Alerts",
	wrath_desc = "Warn on Zeliek casting Wrath.",

	markbar = "Mark %d",
	markwarn1 = "Mark %d!",
	markwarn2 = "Mark %d in 5 sec",
	marktrigger = "is afflicted by Mark of ",

	voidtrigger = "Lady Blaumeux casts Void Zone.",
	voidwarn = "Void Zone Incoming",
	voidbar = "Void Zone",

	meteortrigger = "Thane Korth'azz's Meteor hits ",
	meteorwarn = "Meteor!",
	meteorbar = "Meteor",

	wrathtrigger = "Sir Zeliek's Holy Wrath hits ",
	wrathwarn = "Holy Wrath!",
	wrathbar = "Holy Wrath",

	startwarn = "The Four Horsemen Engaged! Mark in ~17 sec",

	shieldwallbar = "%s - Shield Wall",
	shieldwalltrigger = "(.*) gains Shield Wall.",
	shieldwallwarn = "%s - Shield Wall for 20 sec",
	shieldwallwarn2 = "%s - Shield Wall GONE!",
} end )

L:RegisterTranslations("frFR", function() return {
	mark_name = "Mark Alerts",
	mark_desc = "Warn for marks",

	shieldwall_name = "Shieldwall Alerts",
	shieldwall_desc = "Warn for shieldwall",

	void_name = "Void Zone Alerts",
	void_desc = "Warn on Lady Blaumeux casting Void Zone.",

	meteor_name = "Meteor Alerts",
	meteor_desc = "Warn on Thane casting Meteor.",

	wrath_name = "Holy Wrath Alerts",
	wrath_desc = "Warn on Zeliek casting Wrath.",

	markbar = "Marque %d",
	markwarn1 = "Marque %d!",
	markwarn2 = "Marque %d dans 5 sec",
	marktrigger = "subit les effets de Marque de",

	voidtrigger = "Dame Blaumeux lance Zone de vide.",
	voidwarn = "Zone de Vide imminente!",
	voidbar = "Zone de Vide",

	meteortrigger = "Thane Korth'azz lance Météore sur ",
	meteorwarn = "Météore!",
	meteorbar = "Météore",

	wrathtrigger = "Sire Zeliek lance Colère divine sur ",
	wrathwarn = "Colère Divine!",
	wrathbar = "Colère Divine",

	startwarn = "Les Quatre Cavaliers Engagés! Marque dans ~17 sec",

	shieldwallbar = "%s - Mur Protecteur",
	shieldwalltrigger = "(.*) gagne Mur protecteur.",
	shieldwallwarn = "%s - Mur Protecteur pendant 20 sec",
	shieldwallwarn2 = "%s - Mur Protecteur FINI!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsHorsemen = BigWigs:NewModule(boss)
BigWigsHorsemen.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsHorsemen.enabletrigger = { thane, mograine, zeliek, blaumeux }
BigWigsHorsemen.toggleoptions = {"mark", "shieldwall", -1, "meteor", "void", "wrath", "bosskill"}
BigWigsHorsemen.revision = tonumber(string.sub("$Revision: 16494 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsHorsemen:OnEnable()
	self.marks = 1
	self.deaths = 0

	times = {}
	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "SkillEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "SkillEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "MarkEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "MarkEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenShieldWall", 3)
	-- Upgraded to HorsemenMark2 so that we don't get blocked by throttled syncs
	-- from older revisions.
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenMark2", 8)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenVoid", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenWrath", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "HorsemenMeteor", 5)
end

function BigWigsHorsemen:MarkEvent( msg )
	if string.find(msg, L["marktrigger"]) then
		local t = GetTime()
		if not times["mark"] or (times["mark"] and (times["mark"] + 8) < t) then
			self:TriggerEvent("BigWigs_SendSync", "HorsemenMark2 "..tostring(self.marks + 1))
			times["mark"] = t
		end
	end
end

function BigWigsHorsemen:SkillEvent( msg )
	local t = GetTime()
	if string.find(msg, L["meteortrigger"]) then
		if not times["meteor"] or (times["meteor"] and (times["meteor"] + 8) < t) then
			self:TriggerEvent("BigWigs_SendSync", "HorsemenMeteor")
			times["meteor"] = t
		end
	elseif string.find(msg, L["wrathtrigger"]) then
		if not times["wrath"] or (times["wrath"] and (times["wrath"] + 8) < t) then
			self:TriggerEvent("BigWigs_SendSync", "HorsemenWrath")
			times["wrath"] = t
		end
	elseif msg == L["voidtrigger"] then
		if not times["void"] or (times["void"] and (times["void"] + 8) < t) then
			self:TriggerEvent("BigWigs_SendSync", "HorsemenVoid" )
			times["void"] = t
		end
	end
end

function BigWigsHorsemen:CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE(msg)
	if string.find(msg, L["voidbar"]) then
		self:TriggerEvent("BigWigs_Message", "Zone de Vide sur VOUS!", "Personal", true, "Long")
	end
end

function BigWigsHorsemen:BigWigs_RecvSync(sync, rest)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.mark then
			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, L["meteorbar"], 21, "Interface\\Icons\\Spell_Fire_Fireball02")
			self:TriggerEvent("BigWigs_StartBar", self, L["wrathbar"], 12, "Interface\\Icons\\Spell_Holy_Excorcism")
			self:TriggerEvent("BigWigs_StartBar", self, L["voidbar"], 45, "Interface\\Icons\\Spell_Shadow_GatherShadows")
			self:TriggerEvent("BigWigs_StartBar", self, string.format( L["markbar"], self.marks), 17, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde")
			self:ScheduleEvent("bwhorsemenmark2", "BigWigs_Message", 12, string.format( L["markwarn2"], self.marks ), "Urgent")
		end
	elseif sync == "HorsemenMark2" and rest then
		rest = tonumber(rest)
		if rest == nil then return end
		if rest == (self.marks + 1) then
			if self.db.profile.mark then
				self:TriggerEvent("BigWigs_Message", string.format( L["markwarn1"], self.marks ), "Important")
			end
			self.marks = self.marks + 1
			if self.db.profile.mark then 
				self:TriggerEvent("BigWigs_StartBar", self, string.format( L["markbar"], self.marks ), 12, "Interface\\Icons\\Spell_Shadow_CurseOfAchimonde")
				self:ScheduleEvent("bwhorsemenmark2", "BigWigs_Message", 7, string.format( L["markwarn2"], self.marks ), "Urgent")
			end
		end
	elseif sync == "HorsemenMeteor" then
		if self.db.profile.meteor then
			self:TriggerEvent("BigWigs_Message", L["meteorwarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["meteorbar"], 12, "Interface\\Icons\\Spell_Fire_Fireball02")
		end
	elseif sync == "HorsemenWrath" then
		if self.db.profile.wrath then
			self:TriggerEvent("BigWigs_Message", L["wrathwarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["wrathbar"], 12, "Interface\\Icons\\Spell_Holy_Excorcism")
		end
	elseif sync == "HorsemenVoid" then
		if self.db.profile.void then
			self:TriggerEvent("BigWigs_Message", L["voidwarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["voidbar"], 12, "Interface\\Icons\\Spell_Shadow_GatherShadows")
		end
	elseif sync == "HorsemenShieldWall" and self.db.profile.shieldwall and rest then
		self:TriggerEvent("BigWigs_Message", string.format(L["shieldwallwarn"], rest), "Attention")
		self:ScheduleEvent("BigWigs_Message", 20, string.format(L["shieldwallwarn2"], rest), "Positive")
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["shieldwallbar"], rest), 20, "Interface\\Icons\\Ability_Warrior_ShieldWall")
	end
end

function BigWigsHorsemen:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	local _,_, mob = string.find(msg, L["shieldwalltrigger"])
	if mob then self:TriggerEvent("BigWigs_SendSync", "HorsemenShieldWall "..mob) end
end

function BigWigsHorsemen:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF(msg)
	if msg == L["voidtrigger"] then
		self:TriggerEvent("BigWigs_SendSync", "HorsemenVoid" )
	end	
end

function BigWigsHorsemen:CHAT_MSG_COMBAT_HOSTILE_DEATH( msg )
	if msg == string.format(UNITDIESOTHER, thane ) or
		msg == string.format(UNITDIESOTHER, zeliek) or 
		msg == string.format(UNITDIESOTHER, mograine) or
		msg == string.format(UNITDIESOTHER, blaumeux) then
		self.deaths = self.deaths + 1
		if self.deaths == 4 then
			if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(AceLibrary("AceLocale-2.2"):new("BigWigs")["%s have been defeated"], boss), "Bosskill", nil, "Victory") end
			self.core:ToggleModuleActive(self, false)
		end
	end
end

