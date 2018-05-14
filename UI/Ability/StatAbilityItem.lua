function LegacyPanel_OnLoadStatAbilityItem(self)
    LegacyPanel_InitializeAbilityItem(self);
    self._type = LEGACY_SPELL_TYPE_SPECIALTY;
    self.title:SetText(LEGACY_SPECIALTY_DESC[self.id].title);
    self.desc:SetText(LegacyCharInfo.SpecialtyStats[self.id].Point);
    self.icon:SetTexture(LEGACY_SPECIALTY_DESC[self.id].icon);
    LegacyPanel.StatAbilityItem[self.id] = self;
    self.title:Show();
    self.desc:Show();
end

function LegacyPanel_OnEnterStatAbilityItem(self)
    self.highlight:SetVertexColor(0, 1, 0, 1);
    self.highlight:Show();
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	LegacyPanel_FormatStatItemTip(self);
	GameTooltip:Show();
end

function LegacyPanel_FormatStatItemTip(item)
	local index = item.id;
	local specPoint = Legacy_GetSpecPoint(index);
	if (index == 6) then
		GameTooltip:AddDoubleLine(LEGACY_MF, format(LEGACY_MF_TIP_FORMAT, LegacyCharInfo.MF.Level, LegacyCharInfo.MF.SLevel, LegacyCharInfo.MF.Cap));
		GameTooltip:AddLine(LEGACY_MF_DESC);
		if (LegacyCharInfo.MF.State == 0) then
			GameTooltip:AddLine(LEGACY_MF_STATE_RECORD);
		elseif (LegacyCharInfo.MF.State == 1) then
			GameTooltip:AddLine(LEGACY_MF_STATE_SEALED);
		end
	else
	    GameTooltip:AddLine(format(LEGACY_SPECIALTY_DESC[item.id].tip, Legacy_GetSpecPoint(index)));
		if (index == 5) then
			GameTooltip:AddLine(format(LEGACY_SPECIALTY_DESC_PSYCHE, Legacy_QBenefit(LEGACY_SPECIALTY_BONUS_FACTOR_PSYCHE, LEGACY_SPECIALTY_DDENO, Legacy_GetSpecPoint(index))));
		end
		GameTooltip:AddLine(format(LEGACY_SPECIALTY_DESC[item.id].bonus, Legacy_QBenefit(LEGACY_SPECIALTY_BONUS_FACTOR[item.id], LEGACY_SPECIALTY_DDENO, Legacy_GetSpecPoint(index))));
		GameTooltip:AddLine(" ");
		GameTooltip:AddLine(format(LEGACY_SPECIALTY_DESC[index].desc, Legacy_GetSpecPoint(index) * LEGACY_SPECIALTY_BONUS_R3, Legacy_GetSpecPoint(index) * LEGACY_SPECIALTY_BONUS_R2, Legacy_GetSpecPoint(index) * LEGACY_SPECIALTY_BONUS_R1, Legacy_GetSpecPoint(index) * LEGACY_SPECIALTY_BONUS_R2, Legacy_GetSpecPoint(index) * LEGACY_SPECIALTY_BONUS_R3));
		GameTooltip:AddLine(LEGACY_ABILITY_LEARN_SPECIALTY.." "..format(LEGACY_ABILITY_GP_COST, Legacy_GetGPCostForStat(LegacyCharInfo.SpecialtyStats[index].Point + 1)));
	end
end

function LegacyPanel_OnLeaveStatAbilityItem(self)
	self.highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickStatAbilityItem(self, button)
    if (button == "RightButton") then
		if (self.id == 6) then
			local state = LEGACY_MF_STATE[0];
			local desc = LEGACY_SET_MF_STATE_RECORD;
			if (LegacyCharInfo.MF.State == 0) then
				state = LEGACY_MF_STATE[1];
				desc = LEGACY_SET_MF_STATE_SEAL;
			end
			local popup = StaticPopup_Show("LEGACY_SET_MF_STATE", state, desc);
        elseif (LegacyCharInfo.GP.Available >= Legacy_GetGPCostForStat(LegacyCharInfo.SpecialtyStats[self.id].Point + 1)) then
            Legacy_DoQuery(LMSG_A_LEARN_STAT, self.id);
        end
    end
end

function LegacyPanel_UpdateStats()
    for i = 1, 5 do
        LegacyPanel.StatAbilityItem[i].desc:SetText(Legacy_GetSpecPoint(i));
    end
	
	if (LegacyCharInfo.MF.State == 0) then
		LegacyPanel.StatAbilityItem[6].desc:SetText("|cff00ff00"..Legacy_GetSpecPoint(6));
	elseif (LegacyCharInfo.MF.State == 1) then
		LegacyPanel.StatAbilityItem[6].desc:SetText("|cff00ffff"..Legacy_GetSpecPoint(6));
	end
	
    local tipOwner = GameTooltip:GetOwner();
    if (tipOwner ~= nil and tipOwner._type == LEGACY_SPELL_TYPE_SPECIALTY) then
        GameTooltip:ClearLines();
        LegacyPanel_FormatStatItemTip(tipOwner);
        GameTooltip:Show();
    end
end