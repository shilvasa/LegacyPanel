function LegacyPanel_OnLoadReputationToken(self)
	LegacyPanel_InitToken(self);
    self.Title:Hide();
    self.Desc:Hide();
	self.entry = 0;
end

function LegacyPanel_OnEnterReputationToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
    self.Highlight:Show();
	if (self.Type == LEGACY_REPUTATION_TYPE_REWARD) then
		if (self.entry ~= 0) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
			GameTooltip:SetHyperlink("item:"..self.entry);
			GameTooltip:Show();
		end
	elseif (self.Type == LEGACY_REPUTATION_TYPE_ITEM) then
		if (self.entry ~= 0) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
			GameTooltip:SetHyperlink("item:"..self.entry);
			GameTooltip:AddDoubleLine(LEGACY_COMMUNITY_REPUTATION, format(LEGACY_MARKET_REPUTATION_REWARD, self.data.rank));
			local p = _G[GameTooltip:GetName().."TextRight1"];
			if (self.data.rank <= Legacy.Data.Account.Rank) then
				if (self.data.periodic) then
					p:SetText(LEGACY_MARKET_REPUTATION_REWARDED_PERIODIC);
				else
					p:SetText(LEGACY_MARKET_REPUTATION_REWARDED);
				end
			else
				if (self.data.periodic) then
					p:SetText(LEGACY_MARKET_REPUTATION_NOT_REWARDED_PERIODIC);
				else
					p:SetText(LEGACY_MARKET_REPUTATION_NOT_REWARDED);
				end
			end
			p:Show();
			GameTooltip:Show();
		end
	elseif (self.Type == LEGACY_REPUTATION_TYPE_SPELL) then
		if (self.entry ~= 0) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
			GameTooltip:SetHyperlink("spell:"..self.entry);
			GameTooltip:AddDoubleLine(LEGACY_COMMUNITY_REPUTATION, format(LEGACY_MARKET_REPUTATION_REWARD, self.data.rank));
			local p = _G[GameTooltip:GetName().."TextRight1"];
			if (self.data.rank <= Legacy.Data.Account.Rank) then
				p:SetText(LEGACY_MARKET_REPUTATION_REWARDED);
			else
				p:SetText(LEGACY_MARKET_REPUTATION_NOT_REWARDED);
			end
			p:Show();
			GameTooltip:Show();
		end
	end
end

function LegacyPanel_OnLeaveReputationToken(self, motion)
	self.Highlight:Hide();
    GameTooltip:Hide();
end

function LegacyPanel_OnClickReputationToken(self, button, down)
	if (button == "LeftButton") then
		if (self.Type == LEGACY_REPUTATION_TYPE_ITEM and self.entry ~= 0) then
			if (IsDressableItem(self.entry)) then
				DressUpItemLink(Legacy_GetItemLink(self.entry));
			end
		end
	elseif (button == "RightButton") then
		if (self.Type == LEGACY_REPUTATION_TYPE_REWARD and self.entry ~= 0) then
			LegacyPanel_FetchRewardItem(self.entry, self.data.slot);
		end
	end	
end

function LegacyPanel_UpdateReputation()
	for i = 1, LEGACY_MAX_REPUTATION_REWARD_PER_PAGE do
		local token = Legacy.UI.Reputation.Reward[i];
		local reward = Legacy.Data.Character.Reward.Item[i+Legacy.Var.Nav.Page.Reputation.Reward*LEGACY_MAX_REPUTATION_REWARD_PER_PAGE];
		token.data = reward;
		if (reward ~= nil) then
			token.entry = reward.entry;
			token.Icon:SetTexture(GetItemIcon(reward.entry));
			token.Desc:SetText(reward.count);
			if (reward.slot == LEGACY_REWARD_TYPE_EVENT) then
				token.Desc:SetTextColor(1, 0, 1, 1);
			elseif (reward.slot == LEGACY_REWARD_TYPE_ACCOUNT) then -- account reward
				token.Desc:SetTextColor(0, 1, 1, 1);
			elseif (reward.slot == LEGACY_REWARD_TYPE_CHARACTER) then -- character reward
				token.Desc:SetTextColor(1, 1, 0, 1);
			end
			token.Desc:Show();
			token:Show();
		else
			token.entry = 0;
			token:Hide();
		end
	end
	
	for i = 1, LEGACY_MAX_REPUTATION_ITEM_PER_PAGE do
		local token = Legacy.UI.Reputation.Item[i];
		local item = Legacy.Data.Env.Reputation.Item[i+Legacy.Var.Nav.Page.Reputation.Item*LEGACY_MAX_REPUTATION_ITEM_PER_PAGE];
		token.data = item;
		if (item ~= nil) then
			token.entry = item.entry;
			token.Icon:SetTexture(GetItemIcon(item.entry));
			token:Show();
			token.Desc:SetText(format(LEGACY_MARKET_REPUTATION_RANK_FORMAT, item.rank));
			token.Desc:Show();
			if (item.rank <= Legacy.Data.Account.Rank) then
				token.Icon:SetDesaturated(false);
				if (item.s) then -- ?
					token.Border:SetVertexColor(1, 1, 0.5, 1);
				else
					token.Border:SetVertexColor(1, 0.75, 0.75, 1);
				end
			else
				token.Icon:SetDesaturated(true);
				token.Border:SetVertexColor(0.5, 0.5, 0.5);
			end
		else
			token.entry = 0;
			token:Hide();
		end
	end
	
	for i = 1, LEGACY_MAX_REPUTATION_SPELL_PER_PAGE do
		local token = Legacy.UI.Reputation.Spell[i];
		local spell = Legacy.Data.Env.Reputation.Spell[i+Legacy.Var.Nav.Page.Reputation.Spell*LEGACY_MAX_REPUTATION_SPELL_PER_PAGE];
		token.data = spell;
		if (spell ~= nil) then
			token.entry = spell.entry;
			token.Icon:SetTexture(Legacy_GetSpellIcon(spell.entry));
			if (not LegacyPanel_MarketSpellPossessed(spell.entry)) then
				token.Border:SetVertexColor(0.5, 0.5, 0.5, 1);
				token.Icon:SetDesaturated(true);
			end
			token:Show();
			token.Desc:SetText(format(LEGACY_MARKET_REPUTATION_RANK_FORMAT, spell.rank));
			token.Desc:Show();
			if (spell.rank <= Legacy.Data.Account.Rank) then
				token.Icon:SetDesaturated(false);
				token.Border:SetVertexColor(1, 0.5, 1, 1);
			else
				token.Icon:SetDesaturated(true);
				token.Border:SetVertexColor(0.5, 0.5, 0.5);
			end
		else
			token.entry = 0;
			token:Hide();
		end
	end
