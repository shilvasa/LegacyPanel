function LegacyPanel_OnLoadNavButtonItem(self)
    LegacyPanel_InitializeAbilityItem(self);
    if (self.id > LEGACY_MAX_PAGE) then
        self:Hide();
    else
        self.title:SetText(LEGACY_NAV_DATA[self.id].name);
        self.desc:SetText(0);
        self.icon:SetTexture(LEGACY_NAV_DATA[self.id].icon);
        LegacyPanel.Nav[self.id] = self;
    end
end

function LegacyPanel_OnEnterNavButtonItem(self, motion)
    self.highlight:SetVertexColor(0, 1, 0, 1);
    self.highlight:Show();
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, 20);
    GameTooltip:AddLine(LEGACY_NAV_DATA[self.id].desc);
	if (self.id == LEGACY_PAGE_TRANSMOG) then -- transmog
		GameTooltip:AddDoubleLine(LEGACY_TRANSMOG_POWER, 10);
		GameTooltip:AddDoubleLine(LEGACY_REMOVE_ALL_TRANSMOG_HINT);
	elseif (self.id == LEGACY_PAGE_MARKET) then -- market tab
		GameTooltip:AddDoubleLine(LEGACY_ACCOUNT_FUND, "|cff00ff00"..Legacy.Data.Account.Currency.."|r");
	elseif (self.id == LEGACY_PAGE_REPUTATION) then -- reputation tab
		GameTooltip:AddDoubleLine(LEGACY_ACCOUNT_LEVEL, "|cffffffff"..Legacy.Data.Account.Level.."|r");
		local rank = Legacy.Data.Account.Rank;
		if (rank < 0) then rank = LEGACY_INFINITE_MARK end;
		GameTooltip:AddDoubleLine(LEGACY_ACCOUNT_REPUTATION, "|cffffffff"..rank.."|r");
		GameTooltip:AddDoubleLine(LEGACY_MF, "|cff00eeee+"..Legacy.Data.Account.Level.."|r");
	end
    GameTooltip:Show();
end

function LegacyPanel_OnLeaveNavButtonItem(self, motion)
    if (self.id ~= LegacyPanel.SelectedPage) then
        self.highlight:Hide();
    end
    GameTooltip:Hide();
end

function LegacyPanel_HideOtherPages(current)
    for i = 1, LEGACY_MAX_PAGE do
        if (i ~= LegacyPanel.SelectedPage) then
            LegacyPanel.Page[i]:Hide();
            LegacyPanel.Nav[i].highlight:Hide();
			if (i == LEGACY_PAGE_GUILD) then
				LegacyPanel.ReplacableGuildBonusFrame:Hide();
			end
        end
    end
end

function LegacyPanel_OnClickNavButtonItem(self, button, down)
	if (button == "RightButton" and self.id == LEGACY_PAGE_TRANSMOG) then
		StaticPopup_Show("LEGACY_REMOVE_ALL_TRANSMOG_CONFIRM");
		return;
	end
    LegacyPanel.Page[self.id]:Show();
	if (self.id == LEGACY_PAGE_GUILD) then
		LegacyPanel.ReplacableGuildBonusFrame:Hide();
		for i = 1, 9 do
			LegacyPanel.GuildUI.Bonus[i]:Show();
		end
	end
    LegacyPanel.SelectedPage = self.id;
    LegacyPanel_HideOtherPages(self.id);
end
