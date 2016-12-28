------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Broodlord Lashlayer"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local Player = UnitName("player")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Broodlord",

	trigger1 = "^([^%s]+) ([^%s]+) afflicted by Mortal Strike",

	you = "You",
	are = "are",

	warn1 = "Mortal Strike on you!",
	warn2 = "Mortal Strike on %s!",

	youms_cmd = "youms",
	youms_name = "Mortal strike on you alert",
	youms_desc = "Warn when you get mortal strike",

	elsems_cmd = "elsems",
	elsems_name = "Mortal strike on others alert",
	elsems_desc = "Warn when someone else gets mortal strike",

	msbar_cmd = "msbar",
	msbar_name = "Mortal Strike bar",
	msbar_desc = "Shows a bar with the Mortal Strike duration",
} end )

L:RegisterTranslations("zhCN", function() return {
	trigger1 = "^(.+)受(.+)了致死打击",

	you = "你",
	are = "到",

	warn1 = "你中了致死打击！",
	warn2 = "%s中了致死打击！",

	youms_name = "玩家致死打击警报",
	youms_desc = "你中了致死打击时发出警报",

	elsems_name = "队友致死打击警报",
	elsems_desc = "队友中了致死打击时发出警报",

	msbar_name = "致死打击条",
	msbar_desc = "显示一条致死打击的持续时间",
} end )

L:RegisterTranslations("zhTW", function() return {
	-- Broodlord Lashlayer 勒西雷爾
	trigger1 = "^(.+)受到(.*)致死打擊",

	you = "你",
	are = "了",

	warn1 = "你中了致死打擊！",
	warn2 = "%s 中了致死打擊！",

	youms_name = "玩家致死打擊警報",
	youms_desc = "你中了致死打擊時發出警報",

	elsems_name = "隊友致死打擊警報",
	elsems_desc = "隊友中了致死打擊時發出警報",

	msbar_name = "致死打擊條",
	msbar_desc = "顯示一條致死打擊的持續時間",
} end )

L:RegisterTranslations("deDE", function() return {
	trigger1 = "^([^%s]+) ([^%s]+) von T\195\182dlicher Sto\195\159 betroffen",

	you = "Ihr",
	are = "seid",

	warn1 = "T\195\182dlicher Sto\195\159 auf Dir!",
	warn2 = "T\195\182dlicher Sto\195\159 auf %s!",

	youms_name = "T\195\182dlicher Sto\195\159 auf Dir",
	youms_desc = "Warnung, wenn Du von T\195\182dlicher Sto\195\159 betroffen bist.",

	elsems_name = "T\195\182dlicher Sto\195\159 auf X",
	elsems_desc = "Warnung, wenn andere Spieler von T\195\182dlicher Sto\195\159 betroffen sind.",

	msbar_name = "T\195\182dlicher Sto\195\159",
	msbar_desc = "Zeigt einen Anzeigebalken mit der Dauer des T\195\182dlichen Sto\195\159es.",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "^([^|;%s]*)(.*)죽음의 일격에 걸렸습니다%.$",

	you = "",
	are = "",

	warn1 = "당신은 죽음의 일격!",
	warn2 = "<<%s>> 죽음의 일격!",
	
	youms_name = "자신의 죽음의 일격 경고",
	youms_desc = "당신이 죽음의 일격에 걸렸을 때 경고",
	
	elsems_name = "타인의 죽음의 일격 경고",
	elsems_desc = "타인이 죽음의 일격에 걸렸을 때 경고",

	msbar_name = "죽음의 일격 바",
	msbar_desc = "죽음의 일격 주기 바 표시",
} end )