end

function LegacyPanel_UpdateReputationNavState()
	local rewardCount = #Legacy.Data.Character.Reward.Item;
	if (Legacy.Var.Nav.Page.Reputation.Reward > 0) then
		Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_PREV].more = true;
		Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_PREV].more = false;
		Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	if ((Legacy.Var.Nav.Page.Reputation.Reward+1)*LEGACY_MAX_REPUTATION_REWARD_PER_PAGE >= rewardCount) then
		Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
	
	local itemCount = #Legacy.Data.Env.Reputation.Item;
	if (Legacy.Var.Nav.Page.Reputation.Item > 0) then
		Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_PREV].more = true;
		Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_PREV].more = false;
		Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	if ((Legacy.Var.Nav.Page.Reputation.Item+1)*LEGACY_MAX_REPUTATION_ITEM_PER_PAGE >= itemCount) then
		Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
	
	local spellCount = #Legacy.Data.Env.Reputation.Spell;
	if (Legacy.Var.Nav.Page.Reputation.Spell > 0) then
		Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_PREV].more = true;
		Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_PREV].more = false;
		Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	if ((Legacy.Var.Nav.Page.Reputation.Spell+1)*LEGACY_MAX_REPUTATION_SPELL_PER_PAGE >= spellCount) then
		Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
end

function LegacyPanel_OnLoadReputationNavToken(self)
	LegacyPanel_InitToken(self);
    self.Title:Hide();
    self.Desc:Hide();
	self.Icon:SetTexture(LEGACY_NAV_ARROW[self.Id]);
end

function LegacyPanel_OnEnterReputationNavToken(self, motion)
end

function LegacyPanel_OnLeaveReputationNavToken(self, motion)
end

function LegacyPanel_OnClickReputationNavToken(self, button, down)
	if (button == "LeftButton") then
		if (self.more) then
			if (self.Type == LEGACY_REPUTATION_TYPE_REWARD) then
				if (self.Id == LEGACY_NAV_PREV) then
					Legacy.Var.Nav.Page.Reputation.Reward = Legacy.Var.Nav.Page.Reputation.Reward - 1;
				else
					Legacy.Var.Nav.Page.Reputation.Reward = Legacy.Var.Nav.Page.Reputation.Reward + 1;
				end
			elseif (self.Type == LEGACY_REPUTATION_TYPE_ITEM) then
				if (self.Id == LEGACY_NAV_PREV) then
					Legacy.Var.Nav.Page.Reputation.Item = Legacy.Var.Nav.Page.Reputation.Item - 1;
				else
					Legacy.Var.Nav.Page.Reputation.Item = Legacy.Var.Nav.Page.Reputation.Item + 1;
				end
			elseif (self.Type == LEGACY_REPUTATION_TYPE_SPELL) then
				if (self.Id == LEGACY_NAV_PREV) then
					Legacy.Var.Nav.Page.Reputation.Spell = Legacy.Var.Nav.Page.Reputation.Spell - 1;
				else
					Legacy.Var.Nav.Page.Reputation.Spell = Legacy.Var.Nav.Page.Reputation.Spell + 1;
				end
			end
			
			LegacyPanel_UpdateReputation();
			LegacyPanel_UpdateReputationNavState();
		end
	end
end

function LegacyPanel_UpdateReputationRank()
	Legacy.UI.Home.Nav[LEGACY_PAGE_REPUTATION].Desc:SetText(Legacy.Data.Account.Rank);
end