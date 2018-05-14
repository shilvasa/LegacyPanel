function LegacyPanel_DoInitialQueries()
    Legacy_DoQuery(LMSG_Q_STATS);
    Legacy_DoQuery(LMSG_Q_GP);
	--Legacy_DoQuery(LMSG_Q_SPELLMOD_INFO);
    Legacy_DoQuery(LMSG_Q_ACTIVE_SPELL_INFO);
    Legacy_DoQuery(LMSG_Q_PASSIVE_SPELL_INFO);
    Legacy_DoQuery(LMSG_Q_TALENT_SPELL_INFO);
    --Legacy_DoQuery(LMSG_Q_UNLOCKED_SPELL_INFO);
	Legacy_DoQuery(LMSG_Q_LEGACY_ITEM_INFO);
	Legacy_DoQuery(LMSG_Q_MARKET_ITEM_INFO);
	Legacy_DoQuery(LMSG_Q_MARKET_SPELL_INFO);
	Legacy_DoQuery(LMSG_Q_REWARD_INFO);
	Legacy_DoQuery(LMSG_Q_ACCOUNT_INFO);
	Legacy_DoQuery(LMSG_Q_GOLD_RATIO);
	Legacy_DoQuery(LMSG_Q_UNLOCKED_SPELL_COUNT);
	Legacy_DoQuery(LMSG_Q_TRANSMOGS);
	Legacy_DoQuery(LMSG_Q_TRANSMOG_COLLECTIONS);
	Legacy_DoQuery(LMSG_Q_POSSESSED_MARKET_SPELLS);
	Legacy_DoQuery(LMSG_Q_REPUTATION_ITEM_INFO);
	Legacy_DoQuery(LMSG_Q_REPUTATION_SPELL_INFO);
	Legacy_DoQuery(LMSG_Q_MF_RATE);
	Legacy_DoQuery(LMSG_Q_ACTIVATION_KEY);
	Legacy_DoQuery(LMSG_Q_MARKET_BUFF_INFO);
	Legacy_DoQuery(LMSG_Q_MARKET_BUFF_DATA);
	if (IsInGuild()) then
		Legacy_DoQuery(LMSG_Q_GUILD_RANK_INFO);
		Legacy_DoQuery(LMSG_Q_GUILD_BONUS_INFO);
	end
end

function LegacyPanel_ProcessGrowthPointToNextLevel(msg)
    local point = Legacy_Fetch(msg);
    Legacy.Conf.GPForNextLevel = tonumber(point);
end

function LegacyPanel_ProcessStatInfo(msg)
	local maxLevel, s1, s2, s3, s4, s5, s6, c1, c2, c3, c4, c5, c6 = Legacy_Fetch(msg);
    Legacy.Conf.MaxLevel = tonumber(maxLevel);
	LegacyCharInfo.SpecialtyStats[1] = { Point = tonumber(s1), Cap = tonumber(c1) };
	LegacyCharInfo.SpecialtyStats[2] = { Point = tonumber(s2), Cap = tonumber(c2) };
	LegacyCharInfo.SpecialtyStats[3] = { Point = tonumber(s3), Cap = tonumber(c3) };
	LegacyCharInfo.SpecialtyStats[4] = { Point = tonumber(s4), Cap = tonumber(c4) };
	LegacyCharInfo.SpecialtyStats[5] = { Point = tonumber(s5), Cap = tonumber(c5) };
    LegacyCharInfo.SpecialtyStats[6] = { Point = tonumber(s6), Cap = tonumber(c6) };
    LegacyPanel_UpdateStats();
	PaperDollFrame_UpdateStats();
end

function LegacyPanel_ProcessGPInfo(msg)
	local gp_total, gp_cost, gp_available, tp_total, tp_cost, tp_available = Legacy_Fetch(msg);
	LegacyCharInfo.GP.Total = tonumber(gp_total);
	LegacyCharInfo.GP.Cost = tonumber(gp_cost);
	LegacyCharInfo.GP.Available = tonumber(gp_available);
	LegacyCharInfo.TP.Total = tonumber(tp_total);
	LegacyCharInfo.TP.Cost = tonumber(tp_cost);
	LegacyCharInfo.TP.Available = tonumber(tp_available);
    LegacyPanel_UpdateGP();
end

