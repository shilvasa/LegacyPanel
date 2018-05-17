function LegacyPanel_OnLoadTransmogSlotToken(self)
	LegacyPanel_InitToken(self);
	local info = LEGACY_TRANSMOG_SLOT[self:GetID()];
	self.Icon:SetTexture(info.Icon);
	self.Desc:SetText(info.Name);
	self.Title:Hide();
	self.entry = 0;
end

function LegacyPanel_FormatTransmogSlotTip(self)
	if (GameTooltip:GetOwner() == self) then
		GameTooltip:ClearLines();
		if (self.entry ~= 0) then
		--[[
			local name, entry, quality, _, _, cl, scl, _, slot = GetItemInfo(LegacyPanel.Transmogs[self.Id]);
			if (name ~= nil) then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
				local _, _, _, cHex = GetItemQualityColor(quality);
				local handed = "";
				if (cl == "武器" and slot == "INVTYPE_WEAPONMAINHAND") then
					handed = LEGACY_MAINHAND_ONLY;
				elseif (cl == "武器" and slot == "INVTYPE_WEAPONOFFHAND") then
					handed = LEGACY_OFFHAND_ONLY;
				end
				GameTooltip:AddLine(cHex..Name..handed.."|r");
				if (cl == "护甲" and scl == "饰物") then
					scl = "通用";
				end
				GameTooltip:AddLine(scl);
				GameTooltip:AddLine(LEGACY_TRANSMOG_SLOT_CLICK_HINT);
				GameTooltip:Show();
			else
				GameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
				GameTooltip:SetHyperlink("item:"..LegacyPanel.Transmogs[self.Id]);
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
				GameTooltip:AddLine(LEGACY_ITEM_QUERYING);
			end
		]]--
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
			GameTooltip:SetHyperlink("item:"..self.entry);
		else
			GameTooltip:AddLine("|cffffffff"..LEGACY_TRANSMOG_SLOT[self.Id].Name.."|r");
		end
		
		local tLength = Legacy_TLength(LEGACY_EQUIP_SLOTS[self.Id]);
		if (tLength > 1) then -- more than 1
			_G[GameTooltip:GetName().."TextRight1"]:SetText(format(LEGACY_CLICK_TO_EXPAND, tLength));
			_G[GameTooltip:GetName().."TextRight1"]:Show();
		end
		
		GameTooltip:Show();
	end
end

function LegacyPanel_ColorizeTransmogSlotBorder(self)
	if (self.entry ~= 0) then
		local _, _, quality = GetItemInfo(self.entry);
		if (quality ~= nil) then
			local r, g, b, _ = GetItemQualityColor(quality);
			self.Border:SetVertexColor(r, g, b, 1);
		else
			GameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
			GameTooltip:SetHyperlink("item:"..self.entry);
		end
	else
		if (LegacyPanel_TransmogCollectedAtSlot(self.Id) > 0) then
			self.Border:SetVertexColor(0.75, 0.75, 0.75, 1);
		else
			self.Border:SetVertexColor(0.5, 0.5, 0.5, 1);
		end
	end
end

function LegacyPanel_OnEnterTransmogSlotToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
	self.Highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	LegacyPanel_FormatTransmogSlotTip(self);
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveTransmogSlotToken(self, motion)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickTransmogSlotToken(self, button, down)
	local tLength = Legacy_TLength(LEGACY_EQUIP_SLOTS[self.Id]);
	if (tLength > 1) then
		Legacy.Var.Nav.Selected.TransmogSlot = self.Id;
		Legacy.Var.Nav.Page.Transmog = 1;
		LegacyPanel_UpdateTransmogCollection();
		Legacy.UI.Transmog.CollFrame:SetPoint("CENTER", self, "CENTER", 0, 0);
		LegacyPanel_Navigate(Legacy.UI.Transmog.CollFrame, Legacy.UI.Transmog.SlotFrame);
	else
		if (button == "LeftButton") then
			if (IsDressableItem(self.entry)) then
				DressUpItemLink(Legacy_GetItemLink(self.entry));
			end
		end
	end
end

