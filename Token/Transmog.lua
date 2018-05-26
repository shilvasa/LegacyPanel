function LegacyPanel_OnLoadTransmogToken(self)
	LegacyPanel_InitToken(self);
	local info = LEGACY_TRANSMOG_SLOT[self:GetID()];
	self.Icon:SetTexture(info.Icon);
	self.Desc:SetText(info.Name);
	self.Title:Hide();
	self.entry = 0;
end

function LegacyPanel_OnEnterTransmogToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
	self.Highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.entry ~= 0) then
		local r, g, b = Legacy_GetQualityColor(TransmogData[self.entry].quality);
		GameTooltip:AddDoubleLine(format("%s (%s)", TransmogData[self.entry].name, LEGACY_TRANSMOG_SLOT[self.Id].Name), " ", r, g, b, 0, 1, 0);
	else
		GameTooltip:AddDoubleLine(format("%s (%s)", LEGACY_EMPTY_TRANSMOG_SLOT, LEGACY_TRANSMOG_SLOT[self.Id].Name), " ", 1, 1, 1, 0, 1, 0);
	end
	
	local tLength = Legacy_TLength(LEGACY_EQUIP_SLOTS[self.Id]);
	if (tLength > 1) then -- more than 1
		_G[GameTooltip:GetName().."TextRight1"]:SetText(format(LEGACY_CLICK_TO_EXPAND, tLength));
		_G[GameTooltip:GetName().."TextRight1"]:Show();
	else
		_G[GameTooltip:GetName().."TextRight1"]:SetText(LEGACY_EXPAND_TRANSMOG_COLLECTION_CLICK_HINT);
		_G[GameTooltip:GetName().."TextRight1"]:Show();
	end
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveTransmogToken(self, motion)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickTransmogToken(self, button, down)
	local tLength = Legacy_TLength(LEGACY_EQUIP_SLOTS[self.Id]);
	Legacy.Var.Nav.Selected.Transmog = self.Id;
	if (tLength > 1) then
		Legacy.UI.Transmog.SlotFrame:SetPoint("CENTER", self, "CENTER", 0, 0);
		LegacyPanel_UpdateTransmogSlot();
		Legacy.UI.Transmog.SlotFrame:Show();
		Legacy.UI.Transmog.Frame:Hide();
	else
		local slot = LEGACY_EQUIP_SLOTS[self.Id][0];
		Legacy.Var.Nav.Selected.TransmogSlot = slot.Slot;
		Legacy.UI.Transmog.Coll[0].Desc:SetText(self.Desc:GetText());
		Legacy.UI.Transmog.Coll[0].Desc:Show();
		Legacy.UI.Transmog.Coll[0].Icon:SetTexture(slot.Icon);
		Legacy.UI.Transmog.Coll[0].Icon:SetDesaturated(true);
		Legacy.Var.Nav.Page.TransmogCollection = 0;
		LegacyPanel_LoadTransmogCollection();
		Legacy.UI.Transmog.CollFrame:Show();
		Legacy.UI.Transmog.Frame:Hide();
	end
end

function LegacyPanel_UpdateTransmog()
	for i = LEGACY_EQUIP_SLOT_HEAD, LEGACY_EQUIP_SLOT_RANGED do
		local info = LEGACY_TRANSMOG_SLOT[i];
		if (info ~= nil) then
			local token = Legacy.UI.Transmog.EquipSlot[i];
			local transmog = Legacy.Data.Transmog.EquipSlot[i];
			if (transmog ~= nil and transmog ~= 0) then
				token.entry = transmog;
				token.Icon:SetTexture(GetItemIcon(transmog));
				token.Border:SetVertexColor(Legacy_GetQualityColor(TransmogData[transmog].quality));
			else
				token.entry = 0;
				token.Icon:SetTexture(info.Icon);
				token.Border:SetVertexColor(Legacy_GetQualityColor(0));
			end
		end
	end
end

function LegacyPanel_OnLoadTransmogSlotToken(self)
	LegacyPanel_InitToken(self);
	self.Title:Hide();
	self.Desc:Show();
	self.entry = 0;
	if (self.Id == 0) then
		self.Border:SetVertexColor(1, 1, 1, 1);
	else
		self.Border:SetVertexColor(0.5, 0.5, 0.5, 1);
	end
