function LegacyPanel_OnLoadMarketItem(self)
	LegacyPanel_InitializeAbilityItem(self);
    self.title:Hide();
    self.desc:Hide();
	if (self.id <= LEGACY_MAX_MARKET_ITEM_PER_PAGE) then
		self._type = LEGACY_MARKET_ITEM_TYPE_ITEM;
	elseif (self.id <= LEGACY_MAX_MARKET_ITEM_PER_PAGE + LEGACY_MAX_MARKET_BUFF_PER_PAGE) then
		self._type = LEGACY_MARKET_ITEM_TYPE_BUFF;
	elseif (self.id <= LEGACY_MAX_MARKET_ITEM_PER_PAGE + LEGACY_MAX_MARKET_BUFF_PER_PAGE + LEGACY_MAX_MARKET_SPELL_PER_PAGE) then
		self._type = LEGACY_MARKET_ITEM_TYPE_SPELL;
	end
	LegacyPanel.MarketItem[self.id] = self;
end

function LegacyPanel_OnEnterMarketItem(self, motion)
	self.highlight:SetVertexColor(0, 1, 0, 1);
    self.highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self._type == LEGACY_MARKET_ITEM_TYPE_ITEM) then
		local marketItem = Legacy_GetMarketItemByPos(self.id);
		if (marketItem ~= nil) then
			GameTooltip:SetHyperlink("item:"..marketItem.entry);				
		end
		GameTooltip:AddDoubleLine(LEGACY_MARKET_PRICE, format(LEGACY_MARKET_PRICE_FORMAT, marketItem.price));
		if (marketItem.discount > 0) then
			GameTooltip:AddDoubleLine(LEGACY_MARKET_EVENT_PRICE, format(LEGACY_MARKET_DISCOUNT_FORMAT, Legacy_CalcDiscount(marketItem.price, marketItem.discount), marketItem.discount));
		end
		GameTooltip:AddDoubleLine(LEGACY_RIGHT_CLICK, LEGACY_MARKET_FETCH);
		--[[
	elseif (self._type == LEGACY_MARKET_ITEM_TYPE_GOLD) then
		if (self.id == LEGACY_MAX_MARKET_ITEM_PER_PAGE + 12) then
			GameTooltip:AddLine(LEGACY_CURRENCY_TO_GOLD);
			GameTooltip:AddLine(LEGACY_CURRENT_RATIO);
			local money = Legacy_CalculateGoldAmount(Legacy.Data.Account.Currency);
			local g, s, c = Legacy_GetGoldFromMoney(money);
			GameTooltip:AddLine(format(LEGACY_CURRENCY_TO_GOLD_RATIO, Legacy.Data.Account.Currency, g, s, c));
		else
			GameTooltip:AddLine(format(LEGACY_BUY_GOLD_AMOUNT_TITLE, self.amount));
			GameTooltip:AddLine(LEGACY_CURRENT_RATIO);
			local money = Legacy_CalculateGoldAmount(self.amount);
			local g, s, c = Legacy_GetGoldFromMoney(money);
			GameTooltip:AddLine(format(LEGACY_CURRENCY_TO_GOLD_RATIO, self.amount, g, s, c));
		end
		]]--
	elseif (self._type == LEGACY_MARKET_ITEM_TYPE_BUFF) then
		local buff = Legacy.Data.MarketBuffs[self.id - LEGACY_MAX_MARKET_ITEM_PER_PAGE];
		if (buff ~= nil) then
			GameTooltip:SetHyperlink("spell:"..buff.entry);
			local p = _G[GameTooltip:GetName().."TextRight1"];
			p:Show();
			if (LegacyPanel_MarketBuffPossessed(buff.entry)) then
				p:SetText(format(LEGACY_MARKET_BUFF_POSSESSED, Legacy_ConvertSecToDay(Legacy.Data.PossessedMarketBuffs[buff.entry] - time())));
			else
				p:SetText(LEGACY_MARKET_BUFF_NOT_POSSESSED);
			end
			GameTooltip:AddDoubleLine(LEGACY_MARKET_PRICE, format(LEGACY_MARKET_PRICE_FORMAT, buff.price));
			if (buff.discount > 0) then
				GameTooltip:AddDoubleLine(LEGACY_MARKET_EVENT_PRICE, format(LEGACY_MARKET_DISCOUNT_FORMAT, Legacy_CalcDiscount(buff.price, buff.discount), buff.discount));
			end
			GameTooltip:AddDoubleLine(LEGACY_RIGHT_CLICK, format(LEGACY_MARKET_BUFF_ADDTIME, Legacy_ConvertSecToDay(buff.length)));
		end
	elseif (self._type == LEGACY_MARKET_ITEM_TYPE_SPELL) then
		local marketSpell = Legacy_GetMarketSpellByPos(self.id);
		if (marketSpell ~= nil) then
			GameTooltip:SetHyperlink("spell:"..marketSpell.entry);
			local p = _G[GameTooltip:GetName().."TextRight1"];
			GameTooltip:AddDoubleLine(LEGACY_MARKET_PRICE, format(LEGACY_MARKET_PRICE_FORMAT, marketSpell.price));
			if (marketSpell.discount > 0) then
				GameTooltip:AddDoubleLine(LEGACY_MARKET_EVENT_PRICE, format(LEGACY_MARKET_DISCOUNT_FORMAT, Legacy_CalcDiscount(marketSpell.price, marketSpell.discount), marketSpell.discount));
			end
			if (LegacyPanel_MarketSpellPossessed(marketSpell.entry)) then
				p:SetText(LEGACY_MARKET_SPELL_POSSESSED);
			else
				p:SetText(LEGACY_MARKET_SPELL_NOT_POSSESSED);
				GameTooltip:AddDoubleLine(LEGACY_RIGHT_CLICK, LEGACY_MARKET_FETCH);
			end
			p:Show();
		end
	end
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveMarketItem(self, motion)
	self.highlight:Hide();
    GameTooltip:Hide();
