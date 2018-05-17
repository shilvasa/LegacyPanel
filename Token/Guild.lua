function LegacyPanel_OnLoadGuildRankToken(self)
	LegacyPanel_InitToken(self);
	self.spell = 0;
	self.Icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
	self.Highlight:SetVertexColor(1, 1, 1, 1);
	self.Highlight:Show();
	self.Title:Hide();
	self.Desc:Hide();
end

function LegacyPanel_OnEnterGuildRankToken(self, motion)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	GameTooltip:SetAnchorType("ANCHOR_CURSOR");
	local rank = Legacy.Data.Guild.Rank;
	if (self.Id == 1) then
		GameTooltip:AddLine(format(LEGACY_GUILD_RANK_STRING, rank));
	else
		GameTooltip:AddLine(format(LEGACY_GUILD_RANK_STRING, min(LEGACY_MAX_GUILD_RANK, rank + 1)));
	end
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveGuildRankToken(self, motion)
	GameTooltip:Hide();
end

function LegacyPanel_OnClickGuildRankToken(self, button, down)
end

function LegacyPanel_UpdateGuildRankInfo()
	local faction = UnitFactionGroup("player");
	faction = string.upper(faction);
	local rank = Legacy.Data.Guild.Rank;
	Legacy.UI.Home.Nav[LEGACY_PAGE_GUILD].Desc:SetText(rank);
	if (rank > LEGACY_MAX_GUILD_RANK) then rank = LEGACY_MAX_GUILD_RANK end;
	Legacy.UI.Guild.RankIndicator[1].Icon:SetTexture(LEGACY_GUILD_RANK.ICON[faction][rank]);
	Legacy.UI.Guild.RankIndicator[2].Icon:SetTexture(LEGACY_GUILD_RANK.ICON[faction][min(LEGACY_MAX_GUILD_RANK, rank+1)]);
	-- render trophie
	local xp = Legacy.Data.Guild.XP;
	local nxp = Legacy.Data.Guild.XPToNextLevel;

	for i = 1, 10 do
		local alpha = 1;
		local frac = nxp / 10;
		if (frac > 0) then
			alpha = min(1, (xp - frac * (i - 1)) / frac);
		end
		Legacy.UI.Guild.RankProgress[i].Highlight:SetVertexColor(LEGACY_GUILD_RANK.COLOR[faction].r, LEGACY_GUILD_RANK.COLOR[faction].g, LEGACY_GUILD_RANK.COLOR[faction].b, alpha);
		if (alpha == 0) then
			Legacy.UI.Guild.RankProgress[i].Icon:SetTexture(LEGACY_GUILD_RANK.ICON.NOTSTARTED);
		elseif (alpha == 1) then
			Legacy.UI.Guild.RankProgress[i].Icon:SetTexture(LEGACY_GUILD_RANK.ICON.FINISHED);
		else
			Legacy.UI.Guild.RankProgress[i].Icon:SetTexture(LEGACY_GUILD_RANK.ICON.NOTSTARTED);
		end
		Legacy.UI.Guild.RankProgress[i].Highlight:Show();
	end
end

function LegacyPanel_OnLoadGuildRankProgressToken(self)
	LegacyPanel_InitToken(self);
	self.Title:Hide();
	self.Desc:Hide();
	self.Icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
end

function LegacyPanel_OnEnterGuildRankProgressToken(self, motion)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
	GameTooltip:SetAnchorType("ANCHOR_CURSOR");
	GameTooltip:AddLine(format(LEGACY_GUILD_INFLUENCE, Legacy.Data.Guild.XP, Legacy.Data.Guild.XPToNextLevel));
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveGuildRankProgressToken(self, motion)
	GameTooltip:Hide();
end

function LegacyPanel_OnClickGuildRankProgressToken(self, button, down)
end

function LegacyPanel_OnLoadGuildBonusToken(self)
	LegacyPanel_InitToken(self);
	self.Icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
	if (IsGuildLeader()) then
		self.Icon:SetDesaturated(false);
		self.Border:SetVertexColor(1, 1, 1, 1);
	else
		self.Icon:SetDesaturated(true);
		self.Border:SetVertexColor(0.5, 0.5, 0.5, 1);
	end
	self.Title:Hide();
	self.Desc:Hide();
	self.entry = 0;
end