function LegacyPanel_ProcessMFRate(msg)
    local mfRate = Legacy_Fetch(msg);
    Legacy.Data.MF = tonumber(mfRate) / 100;
end

function LegacyPanel_ProcessRewardCount(msg)
    local rewardCount = tonumber(Legacy_Fetch(msg));
    Legacy.Data.Rewards.Count = rewardCount;
end

function LegacyPanel_ProcessUpgradedSpellModInfo(msg)
    local _, cl = UnitClass("player");
	Legacy.Data.UpgradedSpellMods = {};

    local _, cl = UnitClass("player");
	
	local set = Legacy_SplitToSet(msg, ":");
	local storeIndex = 1;
	for i = 1, #set, 2 do
		local modID = tonumber(set[i]);
		local rank = tonumber(set[i + 1]);
		Legacy.Data.UpgradedSpellMods[modID] = rank;
        LegacyPanel_UpdateSpellModItem(modID, rank);
	end
end

function LegacyPanel_ProcActiveSpellInfo(msg)
    local s1, s2, s3, s4, s5, s6, s7, s8, s9, s10 = Legacy_Fetch(msg);
    Legacy.Data.ActiveSpells[1] = tonumber(s1);
    Legacy.Data.ActiveSpells[2] = tonumber(s2);
    Legacy.Data.ActiveSpells[3] = tonumber(s3);
    Legacy.Data.ActiveSpells[4] = tonumber(s4);
    Legacy.Data.ActiveSpells[5] = tonumber(s5);
    Legacy.Data.ActiveSpells[6] = tonumber(s6);
    Legacy.Data.ActiveSpells[7] = tonumber(s7);
    Legacy.Data.ActiveSpells[8] = tonumber(s8);
    Legacy.Data.ActiveSpells[9] = tonumber(s9);
    Legacy.Data.ActiveSpells[10] = tonumber(s10);
    LegacyPanel_UpdateSpells(UnitLevel("player"));
end

function LegacyPanel_ProcPassiveSpellInfo(msg)
    local s1, s2, s3, s4, s5, s6, s7, s8, s9, s10 = Legacy_Fetch(msg);
    Legacy.Data.PassiveSpells[1] = tonumber(s1);
    Legacy.Data.PassiveSpells[2] = tonumber(s2);
    Legacy.Data.PassiveSpells[3] = tonumber(s3);
    Legacy.Data.PassiveSpells[4] = tonumber(s4);
    Legacy.Data.PassiveSpells[5] = tonumber(s5);
    Legacy.Data.PassiveSpells[6] = tonumber(s6);
    Legacy.Data.PassiveSpells[7] = tonumber(s7);
    Legacy.Data.PassiveSpells[8] = tonumber(s8);
    Legacy.Data.PassiveSpells[9] = tonumber(s9);
    Legacy.Data.PassiveSpells[10] = tonumber(s10);
    LegacyPanel_UpdateSpells(UnitLevel("player"));
end

function LegacyPanel_ProcTalentSpellInfo(msg)
    local s1, s2, s3, s4, s5, s6, s7, s8, s9, s10 = Legacy_Fetch(msg);
    Legacy.Data.TalentSpells[1] = tonumber(s1);
    Legacy.Data.TalentSpells[2] = tonumber(s2);
    Legacy.Data.TalentSpells[3] = tonumber(s3);
    Legacy.Data.TalentSpells[4] = tonumber(s4);
    Legacy.Data.TalentSpells[5] = tonumber(s5);
    Legacy.Data.TalentSpells[6] = tonumber(s6);
    Legacy.Data.TalentSpells[7] = tonumber(s7);
    Legacy.Data.TalentSpells[8] = tonumber(s8);
    Legacy.Data.TalentSpells[9] = tonumber(s9);
    Legacy.Data.TalentSpells[10] = tonumber(s10);
    LegacyPanel_UpdateSpells(UnitLevel("player"));
end

