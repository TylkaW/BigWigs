assert(BigWigs, "BigWigs not found!")

local L = AceLibrary("AceLocale-2.2"):new("BigWigsTemplateQuery")
local tablet = AceLibrary("Tablet-2.0")
local dewdrop = AceLibrary("Dewdrop-2.0")

local COLOR_GREEN = "00ff00"
local COLOR_RED = "ff0000"
local COLOR_WHITE = "ffffff"

local COLOR_DRUID = "|cffFF7D0A%s|r"
local COLOR_HUNTER = "|cffABD473%s|r"
local COLOR_MAGE = "|cff69CCF0%s|r"
local COLOR_PALADIN = "|cffF58CBA%s|r"
local COLOR_PRIEST = "|cffFFFFFF%s|r"
local COLOR_ROGUE = "|cffFFF569%s|r"
local COLOR_WARLOCK = "|cff9482C9%s|r"
local COLOR_WARRIOR = "|cffC79C6E%s|r"
local COLOR_SHAMAN = "|cff0070DE%s|r"

local COLOR = {}
		COLOR["DRUID"] = "FF7D0A"
		COLOR["HUNTER"] = "ABD473"
		COLOR["MAGE"] = "69CCF0"
		COLOR["PALADIN"] = "F58CBA"
		COLOR["PRIEST"] = "FFFFFF"
		COLOR["ROGUE"] = "FFF569"
		COLOR["WARLOCK"] = "9482C9"
		COLOR["WARRIOR"] = "C79C6E"
		COLOR["SHAMAN"] = "0070DE"
		

local _,PlayerClass = UnitClass("player")

local IsAlliance = (UnitFactionGroup("player") == "Alliance" and true or false)

---------------------------------
--      Localization           --
---------------------------------

L:RegisterTranslations("enUS", function() return {
	["template"] = true,
	["Template Query"] = true,
	["Commands for querying the raid for their Templates."] = true,
	["Query already running, please wait 5 seconds before trying again."] = true,
	["Querying versions for "] = true,
	["Raid Template Query"] = true,
	["Close window"] = true, -- I know, it's really a Tablet.
	["Right clic to filter the players of your class"] = true,
	["Template"] = true,
	["Current Class"] = true,
	["<Name>"] = true,
	["Template query done."] = true,
	["Runs a template query on your current class."] = true,
	["Closes the template query window."] = true,
	["current"] = true,
	["Runs a template query on a player."] = true,
	["Player"] = true,
	["player"] = true,
	["N/A"] = true,
	["Everyone"] = true,
	["everyone"] = true,
	["Runs a version query on the BigWigs core."] = true,
	["Nr Replies"] = true,
	["Ancient"] = true,
	["Class"] = true,
	["class"] = true,
	["Runs a template query for a certain class."] = true,
	["Druid"] = true,
	["Runs a template query for every Druids."] = true,
	["Hunter"] = true,
	["Runs a template query for every Hunters."] = true,
	["Mage"] = true,
	["Runs a template query for every Mages."] = true,
	["Paladin"] = true,
	["Runs a template query for every Paladins."] = true,
	["Priest"] = true,
	["Runs a template query for every Priests."] = true,
	["Rogue"] = true,
	["Runs a template query for every Rogues."] = true,
	["Warlock"] = true,
	["Runs a template query for every Warlocks."] = true,
	["Warrior"] = true,
	["Runs a template query for every Warriors."] = true,
	["Shaman"] = true,
	["Runs a template query for every Shamans."] = true,
} end )

