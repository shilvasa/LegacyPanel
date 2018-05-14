function LegacyPanel_OnLoadTransmogSlotItem(self)
	LegacyPanel_InitializeAbilityItem(self);
	LegacyPanel.TransmogSlot[self.id] = self;
	local info = LEGACY_TRANSMOG_SLOT[self:GetID()];
	self.icon:SetTexture(info.icon);
	self.desc:SetText(info.name);
	self.title:Hide();
end

function LegacyPanel_FormatTransmogSlotTip(self)
	if (GameTooltip:GetOwner() == self) then
		GameTooltip:ClearLines();
		if (LegacyPanel.Transmogs[self.id] ~= 0) then
		--[[
			local name, entry, quality, _, _, cl, scl, _, slot = GetItemInfo(LegacyPanel.Transmogs[self.id]);
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
				if (cl == "护甲" and scl == "饰物") then
					scl = "通用";
				end
				GameTooltip:AddLine(scl);
				GameTooltip:AddLine(LEGACY_TRANSMOG_SLOT_CLICK_HINT);
				GameTooltip:Show();
			else
				GameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
				GameTooltip:SetHyperlink("item:"..LegacyPanel.Transmogs[self.id]);
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
				GameTooltip:AddLine(LEGACY_ITEM_QUERYING);
			end
		]]--
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
			GameTooltip:SetHyperlink("item:"..LegacyPanel.Transmogs[self.id]);
		else
			GameTooltip:AddLine("|cffffffff"..LEGACY_TRANSMOG_SLOT[self.id].name.."|r");
		end
		
		local tLength = Legacy_TLength(LEGACY_EQUIP_SLOTS[self.id]);
		if (tLength > 1) then -- more than 1
			_G[GameTooltip:GetName().."TextRight1"]:SetText(format(LEGACY_CLICK_TO_EXPAND, tLength));
			_G[GameTooltip:GetName().."TextRight1"]:Show();
		end
		
		GameTooltip:Show();
	end
end

function LegacyPanel_ColorizeTransmogSlotBorder(self)
	if (LegacyPanel.Transmogs[self.id] ~= 0) then
		local _, _, quality = GetItemInfo(LegacyPanel.Transmogs[self.id]);
		if (quality ~= nil) then
			local r, g, b, _ = GetItemQualityColor(quality);
			self.border:SetVertexColor(r, g, b, 1);
		else
			GameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
			GameTooltip:SetHyperlink("item:"..LegacyPanel.Transmogs[self.id]);
		end
	else
		if (LegacyPanel_TransmogCollectedAtSlot(self.id) > 0) then
			self.border:SetVertexColor(0.75, 0.75, 0.75, 1);
		else
			self.border:SetVertexColor(0.5, 0.5, 0.5, 1);
		end
	end
end

function LegacyPanel_OnEnterTransmogSlotItem(self, motion)
	self.highlight:SetVertexColor(0, 1, 0, 1);
	self.highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	LegacyPanel_FormatTransmogSlotTip(self);
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveTransmogSlotItem(self, motion)
	self.highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickTransmogSlotItem(self, button, down)
	local tLength = Legacy_TLength(LEGACY_EQUIP_SLOTS[self.id]);
	if (tLength > 1) then
		LegacyPanel.SelectedTransmogSlot = self.id;
		LegacyPanel.TransmogItemPage = 1;
		LegacyPanel_UpdateTransmogCollections();
		LegacyPanel.TransmogSlotFrame:Hide();
		LegacyPanel.TransmogItemFrame:SetPoint("CENTER", self, "CENTER", 0, 0);
		LegacyPanel.TransmogItemFrame:Show();
	else
		if (button == "LeftButton") then
			if (IsDressableItem(self.entry)) then
				DressUpItemLink(Legacy_GetItemLink(self.entry));
			end
		end
	end
end

local updateTimer = 0;
function LegacyPanel_OnUpdateTransmogSlotItem(self, elapsed)
	updateTimer = updateTimer + elapsed;
	if (updateTimer > LEGACY_TRANSMOG_SLOT_UPDATE_INTERVAL) then
		updateTimer = 0;
		LegacyPanel_FormatTransmogSlotTip(self);
		LegacyPanel_ColorizeTransmogSlotBorder(self);
	end
end

function LegacyPanel_UpdateTransmogs()
	for k, v in pairs(LegacyPanel.Transmogs) do
		if (LegacyPanel.TransmogSlot[k] ~= nil) then
			if (v ~= 0) then
				LegacyPanel.TransmogSlot[k].icon:SetTexture(GetItemIcon(v));
			else
				LegacyPanel.TransmogSlot[k].icon:SetTexture(LEGACY_TRANSMOG_SLOT[LegacyPanel.TransmogSlot[k].id].icon);
			end
			LegacyPanel_FormatTransmogSlotTip(LegacyPanel.TransmogSlot[k]);
			LegacyPanel_ColorizeTransmogSlotBorder(LegacyPanel.TransmogSlot[k]);
		end
	end
	LegacyPanel_UpdateTransmogCollections();
end