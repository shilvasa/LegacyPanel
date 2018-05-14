function LegacyPanel_OnLoadLegacyItem(self)
    LegacyPanel_InitializeAbilityItem(self);
    self.title:Hide();
	LegacyPanel.LegacyItem[self.id] = self;
end

function LegacyPanel_OnEnterLegacyItem(self, motion)
    self.highlight:SetVertexColor(0, 1, 0, 1);
    self.highlight:Show();
	local legacy = Legacy_GetLegacyItemByPos(self.id);
	if (legacy ~= nil) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
		GameTooltip:SetHyperlink("item:"..legacy.entry);
		--[[
		local cost = LEGACY_ITEM_COST_PRICELESS;
		local available = LEGACY_ITEM_INHERITED;
		if (legacy.cost > 0) then
			cost = format(LEGACY_ITEM_INHERIT_COST, legacy.cost);
		end
		if (legacy.acquirable) then
			available = LEGACY_ITEM_INHERIT;
			if (legacy.cost == 0) then
				available = LEGACY_ITEM_INHERIT_PRICELESS;
			end
		end
		]]--
		GameTooltip:AddDoubleLine(cost, available);
		GameTooltip:Show();
	end
end

function LegacyPanel_OnLeaveLegacyItem(self, motion)
    self.highlight:Hide();
    GameTooltip:Hide();
end

function LegacyPanel_OnClickLegacyItem(self, button, down)
	if (button == "LeftButton") then
		local legacy = Legacy_GetLegacyItemByPos(self.id);
		if (legacy ~= nil) then
			if (IsDressableItem(legacy.entry)) then
				DressUpItemLink(Legacy_GetItemLink(legacy.entry));
			end
		end
	elseif (button == "RightButton") then
	--[[
		local legacy = Legacy_GetLegacyItemByPos(self.id);
		if (legacy ~= nil and legacy.acquirable) then
			local link = Legacy_GetItemLink(legacy.entry);
			local popup = StaticPopup_Show("LEGACY_FETCH_LEGACY_ITEM_CONFIRM", link, legacy.cost);
			popup.entry = legacy.entry;
			popup.cost = legacy.cost;
		end
	]]--
	end
end

function LegacyPanel_FetchLegacyItem(entry)
	Legacy_DoQuery(LMSG_A_FETCH_LEGACY_ITEM, entry);
end

function LegacyPanel_UpdateLegacyItems()
	for i = 1, LEGACY_MAX_LEGACY_ITEM_PER_PAGE do
		local item = LegacyPanel.LegacyItem[i];
		local legacy = Legacy_GetLegacyItemByPos(i);
		if (legacy ~= nil) then
			item.icon:SetTexture(GetItemIcon(legacy.entry));
			if (legacy.cost == 0) then
				item.desc:SetText(LEGACY_INFINITE_MARK);
			else
				item.desc:SetText(legacy.cost);
			end
			if (not legacy.acquirable) then
				item.icon:SetDesaturated(true);
			else
				item.icon:SetDesaturated(false);
			end
			item:Show();
		else
			item:Hide();
		end
	end
end

function LegacyPanel_UpdateLegacyNavState()
	local itemCount = #Legacy.Data.LegacyItems;
	if (LegacyPanel.LegacyItemPage > 0) then
		LegacyPanel.LegacyItemNavButton[1].icon:SetDesaturated(false);
	else
		LegacyPanel.LegacyItemNavButton[1].icon:SetDesaturated(true);
	end
	if (LegacyPanel.LegacyItemPage * LEGACY_MAX_LEGACY_ITEM_PER_PAGE + LEGACY_MAX_LEGACY_ITEM_PER_PAGE >= itemCount) then
		LegacyPanel.LegacyItemNavButton[2].icon:SetDesaturated(true);
	else
		LegacyPanel.LegacyItemNavButton[2].icon:SetDesaturated(false);
	end
end

function LegacyPanel_OnLoadLegacyNavButtonItem(self)
	LegacyPanel_InitializeAbilityItem(self);
    self.title:Hide();
    self.desc:Hide();
	self.icon:SetTexture(LEGACY_NAV_ARROW[self.id]);
	LegacyPanel.LegacyItemNavButton[self.id] = self;
end

function LegacyPanel_OnEnterLegacyNavButtonItem(self, motion)
end

function LegacyPanel_OnLeaveLegacyNavButtonItem(self, motion)
end

function LegacyPanel_OnClickLegacyNavButtonItem(self, button, down)
	local itemCount = #Legacy.Data.LegacyItems;
	if (self.id == 1) then
		if (LegacyPanel.LegacyItemPage > 0) then
			LegacyPanel.LegacyItemPage = LegacyPanel.LegacyItemPage - 1;
			LegacyPanel_UpdateLegacyItems();
			LegacyPanel_UpdateLegacyNavState();
		end
	elseif (self.id == 2) then
		if (LegacyPanel.LegacyItemPage * 36 + 36 < itemCount) then
			LegacyPanel.LegacyItemPage = LegacyPanel.LegacyItemPage + 1;
			LegacyPanel_UpdateLegacyItems();
			LegacyPanel_UpdateLegacyNavState();
		end
	end
end
