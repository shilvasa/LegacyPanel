function LegacyPanel_OnLoadHomeNavToken(self)
    LegacyPanel_InitToken(self);
    if (self.Id > LEGACY_MAX_PAGE) then
        self:Hide();
    else
        self.Title:SetText(LEGACY_NAV_DATA[self.Id].Name);
        self.Desc:SetText(0);
        self.Icon:SetTexture(LEGACY_NAV_DATA[self.Id].Icon);
    end
end

function LegacyPanel_OnEnterHomeNavToken(self, motion)
    self.Highlight:SetVertexColor(0, 1, 0, 1);
    self.Highlight:Show();
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, 20);
    GameTooltip:AddLine(LEGACY_NAV_DATA[self.Id].Desc);
	if (self.Id == LEGACY_PAGE_TRANSMOG) then -- transmog
		GameTooltip:AddDoubleLine(LEGACY_TRANSMOG_POWER, 10);
		GameTooltip:AddDoubleLine(LEGACY_REMOVE_ALL_TRANSMOG_HINT);
	elseif (self.Id == LEGACY_PAGE_MARKET) then -- market tab
		GameTooltip:AddDoubleLine(LEGACY_ACCOUNT_FUND, "|cff00ff00"..Legacy.Data.Account.Currency.."|r");
	elseif (self.Id == LEGACY_PAGE_REPUTATION) then -- reputation tab
		GameTooltip:AddDoubleLine(LEGACY_ACCOUNT_LEVEL, "|cffffffff"..Legacy.Data.Account.Rank.."|r");
		local rank = Legacy.Data.Account.Rank;
		if (rank < 0) then rank = LEGACY_INFINITE_MARK end;
		GameTooltip:AddDoubleLine(LEGACY_ACCOUNT_REPUTATION, "|cffffffff"..Legacy.Data.Account.Reputation.."|r");
	end
    GameTooltip:Show();
end

function LegacyPanel_OnLeaveHomeNavToken(self, motion)
    if (self.Id ~= Legacy.Var.Nav.Selected.Page) then
        self.Highlight:Hide();
    end
    GameTooltip:Hide();
end

function LegacyPanel_HideOtherPages(current)
    for i = 0, LEGACY_MAX_PAGE do
        if (i ~= Legacy.Var.Nav.Selected.Page) then
            Legacy.UI.Home.Page[i]:Hide();
            Legacy.UI.Home.Nav[i].Highlight:Hide();
			if (i == LEGACY_PAGE_GUILD) then
				Legacy.UI.Guild.BonusSelectionFrame:Hide();
			end
        end
    end
end

function LegacyPanel_OnClickHomeNavToken(self, button, down)
	if (button == "RightButton" and self.Id == LEGACY_PAGE_TRANSMOG) then
		StaticPopup_Show("LEGACY_REMOVE_ALL_TRANSMOG_CONFIRM");
		return;
	end
    Legacy.UI.Home.Page[self.Id]:Show();
	if (self.Id == LEGACY_PAGE_GUILD) then
		Legacy.UI.Guild.BonusSelectionFrame:Hide();
		for i = 1, 9 do
			Legacy.UI.Guild.Bonus[i]:Show();
		end
	end
    Legacy.Var.Nav.Selected.Page = self.Id;
    LegacyPanel_HideOtherPages(self.Id);
end
