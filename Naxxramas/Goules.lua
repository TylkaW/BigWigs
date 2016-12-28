------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Anubisath Guardian"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Guardian",

	summon_cmd = "summon",
	summon_name = "Summon Alert",
	summon_desc = "Warn for summoned adds",

	plagueyou_cmd = "plagueyou",
	plagueyou_name = "Plague on you alert",
	plagueyou_desc = "Warn for plague on you",

	plagueother_cmd = "plagueother",
	plagueother_name = "Plague on others alert",
	plagueother_desc = "Warn for plague on others",

	icon_cmd = "icon",
	icon_name = "Place icon",
	icon_desc = "Place raid icon on the last plagued person (requires promoted or higher)",

	explode_cmd = "explode",
	explode_name = "Explode Alert",
	explode_desc = "Warn for incoming explosion",

	enrage_cmd = "enrage",
	enrage_name = "Enrage Alert",
	enrage_desc = "Warn for enrage",

	explodetrigger = "Anubisath Guardian gains Explode.",
	explodewarn = "Exploding!",
	enragetrigger = "Anubisath Guardian gains Enrage.",
	enragewarn = "Enraged!",
	summonguardtrigger = "Anubisath Guardian casts Summon Anubisath Swarmguard.",
	summonguardwarn = "Swarmguard Summoned",
	summonwarriortrigger = "Anubisath Guardian casts Summon Anubisath Warrior.",
	summonwarriorwarn = "Warrior Summoned",
	plaguetrigger = "^([^%s]+) ([^%s]+) afflicted by Plague%.$",
	plaguewarn = " has the Plague!",
	plaguewarnyou = "You have the Plague!",
	plagueyou = "You",
	plagueare = "are",	
} end )

L:RegisterTranslations("deDE", function() return {
	summon_name = "Beschw\195\182rung",
	summon_desc = "Warnung, wenn Besch\195\188tzer des Anubisath Schwarmwachen oder Krieger beschw\195\182rt.",

	plagueyou_name = "Du hast die Seuche",
	plagueyou_desc = "Warnung, wenn Du die Seuche hast.",

	plagueother_name = "X hat die Seuche",
	plagueother_desc = "Warnung, wenn andere Spieler die Seuche haben.",

	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der die Seuche hat. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",

	explode_name = "Explosion",
	explode_desc = "Warnung vor Explosion.",

	enrage_name = "Wutanfall",
	enrage_desc = "Warnung vor Wutanfall.",

	explodetrigger = "Besch\195\188tzer des Anubisath bekommt 'Explodieren'.",
	explodewarn = "Explosion!",
	enragetrigger = "Besch\195\188tzer des Anubisath bekommt 'Wutanfall'.",
	enragewarn = "Wutanfall!",
	summonguardtrigger = "Besch\195\188tzer des Anubisath wirkt Schwarmwache des Anubisath beschw\195\182ren.",
	summonguardwarn = "Schwarmwache beschworen!",
	summonwarriortrigger = "Besch\195\188tzer des Anubisath wirkt Krieger des Anubisath beschw\195\182ren.",
	summonwarriorwarn = "Krieger beschworen!",
	plaguetrigger = "^([^%s]+) ([^%s]+) von Seuche betroffen%.$",
	plaguewarn = " hat die Seuche!",
	plaguewarnyou = "Du hast die Seuche!",
	plagueyou = "Ihr",
	plagueare = "seid",
} end )

L:RegisterTranslations("zhCN", function() return {
	summon_name = "????",
	summon_desc = "?????????????????",

	plagueyou_name = "??????",
	plagueyou_desc = "??????????",

	plagueother_name = "??????",
	plagueother_desc = "???????????",

	explode_name = "????",
	explode_desc = "?????????????????",

	enrage_name = "????",
	enrage_desc = "???????????????????",

	explodetrigger = "?????????????????",
	explodewarn = "????!????!",
	enragetrigger = "?????????????????",
	enragewarn = "??????!",
	summonguardtrigger = "???????????????????????",
	summonguardwarn = "??????????",
	summonwarriortrigger = "?????????????????????",
	summonwarriorwarn = "?????????????",
	plaguetrigger = "^(.+)?(.+)?????????$",
	plaguewarn = "???????!???!",
	plaguewarnyou = "????????!???!",
	plagueyou = "?",
	plagueare = "?",
} end )

L:RegisterTranslations("zhTW", function() return {
	-- Anubisath Guardian ????????
	summon_name = "????",
	summon_desc = "?????????????????",

	plagueyou_name = "??????",
	plagueyou_desc = "??????????",

	plagueother_name = "??????",
	plagueother_desc = "???????????",

	explode_name = "????",
	explode_desc = "?????????????????",

	enrage_name = "????",
	enrage_desc = "???????????????????",

	explodetrigger = "?????????????????",
	explodewarn = "????!????!",
	enragetrigger = "?????????????????",
	enragewarn = "??????!",
	summonguardtrigger = "???????????????????????",
	summonguardwarn = "??????????!",
	summonwarriortrigger = "?????????????????????",
	summonwarriorwarn = "?????????????!",
	plaguetrigger = "^(.+)??(.*)??",
	plaguewarn = "???????!???!",
	plaguewarnyou = "????????!???!",
	plagueyou = "?",
	plagueare = "?",
} end )

