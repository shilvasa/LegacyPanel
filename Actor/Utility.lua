function Legacy_Fetch(msg)
	return strsplit(":", msg);
end

function Legacy_TFetch(msg)
	return strsplit("\t", msg);
end

function Legacy_ReplaceChar(str, index, c)
	return str:sub(1, index-1)..c..str:sub(index+1);
end

function Legacy_DoQuery(header, param)
	if (param == nil) then
		param = "";
	end
    if (LEGACY_DEBUG) then
	    print("|cffff0000Sending:|r TYPE: "..header.." PARAM: "..param);
    end
	SendAddonMessage(LMSG_Q_HEADER..header, param, "GUILD");
end

function Legacy_GetAction(msg)
	local _, index = string.find(msg, LMSG_A_HEADER, 1);
	if not index then
		return 0; 
	end
	return tonumber(string.sub(msg, index + 1, string.len(msg)));
end

function Legacy_SplitToSet(msg, sep)
	local start = 1;
	local index = 1;
	local set = {};
    if (msg == nil or msg == "" or not string.find(msg, sep, start)) then
        return set;
    end
	while true do
		local lastIndex = string.find(msg, sep, start);
		if not lastIndex then
			set[index] = string.sub(msg, start, string.len(msg));
			break;
		end
		set[index] = string.sub(msg, start, lastIndex - 1);
		start = lastIndex + string.len(sep);
		index = index + 1;
	end
	return set;
end

function Legacy_GetGPCostForStat(value)
--	if (value < 1) then
--		return 1;
--	end

--	local v = floor(value / 20);
--	return 1 + 1 * v;
    return 1;
end

function Legacy_GetStatCap(level)
	return level * 10;
end

function Legacy_GetExpForLevel(level)
	level = tonumber(level);
end

function Legacy_CanLearn(spInfo)
    if (spInfo.level > UnitLevel("player")) then
        return false;
    elseif (spInfo.xp > GP["Available"]) then
        return false;
    elseif (spInfo.preqCategory1 ~= 0 and spInfo.preqRank1 ~= 0 and
        (LearnableSpells[spInfo.preqCategory1] == nil or LearnableSpells[spInfo.preqCategory1] - 1 < spInfo.preqRank1)) then
        return false;
    elseif (spInfo.preqCategory2 ~= 0 and spInfo.preqRank2 ~= 0 and
        (LearnableSpells[spInfo.preqCategory2] == nil or LearnableSpells[spInfo.preqCategory2] - 1 < spInfo.preqRank2)) then
        return false;
    elseif (spInfo.preqCategory3 ~= 0 and spInfo.preqRank3 ~= 0 and
        (LearnableSpells[spInfo.preqCategory3] == nil or LearnableSpells[spInfo.preqCategory3] - 1 < spInfo.preqRank3)) then
        return false;
    elseif (spInfo.specRank1 ~= 0 and spInfo.specRank1 > SpecRank[1]) then
        return false;
    elseif (spInfo.specRank2 ~= 0 and spInfo.specRank2 > SpecRank[2]) then
        return false;
    elseif (spInfo.specRank3 ~= 0 and spInfo.specRank3 > SpecRank[3]) then
        return false;
    else
        return true;
    end
end

function Legacy_FormatSpellModDesc(source, value)
    local d10 = format("%.1f", value/10);
    local d100 = format("%.1f", value/100);
    local d1000 = format("%.1f", value/1000);

    source = string.gsub(source, "xv", math.abs(value));
    source = string.gsub(source, "xd", math.abs(d10));
    source = string.gsub(source, "xp", math.abs(d100));
    source = string.gsub(source, "xm", math.abs(d1000));

    return source;
end

function Legacy_CalcArSeq(a, p, n)
    return a * n + (n * (n - 1) * p) / 2;
end

function Legacy_GetUnlockLevelForActiveSlot(id)
    -- if (id <= 3) then
        -- return 1;
    -- else
        -- return min((id - 3) * 10, 60);
    -- end
	return 1;
end

function Legacy_GetUnlockLevelForPassiveSlot(id)
    if (id >= 1 and id <= 6) then
		return 1;
	end
	return 1;
end

function Legacy_GetSpellIcon(spell)
    local _, _, icon, _, _, _, _ = GetSpellInfo(spell);
    return icon;
end

function Legacy_IsSpellUnlocked(spell)
    return Legacy.Data.UnlockedSpells[spell] ~= nil;
end

