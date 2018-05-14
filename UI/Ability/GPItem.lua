function LegacyPanel_OnLoadGPItem(self)
    LegacyPanel_InitializeAbilityItem(self);
    self.title:SetText("GP");
    self.desc:SetText(0);
    self.icon:SetTexture("Interface\\Icons\\ACHIEVEMENT_BG_DG_MASTER_OF_THE_DEEPWIND_GORGE");
    LegacyPanel.GPItem = self;
end

function LegacyPanel_OnEnterGPItem(self)
    self.highlight:SetVertexColor(0, 1, 0, 1);
    self.highlight:Show();
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
    GameTooltip:AddDoubleLine(LEGACY_GP_AVAILABLE, format(LEGACY_STRING_FORMAT_GREEN, LegacyCharInfo.GP.Available));
    GameTooltip:AddDoubleLine(LEGACY_GP_TOTAL_GAINED, format(LEGACY_STRING_FORMAT_YELLOW, LegacyCharInfo.GP.Total));
    GameTooltip:AddDoubleLine(LEGACY_GP_TOTAL_COST, format(LEGACY_STRING_FORMAT_YELLOW, LegacyCharInfo.GP.Cost));
	GameTooltip:AddDoubleLine(LEGACY_TP_AVAILABLE, format(LEGACY_STRING_FORMAT_LIGHTBLUE, LegacyCharInfo.TP.Available));
    GameTooltip:AddDoubleLine(LEGACY_TP_TOTAL_GAINED, format(LEGACY_STRING_FORMAT_YELLOW, LegacyCharInfo.TP.Total));
    GameTooltip:AddDoubleLine(LEGACY_TP_TOTAL_COST, format(LEGACY_STRING_FORMAT_YELLOW, LegacyCharInfo.TP.Cost));
	GameTooltip:AddLine(LEGACY_GP_ITEM_HINT);
    GameTooltip:Show();
end

function LegacyPanel_OnLeaveGPItem(self)
    self.highlight:Hide();
    GameTooltip:Hide();
end

function LegacyPanel_OnClickGPItem(self, button, down)
	if (button == "RightButton") then
		local cost = Legacy_GetGPResetCost();
		if (cost > 0) then
			local popup = StaticPopup_Show("LEGACY_RESET_MASTERY_CONFIRM", cost);
		end
    end
end

function LegacyPanel_UpdateGP()
    LegacyPanel.GPItem.title:SetText(format(LEGACY_STRING_FORMAT_GREEN, LegacyCharInfo.GP.Available));
	LegacyPanel.GPItem.desc:SetText(format(LEGACY_STRING_FORMAT_LIGHTBLUE, LegacyCharInfo.TP.Available));
end