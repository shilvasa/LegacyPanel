function LegacyPanel_OnLoadMarketToken(self)
	LegacyPanel_InitToken(self);
	self.entry = 0;
    self.Title:Hide();
    self.Desc:Hide();
end

function LegacyPanel_OnEnterMarketToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
    self.Highlight:Show();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.Type == LEGACY_MARKET_TYPE_ITEM) then
		if (self.entry ~= 0) then
			GameTooltip:SetHyperlink("item:"..self.entry);				
		end
		GameTooltip:AddDoubleLine(LEGACY_MARKET_PRICE, format(LEGACY_MARKET_PRICE_FORMAT, self.data.price));
		if (self.data.discount > 0) then
			GameTooltip:AddDoubleLine(LEGACY_MARKET_EVENT_PRICE, format(LEGACY_MARKET_DISCOUNT_FORMAT, Legacy_CalcDiscount(self.data.price, self.data.discount), self.data.discount));
		end
		GameTooltip:AddDoubleLine(LEGACY_RIGHT_CLICK, LEGACY_MARKET_FETCH);
	elseif (self.Type == LEGACY_MARKET_TYPE_BUFF) then
		if (self.entry ~= 0) then
			GameTooltip:SetHyperlink("spell:"..self.entry);
			local p = _G[GameTooltip:GetName().."TextRight1"];
			p:Show();
			if (LegacyPanel_OwnedMarketBuff(self.entry)) then
				p:SetText(format(LEGACY_MARKET_BUFF_POSSESSED, Legacy_ConvertSecToDay(Legacy.Data.Character.Market.Buff[self.entry] - time())));
			else
				p:SetText(LEGACY_MARKET_BUFF_NOT_POSSESSED);
			end
			GameTooltip:AddDoubleLine(LEGACY_MARKET_PRICE, format(LEGACY_MARKET_PRICE_FORMAT, self.data.price));
			if (self.data.discount > 0) then
				GameTooltip:AddDoubleLine(LEGACY_MARKET_EVENT_PRICE, format(LEGACY_MARKET_DISCOUNT_FORMAT, Legacy_CalcDiscount(self.data.price, self.data.discount), self.data.discount));
			end
			GameTooltip:AddDoubleLine(LEGACY_RIGHT_CLICK, format(LEGACY_MARKET_BUFF_ADDTIME, Legacy_ConvertSecToDay(self.data.length)));
		end
	elseif (self.Type == LEGACY_MARKET_TYPE_SPELL) then
		if (self.entry ~= 0) then
			GameTooltip:SetHyperlink("spell:"..self.entry);
			local p = _G[GameTooltip:GetName().."TextRight1"];
			GameTooltip:AddDoubleLine(LEGACY_MARKET_PRICE, format(LEGACY_MARKET_PRICE_FORMAT, self.data.price));
			if (self.data.discount > 0) then
				GameTooltip:AddDoubleLine(LEGACY_MARKET_EVENT_PRICE, format(LEGACY_MARKET_DISCOUNT_FORMAT, Legacy_CalcDiscount(self.data.price, self.data.discount), self.data.discount));
			end
			if (LegacyPanel_OwnedMarketSpell(self.entry)) then
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

function LegacyPanel_OnLeaveMarketToken(self, motion)
	self.Highlight:Hide();
    GameTooltip:Hide();
end

