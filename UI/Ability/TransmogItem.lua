function LegacyPanel_OnLoadTransmogItem(self)
	LegacyPanel_InitializeAbilityItem(self);
	LegacyPanel.TransmogItem[self.id] = self;
	self.title:Hide();
	self.desc:Hide();
	if (self.id == 0) then
		self.border:SetVertexColor(1, 1, 1, 1);
	else
		self.border:SetVertexColor(0.5, 0.5, 0.5, 1);
	end
	self.desc:Show();
end

-- kill me already
function LegacyPanel_FormatTransmogItemTip(self)
	if (self.id ~= 0 and GameTooltip:GetOwner() == self) then
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
				GameTooltip:AddLine(cHex..name..handed.."|r");
				local current = "";
				if (LegacyPanel_IsCurrentTransmog(LegacyPanel.SelectedTransmogSlot, self.entry)) then current = LEGACY_CURRENT_TRANSMOG; end
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
	if (self.id == 0) then return end
	if (self.entry == nil or self.entry == 0) then
		self.border:SetVertexColor(0.5, 0.5, 0.5, 1);
		return;
	end
	
	if (LegacyPanel_IsCurrentTransmog(LegacyPanel.SelectedTransmogSlot, self.entry)) then
		self.border:SetVertexColor(1, 1, 0, 1);
		return;
	end
	
	if (self.entry ~= 0) then
		if (LegacyPanel.TransmogQualityCache[self.entry] ~= nil) then
			local r, g, b, _ = GetItemQualityColor(LegacyPanel.TransmogQualityCache[self.entry]);
			self.border:SetVertexColor(r, g, b, 1);
		else
			local _, _, q = GetItemInfo(self.entry);
			if (q ~= nil) then
				LegacyPanel.TransmogQualityCache[self.entry] = q;
				local r, g, b, _ = GetItemQualityColor(LegacyPanel.TransmogQualityCache[self.entry]);
				self.border:SetVertexColor(r, g, b, 1);
			else
				GameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
				GameTooltip:SetHyperlink("item:"..self.entry);
			end
		end
	end
end

function LegacyPanel_OnEnterTransmogItem(self, motion)
	self.highlight:SetVertexColor(0, 1, 0, 1);
	self.highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.id == 0) then
		GameTooltip:AddLine(LEGACY_RETURN);
	else
		LegacyPanel_FormatTransmogItemTip(self);
	end
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveTransmogItem(self, motion)
	self.highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickTransmogItem(self, button, down)
	if (self.id == 0) then
		LegacyPanel.TransmogSlotFrame:Show();
		LegacyPanel.TransmogItemFrame:Hide();
		LegacyPanel.SelectedTransmogSlot = -1;
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

function LegacyPanel_UpdateTransmogCollections()
	if (LegacyPanel.SelectedTransmogSlot < 0) then
		return;
	end
	
	LegacyPanel.TransmogItem[0].entry = LegacyPanel.Transmogs[LegacyPanel.SelectedTransmogSlot];
	if (LegacyPanel.Transmogs[LegacyPanel.SelectedTransmogSlot] ~= 0) then
		LegacyPanel.TransmogItem[0].icon:SetTexture(GetItemIcon(LegacyPanel.Transmogs[LegacyPanel.SelectedTransmogSlot]));
	else
		LegacyPanel.TransmogItem[0].icon:SetTexture(LEGACY_TRANSMOG_SLOT[LegacyPanel.SelectedTransmogSlot].icon);
	end
	LegacyPanel.TransmogItem[0].desc:SetText(LEGACY_TRANSMOG_SLOT[LegacyPanel.SelectedTransmogSlot].name);
	LegacyPanel.TransmogItem[0].desc:Show();
	
	local index = 1;
	for k, v in pairs(LEGACY_EQUIP_SLOTS[LegacyPanel.SelectedTransmogSlot]) do
		local transmogItem = LegacyPanel.TransmogItem[k+1];
		transmogItem.entry = LegacyPanel.TransmogCollections[v.slot];
		if (transmogItem.entry ~= 0) then
			transmogItem.icon:SetTexture(GetItemIcon(transmogItem.entry));
			transmogItem.icon:SetDesaturated(false);
		else
			transmogItem.icon:SetTexture(v.icon);
			transmogItem.icon:SetDesaturated(true);
		end
		transmogItem.desc:SetText(v.name);
		transmogItem.desc:Show();
		LegacyPanel_ColorizeTransmogItemBorder(transmogItem);
		transmogItem:Show();
		if (k >= index) then
			index = k + 2;
		end
	end
	
	for i = index, LEGACY_MAX_TRANSMOG_COLLECTION_SLOT do
		LegacyPanel.TransmogItem[i].entry = 0;
		LegacyPanel.TransmogItem[i]:Hide();
	end
end