function LegacyPanel_ProcUnlockedSpellInfo(msg)
    Legacy.Data.UnlockedSpells = {};
    local set = Legacy_SplitToSet(msg, ":");
    local index = 1;
    if (#set >= 1) then
        for i = 1, #set do
            local spell = tonumber(set[i]);
            Legacy.Data.UnlockedSpells[spell] = true;
            LegacyPanel_UnlockAffectedAbilityFrameAndTips(spell);
        end
	else -- first
		local spell = tonumber(msg);
		if (spell ~= nil) then
			Legacy.Data.UnlockedSpells[spell] = true;
			LegacyPanel_UnlockAffectedAbilityFrameAndTips(spell);
		end
    end
	
	-- ensure ui updates after this
	local lvl = UnitLevel("player");
	LegacyPanel_UpdateActiveSpells(lvl);
	LegacyPanel_UpdatePassiveSpells(lvl);
	LegacyPanel_UpdateTalentSpells(lvl);
end

-- for all spells store in different categories in client they all are just represent themselves so we only perform a single unlock action for each spell, they'll appear as 'unlocked everywhere'. 
function LegacyPanel_UnlockSpell(sender)
    if (sender.gp > LegacyCharInfo.TP.Available) then
        Legacy_Signal(format(LEGACY_NOT_ENOUGH_GP_FORMAT, sender.link));
        return;
    else
        Legacy_DoQuery(LMSG_A_UNLOCK_SPELL, sender.spell);
    end
end

function LegacyPanel_NotifyUnlockedSpell(msg)
    local spell, cost = Legacy_Fetch(msg);
    spell = tonumber(spell);
    cost = tonumber(cost);
    print(format(LEGACY_NOTIFY_UNLOCK_SPELL, GetSpellLink(spell), cost));
end

function LegacyPanel_ProcLegacyItemInfo(msg)
	Legacy.Data.LegacyItems = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 4 do
		local n = tonumber(set[i]);
		local e = tonumber(set[i+1]);
		local c = tonumber(set[i+2]);
		local a = tonumber(set[i+3]);
		if (n ~= nil) then
			local av = a == 1;
			Legacy.Data.LegacyItems[n] = { entry = e, cost = c, acquirable = av };
		end
	end
	LegacyPanel_UpdateLegacyItems();
	LegacyPanel_UpdateLegacyNavState();
end

function LegacyPanel_NotifyLegacyItemFetchResult(msg)
	local result = tonumber(msg);
	if (result == 1) then
		print(LEGACY_FETCH_LEGACY_RESULT_1);
	elseif (result == 2) then
		print(LEGACY_FETCH_LEGACY_RESULT_2);
	elseif (result == 3) then
		print(LEGACY_FETCH_LEGACY_RESULT_3);
	elseif (result == 4) then
		print(LEGACY_FETCH_LEGACY_RESULT_4);
	end
end

function LegacyPanel_ProcMarketItemInfo(msg)
	Legacy.Data.MarketItems = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 4 do
		local n = tonumber(set[i]);
		local e = tonumber(set[i+1]);
		local p = tonumber(set[i+2]);
		local d = tonumber(set[i+3]);
		if (e ~= nil) then
			Legacy.Data.MarketItems[n] = { entry = e, price = p, discount = d };
		end
	end
	LegacyPanel_UpdateMarketItems();
	LegacyPanel_UpdateMarketNavState();
end

function LegacyPanel_ProcMarketSpellInfo(msg)
	Legacy.Data.MarketSpells = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 4 do
		local n = tonumber(set[i]);
		local e = tonumber(set[i+1]);
		local p = tonumber(set[i+2]);
		local d = tonumber(set[i+3]);
		if (e ~= nil) then
			Legacy.Data.MarketSpells[n] = { entry = e, price = p, discount = d };
		end
	end
	LegacyPanel_UpdateMarketItems();
	LegacyPanel_UpdateMarketNavState();
end

function LegacyPanel_ProcNotification(msg)
	local result, param1, param2 = Legacy_Fetch(msg);
	result = tonumber(result);
	param1 = tonumber(param1);
	param2 = tonumber(param2);
	local notification;
	if (result == LNOTIFY_UNLOCK_SPELL) then -- spell unlocked
		if (param2 > 0) then
			notification = format(LEGACY_NOTIFICATIONS[LNOTIFY_UNLOCK_SPELL], GetSpellLink(param1), param2);
		else
			notification = format(LEGACY_NOTIFY_UNLOCK_SPELL, GetSpellLink(param1));
		end
	elseif (result == LNOTIFY_BOUGHT_GOLD) then
		local money = param1;
		local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD));
		local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
		local copper = mod(money, COPPER_PER_SILVER);
		notification = format(LEGACY_NOTIFICATIONS[LNOTIFY_BOUGHT_GOLD], gold, silver, copper);
	elseif (result == LNOTIFY_COLLECT_TRANSMOG) then
		local _, link = GetItemInfo(param1);
		notification = format(LEGACY_NOTIFICATIONS[LNOTIFY_COLLECT_TRANSMOG], link);
	elseif (result == LNOTIFY_MF_STATE_CHANGED) then
		notification = format(LEGACY_NOTIFICATIONS[result], LEGACY_MF_STATE[param1]);
		LegacyCharInfo.MF.State = param1;
		LegacyPanel_UpdateStats();
	else
		notification = format(LEGACY_NOTIFICATIONS[result], param1, param2);
	end
	if (notification ~= nil) then
		print("|cff00ffff"..notification.."|r");
	end
