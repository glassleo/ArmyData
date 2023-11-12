SLASH_ARMYDATA1 = "/army"
ArmyData = LibStub("AceAddon-3.0"):NewAddon("ArmyData", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local OutputFrame = AceGUI:Create("Frame")
OutputFrame:SetLayout("Fill")
local OutputGroup = AceGUI:Create("SimpleGroup")
OutputGroup:SetFullWidth(true)
OutputGroup:SetFullHeight(true)
OutputGroup:SetLayout("Fill")
OutputFrame:AddChild(OutputGroup)
OutputFrame:Hide()
local Scroll
local ScrollStatus = false

_G["ArmyDataOutputFrame"] = OutputFrame.frame
tinsert(UISpecialFrames, "ArmyDataOutputFrame")

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
	["Aspect's Dreaming Crests"] = 2718,
	["Wyrm's Dreaming Crests"] = 2717,
	["Drake's Dreaming Crests"] = 2716,
	["Whelpling's Dreaming Crests"] = 2715,
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
	["Dream Infusion"] = 2777,
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

	-- Events
	["Coin of Ancestry"] = 21100,
	["Trial of Style Token"] = 151134,

	-- PvP
	["Mark of Honor"] = 137642,

	-- Battle Pets
	["Polished Pet Charm"] = 163036,
	["Shiny Pet Charm"] = 116415,

	-- Shadowlands
	["Genesis Mote"] = 188957,
	["Sandworn Relic"] = 190189,

	-- Dragonflight
	["Seedbloom"] = 211376,
	["Dreamsurge Coalescence"] = 207026,
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
			["GrottoNetherwingDrake"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["GrottoNetherwingDrake"] or 4,
			["FlourishingWhimsydrake"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["FlourishingWhimsydrake"] or 1,
			["AlgarianStormrider"] = ArmyDB[name.."-"..realm] and ArmyDB[name.."-"..realm]["AlgarianStormrider"] or 1,

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
	elseif id == 116415 then return "|cffffffffShiny Pet Charm|r", 413584
	elseif id == 163036 then return "|cffffffffPolished Pet Charm|r", 2004597
	elseif id == 188957 then return "|cff1eff00Genesis Mote|r", 4287471
	elseif id == 190189 then return "|cffa335eeSandworn Relic|r", 519378
	elseif id == 21100 then return "|cffffffffCoin of Ancestry|r", 133858
	elseif id == 151134 then return "|cff1eff00Trial of Style Token|r", 1500867
	elseif id == 207026 then return "|cffffffffDreamsurge Coalescence|r", 132858
	elseif id == 211376 then return "|cff1eff00Seedbloom|r", 306845
	else return id, 134400
	end
end

function ArmyGetKey(key, char)
	local name = UnitName("player") or ""
	local realm = GetRealmName() or ""
	local char = char or name.."-"..realm

	return ArmyDB[char] and ArmyDB[char][key] or nil
end


-- Barber Shop/Dragonriding Customization
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
		[8614] = "AlgarianStormrider",
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
		            	? - Algarian Stormrider

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

	            	
	            	
	            	if keys[id] then
	            		UpdateSpecificData(keys[id], choice)
	            	--else print(id, data.name, choice) -- Debug
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
		local itemTable, detailsTable, detailsSortTable = {}, {}, {}
		local detailsTotal = 0
		local icon = 4352494

		for character in pairs(ArmyDB) do
			itemTable[character] = ArmyDB[character].KeystoneLevel or 0
		end

		OutputFrame:SetTitle("|T" .. icon .. ":0|t |cffa335eeMythic Keystones|r")

		if ScrollStatus then AceGUI:Release(Scroll) end
		Scroll = AceGUI:Create("ScrollFrame")
		Scroll:SetLayout("Flow")
		ScrollStatus = true
		OutputGroup:AddChild(Scroll)

		-- Sort the table
		local sortedItemTable = getKeysSortedByValue(itemTable, function(a, b) return a > b end)

		for i, k in ipairs(sortedItemTable) do
			if tonumber(ArmyDB[k]["KeystoneLevel"] or 0) > 0 then
				local level = itemTable[k] or 0

				local Label = AceGUI:Create("Label")
				Label:SetText((level > 0 and ("+" .. level) or ""))
				Label:SetRelativeWidth(0.09)
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
		local level = UnitLevel("player") or 1

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

		local yes, no, maybe = CreateAtlasMarkup("common-icon-checkmark"), CreateAtlasMarkup("common-icon-redx"), CreateAtlasMarkup("common-icon-checkmark-yellow")
		local QuestNormal = CreateAtlasMarkup("QuestNormal")

		local TotalYes, TotalNo, TotalMaybe = 0, 0, 0

		OutputFrame:SetTitle("|c" .. RAID_CLASS_COLORS[class].colorStr .. name .. "|r  |cff9d9d9d" .. realm .. "")

		if ScrollStatus then AceGUI:Release(Scroll) end
		Scroll = AceGUI:Create("ScrollFrame")
		Scroll:SetLayout("Flow")
		ScrollStatus = true
		OutputGroup:AddChild(Scroll)

		local function AddSpace()
			local Label = AceGUI:Create("Label")
			Label:SetText(" ")
			Label:SetFullWidth(true)
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)
		end

		local firstlabel = true
		local function AddLabel(text)
			if firstlabel then
				firstlabel = false
			else
				local Label = AceGUI:Create("Label")
				Label:SetText(" ")
				Label:SetFullWidth(true)
				Label:SetFontObject("GameFontNormalLarge")
				Scroll:AddChild(Label)
			end

			local Label = AceGUI:Create("Label")
			Label:SetText("|cffffd100" .. text .. "|r")
			Label:SetFullWidth(true)
			Label:SetFontObject("GameFontNormalLarge")
			Scroll:AddChild(Label)

			AddSpace()
		end

		local function AddRow(checked, icon, text, description)
			if type(checked) == "string" then
				TotalMaybe = TotalMaybe + 1
			elseif checked then
				TotalYes = TotalYes + 1
			else
				TotalNo = TotalNo + 1
			end

			local Label = AceGUI:Create("Label")
			Label:SetText((type(checked) == "string") and ("|cffffff00" .. checked .. "|r") or checked and yes or no)
			Label:SetRelativeWidth(0.09)
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)

			local Label = AceGUI:Create("Label")
			Label:SetText((icon and "|T" .. icon .. ":0|t " or "") .. text or "")
			if(not checked or type(checked) == "string") then
				Label:SetRelativeWidth(0.4)
			else
				Label:SetRelativeWidth(0.9)
			end
			Label:SetFontObject("GameFontNormal")
			Scroll:AddChild(Label)

			if not checked or type(checked) == "string" then
				local Label = AceGUI:Create("Label")
				Label:SetText(description or " ")
				Label:SetRelativeWidth(0.5)
				Label:SetFontObject("GameFontNormal")
				Scroll:AddChild(Label)
			end
		end

		local function AH(a, h)
			return (faction == "Horde") and h or a
		end

		local function SpellKnown(id)
			return IsPlayerSpell(id) or IsSpellKnown(id, true)
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

		local function HasSkill(skill, level)
			if not Breadcrumbs then return "?" end
			if (Breadcrumbs:GetSkillLine(skill) or 0) >= level then return true end
			return false
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
			local labels = { [1] = FACTION_STANDING_LABEL1, [2] = FACTION_STANDING_LABEL2, [3] = FACTION_STANDING_LABEL3, [4] = FACTION_STANDING_LABEL4, [5] = FACTION_STANDING_LABEL5, [6] = FACTION_STANDING_LABEL6, [7] = FACTION_STANDING_LABEL7, [8] = FACTION_STANDING_LABEL8, [9] = "Paragon", }

			if standingID >= required then
				return "|cff1aff1a" .. labels[standingID] .. " with " .. name .. "|r"
			else
				return "|cff9d9d9d" .. labels[required] .. " with |r" .. name .. "|cff9d9d9d (" .. FormatLargeNumber((barMax or 0)-(barValue or 0)) .. " until " .. labels[standingID + 1] .. ")|r"
			end
		end

		local function CheckItems(id, icon, name)
			local count = GetItemCount(id, true, true, true) or 0
			return (count >= 1 and "|cff1aff1a" .. count or "|cff9d9d9dNo") .. " |T" .. icon .. ":0|t " .. name .. " available"
		end

		local function CheckSkill(skill, level, name)
			if not Breadcrumbs then
				return "|cff9d9d9dRequires |r" .. name .. " " .. level
			elseif Breadcrumbs:Validate("skill:" .. skill ..  ":" .. level) then
				return "|cff1aff1a" .. (Breadcrumbs:GetSkillLine(skill) or 0) .. " " .. name .. "|r"
			else
				return "|cff9d9d9d" .. (Breadcrumbs:GetSkillLine(skill) or 0) .. "/" .. level .. " |r" .. name
			end
		end 

		----


		if msg == "audit" then
			TotalYes, TotalNo, TotalMaybe = 0, 0, 0

			----
			AddLabel("Character")

			AddRow((GetBindLocation() == "Valdrakken") and true or "?", 134414, "Hearthstone", "|cff9d9d9dCurrently set to |r" .. GetBindLocation())

			if level >= 10 then
				-- Dragonriding
				local missing = false
				if not SpellKnown(403093) then missing = "Airborne Recovery" end
				if not SpellKnown(404243) then missing = missing and missing .. ", Land's Blessing" or "Land's Blessing" end
				if not SpellKnown(377922) then missing = missing and missing .. ", Beyond Infinity" or "Beyond Infinity" end
				if not SpellKnown(396760) then missing = missing and missing .. ", Yearning for the Sky" or "Yearning for the Sky" end
				if not SpellKnown(377967) then missing = missing and missing .. ", At Home Aloft" or "At Home Aloft" end
				if prof1Name == "Herbalism" or prof2Name == "Herbalism" or prof1Name == "Mining" or prof2Name == "Mining" then
					if not SpellKnown(381870) then missing = missing and missing .. ", Dragonrider's Cultivation" or "Dragonrider's Cultivation" end
				else
					if not SpellKnown(381871) then missing = missing and missing .. ", Dragonrider's Hunt" or "Dragonrider's Hunt" end
				end
				if not SpellKnown(384824) then missing = missing and missing .. ", Dragonrider's Compassion" or "Dragonrider's Compassion" end

				AddRow((missing == false) and true or false, 4640486, "Dragonriding", "|cff9d9d9dMissing traits:|r " .. (missing or ""))
				
				AddRow(C_MountJournal.GetAppliedMountEquipmentID() and true or false, 413588, "Mount Equipment", "|cff9d9d9dNo Mount Equipment applied")
			end

			local slots = C_Container.GetContainerNumSlots(Enum.BagIndex.Bag_1) or 0
			AddRow((slots >= 34) and true or (slots >= 32) and maybe or false, 133633, "Bag 1", (slots == 0) and "|cffff0000No bag equipped|r" or slots .. " Slots")

			local slots = C_Container.GetContainerNumSlots(Enum.BagIndex.Bag_2) or 0
			AddRow((slots >= 34) and true or (slots >= 32) and maybe or false, 133633, "Bag 2", (slots == 0) and "|cffff0000No bag equipped|r" or slots .. " Slots")

			local slots = C_Container.GetContainerNumSlots(Enum.BagIndex.Bag_3) or 0
			AddRow((slots >= 34) and true or (slots >= 32) and maybe or false, 133633, "Bag 3", (slots == 0) and "|cffff0000No bag equipped|r" or slots .. " Slots")

			local slots = C_Container.GetContainerNumSlots(Enum.BagIndex.Bag_4) or 0
			AddRow((slots >= 34) and true or (slots >= 32) and maybe or false, 133633, "Bag 4", (slots == 0) and "|cffff0000No bag equipped|r" or slots .. " Slots")

			local slots = C_Container.GetContainerNumSlots(Enum.BagIndex.ReagentBag) or 0
			AddRow((slots >= 36) and true or (slots >= 32) and maybe or false, 4549254, "Reagent Bag", (slots == 0) and "|cffff0000No bag equipped|r" or slots .. " Slots")

			
			----
			if class == "DEATHKNIGHT" then
				AddLabel("|cffc41e3aDeath Knight|r")

				AddRow(SpellKnown(127344), 136133, "|cff71d5ffCorpse Exploder|r", "|cff9d9d9dSold by Quartermaster Ozorg in |rAcherus")
			end


			----
			if class == "DRUID" and level >= 10 then
				AddLabel("|cffff7c0aDruid|r")

				AddRow(SpellKnown(127757), 254857, "|cff71d5ffCharm Woodland Creature|r", "|cff9d9d9dSold by Lorelae Wintersong in |rMoonglade")
				AddRow(SpellKnown(164862), 132925, "|cff71d5ffFlap|r", "|cff9d9d9dSold by Lorelae Wintersong in |rMoonglade")
				AddRow(SpellKnown(210053), 1394966, "|cff71d5ffMount Form|r", "|cff9d9d9dSold by Lorelae Wintersong in |rMoonglade")
				AddRow(SpellKnown(210065), 132328, "|cff71d5ffTrack Beasts|r", "|cff9d9d9dSold by Lorelae Wintersong in |rMoonglade")
				AddRow(SpellKnown(114282), 132145, "|cff71d5ffTreant Form|r", "|cff9d9d9dSold by Lorelae Wintersong in |rMoonglade")
			end


			----
			if class == "HUNTER" then
				AddLabel("|cffaad372Hunter|r")

				AddRow(SpellKnown(209997), 134355, "|cff71d5ffPlay Dead|r", "|cff9d9d9dSold by Outfitter Reynolds in |rTrueshot Lodge")
				AddRow(SpellKnown(127933), 134279, "|cff71d5ffFireworks|r", "|cff9d9d9dSold by Hobart Grapplehammer in |rDalaran")
				AddRow(SpellKnown(61648), 463491, "|cff71d5ffAspect of the Chameleon|r", "|cff9d9d9dSold by Outfitter Reynolds in |rTrueshot Lodge")
				AddRow(SpellKnown(125050), 133718, "|cff71d5ffFetch|r", "|cff9d9d9dSold by Outfitter Reynolds in |rTrueshot Lodge")
				AddRow(SpellKnown(138430), 791593, "|cff71d5ffAncient Zandalari Knowledge|r", "|cff9d9d9dDrops from Zandalari Dinomancers on |rIsle of Giants")
				AddRow(SpellKnown(242155), 929300, "|cff71d5ffHybrid Kinship|r", "|cff9d9d9dSold by Pan the Kind Hand in |rTrueshot Lodge")
				AddRow(SpellKnown(205154), 1405813, "|cff71d5ffMecha-Bond Imprint Matrix|r", "|cff9d9d9dCrafted with |rEngineering")
			end


			----
			if class == "MAGE" and level >= 10 then
				AddLabel("|cff3fc7ebMage|r")

				AddRow(SpellKnown(193759), 1536440, "|cff71d5ffTeleport: Hall of the Guardian|r", "|cff9d9d9dLearned through the |rLegion Mage Campaign")
				
				if level >= 21 then
					if level >= 24 and SpellKnown(AH(3561, 3567)) then
						AddRow(SpellKnown(AH(10059, 11417)), AH(135748, 135744), "|cff71d5ffPortal: " .. AH("Stormwind", "Orgrimmar") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(AH(3561, 3567)), AH(135763, 135759), "|cff71d5ffTeleport: " .. AH("Stormwind", "Orgrimmar") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end

					if level >= 24 and SpellKnown(AH(3562, 3566)) then
						AddRow(SpellKnown(AH(11416, 11420)), AH(135743, 135750), "|cff71d5ffPortal: " .. AH("Ironforge", "Thunder Bluff") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(AH(3562, 3566)), AH(135757, 135765), "|cff71d5ffTeleport: " .. AH("Ironforge", "Thunder Bluff") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end
					
					if level >= 24 and SpellKnown(AH(3565, 3563)) then
						AddRow(SpellKnown(AH(11419, 11418)), AH(135741, 135751), "|cff71d5ffPortal: " .. AH("Darnassus", "Undercity") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(AH(3565, 3563)), AH(135755, 135766), "|cff71d5ffTeleport: " .. AH("Darnassus", "Undercity") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end
					
					if level >= 24 and SpellKnown(AH(49359, 49358)) then
						AddRow(SpellKnown(AH(49360, 49361)), AH(135749, 135747), "|cff71d5ffPortal: " .. AH("Theramore", "Stonard") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(AH(49359, 49358)), AH(135764, 135762), "|cff71d5ffTeleport: " .. AH("Theramore", "Stonard") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end
					
					if level >= 24 and SpellKnown(AH(32271, 32272)) then
						AddRow(SpellKnown(AH(32266, 32267)), AH(135742, 135746), "|cff71d5ffPortal: " .. AH("Exodar", "Silvermoon") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(AH(32271, 32272)), AH(135756, 135761), "|cff71d5ffTeleport: " .. AH("Exodar", "Silvermoon") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end
					
					if level >= 24 and SpellKnown(AH(33690, 35715)) then
						AddRow(SpellKnown(AH(33691, 35717)), 135745, "|cff71d5ffPortal: Shattrath|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(AH(33690, 35715)), 135760, "|cff71d5ffTeleport: Shattrath|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end
					
					if level >= 24 and SpellKnown(53140) then
						AddRow(SpellKnown(53142), 237508, "|cff71d5ffPortal: Dalaran - Northrend|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(53140), 135760, "|cff71d5ffTeleport: Dalaran - Northrend|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end
					
					if level >= 24 and SpellKnown(AH(88342, 88344)) then
						AddRow(SpellKnown(AH(88345, 88346)), 462339, "|cff71d5ffPortal: Tol Barad|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(AH(88342, 88344)), 462340, "|cff71d5ffTeleport: Tol Barad|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end
					
					if level >= 24 and SpellKnown(AH(132621, 132627)) then
						AddRow(SpellKnown(AH(132620, 132626)), 851297, "|cff71d5ffPortal: Vale of Eternal Blossoms|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(AH(132621, 132627)), 851298, "|cff71d5ffTeleport: Vale of Eternal Blossoms|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end
					
					if level >= 24 and SpellKnown(AH(176248, 176242)) then
						AddRow(SpellKnown(AH(176246, 176244)), AH(1535372, 1535373), "|cff71d5ffPortal: " .. AH("Stormshield", "Warspear") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(AH(176248, 176242)), AH(1535375, 1535376), "|cff71d5ffTeleport: " .. AH("Stormshield", "Warspear") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end

					if level >= 24 and SpellKnown(224869) then
						AddRow(SpellKnown(224871), 1535371, "|cff71d5ffPortal: Dalaran - Broken Isles|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(224869), 1535374, "|cff71d5ffTeleport: Dalaran - Broken Isles|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end

					if level >= 24 and SpellKnown(AH(281403, 281404)) then
						AddRow(SpellKnown(AH(281400, 281402)), AH(2176537, 2176538), "|cff71d5ffPortal: " .. AH("Boralus", "Dazar'alor") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(AH(281403, 281404)), AH(2176535, 2176536), "|cff71d5ffTeleport: " .. AH("Boralus", "Dazar'alor") .. "|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end
				end
				if level >= 52 then
					if level >= 58 and SpellKnown(344587) then
						AddRow(SpellKnown(344597), 3847779, "|cff71d5ffPortal: Oribos|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					else
						AddRow(SpellKnown(344587), 3847780, "|cff71d5ffTeleport: Oribos|r", "|cff9d9d9dLearned from any |rPortal Trainer")
					end
				end
				if level >= 62 then
					if level >= 68 and SpellKnown(395277) then
						AddRow(SpellKnown(395289), 4661644, "|cff71d5ffPortal: Valdrakken|r", "|cff9d9d9dLearned from Alregosa in |rValdrakken")
					else
						AddRow(SpellKnown(395277), 4661645, "|cff71d5ffTeleport: Valdrakken|r", "|cff9d9d9dLearned from Alregosa in |rValdrakken")
					end
				end
				if level >= 28 then
					if SpellKnown(120145) then
						AddRow(SpellKnown(120146), 628677, "|cff71d5ffAncient Portal: Dalaran|r", "|cff9d9d9dSold by Endora Moorehead in |rNorthrend Dalaran")
					else
						AddRow(SpellKnown(120145), 628678, "|cff71d5ffAncient Teleport: Dalaran|r", "|cff9d9d9dTreasure in |rScarlet Halls")
					end
				end
				if level >= 10 then
					AddRow(SpellKnown(210086), 458228, "|cff71d5ffArcane Linguist|r", "|cff9d9d9dSold by Endora Moorehead in |rNorthrend Dalaran")
					AddRow(SpellKnown(131784), 133564, "|cff71d5ffIllusion|r", "|cff9d9d9dSold by Endora Moorehead in |rNorthrend Dalaran")
				end
				if level >= 11 then
					AddRow(SpellKnown(161354) or "?", 132159, "|cff71d5ffPolymorph: Monkey|r", "|cff9d9d9dDrops from Hozen and Monkeys (BoE)|r")
					AddRow(SpellKnown(161353) or "?", 294471, "|cff71d5ffPolymorph: Polar Bear Cub|r", "|cff9d9d9dDrops from Arctic Grizzlys in |cffffffffDragonblight|r (BoE)|r")
					AddRow(SpellKnown(126819) or "?", 644001, "|cff71d5ffPolymorph: Porcupine|r", "|cff9d9d9dDrops from Porcupines in |cffffffffPandaria|r (BoE)|r")
				end
				if level >= 25 then
					AddRow(SpellKnown(61305), 236547, "|cff71d5ffPolymorph: Black Cat|r", "|cff9d9d9dSold by Endora Moorehead in |rNorthrend Dalaran")
					AddRow(SpellKnown(28272) or "?", 135997, "|cff71d5ffPolymorph: Pig|r", "|cff9d9d9dLearned by The Amazing Zanzo in |rDalaran|cff9d9d9d (rare spawn)|r")
					AddRow(SpellKnown(61721) or "?", 319458, "|cff71d5ffPolymorph: Rabbit|r", "|cff9d9d9dAvailable during |rNoblegarden")
					AddRow(SpellKnown(28271) or "?", 132199, "|cff71d5ffPolymorph: Turtle|r", "|cff9d9d9dRare drop from fishing (BoE)")
				end
				if level >= 50 then
					AddRow(SpellKnown(AH(277792, 277787)) or "?", AH(2027853, 877480), "|cff71d5ffPolymorph: " .. AH("Bumblebee", "Direhorn") .. "|r", CheckReputation(AH(2162, 2103), 7))
				end
				if level >= 60 then
					AddRow(SpellKnown(391622), 4048815, "|cff71d5ffPolymorph: Duck|r", "|cff9d9d9dTreasure in |rAzure Span")
				end
			end


			----
			if class == "MONK" then
				AddLabel("|cff00ff98Monk|r")

				AddRow(SpellKnown(125883), 660248, "|cff71d5ffZen Flight|r", "|cff9d9d9dSold by Caydori Brightstar on |rThe Wandering Isle")
			end


			----
			if class == "PALADIN" then
				AddLabel("|cfff48cbaPaladin|r")

				AddRow(SpellKnown(121183), 134916, "|cff71d5ffContemplation|r", "|cff9d9d9dSold by Eric the Pure in |rThe Sanctum of Light")
			end


			----
			if class == "ROGUE" then
				AddLabel("|cfffff468Rogue|r")

				AddRow(SpellKnown(210108), 132319, "|cff71d5ffDetection|r", "|cff9d9d9dSold by Kelsey Steelspark in |rThe Hall of Shadows")
			end


			---
			if class == "SHAMAN" and level >= 41 then
				AddLabel("|cff0070ddShaman|r")

				AddRow(SpellKnown(211015), 294474, "|cff71d5ffHex: Cockroach|r", "|cff9d9d9dSold by Cravitz Lorent in |rDalaran")
				AddRow(SpellKnown(210873), 132193, "|cff71d5ffHex: Compy|r", "|cff9d9d9dSold by Flamesmith Lanying in |rThe Maelstrom")
				AddRow(SpellKnown(211004) or "?", 132196, "|cff71d5ffHex: Spider|r", "|cff9d9d9dRare drop from Nal'tira in |rThe Arcway")
				AddRow(SpellKnown(309328) or "?", 646670, "|cff71d5ffHex: Living Honey|r", "|cff9d9d9dRare drop from Honey Smasher in |rStormsong Valley")
				AddRow(SpellKnown(269352) or "?", 456563, "|cff71d5ffHex: Skeletal Hatchling|r", "|cff9d9d9dRare drop from Rezan in |rAtal'Dazar")
				AddRow(SpellKnown(AH(277784, 277778)) or "?", AH(2030683, 797327), "|cff71d5ffHex: " .. AH("Wicker Mongrel", "Zandalari Tendonripper") .. "|r", CheckReputation(AH(2161, 2103), 7))
			end


			----
			AddLabel("Items")


			AddRow(HasItem(188152), 607513, "|cff0070ddGateway Control Shard|r", "|cff9d9d9dSold by Reagent vendors|r")

			if prof1Name ~= "Engineering" and prof2Name ~= "Engineering" then
				AddRow(HasItem(109253), 237296, "|cff1eff00Ultimate Gnomish Army Knife|r", "|cff9d9d9dCrafted with |rEngineering")
			end

			if class ~= "MAGE" then
				AddRow(HasItem(AH(63352, 63353)), AH(461810, 461813), "|cff1eff00Shroud of Cooperation|r", CheckReputation(1168, 6))
				AddRow(HasItem(AH(63206, 63207)), AH(461811, 461814), "|cff0070ddWrap of Unity|r", CheckReputation(1168, 6))
				AddRow(HasItem(AH(65360, 65274)), AH(461812, 461815), "|cffa335eeCloak of Coordination|r", CheckReputation(1168, 7))
			end

			AddRow(HasItem(103678), 643915, "|cffa335eeTime-Lost Artifact|r", CheckReputation(1492, 6))
			AddRow(HasItem(202046), 2203919, "|cff0070ddLucky Tortollan Charm|r", "|cff9d9d9dSold by Griftah in |rThe Waking Shores")
			
			AddRow(HasItem(111820), 308321, "|cff0070ddSwapblaster|r", "|cff9d9d9dCrafted with |rEngineering")


			---
			if prof1Name == "Engineering" or prof2Name == "Engineering" then
				AddLabel("Engineering")

				if level >= 10 then
					AddRow(HasItem(114943), 237296, "|cff0070ddUltimate Gnomish Army Knife|r", CheckSkill(2501, 1, "Draenor Engineering"))
					AddRow(HasSkill(2503, 70), 986491, "|cff0070ddLoot-A-Rang|r", CheckSkill(2503, 70, "Cataclysm Engineering"))

					if prof1Name == "Herbalism" or prof1Name == "Mining" or prof1Name == "Skinning" or prof2Name == "Herbalism" or prof2Name == "Mining" or prof2Name == "Skinning" then
						AddRow(HasItem(67494), 465876, "|cff0070ddElectrostatic Condenser|r", CheckSkill(2503, 1, "Cataclysm Engineering"))
					end
				end
				if level >= 20 then
					if SpellKnown(20219) then
						AddRow(true, 132996, "Gnomish Engineer")
					elseif SpellKnown(20222) then
						AddRow(true, 135826, "Goblin Engineer")
					else
						AddRow(false, 132996, "Engineering Specialization", CheckSkill(2506, 200, "Classic Engineering"))
					end
				end
				if level >= 10 then
					AddRow(HasSkill(2504, 50), 463542, "|cff0070ddMOLL-E|r", CheckSkill(2504, 50, "Northrend Engineering"))
				end
				if level >= 30 then
					AddRow(HasItem(49040), 254097, "|cffa335eeJeeves|r", CheckSkill(2504, 75, "Northrend Engineering"))
				end
				if level >= 20 then
					if SpellKnown(20219) then -- Gnomish Engineer
						AddRow(HasSkill(2506, 260), 133870, "|cff0070ddUltrasafe Transporter: Gadgetzan|r", CheckSkill(2506, 260, "Classic Engineering"))
						AddRow(HasSkill(2505, 50), 321487, "|cff0070ddUltrasafe Transporter: Toshley's Station|r", CheckSkill(2505, 50, "Outland Engineering"))
					elseif SpellKnown(20222) then -- Goblin Engineer
						AddRow(HasSkill(2506, 260), 133873, "|cff0070ddDimensional Ripper - Everlook|r", CheckSkill(2506, 260, "Classic Engineering"))
						AddRow(HasSkill(2505, 50), 133865, "|cff0070ddDimensional Ripper - Area 52|r", CheckSkill(2505, 50, "Outland Engineering"))
					end
				end
				if level >= 10 then
					AddRow(HasSkill(2504, 40), 135778, "|cff0070ddWormhole Generator: Northrend|r", CheckSkill(2504, 40, "Northrend Engineering"))
					AddRow(HasSkill(2502, 1), 651094, "|cff0070ddWormhole Generator: Pandaria|r", CheckSkill(2502, 1, "Pandaria Engineering"))
					AddRow(HasSkill(2501, 1), 892831, "|cff0070ddWormhole Centrifuge|r", CheckSkill(2501, 1, "Draenor Engineering"))
				end
				if level >= 50 then
					AddRow(HasItem(144341), 1405815, "|cff0070ddRechargeable Reaves Battery|r", CheckItems(124124, 1417744, "|cff0070ddBlood of Sargeras|r"))
					AddRow(HasSkill(2500, 1), 237560, "|cff0070ddWormhole Generator: Argus|r", CheckSkill(2500, 1, "Legion Engineering"))
				end
				if level >= 45 then
					AddRow(HasSkill(2499, 1), AH(2000841, 2000840), "|cff0070ddWormhole Generator: " .. AH("Kul Tiras", "Zandalar") .. "|r", CheckSkill(2499, 1, AH("Kul Tiran Engineering", "Zandalari Engineering")))
				end
				if level >= 50 then
					AddRow(HasSkill(2755, 1), 3610528, "|cff0070ddWormhole Generator: Shadowlands|r", CheckSkill(2755, 1, "Shadowlands Engineering"))
				end
				if level >= 60 then
					if HasSkill(2827, 50) then
						AddRow(CheckQuests("70573,70574,70575,70576,70577,70578,70579,70580,70581,70583,70584,70585,73145,73143,73144,75186"), 4548860, "|cff0070ddWyrmhole Generator: Dragon Isles|r", "|cff9d9d9dFind all Deactivated Signal Transmitters|r")
					else
						AddRow(false, 4548860, "|cff0070ddWyrmhole Generator: Dragon Isles|r", CheckSkill(2827, 1, "Dragon Isles Engineering"))
					end
				end
			end


			---
			if prof1Name == "Alchemy" or prof2Name == "Alchemy" then
				AddLabel("Alchemy")

				if HasItem(9149) then -- Todo: add the other Alchemist Stones - https://www.wowhead.com/search?q=alchemist+stone
					AddRow(true, 134333, "|cff1eff00Philosopher's Stone|r")
				else
					AddRow(HasItem(109262), 134333, "|cff0070ddDraenic Philosopher's Stone|r", CheckSkill(2480, 1, "Draenor Alchemy"))
				end

				if SpellKnown(28672) then
					AddRow(true, 134918, "Transmutation Master")
				elseif SpellKnown(28677) then
					AddRow(true, 134918, "Elixir Master")
				elseif SpellKnown(28677) then
					AddRow(true, 28675, "Potion Master")
				else
					AddRow(false, 134918, "Alcehmy Specialization", CheckSkill(2485, 300, "Classic Alchemy"))
				end
			end


			---
			if prof1Name == "Enchanting" or prof2Name == "Enchanting" then
				AddLabel("Enchanting")

				if level >= 50 then
					AddRow(HasItem(164766), 2440573, "|cffa335eeIwen's Enchanting Rod|r", CheckSkill(2486, 150, AH("Kul Tiran Enchanting", "Zandalari Enchanting")))
				end
			end


			---
			if prof1Name == "Herbalism" or prof2Name == "Herbalism" then
				AddLabel("Herbalism")

				AddRow(HasItem(86566), 621748, "|cff0070ddForager's Gloves|r", "|cff9d9d9dDrops from Burning Berskerkers on |rTimeless Isle")
				AddRow(HasItem(87213), 133149, "|cff1eff00Mist-Piercing Goggles|r", "|cff9d9d9dCrafted with |rEngineering")
				--AddRow(HasItem(116916), 944150, "|cff0070ddGorepetal's Gentle Grasp|r", "|cff9d9d9dDrops from Gorepetal in |rNagrand")
			end


			---
			if prof1Name == "Mining" or prof2Name == "Mining" then
				AddLabel("Mining")

				AddRow(HasItem(86566), 621748, "|cff0070ddForager's Gloves|r", "|cff9d9d9dDrops from Burning Berskerkers on |rTimeless Isle")
				AddRow(HasItem(87213), 133149, "|cff1eff00Mist-Piercing Goggles|r", "|cff9d9d9dCrafted with |rEngineering")
				AddRow(HasItem(85777), 134710, "|cff0070ddAncient Pandaren Mining Pick|r", "|cff9d9d9dRare treasure|r")
				AddRow(HasItem(116913), 134710, "|cff0070ddPeon's Mining Pick|r", "|cff9d9d9dTreasure in |rSpires of Arak")
				--AddRow(HasItem(153290), 1717137, "|cff0070ddKrokul Mining Pick|r", CheckReputation(2170, 6))
			end


			---
			if prof1Name == "Skinning" or prof2Name == "Skinning" then
				AddLabel("Skinning")

				AddRow(HasItem(86566), 621748, "|cff0070ddForager's Gloves|r", "|cff9d9d9dDrops from Burning Berskerkers on |rTimeless Isle")
			end


			---
			AddLabel("Cooking")

			if level >= 10 then
				AddRow(HasSkill(2546, 25), 236571, "|cff0070ddChef's Hat|r", CheckSkill(2546, 25, "Northrend Cooking"))
				AddRow(HasSkill(2824, 50), 4620671, "Dragon Isles Cooking", CheckSkill(2824, 50, "Dragon Isles Cooking"))
			end


			---
			AddLabel("Fishing")

			AddRow(SpellKnown(43308), 133888, "|cff71d5ffFind Fish|r", "|cff9d9d9dRecipe drops from trunks fished up from debris pools|r")
			if level >= 50 then
				--AddRow(HasItem(133755), 1053367, "|cffe6cc80Underlight Angler|r")
			end


			----
			if level >= 60 then
				AddLabel("Dragonflight")

				AddRow(CheckQuests("69979"), nil, QuestNormal .. " |cffffd100Artisan's Consortium|r", "|cff9d9d9dSkip available at |rRuby Life Pools")
				AddRow(CheckQuests("70899"), nil, QuestNormal .. " |cffffd100Engine of Innovation|r", "|cff9d9d9dSkip available in |rValdrakken|r")
				AddRow(CheckQuests("73156"), nil, QuestNormal .. " |cffffd100The Forbidden Reach|r", "|cff9d9d9dSkip available at |rThe Seat of the Aspects")
			end

			----
			if level >= 60 then
				AddLabel("Shadowlands")

				AddRow(CheckQuests("59770"), nil, QuestNormal .. " |cffffd100The Maw|r", "|cff9d9d9dSkip available in |r" .. AH("Stormwind", "Orgrimmar"))
				AddRow(CheckQuests("62704"), nil, QuestNormal .. " |cffffd100Threads of Fate|r", "|cff9d9d9dSkip available in |rOribos")

				local renown = C_CovenantSanctumUI and C_CovenantSanctumUI.GetRenownLevel() or 1
    			local covenant = C_Covenants and C_Covenants.GetActiveCovenantID() or 0

				if covenant == 1 then
					AddRow((renown >= 80) and true or (renown >= 60) and maybe or false, 3641395, "Kyrian Renown", (renown >= 60) and "Renown " .. renown or "|cff9d9d9dRenown 60 boost available in Oribos|r")
				elseif covenant == 2 then
					AddRow((renown >= 80) and true or (renown >= 60) and maybe or false, 3641397, "Venthyr Renown", (renown >= 60) and "Renown " .. renown or "|cff9d9d9dRenown 60 boost available in Oribos|r")
				elseif covenant == 3 then
					AddRow((renown >= 80) and true or (renown >= 60) and maybe or false, 3641394, "Night Fae Renown", (renown >= 60) and "Renown " .. renown or "|cff9d9d9dRenown 60 boost available in Oribos|r")
				elseif covenant == 4 then
					AddRow((renown >= 80) and true or (renown >= 60) and maybe or false, 3641396, "Necrolord Renown", (renown >= 60) and "Renown " .. renown or "|cff9d9d9dRenown 60 boost available in Oribos|r")
				else
					AddRow(false, 3601566, "Covenant", "|cff9d9d9dChoose a Covenant in |rOribos")
				end

				if HasBankItem(186472) then
					AddRow(maybe, 3528275, "|cffa335eeWisps of Memory|r", CheckItems(186472, 3528275, "|cffa335eeWisps of Memory|r"))
				end

				if HasBankItem(188005) then
					AddRow(maybe, 3528288, "Anima", "|cff9d9d9dDeposit Anima|r")
				end
				
				AddRow(CheckQuests("64958"), nil, QuestNormal .. " |cffffd100Zereth Mortis|r", "|cff9d9d9dSkip available in |rOribos")
				AddRow(CheckQuests("65694"), 1360978, "|cffa335eeFont of Ephemeral Power|r", CheckReputation(2478, 5))
			end

			----
			if level >= 10 then
				AddLabel("Legion")

				AddRow(CheckAnyQuest("44184,44663"), 1444943, "Dalaran Hearthstone", "|cff9d9d9dSkip available in |r" .. AH("Stormwind", "Orgrimmar"))
				AddRow(CheckAnyQuest("43341,45727"), nil, QuestNormal .. " |cffffd100Uniting the Isles|r", "|cff9d9d9dQuest available in |rThe Violet Citadel")
				AddRow(CheckQuests("46734"), nil, QuestNormal .. " |cffffd100Broken Shore|r", "|cff9d9d9dSkip available in |rKrasus' Landing")
				AddRow(CheckQuests("48440"), nil, QuestNormal .. " |cffffd100Argus|r", "|cff9d9d9dQuest available in |rThe Violet Citadel")


				AddLabel("Draenor")

				AddRow(CheckAnyQuest("34586,34378"), 1041860, "Garrison Hearthstone", "|cff9d9d9dQuest available in |r" .. AH("Shadowmoon Valley", "Frostfire Ridge"))
			end

			AddSpace()
			OutputFrame:SetStatusText("Total " .. (TotalYes + TotalMaybe + TotalNo) .. " Tasks:   " .. yes .. " |cff1aff1a" .. TotalYes .. "|r    " .. maybe .. " " .. TotalMaybe .. "    " .. no .. " |cffff0000" .. TotalNo .. "|r")
		else
			if prof1Name == "Alchemy" or prof2Name == "Alchemy" then
				AddLabel("Alchemy")
				AddRow(CheckAnyQuest("70533,70530,70531,70532"), nil, QuestNormal .. " |cffffd100Alchemy Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("72427,66940,66938,66937,75363,75371"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("66373,66374"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70511"), 463558, "|cff0070ddElementious Splinter|r", "|cff9d9d9dDrops from |rElementals")
				AddRow(CheckQuests("70504"), 1500941, "|cff0070ddDecaying Phlegm|r", "|cff9d9d9dDrops from |rDecay Elementals")
				AddRow(CheckQuests("74108"), 3615513, "|cff0070ddDraconic Treatise on Alchemy|r", "|cff9d9d9dCrafted with |rInscription")
			end
			
			if prof1Name == "Blacksmithing" or prof2Name == "Blacksmithing" then
				AddLabel("Blacksmithing")
				AddRow(CheckAnyQuest("70234,70211,70233,70235"), nil, QuestNormal .. " |cffffd100Blacksmithing Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("66897,66941,66517,72398,75569,75148"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70589"), nil, QuestNormal .. " |cffffd100Blacksmithing Services Requested|r", "|cff9d9d9dComplete 3 Work Orders|r")
				AddRow(CheckQuests("66381,66382"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70512"), 962047, "|cff0070ddPrimeval Earth Fragment|r", "|cff9d9d9dDrops from |rEarth Elementals")
				AddRow(CheckQuests("70513"), 451169, "|cff0070ddMolten Globule|r", "|cff9d9d9dDrops from |rFire Elementals")
				AddRow(CheckQuests("74109"), 3618821, "|cff0070ddDraconic Treatise on Blacksmithing|r", "|cff9d9d9dCrafted with |rInscription")
			end
			
			if prof1Name == "Enchanting" or prof2Name == "Enchanting" then
				AddLabel("Enchanting")
				AddRow(CheckAnyQuest("72175,72172,72155,72173"), nil, QuestNormal .. " |cffffd100Enchanting Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("72423,66900,66935,66884,75865,75150"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("66377,66378"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70514"), 237016, "|cff0070ddPrimordial Aether|r", "|cff9d9d9dDrops from |rArcane Elementals")
				AddRow(CheckQuests("70515"), 1379232, "|cff0070ddPrimalist Charm|r", "|cff9d9d9dDrops from |rPrimalists")
				AddRow(CheckQuests("74110"), 3615911, "|cff0070ddDraconic Treatise on Enchanting|r", "|cff9d9d9dCrafted with |rInscription")
			end
			
			if prof1Name == "Herbalism" or prof2Name == "Herbalism" then
				AddLabel("Herbalism")
				AddRow(CheckAnyQuest("70615,70614,70613,70616"), nil, QuestNormal .. " |cffffd100Herbalism Weekly|r", "|cff9d9d9dTurn in specific herbs|r")
				AddRow(CheckQuests("71857,71858,71859,71860,71861"), 959796, "|cff0070ddDreambloom Petal|r", "|cff9d9d9dCan drop while gathering any herb|r")
				AddRow(CheckQuests("71864"), 959795, "|cffa335eeDreambloom|r", "|cff9d9d9dCan drop while gathering any herb|r")
				AddRow(CheckQuests("74107"), 3615517, "|cff0070ddDraconic Treatise on Herbalism|r", "|cff9d9d9dCrafted with |rInscription")
			end
			
			if prof1Name == "Inscription" or prof2Name == "Inscription" then
				AddLabel("Inscription")
				AddRow(CheckAnyQuest("70561,70560,70559,70558"), nil, QuestNormal .. " |cffffd100Inscription Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("72438,66945,66943,66944,75573,75149"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70592"), nil, QuestNormal .. " |cffffd100Inscription Services Requested|r", "|cff9d9d9dComplete 2 Work Orders|r")
				AddRow(CheckQuests("66375,66376"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70518"), 134420, "|cff0070ddCurious Djaradin Rune|r", "|cff9d9d9dDrops from |rDjaradin")
				AddRow(CheckQuests("70519"), 348560, "|cff0070ddDraconic Glamour|r", "|cff9d9d9dDrops from |rSundered Flame Draconids")
				AddRow(CheckQuests("74105"), 3615518, "|cff0070ddDraconic Treatise on Inscription|r", "|cff9d9d9dCrafted with |rInscription")
			end
			
			if prof1Name == "Jewelcrafting" or prof2Name == "Jewelcrafting" then
				AddLabel("Jewelcrafting")
				AddRow(CheckAnyQuest("70563,70564,70562,70565"), nil, QuestNormal .. " |cffffd100Jewelcrafting Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("66516,66949,66950,72428,75362,75602"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70593"), nil, QuestNormal .. " |cffffd100Jewelcrafting Services Requested|r", "|cff9d9d9dComplete 2 Work Orders|r")
				AddRow(CheckQuests("66388,66389"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70520"), 132879, "|cff0070ddIncandescent Curio|r", "|cff9d9d9dDrops from |rEarth Elementals")
				AddRow(CheckQuests("70521"), 134890, "|cff0070ddElegantly Engraved Embellishment|r", "|cff9d9d9dDrops from |rSundered Flame Draconids")
				AddRow(CheckQuests("74112"), 3615519, "|cff0070ddDraconic Treatise on Jewelcrafting|r", "|cff9d9d9dCrafted with |rInscription")
			end
			
			if prof1Name == "Leatherworking" or prof2Name == "Leatherworking" then
				AddLabel("Leatherworking")
				AddRow(CheckAnyQuest("70567,70568,70571,70569"), nil, QuestNormal .. " |cffffd100Leatherworking Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("66951,66363,66364,72407,75354,75368"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70594"), nil, QuestNormal .. " |cffffd100 Leatherworking Services Requested|r", "|cff9d9d9dComplete 3 Work Orders|r")
				AddRow(CheckQuests("66384,66385"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70522"), 1377086, "|cff0070ddOssified Hide|r", "|cff9d9d9dDrops from |rProto-Drakes")
				AddRow(CheckQuests("70523"), 466842, "|cff0070ddExceedingly Soft Skin|r", "|cff9d9d9dDrops from |rVorquin")
				AddRow(CheckQuests("74113"), 3615520, "|cff0070ddDraconic Treatise on Leatherworking|r", "|cff9d9d9dCrafted with |rInscription")
			end
			
			if prof1Name == "Mining" or prof2Name == "Mining" then
				AddLabel("Mining")
				AddRow(CheckAnyQuest("72157,70617,70618,72156"), nil, QuestNormal .. " |cffffd100Mining Weekly|r", "|cff9d9d9dTurn in specific materials|r")
				AddRow(CheckQuests("70381,70383,70384,70385,70386"), 961627, "|cff0070ddIridescent Ore Fragments|r", "|cff9d9d9dCan drop while mining any node|r")
				AddRow(CheckQuests("70389"), 134563, "|cffa335eeIridescent Ore|r", "|cff9d9d9dCan drop while mining any node|r")
				AddRow(CheckQuests("74106"), 3615521, "|cff0070ddDraconic Treatise on Mining|r", "|cff9d9d9dCrafted with |rInscription")
			end
			
			if prof1Name == "Skinning" or prof2Name == "Skinning" then
				AddLabel("Skinning")
				AddRow(CheckAnyQuest("70620,72159,72158,70619"), nil, QuestNormal .. " |cffffd100Skinning Weekly|r", "|cff9d9d9dTurn in specific materials|r")
				AddRow(CheckQuests("70381,70383,70384,70385,70386"), 4559226, "|cff0070ddCurious Hide Scraps|r", "|cff9d9d9dCan drop while skinning any creature|r")
				AddRow(CheckQuests("70389"), 4559228, "|cffa335eeLarge Sample of Curious Hide|r", "|cff9d9d9dCan drop while skinning any creature|r")
				AddRow(CheckQuests("74114"), 4625106, "|cff0070ddDraconic Treatise on Skinning|r", "|cff9d9d9dCrafted with |rInscription")
			end

			if prof1Name == "Tailoring" or prof2Name == "Tailoring"then
				AddLabel("Tailoring")
				AddRow(CheckAnyQuest("70587,70572,70582,70586"), nil, QuestNormal .. " |cffffd100Tailoring Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("66899,66953,66952,72410,75407,75600"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70595"), nil, QuestNormal .. " |cffffd100Tailoring Services Requested|r", "|cff9d9d9dComplete 3 Work Orders|r")
				AddRow(CheckQuests("66386,66387"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70524"), 463527, "|cff0070ddOhn'ahran Weave|r", "|cff9d9d9dDrops from |rNokhud Centaurs")
				AddRow(CheckQuests("70525"), 2032604, "|cff0070ddStupidly Effective Stitchery|r", "|cff9d9d9dDrops from |rGnolls")
				AddRow(CheckQuests("74115"), 3615523, "|cff0070ddDraconic Treatise on Tailoring|r", "|cff9d9d9dCrafted with |rInscription")
			end

			if prof1Name == "Engineering" or prof2Name == "Engineering"then
				AddLabel("Engineering")
				AddRow(CheckAnyQuest("70557,70545,70539,70540"), nil, QuestNormal .. " |cffffd100Engineering Weekly|r", "|cff9d9d9dCrafting quest|r")
				AddRow(CheckAnyQuest("66942,66891,72396,66890,75575,75608"), nil, QuestNormal .. " |cffffd100Artisan's Market Weekly|r", "|cff9d9d9dCollection quest|r")
				AddRow(CheckQuests("70591"), nil, QuestNormal .. " |cffffd100Engineering Services Requested|r", "|cff9d9d9dComplete 2 Work Orders|r")
				AddRow(CheckQuests("66379,66380"), 1060570, "|cff0070ddExpedition Treasures|r", CheckItems(191304, 1060570, "|cffffffffSturdy Expedition Shovel|r"))
				AddRow(CheckQuests("70516"), 2000861, "|cff0070ddKeeper's Mark|r", "|cff9d9d9dDrops from |rTitan Constructs")
				AddRow(CheckQuests("70517"), 2115322, "|cff0070ddInfinitely Attachable Pair o' Docks|r", "|cff9d9d9dDrops from |rDragonkin")
				AddRow(CheckQuests("74111"), 4624728, "|cff0070ddDraconic Treatise on Engineering|r", "|cff9d9d9dCrafted with |rInscription")
			end

			AddSpace()
			OutputFrame:SetStatusText("")
		end

		----
		OutputFrame:SetWidth(700)
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
	elseif keyword == "delete" then
		if options and ArmyDB[options] then
			print("Removing saved data for", options)
			ArmyDB[options] = nil
		elseif options then
			print("No entry found for \"" .. options .. "\" - make sure you type the full character and realm name (case sensitive)")
			print("Usage: /army delete Name-Realm Name")
		end
	else
		local totalMoney = 0
		local faction,_ = UnitFactionGroup("player")
		local name = UnitName("player")
		local realm = GetRealmName()
		local currencyTable = {}

		for k, v in pairs(ArmyDB) do
			local c = ArmyDB[k]

			currencyTable[k] = c["Money"] or 0
			totalMoney = totalMoney + c["Money"]
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

		OutputFrame:SetStatusText("Account Total:  " .. FormatLargeNumber(floor(totalMoney / 10000)) .. " |TInterface/MoneyFrame/UI-GoldIcon:14:14|t")
		OutputFrame:SetWidth(450)
		OutputFrame:SetHeight(520)
		OutputFrame:Show()
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
