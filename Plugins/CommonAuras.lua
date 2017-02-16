--[[
--
-- BigWigs Strategy Module - Common Auras
--
-- Gives timer bars and raid messages about common
-- buffs and debuffs.
--
--]]

------------------------------
--      Are you local?      --
------------------------------

local name = "Common Auras"
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)

local spellStatus = nil
local lastTank = nil
local shieldWallDuration = nil

-- Use for detecting instant cast target (Fear Ward)
local spellTarget = nil
local spellCasting = nil

local portalIcons = {}

------------------------------
--      Localization        --
------------------------------

L:RegisterTranslations("enUS", function() return {
	fw_cast = "%s fearwarded %s.",
	fw_bar = "%s: FW Cooldown",

	sw_cast = "%s used Shield Wall.",
	sw_bar = "%s: Shield Wall",

	cs_cast = "%s used challenging shout!",
	cs_bar = "%s: Challenging Shout",

	cr_cast = "%s used challenging roar!",
	cr_bar = "%s: Challenging Roar",
    
    nf_cast = "%s has spell vulnerability",
    nf_bar = "%s: Spell Vulnerability",
    
    nightfall_trig = "(.+) is afflicted by Spell Vulnerability",
	portal_cast = "%s opened a portal to %s!",
	-- portal_bar is the spellname

	["Fear Ward"] = true,
	["Toggle Fear Ward display."] = true,
	["Shield Wall"] = true,
	["Toggle Shield Wall display."] = true,
	["Challenging Shout"] = true,
	["Toggle Challenging Shout display."] = true,
	["Challenging Roar"] = true,
	["Toggle Challenging Roar display."] = true,
	["Portal"] = true,
	["Toggle Portal reporting."] = true,
    ["Nightfall"] = true,
    ["Toggle Nightfall Proc display."] = true,
	["broadcast"] = true,
	["Broadcast"] = true,
	["Toggle broadcasting the messages to raid."] = true,

	["Gives timer bars and raid messages about common buffs and debuffs."] = true,
	["Common Auras"] = true,
	["commonauras"] = true,

	["Portal: Ironforge"] = true,
	["Portal: Stormwind"] = true,
	["Portal: Darnassus"] = true,
	["Portal: Orgrimmar"] = true,
	["Portal: Thunder Bluff"] = true,
	["Portal: Undercity"] = true,
} end )

L:RegisterTranslations("frFR", function() return {
	fw_cast = "%s lance Gardien de peur.",
	fw_bar = "%s: FW Cooldown",

	sw_cast = "%s lance Mur protecteur.",
	sw_bar = "%s: Shield Wall",

	cs_cast = "%s lance Cri de défi!",
	cs_bar = "%s: Cri de défi",

	cr_cast = "%s lance Rugissement provocateur!",
	cr_bar = "%s: Rugissement provocateur",

	portal_cast = "%s ouvre un portail pour %s.",
	
	["Fear Ward"] = "Gardien de peur",
	["Toggle Fear Ward display."] = "Active l'affichage du Gardien de peur.",
	["Shield Wall"] = "Mur protecteur",
	["Toggle Shield Wall display."] = "Active l'affichage du Mur protecteur.",
	["Challenging Shout"] = "Cri de défi",
	["Toggle Challenging Shout display."] = "Active l'affichage du Cri de défi.",
	["Challenging Roar"] = "Rugissement provocateur",
	["Toggle Challenging Roar display."] = "Active l'affichage du Rugissement provocateur.",
	["Portal"] = "Portail",
	["Toggle Portal reporting."] = "Diffuser l'ouverture de portails",
	["broadcast"] = "diffusion",
	["Broadcast"] = "Diffusion",
	["Toggle broadcasting the messages to raid."] = "Diffuser les messages sur le canal raid.",
	
	["Gives timer bars and raid messages about common buffs and debuffs."] = "Donne des barres de timer et des messages raid à propos des Buffs et Débuffs courants.",
	["Common Auras"] = "Auras Courantes",
	["commonauras"] = "commonauras",
	
	["Portal: Ironforge"] = "Portail : Ironforge",
	["Portal: Stormwind"] = "Portail : Stormwind",
	["Portal: Darnassus"] = "Portail : Darnassus",
	["Portal: Orgrimmar"] = "Portail : Orgrimmar",
	["Portal: Thunder Bluff"] = "Portail : Thunder Bluff",
	["Portal: Undercity"] = "Portail : Undercity",
} end )

------------------------------
--      Module              --
------------------------------

BigWigsCommonAuras = BigWigs:NewModule(name, "AceHook-2.1")
BigWigsCommonAuras.synctoken = myname
BigWigsCommonAuras.defaultDB = {
	fearward = true,
	shieldwall = true,
	challengingshout = true,
	challengingroar = true,
	portal = true,
    nightfall = false,
	broadcast = false,
}

