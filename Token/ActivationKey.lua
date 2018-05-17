function LegacyPanel_OnLoadActivationKeyToken(self)
	LegacyPanel_InitToken(self);
	self:Hide();
	self.Title:Hide();
	self.Desc:Hide();
	self.Icon:SetTexture(LEGACY_ACTIVATION_KEY_ICON);
end

function LegacyPanel_OnEnterActivationKeyToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
    self.Highlight:Show();
	if (self.key ~= nil) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
		GameTooltip:AddLine(self.key, 1, 1, 1, 1);
		GameTooltip:Show();
	end
end

function LegacyPanel_OnLeaveActivationKeyToken(self, motion)
	self.Highlight:Hide();
    GameTooltip:Hide();
end

function LegacyPanel_OnClickActivationKeyToken(self, button, down)
end

function LegacyPanel_UpdateActivationKey()
	Legacy.UI.Home.Nav[LEGACY_PAGE_ACTIVATION_KEY].Desc:SetText(#Legacy.Data.Account.ActivationKey);
	local index = 1;
	for i = 1, LEGACY_MAX_ACTIVATION_KEYS_PER_PAGE do
		local key = Legacy.Data.Account.ActivationKey[i];
		if (key ~= nil) then
			Legacy.UI.ActivationKey[i].key = key;
			Legacy.UI.ActivationKey[i]:Show();
		else
			Legacy.UI.ActivationKey[i].key = nil;
			Legacy.UI.ActivationKey[i]:Hide();
		end
	end
end