L:RegisterTranslations("koKR", function() return {
	summon_name = "?? ??",
	summon_desc = "?? ??? ?? ??",

	plagueyou_name = "??? ?? ??",
	plagueyou_desc = "??? ??? ?? ??",

	plagueother_name = "??? ?? ??",
	plagueother_desc = "??? ??? ?? ??",

	icon_name = "??? ??",
	icon_desc = "??? ??? ?? ???? ??? ??? ?? (??? ?? ??)",

	explode_name = "?? ??",
	explode_desc = "??? ?? ??",

	enrage_name = "?? ??",
	enrage_desc = "??? ?? ??",

	explodetrigger = "????? ???|1?;?; ?? ??? ?????.",
	explodewarn = "??! ????!",
	enragetrigger = "????? ???|1?;?; ?? ??? ?????.",
	enragewarn = "??!",
	summonguardtrigger = "????? ???|1?;?; ????? ??? ??|1?;?; ?????.",
	summonguardwarn = "??? ??",
	summonwarriortrigger = "????? ???|1?;?; ????? ?? ??|1?;?; ?????.",
	summonwarriorwarn = "?? ??",
	plaguetrigger = "^([^|;%s]*)(.*)??? ?????%.$",
	plaguewarn = "?? ??? ?????. ????!",
	plaguewarnyou = "??? ??? ?????.",
	plagueyou = "",
	plagueare = "",	
} end )

L:RegisterTranslations("frFR", function() return {

	summon_name = "Alerte invocation",
	summon_desc = "Pr\195\169viens quand le gardien invoque des adds.",

	plagueyou_name = "Alerte Peste sur vous",
	plagueyou_desc = "Pr\195\169viens quand vous avez la peste.",

	plagueother_name = "Alerte Peste sur d'autres",
	plagueother_desc = "Pr\195\169viens quand d'autres joueurs ont la peste.",

	icon_name = "Placer une ic\195\180ne",
	icon_desc = "Place une ic\195\180ne de raid sur le dernier personnage qui a la peste (requiert d'\195\170tre promus ou plus).",

	explode_name = "Alerte Explosion",
	explode_desc = "Pr\195\169viens en cas d'explosion imminente.",

	enrage_name = "Alerte Enrag\195\169",
	enrage_desc = "Pr\195\169viens quand le gardien s'enrage.",

	explodetrigger = "Gardien Anubisath gagne Exploser.",
	explodewarn = "Explosion imminente !",
	enragetrigger = "Gardien Anubisath gagne Enrager.",
	enragewarn = "Enrag\195\169 !",
	summonguardtrigger = "Gardien Anubisath lance Invocation d'un Garde-essaim Anubisath.",
	summonguardwarn = "Garde-Essaim invoqu\195\169 !",
	summonwarriortrigger = "Gardien Anubisath lance Invocation d'un Guerrier Anubisath.",
	summonwarriorwarn = "Guerrier invoqu\195\169 !",
	plaguetrigger = "^([^%s]+) ([^%s]+) les effets de Peste%.$",
	plaguewarn = " a la peste !",
	plaguewarnyou = "Tu as la peste !",
	plagueyou = "Vous",
	plagueare = "subissez",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGuardians = BigWigs:NewModule(boss)
BigWigsGuardians.zonename = AceLibrary("Babble-Zone-2.2")["Ruins of Ahn'Qiraj"]
BigWigsGuardians.enabletrigger = boss
BigWigsGuardians.toggleoptions = {"summon", "explode", "enrage", -1, "plagueyou", "plagueother", "icon", "bosskill"}
BigWigsGuardians.revision = tonumber(string.sub("$Revision: 16639 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGuardians:OnEnable()
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "CheckPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "CheckPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "CheckPlague")
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsGuardians:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
	if msg == string.format(UNITDIESOTHER, boss) then
		self.core:ToggleModuleActive(self, false)
	end
end

function BigWigsGuardians:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS( msg )
	if self.db.profile.explode and msg == L["explodetrigger"] then 
		self:TriggerEvent("BigWigs_Message", L["explodewarn"], "Important")
		self:TriggerEvent("BigWigs_StartBar", self, "Finissez-Le !", 7, "Interface\\Icons\\Spell_Fire_SelfDestruct")
	elseif self.db.profile.enrage and msg == L["enragetrigger"] then 
		self:TriggerEvent("BigWigs_Message", L["enragewarn"], "Important")
	end
end

function BigWigsGuardians:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF( msg )
	if self.db.profile.summon and msg == L["summonguardtrigger"] then 
		self:TriggerEvent("BigWigs_Message", L["summonguardwarn"], "Attention")
	elseif self.db.profile.summon and msg == L["summonwarriortrigger"] then 
		self:TriggerEvent("BigWigs_Message", L["summonwarriorwarn"], "Attention")
	end
end

function BigWigsGuardians:CheckPlague( msg )
	local _,_, player, type = string.find(msg, L["plaguetrigger"])
	if player and type then
		if self.db.profile.plagueyou and player == L["plagueyou"] and type == L["plagueare"] then
			self:TriggerEvent("BigWigs_Message", L["plaguewarnyou"], "Personal", true, "Long")
			self:TriggerEvent("BigWigs_Message", UnitName("player") .. L["plaguewarn"], "Attention", nil, nil, true )
		elseif self.db.profile.plagueother then
			self:TriggerEvent("BigWigs_Message", player .. L["plaguewarn"], "Attention")
			self:TriggerEvent("BigWigs_SendTell", player, L["plaguewarnyou"])
		end

		if self.db.profile.icon then
			self:TriggerEvent("BigWigs_SetRaidIcon", player)
		end
	end
end