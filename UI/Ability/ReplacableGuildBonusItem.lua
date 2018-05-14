function LegacyPanel_OnLoadGuildBonusReplaceItem(self)
	LegacyPanel_InitializeAbilityItem(self);
	LegacyPanel.GuildUI.BonusReplacer[self.id] = self;
	self.spell = 0;
	self.cost = 0;
	self.title:Hide();
	self.desc:Hide();
end

function LegacyPanel_OnEnterGuildBonusReplaceItem(self, motion)
	self.highlight:SetVertexColor(0, 1, 0, 1);
	self.highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.id == 1) then
		if (self.spell ~= 0) then
			GameTooltip:SetHyperlink("spell:"..self.spell);
		else
			GameTooltip:AddLine(LEGACY_GUILD_BONUS_EMPTY);
			GameTooltip:AddLine(LEGACY_GUILD_REPLACE_BONUS_CLICK_TO_RETURN);
		end
		GameTooltip:Show();
	elseif (self.spell ~= 0) then
		GameTooltip:SetHyperlink("spell:"..self.spell);
		if (self.cost > 0) then
			GameTooltip:AddDoubleLine(LEGACY_GUILD_BONUS_COST, format(LEGACY_GUILD_BONUS_COST_VALUE, self.cost));
		end
		if (Legacy.Data.Guild.Rank >= self.rank) then
			GameTooltip:AddDoubleLine("|cff00ff00"..LEGACY_REQ_GUILD_LEVEL.."|r", "|cff00ff00"..self.rank.."|r");
		else
			GameTooltip:AddDoubleLine("|cffdddddd"..LEGACY_REQ_GUILD_LEVEL.."|r", "|cffdddddd"..self.rank.."|r");
		end
		
		_G[GameTooltip:GetName().."TextLeft1"]:SetVertexColor(Legacy_QualityColor(self.quality));
		
		GameTooltip:Show();
	end
end

function LegacyPanel_OnLeaveGuildBonusReplaceItem(self, motion)
	self.highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickGuildBonusReplaceItem(self, button, down)
	if (self.id == 1) then
		LegacyPanel.ReplacableGuildBonusFrame:Hide();
		for i = 1, LEGACY_MAX_GUILD_BONUS do
			LegacyPanel.GuildUI.Bonus[i]:Show();
		end
		return;
	end
	
	if (not Legacy_IsCurrentGuildBonus(self.id - 1, self.spell)) then
		local link = GetSpellLink(self.spell);
		local popup = StaticPopup_Show("LEGACY_SELECT_GUILD_SPELL_CONFIRM", link, self.cost);
		popup.slot = self.slot;
		popup.spell = self.spell;
	end
end

function LegacyPanel_SetGuildBonusSlot(slot)
	for i = 1, 7 do
		LegacyPanel.GuildUI.BonusReplacer[i].slot = slot;
	end
end

function LegacyPanel_LoadGuildBonusItems(data)
	LegacyPanel.GuildUI.BonusReplacer[1].icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
	
	for i = 2, 7 do
		local replacer = LegacyPanel.GuildUI.BonusReplacer[i];
		
		replacer.spell = data[i-2].s;
		replacer.cost = data[i-2].c;
		replacer.rank = data[i-2].r;
		replacer.quality = data[i-2].q;
		
		if (replacer.spell ~= 0) then
			replacer.icon:SetTexture(Legacy_GetSpellIcon(replacer.spell));
			if (replacer.cost > 0) then
				replacer.desc:SetText(replacer.cost);
				replacer.desc:Show();
			end
			if (Legacy_IsCurrentGuildBonus(i - 2, replacer.spell)) then
				replacer.border:SetVertexColor(1.0, 1.0, 0, 1.0);
			else
				replacer.border:SetVertexColor(Legacy_QualityColor(replacer.quality));
			end
			replacer:Show();
		else
			replacer.icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
			replacer:Hide();
		end
	end
end

function LegacyPanel_SelectGuildSpell(slot, spell)
	Legacy_DoQuery(LMSG_A_SELECT_GUILD_SPELL, slot..":"..spell);
	LegacyPanel.ReplacableGuildBonusFrame:Hide();
	for i = 1, LEGACY_MAX_GUILD_BONUS do
		LegacyPanel.GuildUI.Bonus[i]:Show();
	end
end