function Legacy_GetLevelForSpellMod(modID)
    if (Legacy.Data.UpgradedSpellMods[modID] == nil) then
        return 0;
    end
    return Legacy.Data.UpgradedSpellMods[modID];
end

function Legacy_CalcGPCost(base, step, level)
    return base + step * level;
end

function Legacy_Signal(msg)
    print(msg);
end

function Legacy_GetSpellModCost(mod)
    return mod.g + mod.p * Legacy_GetLevelForSpellMod(mod.i);
end

function Legacy_HasUpgradeForSpell(spell)
    local _, cl = UnitClass("player");
	if (SpellMods[cl] == nil) then
		return false;
	end
    if (SpellMods[cl][spell] ~= nil) then
        return true;
    end
    return false;
end

function Legacy_GetSpellMod(spell)
	local _, cl = UnitClass("player");
	return SpellMods[cl][spell];
end

function Legacy_GetUnlockLevelForTalentSlot(id)
    -- return 35 + id * 5;
	return 1;
end

function Legacy_CanActiveSpell(spell, list)
    for i = 1, #list do
        if (list[i] == spell) then
            return false;
        end
    end
    return true;
end

function Legacy_GetSpecPoint(index)
	if (index == 6) then
		return LegacyCharInfo.MF.Level;
	else
		return LegacyCharInfo.SpecialtyStats[index].Point;
	end
end

function Legacy_GetLegacyItemByPos(pos)
	return Legacy.Data.LegacyItems[LEGACY_MAX_LEGACY_ITEM_PER_PAGE*LegacyPanel.LegacyItemPage+pos];
end

function Legacy_GetMarketItemByPos(pos)
	return Legacy.Data.MarketItems[LEGACY_MAX_MARKET_ITEM_PER_PAGE*LegacyPanel.MarketItemPage+pos];
end

function Legacy_GetMarketSpellByPos(pos)
	return Legacy.Data.MarketSpells[LEGACY_MAX_MARKET_SPELL_PER_PAGE*LegacyPanel.MarketSpellPage+pos - LEGACY_MAX_MARKET_ITEM_PER_PAGE - LEGACY_MAX_MARKET_GOLD_PER_PAGE];
end

function Legacy_GetRewardItemByPos(pos)
	return Legacy.Data.RewardItems[LEGACY_MAX_REWARD_PER_PAGE*LegacyPanel.RewardItemPage+pos];
end

function Legacy_GetReputationItemByPos(pos)
	return Legacy.Data.ReputationItems[LEGACY_MAX_REPUTATION_ITEM_PER_PAGE*LegacyPanel.ReputationItemPage+pos - LEGACY_MAX_REWARD_PER_PAGE];
end

function Legacy_GetReputationSpellByPos(pos)
	return Legacy.Data.ReputationSpells[LEGACY_MAX_REPUTATION_SPELL_PER_PAGE*LegacyPanel.ReputationSpellPage+pos - LEGACY_MAX_REWARD_PER_PAGE - LEGACY_MAX_REPUTATION_ITEM_PER_PAGE];
end

function Legacy_GetItemLink(entry)
	local _, link = GetItemInfo(entry);
	return link;
end

function Legacy_GetSpellLink(entry)
	local link, _ = GetSpellLink(entry);
	return link;
end

function Legacy_GetSpellName(entry)
	local name = GetSpellInfo(entry);
	return name;
end

function Legacy_HasUnlockedSpellForTier(_type, tier)
	--if (tier == 7 or tier == 8 or tier == 9) then return false end;
	local _, cl = UnitClass("player");
	if (_type == LEGACY_SPELL_TYPE_ACTIVE) then
		if (BaseActiveSpells[cl] == nil) then return end;
		local spells = BaseActiveSpells[cl][tier];
		if (spells == nil) then -- before first loading
			return;
		end
		for k, v in pairs(spells) do
			if (Legacy_IsSpellUnlocked(k)) then
				return true;
			end
		end
	elseif (_type == LEGACY_SPELL_TYPE_PASSIVE) then
		if (BasePassiveSpells[cl] == nil) then return end;
		local spells = BasePassiveSpells[cl][tier];
		if (spells == nil) then -- before first loading
			return;
		end
		for k, v in pairs(spells) do
			if (Legacy_IsSpellUnlocked(k)) then
				return true;
			end
		end
	elseif (_type == LEGACY_SPELL_TYPE_TALENT) then
		if (BaseTalentSpells[cl] == nil) then return end;
		local spells = BaseTalentSpells[cl][tier];
		if (spells == nil) then -- before first loading
			return;
		end
		for k, v in pairs(spells) do
			if (Legacy_IsSpellUnlocked(k)) then
				return true;
			end
		end
	end
	return false;