local function CheckNightfall()
    local _,_,ic2=strfind(GetInventoryItemLink('player', 16),'(%d+):');
    local aw = false
    if ic2 == '19169' then 
        aw = true
    else
        for i=4,0,-1 do
            local bs = GetContainerNumSlots(i);
            if bs>0 then 
                for j=1,bs do 
                    local _,icnt=GetContainerItemInfo(i,j); 
                    if (icnt) then
                        local il = GetContainerItemLink(i,j);
                        local _, _, ic = strfind(il, '(%d+):');
                        if ic == '19169' then
                            aw = true;
                            break;
                        end
                    end
                end
            end
        end
    end
    return aw;
end

BigWigsCommonAuras.consoleCmd = "commonauras"
BigWigsCommonAuras.consoleOptions = {
	type = "group",
	name = L["Common Auras"],
	desc = L["Gives timer bars and raid messages about common buffs and debuffs."],
	args   = {
		["fearward"] = {
			type = "toggle",
			name = L["Fear Ward"],
			desc = L["Toggle Fear Ward display."],
			get = function() return BigWigsCommonAuras.db.profile.fearward end,
			set = function(v) BigWigsCommonAuras.db.profile.fearward = v end,
		},
		["shieldwall"] = {
			type = "toggle",
			name = L["Shield Wall"],
			desc = L["Toggle Shield Wall display."],
			get = function() return BigWigsCommonAuras.db.profile.shieldwall end,
			set = function(v) BigWigsCommonAuras.db.profile.shieldwall = v end,
		},
		["challengingshout"] = {
			type = "toggle",
			name = L["Challenging Shout"],
			desc = L["Toggle Challenging Shout display."],
			get = function() return BigWigsCommonAuras.db.profile.challengingshout end,
			set = function(v) BigWigsCommonAuras.db.profile.challengingshout = v end,
		},
		["challengingroar"] = {
			type = "toggle",
			name = L["Challenging Roar"],
			desc = L["Toggle Challenging Roar display."],
			get = function() return BigWigsCommonAuras.db.profile.challengingroar end,
			set = function(v) BigWigsCommonAuras.db.profile.challengingroar = v end,
		},
		["portal"] = {
			type = "toggle",
			name = L["Portal"],
			desc = L["Toggle Portal reporting."],
			get = function() return BigWigsCommonAuras.db.profile.portal end,
			set = function(v) BigWigsCommonAuras.db.profile.portal = v end,
		},
		["nightfall"] = {
			type = "toggle",
			name = L["Nightfall"],
			desc = L["Toggle Nightfall Proc display."],
			get = function() return BigWigsCommonAuras.db.profile.nightfall end,
			set = function(v) BigWigsCommonAuras.db.profile.nightfall = v; if v then if CheckNightfall() then self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE") end end end,
		},
		["broadcast"] = {
			type = "toggle",
			name = L["Broadcast"],
			desc = L["Toggle broadcasting the messages to raid."],
			get = function() return BigWigsCommonAuras.db.profile.broadcast end,
			set = function(v) BigWigsCommonAuras.db.profile.broadcast = v end,
		},
	}
}
BigWigsCommonAuras.revision = tonumber(string.sub("$Revision: 11670 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsCommonAuras:OnEnable()
	local _, class = UnitClass("player")
	local _, race = UnitRace("player")
    --self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
	if class == "WARRIOR" or class == "DRUID" then
		self:RegisterEvent("SpellStatus_SpellCastInstant")
		if class == "WARRIOR" then
			local _, _, _, _, currentRank , _, _, _ = GetTalentInfo( 3 , 13 )
			if currentRank == 0 then
				shieldWallDuration = 10
			elseif currentRank == 1 then
				shieldWallDuration = 13
			else
				shieldWallDuration = 15
			end
		end
	elseif class == "PRIEST" and race == "Dwarf" then
		self:RegisterEvent("SpellStatus_SpellCastInstant")
		--[[self:Hook("CastSpell")
		self:Hook("CastSpellByName")
		self:Hook("SpellTargetUnit")
		self:Hook("SpellStopTargeting")
		self:Hook("TargetUnit")
		self:Hook("UseAction")
		self:HookScript(WorldFrame,"OnMouseDown","BigWigsCommonAurasOnMouseDown")]]
	elseif class == "MAGE" then
		if not spellStatus then spellStatus = AceLibrary("SpellStatus-1.0") end
		self:RegisterEvent("SpellStatus_SpellCastCastingFinish")
		self:RegisterEvent("SpellStatus_SpellCastFailure")
	end
    
    if self.db.profile.nightfall then
        if CheckNightfall() then self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE"); end
    end
	portalIcons["Ironforge"] = "Spell_Arcane_PortalIronForge"
	portalIcons["Stormwind"] = "Spell_Arcane_PortalStormWind"
	portalIcons["Darnassus"] = "Spell_Arcane_PortalDarnassus"
	portalIcons["Orgrimmar"] = "Spell_Arcane_PortalOrgrimmar"
	portalIcons["Thunder Bluff"] = "Spell_Arcane_PortalThunderBluff"
	portalIcons["Undercity"] = "Spell_Arcane_PortalUnderCity"

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCAFW", 0) -- Fear Ward
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCASW", 0) -- Shield Wall
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCACS", 0) -- Challenging Shout
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCACR", 0) -- Challenging Roar
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCAP", 0.1) -- Portal
    self:TriggerEvent("BigWigs_ThrottleSync", "BWNF", 0) -- NightFall
end

------------------------------
--      Events              --
------------------------------

function BigWigsCommonAuras:BigWigs_RecvSync( sync, rest, nick )
	if not nick then nick = UnitName("player") end
	if self.db.profile.fearward and sync == "BWCAFW" and rest then
		self:TriggerEvent("BigWigs_Message", string.format(L["fw_cast"], nick, rest), "Green", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["fw_bar"], nick), 30, "Interface\\Icons\\Spell_Holy_Excorcism", "Green")
	elseif self.db.profile.shieldwall and sync == "BWCASW" then
		self:TriggerEvent("BigWigs_Message", string.format(L["sw_cast"], nick), "Yellow", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["sw_bar"], nick), 10, "Interface\\Icons\\Ability_Warrior_ShieldWall", "Yellow")
		lastTank = nick
	elseif self.db.profile.challengingshout and sync == "BWCACS" then
		self:TriggerEvent("BigWigs_Message", string.format(L["cs_cast"], nick), "Orange", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["cs_bar"], nick), 6, "Interface\\Icons\\Ability_BullRush", "Orange")
		lastTank = nick
	elseif self.db.profile.challengingroar and sync == "BWCACR" then
		self:TriggerEvent("BigWigs_Message", string.format(L["cr_cast"], nick), "Orange", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["cr_bar"], nick), 6, "Interface\\Icons\\Ability_Druid_ChallangingRoar", "Orange")
		lastTank = nick
	elseif self.db.profile.portal and sync == "BWCAP" and rest then
		-- DEFAULT_CHAT_FRAME:AddMessage("'"..rest.."'")
		local _, _, zone = string.find(rest, ".*: (.*)")
		self:TriggerEvent("BigWigs_Message", string.format(L["portal_cast"], nick, zone), "Blue", not self.db.profile.broadcast, false)
		self:TriggerEvent("BigWigs_StartBar", self, rest, 60, "Interface\\Icons\\"..portalIcons[zone], "Blue")
    elseif self.db.profile.nightfall and sync == "BWNF" and rest then
		self:TriggerEvent("BigWigs_Message", string.format(L["nf_cast"], rest), "Orange", not self.db.profile.nightfall, false)
		self:TriggerEvent("BigWigs_StartBar", self, string.format(L["nf_bar"], rest), 5, "Interface\\Icons\\INV_Axe_12", "Orange")
	end
