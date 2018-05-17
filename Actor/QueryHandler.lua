-- LMSG_Q_SPECIALTY
function Legacy_HandleSpecialtyInfo(msg)
	local point, available, s1, s2, s3, s4, s5, s6 = Legacy_Fetch(msg);
	Legacy.Data.Character.Specialty.Point = tonumber(point);
	Legacy.Data.Character.Specialty.Available = tonumber(available);
	Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_ARMFORCE] = tonumber(s1);
	Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_INSTINCT] = tonumber(s2);
	Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_WILLPOWER] = tonumber(s3);
	Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_SANITY] = tonumber(s4);
	Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_PYSCHE] = tonumber(s5);
	Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_TRIAL] = tonumber(s6);
	LegacyPanel_UpdateSpecialty();
end

-- LMSG_Q_MEMORY_POINT
function Legacy_HandleMemoryPointInfo(msg)
	local point, available, costByMod, costBySlot = Legacy_Fetch(msg);
	Legacy.Data.Character.Memory.Point = tonumber(point);
	Legacy.Data.Character.Memory.Available = tonumber(available);
	Legacy.Data.Character.Memory.Cost.Mod = tonumber(costByMod);
	Legacy.Data.Character.Memory.Cost.Slot = tonumber(costBySlot);
	
	LegacyPanel_UpdateMemoryPoint();
end

-- LMSG_Q_SPELLINFO (obs)
-- LMSG_Q_LEARNABLE_SPELL_LIST (obs)
-- LMSG_Q_SPELL_CACHE (obs)
-- LMSG_Q_SPEC_COUNT (obs)
-- LMSG_Q_GP_FOR_NEXT_LEVEL (obs)
-- LMSG_Q_MAX_LEVEL (obs)
-- LMSG_Q_ALL_SPELLINFO (obs)
-- LMSG_Q_MF_RATE (obs)

-- LMSG_Q_REWARD_COUNT
function Legacy_HandleRewardCount(msg)
	local rewardCount = tonumber(Legacy_Fetch(msg));
    Legacy.Data.Character.Reward.Count = rewardCount;
end

-- LMSG_Q_REWARD_INFO
function Legacy_HandleRewardInfo(msg)
	Legacy.Data.Character.Reward.Item = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 4 do
		local n = tonumber(set[i]);
		local e = tonumber(set[i+1]);
		local c = tonumber(set[i+2]);
		local s = tonumber(set[i+3]);
		Legacy.Data.Character.Reward.Item[n] = { entry = e, count = c, slot = s };
	end
	LegacyPanel_UpdateReputation();
	LegacyPanel_UpdateReputationNavState();
end

-- LMSG_Q_SPELLMOD_INFO (obs)

-- LMSG_Q_RUNE0_INFO
function Legacy_HandleRune0Info(msg)
	local s1, s2, s3, s4, s5, s6, s7, s8, s9, s10 = Legacy_Fetch(msg);
	Legacy.Data.Character.Rune[0] = {};
    Legacy.Data.Character.Rune[0][1] = tonumber(s1);
    Legacy.Data.Character.Rune[0][2] = tonumber(s2);
    Legacy.Data.Character.Rune[0][3] = tonumber(s3);
    Legacy.Data.Character.Rune[0][4] = tonumber(s4);
    Legacy.Data.Character.Rune[0][5] = tonumber(s5);
    Legacy.Data.Character.Rune[0][6] = tonumber(s6);
    Legacy.Data.Character.Rune[0][7] = tonumber(s7);
    Legacy.Data.Character.Rune[0][8] = tonumber(s8);
    Legacy.Data.Character.Rune[0][9] = tonumber(s9);
    Legacy.Data.Character.Rune[0][10] = tonumber(s10);
	LegacyPanel_UpdateRunes();
end

-- LMSG_Q_RUNE1_INFO
function Legacy_HandleRune1Info(msg)
	local s1, s2, s3, s4, s5, s6, s7, s8, s9, s10 = Legacy_Fetch(msg);
	Legacy.Data.Character.Rune[1] = {};
    Legacy.Data.Character.Rune[1][1] = tonumber(s1);
    Legacy.Data.Character.Rune[1][2] = tonumber(s2);
    Legacy.Data.Character.Rune[1][3] = tonumber(s3);
    Legacy.Data.Character.Rune[1][4] = tonumber(s4);
    Legacy.Data.Character.Rune[1][5] = tonumber(s5);
    Legacy.Data.Character.Rune[1][6] = tonumber(s6);
    Legacy.Data.Character.Rune[1][7] = tonumber(s7);
    Legacy.Data.Character.Rune[1][8] = tonumber(s8);
    Legacy.Data.Character.Rune[1][9] = tonumber(s9);
    Legacy.Data.Character.Rune[1][10] = tonumber(s10);
	LegacyPanel_UpdateRunes();
end

-- LMSG_Q_UNLOCKED_SPELL_INFO (obs)