end

function LegacyPanel_OnClickMarketItem(self, button, down)
	if (button == "LeftButton") then
		if (self._type == LEGACY_MARKET_ITEM_TYPE_ITEM) then
			local marketItem = Legacy_GetMarketItemByPos(self.id);
			if (marketItem ~= nil) then
				if (IsDressableItem(marketItem.entry)) then
					DressUpItemLink(Legacy_GetItemLink(marketItem.entry));
				end
			end
		end
	elseif (button == "RightButton") then
		if (self._type == LEGACY_MARKET_ITEM_TYPE_ITEM) then
			local marketItem = Legacy_GetMarketItemByPos(self.id);
			if (marketItem ~= nil) then
				local price = Legacy_CalcDiscount(marketItem.price, marketItem.discount);
				local link = Legacy_GetItemLink(marketItem.entry);
				local popup = StaticPopup_Show("LEGACY_FETCH_MARKET_ITEM_CONFIRM", link, price);
				popup.entry = marketItem.entry;
				popup.price = price;
			end
		elseif (self._type == LEGACY_MARKET_ITEM_TYPE_SPELL) then
			local marketSpell = Legacy_GetMarketSpellByPos(self.id);
			if (marketSpell ~= nil and not LegacyPanel_MarketSpellPossessed(marketSpell.entry)) then
				local price = Legacy_CalcDiscount(marketSpell.price, marketSpell.discount);
				local link = "["..Legacy_GetSpellName(marketSpell.entry).."]";
				local popup = StaticPopup_Show("LEGACY_FETCH_MARKET_SPELL_CONFIRM", link, price);
				popup.entry = marketSpell.entry;
				popup.price = price;
			end
			--[[
		elseif (self._type == LEGACY_MARKET_ITEM_TYPE_GOLD) then
			local amount = self.amount;
			if (self.id == 23) then amount = Legacy.Data.Account.Currency; end
			local g, s, c = Legacy_GetGoldFromMoney(Legacy_CalculateGoldAmount(amount));
			local fmt = g..LEGACY_MONEY_GOLD_ICON.." "..s..LEGACY_MONEY_SILVER_ICON.." "..c..LEGACY_MONEY_COPPER_ICON;
			local popup = StaticPopup_Show("LEGACY_BUY_GOLD_CONFIRM", amount, fmt);
			popup.amount = amount;
		end
			]]--
		elseif (self._type == LEGACY_MARKET_ITEM_TYPE_BUFF) then
			local buff = Legacy.Data.MarketBuffs[self.id - LEGACY_MAX_MARKET_SPELL_PER_PAGE];
			if (buff ~= nil) then
				local price = Legacy_CalcDiscount(buff.price, buff.discount);
				local link = "["..Legacy_GetSpellName(buff.entry).."]";
				local str = format(LEGACY_MARKET_BUFF_BUY_CONFIRM, Legacy_ConvertSecToDay(buff.length), link, price);
				local popup = StaticPopup_Show("LEGACY_FETCH_MARKET_BUFF_CONFIRM", str);
				popup.entry = buff.entry;
			end
		end
	end	