end

function LegacyPanel_FormatTransmogSlotTip(self)
	if (self.Id ~= 0 and GameTooltip:GetOwner() == self) then
		GameTooltip:ClearLines();
		local left, right = "";
		local r, g, b;
		left = format("%s - %s", LEGACY_TRANSMOG_SLOT[Legacy.Var.Nav.Selected.Transmog].Name, self.Desc:GetText());
		if (self.entry ~= 0) then
			right = TransmogData[self.entry].name;
			r, g, b = Legacy_GetQualityColor(TransmogData[self.entry].quality);
		else
			right = LEGACY_EMPTY_TRANSMOG_SLOT;
			r = 1; b = 1; g = 1;
		end
		GameTooltip:AddDoubleLine(left, right, r, g, b, r, g, b);
		GameTooltip:AddDoubleLine(LEGACY_CLICK, LEGACY_EXPAND_TRANSMOG_COLLECTION, 0, 1, 0, 0, 1, 0);
	end
end

function LegacyPanel_OnEnterTransmogSlotToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
	self.Highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.Id == 0) then
		GameTooltip:AddLine(LEGACY_RETURN, 0, 1, 0);
	else
		LegacyPanel_FormatTransmogSlotTip(self);
	end
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveTransmogSlotToken(self, motion)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickTransmogSlotToken(self, button, down)
	if (self.Id == 0) then
		Legacy.UI.Transmog.SlotFrame:Hide();
		Legacy.UI.Transmog.Frame:Show();
		Legacy.Var.Nav.Selected.TransmogSlot = -1;
	else
		Legacy.Var.Nav.Selected.TransmogSlot = self.data.Slot;
		Legacy.UI.Transmog.Coll[0].Desc:SetText(self.Desc:GetText());
		Legacy.UI.Transmog.Coll[0].Desc:Show();
		Legacy.UI.Transmog.Coll[0].Icon:SetTexture(self.data.Icon);
		Legacy.UI.Transmog.Coll[0].Icon:SetDesaturated(true);
		Legacy.Var.Nav.Page.TransmogCollection = 0;
		LegacyPanel_LoadTransmogCollection();
		Legacy.UI.Transmog.CollFrame:Show();
		Legacy.UI.Transmog.SlotFrame:Hide();
	end
end

function LegacyPanel_UpdateTransmogSlot()
	if (Legacy.Var.Nav.Selected.Transmog < 0) then
		return;
	end
	local itemToken = Legacy.UI.Transmog.Slot[0];
	itemToken.entry = Legacy.Data.Transmog.Slot[Legacy.Var.Nav.Selected.Transmog];
	if (Legacy.UI.Transmog.EquipSlot[Legacy.Var.Nav.Selected.Transmog].entry ~= 0) then
		itemToken.Icon:SetTexture(GetItemIcon(Legacy.UI.Transmog.EquipSlot[Legacy.Var.Nav.Selected.Transmog].entry));
		itemToken.Border:SetVertexColor(Legacy_GetQualityColor(TransmogData[Legacy.UI.Transmog.EquipSlot[Legacy.Var.Nav.Selected.Transmog].entry].quality));
	else
		itemToken.Icon:SetTexture(LEGACY_TRANSMOG_SLOT[Legacy.Var.Nav.Selected.Transmog].Icon);
		itemToken.Border:SetVertexColor(Legacy_GetQualityColor(0));
	end
	itemToken.Desc:SetText(LEGACY_TRANSMOG_SLOT[Legacy.Var.Nav.Selected.Transmog].Name);
	itemToken.Desc:Show();
	
	local index = 1;
	for k, v in pairs(LEGACY_EQUIP_SLOTS[Legacy.Var.Nav.Selected.Transmog]) do
		local token = Legacy.UI.Transmog.Slot[k+1];
		local transmog = Legacy.Data.Transmog.Slot[v.Slot];
		token.data = v;
		if (transmog ~= nil and transmog ~= 0) then
			token.entry = transmog;
			token.Icon:SetTexture(GetItemIcon(transmog));
			token.Icon:SetDesaturated(false);
			token.Border:SetVertexColor(Legacy_GetQualityColor(TransmogData[transmog].quality));
		else
			token.entry = 0;
			token.Icon:SetTexture(v.Icon);
			token.Icon:SetDesaturated(true);
			token.Border:SetVertexColor(Legacy_GetQualityColor(0));
		end
		token.Desc:SetText(v.Name);
		token.Desc:Show();
		token:Show();
		if (k >= index) then
			index = k + 2;
		end
	end
	
	for i = index, LEGACY_MAX_TRANSMOG_TYPE_SLOT do
		Legacy.UI.Transmog.Slot[i].entry = 0;
		Legacy.UI.Transmog.Slot[i].data = nil;
		Legacy.UI.Transmog.Slot[i]:Hide();
	end
