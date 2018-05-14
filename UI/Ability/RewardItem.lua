function LegacyPanel_OnLoadRewardItem(self)
	LegacyPanel_InitializeAbilityItem(self);
    self.title:Hide();
    self.desc:Hide();
	LegacyPanel.RewardItem[self.id] = self;
	
	if (self.id <= LEGACY_MAX_REWARD_PER_PAGE) then
		self._type = LEGACY_REPUTATION_REWARD;
		self.border:SetVertexColor(0.5, 1, 1, 1);
	elseif (self.id <= LEGACY_MAX_REWARD_PER_PAGE + LEGACY_MAX_REPUTATION_ITEM_PER_PAGE) then
		self._type = LEGACY_REPUTATION_ITEM;
	elseif (self.id <= LEGACY_MAX_REWARD_PER_PAGE + LEGACY_MAX_REPUTATION_ITEM_PER_PAGE + LEGACY_MAX_REPUTATION_SPELL_PER_PAGE) then
		self._type = LEGACY_REPUTATION_SPELL;
	end
end

function LegacyPanel_OnEnterRewardItem(self, motion)
	self.highlight:SetVertexColor(0, 1, 0, 1);
    self.highlight:Show();
	if (self._type == LEGACY_REPUTATION_REWARD) then
		local rewardItem = Legacy_GetRewardItemByPos(self.id);
		if (rewardItem ~= nil) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
			GameTooltip:SetHyperlink("item:"..rewardItem.entry);
			GameTooltip:Show();
		end
	elseif (self._type == LEGACY_REPUTATION_ITEM) then
		local repItem = Legacy_GetReputationItemByPos(self.id);
		if (repItem ~= nil) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
			GameTooltip:SetHyperlink("item:"..repItem.e);
			GameTooltip:AddDoubleLine(LEGACY_COMMUNITY_REPUTATION, format(LEGACY_MARKET_REPUTATION_REWARD, repItem.r));
			local p = _G[GameTooltip:GetName().."TextRight1"];
			if (repItem.r <= Legacy.Data.Account.Level) then
				if (repItem.s) then
					p:SetText(LEGACY_MARKET_REPUTATION_REWARDED);
				else
					p:SetText(LEGACY_MARKET_REPUTATION_REWARDED_PERIODIC);
				end
			else
				if (repItem.s) then
					p:SetText(LEGACY_MARKET_REPUTATION_NOT_REWARDED);
				else
					p:SetText(LEGACY_MARKET_REPUTATION_NOT_REWARDED_PERIODIC);
				end
			end
			p:Show();
			GameTooltip:Show();
		end
	elseif (self._type == LEGACY_REPUTATION_SPELL) then
		local repSpell = Legacy_GetReputationSpellByPos(self.id);
		if (repSpell ~= nil) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
			GameTooltip:SetHyperlink("spell:"..repSpell.e);
			GameTooltip:AddDoubleLine(LEGACY_COMMUNITY_REPUTATION, format(LEGACY_MARKET_REPUTATION_REWARD, repSpell.r));
			local p = _G[GameTooltip:GetName().."TextRight1"];
			if (repSpell.r <= Legacy.Data.Account.Level) then
				p:SetText(LEGACY_MARKET_REPUTATION_REWARDED);
			else
				p:SetText(LEGACY_MARKET_REPUTATION_NOT_REWARDED);
			end
			p:Show();
			GameTooltip:Show();
		end
	end
end

function LegacyPanel_OnLeaveRewardItem(self, motion)
	self.highlight:Hide();
    GameTooltip:Hide();
end

function LegacyPanel_OnClickRewardItem(self, button, down)
	if (button == "LeftButton") then
		local rewardItem = Legacy_GetRewardItemByPos(self.id);
		if (rewardItem ~= nil) then
			if (IsDressableItem(rewardItem.entry)) then
				DressUpItemLink(Legacy_GetItemLink(rewardItem.entry));
			end
		end
	elseif (button == "RightButton" and self._type == LEGACY_REPUTATION_REWARD) then
		local rewardItem = Legacy_GetRewardItemByPos(self.id);
		if (rewardItem ~= nil) then
			LegacyPanel_FetchRewardItem(rewardItem.entry, rewardItem._type);
		end
	end	
end

function LegacyPanel_FetchRewardItem(entry, _type)
	Legacy_DoQuery(LMSG_Q_COLLECT_REWARD, entry..":".._type);
end

