function LegacyPanel_OnLoadTransmogNavItem(self)
	LegacyPanel_InitializeAbilityItem(self);
	LegacyPanel.TransmogNavButton[self.id] = self;
	self.icon:SetTexture(LEGACY_NAV_ARROW[self.id]);
	self.title:Hide();
	self.desc:Hide();
end

function LegacyPanel_OnEnterTransmogNavItem(self, motion)
end

function LegacyPanel_OnLeaveTransmogNavItem(self, motion)
end

function LegacyPanel_OnClickTransmogNavItem(self, button, down)
	if (LegacyPanel.SelectedTransmogSlot < 0) then return end
	local count = LegacyPanel_TransmogCollectedAtSlot(LegacyPanel.SelectedTransmogSlot);
	if (self.id == 1 and LegacyPanel.TransmogItemPage > 1) then
		LegacyPanel.TransmogItemPage = LegacyPanel.TransmogItemPage - 1;
	elseif (self.id == 2 and count > LegacyPanel.TransmogItemPage * LEGACY_MAX_TRANSMOG_ITEM_PER_PAGE) then
		LegacyPanel.TransmogItemPage = LegacyPanel.TransmogItemPage + 1;
	end
	LegacyPanel_UpdateTransmogItemNavButton();
	LegacyPanel_UpdateTransmogCollections();
end

function LegacyPanel_UpdateTransmogItemNavButton()
	local count = LegacyPanel_TransmogCollectedAtSlot(LegacyPanel.SelectedTransmogSlot);
	if (LegacyPanel.TransmogItemPage == 1) then
		LegacyPanel.TransmogNavButton[1].icon:SetDesaturated(true);
	else
		LegacyPanel.TransmogNavButton[1].icon:SetDesaturated(false);
	end
	if (count > LegacyPanel.TransmogItemPage * LEGACY_MAX_TRANSMOG_ITEM_PER_PAGE) then
		LegacyPanel.TransmogNavButton[2].icon:SetDesaturated(false);
	else
		LegacyPanel.TransmogNavButton[2].icon:SetDesaturated(true);
	end
end