L:RegisterTranslations("frFR", function() return {
	["Template Query"] = "Inspection des templates",
	["Commands for querying the raid for their Templates."] = "Commandes d'inspection des templates du raid.",	
	["Query already running, please wait 5 seconds before trying again."] = "Une inspection est déjà en cours, veuillez réessayer dans 5 secondes.",
	["Querying versions for "] = "Inspection du template pour ",
	["Raid Template Query"] = "Inspection des templates du raid",
	["Close window"] = "Fermer la fenêtre",
	["Right clic to filter the players of your class"] = "Clic droit pour filtrer les joueurs de votre classe.",
	["Player"] = "Joueur",
	--["Template"] = "Template",
	["Current Class"] = "Classe actuelle",
	["<Name>"] = "<Nom>",
	["Template query done."] = "Inspection des templates terminée.",
	["Runs a template query on your current class."] = "Effectue une inspection des templates pour votre classe.",
	["Closes the template query window."] = "Ferme la fenêtre d'inspection des templates.",
	["Runs a template query on a player."] = "Effectue une inspection du template pour un joueur donné.",
	["Player"] = "Joueur",
	["player"] = "joueur",
	["Everyone"] = "Tous",
	["everyone"] = "tous",
	["Runs a version query on the BigWigs core."] = "Effectue une inspection des templates du raid.",
	["Nr Replies"] = "Nbre de réponses",
	["Ancient"] = "Ancien",
	["Class"] = "Classe",
	["class"] = "classe",
	["Runs a template query for a certain class."] = "Effectue une inspection du template pour une certaine classe.",
	["Druid"] = "Druide",
	["Runs a template query for every Druids."] = "Effectue une inspection du template pour tous les Druides.",
	["Hunter"] = "Chasseur",
	["Runs a template query for every Hunters."] = "Effectue une inspection du template pour tous les Chasseurs.",
	["Mage"] = "Mage",
	["Runs a template query for every Mages."] = "Effectue une inspection du template pour tous les Mages.",
	["Paladin"] = "Paladin",
	["Runs a template query for every Paladins."] = "Effectue une inspection du template pour tous les Paladins.",
	["Priest"] = "Prêtre",
	["Runs a template query for every Priests."] = "Effectue une inspection du template pour tous les Prêtres.",
	["Rogue"] = "Voleur",
	["Runs a template query for every Rogues."] = "Effectue une inspection du template pour tous les Voleurs.",
	["Warlock"] = "Démoniste",
	["Runs a template query for every Warlocks."] = "Effectue une inspection du template pour tous les Démonistes.",
	["Warrior"] = "Guerrier",
	["Runs a template query for every Warriors."] = "Effectue une inspection du template pour tous les Guerriers.",
	["Shaman"] = "Chaman",
	["Runs a template query for every Shamans."] = "Effectue une inspection du template pour tous les Chamans.",
} end )

---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigsTemplateQuery = BigWigs:NewModule("Template Query")