end

function LegacyPanel_ProcRewardInfo(msg)
	Legacy.Data.RewardItems = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 4 do
		local n = tonumber(set[i]);
		local e = tonumber(set[i+1]);
		local c = tonumber(set[i+2]);
		local t = tonumber(set[i+3]);
		Legacy.Data.RewardItems[n] = { entry = e, count = c, _type = t };
	end
	LegacyPanel_UpdateRewardItems();
	LegacyPanel_UpdateRewardNavState();
end

function LegacyPanel_ProcAccountInfo(msg)
	local curr, level, rank = Legacy_Fetch(msg);
	Legacy.Data.Account.Currency = tonumber(curr);
	Legacy.Data.Account.Level = tonumber(level);
	Legacy.Data.Account.Rank = tonumber(rank);
	LegacyPanel_UpdateAccountInfo();
end

function LegacyPanel_ProcGuildRankInfo(msg)
	local r, x, n = Legacy_Fetch(msg);
	Legacy.Data.Guild.Rank = tonumber(r);
	Legacy.Data.Guild.XP = tonumber(x);
	Legacy.Data.Guild.XPToNextLevel = tonumber(n);
	LegacyPanel_UpdateGuildRankInfo();
	LegacyPanel_UpdateGuildBonus(); -- update unlock action
end

function LegacyPanel_ProcGuildSpellInfo(msg)
	local data = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 5 do
		local index = tonumber(set[i]);
		local spell = tonumber(set[i+1]);
		local cost = tonumber(set[i+2]);
		local rank = tonumber(set[i+3]);
		local quality = tonumber(set[i+4]);
		data[index] = { s = spell, c = cost, r = rank, q = quality };
	end
	LegacyPanel_LoadGuildBonusItems(data);
end

function LegacyPanel_ProcGuildBonusInfo(msg)
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 4 do
		local slot = tonumber(set[i]);
		local spell = tonumber(set[i+1]);
		local cost = tonumber(set[i+2]);
		local quality = tonumber(set[i+3]);
		if (slot ~= nil) then
			Legacy.Data.Guild.Bonus[slot] = { s = spell, c = cost, q = quality };
		end
	end
	LegacyPanel_UpdateGuildBonus();
end

function LegacyPanel_ProcUpdateGoldRatio(msg)
	local r = Legacy_Fetch(msg);
	Legacy.Data.GoldRatio = tonumber(r);
end

function LegacyPanel_ProcUpdateUnlockedSpellCount(msg)
	local a, p, t = Legacy_Fetch(msg);
	LegacyCharInfo.Spell.ActiveCount = tonumber(a);
	LegacyCharInfo.Spell.PassiveCount = tonumber(p);
	LegacyCharInfo.Spell.TalentCount = tonumber(t);
end

function LegacyPanel_ProcTransmogInfo(msg)
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 2 do
		local slot = tonumber(set[i]);
		local entry = tonumber(set[i+1]);
		LegacyPanel.Transmogs[slot] = entry;
	end
	LegacyPanel_UpdateTransmogs();
end

function LegacyPanel_ProcTransmogCollectionInfo(msg)
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 2 do
		local slot = tonumber(set[i]);
		local entry = tonumber(set[i+1]);
		LegacyPanel.TransmogCollections[slot] = entry;
	end
	LegacyPanel_UpdateTransmogCollections();
end