function LegacyPanel_OnEnterGuildBonusToken(self, motion)
	if (IsGuildLeader() and Legacy_GuildBonusUnlockAt(self.Id) <= Legacy.Data.Guild.Rank) then
		self.Highlight:SetVertexColor(0, 1, 0, 1);
		self.Highlight:Show();
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (Legacy_GuildBonusUnlockAt(self.Id) > Legacy.Data.Guild.Rank) then
		GameTooltip:AddLine(format(LEGACY_UNLOCK_AT_LEVEL, Legacy_GuildBonusUnlockAt(self.Id)));
	elseif (self.entry ~= 0) then
		GameTooltip:SetHyperlink("spell:"..self.entry);
		if (self.cost > 0) then
			GameTooltip:AddDoubleLine(LEGACY_GUILD_BONUS_COST, format(LEGACY_GUILD_BONUS_COST_VALUE, self.cost));
		end
	else
		GameTooltip:AddLine(LEGACY_GUILD_BONUS_EMPTY);
		if (IsGuildLeader()) then
			GameTooltip:AddLine(LEGACY_GUILD_BONUS_CLICK_TO_SELECT);
		end
	end
	_G[GameTooltip:GetName().."TextLeft1"]:SetVertexColor(Legacy_QualityColor(self.quality));
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveGuildBonusToken(self, motion)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickGuildBonusToken(self, button, down)
	if (not IsGuildLeader() or Legacy_GuildBonusUnlockAt(self.Id) > Legacy.Data.Guild.Rank) then
		return;
	end
	
	Legacy.UI.Guild.BonusSelection[2]:Hide();
	Legacy.UI.Guild.BonusSelection[3]:Hide();
	Legacy.UI.Guild.BonusSelection[4]:Hide();
	Legacy.UI.Guild.BonusSelection[5]:Hide();
	Legacy.UI.Guild.BonusSelection[6]:Hide();
	Legacy.UI.Guild.BonusSelection[7]:Hide();

	Legacy_DoQuery(LMSG_A_REQUEST_GUILD_SPELL, self.Id - 1);
	LegacyPanel_SetGuildBonusSlot(self.Id - 1);
	local x, y = self:GetCenter();
	Legacy.UI.Guild.BonusSelectionFrame:SetPoint("CENTER", Legacy.UI.Guild.BonusSelectionFrame:GetParent(), "BOTTOMLEFT", x, y);
	Legacy.UI.Guild.BonusSelectionFrame:SetFrameStrata("HIGH");
	Legacy.UI.Guild.BonusSelectionFrame:Show();
	for i = 1, LEGACY_MAX_GUILD_BONUS do
		Legacy.UI.Guild.Bonus[i]:Hide();
	end
end

function LegacyPanel_UpdateGuildBonus()
	for i = 1, LEGACY_MAX_GUILD_BONUS do
		local token = Legacy.UI.Guild.Bonus[i];
		if (Legacy_GuildBonusUnlockAt(i) > Legacy.Data.Guild.Rank) then
			token.Icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
			token.Icon:SetDesaturated(true);
			token.Border:SetVertexColor(0.5, 0.5, 0.5, 1);
		else
			token.Icon:SetDesaturated(false);
			token.Border:SetVertexColor(1, 1, 1, 1);
			if (Legacy.Data.Guild.Buff[i - 1] ~= nil and Legacy.Data.Guild.Buff[i - 1].spell ~= 0) then
				token.spell = Legacy.Data.Guild.Buff[i - 1].spell;
				token.cost = Legacy.Data.Guild.Buff[i - 1].cost;
				token.quality = Legacy.Data.Guild.Buff[i - 1].quality;
				token.Border:SetVertexColor(Legacy_QualityColor(token.quality));
				token.Icon:SetTexture(Legacy_GetSpellIcon(token.spell));
				if (token.cost > 0) then
					token.Desc:SetText(token.cost);
					token.Desc:Show();
				else
					token.Desc:Hide();
				end
			else
				token.spell = 0;
				token.cost = 0;
				token.Icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
				token.Desc:Hide();
			end
		end
	end
end

---------------------------

function LegacyPanel_OnLoadGuildBonusSelectionToken(self)
	LegacyPanel_InitToken(self);
	self.spell = 0;
	self.cost = 0;
	self.Title:Hide();
	self.Desc:Hide();
end

function LegacyPanel_OnEnterGuildBonusSelectionToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
	self.Highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.Id == 1) then
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

function LegacyPanel_OnLeaveGuildBonusSelectionToken(self, motion)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickGuildBonusSelectionToken(self, button, down)
	if (self.Id == 1) then
		Legacy.UI.Guild.BonusSelectionFrame:Hide();
		for i = 1, LEGACY_MAX_GUILD_BONUS do
			Legacy.UI.Guild.Bonus[i]:Show();
		end
		return;
	end
	
	if (not Legacy_IsCurrentGuildBonus(self.Id - 1, self.spell)) then
		local link = GetSpellLink(self.spell);
		local popup = StaticPopup_Show("LEGACY_SELECT_GUILD_SPELL_CONFIRM", link, self.cost);
		popup.slot = self.slot;
		popup.spell = self.spell;
	end
end

function LegacyPanel_SetGuildBonusSlot(slot)
	for i = 1, 7 do
		Legacy.UI.Guild.BonusSelection[i].slot = slot;
	end
end

function LegacyPanel_LoadGuildBonusItems(data)
	Legacy.UI.Guild.BonusSelection[1].Icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
	for i = 2, 7 do
		local token = Legacy.UI.Guild.BonusSelection[i];
		token.spell = data[i-2].spell;
		token.cost = data[i-2].cost;
		token.rank = data[i-2].rank;
		token.quality = data[i-2].quality;
		
		if (token.spell ~= 0) then
			token.Icon:SetTexture(Legacy_GetSpellIcon(token.spell));
			if (token.cost > 0) then
				token.Desc:SetText(token.cost);
				token.Desc:Show();
			end
			if (Legacy_IsCurrentGuildBonus(i - 2, token.spell)) then
				token.Border:SetVertexColor(1.0, 1.0, 0, 1.0);
			else
				token.Border:SetVertexColor(Legacy_QualityColor(token.quality));
			end
			token:Show();
		else
			token.Icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
			token:Hide();
		end
	end
end

function LegacyPanel_SelectGuildSpell(slot, spell)
	Legacy_DoQuery(LMSG_A_SELECT_GUILD_SPELL, slot..":"..spell);
	Legacy.UI.Guild.BonusSelectionFrame:Hide();
	for i = 1, LEGACY_MAX_GUILD_BONUS do
		Legacy.UI.Guild.Bonus[i]:Show();
	end
end