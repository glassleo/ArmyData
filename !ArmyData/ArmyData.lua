SLASH_ARMYDATA1 = "/army"

local frame = CreateFrame("FRAME", "ArmyData")

frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("PLAYER_MONEY")
frame:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
frame:RegisterEvent("PLAYER_LOOT_SPEC_UPDATED")


local currencies = {
	-- Resources
	["GarrisonResources"] = 824,
	["Oil"] = 1101,
	["OrderResources"] = 1220,
	["WarResources"] = 1560,
	["ReservoirAnima"] = 1813,

	-- Dungeon and Raid
	["Valor"] = 1191,

	-- Player vs. Player
	["Honor"] = 1792,
	["Conquest"] = 1602,

	-- Bonus Rolls
	["LesserCharmOfGoodFortune"] = 738,
	["ElderCharmOfGoodFortune"] = 697,
	["MoguRuneOfFate"] = 752,
	["WarforgedSeal"] = 776,
	["SealOfTemperedFate"] = 994,
	["SealOfInevitableFate"] = 1129,
	["SealOfBrokenFate"] = 1273,
	["SealOfWartornFate"] = 1580,

	-- Events
	["TimewarpedBadge"] = 1166,
	["DarkmoonPrizeTicket"] = 515,
	["TrialOfStyleToken"] = 1379,
	["BrawlersGold"] = 1299,

	-- Burning Crusade
	["SpiritShard"] = 1704,

	-- Wrath of the Lich King
	["ChampionsSeal"] = 241,

	-- Cataclysm
	["TolBaradCommendation"] = 391,
	["MarkOfTheWorldTree"] = 416,
	["MoteOfDarkness"] = 614,
	["EssenceOfCorruptedDeathwing"] = 615,

	-- Mists of Pandaria
	["TimelessCoin"] = 777,

	-- Warlords of Draenor
	["ApexisCrystal"] = 823,

	-- Legion
	["CuriousCoin"] = 1275,
	["SightlessEye"] = 1149,
	["AncientMana"] = 1155,
	["Nethershard"] = 1226,
	["LegionfallWarSupplies"] = 1342,
	["VeiledArgunite"] = 1508,
	["WakeningEssence"] = 1533,

	-- Battle for Azeroth
	["SeafarersDubloon"] = 1710,
	["7thLegionServiceMedal"] = 1717,
	["HonorboundServiceMedal"] = 1716,
	["PrismaticManapearl"] = 1721,
	["TitanResiduum"] = 1718,
	["CoalescingVisions"] = 1755,
	["CorruptedMemento"] = 1744,
	["EchoesOfNyalotha"] = 1803,

	-- Shadowlands
	["GratefulOffering"] = 1885,
	["RedeemedSoul"] = 1810,
	["Stygia"] = 1767,
	["InfusedRuby"] = 1820,
	["SinstoneFragments"] = 1816,
	["MedallionOfService"] = 1819,
	["CatalogedResearch"] = 1931,
	["SoulAsh"] = 1828,
	["SoulCinders"] = 1906,
	["StygianEmber"] = 1977,

	-- Cooking
	["EpicureansAward"] = 81,
	["IronpawToken"] = 402,

	-- Jewelcrafting
	["DalaranJewelcraftersToken"] = 61,
	["IllustriousJewelcraftersToken"] = 361,

	-- Pick Pocketing
	["DingyIronCoins"] = 980,
	["CoinsOfAir"] = 1416,
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

		if professionIcon == 136247 then
			professionIcon = 133611 -- Fix incorrect Leatherworking icon
		end


		ArmyDB[name.."-"..realm] = {
			["Name"] = name,
			["Realm"] = realm,
			["Faction"] = faction,
			["Class"] = class,
			["Money"] = GetMoney() or 0,
			["LootSpec"] = GetLootSpecialization() or 0,
			["Profession"] = profession,
			["ProfessionIcon"] = professionIcon,
		}

		for currencyName, currencyID in pairs(currencies) do
			local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyID) or {}

			ArmyDB[name.."-"..realm][currencyName] = currencyInfo["quantity"] or 0
		end
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

		for k, v in pairs(ArmyDB) do
			local c = ArmyDB[k]

			currencyTable[k] = c[currencyName] or 0
		end

		-- Sort the table
		local sortedCurrencyTable = getKeysSortedByValue(currencyTable, function(a, b) return a > b end)

		DEFAULT_CHAT_FRAME:AddMessage("---")
		DEFAULT_CHAT_FRAME:AddMessage("|T" .. icon .. ":0|t " .. name)

		for i, k in ipairs(sortedCurrencyTable) do
			if i <= 9 then
				DEFAULT_CHAT_FRAME:AddMessage(i .. " - " .. k .. ": " .. FormatLargeNumber(currencyTable[k] or 0))
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

		DEFAULT_CHAT_FRAME:AddMessage("---")
		DEFAULT_CHAT_FRAME:AddMessage("|TInterface/MoneyFrame/UI-GoldIcon:14:14|t Gold (Connected " .. realm .. ")")

		for i, k in ipairs(sortedCurrencyTable) do
			if i <= 5 then
				DEFAULT_CHAT_FRAME:AddMessage(i .. " - " .. k .. ": " .. (currencyTable[k] >= 100000 and FormatLargeNumber(floor((currencyTable[k]) / 10000)) .. " |TInterface/MoneyFrame/UI-GoldIcon:14:14|t" or GetCoinTextureString(currencyTable[k] or 0)))
			end
		end
		
		DEFAULT_CHAT_FRAME:AddMessage("---")
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