end

function Legacy_GuildBonusUnlockAt(level)
	return 0;
end

function Legacy_GetGoldFromMoney(money)
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD));
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
	local copper = mod(money, COPPER_PER_SILVER);
	copper = floor(copper);
	return gold, silver, copper;
end

function Legacy_CalculateGoldAmount(currency)
	return currency * math.pow(currency, 0.0625) * COPPER_PER_SILVER * SILVER_PER_GOLD * Legacy.Data.GoldRatio;
end

function Legacy_ArithmeticSum(f, d, n)
	return n * f + n * (n - 1) * d / 2;
end

function Legacy_ArithmeticProgression(f, d, n)
	return f + (n - 1) * d;
end

function Legacy_AddPct(v, p)
	return v + v * p / 100;
end

function Legacy_CalcSpellExtraCost(_type)
	if (_type == LEGACY_SPELL_TYPE_ACTIVE) then
		return LegacyCharInfo.Spell.ActiveCount * 2;
	elseif (_type == LEGACY_SPELL_TYPE_PASSIVE) then
		return LegacyCharInfo.Spell.PassiveCount * 5;
	elseif (_type == LEGACY_SPELL_TYPE_TALENT) then
		return LegacyCharInfo.Spell.TalentCount * 10;
	else
		return 0;
	end
end

function Legacy_GetSpecialtyBonus(statIndex)
	return Legacy_GetSpecPoint(statIndex) * LEGACY_SPECIALTY_BONUS;
end

function Legacy_GetStatBonus(statIndex, value)
	local b = 1;
	local n = 1;
	if (statIndex == 1) then
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[1].Point * LEGACY_SPECIALTY_BONUS_R3);
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[2].Point * LEGACY_SPECIALTY_BONUS_R2);
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[3].Point * LEGACY_SPECIALTY_BONUS_R1);
		n = Legacy_AddPct(n, LegacyCharInfo.SpecialtyStats[5].Point * LEGACY_SPECIALTY_BONUS_R2);
		n = Legacy_AddPct(n, LegacyCharInfo.SpecialtyStats[4].Point * LEGACY_SPECIALTY_BONUS_R3);
	elseif (statIndex == 2) then
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[2].Point * LEGACY_SPECIALTY_BONUS_R3);
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[4].Point * LEGACY_SPECIALTY_BONUS_R2);
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[1].Point * LEGACY_SPECIALTY_BONUS_R1);
		n = Legacy_AddPct(n, LegacyCharInfo.SpecialtyStats[3].Point * LEGACY_SPECIALTY_BONUS_R2);
		n = Legacy_AddPct(n, LegacyCharInfo.SpecialtyStats[5].Point * LEGACY_SPECIALTY_BONUS_R3);
	elseif (statIndex == 3) then
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[3].Point * LEGACY_SPECIALTY_BONUS_R3);
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[1].Point * LEGACY_SPECIALTY_BONUS_R2);
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[5].Point * LEGACY_SPECIALTY_BONUS_R1);
		n = Legacy_AddPct(n, LegacyCharInfo.SpecialtyStats[4].Point * LEGACY_SPECIALTY_BONUS_R2);
		n = Legacy_AddPct(n, LegacyCharInfo.SpecialtyStats[2].Point * LEGACY_SPECIALTY_BONUS_R3);
	elseif (statIndex == 4) then
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[4].Point * LEGACY_SPECIALTY_BONUS_R3);
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[5].Point * LEGACY_SPECIALTY_BONUS_R2);
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[2].Point * LEGACY_SPECIALTY_BONUS_R1);
		n = Legacy_AddPct(n, LegacyCharInfo.SpecialtyStats[1].Point * LEGACY_SPECIALTY_BONUS_R2);
		n = Legacy_AddPct(n, LegacyCharInfo.SpecialtyStats[3].Point * LEGACY_SPECIALTY_BONUS_R3);
	elseif (statIndex == 5) then
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[5].Point * LEGACY_SPECIALTY_BONUS_R3);
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[3].Point * LEGACY_SPECIALTY_BONUS_R2);
		b = Legacy_AddPct(b, LegacyCharInfo.SpecialtyStats[4].Point * LEGACY_SPECIALTY_BONUS_R1);
		n = Legacy_AddPct(n, LegacyCharInfo.SpecialtyStats[2].Point * LEGACY_SPECIALTY_BONUS_R2);
		n = Legacy_AddPct(n, LegacyCharInfo.SpecialtyStats[1].Point * LEGACY_SPECIALTY_BONUS_R3);
	end
	
	return value * b / n * LEGACY_STAT_BONUS_FACTOR;
