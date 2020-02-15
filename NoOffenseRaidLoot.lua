local NoOffenseRaidLoot, NoOffenseRaidLoot = ...
local labelRed = 162/255
local labelGreen = 49/255
local labelBlue = 49/255
local valueRed = 255/255
local valueGreen = 210/255
local valueBlue = 0/255

local function GameTooltip_OnTooltipSetItem(tooltip)
	local currentItemName = tooltip:GetItem()
  if not currentItemName then return; end
	
	local raidItem = NoOffenseRaidLoot.items[currentItemName]
	if not raidItem then return; end

	local bisFor = raidItem.bisFor

	if bisFor == "" then
		bisFor = 'None'
	end

	tooltip:AddLine(" ")
	tooltip:AddDoubleLine('NO BIS: ', bisFor, labelRed, labelGreen, labelBlue, valueRed, valueGreen, valueBlue)
	tooltip:AddDoubleLine('NO GP: ', raidItem.gp, labelRed, labelGreen, labelBlue, valueRed, valueGreen, valueBlue)
end

GameTooltip:HookScript("OnTooltipSetItem", GameTooltip_OnTooltipSetItem)
