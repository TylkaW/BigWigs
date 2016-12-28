------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Razorgore the Untamed"]
local controller = AceLibrary("Babble-Boss-2.2")["Grethok the Controller"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local eggs

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Razorgore",

	start_trigger = "Intruders have breached",
	start_message = "Razorgore engaged! Mobs in 45sec!",
	start_soon = "Mob Spawn in 5sec!",
	start_mob = "Mob Spawn",
	
	mindcontrol_trigger = "Foolish ([^%s]+).",
	mindcontrol_message = "%s has been mind controlled!",

	egg_trigger = "casts Destroy Egg",
	egg_message = "%d/30 eggs destroyed!",

	phase2_trigger = "Razorgore the Untamed's Warming Flames heals Razorgore the Untamed for .*.",
	phase2_message = "All eggs destroyed, Razorgore loose!",

	mc_cmd = "mindcontrol",
	mc_name = "Mind Control",
	mc_desc = "Warn when players are mind controlled",

	eggs_cmd = "eggs",
	eggs_name = "Don't count eggs",
	eggs_desc = "Don't count down the remaining eggs - this option does not work for everyone, we need better triggers.",

	phase_cmd = "phase",
	phase_name = "Phases",
	phase_desc = "Alert on phase 1 and 2",
	
	warstomp_cmd = "warstomp",
	warstomp_name = "Alerte Choc Martial",
	warstomp_desc = "Préviens de l'arrivée du Choc Martial",
	
	deflag_cmd = "deflag",
	deflag_name = "Alerte Déflagration",
	deflag_desc = "Préviens de l'arrivée de la Déflagration",
	
	fireball_cmd = "fireball",
	fireball_name = "Alerte Volée de boules de feu",
	fireball_desc = "Préviens de l'arrivée des Volée de boules de feu.",
} end)