end

function Legacy_AddEnchantToItemLink(oldLink, enchant)
	local item, rest = string.match(oldLink,"(.*item:%d+:)%d+(.*)");
	if item and rest then
		return item..enchant..rest;
	end
	return oldLink;
end

function LegacyPanel_TransmogCollectedAtSlot(slot)
	return 0;
end

function LegacyPanel_IsCurrentTransmog(slot, item)
	if (slot == nil or item == nil) then return false end
	if (LegacyPanel.Transmogs[slot] ~= nil and LegacyPanel.Transmogs[slot] == item) then
		return true;
	else
		return false;
	end
end

function LegacyPanel_MarketSpellPossessed(entry)
	if (Legacy.Data.PossessedMarketSpells[entry] == true) then
		return true;
	end
	return false;
end

function Legacy_CalcDiscount(price, discount)
	return price * (100 - discount) / 100;
end

function Legacy_TLength(t)
	local count = 0;
	for k, v in pairs(t) do count = count + 1 end
	return count;
end

function Legacy_HideMainFrame()
	LegacyPanel.MainFrame:Hide();
	_G["LegacyPanelCharName"]:Show();
end

function Legacy_ClassSpellQuality(spell, _type, tier)
	local _, cl = UnitClass("player");
	local list = PlayerSpell[cl];
	if (list == nil) then return 0 end
	local typeSpells = list[_type];
	if (typeSpells == nil) then return 0 end
	local tierSpells = typeSpells[tier];
	if (tierSpells == nil) then return 0 end
	for k, v in pairs(tierSpells) do
		if (v.s == spell) then
			return v.q;
		end
	end
	
	return 0;
end

function Legacy_QualityColor(quality)
	if (quality == 0) then
		return 0.5, 0.5, 0.5, 1.0;
	elseif (quality == 1) then
		return 1.0, 1.0, 1.0, 1.0;
	elseif (quality == 2) then
		return 0.1176, 1.0, 0, 1.0;
	elseif (quality == 3) then
		return 0, 0.4392, 0.8667, 1.0;
	elseif (quality == 4) then
		return 0.6392, 0.2078, 0.9333, 1.0;
	else
		return 1, 0.502, 0, 1.0;
	end
end

function Legacy_QualityColorNA(quality)
	if (quality == 0) then
		return 0.5, 0.5, 0.5;
	elseif (quality == 1) then
		return 1.0, 1.0, 1.0;
	elseif (quality == 2) then
		return 0.1176, 1.0, 0;
	elseif (quality == 3) then
		return 0, 0.4392, 0.8667;
	elseif (quality == 4) then
		return 0.6392, 0.2078, 0.9333;
	else
		return 1, 0.502, 0;
	end
end

function Legacy_QualityColorHex(quality)
	if (quality == 0 or quality == 1) then
		return "ffffff";
	elseif (quality == 2) then
		return "1eff00";
	elseif (quality == 3) then
		return "0070dd";
	elseif (quality == 4) then
		return "a335ee";
	else
		return "ff8000";
	end
end

function Legacy_IsCurrentGuildBonus(index, spell)
	if (Legacy.Data.Guild.Bonus[index].s ~= 0 and Legacy.Data.Guild.Bonus[index].s == spell) then
		return true;
	end
	return false;
end

function Legacy_QBenefit(limiter, deno, value)
	return limiter * value / (deno + value);
end

function Legacy_GetGPResetCost()
	local spent = 0;
	for i = 1, 5 do
		spent = spent + LegacyCharInfo.SpecialtyStats[i].Point;
	end
	return spent;
end

function Legacy_LeveledMod(v, a, e)
	if (v <= 0 or a <= 0 or e <= 0) then
		return 0;
	end
	
	local an = v / a;
	local blocked = 0;
	
	for i = 0, 9 do
		if (an <= i) then
			return blocked;
		end
		
		blocked = blocked + math.min(v, a * e * math.pow(0.5, i));
	end
	
	return blocked;
end

function Legacy_ConvertSecToDay(sec)
	return format("%d天", sec/86400 + 0.5);
end