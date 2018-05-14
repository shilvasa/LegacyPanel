function LegacyPanel_InitializeAbilityItem(self)
    self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    local name = self:GetName();
    self.id = self:GetID();
	self.icon = _G[name .. "Icon"];
	self.border = _G[name .. "Border"];
	self.highlight = _G[name .. "Highlight"];
    self.title = _G[name.."Title"];
    self.desc = _G[name.."Desc"];
    self.spell = 0;
    self.replacedSpell = 0;
    self.gp = 0;
end

function LegacyPanel_UnlockAffectedAbilityFrameAndTips(spell)
    for i = 1, 19 do
        if (LegacyPanel.ReplacableAbilityItem[i].spell == spell) then
            LegacyPanel.ReplacableAbilityItem[i].icon:SetDesaturated(false);
        end
    end

    if (LegacyPanel.AbilityUpgradeItem[1].spell == spell) then
        LegacyPanel.AbilityUpgradeItem[1].title:Hide();
        LegacyPanel.AbilityUpgradeItem[1].desc:Hide();
        for i = 1, 8 do
            LegacyPanel.AbilityUpgradeItem[i].icon:SetDesaturated(false);
        end
    end
end