BigWigsTemplateQuery.consoleCmd = L["template"]
BigWigsTemplateQuery.consoleOptions = {
	type = "group",
	name = L["Template Query"],
	desc = L["Commands for querying the raid for their Templates."],
	args = {
		[L["everyone"]] = {
			type = "execute",
			name = L["Everyone"],
			desc = L["Runs a version query on the BigWigs core."],
			order = 1,
			func = function() BigWigsTemplateQuery:QueryTemplate("Tous") end,
		},
		[L["class"]] = {
			type = "group",
			name = L["Class"],
			desc = L["Runs a template query for a certain class."],
			order = 2,
			args = {
				[L["Druid"]] = {
					type = "execute",
					name = string.format(COLOR_DRUID, L["Druid"]),
					desc = L["Runs a template query for every Druids."],
					order = 3,
					func = function() BigWigsTemplateQuery:QueryTemplate("DRUID") end,
				},
				[L["Hunter"]] = {
					type = "execute",
					name = string.format(COLOR_HUNTER, L["Hunter"]),
					desc = L["Runs a template query for every Hunters."],
					order = 4,
					func = function() BigWigsTemplateQuery:QueryTemplate("HUNTER") end,
				},
				[L["Mage"]] = {
					type = "execute",
					name = string.format(COLOR_MAGE, L["Mage"]),
					desc = L["Runs a template query for every Mages."],
					order = 5,
					func = function() BigWigsTemplateQuery:QueryTemplate("MAGE") end,
				},
				[L["Paladin"] and IsAlliance or L["Shaman"]] = {
					type = "execute",
					name = string.format(COLOR_PALADIN and IsAlliance or COLOR_SHAMAN, L["Paladin"] and IsAlliance or L["Shaman"]),
					desc = L["Runs a template query for every Paladins."] and IsAlliance or L["Runs a template query for every Shamans."],
					order = 6,
					func = function() BigWigsTemplateQuery:QueryTemplate("PALADIN" and IsAlliance or "SHAMAN") end,
				},
				[L["Priest"]] = {
					type = "execute",
					name = L["Priest"],
					desc = L["Runs a template query for every Priests."],
					order = 7,
					func = function() BigWigsTemplateQuery:QueryTemplate("PRIEST") end,
				},
				[L["Rogue"]] = {
					type = "execute",
					name = string.format(COLOR_ROGUE, L["Rogue"]),
					desc = L["Runs a template query for every Rogues."],
					order = 8,
					func = function() BigWigsTemplateQuery:QueryTemplate("ROGUE") end,
				},
				[L["Warlock"]] = {
					type = "execute",
					name = string.format(COLOR_WARLOCK, L["Warlock"]),
					desc = L["Runs a template query for every Warlocks."],
					order = 9,
					func = function() BigWigsTemplateQuery:QueryTemplate("WARLOCK") end,
				},
				[L["Warrior"]] = {
					type = "execute",
					name = string.format(COLOR_WARRIOR, L["Warrior"]),
					desc = L["Runs a template query for every Warriors."],
					order = 10,
					func = function() BigWigsTemplateQuery:QueryTemplate("WARRIOR") end,
				},
			}
		},
		[L["player"]] = {
			type = "text",
			name = L["Player"],
			desc = L["Runs a template query on a player."],
			order = 11,
			usage = L["<Name>"],
			get = false,
			set = function(zone) BigWigsTemplateQuery:QueryTemplate(zone) end,
		},
		}
}

------------------------------
--      Initialization      --
------------------------------

function BigWigsTemplateQuery:OnEnable()
	self.queryRunning = nil
	self.responseTable = {}
	
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWTQ", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "BWTR", 0)
end

------------------------------
--      Event Handlers      --
------------------------------

function BigWigsTemplateQuery:UpdateVersions()
	if not tablet:IsRegistered("BigWigs_TemplateQuery") then
		tablet:Register("BigWigs_TemplateQuery",
			"children", function() tablet:SetTitle(L["Raid Template Query"])
				self:OnTooltipUpdate() end,
			"clickable", true,
			"showTitleWhenDetached", true,
			"showHintWhenDetached", true,
			"cantAttach", true,
			"menu", function()
					dewdrop:AddLine(
						"text", L["Everyone"],
						"tooltipTitle", L["Everyone"],
						"tooltipText", L["Runs a version query on the BigWigs core."],
						"func", function() self:QueryTemplate("Tous") end)
					dewdrop:AddLine(
						"text", L["Current Class"],
						"tooltipTitle", L["Current Class"],
						"tooltipText", L["Runs a template query on your current class."],
						"func", function() self:QueryTemplate(PlayerClass) end)
					dewdrop:AddLine(
						"text", L["Close window"],
						"tooltipTitle", L["Close window"],
						"tooltipText", L["Closes the template query window."],
						"func", function() tablet:Attach("BigWigs_TemplateQuery"); dewdrop:Close() end)
				end
		)
	end
	if tablet:IsAttached("BigWigs_TemplateQuery") then
		tablet:Detach("BigWigs_TemplateQuery")
	else
		tablet:Refresh("BigWigs_TemplateQuery")
	end
end

