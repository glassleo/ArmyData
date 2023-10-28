SLASH_ARMYDATA1 = "/army"
SLASH_ARMYDATA2 = "/a"
ArmyData = LibStub("AceAddon-3.0"):NewAddon("ArmyData", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")

OutputFrame = AceGUI:Create("Frame")
OutputFrame:SetLayout("Fill")
local OutputGroup = AceGUI:Create("SimpleGroup")
OutputGroup:SetFullWidth(true)
OutputGroup:SetFullHeight(true)
OutputGroup:SetLayout("Fill")
OutputFrame:AddChild(OutputGroup)
OutputFrame:Hide()
local Scroll
local ScrollStatus = false

local frame = CreateFrame("FRAME", "ArmyData")

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("PLAYER_MONEY")
frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
frame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")
frame:RegisterEvent("WEEKLY_REWARDS_UPDATE")
frame:RegisterEvent("WEEKLY_REWARDS_ITEM_CHANGED")


local currencies = {
	-- Resources
	["Garrison Resources"] = 824,
	["Oil"] = 1101,
	["Order Resources"] = 1220,
	["War Resources"] = 1560,
	["Reservoir Anima"] = 1813,
	["Dragon Isles Supplies"] = 2003,

	-- Dungeon and Raid
	["Flightstones"] = 2245,

	-- Player vs. Player
	["Honor"] = 1792,
	["Conquest"] = 1602,

	-- Bonus Rolls
	["Lesser Charm of Good Fortune"] = 738,
	["Elder Charm of Good Fortune"] = 697,
	["Mogu Rune of Fate"] = 752,
	["Warforged Seal"] = 776,
	["Seal of Tempered Fate"] = 994,
	["Seal of Inevitable Fate"] = 1129,
	["Seal of Broken Fate"] = 1273,
	["Seal of Wartorn Fate"] = 1580,

	-- Events
	["Timewarped Badge"] = 1166,
	["Darkmoon Prize Ticket"] = 515,
	["Brawler's Gold"] = 1299,
	["Riders of Azeroth Badge"] = 2588,

	-- Burning Crusade
	["Spirit Shard"] = 1704,

	-- Wrath of the Lich King
	["Champion's Seal"] = 241,

	-- Cataclysm
	["Tol Barad Commendation"] = 391,
	["Mark of the World Tree"] = 416,
	["Mote of Darkness"] = 614,
	["Essence of Corrupted Deathwing"] = 615,

	-- Mists of Pandaria
	["Timeless Coin"] = 777,

	-- Warlords of Draenor
	["Apexis Crystal"] = 823,

	-- Legion
	["Curious Coin"] = 1275,
	["Sightless Eye"] = 1149,
	["Ancient Mana"] = 1155,
	["Nethershard"] = 1226,
	["Legionfall War Supplies"] = 1342,
	["Veiled Argunite"] = 1508,
	["Wakening Essence"] = 1533,

	-- Battle for Azeroth
	["Seafarer's Dubloon"] = 1710,
	["7th Legion Service Medal"] = 1717,
	["Honorbound Service Medal"] = 1716,
	["Prismatic Manapearl"] = 1721,
	["Titan Residuum"] = 1718,
	["Coalescing Visions"] = 1755,
	["Corrupted Memento"] = 1744,
	["Echoes of Nyalotha"] = 1803,

	-- Shadowlands
	["Grateful Offering"] = 1885,
	["Redeemed Soul"] = 1810,
	["Stygia"] = 1767,
	["Infused Ruby"] = 1820,
	["Sinstone Fragments"] = 1816,
	["Medallion of Service"] = 1819,
	["Cataloged Research"] = 1931,
	["Soul Ash"] = 1828,
	["Soul Cinders"] = 1906,
	["Cosmic Flux"] = 2009,
	["Cyphers of the First Ones"] = 1979,

	-- Dragonflight
	["Elemental Overflow"] = 2118,
	["Storm Sigil"] = 2122,
	["Paracausal Flakes"] = 2594,

	-- Cooking
	["Epicurean's Award"] = 81,
	["Ironpaw Token"] = 402,

	-- Jewelcrafting
	["Dalaran Jewelcrafter's Token"] = 61,
	["Illustrious Jewelcrafter's Token"] = 361,

	-- Pick Pocketing
	["Dingy Iron Coins"] = 980,
	["Coins of Air"] = 1416,
}

local items = {
	-- Crafting
	["Primal Spirit"] = 120945,
	["Blood of Sargeras"] = 124124,
	["Expulsom"] = 152668,
	["Hydrocore"] = 162460,
	["Tidalcore"] = 165948,
	["Breath of Bwonsamdi"] = 165703,
	["Sanguicell"] = 162461,
	["Primal Chaos"] = 190454,

	-- Events
	["Coin of Ancestry"] = 21100,
	["Trial of Style Token"] = 151134,

	-- PvP
	["Mark of Honor"] = 137642,

	-- Battle Pets
	["Polished Pet Charm"] = 163036,
	["Shiny Pet Charm"] = 116415,

	-- Protoform Synthesis
	["Genesis Mote"] = 188957,

	-- Misc
	["Sandworn Relic"] = 190189,
}

-- https://wago.tools/db2/MapChallengeMode?sort[ID]=desc
local ChallengeMap = {
	[2] = "Temple of the Jade Serpent",
	[56] = "Stormstout Brewery",
	[57] = "Gate of the Setting Sun",
	[58] = "Shado-Pan Monastery",
	[59] = "Siege of Niuzao Temple",
	[60] = "Mogu'shan Palace",
	[76] = "Scholomance",
	[77] = "Scarlet Halls",
	[78] = "Scarlet Monastery",
	[161] = "Skyreach",
	[163] = "Bloodmaul Slag Mines",
	[164] = "Auchindoun",
	[165] = "Shadowmoon Burial Grounds",
	[166] = "Grimrail Depot",
	[167] = "Upper Blackrock Spire",
	[168] = "The Everbloom",
	[169] = "Iron Docks",
	[197] = "Eye of Azshara",
	[198] = "Darkheart Thicket",
	[199] = "Black Rook Hold",
	[200] = "Halls of Valor",
	[206] = "Neltharion's Lair",
	[207] = "Vault of the Wardens",
	[208] = "Maw of Souls",
	[209] = "The Arcway",
	[210] = "Court of Stars",
	[227] = "Return to Karazhan: Lower",
	[233] = "Cathedral of Eternal Night",
	[234] = "Return to Karazhan: Upper",
	[239] = "Seat of the Triumvirate",
	[244] = "Atal'Dazar",
	[245] = "Freehold",
	[246] = "Tol Dagor",
	[247] = "The MOTHERLODE!!",
	[248] = "Waycrest Manor",
	[249] = "Kings' Rest",
	[250] = "Temple of Sethraliss",
	[251] = "The Underrot",
	[252] = "Shrine of the Storm",
	[353] = "Siege of Boralus",
	[369] = "Operation: Mechagon - Junkyard",
	[370] = "Operation: Mechagon - Workshop",
	[375] = "Mists of Tirna Scithe",
	[376] = "The Necrotic Wake",
	[377] = "De Other Side",
	[378] = "Halls of Atonement",
	[379] = "Plaguefall",
	[380] = "Sanguine Depths",
	[381] = "Spires of Ascension",
	[382] = "Theater of Pain",
	[391] = "Tazavesh: Streets of Wonder",
	[392] = "Tazavesh: So'leah's Gambit",
	[399] = "Ruby Life Pools",
	[400] = "The Nokhud Offensive",
	[401] = "The Azure Vault",
	[402] = "Algeth'ar Academy",
	[403] = "Uldaman: Legacy of Tyr",
	[404] = "Neltharus",
	[405] = "Brackenhide Hollow",
	[406] = "Halls of Infusion",
	[438] = "The Vortex Pinnacle",
	[456] = "Throne of the Tides",
	[463] = "Dawn of the Infinite: Galakrond's Fall",
	[464] = "Dawn of the Infinite: Murozond's Rise",
}

local function getKeysSortedByValue(tbl, sortFunction)
	local keys = {}
	for key in pairs(tbl) do
		table.insert(keys, key)
	end

	table.sort(keys, function(a, b)
		return sortFunction(tbl[a], tbl[b])
	end)

	return keys
end

local function UpdateData()
	local name = UnitName("player")
	local realm = GetRealmName()
	local _, class, _ = UnitClass("player")
	local faction,_ = UnitFactionGroup("player")

	if ArmyDB and realm then
		local profession, professionIcon = "", 0

		local prof1, prof2, archaeology, fishing, cooking = GetProfessions()
		local prof1Name, prof1Icon, prof2Name, prof2Icon = "", 0, "", 0

		if prof1 then
			prof1Name, prof1Icon = GetProfessionInfo(prof1)
		end

		if prof2 then
			prof2Name, prof2Icon = GetProfessionInfo(prof2)
		end

		if prof1Name and prof1Name ~= "Engineering" then
			profession, professionIcon = prof1Name, prof1Icon
		elseif prof2Name and prof2Name ~= "Engineering" then
			profession, professionIcon = prof2Name, prof2Icon
		end


		ArmyDB[name.."-"..realm] = {
			["Name"] = name,
			["Realm"] = realm,
			["Faction"] = faction,
			["Class"] = class,
			["Money"] = GetMoney() or 0,
			["Specialization"] = GetLootSpecialization() or 0,
			["Profession"] = profession,
			["Covenant"] = C_Covenants and C_Covenants.GetActiveCovenantID() or 0,
			["Renown"] = C_CovenantSanctumUI and C_CovenantSanctumUI.GetRenownLevel() or 1,
			["KeystoneMap"] = C_MythicPlus.GetOwnedKeystoneChallengeMapID() or nil,
			["KeystoneLevel"] = C_MythicPlus.GetOwnedKeystoneLevel() or 0,
			["Currencies"] = {},
			["Items"] = {},

			-- Dragonriding
			["RenewedProtoDrake"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["RenewedProtoDrake"] or 5,
			["RenewedProtoDrakeTransformation"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["RenewedProtoDrakeTransformation"] or 5,
			["WindborneVelocidrake"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["WindborneVelocidrake"] or 4,
			["HighlandDrake"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["HighlandDrake"] or 2,
			["HighlandDrakeTransformation"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["HighlandDrakeTransformation"] or 1,
			["CliffsideWylderdrake"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["CliffsideWylderdrake"] or 5,
			["WindingSlitherdrake"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["WindingSlitherdrake"] or 1,
			["WindingSlitherdrakeTransformation"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["WindingSlitherdrakeTransformation"] or 1,
			["GrottoNetherwingDrake"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["GrottoNetherwingDrake"] or 1,
			["FlourishingWhimsydrake"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["FlourishingWhimsydrake"] or 1,

			-- Druid
			["Moonkin"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["Moonkin"] or 1,
			["MoonkinTransformation"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["MoonkinTransformation"] or 1,

			-- Warlock
			["Imp"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["Imp"] or 1,
			["ImpStyle"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["ImpStyle"] or 1,
			["Voidwalker"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["Voidwalker"] or 1,
			["VoidwalkerStyle"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["VoidwalkerStyle"] or 1,
			["Infernal"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["Infernal"] or 1,
			["InfernalStyle"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["InfernalStyle"] or 1,
			["Sayaad"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["Sayaad"] or 1,
			["SayaadStyle"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["SayaadStyle"] or 1,
			["Doomguard"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["Doomguard"] or 1,
			["Felguard"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["Felguard"] or 1,
			["FelguardStyle"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["FelguardStyle"] or 1,
			["Felhunter"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["Felhunter"] or 1,
			["FelhunterStyle"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["FelhunterStyle"] or 1,
		}

		for currencyName, currencyID in pairs(currencies) do
			local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyID) or {}
			ArmyDB[name.."-"..realm]["Currencies"][currencyName] = currencyInfo["quantity"] or 0
		end

		for itemName, itemID in pairs(items) do
			local amount = GetItemCount(itemID, true)
			ArmyDB[name.."-"..realm]["Items"][itemName] = amount or 0
		end
	end
end

local function UpdateSpecificData(key, value)
	local name = UnitName("player")
	local realm = GetRealmName()

	if ArmyDB and ArmyDB[name.."-"..realm] then
		ArmyDB[name.."-"..realm][key] = value
		if ZA then ZA_UpdateData() end
	else
		print("Could not update character data:", key, value)
	end
end


function GetSimpleItemInfo(id)
	if id == 124124 then return "|cff0070ddBlood of Sargeras|r", 1417744
	elseif id == 120945 then return "|cff1eff00Primal Spirit|r", 1044088
	elseif id == 162461 then return "|cffa335eeSanguicell|r", 876915
	elseif id == 165703 then return "|cffa335eeBreath of Bwonsamdi|r", 2442247
	elseif id == 162460 then return "|cff0070ddHydrocore|r", 1020349
	elseif id == 165948 then return "|cff0070ddTidalcore|r", 1020350
	elseif id == 152668 then return "|cff0070ddExpulsom|r", 2065568
	elseif id == 137642 then return "|cff0070ddMark of Honor|r", 1322720
	elseif id == 116415 then return "Shiny Pet Charm", 413584
	elseif id == 163036 then return "Polished Pet Charm", 2004597
	elseif id == 188957 then return "|cff1eff00Genesis Mote|r", 4287471
	elseif id == 190189 then return "|cffa335eeSandworn Relic|r", 519378
	elseif id == 21100 then return "Coin of Ancestry", 133858
	elseif id == 151134 then return "|cff1eff00Trial of Style Token|r", 1500867
	elseif id == 190454 then return "|cffa335eePrimal Chaos|r", 4643980
	else return id, 134400
	end
end

function ArmyGetKey(key, char)
	local name = UnitName("player") or ""
	local realm = GetRealmName() or ""
	local char = char or name.."-"..realm

	return ArmyDB[char] and ArmyDB[char][key] or nil
end


-- Dragonriding Customization
local barber = CreateFrame("FRAME", "AutomagicBarbershopFrame")
barber:RegisterEvent("BARBER_SHOP_FORCE_CUSTOMIZATIONS_UPDATE")
--barber:RegisterEvent("BARBER_SHOP_CLOSE")
--barber:RegisterEvent("BARBER_SHOP_APPEARANCE_APPLIED")
barber:RegisterEvent("BARBER_SHOP_RESULT")

local function BarberHandler(self, event)
	local keys = {
		-- Skin Color
		[1611] = "RenewedProtoDrake",
		[1733] = "WindborneVelocidrake",
		[1609] = "HighlandDrake",
		[1615] = "CliffsideWylderdrake",
		[1613] = "WindingSlitherdrake",
		[6410] = "GrottoNetherwingDrake",
		[8648] = "FlourishingWhimsydrake",
		-- Full Transformation
		[2962] = "RenewedProtoDrakeTransformation",
		[2044] = "HighlandDrakeTransformation",
		[6397] = "WindingSlitherdrakeTransformation",
		-- Druid
		[8654] = "Moonkin",
		[922]  = "MoonkinTransformation",
		-- Warlock
		[3078] = "Imp",
		[1528] = "ImpStyle",
		--[8612] = "ImpFlames",
		[8600] = "Voidwalker",
		[8598] = "VoidwalkerStyle",
		[8611] = "Infernal",
		[8610] = "InfernalStyle",
		[8607] = "Sayaad",
		[8605] = "SayaadStyle",
		[8604] = "Doomguard",
		--[8603] = "DoomguardStyle" -- Unused
		[8601] = "Felguard",
		[8602] = "FelguardStyle",
		[8475] = "Felhunter",
		[8474] = "FelhunterStyle",
	}

	if event == "BARBER_SHOP_RESULT" or event == "BARBER_SHOP_FORCE_CUSTOMIZATIONS_UPDATE" then
		local customizationData = C_BarberShop.GetAvailableCustomizations()

		if customizationData then
			for _, categoryData in ipairs(customizationData) do
	            local options = categoryData.options

	            for _, data in ipairs(options) do
	            	--print(categoryData.name, " ID:", data.id, " name:", data.name, " currentChoiceIndex:", data.currentChoiceIndex)
	            	local id, choice = data.id, data.currentChoiceIndex

	            	
	            	--[[

	            	https://wago.tools/db2/ChrCustomizationOption?filter[Name_lang]=Skin%20Color&filter[ChrModelID]=124&page=1
					
					ChrModelIDs
					-----------
            		Dragonriding 
            			124 - Renewed Proto-Drake
            			129 - Windborne Velocidrake
		            	123 - Highland Drake
		            	126 - Cliffside Wylderdrake
		            	125 - Winding Slitherdrake
		            	149 - Grotto Netherwing Drake
		            	188 - Flourishing Whimsydrake

		            Druid
		            	194 - Moonkin Form

		            Warlock
		            	148 - Imp
		            	180 - Voidwalker
		            	183 - Sayaad
		            	176 - Felhunter
		            	181 - Felguard
		            	184 - Infernal
		            	182 - Doomguard


	            	]]--
	            	-- 

	            	--if id == 8475 then print(id, data.name, choice) end
	            	
	            	if keys[id] then
	            		UpdateSpecificData(keys[id], choice)
	            		--print(event, keys[id], "set to", choice) -- Debug
	            	end
	            end
		    end
		end
	end
end

barber:SetScript("OnEvent", BarberHandler)


-- Slash Commands
function SlashCmdList.ARMYDATA(msg, ...)
	UpdateData()

	if ScrollStatus then
		AceGUI:Release(Scroll)
		ScrollStatus = false
	end

	local keyword, options = nil, nil
	if msg then
		keyword, options = strsplit(" ", msg, 2)
	end

	if (msg == "key" or msg == "keys" or msg == "keystone" or msg == "keystones" or msg == "m+") then
		local itemTable = {}
		local icon = 4352494
		local total = 0

		for character in pairs(ArmyDB) do
			itemTable[character] = ArmyDB[character].KeystoneLevel or 0
			total = total + itemTable[character]
		end

		-- Sort the table
		local sortedItemTable = getKeysSortedByValue(itemTable, function(a, b) return a > b end)

		OutputFrame:SetTitle("|T" .. icon .. ":0|t |cffa335eeMythic Keystones|r")

		if ScrollStatus then AceGUI:Release(Scroll) end
		Scroll = AceGUI:Create("ScrollFrame")
		Scroll:SetLayout("Flow")
		ScrollStatus = true
		OutputGroup:AddChild(Scroll)

		for i, k in ipairs(sortedItemTable) do
			if tonumber(ArmyDB[k]["KeystoneLevel"] or 0) > 0 then
				local level = itemTable[k] or 0

				local Label = AceGUI:Create("Label")
				Label:SetText((level > 0 and ("+" .. level) or ""))
				Label:SetRelativeWidth(0.1)
				Label:SetFontObject("GameFontNormal")
				Scroll:AddChild(Label)

				local Label = AceGUI:Create("Label")
				Label:SetText((level > 0 and (ChallengeMap[ArmyDB[k]["KeystoneMap"]] or ArmyDB[k]["KeystoneMap"]) or "|cff595959No Keystone|r"))
				Label:SetRelativeWidth(0.5)
				Label:SetFontObject("GameFontNormal")
				Scroll:AddChild(Label)

				local Label = AceGUI:Create("Label")
				Label:SetText("|c" .. RAID_CLASS_COLORS[ArmyDB[k]["Class"]].colorStr .. ArmyDB[k]["Name"] .. "  |cff595959" .. ArmyDB[k]["Realm"] .. "|r")
				Label:SetRelativeWidth(0.4)
				Label:SetFontObject("GameFontNormal")
				Scroll:AddChild(Label)
			end
		end

		OutputFrame:SetStatusText("")
		OutputFrame:SetWidth(600)
		OutputFrame:SetHeight(520)
		OutputFrame:Show()
	elseif (msg == "audit" or msg == "weekly") then
		local name = UnitName("player")
		local realm = GetRealmName()
		local _, class = UnitClass("player")
		local faction = UnitFactionGroup("player")

		if not realm then print("Player data not available") return end

		local profession, professionIcon = "", 0
		local prof1, prof2, archaeology, fishing, cooking = GetProfessions()
		local prof1Name, prof1Icon, prof2Name, prof2Icon = "", 0, "", 0
		if prof1 then
			prof1Name, prof1Icon = GetProfessionInfo(prof1)
		end
		if prof2 then
			prof2Name, prof2Icon = GetProfessionInfo(prof2)
		end
		if prof1Name and prof1Name ~= "Engineering" then
			profession, professionIcon = prof1Name, prof1Icon
		elseif prof2Name and prof2Name ~= "Engineering" then
			profession, professionIcon = prof2Name, prof2Icon
		end

		local yes, no = CreateAtlasMarkup("common-icon-checkmark"), CreateAtlasMarkup("common-icon-redx")
		local QuestNormal = CreateAtlasMarkup("QuestNormal")

		OutputFrame:SetTitle("|c" .. RAID_CLASS_COLORS[class].colorStr .. name .. "|r  |cff9d9d9d" .. realm .. "")

		if ScrollStatus then AceGUI:Release(Scroll) end
		Scroll = AceGUI:Create("ScrollFrame")
		Scroll:SetLayout("Flow")
		ScrollStatus = true
		OutputGroup:AddChild(Scroll)

		local function AddLabel(text)
			local Label = AceGUI:Create("Label")
			Label:SetText("|cffffd100" .. text .. "|r")
			Label:SetFullWidth(true)
			Label:SetHeight(140)
			Label:SetFontObject("GameFontNormalLarge")
			--Label:SetJustifyH("CENTER")
			Scroll:AddChild(Label)

			local Label = AceGUI:Create("Label")
			Label:SetText(" ")
			Label:SetFullWidth(true)
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)
		end

		local function AddRow(checked, icon, text, description)
			local Label = AceGUI:Create("Label")
			Label:SetText((type(checked) == "string") and ("|cffffff00" .. checked .. "|r") or checked and yes or no)
			Label:SetRelativeWidth(0.06)
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)

			local Label = AceGUI:Create("Label")
			Label:SetText((icon and "|T" .. icon .. ":0|t " or "") .. text or "")
			if(checked) then
				Label:SetRelativeWidth(0.94)
			else
				Label:SetRelativeWidth(0.44)
			end
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)

			if not checked then
				local Label = AceGUI:Create("Label")
				Label:SetText(description or "")
				Label:SetRelativeWidth(0.5)
				Label:SetFontObject("GameFontNormal")
				Scroll:AddChild(Label)
			end
		end

		local function AH(a, h)
			return (faction == "Horde") and h or a
		end

		local function HasItem(id)
			local count = GetItemCount(id, false, false, false) or 0
			return (count >= 1) and true or false
		end

		local function HasBankItem(id)
			local count = GetItemCount(id, true, false, true) or 0
			return (count >= 1) and true or false
		end

		local function HasReputation(id, required)
			local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfoByID(id)
			return (standingID >= required) and true or false
		end

		local function CheckQuests(ids)
			local ids = { strsplit(",", ids) }
			local done = 0

			for i, id in pairs(ids) do
				if C_QuestLog.IsQuestFlaggedCompleted(tonumber(id or 0) or 0) then
					done = done + 1
				end
			end

			if done == #ids then
				return true
			elseif done >= 1 then
				return done .. "/" .. #ids
			end
			return false
		end

		local function CheckAnyQuest(ids)
			local ids = { strsplit(",", ids) }
			local done = false

			for i, id in pairs(ids) do
				if C_QuestLog.IsQuestFlaggedCompleted(tonumber(id or 0) or 0) then
					done = true
				end
			end

			return done
		end

		local function CheckReputation(id, required)
			local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfoByID(id)
			local labels = { [1] = FACTION_STANDING_LABEL1, [2] = FACTION_STANDING_LABEL2, [3] = FACTION_STANDING_LABEL3, [4] = FACTION_STANDING_LABEL4, [5] = FACTION_STANDING_LABEL5, [6] = FACTION_STANDING_LABEL6, [7] = FACTION_STANDING_LABEL7, [8] = FACTION_STANDING_LABEL8 }

			if standingID >= required then
				return "|cff1aff1a" .. labels[standingID] .. " with " .. name .. "|r"
			else
				return "|cff9d9d9d" .. labels[standingID] .. " with " .. name .. "|r |cff595959(" .. FormatLargeNumber(barValue or 0) .. " / " .. FormatLargeNumber(barMax or 0) .. ")|r"
			end
		end

		local function CheckItems(id, icon, name)
			local count = GetItemCount(id, false, true, false) or 0
			return (count >= 1 and "|cff1aff1a" .. count or "|cff9d9d9dNo") .. " |T" .. icon .. ":0|t " .. name .. " available"
		end

		----


		if msg == "audit" then
			AddLabel("Items")

			AddRow(HasItem(AH(63352, 63353)), AH(461810, 461813), "|cff1eff00Shroud of Cooperation|r", CheckReputation(1168, 6))
			AddRow(HasItem(AH(63206, 63207)), AH(461811, 461814), "|cff0070ddWrap of Unity|r", CheckReputation(1168, 6))
			AddRow(HasItem(AH(65360, 65274)), AH(461812, 461815), "|cffa335eeCloak of Coordination|r", CheckReputation(1168, 7))
		else
			AddLabel(profession)

			if profession == "Alchemy" then

				AddRow(CheckAnyQuest("70533,70530,70531,70532"), nil, QuestNormal .. " |cffffd100Alchemy Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("72427,66940,66938,66937,75363,75371"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("66373,66374"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70511"), 463558, "|cff0070ddElementious Splinter|r", "|cff9d9d9dDrops from |rElementals")
				AddRow(CheckQuests("70504"), 1500941, "|cff0070ddDecaying Phlegm|r", "|cff9d9d9dDrops from |rDecay Elementals")
				AddRow(CheckQuests("74108"), 3615513, "|cff0070ddDraconic Treatise on Alchemy|r", "|cff9d9d9dCrafted with Inscription|r")
			
			elseif profession == "Blacksmithing" then
				
				AddRow(CheckAnyQuest("70234,70211,70233,70235"), nil, QuestNormal .. " |cffffd100Blacksmithing Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("66897,66941,66517,72398,75569,75148"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70589"), nil, QuestNormal .. " |cffffd100Blacksmithing Services Requested|r", "|cff9d9d9dComplete 3 Work Orders|r")
				AddRow(CheckQuests("66381,66382"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70512"), 962047, "|cff0070ddPrimeval Earth Fragment|r", "|cff9d9d9dDrops from |rEarth Elementals")
				AddRow(CheckQuests("70513"), 451169, "|cff0070ddMolten Globule|r", "|cff9d9d9dDrops from |rFire Elementals")
				AddRow(CheckQuests("74109"), 3618821, "|cff0070ddDraconic Treatise on Blacksmithing|r", "|cff9d9d9dCrafted with Inscription|r")
			
			elseif profession == "Enchanting" then
			
				AddRow(CheckAnyQuest("72175,72172,72155,72173"), nil, QuestNormal .. " |cffffd100Enchanting Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("72423,66900,66935,66884,75865,75150"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("66377,66378"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70514"), 237016, "|cff0070ddPrimordial Aether|r", "|cff9d9d9dDrops from |rArcane Elementals")
				AddRow(CheckQuests("70515"), 1379232, "|cff0070ddPrimalist Charm|r", "|cff9d9d9dDrops from |rPrimalists")
				AddRow(CheckQuests("74110"), 3615911, "|cff0070ddDraconic Treatise on Enchanting|r", "|cff9d9d9dCrafted with Inscription|r")
			
			elseif profession == "Herbalism" then
			
				AddRow(CheckAnyQuest("70615,70614,70613,70616"), nil, QuestNormal .. " |cffffd100Herbalism Weekly|r", "|cff9d9d9dTurn in specific herbs|r")
				AddRow(CheckQuests("71857,71858,71859,71860,71861"), 959796, "|cff0070ddDreambloom Petal|r", "Can drop while gathering any herb")
				AddRow(CheckQuests("71864"), 200678, "|cffa335eeDreambloom|r", "Can drop while gathering any herb")
				AddRow(CheckQuests("74107"), 3615517, "|cff0070ddDraconic Treatise on Herbalism|r", "|cff9d9d9dCrafted with Inscription|r")
			
			elseif profession == "Inscription" then
				
				AddRow(CheckAnyQuest("70561,70560,70559,70558"), nil, QuestNormal .. " |cffffd100Inscription Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("72438,66945,66943,66944,75573,75149"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70592"), nil, QuestNormal .. " |cffffd100Inscription Services Requested|r", "|cff9d9d9dComplete 2 Work Orders|r")
				AddRow(CheckQuests("66375,66376"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70518"), 134420, "|cff0070ddCurious Djaradin Rune|r", "|cff9d9d9dDrops from |rDjaradin")
				AddRow(CheckQuests("70519"), 348560, "|cff0070ddDraconic Glamour|r", "|cff9d9d9dDrops from |rSundered Flame Draconids")
				AddRow(CheckQuests("74105"), 3615518, "|cff0070ddDraconic Treatise on Inscription|r", "|cff9d9d9dCrafted with Inscription|r")
			
			elseif profession == "Jewelcrafting" then
			
				AddRow(CheckAnyQuest("70563,70564,70562,70565"), nil, QuestNormal .. " |cffffd100Jewelcrafting Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("66516,66949,66950,72428,75362,75602"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70593"), nil, QuestNormal .. " |cffffd100Jewelcrafting Services Requested|r", "|cff9d9d9dComplete 2 Work Orders|r")
				AddRow(CheckQuests("66388,66389"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70520"), 132879, "|cff0070ddIncandescent Curio|r", "|cff9d9d9dDrops from |rEarth Elementals")
				AddRow(CheckQuests("70521"), 134890, "|cff0070ddElegantly Engraved Embellishment|r", "|cff9d9d9dDrops from |rSundered Flame Draconids")
				AddRow(CheckQuests("74112"), 3615519, "|cff0070ddDraconic Treatise on Jewelcrafting|r", "|cff9d9d9dCrafted with Inscription|r")
			
			elseif profession == "Leatherworking" then
			
				AddRow(CheckAnyQuest("70567,70568,70571,70569"), nil, QuestNormal .. " |cffffd100Leatherworking Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("66951,66363,66364,72407,75354,75368"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70594"), nil, QuestNormal .. " |cffffd100Leatherworking Services Requested|r", "|cff9d9d9dComplete 3 Work Orders|r")
				AddRow(CheckQuests("66384,66385"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70522"), 1377086, "|cff0070ddOssified Hide|r", "|cff9d9d9dDrops from |rProto-Drakes")
				AddRow(CheckQuests("70523"), 466842, "|cff0070ddExceedingly Soft Skin|r", "|cff9d9d9dDrops from |rVorquin")
				AddRow(CheckQuests("74113"), 3615520, "|cff0070ddDraconic Treatise on Leatherworking|r", "|cff9d9d9dCrafted with Inscription|r")
			
			elseif profession == "Mining" then
			
				AddRow(CheckAnyQuest("72157,70617,70618,72156"), nil, QuestNormal .. " |cffffd100Mining Weekly|r", "|cff9d9d9dTurn in specific materials|r")
				AddRow(CheckQuests("70381,70383,70384,70385,70386"), 961627, "|cff0070ddIridescent Ore Fragments|r", "Can drop while mining any node")
				AddRow(CheckQuests("70389"), 134563, "|cffa335eeIridescent Ore|r", "Can drop while mining any node")
				AddRow(CheckQuests("74106"), 3615521, "|cff0070ddDraconic Treatise on Mining|r", "|cff9d9d9dCrafted with Inscription|r")
			
			elseif profession == "Skinning" then
			
				AddRow(CheckAnyQuest("70620,72159,72158,70619"), nil, QuestNormal .. " |cffffd100Skinning Weekly|r", "|cff9d9d9dTurn in specific materials|r")
				AddRow(CheckQuests("70381,70383,70384,70385,70386"), 4559226, "|cff0070ddCurious Hide Scraps|r", "Can drop while skinning any creature")
				AddRow(CheckQuests("70389"), 4559228, "|cffa335eeLarge Sample of Curious Hide|r", "Can drop while skinning any creature")
				AddRow(CheckQuests("74114"), 4625106, "|cff0070ddDraconic Treatise on Skinning|r", "|cff9d9d9dCrafted with Inscription|r")
			
			elseif profession == "Tailoring" then
			
				AddRow(CheckAnyQuest("70587,70572,70582,70586"), nil, QuestNormal .. " |cffffd100Tailoring Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("66899,66953,66952,72410,75407,75600"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70595"), nil, QuestNormal .. " |cffffd100Tailoring Services Requested|r", "|cff9d9d9dComplete 3 Work Orders|r")
				AddRow(CheckQuests("66386,66387"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70524"), 463527, "|cff0070ddOhn'ahran Weave|r", "|cff9d9d9dDrops from |rNokhud Centaurs")
				AddRow(CheckQuests("70525"), 2032604, "|cff0070ddStupidly Effective Stitchery|r", "|cff9d9d9dDrops from |rGnolls")
				AddRow(CheckQuests("74115"), 3615523, "|cff0070ddDraconic Treatise on Tailoring|r", "|cff9d9d9dCrafted with Inscription|r")
			
			end


			AddLabel(" ")
			AddLabel("Engineering")

			AddRow(CheckAnyQuest("70557,70545,70539,70540"), nil, QuestNormal .. " |cffffd100Engineering Weekly|r", "|cff9d9d9dCrafting quest|r")
			AddRow(CheckAnyQuest("66942,66891,72396,66890,75575,75608"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
			AddRow(CheckQuests("70591"), nil, QuestNormal .. " |cffffd100Engineering Services Requested|r", "|cff9d9d9dComplete 2 Work Orders|r")
			AddRow(CheckQuests("66379,66380"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
			AddRow(CheckQuests("70516"), 2000861, "|cff0070ddKeeper's Mark|r", "|cff9d9d9dDrops from |rTitan Constructs")
			AddRow(CheckQuests("70517"), 2115322, "|cff0070ddInfinitely Attachable Pair o' Docks|r", "|cff9d9d9dDrops from |rDragonkin")
			AddRow(CheckQuests("74111"), 4624728, "|cff0070ddDraconic Treatise on Engineering|r", "|cff9d9d9dCrafted with Inscription|r")
		end

		----


		OutputFrame:SetStatusText("")
		OutputFrame:SetWidth(600)
		OutputFrame:SetHeight(520)
		OutputFrame:Show()
	elseif currencies[msg] then
		local currencyName = msg
		local currencyTable = {}
		local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencies[currencyName]) or {}
		local name = currencyInfo["name"] or "Unknown"
		local icon = currencyInfo["iconFileID"] or 0
		local total = 0

		for character in pairs(ArmyDB) do
			currencyTable[character] = ArmyDB[character].Currencies[currencyName] or 0
			total = total + currencyTable[character]
		end

		-- Sort the table
		local sortedCurrencyTable = getKeysSortedByValue(currencyTable, function(a, b) return a > b end)

		OutputFrame:SetTitle("|T" .. icon .. ":0|t " .. name)

		if ScrollStatus then AceGUI:Release(Scroll) end
		Scroll = AceGUI:Create("ScrollFrame")
		Scroll:SetLayout("Flow")
		ScrollStatus = true
		OutputGroup:AddChild(Scroll)

		for i, k in ipairs(sortedCurrencyTable) do
			local amount = currencyTable[k] or 0

			local Label = AceGUI:Create("Label")
			Label:SetText("|T" .. icon .. ":0|t " .. (amount > 0 and FormatLargeNumber(amount) or "|cff5959590|r"))
			Label:SetRelativeWidth(0.3)
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)

			local Label = AceGUI:Create("Label")
			Label:SetText("|c" .. RAID_CLASS_COLORS[ArmyDB[k]["Class"]].colorStr .. ArmyDB[k]["Name"] .. "  |cff595959" .. ArmyDB[k]["Realm"] .. "|r")
			Label:SetRelativeWidth(0.7)
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)
		end

		OutputFrame:SetStatusText("Account Total:  |T" .. icon .. ":0|t " .. FormatLargeNumber(total))
		OutputFrame:SetWidth(450)
		OutputFrame:SetHeight(520)
		OutputFrame:Show()
	elseif items[msg] then
		local itemName = msg
		local itemTable = {}
		local name, icon = GetSimpleItemInfo(items[itemName])
		local total = 0

		for character in pairs(ArmyDB) do
			itemTable[character] = ArmyDB[character].Items[itemName] or 0
			total = total + itemTable[character]
		end

		-- Sort the table
		local sortedItemTable = getKeysSortedByValue(itemTable, function(a, b) return a > b end)

		OutputFrame:SetTitle("|T" .. icon .. ":0|t " .. name)

		if ScrollStatus then AceGUI:Release(Scroll) end
		Scroll = AceGUI:Create("ScrollFrame")
		Scroll:SetLayout("Flow")
		ScrollStatus = true
		OutputGroup:AddChild(Scroll)

		for i, k in ipairs(sortedItemTable) do
			local amount = itemTable[k] or 0

			local Label = AceGUI:Create("Label")
			Label:SetText("|T" .. icon .. ":0|t " .. (amount > 0 and FormatLargeNumber(amount) or "|cff5959590|r"))
			Label:SetRelativeWidth(0.3)
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)

			local Label = AceGUI:Create("Label")
			Label:SetText("|c" .. RAID_CLASS_COLORS[ArmyDB[k]["Class"]].colorStr .. ArmyDB[k]["Name"] .. "  |cff595959" .. ArmyDB[k]["Realm"] .. "|r")
			Label:SetRelativeWidth(0.7)
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)
		end

		OutputFrame:SetStatusText("Account Total:  |T" .. icon .. ":0|t " .. FormatLargeNumber(total))
		OutputFrame:SetWidth(450)
		OutputFrame:SetHeight(520)
		OutputFrame:Show()
	elseif msg == "weeklyreset" then
		for char, _ in pairs(ArmyDB) do
			ArmyDB[char]["KeystoneMap"] = nil
			ArmyDB[char]["KeystoneLevel"] = 0
		end

		UpdateData()
	else
		local totalMoney, realmMoney = 0, 0
		local faction,_ = UnitFactionGroup("player")
		local name = UnitName("player")
		local realm = GetRealmName()
		local currencyTable = {}
		local connectedRealms = {
			["Ravenholdt"] = "Ravenholdt",
			["Sporeggar"] = "Ravenholdt",
			["Scarshield Legion"] = "Ravenholdt",
			["The Venture Co"] = "Ravenholdt",
			["Defias Brotherhood"] = "Ravenholdt",
			["Earthen Ring"] = "Ravenholdt",
			["Darkmoon Faire"] = "Ravenholdt",
			["Xavius"] = "Xavius",
			["Al'Akir"] = "Xavius",
			["Skullcrusher"] = "Xavius",
			["Burning Legion"] = "Xavius",
			["The Sha'tar"] = "Moonglade",
			["Moonglade"] = "Moonglade",
			["Steamwheedle Cartel"] = "Moonglade",
			["Bloodfeather"] = "Bloodfeather",
			["Kor'gall"] = "Bloodfeather",
			["Executus"] = "Bloodfeather",
			["Burning Steppes"] = "Bloodfeather",
			["Shattered Hand"] = "Bloodfeather",
			["Terokkar"] = "Bloodfeather",
			["Saurfang"] = "Bloodfeather",
			["Darkspear"] = "Bloodfeather",
		}
		if connectedRealms[realm] then realm = connectedRealms[realm] end

		for k, v in pairs(ArmyDB) do
			local c = ArmyDB[k]

			if connectedRealms[c["Realm"]] == realm or c["Realm"] == realm then
				currencyTable[k] = c["Money"] or 0
				realmMoney = realmMoney + c["Money"]
			end

			totalMoney = totalMoney + c["Money"]
			--print(c["Name"], c["Money"])
		end

		-- Sort the table
		local sortedCurrencyTable = getKeysSortedByValue(currencyTable, function(a, b) return a > b end)

		OutputFrame:SetTitle("|TInterface/MoneyFrame/UI-GoldIcon:14:14|t Gold")

		if ScrollStatus then AceGUI:Release(Scroll) end
		Scroll = AceGUI:Create("ScrollFrame")
		Scroll:SetLayout("Flow")
		ScrollStatus = true
		OutputGroup:AddChild(Scroll)

		for i, k in ipairs(sortedCurrencyTable) do
			local Label = AceGUI:Create("Label")
			Label:SetText((currencyTable[k] >= 100000 and FormatLargeNumber(floor((currencyTable[k]) / 10000)) .. " |TInterface/MoneyFrame/UI-GoldIcon:14:14|t" or GetCoinTextureString(currencyTable[k] or 0)))
			Label:SetRelativeWidth(0.3)
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)

			local Label = AceGUI:Create("Label")
			Label:SetText("|c" .. RAID_CLASS_COLORS[ArmyDB[k]["Class"]].colorStr .. ArmyDB[k]["Name"] .. "  |cff595959" .. ArmyDB[k]["Realm"] .. "|r")
			Label:SetRelativeWidth(0.7)
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)
		end

		OutputFrame:SetStatusText("Connected " .. realm .. ":  " .. FormatLargeNumber(floor(realmMoney / 10000)) .. " |TInterface/MoneyFrame/UI-GoldIcon:14:14|t")
		OutputFrame:SetWidth(450)
		OutputFrame:SetHeight(520)
		OutputFrame:Show()

		--DEFAULT_CHAT_FRAME:AddMessage("Account Total:  " .. FormatLargeNumber(floor(totalMoney / 10000)) .. " |TInterface/MoneyFrame/UI-GoldIcon:14:14|t")
	end
end


local function eventHandler(self, event)
	if event == "VARIABLES_LOADED" then
		-- Make sure defaults are set
		if not ArmyDB then ArmyDB = { } end
	elseif event == "WEEKLY_REWARDS_UPDATE" then
		C_Timer.After(1, function()
			UpdateData()
		end)
	else
		UpdateData()
	end
end

frame:SetScript("OnEvent", eventHandler)
