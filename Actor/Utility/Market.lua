function Legacy_GetGoldFromMoney(money)
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD));
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
	local copper = mod(money, COPPER_PER_SILVER);
	copper = floor(copper);
	return gold, silver, copper;
end

function Legacy_CalculateGoldAmount(currency)
	return currency * math.pow(currency, 0.0625) * COPPER_PER_SILVER * SILVER_PER_GOLD * Legacy.Data.Env.GoldRatio;
end

function LegacyPanel_OwnedMarketSpell(entry)
	return Legacy.Data.Character.Market.Spell[entry] == true;
end

function LegacyPanel_OwnedMarketBuff(entry)
	return false;
end

function Legacy_CalcDiscount(price, discount)
	return price * (100 - discount) / 100;
end

function LegacyPanel_FetchRewardItem(entry, slot)
	Legacy_DoQuery(LMSG_A_COLLECT_REWARD, entry..":"..slot);
end

function LegacyPanel_UpdateAccountInfo()
	-- display currency at market tab
	Legacy.UI.Home.Nav[5].Desc:SetText("|cff00ff00"..Legacy.Data.Account.Currency.."|r");
	Legacy.UI.Home.Nav[6].Desc:SetText(Legacy.Data.Account.Rank);
end

function LegacyPanel_FetchMarketItem(entry)
	Legacy_DoQuery(LMSG_A_FETCH_MARKET_ITEM, entry);
end

function LegacyPanel_FetchMarketSpell(entry)
	Legacy_DoQuery(LMSG_A_FETCH_MARKET_SPELL, entry);
end