end

function LegacyPanel_FetchMarketItem(entry)
	Legacy_DoQuery(LMSG_A_FETCH_MARKET_ITEM, entry);
end

function LegacyPanel_FetchMarketSpell(entry)
	Legacy_DoQuery(LMSG_A_FETCH_MARKET_SPELL, entry);
end

function LegacyPanel_UpdateMarketItems()
	for i = 1, LEGACY_MAX_MARKET_ITEM_PER_PAGE do
		local item = LegacyPanel.MarketItem[i];
		local marketItem = Legacy_GetMarketItemByPos(i);
		if (marketItem ~= nil) then
			local price = Legacy_CalcDiscount(marketItem.price, marketItem.discount);
			if (marketItem.discount == 0) then
				item.desc:SetText(marketItem.price);
			else
				item.desc:SetText("|cff00ff00"..price.."|r");
			end
			item.desc:Show();
			item.icon:SetTexture(GetItemIcon(marketItem.entry));
			item.border:SetVertexColor(1, 1, 0.5, 1);
			item:Show();
		else
			item:Hide();
		end
	end
	
	--[[
	for i = LEGACY_MAX_MARKET_ITEM_PER_PAGE + 1, LEGACY_MAX_MARKET_ITEM_PER_PAGE + LEGACY_MAX_MARKET_GOLD_PER_PAGE do
		local index = i - LEGACY_MAX_MARKET_ITEM_PER_PAGE;
		local amount = LegacyBuyGoldAmounts[index];
		if (index == 12) then amount = Legacy.Data.Account.Currency; end
		local item = LegacyPanel.MarketItem[i];
		item.icon:SetTexture(LEGACY_GOLD_COIN_ICON);
		item.desc:SetText(amount);
		item.desc:Show();
		item.amount = amount;
	end
	]]--
	
	for i = LEGACY_MAX_MARKET_ITEM_PER_PAGE + 1, LEGACY_MAX_MARKET_ITEM_PER_PAGE + LEGACY_MAX_MARKET_BUFF_PER_PAGE do
		local index = i - LEGACY_MAX_MARKET_ITEM_PER_PAGE;
		local item = LegacyPanel.MarketItem[i];
		local buff = Legacy.Data.MarketBuffs[index];
		if (buff ~= nil) then
			item:Show();
			item.icon:SetTexture(Legacy_GetSpellIcon(buff.entry));
			item.border:SetVertexColor(0.5, 0.5, 1, 1);
			item.icon:SetDesaturated(false);
			if (not LegacyPanel_MarketBuffPossessed(buff.entry)) then
				item.border:SetVertexColor(0.5, 0.5, 0.5, 1);
				item.icon:SetDesaturated(true);
			end
			local price = Legacy_CalcDiscount(buff.price, buff.discount);
			item.desc:Show();
			if (buff.discount == 0) then
				item.desc:SetText(buff.price);
			else
				item.desc:SetText("|cff00ff00"..price.."|r");
			end
		else
			item:Hide();
		end
	end
	
	for i = LEGACY_MAX_MARKET_ITEM_PER_PAGE + LEGACY_MAX_MARKET_BUFF_PER_PAGE + 1, LEGACY_MAX_MARKET_ITEM_PER_PAGE + LEGACY_MAX_MARKET_BUFF_PER_PAGE + LEGACY_MAX_MARKET_SPELL_PER_PAGE do
		local item = LegacyPanel.MarketItem[i];
		local marketSpell = Legacy_GetMarketSpellByPos(i);
		if (marketSpell ~= nil) then
			local price = Legacy_CalcDiscount(marketSpell.price, marketSpell.discount);
			if (marketSpell.discount == 0) then
				item.desc:SetText(marketSpell.price);
			else
				item.desc:SetText("|cff00ff00"..price.."|r");
			end
			item.desc:Show();
			item.border:SetVertexColor(1, 0.5, 1, 1);
			item.icon:SetDesaturated(false);
			item.icon:SetTexture(Legacy_GetSpellIcon(marketSpell.entry));
			if (not LegacyPanel_MarketSpellPossessed(marketSpell.entry)) then
				item.border:SetVertexColor(0.5, 0.5, 0.5, 1);
				item.icon:SetDesaturated(true);
			end
			item:Show();
		else
			item:Hide();
		end
	end
	
	-- unused
	for i = 35, 36 do
		LegacyPanel.MarketItem[i]:Hide();
	end
