function LegacyPanel_OnLoadReplacableAbilityItem(self)
    LegacyPanel_InitializeAbilityItem(self);
    self.title:Hide();
    self.desc:Hide();
    LegacyPanel.ReplacableAbilityItem[self.id] = self;
end

function LegacyPanel_OnEnterReplacableAbilityItem(self)
    local level = UnitLevel("player");
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
    if (self.spell ~= 0) then
	    GameTooltip:SetHyperlink("spell:"..self.spell);
		local l = _G[GameTooltip:GetName().."TextLeft1"];
		l:SetText("|cff"..Legacy_QualityColorHex(self.quality)..l:GetText());
		local p = _G[GameTooltip:GetName().."TextRight1"];
		p:SetText("|cff00ff00T"..self.tier);
		p:Show();
        if (self.id == 1) then
            GameTooltip:AddLine(LEGACY_ABILITY_RETURN_TO_MAIN_FRAME_HINT);
        elseif (Legacy_IsSpellUnlocked(self.spell)) then
            if (Legacy_HasUpgradeForSpell(self.spell)) then
                GameTooltip:AddDoubleLine(LEGACY_ABILITY_LEFT_CLICK_HINT, LEGACY_ABILITY_RIGHT_CLICK_HINT);
            else
                GameTooltip:AddLine(LEGACY_ABILITY_LEFT_CLICK_HINT);
            end
		else -- unlocked spell
        end
    else
		if (LegacyPanel.AbilityItemTarget ~= nil) then
			if (LegacyPanel.AbilityItemTarget._type == LEGACY_SPELL_TYPE_ACTIVE) then
				GameTooltip:AddLine(format(LEGACY_ABILITY_ACTIVE_SLOT_EMPTY, LegacyPanel.AbilityItemTarget.id));
			elseif (LegacyPanel.AbilityItemTarget._type == LEGACY_SPELL_TYPE_PASSIVE) then
				GameTooltip:AddLine(format(LEGACY_ABILITY_PASSIVE_SLOT_EMPTY, LegacyPanel.AbilityItemTarget.id));
			elseif (LegacyPanel.AbilityItemTarget._type == LEGACY_SPELL_TYPE_TALENT) then
				GameTooltip:AddLine(format(LEGACY_ABILITY_TALENT_SLOT_EMPTY, LegacyPanel.AbilityItemTarget.id));
			end
		end
        GameTooltip:AddLine(LEGACY_ABILITY_RETURN_TO_MAIN_FRAME_HINT);
    end
    self.highlight:SetVertexColor(0, 1, 0, 1);
    self.highlight:Show();
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveReplacableAbilityItem(self)
	self.highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickReplacableAbilityItem(self, button)
    if (button == "LeftButton") then
        if (self.id == 1) then
            
		else
			LegacyPanel_ReplaceAbility(self.spell, self.tier, self._type);
		end
		LegacyPanel.ReplacableAbilityFrame:Hide();
		LegacyPanel_ShowMainFrames();
	end	
		--[[
        elseif (Legacy_IsSpellUnlocked(self.spell)) then
            if (LegacyPanel.AbilityItemTarget.spell ~= 0) then
                local popup = StaticPopup_Show("LEGACY_REPLACE_ABILITY_CONFIRM", GetSpellLink(LegacyPanel.AbilityItemTarget.spell), GetSpellLink(self.spell));
                popup.spell = self.spell;
                popup.tier = LegacyPanel.AbilityItemTarget.id;
                popup._type = LegacyPanel.AbilityItemTarget._type;
            else
                LegacyPanel_ReplaceAbility(self.spell, LegacyPanel.AbilityItemTarget.id, LegacyPanel.AbilityItemTarget._type);
            end
        end
    else
        if (self.id == 1 and self.spell == 0) then return end
        if (Legacy_IsSpellUnlocked(self.spell) and Legacy_HasUpgradeForSpell(self.spell)) then
            local x, y = self:GetCenter();
            LegacyPanel.AbilityUpgradeFrame:SetPoint("CENTER", LegacyPanel.AbilityUpgradeFrame:GetParent(), "BOTTOMLEFT", x, y);
            LegacyPanel_LoadSpellUpgradesToFrame(self.spell, self.gp);
            LegacyPanel_Navigate(LegacyPanel.ReplacableAbilityFrame, LegacyPanel.AbilityUpgradeFrame);
        elseif (not Legacy_IsSpellUnlocked(self.spell) and self.gp > 0) then
			local cost = self.gp + Legacy_CalcSpellExtraCost(self._type);
			if (LegacyCharInfo.TP.Available >= cost) then
				local link = GetSpellLink(self.spell);
				local popup = StaticPopup_Show("LEGACY_LEARN_ABILITY_CONFIRM", link, cost);
				popup.link = link;
				popup.spell = self.spell;
				popup.gp = cost;
			end
        end
    end
	]]--
end

function LegacyPanel_LoadReplacableSpellsToFrame(spell, tier, _type)
    local _, cl = UnitClass("player");
	LegacyPanel.ReplacableAbilityItem[1].tier = tier + 1;
    LegacyPanel.ReplacableAbilityItem[1].spell = spell;
	LegacyPanel.ReplacableAbilityItem[1].border:SetVertexColor(1, 1, 0, 1);
    if (spell ~= 0) then
        LegacyPanel.ReplacableAbilityItem[1].icon:SetTexture(Legacy_GetSpellIcon(spell));
    else
        LegacyPanel.ReplacableAbilityItem[1].icon:SetTexture(LEGACY_ABILITY_EMPTY_ICON);
    end
    local index = 2;
    local list = PlayerSpell[cl];
    if (list == nil) then
        -- should not happen
    else
		local typeSpells = list[_type];
		if (typeSpells ~= nil) then
			local tierSpells = list[_type][tier];
			if (tierSpells == nil) then
			else
				for k, v in pairs(tierSpells) do
					LegacyPanel.ReplacableAbilityItem[index].tier = tier + 1;
					LegacyPanel.ReplacableAbilityItem[index].spell = v.s;
					LegacyPanel.ReplacableAbilityItem[index].quality = v.q;
					LegacyPanel.ReplacableAbilityItem[index]._type = _type;
					LegacyPanel.ReplacableAbilityItem[index].icon:SetTexture(Legacy_GetSpellIcon(v.s));
					LegacyPanel.ReplacableAbilityItem[index].border:SetVertexColor(Legacy_QualityColor(v.q));
					LegacyPanel.ReplacableAbilityItem[index]:Show();
					index = index + 1;
				end
			end
		end
    end

    for i = index, LEGACY_MAX_REPLACABLE_ABILITY_UI_SLOT do
        LegacyPanel.ReplacableAbilityItem[i]:Hide();
    end
end

function LegacyPanel_ReplaceAbility(spell, tier, _type)
    Legacy_DoQuery(LMSG_A_REPLACE_SPELL, spell..":"..tier..":".._type);
    LegacyPanel.ReplacableAbilityFrame:Hide();
    LegacyPanel_ShowMainFrames();
    LegacyPanel.AbilityItemTarget = nil;
end