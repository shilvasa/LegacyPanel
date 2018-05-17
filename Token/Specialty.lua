function LegacyPanel_OnLoadStatToken(self)
    LegacyPanel_InitToken(self);
    self.Title:SetText(0);
	self.Title:SetVertexColor(0, 1, 0, 1);
    self.Desc:SetText(0);
	self.Desc:SetVertexColor(1, 1, 1, 1);
    self.Icon:SetTexture("Interface\\Icons\\ACHIEVEMENT_BG_DG_MASTER_OF_THE_DEEPWIND_GORGE");
end

function LegacyPanel_OnEnterStatToken(self)
    self.Highlight:SetVertexColor(0, 1, 0, 1);
    self.Highlight:Show();
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
    GameTooltip:AddDoubleLine(LEGACY_GP_AVAILABLE, format(LEGACY_STRING_FORMAT_GREEN, Legacy.Data.Character.Specialty.Available));
    GameTooltip:AddDoubleLine(LEGACY_GP_TOTAL_GAINED, format(LEGACY_STRING_FORMAT_YELLOW, Legacy.Data.Character.Specialty.Point));
    GameTooltip:Show();
end

function LegacyPanel_OnLeaveStatToken(self)
    self.Highlight:Hide();
    GameTooltip:Hide();
end

function LegacyPanel_OnClickStatToken(self, button, down)
	if (button == "RightButton") then
		local cost = Legacy_GetSpecialtyResetCost();
		if (cost > 0) then
			local popup = StaticPopup_Show("LEGACY_RESET_SPECIALTY_CONFIRM", cost);
		end
    end
end

function LegacyPanel_OnLoadSpecialtyToken(self)
    LegacyPanel_InitToken(self);
    self.Title:SetText(LEGACY_SPECIALTY_DESC[self.Id].Title);
    self.Icon:SetTexture(LEGACY_SPECIALTY_DESC[self.Id].Icon);
    self.Desc:SetText(0);
    self.Title:Show();
    self.Desc:Show();
end

function LegacyPanel_OnEnterSpecialtyToken(self)
    self.Highlight:SetVertexColor(0, 1, 0, 1);
    self.Highlight:Show();
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	LegacyPanel_ReformatSpecialtyTip(self);
	GameTooltip:Show();
end

function LegacyPanel_ReformatSpecialtyTip(token)
	if (token == GameTooltip:GetOwner()) then
		GameTooltip:ClearLines();
		GameTooltip:AddDoubleLine(LEGACY_SPECIALTY_DESC[token.Id].Title, Legacy.Data.Character.Specialty.Stat[token.Id]);
	end
end

function LegacyPanel_OnLeaveSpecialtyToken(self)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickSpecialtyToken(self, button)
    if (button == "RightButton") then
		if (Legacy.Data.Character.Specialty.Available > 0) then
            Legacy_DoQuery(LMSG_A_LEARN_SPECIALTY, self.Id);
        end
    end
end

function LegacyPanel_UpdateSpecialty()
	Legacy.UI.Specialty.Stat.Title:SetText(Legacy.Data.Character.Specialty.Available);
	Legacy.UI.Specialty.Stat.Desc:SetText(Legacy.Data.Character.Specialty.Point);
	Legacy.UI.Specialty.Armforce.Desc:SetText(Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_ARMFORCE]);
	LegacyPanel_ReformatSpecialtyTip(Legacy.UI.Specialty.Armforce);
	Legacy.UI.Specialty.Instinct.Desc:SetText(Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_INSTINCT]);
	LegacyPanel_ReformatSpecialtyTip(Legacy.UI.Specialty.Instinct);
	Legacy.UI.Specialty.Willpower.Desc:SetText(Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_WILLPOWER]);
	LegacyPanel_ReformatSpecialtyTip(Legacy.UI.Specialty.Willpower);
	Legacy.UI.Specialty.Sanity.Desc:SetText(Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_SANITY]);
	LegacyPanel_ReformatSpecialtyTip(Legacy.UI.Specialty.Sanity);
	Legacy.UI.Specialty.Pysche.Desc:SetText(Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_PYSCHE]);
	LegacyPanel_ReformatSpecialtyTip(Legacy.UI.Specialty.Pysche);
	Legacy.UI.Specialty.Trial.Desc:SetText(Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_TRIAL]);
	LegacyPanel_ReformatSpecialtyTip(Legacy.UI.Specialty.Trial);
end