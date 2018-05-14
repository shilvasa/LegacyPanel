function LegacyPanel_OnLoadActivationKeyItem(self)
	LegacyPanel_InitializeAbilityItem(self);
	self:Hide();
	self.title:Hide();
	self.desc:Hide();
	self.icon:SetTexture(LEGACY_ACTIVATION_KEY_ICON);
	LegacyPanel.ActivationKey[self.id] = self;
end

function LegacyPanel_OnEnterActivationKeyItem(self, motion)
	self.highlight:SetVertexColor(0, 1, 0, 1);
    self.highlight:Show();
	local key = Legacy.Data.ActivationKeys[self.id];
	if (key ~= nil) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
		GameTooltip:AddLine(key, 1, 1, 1, 1);
		GameTooltip:Show();
	end
end

function LegacyPanel_OnLeaveActivationKeyItem(self, motion)
	self.highlight:Hide();
    GameTooltip:Hide();
end

function LegacyPanel_OnClickActivationKeyItem(self, button, down)
end

function LegacyPanel_UpdateActivationKeys()
	LegacyPanel.Nav[LEGACY_PAGE_ACTIVATION_KEY].desc:SetText(#Legacy.Data.ActivationKeys);
	local index = 1;
	for i = 1, LEGACY_MAX_ACTIVATION_KEYS_PER_PAGE do
		local key = Legacy.Data.ActivationKeys[i];
		if (key ~= nil) then
			LegacyPanel.ActivationKey[i]:Show();
		else
			LegacyPanel.ActivationKey[i]:Hide();
		end
	end
end