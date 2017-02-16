------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Chromaggus"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local twenty
local _, class = UnitClass("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Chromaggus",

	enrage_cmd = "enrage",
	enrage_name = "Enrage",
	enrage_desc = "Warn before Enrage at 20%",

	frenzy_cmd = "frenzy",
	frenzy_name = "Frenzy Alert",
	frenzy_desc = "Warn for Frenzy",

	breath_cmd = "breath",
	breath_name = "Breath Alerts",
	breath_desc = "Warn for Breaths",

	vulnerability_cmd = "vulnerability",
	vulnerability_name = "Vulnerability Alerts",
	vulnerability_desc = "Warn for Vulnerability changes",

	breath_trigger = "begins to cast ([%w ]+)\.",
	vulnerability_test = "^[%w']+ [%w' ]+ ([%w]+) Chromaggus for ([%d]+) ([%w ]+) damage%..*",
	frenzy_trigger = "goes into a killing frenzy!",
	vulnerability_trigger = "flinches as its skin shimmers.",
	--vulnerability_trigger = "flinches",
	
	hit = "hits",
	crit = "crits",

	breath_warning = "%s in 10 seconds!",
	breath_message = "%s is casting!",
	vulnerability_message = "Vulnerability: %s!",
	vulnerability_warning = "Spell vulnerability changed!",
	frenzy_message = "Frenzy Alert!",
	enrage_warning = "Enrage soon!",

	breath1 = "Time Lapse",
	breath2 = "Corrosive Acid",
	breath3 = "Ignite Flesh",
	breath4 = "Incinerate",
	breath5 = "Frost Burn",

	iconunknown = "Interface\\Icons\\INV_Misc_QuestionMark",
	icon1 = "Interface\\Icons\\Spell_Arcane_PortalOrgrimmar",
	icon2 = "Interface\\Icons\\Spell_Nature_Acid_01",
	icon3 = "Interface\\Icons\\Spell_Fire_Fire",
	icon4 = "Interface\\Icons\\Spell_Shadow_ChillTouch",
	icon5 = "Interface\\Icons\\Spell_Frost_ChillingBlast",

	castingbar = "Cast %s",

} end )

L:RegisterTranslations("deDE", function() return {
	enrage_name = "Wutanfall",
	enrage_desc = "Warnung, wenn Chromaggus w\195\188tend wird. (ab 20%).",

	frenzy_name = "Raserei",
	frenzy_desc = "Warnung, wenn Chromaggus in Raserei ger\195\164t.",

	breath_name = "Atem",
	breath_desc = "Warnung, wenn Chromaggus seinen Atem wirkt.",

	vulnerability_name = "Zauber-Verwundbarkeiten",
	vulnerability_desc = "Warnung, wenn Chromagguss Zauber-Verwundbarkeit sich \195\164ndert.",

	breath_trigger = "^Chromaggus beginnt (.+) zu wirken%.",
	vulnerability_test = "^[^%s]+ .* trifft Chromaggus(.+)f\195\188r ([%d]+) ([%w ]+)'schaden%..*", -- ?
	frenzy_trigger = "^Chromaggus ger\195\164t in t\195\182dliche Raserei!",
	vulnerability_trigger = "^Chromaggus weicht zur\195\188ck, als die Haut schimmert.",

	hit = "trifft",
	crit = "kritisch",

	breath_warning = "%s in 10 Sekunden!",
	breath_message = "Chromaggus wirkt: %s Atem!",
	vulnerability_message = "Neue Zauber-Verwundbarkeit: %s",
	vulnerability_warning = "Zauber-Verwundbarkeit ge\195\164ndert!",
	frenzy_message = "Raserei - Einlullender Schuss!",
	enrage_warning = "Wutanfall steht kurz bevor!",

	breath1 = "Zeitraffer",
	breath2 = "\195\132tzende S\195\164ure",
	breath3 = "Fleisch entz\195\188nden",
	breath4 = "Verbrennen",
	breath5 = "Frostbeulen",

	castingbar = "Wirkt %s",
} end )