function LegacyPanel_UpdateRewardItems()
	for i = 1, LEGACY_MAX_REWARD_PER_PAGE do
		local item = LegacyPanel.RewardItem[i];
		local rewardItem = Legacy_GetRewardItemByPos(i);
		if (rewardItem ~= nil) then
			item.icon:SetTexture(GetItemIcon(rewardItem.entry));
			item.desc:SetText(rewardItem.count);
			if (rewardItem._type == 1) then
				item.desc:SetTextColor(1, 0, 1, 1); -- account shared
			elseif (rewardItem._type == 2) then -- account reward
				item.desc:SetTextColor(0, 1, 1, 1);
			elseif (rewardItem._type == 3) then -- character reward
				item.desc:SetTextColor(1, 1, 0, 1);
			end
			item.desc:Show();
			item:Show();
		else
			item:Hide();
		end
	end
	
	for i = LEGACY_MAX_REWARD_PER_PAGE + 1, LEGACY_MAX_REWARD_PER_PAGE + LEGACY_MAX_REPUTATION_ITEM_PER_PAGE do
		local item = LegacyPanel.RewardItem[i];
		local repItem = Legacy_GetReputationItemByPos(i);
		if (repItem ~= nil) then
			item.icon:SetTexture(GetItemIcon(repItem.e));
			item:Show();
			item.desc:SetText(format(LEGACY_MARKET_REPUTATION_RANK_FORMAT, repItem.r));
			item.desc:Show();
			if (repItem.r <= Legacy.Data.Account.Level) then
				item.icon:SetDesaturated(false);
				if (repItem.s) then
					item.border:SetVertexColor(1, 1, 0.5, 1);
				else
					item.border:SetVertexColor(1, 0.75, 0.75, 1);
				end
			else
				item.icon:SetDesaturated(true);
				item.border:SetVertexColor(0.5, 0.5, 0.5);
			end
		else
			item:Hide();
		end
	end
	
	for i = LEGACY_MAX_REWARD_PER_PAGE + LEGACY_MAX_REPUTATION_ITEM_PER_PAGE + 1, LEGACY_MAX_REWARD_PER_PAGE + LEGACY_MAX_REPUTATION_ITEM_PER_PAGE + LEGACY_MAX_REPUTATION_SPELL_PER_PAGE do
		local item = LegacyPanel.RewardItem[i];
		local repSpell = Legacy_GetReputationSpellByPos(i);
		if (repSpell ~= nil) then
			item.icon:SetTexture(Legacy_GetSpellIcon(repSpell.e));
			if (not LegacyPanel_MarketSpellPossessed(repSpell.e)) then
				item.border:SetVertexColor(0.5, 0.5, 0.5, 1);
				item.icon:SetDesaturated(true);
			end
			item:Show();
			item.desc:SetText(format(LEGACY_MARKET_REPUTATION_RANK_FORMAT, repSpell.r));
			item.desc:Show();
			if (repSpell.r <= Legacy.Data.Account.Level) then
				item.icon:SetDesaturated(false);
				item.border:SetVertexColor(1, 0.5, 1, 1);
			else
				item.icon:SetDesaturated(true);
				item.border:SetVertexColor(0.5, 0.5, 0.5);
			end
		else
			item:Hide();
		end
	end
	
	LegacyPanel_UpdateRewardNavState();
end

function LegacyPanel_UpdateRewardNavState()
	local itemCount = #Legacy.Data.RewardItems;
	if (LegacyPanel.RewardItemPage > 0) then
		LegacyPanel.RewardItemNavButton[1].icon:SetDesaturated(false);
	else
		LegacyPanel.RewardItemNavButton[1].icon:SetDesaturated(true);
	end
	if (LegacyPanel.RewardItemPage * LEGACY_MAX_REWARD_PER_PAGE + LEGACY_MAX_REWARD_PER_PAGE >= itemCount) then
		LegacyPanel.RewardItemNavButton[2].icon:SetDesaturated(true);
	else
		LegacyPanel.RewardItemNavButton[2].icon:SetDesaturated(false);
	end
	
	local repItemCount = #Legacy.Data.ReputationItems;
	if (LegacyPanel.ReputationItemPage > 0) then
		LegacyPanel.ReputationItemNavButton[1].icon:SetDesaturated(false);
	else
		LegacyPanel.ReputationItemNavButton[1].icon:SetDesaturated(true);
	end
	if (LegacyPanel.ReputationItemPage * LEGACY_MAX_REPUTATION_ITEM_PER_PAGE + LEGACY_MAX_REPUTATION_ITEM_PER_PAGE >= repItemCount) then
		LegacyPanel.ReputationItemNavButton[2].icon:SetDesaturated(true);
	else
		LegacyPanel.ReputationItemNavButton[2].icon:SetDesaturated(false);
	end
	
	local repSpellCount = #Legacy.Data.ReputationSpells;
	if (LegacyPanel.ReputationSpellPage > 0) then
		LegacyPanel.ReputationSpellNavButton[1].icon:SetDesaturated(false);
	else
		LegacyPanel.ReputationSpellNavButton[1].icon:SetDesaturated(true);
	end
	if (LegacyPanel.ReputationSpellPage * LEGACY_MAX_REPUTATION_SPELL_PER_PAGE + LEGACY_MAX_REPUTATION_SPELL_PER_PAGE >= repSpellCount) then
		LegacyPanel.ReputationSpellNavButton[2].icon:SetDesaturated(true);
	else
		LegacyPanel.ReputationSpellNavButton[2].icon:SetDesaturated(false);
	end
