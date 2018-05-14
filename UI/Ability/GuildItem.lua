function LegacyPanel_OnLoadGuildRankIndicator(self)
	LegacyPanel_InitializeAbilityItem(self);
	LegacyPanel.GuildUI.RankIndicator[self.id] = self;
	self.spell = 0;
	self.icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
	self.highlight:SetVertexColor(1, 1, 1, 1);
	self.highlight:Show();
	self.title:Hide();
	self.desc:Hide();
end

function LegacyPanel_OnEnterGuildRankIndicator(self, motion)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	GameTooltip:SetAnchorType("ANCHOR_CURSOR");
	local rank = Legacy.Data.Guild.Rank;
	if (self.id == 1) then
		GameTooltip:AddLine(format(LEGACY_GUILD_RANK_STRING, rank));
	else
		GameTooltip:AddLine(format(LEGACY_GUILD_RANK_STRING, min(LEGACY_MAX_GUILD_RANK, rank + 1)));
	end
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveGuildRankIndicator(self, motion)
	GameTooltip:Hide();
end

function LegacyPanel_OnClickGuildRankIndicator(self, button, down)
end

function LegacyPanel_UpdateGuildRankInfo()
	local faction = UnitFactionGroup("player");
	faction = string.upper(faction);
	local level = Legacy.Data.Guild.Rank;
	LegacyPanel.Nav[LEGACY_PAGE_GUILD].desc:SetText(level);
	if (level > LEGACY_MAX_GUILD_RANK) then level = LEGACY_MAX_GUILD_RANK end;
	LegacyPanel.GuildUI.RankIndicator[1].icon:SetTexture(LEGACY_GUILD_RANK.ICON[faction][level]);
	LegacyPanel.GuildUI.RankIndicator[2].icon:SetTexture(LEGACY_GUILD_RANK.ICON[faction][min(LEGACY_MAX_GUILD_RANK, level + 1)]);
	-- render trophie
	local xp = Legacy.Data.Guild.XP;
	local nxp = Legacy.Data.Guild.XPToNextLevel;

	for i = 1, 10 do
		local alpha = 1;
		local frac = nxp / 10;
		if (frac > 0) then
			alpha = min(1, (xp - frac * (i - 1)) / frac);
		end
		LegacyPanel.GuildUI.RankProgress[i].highlight:SetVertexColor(LEGACY_GUILD_RANK.COLOR[faction].r, LEGACY_GUILD_RANK.COLOR[faction].g, LEGACY_GUILD_RANK.COLOR[faction].b, alpha);
		if (alpha == 0) then
			LegacyPanel.GuildUI.RankProgress[i].icon:SetTexture(LEGACY_GUILD_RANK.ICON.NOTSTARTED);
		elseif (alpha == 1) then
			LegacyPanel.GuildUI.RankProgress[i].icon:SetTexture(LEGACY_GUILD_RANK.ICON.FINISHED);
		else
			LegacyPanel.GuildUI.RankProgress[i].icon:SetTexture(LEGACY_GUILD_RANK.ICON.NOTSTARTED);
		end
		LegacyPanel.GuildUI.RankProgress[i].highlight:Show();
	end
end

function LegacyPanel_OnLoadGuildRankProgressItem(self)
	LegacyPanel_InitializeAbilityItem(self);
	LegacyPanel.GuildUI.RankProgress[self.id] = self;
	self.title:Hide();
	self.desc:Hide();
	self.icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
end

function LegacyPanel_OnEnterGuildRankProgressItem(self, motion)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", 0, 0);
	GameTooltip:SetAnchorType("ANCHOR_CURSOR");
	GameTooltip:AddLine(format(LEGACY_GUILD_INFLUENCE, Legacy.Data.Guild.XP, Legacy.Data.Guild.XPToNextLevel));
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveGuildRankProgressItem(self, motion)
	GameTooltip:Hide();
end

function LegacyPanel_OnClickGuildRankProgressItem(self, button, down)
end

