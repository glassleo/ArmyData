SLASH_ARMYDATA1 = "/army"

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

	-- Dungeon and Raid
	["Valor"] = 1191,

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
	["Trial of Style Token"] = 1379,
	["Brawler's Gold"] = 1299,

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
	-- Legion
	["Blood of Sargeras"] = 124124,

	-- PvP
	["Mark of Honor"] = 137642,

	-- Battle Pets
	["Polished Pet Charm"] = 163036,
	["Shiny Pet Charm"] = 116415,
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


local function updateData()
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
			["Currencies"] = {},
			["Items"] = {},
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


function GetSimpleItemInfo(id)
	if id == 124124 then return "|cff0070ddBlood of Sargeras|r", 1417744
	elseif id == 137642 then return "|cff0070ddMark of Honor|r", 1322720
	elseif id == 116415 then return "Shiny Pet Charm", 413584
	elseif id == 163036 then return "Polished Pet Charm", 2004597
	else return id, 134400
	end
end


-- Slash Commands
function SlashCmdList.ARMYDATA(msg, editbox)
	updateData()

	if currencies[msg] then
		local currencyName = msg
		local currencyTable = {}
		local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencies[currencyName]) or {}
		local name = currencyInfo["name"] or "Unknown"
		local icon = currencyInfo["iconFileID"] or 0

		for character in pairs(ArmyDB) do
			currencyTable[character] = ArmyDB[character].Currencies[currencyName] or 0
		end

		-- Sort the table
		local sortedCurrencyTable = getKeysSortedByValue(currencyTable, function(a, b) return a > b end)

		DEFAULT_CHAT_FRAME:AddMessage("---")
		DEFAULT_CHAT_FRAME:AddMessage("|T" .. icon .. ":0|t " .. name)

		for i, k in ipairs(sortedCurrencyTable) do
			if i <= 7 then
				DEFAULT_CHAT_FRAME:AddMessage(i .. " - " .. k .. ": " .. FormatLargeNumber(currencyTable[k] or 0))
			end
		end
	elseif items[msg] then
		local itemName = msg
		local itemTable = {}
		local name, icon = GetSimpleItemInfo(items[itemName])

		for character in pairs(ArmyDB) do
			itemTable[character] = ArmyDB[character].Items[itemName] or 0
		end

		-- Sort the table
		local sortedItemTable = getKeysSortedByValue(itemTable, function(a, b) return a > b end)

		DEFAULT_CHAT_FRAME:AddMessage("---")
		DEFAULT_CHAT_FRAME:AddMessage("|T" .. icon .. ":0|t " .. name)

		for i, k in ipairs(sortedItemTable) do
			if i <= 7 then
				DEFAULT_CHAT_FRAME:AddMessage(i .. " - " .. k .. ": " .. FormatLargeNumber(itemTable[k] or 0))
			end
		end
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

		DEFAULT_CHAT_FRAME:AddMessage(" ")
		DEFAULT_CHAT_FRAME:AddMessage("|TInterface/MoneyFrame/UI-GoldIcon:14:14|t Gold (Connected " .. realm .. ")")

		for i, k in ipairs(sortedCurrencyTable) do
			if i <= 5 then
				DEFAULT_CHAT_FRAME:AddMessage(i .. " - " .. k .. ": " .. (currencyTable[k] >= 100000 and FormatLargeNumber(floor((currencyTable[k]) / 10000)) .. " |TInterface/MoneyFrame/UI-GoldIcon:14:14|t" or GetCoinTextureString(currencyTable[k] or 0)))
			end
		end
		
		DEFAULT_CHAT_FRAME:AddMessage(" ")
		DEFAULT_CHAT_FRAME:AddMessage("Connected " .. realm .. ":  " .. FormatLargeNumber(floor(realmMoney / 10000)) .. " |TInterface/MoneyFrame/UI-GoldIcon:14:14|t")
		DEFAULT_CHAT_FRAME:AddMessage("Account Total:  " .. FormatLargeNumber(floor(totalMoney / 10000)) .. " |TInterface/MoneyFrame/UI-GoldIcon:14:14|t")
	end
end


local function eventHandler(self, event)
	if event == "VARIABLES_LOADED" then
		-- Make sure defaults are set
		if not ArmyDB then ArmyDB = { } end
	else
		updateData()
	end
end

frame:SetScript("OnEvent", eventHandler)