L:RegisterTranslations("frFR", function() return {
	enrage_name = "Alerte Enrag\195\169",
	enrage_desc = "Pr\195\169viens quand Chromaggus s'enrage (\195\160 20%).",

	frenzy_name = "Alerte Fr\195\169n\195\169sie",
	frenzy_desc = "Pr\195\169viens quand Chromaggus entre dans des fr\195\169n\195\169sies sanglantes.",

	breath_name = "Alerte Souffles",
	breath_desc = "Pr\195\169viens quand Chromaggus souffle ainsi que leurs types.",

	vulnerability_name = "Alerte Vuln\195\169rabilit\195\169s",
	vulnerability_desc = "Pr\195\169viens quand la vuln\195\169rabilit\195\169 de Chromaggus change.",
	
	breath_trigger = "^Chromaggus commence \195\160 lancer (.+)%.",
	vulnerability_test = "^.+ lance .+ sur Chromaggus et lui (.+) ([%d]+) points de dégâts .+ (.+)%.";

	frenzy_trigger = "^Chromaggus entre dans une frénésie sanglante !",
	vulnerability_trigger = "^Chromaggus grimace lorsque sa peau se met à briller.",

	hit = "inflige",
	crit = "critique",

	breath_warning = "%s dans 10 sec. !",
	breath_message = "%s en cours d'incantation !",
	vulnerability_message = "Vulnerabilit\195\169 : %s !",
	vulnerability_warning = "Vuln\195\169rabilit\195\169 aux sorts modifi\195\169e !",
	frenzy_message = "Alerte fr\195\169n\195\169sie !",
	enrage_warning = "Enragement imminent !",

	breath1 = "Trou de temps",
	breath2 = "Acide corrosif",
	breath3 = "Enflammer la chair",
	breath4 = "Incin\195\169rer",
	breath5 = "Br\195\187lure de givre",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsChromaggus = BigWigs:NewModule(boss)
BigWigsChromaggus.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsChromaggus.enabletrigger = boss
BigWigsChromaggus.toggleoptions = { "enrage", "frenzy", "breath", "vulnerability", "bosskill"}
BigWigsChromaggus.revision = tonumber(string.sub("$Revision: 16721 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsChromaggus:OnEnable()
	-- in the module itself for resetting via schedule
	self.vulnerability = nil
	twenty = nil

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PET_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_PARTY_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE", "PlayerDamageEvents")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ChromaggusBreath", 10)
end

function BigWigsChromaggus:UNIT_HEALTH( msg )
	if self.db.profile.enrage and UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 20 and health <= 23 and not twenty then
			if self.db.profile.enrage then self:TriggerEvent("BigWigs_Message", L["enrage_warning"], "Important") end
			twenty = true
		elseif health > 40 and twenty then
			twenty = nil
		end
	end
end

function BigWigsChromaggus:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE( msg )
    --DEFAULT_CHAT_FRAME:AddMessage(msg)
	local _,_, spellName = string.find(msg, L["breath_trigger"])
	if spellName then
        --DEFAULT_CHAT_FRAME:AddMessage("souffle")
		local breath = L:HasReverseTranslation(spellName) and L:GetReverseTranslation(spellName) or nil
		if not breath then return end
		breath = string.sub(breath, -1)
		self:TriggerEvent("BigWigs_SendSync", "ChromaggusBreath "..breath)
	end
end

function BigWigsChromaggus:BigWigs_RecvSync(sync, spellId)
	if sync ~= "ChromaggusBreath" or not spellId or not self.db.profile.breath then return end

	local spellName = L:HasTranslation("breath"..spellId) and L["breath"..spellId] or nil
	if not spellName then return end

	self:TriggerEvent("BigWigs_StartBar", self, string.format( L["castingbar"], spellName), 2 )
	self:TriggerEvent("BigWigs_Message", string.format(L["breath_message"], spellName), "Important")
	self:ScheduleEvent("bwchromaggusbreath"..spellName, "BigWigs_Message", 50, string.format(L["breath_warning"], spellName), "Important")
	self:TriggerEvent("BigWigs_StartBar", self, spellName, 60, L["icon"..spellId])
end

function BigWigsChromaggus:CHAT_MSG_MONSTER_EMOTE(msg)
    --DEFAULT_CHAT_FRAME:AddMessage(msg)
	if msg == L["frenzy_trigger"] and self.db.profile.frenzy then
        --DEFAULT_CHAT_FRAME:AddMessage("frenzy")
		if class == "HUNTER" then
			self:TriggerEvent("BigWigs_Message", L["frenzy_message"], "Personal", true, "Long")
		else
			self:TriggerEvent("BigWigs_Message", L["frenzy_message"], "Important")
		end
		self:TriggerEvent("BigWigs_StartBar", self, "Prochaine frénésie", 15, "Interface\\Icons\\ability_druid_challangingroar")
	elseif string.find(msg, L["vulnerability_trigger"]) then
		--DEFAULT_CHAT_FRAME:AddMessage("vul")
        if self.db.profile.vulnerability then
			self:TriggerEvent("BigWigs_Message", L["vulnerability_warning"], "Positive")
			self:TriggerEvent("BigWigs_StartBar", self, "New vulnerability", 45, "Interface\\Icons\\inv_misc_monsterscales_17")
		end
		self:ScheduleEvent(function() BigWigsChromaggus.vulnerability = nil end, 2.5)
	end
end

if (GetLocale() == "koKR") then
	function BigWigsChromaggus:PlayerDamageEvents(msg)
		if (not self.vulnerability) then
			local _,_,_, dmg, school, type = string.find(msg, L["vulnerability_test"])
			if ( type == L["hit"] or type == L["crit"] ) and tonumber(dmg or "") and school then
				if (tonumber(dmg) >= 550 and type == L["hit"]) or (tonumber(dmg) >= 1100 and type == L["crit"]) then
					self.vulnerability = school
					if self.db.profile.vulnerability then self:TriggerEvent("BigWigs_Message", format(L["vulnerability_message"], school), "Positive") end
				end
			end
		end
	end
else
	function BigWigsChromaggus:PlayerDamageEvents(msg)
        --DEFAULT_CHAT_FRAME:AddMessage(msg)
		if (not self.vulnerability) then
			local _,_, type, dmg, school = string.find(msg, L["vulnerability_test"])
			if not school then
				_,_, type, dmg, school = string.find(msg, "^.+ lance .+ et inflige un coup (.+) à Chromaggus %(([%d]+) points de dégâts .+ (.+)%)%.")
			end
			if ( type == L["hit"] or type == L["crit"] ) and tonumber(dmg or "") and school then
				if (tonumber(dmg) >= 550 and type == L["hit"]) or (tonumber(dmg) >= 1100 and type == L["crit"]) then
					self.vulnerability = school
					if self.db.profile.vulnerability then self:TriggerEvent("BigWigs_Message", format(L["vulnerability_message"], school), "Positive") end
				end
			end
		end
	end
end

