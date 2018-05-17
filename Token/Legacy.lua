function LegacyPanel_OnLoadLegacyItemToken(self)
    LegacyPanel_InitToken(self);
	self.entry = 0;
    self.Title:Hide();
end

function LegacyPanel_OnEnterLegacyItemToken(self, motion)
    self.Highlight:SetVertexColor(0, 1, 0, 1);
    self.Highlight:Show();
	if (self.entry ~= 0) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
		GameTooltip:SetHyperlink("item:"..self.entry);
		GameTooltip:Show();
	end
end

function LegacyPanel_OnLeaveLegacyItemToken(self, motion)
    self.Highlight:Hide();
    GameTooltip:Hide();
end

function LegacyPanel_OnClickLegacyToken(self, button, down)
	if (button == "LeftButton") then
		if (self.entry ~= 0) then
			if (IsDressableItem(self.entry)) then
				DressUpItemLink(Legacy_GetItemLink(self.entry));
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

function LegacyPanel_UpdateLegacyItem()
	for i = 1, LEGACY_MAX_LEGACY_ITEM_PER_PAGE do
		local token = Legacy.UI.Legacy.Item[i];
		local legacy = Legacy.Data.Env.Legacy[i+Legacy.Var.Nav.Page.Legacy*LEGACY_MAX_LEGACY_ITEM_PER_PAGE];
		token.data = legacy;
		if (legacy ~= nil) then
			token.entry = legacy.entry;
			token.Icon:SetTexture(GetItemIcon(legacy.entry));
			if (legacy.cost == 0) then
				token.Desc:SetText(LEGACY_INFINITE_MARK);
			else
				token.Desc:SetText(legacy.cost);
			end
			if (not legacy.acquirable) then
				token.Icon:SetDesaturated(true);
			else
				token.Icon:SetDesaturated(false);
			end
			token:Show();
		else
			token.entry = 0;
			token:Hide();
		end
	end
end

function LegacyPanel_UpdateLegacyItemNavState()
	local itemCount = #Legacy.Data.Env.Legacy;
	if (Legacy.Var.Nav.Page.Legacy > 0) then
		Legacy.UI.Legacy.Nav[LEGACY_NAV_PREV].more = true;
		Legacy.UI.Legacy.Nav[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.Legacy.Nav[LEGACY_NAV_PREV].more = false;
		Legacy.UI.Legacy.Nav[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	if ((Legacy.Var.Nav.Page.Legacy+1)*LEGACY_MAX_LEGACY_ITEM_PER_PAGE >= itemCount) then
		Legacy.UI.Legacy.Nav[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.Legacy.Nav[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.Legacy.Nav[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.Legacy.Nav[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
end

function LegacyPanel_OnLoadLegacyItemNavToken(self)
	LegacyPanel_InitToken(self);
    self.Title:Hide();
    self.Desc:Hide();
	self.Icon:SetTexture(LEGACY_NAV_ARROW[self.Id]);
end

function LegacyPanel_OnEnterLegacyItemNavToken(self, motion)
end

function LegacyPanel_OnLeaveLegacyItemNavToken(self, motion)
end

function LegacyPanel_OnClickLegacyItemNavToken(self, button, down)
	if (self.more) then
		if (self == Legacy.UI.Legacy.Nav[LEGACY_NAV_PREV]) then
			Legacy.Var.Nav.Page.Legacy = Legacy.Var.Nav.Page.Legacy - 1;
		else
			Legacy.Var.Nav.Page.Legacy = Legacy.Var.Nav.Page.Legacy + 1;
		end
		LegacyPanel_UpdateLegacyItem();
		LegacyPanel_UpdateLegacyItemNavState();
	end
end
