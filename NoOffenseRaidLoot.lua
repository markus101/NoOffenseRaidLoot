local NoOffenseRaidLoot, NoOffenseRaidLoot = ...
local labelRed = 162/255
local labelGreen = 49/255
local labelBlue = 49/255
local valueRed = 255/255
local valueGreen = 210/255
local valueBlue = 0/255

local isGameTooltipDone
local isItemRefTooltipDone

local function ProcessTooltip(tooltip, link)
	-- SendChatMessage("Showing Tooltip", "PARTY"); -- DEBUG

	if not link then return; end

	-- Thanks Auctionator
	-- 1: name
	-- 2: itemLink
	-- 3: quality
	-- 4: iLevel
	-- 5: required Level
	-- 6: itemClass String
	-- 7: subClass String
	-- 8: ? (int)
	-- 9: WTF String
	-- 10: big int
	-- 11: itemVendorPrice? (big int)
	-- 12: itemClass int
	-- 13: subClass int
	local itemName, itemLink, itemRarity, _, itemMinLevel, itemType, _, _, _, _, itemVendorPrice, classID = GetItemInfo (link);

	if not itemName then return; end

	local raidItem = NoOffenseRaidLoot.items[itemName]
	if not raidItem then return; end

	local bisFor = raidItem.bisFor

	if bisFor == "" then
		bisFor = 'None'
	end

	tooltip:AddLine(" ")
	tooltip:AddDoubleLine('NO BIS: ', bisFor, labelRed, labelGreen, labelBlue, valueRed, valueGreen, valueBlue)
	tooltip:AddDoubleLine('NO GP: ', raidItem.gp, labelRed, labelGreen, labelBlue, valueRed, valueGreen, valueBlue)
end

local function GameTooltip_OnTooltipSetItem(tooltip, ...)
	if (not isGameTooltipDone) and tooltip then
		isGameTooltipDone = true

		local name, link = tooltip:GetItem()
		
		if link then
			ProcessTooltip(tooltip, link)
		end
	end
end

local function GameTooltip_OnTooltipCleared(tooltip, ...)
	isGameTooltipDone = nil
end

local function ItemRefTooltip_OnTooltipSetItem(tooltip, ...)
	if (not isItemRefTooltipDone) and tooltip then
		local _, link = tooltip:GetItem()
		isItemRefTooltipDone = true
		if link then
			ProcessTooltip(tooltip, link)
		end
	end
end

local function ItemRefTooltip_OnTooltipCleared(tooltip, ...)
	isItemRefTooltipDone = nil
end

GameTooltip:HookScript("OnTooltipSetItem", GameTooltip_OnTooltipSetItem)
GameTooltip:HookScript("OnTooltipCleared", GameTooltip_OnTooltipCleared)

ItemRefTooltip:HookScript("OnTooltipSetItem", ItemRefTooltip_OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipCleared", ItemRefTooltip_OnTooltipCleared)