-- LMSG_NOTIFY
function Legacy_HandleNotify(msg)
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

-- MSG_Q_RUNE2_INFO
function Legacy_HandleRune2Info(msg)
	local s1, s2, s3, s4, s5, s6, s7, s8, s9, s10 = Legacy_Fetch(msg);
	Legacy.Data.Character.Rune[2] = {};
    Legacy.Data.Character.Rune[2][1] = tonumber(s1);
    Legacy.Data.Character.Rune[2][2] = tonumber(s2);
    Legacy.Data.Character.Rune[2][3] = tonumber(s3);
    Legacy.Data.Character.Rune[2][4] = tonumber(s4);
    Legacy.Data.Character.Rune[2][5] = tonumber(s5);
    Legacy.Data.Character.Rune[2][6] = tonumber(s6);
    Legacy.Data.Character.Rune[2][7] = tonumber(s7);
    Legacy.Data.Character.Rune[2][8] = tonumber(s8);
    Legacy.Data.Character.Rune[2][9] = tonumber(s9);
    Legacy.Data.Character.Rune[2][10] = tonumber(s10);
	LegacyPanel_UpdateRunes();
end

-- LMSG_Q_LEGACY_ITEM_INFO
function Legacy_HandleLegacyItemInfo(msg)
	Legacy.Data.Env.Legacy = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 4 do
		local n = tonumber(set[i]);
		local e = tonumber(set[i+1]);
		local c = tonumber(set[i+2]);
		local a = tonumber(set[i+3]);
		if (n ~= nil) then
			local av = a == 1;
			Legacy.Data.Env.Legacy[n] = { entry = e, cost = c, acquirable = av };
		end
	end
	LegacyPanel_UpdateLegacyItem();
	LegacyPanel_UpdateLegacyItemNavState();
end

-- LMSG_Q_MARKET_ITEM_INFO
function Legacy_HandleMarketItemInfo(msg)
	Legacy.Data.Env.Market.Item = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 4 do
		local n = tonumber(set[i]);
		local e = tonumber(set[i+1]);
		local p = tonumber(set[i+2]);
		local d = tonumber(set[i+3]);
		if (e ~= nil) then
			Legacy.Data.Env.Market.Item[n] = { entry = e, price = p, discount = d };
		end
	end
	LegacyPanel_UpdateMarket();
	LegacyPanel_UpdateMarketNavState();
end

-- LMSG_Q_ACCOUNT_INFO
function Legacy_HandleAccountInfo(msg)
	local curr, reputation, rank = Legacy_Fetch(msg);
	Legacy.Data.Account.Currency = tonumber(curr);
	Legacy.Data.Account.Reputation = tonumber(reputation);
	Legacy.Data.Account.Rank = tonumber(rank);
end

-- LMSG_Q_GUILD_BONUS_INFO
function Legacy_HandleGuildBonusInfo(msg)
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
end

-- LMSG_Q_GUILD_RANK_INFO
function Legacy_HandleGuildRankInfo(msg)
	local r, x, n = Legacy_Fetch(msg);
	Legacy.Data.Guild.Rank = tonumber(r);
	Legacy.Data.Guild.XP = tonumber(x);
	Legacy.Data.Guild.XPToNextLevel = tonumber(n);
end

-- LMSG_Q_GOLD_RATIO
function Legacy_HandleGoldRatioInfo(msg)
	local r = Legacy_Fetch(msg);
	Legacy.Data.Env.GoldRatio = tonumber(r);
end

-- LMSG_Q_UNLOCKED_SPELL_COUNT (obs)

-- LMSG_Q_TRANSMOGS (nyi)
-- LMSG_Q_TRANSMOG_COLLECTIONS (nyi)

