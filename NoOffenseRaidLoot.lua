local NoOffenseRaidLoot, NoOffenseRaidLoot = ...
local labelRed = 162/255
local labelGreen = 49/255
local labelBlue = 49/255
local valueRed = 255/255
local valueGreen = 210/255
local valueBlue = 0/255

local function ShowTooltip(tooltip, link, num)
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
	tooltip:Show()
end

hooksecurefunc (GameTooltip, "SetMerchantItem",
  function(tooltip, index)
    local _, _, _, num = GetMerchantItemInfo(index);
    ShowTooltip(tooltip, GetMerchantItemLink(index), num);
  end
);

hooksecurefunc (GameTooltip, "SetBuybackItem",
  function(tooltip, index)
    local _, _, _, num = GetBuybackItemInfo(index);
    ShowTooltip(tooltip, GetBuybackItemLink(index), num);
  end
);



hooksecurefunc (GameTooltip, "SetBagItem",
  function(tooltip, bag, slot)
    local _, num = GetContainerItemInfo(bag, slot);
    ShowTooltip(tooltip, GetContainerItemLink(bag, slot), num);
  end
);

hooksecurefunc (GameTooltip, "SetAuctionItem",
  function (tooltip, type, index)
    local _, _, num = GetAuctionItemInfo(type, index);
    ShowTooltip(tooltip, GetAuctionItemLink(type, index), num);
  end
);

hooksecurefunc (GameTooltip, "SetAuctionSellItem",
  function (tooltip)
    local name, _, count = GetAuctionSellItemInfo();
    local __, link = GetItemInfo(name);
    ShowTooltip(tooltip, link, num);
  end
);

hooksecurefunc (GameTooltip, "SetLootItem",
  function (tooltip, slot)
    if LootSlotHasItem(slot) then
      local link, _, num = GetLootSlotLink(slot);
      ShowTooltip(tooltip, link, num);
    end
  end
);

hooksecurefunc (GameTooltip, "SetLootRollItem",
  function (tooltip, slot)
    local _, _, num = GetLootRollItemInfo(slot);
    ShowTooltip(tooltip, GetLootRollItemLink(slot), num);
  end
);

hooksecurefunc (GameTooltip, "SetInventoryItem",
  function (tooltip, unit, slot)
    ShowTooltip(tooltip, GetInventoryItemLink(unit, slot), GetInventoryItemCount(unit, slot));
  end
);

hooksecurefunc (GameTooltip, "SetTradePlayerItem",
  function (tooltip, id)
    local _, _, num = GetTradePlayerItemInfo(id);
    ShowTooltip(tooltip, GetTradePlayerItemLink(id), num);
  end
);

hooksecurefunc (GameTooltip, "SetTradeTargetItem",
  function (tooltip, id)
    local _, _, num = GetTradeTargetItemInfo(id);
    ShowTooltip(tooltip, GetTradeTargetItemLink(id), num);
  end
);

hooksecurefunc (GameTooltip, "SetQuestItem",
  function (tooltip, type, index)
    local _, _, num = GetQuestItemInfo(type, index);
    ShowTooltip(tooltip, GetQuestItemLink(type, index), num);
  end
);

hooksecurefunc (GameTooltip, "SetQuestLogItem",
  function (tooltip, type, index)
    local num, _;
    if type == "choice" then
      _, _, num = GetQuestLogChoiceInfo(index);
    else
      _, _, num = GetQuestLogRewardInfo(index)
    end

    ShowTooltip(tooltip, GetQuestLogItemLink(type, index), num);
  end
);

hooksecurefunc (GameTooltip, "SetInboxItem",
  function (tooltip, index, attachIndex)
    if AUCTIONATOR_SHOW_MAILBOX_TIPS == 1 then
      local attachmentIndex = attachIndex or 1
      local _, _, _, num = GetInboxItem(index, attachmentIndex);

      ShowTooltip(tooltip, GetInboxItemLink(index, attachmentIndex), num);
    end
  end
);

hooksecurefunc ( "InboxFrameItem_OnEnter",
  function ( self )
    local itemCount = select( 8, GetInboxHeaderInfo( self.index ) )
    local tooltipEnabled = AUCTIONATOR_SHOW_MAILBOX_TIPS == 1 and  (
      AUCTIONATOR_V_TIPS == 1 or AUCTIONATOR_A_TIPS == 1 or AUCTIONATOR_D_TIPS == 1
    )

    if tooltipEnabled and itemCount and itemCount > 1 then
      for numIndex = 1, ATTACHMENTS_MAX_RECEIVE do
        local name, _, _, num = GetInboxItem( self.index, numIndex )

        if name then
          local attachLink = GetInboxItemLink( self.index, numIndex ) or name

          GameTooltip:AddLine( attachLink )

          if num > 1 then
            Atr_ShowTipWithPricing( GameTooltip, attachLink, num )
          else
            Atr_ShowTipWithPricing( GameTooltip, attachLink )
          end
        end
      end
    end
  end
);

hooksecurefunc (GameTooltip, "SetSendMailItem",
  function (tooltip, id)
    local name, _, _, num = GetSendMailItem(id)
    local name, link = GetItemInfo(name);
    ShowTooltip(tooltip, link, num);
  end
);

hooksecurefunc (GameTooltip, "SetHyperlink",
  function (tooltip, itemstring, num)
    local name, link = GetItemInfo (itemstring);
    ShowTooltip(tooltip, link, num);
  end
);

hooksecurefunc (ItemRefTooltip, "SetHyperlink",
  function (tooltip, itemstring)
    local name, link = GetItemInfo (itemstring);
    ShowTooltip(tooltip, link);
  end
);