end

-----------------------

function LegacyPanel_OnLoadTransmogCollectionToken(self)
	LegacyPanel_InitToken(self);
	self.Title:Hide();
	self.Desc:Hide();
	if (self.Id == 0) then
		self.Desc:SetVertexColor(1, 1, 1, 1);
	else
		self.Desc:SetVertexColor(0, 1, 0, 1);
	end
	self.entry = 0;
	self.updated = true;
end

function LegacyPanel_OnEnterTransmogCollectionToken(self, motion)
	self.Highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.Id == 0) then
		GameTooltip:AddLine(LEGACY_RETURN, 0, 1, 0);
	else
		if (self.entry ~= 0) then
			local collected = Legacy_TransmogCollected(self.entry);
			local r, g, b = Legacy_GetQualityColor(self.data.quality);
			local rr = 0.5;
			local rg = 0.5;
			local rb = 0.5;
			local c = LEGACY_TRANSMOG_NOT_COLLECTED;
			if (collected) then
				rr = 0;
				rg = 1;
				rb = 0;
				c = LEGACY_TRANSMOG_COLLECTED;
			end
			GameTooltip:AddDoubleLine(self.data.name, c, r, g, b, rr, rg, rb);
			
			GameTooltip:AddLine(LEGACY_TRANSMOG_PREVIEW_LEFT_CLICK_HINT, 0, 1, 0);
			
			if (not collected) then
				GameTooltip:AddDoubleLine(LEGACY_TRANSMOG_COLLECT_RIGHT_CLICK_HINT, format(LEGACY_TRANSMOG_COLLECT_COST_HINT, self.data.price), 0, 1, 0, 0, 1, 0);
			else
				GameTooltip:AddLine(LEGACY_ACTIVATE_TRANSMOG_RIGHT_CLICK_HINT, 0, 1, 0);
			end
		end
	end
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveTransmogCollectionToken(self, motion)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickTransmogCollectionToken(self, button, down)
	if (self.Id == 0) then
		Legacy.UI.Transmog.CollFrame:Hide();
		local tLength = Legacy_TLength(LEGACY_EQUIP_SLOTS[Legacy.Var.Nav.Selected.Transmog]);
		if (tLength > 1) then
			Legacy.UI.Transmog.SlotFrame:Show();
		else
			Legacy.UI.Transmog.Frame:Show();
		end
	else
		if (button == "LeftButton") then
			if (IsDressableItem(self.entry)) then
				DressUpItemLink(Legacy_GetItemLink(self.entry));
			end
		else
			if (self.entry ~= 0) then
				if (not Legacy_TransmogCollected(self.entry)) then
					local popup = StaticPopup_Show("LEGACY_COLLECT_TRANSMOG_CONFIRM", Legacy_GetItemLink(self.entry), self.data.price);
					popup.entry = self.entry;
				elseif (not Legacy_IsCurrentTransmog(Legacy.Var.Nav.Selected.TransmogSlot, self.entry)) then
					Legacy_ActivateTransmog(Legacy.Var.Nav.Selected.TransmogSlot, self.entry);
				end
			end
		end
	end
end