end

function BigWigsCommonAuras:SpellStatus_SpellCastInstant(sId, sName, sRank, sFullName, sCastTime)
	if sName == L["Fear Ward"] then
		local targetName = nil
		if spellTarget then
			targetName = spellTarget
			spellCasting = nil
			spellTarget = nil
		else
			targetName = UnitExists("target") and UnitName("target") or UnitName("player")
		end
		self:TriggerEvent("BigWigs_SendSync", "BWCAFW "..targetName)
	elseif sName == L["Shield Wall"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCASW")
	elseif sName == L["Challenging Shout"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCACS")
	elseif sName == L["Challenging Roar"] then
		self:TriggerEvent("BigWigs_SendSync", "BWCACR")
	end
end

function BigWigsCommonAuras:SpellStatus_SpellCastCastingFinish(sId, sName, sRank, sFullName, sCastTime)
	if not string.find(sName, L["Portal"]) then return end
	self:ScheduleEvent("bwcaspellcast", self.SpellCast, 0.3, self, sName)
end

function BigWigsCommonAuras:SpellStatus_SpellCastFailure(sId, sName, sRank, sFullName, isActiveSpell, UIEM_Message, CMSFLP_SpellName, CMSFLP_Message)
	-- do nothing if we are casting a spell but the error doesn't consern that spell, thanks Iceroth.
	if (spellStatus:IsCastingOrChanneling() and not spellStatus:IsActiveSpell(sId, sName)) then
		return
	end
	if self:IsEventScheduled("bwcaspellcast") then
		self:CancelScheduledEvent("bwcaspellcast")
	end
end

function BigWigsCommonAuras:SpellCast(sName)
	self:TriggerEvent("BigWigs_SendSync", "BWCAP "..sName)
end

function BigWigsCommonAuras:CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE(msg)
    local _,_,name = string.find(msg, L["nightfall_trig"]) 
    if name then
		self:TriggerEvent("BigWigs_SendSync", "BWNF "..name)
	end
end
------------------------------
--      Macro               --
------------------------------

function BWCATargetLastTank()
	if not lastTank then return end
	TargetByName(lastTank, true)
end

