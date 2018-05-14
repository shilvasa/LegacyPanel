function LegacyPanel_OnLoadPassiveAbilityItem(self)
    LegacyPanel_InitializeAbilityItem(self);
    self._type = LEGACY_SPELL_TYPE_PASSIVE;
    LegacyPanel.PassiveAbilityItem[self.id] = self;
	self.border:SetVertexColor(LEGACY_PASSIVE_SPELL_COLOR.r, LEGACY_PASSIVE_SPELL_COLOR.g, LEGACY_PASSIVE_SPELL_COLOR.b, LEGACY_PASSIVE_SPELL_COLOR.a);
	self.title:Hide();
	self.desc:Hide();
end

function LegacyPanel_OnEnterPassiveAbilityItem(self)
	local lvl = UnitLevel("player");
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.spell ~= 0) then
		GameTooltip:SetHyperlink("spell:"..self.spell);
		local l = _G[GameTooltip:GetName().."TextLeft1"];
		l:SetText("|cff"..Legacy_QualityColorHex(self.quality)..l:GetText());
		local p = _G[GameTooltip:GetName().."TextRight1"];
		if (self.locked) then
			p:SetText(LEGACY_PASSIVE_SPELL_TIER[self.id].name.."("..LEGACY_SPELL_SEALED..")");
		else
			p:SetText(LEGACY_PASSIVE_SPELL_TIER[self.id].name);
		end
		p:Show();
		GameTooltip:AddLine(LEGACY_REMOVE_RUNE_HINT);
	else
		if (lvl < LEGACY_RUNE_UNLOCK_LEVEL[self.id]) then
			GameTooltip:AddDoubleLine(LEGACY_PASSIVE_SPELL_TIER[self.id].name, format(LEGACY_SPELL_UNLOCK_AT_LEVEL, LEGACY_RUNE_UNLOCK_LEVEL[self.id]));
		else
			if (self.locked) then
				GameTooltip:AddDoubleLine(LEGACY_PASSIVE_SPELL_TIER[self.id].name, LEGACY_SPELL_SEALED);
			else
				GameTooltip:AddDoubleLine(LEGACY_ACTIVE_SPELL_TIER[self.id].name, LEGACY_SPELL_AVAILABLE);
			end
		end
	end
	GameTooltip:Show();
end

function LegacyPanel_OnLeavePassiveAbilityItem(self)
	GameTooltip:Hide();
end

function LegacyPanel_OnClickPassiveAbilityItem(self, button)
	-- LegacyPanel_LoadReplacableSpellsToFrame(self.spell, self.id - 1, 2);
	-- LegacyPanel.ReplacableAbilityFrame:SetPoint("CENTER", self, "CENTER", 0, 0);
	-- Legacy_HideMainFrame();
	-- LegacyPanel.ReplacableAbilityFrame:SetFrameStrata("HIGH");
	-- LegacyPanel.ReplacableAbilityFrame:Show();
	
	if (button == "RightButton") then
		if (self.spell ~= 0) then
			local popup = StaticPopup_Show("LEGACY_REMOVE_RUNE_CONFIRM", GetSpellLink(self.spell));
			popup.type = 2;
			popup.slot = self.id - 1;
		end
	end

end
