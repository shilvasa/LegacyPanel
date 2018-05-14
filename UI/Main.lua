function LegacyPanel_HideMainFrames()
    LegacyPanel.MainFrame:Hide();
    LegacyPanel.ActiveAbilityFrame:Hide();
    LegacyPanel.PassiveAbilityFrame:Hide();
    LegacyPanel.StatAbilityFrame:Hide();
    LegacyPanel.TalentAbilityFrame:Hide();
end

function LegacyPanel_ShowMainFrames()
    LegacyPanel.MainFrame:Show();
    LegacyPanel.ActiveAbilityFrame:Show();
    LegacyPanel.PassiveAbilityFrame:Show();
    LegacyPanel.StatAbilityFrame:Show();
    LegacyPanel.TalentAbilityFrame:Show();
end

function LegacyPanel_OnShow()
    PlaySound("Glyph_MinorCreate");
    LegacyPanel_ShowMainFrames();
end

function LegacyPanel_OnHide()
    PlaySound("Glyph_MinorDestroy");
    LegacyPanel_HideMainFrames();
    LegacyPanel.ReplacableAbilityFrame:Hide();
    LegacyPanel.AbilityUpgradeFrame:Hide();
	LegacyPanel.ReplacableGuildBonusFrame:Hide();
end

function LegacyPanel_Navigate(prev, current)
    LegacyPanel.PreviousFrame = prev;
    LegacyPanel.CurrentFrame = current;
    if (prev ~= nil) then prev:Hide(); end
    if (current ~= nil) then current:Show(); end
end

function LegacyPanel_NavigateBack()
    if (LegacyPanel.PreviousFrame ~= nil) then
        LegacyPanel.PreviousFrame:Show();
    end

    if (LegacyPanel.CurrentFrame ~= nil) then
        LegacyPanel.CurrentFrame:Hide();
    end

    LegacyPanel.PreviousFrame = LegacyPanel.CurrentFrame;
    LegacyPanel.CurrentFrame = nil;
end

function LegacyPanel_InitUI()
	-- LegacyPanel.UI.ActionButton[1]:SetPoint("BOTTOMLEFT", 400, 200);
	-- LegacyPanel.UI.ActionButton[7]:SetPoint("LEFT", LegacyPanel.UI.ActionButton[1], "LEFT", 0, 43);
end