local updateTimer = 0;
function LegacyPanel_OnUpdateTransmogSlotToken(self, elapsed)
	updateTimer = updateTimer + elapsed;
	if (updateTimer > LEGACY_TRANSMOG_SLOT_UPDATE_INTERVAL) then
		updateTimer = 0;
		LegacyPanel_FormatTransmogSlotTip(self);
		LegacyPanel_ColorizeTransmogSlotBorder(self);
	end
end

function LegacyPanel_UpdateTransmogs()
	for k, v in pairs(Legacy.Data.Transmog.Slot) do
		local token = Legacy.UI.Transmog.Slot[k];
		token.entry = v;
		if (v ~= 0) then
			token.Icon:SetTexture(GetItemIcon(v));
		else
			token.Icon:SetTexture(LEGACY_TRANSMOG_SLOT[token.Id].Icon);
		end
		LegacyPanel_FormatTransmogSlotTip(LegacyPanel.TransmogSlot[k]);
		LegacyPanel_ColorizeTransmogSlotBorder(LegacyPanel.TransmogSlot[k]);
	end
	LegacyPanel_UpdateTransmogCollection();
end

-------------------------------------------------

function LegacyPanel_OnLoadTransmogToken(self)
	LegacyPanel_InitToken(self);
	self.Title:Hide();
	self.Desc:Show();
	if (self.Id == 0) then
		self.Border:SetVertexColor(1, 1, 1, 1);
	else
		self.Border:SetVertexColor(0.5, 0.5, 0.5, 1);
	end
end

-- kill me already
function LegacyPanel_FormatTransmogTip(self)
	if (self.Id ~= 0 and GameTooltip:GetOwner() == self) then
		--GameTooltip:ClearLines();
		if (self.entry ~= nil and self.entry ~= 0) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
		--[[
			local name, _, quality, _, _, cl, scl, _, slot = GetItemInfo(self.entry);
			if (name ~= nil) then
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
				local _, _, _, cHex = GetItemQualityColor(quality);
				local handed = "";
				if (cl == "武器" and slot == "INVTYPE_WEAPONMAINHAND") then
					handed = LEGACY_MAINHAND_ONLY;
				elseif (cl == "武器" and slot == "INVTYPE_WEAPONOFFHAND") then
					handed = LEGACY_OFFHAND_ONLY;
				end
				GameTooltip:AddLine(cHex..Name..handed.."|r");
				local current = "";
				if (LegacyPanel_IsCurrentTransmog(Legacy.Var.Nav.Selected.TransmogSlot, self.entry)) then current = LEGACY_CURRENT_TRANSMOG; end
				if (cl == "护甲" and scl == "饰物") then
					scl = "通用";
				end
				GameTooltip:AddDoubleLine(scl, current);
				GameTooltip:AddDoubleLine(LEGACY_TRANSMOG_ITEM_LEFT_CLICK, LEGACY_TRANSMOG_ITEM_RIGHT_CLICK);
				GameTooltip:Show();
			else
				GameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
				GameTooltip:SetHyperlink("item:"..self.entry);
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
				GameTooltip:AddLine(LEGACY_ITEM_QUERYING);
			end
		]]--
		GameTooltip:SetHyperlink("item:"..self.entry);
		GameTooltip:Show();
		else
		end
	end
end

function LegacyPanel_ColorizeTransmogItemBorder(self)
	if (self.Id == 0) then return end
	if (self.entry == nil or self.entry == 0) then
		self.Border:SetVertexColor(0.5, 0.5, 0.5, 1);
		return;
	end
	
	if (LegacyPanel_IsCurrentTransmog(Legacy.Var.Nav.Selected.TransmogSlot, self.entry)) then
		self.Border:SetVertexColor(1, 1, 0, 1);
		return;
	end
	
	if (self.entry ~= 0) then
		if (LegacyPanel.TransmogQualityCache[self.entry] ~= nil) then
			local r, g, b, _ = GetItemQualityColor(LegacyPanel.TransmogQualityCache[self.entry]);
			self.Border:SetVertexColor(r, g, b, 1);
		else
			local _, _, q = GetItemInfo(self.entry);
			if (q ~= nil) then
				LegacyPanel.TransmogQualityCache[self.entry] = q;
				local r, g, b, _ = GetItemQualityColor(LegacyPanel.TransmogQualityCache[self.entry]);
				self.Border:SetVertexColor(r, g, b, 1);
			else
				GameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
				GameTooltip:SetHyperlink("item:"..self.entry);
			end
		end
	end