function LegacyPanel_OnLoadGuildBonusItem(self)
	LegacyPanel_InitializeAbilityItem(self);
	LegacyPanel.GuildUI.Bonus[self.id] = self;
	self.icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
	if (IsGuildLeader()) then
		self.icon:SetDesaturated(false);
		self.border:SetVertexColor(1, 1, 1, 1);
	else
		self.icon:SetDesaturated(true);
		self.border:SetVertexColor(0.5, 0.5, 0.5, 1);
	end
	--self:Hide();
	self.title:Hide();
	self.desc:Hide();
end

function LegacyPanel_OnEnterGuildBonusItem(self, motion)
	if (IsGuildLeader() and Legacy_GuildBonusUnlockAt(self.id) <= Legacy.Data.Guild.Rank) then
		self.highlight:SetVertexColor(0, 1, 0, 1);
		self.highlight:Show();
	end
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (Legacy_GuildBonusUnlockAt(self.id) > Legacy.Data.Guild.Rank) then
		GameTooltip:AddLine(format(LEGACY_UNLOCK_AT_LEVEL, Legacy_GuildBonusUnlockAt(self.id)));
	elseif (self.spell ~= 0) then
		GameTooltip:SetHyperlink("spell:"..self.spell);
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

function LegacyPanel_OnLeaveGuildBonusItem(self, motion)
	self.highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickGuildBonusItem(self, button, down)
	if (not IsGuildLeader() or Legacy_GuildBonusUnlockAt(self.id) > Legacy.Data.Guild.Rank) then
		return;
	end
	
	LegacyPanel.GuildUI.BonusReplacer[2]:Hide();
	LegacyPanel.GuildUI.BonusReplacer[3]:Hide();
	LegacyPanel.GuildUI.BonusReplacer[4]:Hide();
	LegacyPanel.GuildUI.BonusReplacer[5]:Hide();
	LegacyPanel.GuildUI.BonusReplacer[6]:Hide();
	LegacyPanel.GuildUI.BonusReplacer[7]:Hide();

	Legacy_DoQuery(LMSG_A_REQUEST_GUILD_SPELL, self.id - 1);
	LegacyPanel_SetGuildBonusSlot(self.id - 1);
	local x, y = self:GetCenter();
	LegacyPanel.ReplacableGuildBonusFrame:SetPoint("CENTER", LegacyPanel.ReplacableGuildBonusFrame:GetParent(), "BOTTOMLEFT", x, y);
	LegacyPanel.ReplacableGuildBonusFrame:SetFrameStrata("HIGH");

	LegacyPanel.ReplacableGuildBonusFrame:Show();
	for i = 1, LEGACY_MAX_GUILD_BONUS do
		LegacyPanel.GuildUI.Bonus[i]:Hide();
	end
end

function LegacyPanel_UpdateGuildBonus()
	for i = 1, LEGACY_MAX_GUILD_BONUS do
		local bonusUI = LegacyPanel.GuildUI.Bonus[i];
		if (Legacy_GuildBonusUnlockAt(i) > Legacy.Data.Guild.Rank) then
			bonusUI.icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
			bonusUI.icon:SetDesaturated(true);
			bonusUI.border:SetVertexColor(0.5, 0.5, 0.5, 1);
		else
			bonusUI.icon:SetDesaturated(false);
			bonusUI.border:SetVertexColor(1, 1, 1, 1);
			if (Legacy.Data.Guild.Bonus[i - 1] ~= nil and Legacy.Data.Guild.Bonus[i - 1].s ~= 0) then
				bonusUI.spell = Legacy.Data.Guild.Bonus[i - 1].s;
				bonusUI.cost = Legacy.Data.Guild.Bonus[i - 1].c;
				bonusUI.quality = Legacy.Data.Guild.Bonus[i - 1].q;
				bonusUI.border:SetVertexColor(Legacy_QualityColor(bonusUI.quality));
				bonusUI.icon:SetTexture(Legacy_GetSpellIcon(bonusUI.spell));
				if (bonusUI.cost > 0) then
					bonusUI.desc:SetText(bonusUI.cost);
					bonusUI.desc:Show();
				else
					bonusUI.desc:Hide();
				end
			else
				bonusUI.spell = 0;
				bonusUI.cost = 0;
				bonusUI.icon:SetTexture(LEGACY_GUILD_RANK.ICON.BONUS_UNASSIGNED);
				bonusUI.desc:Hide();
			end
		end
	end
end