function LegacyPanel_OnUpdateTransmogCollectionToken(self, elapsed)
	if (self.entry ~= 0 and not self.updated) then
		local itemInfo = GetItemInfo(self.entry);
		if (itemInfo == nil) then
			Legacy_QueryItemInfo(self.entry);
			self.updated = true;
		else
			self.updated = true;
		end
	end
end

function LegacyPanel_LoadTransmogCollection()
	local colls = TransmogCollection[Legacy.Var.Nav.Selected.TransmogSlot];
	if (colls == nil) then
		for i = 1, LEGACY_MAX_TRANSMOG_COLL_SLOT do
			Legacy.UI.Transmog.Coll[i].entry = 0;
			Legacy.UI.Transmog.Coll[i].updated = true;
			Legacy.UI.Transmog.Coll[i]:Hide();
		end
	else
		for i = 1, LEGACY_MAX_TRANSMOG_COLL_SLOT do
			local token = Legacy.UI.Transmog.Coll[i];
			local transmog = colls[i+Legacy.Var.Nav.Page.TransmogCollection*LEGACY_MAX_TRANSMOG_COLL_SLOT];
			token.data = transmog;
			if (transmog ~= nil) then
				token.updated = false;
				token.entry = transmog.entry;
				token.Icon:SetTexture(GetItemIcon(transmog.entry));
				if (Legacy_TransmogCollected(transmog.entry)) then
					token.Desc:Hide();
					token.Icon:SetDesaturated(false);
					if (Legacy_IsCurrentTransmog(Legacy.Var.Nav.Selected.TransmogSlot, token.entry)) then
						token.Border:SetVertexColor(1, 1, 0, 1);
					else
						token.Border:SetVertexColor(Legacy_GetQualityColor(transmog.quality));
					end
				else
					token.Desc:SetText(transmog.price);
					token.Desc:Show();
					token.Icon:SetDesaturated(true);
					token.Border:SetVertexColor(Legacy_GetQualityColorShift(transmog.quality, 0.5));
				end
				token:Show();
			else
				token.updated = true;
				token.entry = 0;
				token:Hide();
			end
		end
	end
	LegacyPanel_UpdateTransmogCollectionNav();
end

function LegacyPanel_OnLoadTransmogCollectionNavToken(self)
	LegacyPanel_InitToken(self);
	self.Icon:SetTexture(LEGACY_NAV_ARROW[self.Id]);
	self.Title:Hide();
	self.Desc:Hide();
end

function LegacyPanel_OnEnterTransmogCollectionNavToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
	self.Highlight:Show();
end

function LegacyPanel_OnLeaveTransmogCollectionNavToken(self, motion)
	self.Highlight:Hide();
end

function LegacyPanel_OnClickTransmogCollectionNavToken(self, button, down)
	if (self.more) then
		if (self.Id == LEGACY_NAV_PREV) then
			Legacy.Var.Nav.Page.TransmogCollection = Legacy.Var.Nav.Page.TransmogCollection - 1;
		else
			Legacy.Var.Nav.Page.TransmogCollection = Legacy.Var.Nav.Page.TransmogCollection + 1;
		end
		LegacyPanel_LoadTransmogCollection();
		LegacyPanel_UpdateTransmogCollectionNav();
	end
end

function LegacyPanel_UpdateTransmogCollectionNav()
	if (Legacy.Var.Nav.Selected.TransmogSlot < 0 or TransmogCollection[Legacy.Var.Nav.Selected.TransmogSlot] == nil) then
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_PREV].more = false;
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
		return;
	end
	
	if (Legacy.Var.Nav.Page.TransmogCollection > 0) then
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_PREV].more = true;
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_PREV].more = false;
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	
	if ((Legacy.Var.Nav.Page.TransmogCollection+1)*LEGACY_MAX_TRANSMOG_COLL_SLOT >= #TransmogCollection[Legacy.Var.Nav.Selected.TransmogSlot]) then
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.Transmog.Nav.Coll[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
end

function LegacyPanel_UpdateTransmogCollectionCount()
	local count = Legacy_GetElementCount(Legacy.Data.Transmog.Collection, 1);
	Legacy.UI.Home.Nav[LEGACY_PAGE_TRANSMOG].Desc:SetText(count);
end