L:RegisterTranslations("frFR", function() return {
	-- trigger1 = "^([^%s]+) ([^%s]+) les effets de Frappe mortelle.",
	trigger1 = "Frappe mortelle DE Seigneur des couvées Lanistaire touche ([^%s]+)",

	you = "Vous",
	are = "subissez",

	warn1 = "Frappe mortelle sur toi !",
	warn2 = "Frappe mortelle : %s !",
	
	youms_name = "Alerte Frappe mortelle sur vous",
	youms_desc = "Pr\195\169viens quand vous \195\170tes touch\195\169 par la Frappe mortelle.",

	elsems_name = "Alerte Frappe mortelle sur les autres",
	elsems_desc = "Pr\195\169viens quand quelqu'un d'autre est touch\195\169 par la Frappe mortelle.",

	msbar_name = "Barre Frappe mortelle",
	msbar_desc = "Affiche une barre indiquant la dur\195\169e de la Frappe mortelle.",	
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsBroodlord = BigWigs:NewModule(boss)
BigWigsBroodlord.zonename = AceLibrary("Babble-Zone-2.2")["Blackwing Lair"]
BigWigsBroodlord.enabletrigger = boss
BigWigsBroodlord.toggleoptions = {"youms", "elsems", "msbar", "bosskill"}
BigWigsBroodlord.revision = tonumber(string.sub("$Revision: 16639 $", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsBroodlord:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "MortalStrike", 14)
	self:TriggerEvent("BigWigs_ThrottleSync", "MortalStrikeCD", 14)
	self:TriggerEvent("BigWigs_ThrottleSync", "KnockAway", 14)
	self:TriggerEvent("BigWigs_ThrottleSync", "BlastWave", 14)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsBroodlord:Event(msg)
	local _, _, EPlayer = string.find(msg, L["trigger1"])
	if EPlayer then
			self:TriggerEvent("BigWigs_SendSync", "MortalStrike "..EPlayer)
	end
	if string.find(msg, "Frappe mortelle") then
		self:TriggerEvent("BigWigs_SendSync", "MortalStrikeCD")
	elseif string.find(msg, "Repousser au loin") then
		self:TriggerEvent("BigWigs_SendSync", "KnockAway")
	elseif string.find(msg, "Vague explosive") then
		self:TriggerEvent("BigWigs_SendSync", "BlastWave")
	end
end

function BigWigsBroodlord:CHAT_MSG_MONSTER_YELL(msg)
	if string.find(msg, "Aucun membre de votre espèce ne devrait être ici. Vous vous êtes condamnés vous mêmes !") then
		self:TriggerEvent("BigWigs_StartBar", self, "~Prochaine Frappe Mortelle", 26, "Interface\\Icons\\Ability_Warrior_SavageBlow")
		self:TriggerEvent("BigWigs_StartBar", self, "~Prochaine Vague explosive", 15, "Interface\\Icons\\Spell_Holy_Excorcism_02")
	end
end

function BigWigsBroodlord:BigWigs_RecvSync(sync, rest)
	if (sync == "MortalStrike" and rest) then
		if rest == Player and self.db.profile.youms then
			self:TriggerEvent("BigWigs_Message", L["warn1"], "Personal", true, "Long")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["warn2"], UnitName("player")), 5, "Interface\\Icons\\Ability_Warrior_SavageBlow")
		elseif self.db.profile.elsems then
			self:TriggerEvent("BigWigs_Message", string.format(L["warn2"], rest), "Attention")
			self:TriggerEvent("BigWigs_StartBar", self, string.format(L["warn2"], rest), 5, "Interface\\Icons\\Ability_Warrior_SavageBlow")
		end
	elseif sync == "MortalStrikeCD" then
		self:ScheduleEvent("BigWigs_Message", 11, "Prochaine Frappe Mortelle dans ~5 secondes !", "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, "~Prochaine Frappe Mortelle", 16, "Interface\\Icons\\Ability_Warrior_SavageBlow")
	elseif sync == "KnockAway" then
		self:TriggerEvent("BigWigs_Message", "Repousser au loin !", "Attention")
		self:ScheduleEvent("BigWigs_Message", 11, "Prochain Repousser au loin dans ~5 secondes !", "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, "~Prochain Repousser au loin", 16, "Interface\\Icons\\Inv_Gauntlets_05")
	elseif sync == "BlastWave" then
		self:TriggerEvent("BigWigs_Message", "Vague explosive !", "Attention")
		self:ScheduleEvent("BigWigs_Message", 25, "Prochaine Vague explosive dans ~5 secondes !", "Urgent")
		self:TriggerEvent("BigWigs_StartBar", self, "~Prochaine Vague explo...", 30, "Interface\\Icons\\Spell_Holy_Excorcism_02")
	end
end