function LegacyPanel_ProcMarketSpellPossessionInfo(msg)
	Legacy.Data.PossessedMarketSpells = {};
	local set = Legacy_SplitToSet(msg, ":");
	if (#set > 0) then
		for i = 1, #set, 1 do
			local entry = tonumber(set[i]);
			Legacy.Data.PossessedMarketSpells[entry] = true;
		end
	else
		local e = Legacy_Fetch(msg);
		if (e ~= "" and e ~= nil) then
			e = tonumber(e);
			Legacy.Data.PossessedMarketSpells[e] = true;
		end
	end
	
	LegacyPanel_UpdateMarketItems();
end

function LegacyPanel_ProcReputationItemInfo(msg)
	Legacy.Data.ReputationItems = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 5 do
		local index = tonumber(set[i]);
		local entry = tonumber(set[i+1]);
		local count = tonumber(set[i+2]);
		local rank = tonumber(set[i+3]);
		local singleTimeReward = tonumber(set[i+4]) == 1;
		Legacy.Data.ReputationItems[index] = { e = entry, c = count, r = rank, s = singleTimeReward };
	end
	LegacyPanel_UpdateRewardItems();
end

function LegacyPanel_ProcReputationSpellInfo(msg)
	Legacy.Data.ReputationSpells = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 3 do
		local index = tonumber(set[i]);
		local entry = tonumber(set[i+1]);
		local rank = tonumber(set[i+2]);
		Legacy.Data.ReputationSpells[index] = { e = entry, r = rank };
	end
	LegacyPanel_UpdateRewardItems();
end

function LegacyPanel_ProcMFInfo(msg)
	local l, s, c = Legacy_Fetch(msg);
	LegacyCharInfo.MF.Level = tonumber(l);
	LegacyCharInfo.MF.SLevel = tonumber(s);
	LegacyCharInfo.MF.Cap = tonumber(c);
	LegacyPanel_UpdateStats();
end

function LegacyPanel_ProcTransmogCollectionSlot(msg)
	local slot, entry = Legacy_Fetch(msg);
	LegacyPanel.TransmogCollections[tonumber(slot)] = tonumber(entry);
	LegacyPanel_UpdateTransmogCollections();
end

function LegacyPanel_ProcTransmogSlot(msg)
	local slot, entry = Legacy_Fetch(msg);
	LegacyPanel.Transmogs[tonumber(slot)] = tonumber(entry);
	LegacyPanel_UpdateTransmogs();
end

function LegacyPanel_ProcMsg(msg)
	local a, b = string.find(msg, "\t", 1, false);
	local index = tonumber(string.sub(msg, 1, a - 1));
	local data = string.sub(msg, b + 1, string.len(msg));
	print(format(LEGACY_MESSAGE[index], Legacy_TFetch(data)));
end

function LegacyPanel_ProcActivationKey(msg)
	Legacy.Data.ActivationKeys = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set do
		Legacy.Data.ActivationKeys[i] = set[i];
	end
	
	LegacyPanel_UpdateActivationKeys();
end

function LegacyPanel_ProcMarketBuffInfo(msg)
	Legacy.Data.MarketBuffs = {};
	local set = Legacy_SplitToSet(msg, ":");
	local index = 1;
	for i = 1, #set, 4 do
		Legacy.Data.MarketBuffs[index] = {};
		Legacy.Data.MarketBuffs[index].entry = tonumber(set[i]);
		Legacy.Data.MarketBuffs[index].price = tonumber(set[i+1]);
		Legacy.Data.MarketBuffs[index].length = tonumber(set[i+2]);
		Legacy.Data.MarketBuffs[index].discount = tonumber(set[i+3]);
		index = index + 1;
	end
	
	LegacyPanel_UpdateMarketItems();
end

function LegacyPanel_ProcPossessedMarketBuffInfo(msg)
	Legacy.Data.PossessedMarketBuffs = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 2 do
		Legacy.Data.PossessedMarketBuffs[tonumber(set[i])] = tonumber(set[i+1]);
	end
	
	LegacyPanel_UpdateMarketItems();
end

function LegacyPanel_MarketBuffPossessed(buff)
	if (Legacy.Data.PossessedMarketBuffs[buff] == nil) then
		return false;
	else
		local t = time();
		if (Legacy.Data.PossessedMarketBuffs[buff] < t) then
			return false;
		end
	end
	
	return true;
end