-- LMSG_Q_OWNED_MARKET_SPELLS
function Legacy_HandleOwnedMarketSpellInfo(msg)
	Legacy.Data.Character.Market.Spell = {};
	local set = Legacy_SplitToSet(msg, ":");
	if (#set > 0) then
		for i = 1, #set, 1 do
			local entry = tonumber(set[i]);
			Legacy.Data.Character.Market.Spell[entry] = true;
		end
	else
		local e = Legacy_Fetch(msg);
		if (e ~= "" and e ~= nil) then
			e = tonumber(e);
			Legacy.Data.Character.Market.Spell[e] = true;
		end
	end
	LegacyPanel_UpdateMarket();
end

-- LMSG_Q_MARKET_SPELL_INFO
function Legacy_HandleMarketSpellInfo(msg)
	Legacy.Data.Env.Market.Spell = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 4 do
		local n = tonumber(set[i]);
		local e = tonumber(set[i+1]);
		local p = tonumber(set[i+2]);
		local d = tonumber(set[i+3]);
		if (e ~= nil) then
			Legacy.Data.Env.Market.Spell[n] = { entry = e, price = p, discount = d };
		end
	end
	LegacyPanel_UpdateMarket();
	LegacyPanel_UpdateMarketNavState();
end

-- LMSG_Q_REPUTATION_SPELL_INFO
function Legacy_HandleReputationSpellInfo(msg)
	Legacy.Data.Env.Reputation.Spell = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 3 do
		local index = tonumber(set[i]);
		local e = tonumber(set[i+1]);
		local r = tonumber(set[i+2]);
		Legacy.Data.Env.Reputation.Spell[index] = { entry = e, rank = r };
	end
	LegacyPanel_UpdateReputation();
	LegacyPanel_UpdateReputationNavState();
end

-- LMSG_Q_REPUTATION_ITEM_INFO
function Legacy_HandleReputationItemInfo(msg)
	Legacy.Data.Env.Reputation.Item = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 5 do
		local index = tonumber(set[i]);
		local e = tonumber(set[i+1]);
		local c = tonumber(set[i+2]);
		local r = tonumber(set[i+3]);
		local s = tonumber(set[i+4]) == 1;
		Legacy.Data.Env.Reputation.Item[index] = { entry = e, count = c, rank = r, singleTime = s };
	end
	LegacyPanel_UpdateReputation();
	LegacyPanel_UpdateReputationNavState();
end

-- LMSG_Q_TRANSMOG_COLLECTION_SLOT (nyi)
-- LMSG_Q_TRANSMOG_SLOT (nyi)

-- LMSG_MSG
function Legacy_HandleMessage(msg)
	local a, b = string.find(msg, "\t", 1, false);
	local index = tonumber(string.sub(msg, 1, a - 1));
	local data = string.sub(msg, b + 1, string.len(msg));
	print(format(LEGACY_MESSAGE[index], Legacy_TFetch(data)));
end

-- LMSG_Q_ACTIVATION_KEY
function Legacy_HandleActivationKeyInfo(msg)
	Legacy.Data.Account.ActivationKey = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set do
		Legacy.Data.Account.ActivationKey[i] = set[i];
	end
end

-- LMSG_Q_MARKET_BUFF_INFO
function Legacy_HandleMarketBuffInfo(msg)
	Legacy.Data.Env.Market.Buff = {};
	local set = Legacy_SplitToSet(msg, ":");
	local index = 1;
	for i = 1, #set, 4 do
		Legacy.Data.Env.Market.Buff[index] = {};
		Legacy.Data.Env.Market.Buff[index].entry = tonumber(set[i]);
		Legacy.Data.Env.Market.Buff[index].price = tonumber(set[i+1]);
		Legacy.Data.Env.Market.Buff[index].length = tonumber(set[i+2]);
		Legacy.Data.Env.Market.Buff[index].discount = tonumber(set[i+3]);
		index = index + 1;
	end
	LegacyPanel_UpdateMarket();
	LegacyPanel_UpdateMarketNavState();
end

-- LMSG_Q_MARKET_BUFF_DATA
function Legacy_HandleMarketBuffDataInfo(msg)
	Legacy.Data.Character.Market.Buff = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 2 do
		Legacy.Data.Character.Market.Buff[tonumber(set[i])] = tonumber(set[i+1]);
	end
	LegacyPanel_UpdateMarket();
end

-- LMSG_Q_MEMORIZED_SPELL
function Legacy_HandleMemorizedSpellInfo(msg)
end

-- LMSG_Q_ACTIVATED_SPELL
function Legacy_HandleActivatedSpellInfo(msg)
	Legacy.Data.Character.Spell.Activated = {};
	local set = Legacy_SplitToSet(msg, ":");
	for i = 1, #set, 1 do
		Legacy.Data.Character.Spell.Activated[i] = tonumber(set[i]);
	end
	LegacyPanel_UpdateActivatedSpell();
	LegacyPanel_UpdateActivatedSpellNavState();
end

-- LMSG_Q_CLASS_SKILL
function Legacy_HandleClassSkillInfo(msg)
	Legacy.Data.Character.ClassSkill = {};
	local set = Legacy_SplitToSet(msg, ":");
	local index = 1;
	for i = 1, #set, 2 do
		Legacy.Data.Character.ClassSkill[index] = {};
		Legacy.Data.Character.ClassSkill[index].Rank = tonumber(set[i]);
		Legacy.Data.Character.ClassSkill[index].Cap = tonumber(set[i+1]);
		index = index + 1;
	end
	LegacyPanel_UpdateClassSkill();
end

-- LMSG_Q_CLASS_SPELLMOD
function Legacy_HandleClassSpellModInfo(msg)
	local set = Legacy_SplitToSet(msg, ":");
	local storeIndex = 1;
	for i = 1, #set, 2 do
		local mod = tonumber(set[i]);
		local rank = tonumber(set[i + 1]);
		Legacy.Data.Character.Spell.Mod[mod] = rank;
	end
end