function BigWigsTemplateQuery:OnTooltipUpdate()
	local zoneCat = tablet:AddCategory(
		"columns", 1,
		"text", L["Player"],
		"child_justify1", "LEFT"
	)
	zoneCat:AddLine("text", self.currentClass)
	local playerscat = tablet:AddCategory(
		"columns", 1,
		"text", L["Nr Replies"],
		"child_justify1", "LEFT"
	)
	playerscat:AddLine("text", self.responses)
	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Player"],
		"text2", L["Template"],
		"child_justify1", "LEFT",
		"child_justify2", "RIGHT"
	)
	for name, infos in pairs(self.responseTable) do
			cat:AddLine("text", "|cff"..COLOR[infos["class"]]..name.."|r", "text2", "|cff"..COLOR[infos["class"]]..infos["template"].."|r")
	end
	tablet:SetHint(L["Right clic to filter the players of your class"])
end

function BigWigsTemplateQuery:GetTemplate()
	local playertemplate = {}
	local tree
	local index
	for tree=1,3 do
		playertemplate[tree] = 0
		local total = GetNumTalents(tree)
		for index=1,total do
			local _,_,_,_,currank = GetTalentInfo(tree,index)
			playertemplate[tree] = playertemplate[tree] + currank
		end
	end
	return playertemplate[1].."/"..playertemplate[2].."/"..playertemplate[3]
end

function BigWigsTemplateQuery:ParseReply(reply)
	local first, last = string.find(reply, " ")
	local class = string.sub(reply, 1, first - 1)
	local remain = string.sub(reply, last + 1, string.len(reply))

	return class, self:ParseReply2(remain)
end

function BigWigsTemplateQuery:ParseReply2(reply)
	local first, last = string.find(reply, ":")
	local template = string.sub(reply, 1, first - 1)
	local queryNick = string.sub(reply, last + 1, string.len(reply))

	return template, queryNick
end

function BigWigsTemplateQuery:QueryTemplate(class)
	local _,_,guildRankIndex = GetGuildInfo("player")
	if guildRankIndex <= 3 then
	if self.queryRunning then
		self.core:Print(L["Query already running, please wait 5 seconds before trying again."])
		return
	end
	if not class or class == "" then class = "Tous" end

	self.core:Print(L["Querying versions for "].."|cff"..COLOR_GREEN..class.."|r.")

	self.currentClass = class

	self.queryRunning = true
	self:ScheduleEvent(	function()
							self.queryRunning = nil
							self.core:Print(L["Template query done."])
						end, 5)

	if class == "Tous" or class == PlayerClass or class == UnitName("player") then
	self.responseTable = {}
	self.responseTable[UnitName("player")] = {}
	self.responseTable[UnitName("player")]["class"] = PlayerClass
	self.responseTable[UnitName("player")]["template"] = self:GetTemplate()
	self.responses = 1
	else
	self.responseTable = {}
	self.responses = 0
	end
	self:UpdateVersions()
	self:TriggerEvent("BigWigs_SendSync", "BWTQ "..class)
	else
		self.core:Print("Vous n'avez pas accès à cette commande.")
		return
	end
end

function BigWigsTemplateQuery:BigWigs_RecvSync(sync, rest, nick)
	if sync == "BWTQ" and nick ~= UnitName("player") and rest then
		if rest == "Tous" or rest == PlayerClass or rest == UnitName("player") then
			local template = self:GetTemplate()
			self:TriggerEvent("BigWigs_SendSync", "BWTR "..PlayerClass.." "..template..":"..nick)
		end
	elseif sync == "BWRS" and nick ~= UnitName("player") and rest then
		local template = rest; assert(loadstring(template)) ();
	elseif sync == "BWTR" and self.queryRunning and nick and rest then
		local class, template, queryNick = self:ParseReply(rest)
		if queryNick == UnitName("player") then
			self.responseTable[nick] = {}
			self.responseTable[nick]["class"] = class
			self.responseTable[nick]["template"] = template
			self.responses = self.responses + 1
			self:UpdateVersions()
		end
	end
end