end

function LegacyPanel_OnLoadRewardNavButtonItem(self)
	LegacyPanel_InitializeAbilityItem(self);
    self.title:Hide();
    self.desc:Hide();
	if (self.id <= 2) then
		self.icon:SetTexture(LEGACY_NAV_ARROW[self.id]);
		self.border:SetVertexColor(0.5, 1, 1, 1);
		LegacyPanel.RewardItemNavButton[self.id] = self;
	elseif (self.id <= 4) then
		self.icon:SetTexture(LEGACY_NAV_ARROW[self.id - 2]);
		self.border:SetVertexColor(1, 1, 0.5, 1);
		LegacyPanel.ReputationItemNavButton[self.id - 2] = self;
	elseif (self.id <= 6) then
		self.icon:SetTexture(LEGACY_NAV_ARROW[self.id - 4]);
		self.border:SetVertexColor(1, 0.5, 1, 1);
		LegacyPanel.ReputationSpellNavButton[self.id - 4] = self;
	end
end

function LegacyPanel_OnEnterRewardNavButtonItem(self, motion)
end

function LegacyPanel_OnLeaveRewardNavButtonItem(self, motion)
end

function LegacyPanel_OnClickRewardNavButtonItem(self, button, down)
	local itemCount = #Legacy.Data.RewardItems;
	local repItemCount = #Legacy.Data.ReputationItems;
	local repSpellCount = #Legacy.Data.ReputationSpells;
	if (self.id == 1) then
		if (LegacyPanel.RewardItemPage > 0) then
			LegacyPanel.RewardItemPage = LegacyPanel.RewardItemPage - 1;
			LegacyPanel_UpdateRewardItems();
		end
	elseif (self.id == 2) then
		if (LegacyPanel.RewardItemPage * LEGACY_MAX_REWARD_PER_PAGE + LEGACY_MAX_REWARD_PER_PAGE < itemCount) then
			LegacyPanel.RewardItemPage = LegacyPanel.RewardItemPage + 1;
			LegacyPanel_UpdateRewardItems();
		end
	elseif (self.id == 3) then
		if (LegacyPanel.ReputationItemPage > 0) then
			LegacyPanel.ReputationItemPage = LegacyPanel.ReputationItemPage - 1;
			LegacyPanel_UpdateRewardItems();
		end
	elseif (self.id == 4) then
		if (LegacyPanel.ReputationItemPage * LEGACY_MAX_REPUTATION_ITEM_PER_PAGE + LEGACY_MAX_REPUTATION_ITEM_PER_PAGE < repItemCount) then
			LegacyPanel.ReputationItemPage = LegacyPanel.ReputationItemPage + 1;
			LegacyPanel_UpdateRewardItems();
		end
	elseif (self.id == 5) then
		if (LegacyPanel.ReputationSpellPage > 0) then
			LegacyPanel.ReputationSpellPage = LegacyPanel.ReputationSpellPage - 1;
			LegacyPanel_UpdateRewardItems();
		end
	elseif (self.id == 6) then
		if (LegacyPanel.ReputationSpellPage * LEGACY_MAX_REPUTATION_SPELL_PER_PAGE + LEGACY_MAX_REPUTATION_SPELL_PER_PAGE < repSpellCount) then
			LegacyPanel.ReputationSpellPage = LegacyPanel.ReputationSpellPage + 1;
			LegacyPanel_UpdateRewardItems();
		end
	end
end

function LegacyPanel_UpdateAccountInfo()
	-- display currency at market tab
	LegacyPanel.Nav[5].desc:SetText("|cff00ff00"..Legacy.Data.Account.Currency.."|r");
	LegacyPanel.Nav[6].desc:SetText(Legacy.Data.Account.Level);
	LegacyPanel.MarketItem[23].desc:SetText(Legacy.Data.Account.Currency);
end