function LegacyPanel_OnClickMarketToken(self, button, down)
	if (button == "LeftButton") then
		if (self.Type == LEGACY_MARKET_TYPE_ITEM) then
			if (self.entry ~= 0) then
				if (IsDressableItem(self.entry)) then
					DressUpItemLink(Legacy_GetItemLink(self.entry));
				end
			end
		end
	elseif (button == "RightButton") then
		if (self.Type == LEGACY_MARKET_TYPE_ITEM) then
			if (self.entry ~= 0) then
				local price = Legacy_CalcDiscount(self.data.price, self.data.discount);
				local link = Legacy_GetItemLink(self.entry);
				local popup = StaticPopup_Show("LEGACY_FETCH_MARKET_ITEM_CONFIRM", link, price);
				popup.entry = self.entry;
				popup.price = price;
			end
		elseif (self.Type == LEGACY_MARKET_TYPE_SPELL) then
			if (self.entry ~= 0 and not LegacyPanel_OwnedMarketSpell(self.entry)) then
				local price = Legacy_CalcDiscount(self.data.price, self.data.discount);
				local link = "["..Legacy_GetSpellName(self.entry).."]";
				local popup = StaticPopup_Show("LEGACY_FETCH_MARKET_SPELL_CONFIRM", link, price);
				popup.entry = self.entry;
				popup.price = price;
			end
		elseif (self.Type == LEGACY_MARKET_TYPE_BUFF) then
			if (self.entry ~= 0) then
				local price = Legacy_CalcDiscount(self.data.price, self.data.discount);
				local link = "["..Legacy_GetSpellName(self.entry).."]";
				local str = format(LEGACY_MARKET_BUFF_BUY_CONFIRM, Legacy_ConvertSecToDay(self.data.length), link, price);
				local popup = StaticPopup_Show("LEGACY_FETCH_MARKET_BUFF_CONFIRM", str);
				popup.entry = self.entry;
			end
		end
	end	
end

function LegacyPanel_UpdateMarket()
	for i = 1, LEGACY_MAX_MARKET_ITEM_PER_PAGE do
		local token = Legacy.UI.Market.Item[i];
		local item = Legacy.Data.Env.Market.Item[i+Legacy.Var.Nav.Page.Market.Item*LEGACY_MAX_MARKET_ITEM_PER_PAGE];
		token.data = item;
		if (item ~= nil) then
			token.entry = item.entry;
			local price = Legacy_CalcDiscount(item.price, item.discount);
			if (item.discount == 0) then
				token.Desc:SetText(item.price);
			else
				token.Desc:SetText("|cff00ff00"..price.."|r");
			end
			token.Desc:Show();
			token.Icon:SetTexture(GetItemIcon(item.entry));
			token.Border:SetVertexColor(1, 1, 0.5, 1);
			token:Show();
		else
			token.entry = 0;
			token:Hide();
		end
	end
	
	for i = 1, LEGACY_MAX_MARKET_BUFF_PER_PAGE do
		local token = Legacy.UI.Market.Buff[i];
		local buff = Legacy.Data.Env.Market.Buff[i+Legacy.Var.Nav.Page.Market.Buff*LEGACY_MAX_MARKET_BUFF_PER_PAGE];
		token.data = buff;
		if (buff ~= nil) then
			token.entry = buff.entry;
			token:Show();
			token.Icon:SetTexture(Legacy_GetSpellIcon(buff.entry));
			token.Border:SetVertexColor(0.5, 0.5, 1, 1);
			token.Icon:SetDesaturated(false);
			if (not LegacyPanel_OwnedMarketBuff(buff.entry)) then
				token.Border:SetVertexColor(0.5, 0.5, 0.5, 1);
				token.Icon:SetDesaturated(true);
			end
			local price = Legacy_CalcDiscount(buff.price, buff.discount);
			token.Desc:Show();
			if (buff.discount == 0) then
				token.Desc:SetText(buff.price);
			else
				token.Desc:SetText("|cff00ff00"..price.."|r");
			end
		else
			token.entry = 0;
			token:Hide();
		end
	end
	
	for i = 1, LEGACY_MAX_MARKET_SPELL_PER_PAGE do
		local token = Legacy.UI.Market.Spell[i];
		local spell = Legacy.Data.Env.Market.Spell[i+Legacy.Var.Nav.Page.Market.Spell*LEGACY_MAX_MARKET_SPELL_PER_PAGE];
		token.data = spell;
		if (spell ~= nil) then
			token.entry = spell.entry;
			local price = Legacy_CalcDiscount(spell.price, spell.discount);
			if (spell.discount == 0) then
				token.Desc:SetText(spell.price);
			else
				token.Desc:SetText("|cff00ff00"..price.."|r");
			end
			token.Desc:Show();
			token.Border:SetVertexColor(1, 0.5, 1, 1);
			token.Icon:SetDesaturated(false);
			token.Icon:SetTexture(Legacy_GetSpellIcon(spell.entry));
			if (not LegacyPanel_OwnedMarketSpell(spell.entry)) then
				token.Border:SetVertexColor(0.5, 0.5, 0.5, 1);
				token.Icon:SetDesaturated(true);
			end
			token:Show();
		else
			token.entry = 0;
			token:Hide();
		end
	end
