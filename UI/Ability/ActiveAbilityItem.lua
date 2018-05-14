function LegacyPanel_OnLoadActiveAbilityItem(self)
    LegacyPanel_InitializeAbilityItem(self);
    self._type = LEGACY_SPELL_TYPE_ACTIVE;
    LegacyPanel.ActiveAbilityItem[self.id] = self;
	self.border:SetVertexColor(LEGACY_ACTIVE_SPELL_COLOR.r, LEGACY_ACTIVE_SPELL_COLOR.g, LEGACY_ACTIVE_SPELL_COLOR.b, LEGACY_ACTIVE_SPELL_COLOR.a);
	self.title:Hide();
	self.desc:Hide();
end

function LegacyPanel_OnEnterActiveAbilityItem(self)
	local lvl = UnitLevel("player");
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.spell ~= 0) then
		GameTooltip:SetHyperlink("spell:"..self.spell);
		local l = _G[GameTooltip:GetName().."TextLeft1"];
		l:SetText("|cff"..Legacy_QualityColorHex(self.quality)..l:GetText());
		local p = _G[GameTooltip:GetName().."TextRight1"];
		if (self.locked) then
			p:SetText(LEGACY_ACTIVE_SPELL_TIER[self.id].name.."("..LEGACY_SPELL_SEALED..")");
		else
			p:SetText(LEGACY_ACTIVE_SPELL_TIER[self.id].name);
		end
		p:Show();
		GameTooltip:AddLine(LEGACY_REMOVE_RUNE_HINT);
	else
		if (lvl < LEGACY_RUNE_UNLOCK_LEVEL[self.id]) then
			GameTooltip:AddDoubleLine(LEGACY_ACTIVE_SPELL_TIER[self.id].name, format(LEGACY_SPELL_UNLOCK_AT_LEVEL, LEGACY_RUNE_UNLOCK_LEVEL[self.id]));
		else
			if (self.locked) then
				GameTooltip:AddDoubleLine(LEGACY_ACTIVE_SPELL_TIER[self.id].name, LEGACY_SPELL_SEALED);
			else
				GameTooltip:AddDoubleLine(LEGACY_ACTIVE_SPELL_TIER[self.id].name, LEGACY_SPELL_AVAILABLE);
			end
		end
	end
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveActiveAbilityItem(self)
	GameTooltip:Hide();
end

function LegacyPanel_OnClickActiveAbilityItem(self, button)
	-- LegacyPanel_LoadReplacableSpellsToFrame(self.spell, self.id - 1, 1);
	-- LegacyPanel.ReplacableAbilityFrame:SetPoint("CENTER", self, "CENTER", 0, 0);
	-- Legacy_HideMainFrame();
	-- LegacyPanel.ReplacableAbilityFrame:SetFrameStrata("HIGH");
	-- LegacyPanel.ReplacableAbilityFrame:Show();
	
	if (button == "RightButton") then
		if (self.spell ~= 0) then
			local popup = StaticPopup_Show("LEGACY_REMOVE_RUNE_CONFIRM", GetSpellLink(self.spell));
			popup.type = 1;
			popup.slot = self.id - 1;
		end
	end
end

function LegacyPanel_UpdateRuneSlot(slot, spell, lvl, active)
	slot.spell = spell;
	local lvlReached = lvl >= LEGACY_RUNE_UNLOCK_LEVEL[slot.id];
	local _, cl = UnitClass("player");
	if (active or not lvlReached) then
		slot.icon:SetDesaturated(false);
		if (not lvlReached or (active and spell == 0)) then
			slot.icon:SetTexture(LEGACY_CLASS_ICON[0][cl]);
			slot.icon:SetVertexColor(LegacyClassColor[cl].r, LegacyClassColor[cl].g, LegacyClassColor[cl].b, 0.75);
		else
			slot.icon:SetVertexColor(1, 1, 1, 1);
			if (spell ~= 0) then
				slot.icon:SetTexture(Legacy_GetSpellIcon(spell));
			else
				slot.icon:SetTexture(LEGACY_LOCKED_ICON);
			end
		end
		slot.locked = false;
	else
		slot.icon:SetDesaturated(true);
		if (slot.spell ~= 0) then
			slot.icon:SetTexture(Legacy_GetSpellIcon(spell));
		else
			slot.icon:SetTexture(LEGACY_LOCKED_ICON);
		end
		slot.icon:SetVertexColor(1, 1, 1, 1);
		slot.locked = true;
	end
	
	if (not lvlReached) then
		slot.title:SetText(LEGACY_LEVEL);
		slot.desc:SetText(LEGACY_RUNE_UNLOCK_LEVEL[slot.id]);
		slot.title:Show();
		slot.desc:Show();
	else
		slot.title:Hide();
		slot.desc:Hide();
	end
end

-- wat a mes
function LegacyPanel_UpdateSpells(lvl)
    local _, cl = UnitClass("player");
    for i = 1, LEGACY_MAX_ACTIVE_ABILITY_UI_SLOT do
		local active = LegacyPanel.ActiveAbilityItem[i];
		local passive = LegacyPanel.PassiveAbilityItem[i];
		local talent = LegacyPanel.TalentAbilityItem[i];
		local activeSp = Legacy.Data.ActiveSpells[i];
		local passiveSp = Legacy.Data.PassiveSpells[i];
		local talentSp = Legacy.Data.TalentSpells[i];
		
		LegacyPanel_UpdateRuneSlot(active, activeSp, lvl, true);
		LegacyPanel_UpdateRuneSlot(passive, passiveSp, lvl, activeSp ~= 0);
		LegacyPanel_UpdateRuneSlot(talent, talentSp, lvl, activeSp ~= 0 and passiveSp ~= 0);
    end
end