end

function LegacyPanel_OnEnterTransmogToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
	self.Highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.Id == 0) then
		GameTooltip:AddLine(LEGACY_RETURN);
	else
		LegacyPanel_FormatTransmogItemTip(self);
	end
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveTransmogToken(self, motion)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickTransmogToken(self, button, down)
	if (self.Id == 0) then
		LegacyPanel_NavigateBack();
		Legacy.Var.Nav.Selected.TransmogSlot = -1;
	else
		if (button == "LeftButton") then
			if (IsDressableItem(self.entry)) then
				DressUpItemLink(Legacy_GetItemLink(self.entry));
			end
		end
	end
end

local updateTimer = 0;
function LegacyPanel_OnUpdateTransmogItem(self, elapsed)
	updateTimer = updateTimer + elapsed;
	if (updateTimer > LEGACY_TRANSMOG_ITEM_UPDATE_INTERVAL) then
		updateTimer = 0;
		LegacyPanel_FormatTransmogItemTip(self);
		LegacyPanel_ColorizeTransmogItemBorder(self);
	end
end

function LegacyPanel_UpdateTransmogCollection()
	if (Legacy.Var.Nav.Selected.TransmogSlot < 0) then
		return;
	end
	
	Legacy.UI.Transmog.Item[0].entry = Legacy.Data.Transmog.Slot[Legacy.Var.Nav.Selected.TransmogSlot];
	if (Legacy.UI.Transmog.Item[0].entry ~= 0) then
		Legacy.UI.Transmog.Item[0].Icon:SetTexture(GetItemIcon(Legacy.UI.Transmog.Item[0].entry));
	else
		Legacy.UI.Transmog.Item[0].Icon:SetTexture(LEGACY_TRANSMOG_SLOT[Legacy.Var.Nav.Selected.TransmogSlot].Icon);
	end
	Legacy.UI.Transmog.Item[0].Desc:SetText(LEGACY_TRANSMOG_SLOT[Legacy.Var.Nav.Selected.TransmogSlot].Name);
	Legacy.UI.Transmog.Item[0].Desc:Show();
	
	local index = 1;
	for k, v in pairs(LEGACY_EQUIP_SLOTS[Legacy.Var.Nav.Selected.TransmogSlot]) do
		local token = Legacy.UI.Transmog.Item[k+1];
		token.entry = Legacy.Data.Transmog.Collection[v.slot];
		if (token.entry ~= 0) then
			token.Icon:SetTexture(GetItemIcon(token.entry));
			token.Icon:SetDesaturated(false);
		else
			token.Icon:SetTexture(v.Icon);
			token.Icon:SetDesaturated(true);
		end
		token.Desc:SetText(v.Name);
		token.Desc:Show();
		LegacyPanel_ColorizeTransmogItemBorder(token);
		token:Show();
		if (k >= index) then
			index = k + 2;
		end
	end
	
	for i = index, LEGACY_MAX_TRANSMOG_COLLECTION_SLOT do
		Legacy.UI.Transmog.Item[i].entry = 0;
		Legacy.UI.Transmog.Item[i]:Hide();
	end
end

-----------------------

function LegacyPanel_OnLoadTransmogNavToken(self)
	LegacyPanel_InitToken(self);
	self.Icon:SetTexture(LEGACY_NAV_ARROW[self.id]);
	self.Title:Hide();
	self.Desc:Hide();
end

function LegacyPanel_OnEnterTransmogNavToken(self, motion)
end

function LegacyPanel_OnLeaveTransmogNavToken(self, motion)
end

function LegacyPanel_OnClickTransmogNavToken(self, button, down)
end

function LegacyPanel_UpdateTransmogNav()
end