end

function LegacyPanel_UpdateMarketNavState()
	local itemCount = #Legacy.Data.Env.Market.Item;
	if (Legacy.Var.Nav.Page.Market.Item > 0) then
		Legacy.UI.Market.Nav.Item[LEGACY_NAV_PREV].more = true;
		Legacy.UI.Market.Nav.Item[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.Market.Nav.Item[LEGACY_NAV_PREV].more = false;
		Legacy.UI.Market.Nav.Item[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	if ((Legacy.Var.Nav.Page.Market.Item+1)*LEGACY_MAX_MARKET_ITEM_PER_PAGE >= itemCount) then
		Legacy.UI.Market.Nav.Item[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.Market.Nav.Item[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.Market.Nav.Item[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.Market.Nav.Item[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
	
	local buffCount = #Legacy.Data.Env.Market.Buff;
	if (Legacy.Var.Nav.Page.Market.Buff > 0) then
		Legacy.UI.Market.Nav.Buff[LEGACY_NAV_PREV].more = true;
		Legacy.UI.Market.Nav.Buff[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.Market.Nav.Buff[LEGACY_NAV_PREV].more = false;
		Legacy.UI.Market.Nav.Buff[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	if ((Legacy.Var.Nav.Page.Market.Buff+1)*LEGACY_MAX_MARKET_BUFF_PER_PAGE >= buffCount) then
		Legacy.UI.Market.Nav.Buff[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.Market.Nav.Buff[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.Market.Nav.Buff[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.Market.Nav.Buff[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
	
	local spellCount = #Legacy.Data.Env.Market.Spell;
	if (Legacy.Var.Nav.Page.Market.Spell > 0) then
		Legacy.UI.Market.Nav.Spell[LEGACY_NAV_PREV].more = true;
		Legacy.UI.Market.Nav.Spell[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.Market.Nav.Spell[LEGACY_NAV_PREV].more = false;
		Legacy.UI.Market.Nav.Spell[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	if ((Legacy.Var.Nav.Page.Market.Spell+1)*LEGACY_MAX_MARKET_SPELL_PER_PAGE >= spellCount) then
		Legacy.UI.Market.Nav.Spell[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.Market.Nav.Spell[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.Market.Nav.Spell[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.Market.Nav.Spell[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
end

function LegacyPanel_OnLoadMarketNavToken(self)
	LegacyPanel_InitToken(self);
    self.Title:Hide();
    self.Desc:Hide();
	self.Icon:SetTexture(LEGACY_NAV_ARROW[self.Id]);
end

function LegacyPanel_OnEnterMarketNavToken(self, motion)
end

function LegacyPanel_OnLeaveMarketNavToken(self, motion)
end

function LegacyPanel_OnClickMarketNavToken(self, button, down)
	if (self.more) then
		if (self.Type == LEGACY_MARKET_TYPE_ITEM) then
			if (self.Id == LEGACY_NAV_PREV) then
				Legacy.Var.Nav.Page.Market.Item = Legacy.Var.Nav.Page.Market.Item - 1;
			else
				Legacy.Var.Nav.Page.Market.Item = Legacy.Var.Nav.Page.Market.Item + 1;
			end
		elseif (self.Type == LEGACY_MARKET_TYPE_BUFF) then
			if (self.Id == LEGACY_NAV_PREV) then
				Legacy.Var.Nav.Page.Market.Buff = Legacy.Var.Nav.Page.Market.Buff - 1;
			else
				Legacy.Var.Nav.Page.Market.Buff = Legacy.Var.Nav.Page.Market.Buff + 1;
			end
		elseif (self.Type == LEGACY_MARKET_TYPE_SPELL) then
			if (self.Id == LEGACY_NAV_PREV) then
				Legacy.Var.Nav.Page.Market.Spell = Legacy.Var.Nav.Page.Market.Spell - 1;
			else
				Legacy.Var.Nav.Page.Market.Spell = Legacy.Var.Nav.Page.Market.Spell + 1;
			end
		end
	end
	
	LegacyPanel_UpdateMarket();
	LegacyPanel_UpdateMarketNavState();
end

function LegacyPanel_UpdateGoldRatio()
end