end

function LegacyPanel_UpdateMarketNavState()
	local itemCount = #Legacy.Data.MarketItems;
	if (LegacyPanel.MarketItemPage > 0) then
		LegacyPanel.MarketItemNavButton[1].icon:SetDesaturated(false);
	else
		LegacyPanel.MarketItemNavButton[1].icon:SetDesaturated(true);
	end
	if (LegacyPanel.MarketItemPage * LEGACY_MAX_MARKET_ITEM_PER_PAGE + LEGACY_MAX_MARKET_ITEM_PER_PAGE >= itemCount) then
		LegacyPanel.MarketItemNavButton[2].icon:SetDesaturated(true);
	else
		LegacyPanel.MarketItemNavButton[2].icon:SetDesaturated(false);
	end
	
	local spellCount = #Legacy.Data.MarketSpells;
	if (LegacyPanel.MarketSpellPage > 0) then
		LegacyPanel.MarketSpellNavButton[1].icon:SetDesaturated(false);
	else
		LegacyPanel.MarketSpellNavButton[1].icon:SetDesaturated(true);
	end
	if (LegacyPanel.MarketSpellPage * LEGACY_MAX_MARKET_SPELL_PER_PAGE + LEGACY_MAX_MARKET_SPELL_PER_PAGE >= spellCount) then
		LegacyPanel.MarketSpellNavButton[2].icon:SetDesaturated(true);
	else
		LegacyPanel.MarketSpellNavButton[2].icon:SetDesaturated(false);
	end
end

function LegacyPanel_OnLoadMarketNavButtonItem(self)
	LegacyPanel_InitializeAbilityItem(self);
    self.title:Hide();
    self.desc:Hide();
	if (self.id == 1 or self.id == 2) then
		self.icon:SetTexture(LEGACY_NAV_ARROW[self.id]);
		LegacyPanel.MarketItemNavButton[self.id] = self;
	elseif (self.id == 3 or self.id == 4) then
		self.icon:SetTexture(LEGACY_NAV_ARROW[self.id - 2]);
		LegacyPanel.MarketSpellNavButton[self.id - 2] = self;
	end
end

function LegacyPanel_OnEnterMarketNavButtonItem(self, motion)
end

function LegacyPanel_OnLeaveMarketNavButtonItem(self, motion)
end

function LegacyPanel_OnClickMarketNavButtonItem(self, button, down)
	if (self.id <= 2) then
		local itemCount = #Legacy.Data.MarketItems;
		if (self.id == 1) then
			if (LegacyPanel.MarketItemPage > 0) then
				LegacyPanel.MarketItemPage = LegacyPanel.MarketItemPage - 1;
				LegacyPanel_UpdateMarketItems();
				LegacyPanel_UpdateMarketNavState();
			end
		elseif (self.id == 2) then
			if (LegacyPanel.MarketItemPage * LEGACY_MAX_MARKET_ITEM_PER_PAGE + LEGACY_MAX_MARKET_ITEM_PER_PAGE < itemCount) then
				LegacyPanel.MarketItemPage = LegacyPanel.MarketItemPage + 1;
				LegacyPanel_UpdateMarketItems();
				LegacyPanel_UpdateMarketNavState();
			end
		end
	elseif (self.id <= 4) then
		local spellCount = #Legacy.Data.MarketSpells;
		if (self.id == 3) then
			if (LegacyPanel.MarketSpellPage > 0) then
				LegacyPanel.MarketSpellPage = LegacyPanel.MarketSpellPage - 1;
				LegacyPanel_UpdateMarketItems();
				LegacyPanel_UpdateMarketNavState();
			end
		elseif (self.id == 4) then
			if (LegacyPanel.MarketSpellPage * LEGACY_MAX_MARKET_SPELL_PER_PAGE + LEGACY_MAX_MARKET_SPELL_PER_PAGE < spellCount) then
				LegacyPanel.MarketSpellPage = LegacyPanel.MarketSpellPage + 1;
				LegacyPanel_UpdateMarketItems();
				LegacyPanel_UpdateMarketNavState();
			end
		end
	end
end

function LegacyPanel_UpdateGoldRatio()
	local tip = GameTooltip:GetOwner();
	if (tip ~= LegacyPanel.Nav[i]) then
		return;
	end
	GameTooltip:ClearLines();
	--LegacyPanel_FormatGoldRatioTooltip();
end
