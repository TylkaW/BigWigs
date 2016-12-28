------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Loatheb"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local _,Class = UnitClass("player")

local ordre = {}
ordre[1] = 6;
ordre[2] = 5;
ordre[3] = 2;
ordre[4] = 3;
ordre[5] = 4;

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Loatheb",

	doom_cmd = "doom",
	doom_name = "Inevitable Doom Alert",
	doom_desc = "Warn for Inevitable Doom",

	spore_cmd = "spore",
	spore_name = "Spore Spawning Alert",
	spore_desc = "Warn when a spore spawns",

	curse_cmd = "curse",
	curse_name = "Remove Curse Alert",
	curse_desc = "Warn when curses are removed from Loatheb",
	
	flash_cmd = "flash",
	flash_name = "Flash",
	flash_desc = "Fait un flash quand c'est à votre tour de heal.",

	doombar = "Inevitable Doom %d",
	doomwarn = "Inevitable Doom %d! %d sec to next!",
	doomwarn5sec = "Inevitable Doom %d in 5 sec!",
	doomtrigger = "afflicted by Inevitable Doom.",

	sporewarn = "Spore groupe %d !",
	sporebar = "Invocation Spore groupe %d",
	sporespawntrigger = "Loatheb casts Summon Spore.",

	removecursewarn = "Curses removed on Loatheb",
	removecursebar = "Remove Curse",
	removecursetrigger = "Loatheb casts Remove Curse on Loatheb.",

	doomtimerbar = "Doom every 15sec",
	doomtimerwarn = "Doom timerchange in %s sec!",
	doomtimerwarnnow = "Inevitable Doom now happens every 15sec!",

	startwarn = "Loatheb engaged, 2 minutes to Inevitable Doom!",

	you = "You",
	are = "are",
} end )

