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


-- Dragonriding Customization
local barber = CreateFrame("FRAME", "AutomagicBarbershopFrame")
barber:RegisterEvent("BARBER_SHOP_FORCE_CUSTOMIZATIONS_UPDATE")
barber:RegisterEvent("BARBER_SHOP_CLOSE")
barber:RegisterEvent("BARBER_SHOP_APPEARANCE_APPLIED")
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
		-- Full Transoformation
		[2962] = "RenewedProtoDrakeTransformation",
		[2044] = "HighlandDrakeTransformation",
		[6397] = "WindingSlitherdrakeTransformation",
	}

	if event == "BARBER_SHOP_FORCE_CUSTOMIZATIONS_UPDATE" then
		local customizationData = C_BarberShop.GetAvailableCustomizations()

		if customizationData then
			for _, categoryData in ipairs(customizationData) do
	            local options = categoryData.options

	            for _, data in ipairs(options) do
	            	--print(categoryData.name, " ID:", data.id, " name:", data.name, " currentChoiceIndex:", data.currentChoiceIndex)
	            	local id, choice = data.id, data.currentChoiceIndex

	            	-- https://wago.tools/db2/ChrCustomizationOption?filter[Name_lang]=Skin%20Color&filter[ChrModelID]=124&page=1
	            	-- 124 = Renewed Proto-Drake
	            	-- 129 = Windborne Velocidrake
	            	-- 123 = Highland Drake
	            	-- 126 = Cliffside Wylderdrake
	            	-- 125 = Winding Slitherdrake
	            	-- 149 = Grotto Netherwing Drake
	            	-- 188 = Flourishing Whimsydrake

	            	--if id == 1611 then -- Renewed Proto-Drake: Skin Color
	            		--print("Renewed Proto-Drake -", data.name, choice)
	            		--UpdateSpecificData("RenewedProtoDrake", choice)
	            	--end
	            	
	            	if keys[id] then
	            		UpdateSpecificData(keys[id], choice)
	            		print(keys[id], "set to", choice) -- Debug
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

	if(msg == "key" or msg == "keys" or msg == "keystone" or msg == "keystones" or msg == "m+") then
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
	else
		UpdateData()
	end
end

frame:SetScript("OnEvent", eventHandler)
