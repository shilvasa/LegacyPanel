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

function Legacy_FormatSpellStatText(text, prefix, index)
	if (text ~= nil) then
		local v, m, d, l = string.match(text, "<q"..prefix.."|(%d+)|(%d+.?%d*)|(%d+.?%d*)|(%d+.?%d*)>");
		if (v ~= nil) then
			local _, stat, _, _ = UnitStat("player", index);
			text = string.gsub(text, "<q"..prefix.."|%d+|%d+.?%d*|%d+.?%d*|%d+.?%d*>", format("%.1f", Legacy_QBenefit(l, d, v*stat*m)));
		end
		v, m, d, l = string.match(text, "<q"..prefix.."1|(%d+)|(%d+.?%d*)|(%d+.?%d*)|(%d+.?%d*)>");
		if (v ~= nil) then
			local _, stat, _, _ = UnitStat("player", index);
			text = string.gsub(text, "<q"..prefix.."1|%d+|%d+.?%d*|%d+.?%d*|%d+.?%d*>", format("%.1f", Legacy_QBenefit(l, d, v*stat*m)));
		end
		v, m = string.match(text, "<"..prefix.."|(%d+)|(%d+.?%d*)>");
		if (v ~= nil) then
			local _, stat, _, _ = UnitStat("player", index);
			text = string.gsub(text, "<"..prefix.."|%d+|%d+.?%d*>", format("%.1f", v*stat*m));
		end
	end
	
	return text;
end

function Legacy_FormatSpellText(frame)
	local t = frame:GetText();
	if (t ~= nil) then
		t = Legacy_FormatSpellStatText(t, "str", 1);
		t = Legacy_FormatSpellStatText(t, "agi", 2);
		t = Legacy_FormatSpellStatText(t, "sta", 3);
		t = Legacy_FormatSpellStatText(t, "int", 4);
		t = Legacy_FormatSpellStatText(t, "spi", 5);
		frame:SetText(t);
	end
end

function Legacy_FormatSpellInfo(tooltip, link)
	for i = 2, tooltip:NumLines() do
		Legacy_FormatSpellText(_G[tooltip:GetName().."TextLeft"..i]);
		Legacy_FormatSpellText(_G[tooltip:GetName().."TextRight"..i]);
	end
end

function LegacyPanel_HookSpellTooltip(tooltip)
    tooltip:HookScript("OnTooltipSetSpell", function(self, ...)
        local _, link = self:GetItem();
		if (link ~= "") then
			Legacy_FormatSpellInfo(self, link);
		end
    end)
end