L:RegisterTranslations("frFR", function() return {
	cmd = "Horreb",
	startwarn = "Horreb engagé, Malédiction inévitable dans 2 minutes!",
	
	doombar = "Malédiction inévitable %d",
	doomwarn = "Malédiction inévitable %d! suivante dans %d sec!",
	doomwarn5sec = "Malédiction inévitable %d dans 5 sec!",
	
	doomtimerbar = "Malédiction toutes les 15sec",
	doomtimerwarn = "Malédiction plus rapide dans %s sec!",
	doomtimerwarnnow = "Malédiction inévitable arrive toutes les 15sec!",
	
	removecursewarn = "Malédictions dissipées sur Horreb",
	removecursebar = "prochain Decurse",

	doomtrigger = "les effets de Mal\195\169diction in\195\169vitable.",

	sporespawntrigger = "Horreb lance Invocation de spore.",

	removecursetrigger = "Horreb lance D\195\169livrance de la mal\195\169diction sur Horreb.",

	you = "Vous",
	are = "subissez",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsLoatheb = BigWigs:NewModule(boss)
BigWigsLoatheb.zonename = AceLibrary("Babble-Zone-2.2")["Naxxramas"]
BigWigsLoatheb.enabletrigger = boss
BigWigsLoatheb.toggleoptions = {"doom", "spore", "curse", "flash", "bosskill"}
BigWigsLoatheb.revision = tonumber(string.sub("$Revision: 15709 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsLoatheb:OnEnable()
	self.doomTime = 30
	self.sporeCount = 1
	self.doomCount = 1
	started = nil

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_WHISPER")

	self:RegisterEvent("BigWigs_RecvSync")

	-- 2: Doom and SporeSpawn versioned up because of the sync including the
	-- doom/spore count now, so we don't hold back the counter.
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebDoom2", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebSporeSpawn2", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "LoathebRemoveCurse", 10)
	
	if (Class == "PALADIN" or Class == "PRIEST" or Class == "DRUID") then
		BigWigs:Print("|cff00FF00[Heal MT]|r Vous devez impérativement chuchoter |cffFF0000a toi de heal|r au healer suivant pour que l'annonce fonctionne.")
	end
end

function BigWigsLoatheb:BigWigs_RecvSync(sync, rest, nick)
	if sync == self:GetEngageSync() and rest and rest == boss and not started then
		started = true
		self:ScheduleEvent("bwrloathebinitspore", self.InitSporeSpawn, 8, self)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["sporebar"], ordre[self.sporeCount]), 8, "Interface\\AddOns\\BigWigs\\Icons\\Spore")
		self:ScheduleEvent("bwrloathebinitcurse", self.InitRemoveCurse, 25, self)
		self:TriggerEvent("BigWigs_StartBar", self, L["removecursebar"], 25, "Interface\\Icons\\Spell_Holy_RemoveCurse")
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.doom then
			self:TriggerEvent("BigWigs_StartBar", self, L["doomtimerbar"], 300, "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
			self:ScheduleEvent("bwloathebtimerreduce1", "BigWigs_Message", 240, string.format(L["doomtimerwarn"], 60), "Attention")
			self:ScheduleEvent("bwloathebtimerreduce2", "BigWigs_Message", 270, string.format(L["doomtimerwarn"], 30), "Attention")
			self:ScheduleEvent("bwloathebtimerreduce3", "BigWigs_Message", 290, string.format(L["doomtimerwarn"], 10), "Urgent")
			self:ScheduleEvent("bwloathebtimerreduce4", "BigWigs_Message", 295, string.format(L["doomtimerwarn"], 5), "Important")
			self:ScheduleEvent("bwloathebtimerreduce5", "BigWigs_Message", 300, L["doomtimerwarnnow"], "Important")

			self:ScheduleEvent("bwloathebdoomtimerreduce", function () BigWigsLoatheb.doomTime = 15 end, 300)

			self:TriggerEvent("BigWigs_Message", L["startwarn"], "Red")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["doombar"], self.doomCount), 120, "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
			self:ScheduleEvent("bwloathebdoom", "BigWigs_Message", 115, string.format(L["doomwarn5sec"], self.doomCount), "Urgent")
		end
	elseif sync == "LoathebDoom2" and rest then
		rest = tonumber(rest)
		if not rest then return end

		if rest == (self.doomCount + 1) then
			if self.db.profile.doom then
				self:TriggerEvent("BigWigs_Message", string.format(L["doomwarn"], self.doomCount, self.doomTime), "Important")
			end
			self.doomCount = self.doomCount + 1
			if self.db.profile.doom then
				self:TriggerEvent("BigWigs_StartBar", self, string.format(L["doombar"], self.doomCount), self.doomTime, "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
				self:ScheduleEvent("bwloathebdoom", "BigWigs_Message", self.doomTime - 5, string.format(L["doomwarn5sec"], self.doomCount), "Urgent")
			end
		end
	elseif sync == "LoathebRemoveCurse" then
		if self.db.profile.curse then
			self:TriggerEvent("BigWigs_Message", L["removecursewarn"], "Important")
			self:TriggerEvent("BigWigs_StartBar", self, L["removecursebar"], 28, "Interface\\Icons\\Spell_Holy_RemoveCurse")
		end
	end
end

function BigWigsLoatheb:Event( msg )
	if string.find(msg, L["doomtrigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "LoathebDoom2 "..tostring(self.doomCount + 1))
	end
end

function BigWigsLoatheb:InitSporeSpawn()
	self:ScheduleRepeatingEvent("bwloathebSporeSpawn", self.SporeSpawn, 13, self)
	self:SporeSpawn()
end

function BigWigsLoatheb:SporeSpawn()
	if self.db.profile.spore then
		self:TriggerEvent("BigWigs_Message", string.format(L["sporewarn"], ordre[self.sporeCount]), "Important")
	end
	if self.sporeCount < 5 then
		self.sporeCount = self.sporeCount + 1
	else
		self.sporeCount = 1
	end
	if self.db.profile.spore then
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["sporebar"], ordre[self.sporeCount]), 13, "Interface\\AddOns\\BigWigs\\Icons\\Spore")
		if ordre[self.sporeCount] == self:GetSubGroupID() then
			self:ScheduleEvent("bwrloathebchatmsgpost", self.Chatmsgpost, 10, self)
		end
	end
end

function BigWigsLoatheb:InitRemoveCurse()
	self:ScheduleRepeatingEvent("bwloathebremovecurse", self.RemoveCurse, 28, self)
	self:RemoveCurse()
end

function BigWigsLoatheb:RemoveCurse()
	self:TriggerEvent("BigWigs_SendSync", "LoathebRemoveCurse")
end

function BigWigsLoatheb:GetSubGroupID()
	if not UnitInRaid("PLAYER") then return end
	for i = 1 , GetNumRaidMembers() do
		name, _, subgroup = GetRaidRosterInfo(i)
		if ( name == UnitName("PLAYER") ) then
			return subgroup
		end
	end
end

function BigWigsLoatheb:Chatmsgpost()
	SendChatMessage("<<< GO LA SPORE !!! >>>", "PARTY")
end

function BigWigsLoatheb:CHAT_MSG_WHISPER(msg)
	if not (Class == "PALADIN" or Class == "PRIEST" or Class == "DRUID") then return; end
	if string.find(string.lower(msg), "a toi de heal") then
		if self.db.profile.flash then
			self:TriggerEvent("BigWigs_Message", "A votre tour de heal", "Personal", true, "Long")
		else
			self:TriggerEvent("BigWigs_Message", "A votre tour de heal", "Important", true, "Long")
		end
		self:TriggerEvent("BigWigs_StartBar", self, "A vous de heal", 10, "Interface\\Icons\\Spell_Holy_FlashHeal")
	end
end