function LegacyPanel_OnLoadHomeNavToken(self)
    LegacyPanel_InitToken(self);
    if (self.Id > LEGACY_MAX_PAGE) then
        self:Hide();
    else
        self.Title:SetText(LEGACY_NAV_DATA[self.Id].Name);
		self.Title:SetVertexColor(1, 1, 1, 1);
        self.Desc:SetText(0);
		self.Desc:SetVertexColor(0, 1, 0, 1);
        self.Icon:SetTexture(LEGACY_NAV_DATA[self.Id].Icon);
    end
end

function LegacyPanel_OnEnterHomeNavToken(self, motion)
    self.Highlight:SetVertexColor(0, 1, 0, 1);
    self.Highlight:Show();
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, 20);
    GameTooltip:AddLine(LEGACY_NAV_DATA[self.Id].Desc, 1, 1, 1);
	if (self.Id == LEGACY_PAGE_CLASSSKILL) then
		GameTooltip:AddDoubleLine(LEGACY_SKILL_MASTERY_AVAILABLE, Legacy.Data.Character.ClassSkill.Available, 1, 1, 1, 0, 1, 0);
		GameTooltip:AddDoubleLine(LEGACY_MEMORY_POINT_AVAILABLE, Legacy.Data.Character.Memory.Available, 1, 1, 1, 0, 1, 0);
	elseif (self.Id == LEGACY_PAGE_RUNE) then
		GameTooltip:AddDoubleLine(LEGACY_GP_AVAILABLE, Legacy.Data.Character.Specialty.Available, 1, 1, 1, 0, 1, 0);
		GameTooltip:AddDoubleLine(LEGACY_RUNE_SOCKETED, Legacy_ActivatedRuneCount().."/30", 1, 1, 1, 0, 1, 0);
	elseif (self.Id == LEGACY_PAGE_TRANSMOG) then -- transmog
		GameTooltip:AddDoubleLine(LEGACY_TRANSMOG_SOURCE_COLLECTED, format("%d/%d", Legacy_GetElementCount(Legacy.Data.Transmog.Collection, 1), TransmogCollectionCount), 1, 1, 1, 0, 1, 0);
	elseif (self.Id == LEGACY_PAGE_MARKET) then -- market tab
		GameTooltip:AddDoubleLine(LEGACY_ACCOUNT_FUND, Legacy.Data.Account.Currency, 1, 1, 1, 0, 1, 0);
	elseif (self.Id == LEGACY_PAGE_REPUTATION) then -- reputation tab
		GameTooltip:AddDoubleLine(LEGACY_ACCOUNT_LEVEL, Legacy.Data.Account.Rank, 1, 1, 1, 0, 1, 0);
		local rank = Legacy.Data.Account.Rank;
		if (rank < 0) then rank = LEGACY_INFINITE_MARK end;
		GameTooltip:AddDoubleLine(LEGACY_ACCOUNT_REPUTATION, Legacy.Data.Account.Reputation, 1, 1, 1, 0, 1, 0);
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