L:RegisterTranslations("frFR", function() return {
	start_trigger = "Protégez les oeufs",
	start_message = "Tranchetripe engagé ! 45 secondes avant l'arrivée des gardes !",
	start_soon = "Arrivée des gardes dans 5 secondes !",
	start_mob = "Arrivée des gardes",

	mindcontrol_trigger = "Stupide ([^%s]+), tu es mon esclave maintenant !",
	mindcontrol_message = "%s est sous Contr\195\180le mental !",

	egg_trigger = "Tranchetripe l'Indompté lance Détruire (.*)%.",
	egg_message = "%d oeufs sur 30 détruits !",

	phase2_trigger = "Flammes échauffantes .+ Tranchetripe l'Indompté guérit Tranchetripe l'Indompté de .* points de vie%.",
	phase2_message = "Tous les oeufs ont été détruits !",

	mc_name = "Alerte Contr\195\180le mental",
	mc_desc = "Préviens quand un joueur subit subit un contr\195\180le mental.",

	eggs_name = "Ne pas compter les oeufs",
	eggs_desc = "Ne compte pas le nombre d'oeufs restants - cette option ne fonctionne pas chez tout le monde, un meilleur déclencheur doit \195\170tre trouvé.",

	phase_name = "Alerte Phases",
	phase_desc = "Préviens de l'arrivée des phases 1 & 2.",
	
	warstomp_name = "Alerte Choc Martial",
	warstomp_desc = "Préviens de l'arrivée du Choc Martial",
	
	deflag_name = "Alerte Déflagration",
	deflag_desc = "Préviens de l'arrivée de la Déflagration",
	
	fireball_name = "Alerte Volée de boules de feu",
	fireball_desc = "Préviens de l'arrivée des Volée de boules de feu.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsRazorgore = BigWigs:NewModule(boss)
BigWigsRazorgore.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsRazorgore.enabletrigger = { boss, controller }
BigWigsRazorgore.toggleoptions = { "mc", "eggs", "phase", "warstomp", "deflag", "fireball", "bosskill" }
BigWigsRazorgore.revision = tonumber(string.sub("$Revision: 17555 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsRazorgore:OnEnable()
	eggs = 0

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "RazorgoreEgg", 7)
	self:TriggerEvent("BigWigs_ThrottleSync", "FireballVolley", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "Deflagration", 12)
	self:TriggerEvent("BigWigs_ThrottleSync", "Warstomp", 10)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsRazorgore:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, L["start_trigger"]) then
		if self.db.profile.phase then
			self:TriggerEvent("BigWigs_Message", L["start_message"], "Urgent")
			self:TriggerEvent("BigWigs_StartBar", self, L["start_mob"], 41, "Interface\\Icons\\Spell_Holy_PrayerOfHealing")
			self:ScheduleEvent("BigWigs_Message", 36, L["start_soon"], "Important")
		end
		eggs = 0
	elseif self.db.profile.mc then
		local _, _, player = string.find(msg, L["mindcontrol_trigger"]);
		if player then
			self:TriggerEvent("BigWigs_Message", string.format(L["mindcontrol_message"], player), "Important")
		end
	end
end

function BigWigsRazorgore:Event(msg)
	if string.find(msg, "Volée de Boules de feu") then
		self:TriggerEvent("BigWigs_SendSync", "FireballVolley")
	elseif string.find(msg, "Déflagration") then
		self:TriggerEvent("BigWigs_SendSync", "Deflagration")
	elseif string.find(msg, "Choc martial") then
		self:TriggerEvent("BigWigs_SendSync", "Warstomp")
	end
end

function BigWigsRazorgore:CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF(msg)
	if string.find(msg, L["egg_trigger"]) then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreEgg "..tostring(eggs + 1))
	end
end

function BigWigsRazorgore:CHAT_MSG_MONSTER_EMOTE(msg)
	if string.find(msg, "lance Détruire l'Oeuf.") then
		self:TriggerEvent("BigWigs_SendSync", "RazorgoreEgg "..tostring(eggs + 1))
	end
end

function BigWigsRazorgore:FireballVolley()
	self:TriggerEvent("BigWigs_StartBar", self, "~Volée Probable", 5, "Interface\\Icons\\Spell_Fire_Flamebolt")
end

function BigWigsRazorgore:Deflag()
	self:TriggerEvent("BigWigs_StartBar", self, "~Déflagration Probable", 10, "Interface\\Icons\\Spell_Fire_Incinerate")
end

function BigWigsRazorgore:BigWigs_RecvSync(sync, rest)
	if sync == "RazorgoreEgg" and rest then
		rest = tonumber(rest)
		if rest == (eggs + 1) then
			eggs = eggs + 1
			if not self.db.profile.eggs then
				self:TriggerEvent("BigWigs_Message", string.format(L["egg_message"], eggs), "Positive")
			end

			if eggs == 30 and self.db.profile.phase then
				self:TriggerEvent("BigWigs_Message", L["phase2_message"], "Important")
				if self.db.profile.fireball then
					self:TriggerEvent("BigWigs_StartBar", self, "Prochaine Volée", 15, "Interface\\Icons\\Spell_Fire_Flamebolt")
				end
				if self.db.profile.warstomp then
					self:TriggerEvent("BigWigs_StartBar", self, "Prochain Choc Martial", 28, "Interface\\Icons\\Ability_Bullrush")
				end
				if self.db.profile.deflag then
					self:TriggerEvent("BigWigs_StartBar", self, "Prochaine Déflagration", 12, "Interface\\Icons\\Spell_Fire_Incinerate")
				end
			end
		elseif rest >= (eggs + 1) then
			eggs = rest
			if not self.db.profile.eggs then
				self:TriggerEvent("BigWigs_Message", string.format(L["egg_message"], eggs), "Positive")
			end
		end
	elseif sync == "FireballVolley" and self.db.profile.fireball then
		self:TriggerEvent("BigWigs_StartBar", self, "Prochaine Volée", 15, "Interface\\Icons\\Spell_Fire_Flamebolt")
		self:TriggerEvent("BigWigs_Message", "Volée de boules de feu !", "Important")
		self:TriggerEvent("BigWigs_StopBar", self, "~Volée Probable")
		self:ScheduleEvent("BWRazorgore", self.FireballVolley, 15, self)
	elseif sync == "Warstomp" and self.db.profile.warstomp then
		self:TriggerEvent("BigWigs_StartBar", self, "Prochain Choc Martial", 30, "Interface\\Icons\\Ability_Bullrush")
		self:TriggerEvent("BigWigs_Message", "Choc Martial !", "Important")
	elseif sync == "Deflagration" and self.db.profile.deflag then
		self:TriggerEvent("BigWigs_StartBar", self, "Prochaine Déflagration", 15, "Interface\\Icons\\Spell_Fire_Incinerate")
		self:TriggerEvent("BigWigs_Message", "Déflagration !", "Important")
		self:TriggerEvent("BigWigs_StopBar", self, "~Déflagration Probable")
		self:ScheduleEvent("BWRazorgoreDeflag", self.Deflag, 15, self)
	end
end

