function Legacy_ParseQuery(action, msg)
	if (action == LMSG_Q_SPECIALTY) then
		Legacy_HandleSpecialtyInfo(msg);
	elseif (action == LMSG_Q_MEMORY_POINT) then
		Legacy_HandleMemoryPointInfo(msg);
	elseif (action == LMSG_Q_REWARD_COUNT) then
		Legacy_HandleRewardCount(msg);
	elseif (action == LMSG_Q_REWARD_INFO) then
		Legacy_HandleRewardInfo(msg);
	elseif (action == LMSG_Q_RUNE0_INFO) then
		Legacy_HandleRune0Info(msg);
	elseif (action == LMSG_Q_RUNE1_INFO) then
		Legacy_HandleRune1Info(msg);
	elseif (action == LMSG_NOTIFY) then
		Legacy_HandleNotify(msg);
	elseif (action == LMSG_Q_RUNE2_INFO) then
		Legacy_HandleRune2Info(msg);
	elseif (action == LMSG_Q_LEGACY_ITEM_INFO) then
		Legacy_HandleLegacyItemInfo(msg);
	elseif (action == LMSG_Q_MARKET_ITEM_INFO) then
		Legacy_HandleMarketItemInfo(msg);
	elseif (action == LMSG_Q_ACCOUNT_INFO) then
		Legacy_HandleAccountInfo(msg);
	elseif (action == LMSG_Q_GUILD_BONUS_INFO) then
		Legacy_HandleGuildBonusInfo(msg);
	elseif (action == LMSG_Q_GUILD_RANK_INFO) then
		Legacy_HandleGuildRankInfo(msg);
	elseif (action == LMSG_Q_GOLD_RATIO) then
		Legacy_HandleGoldRatioInfo(msg);
	elseif (action == LMSG_Q_OWNED_MARKET_SPELLS) then
		Legacy_HandleOwnedMarketSpellInfo(msg);
	elseif (action == LMSG_Q_MARKET_SPELL_INFO) then
		Legacy_HandleMarketSpellInfo(msg);
	elseif (action == LMSG_Q_REPUTATION_SPELL_INFO) then
		Legacy_HandleReputationSpellInfo(msg);
	elseif (action == LMSG_Q_REPUTATION_ITEM_INFO) then
		Legacy_HandleReputationItemInfo(msg);
	elseif (action == LMSG_MSG) then
		Legacy_HandleMessage(msg);
	elseif (action == LMSG_Q_ACTIVATION_KEY) then
		Legacy_HandleActivationKeyInfo(msg);
	elseif (action == LMSG_Q_MARKET_BUFF_INFO) then
		Legacy_HandleMarketBuffInfo(msg);
	elseif (action == LMSG_Q_MARKET_BUFF_DATA) then
		Legacy_HandleMarketBuffDataInfo(msg);
	elseif (action == LMSG_Q_MEMORIZED_SPELL) then
		Legacy_HandleMemorizedSpellInfo(msg);
	elseif (action == LMSG_Q_ACTIVATED_SPELL) then
		Legacy_HandleActivatedSpellInfo(msg);
	elseif (action == LMSG_Q_CLASS_SKILL) then
		Legacy_HandleClassSkillInfo(msg);
	elseif (action == LMSG_Q_CLASS_SPELLMOD) then
		Legacy_HandleClassSpellModInfo(msg);
	end
end

function LegacyPanel_DoInitialQueries()
    Legacy_DoQuery(LMSG_Q_SPECIALTY);
    Legacy_DoQuery(LMSG_Q_MEMORY_POINT);
	Legacy_DoQuery(LMSG_Q_REWARD_COUNT);
	Legacy_DoQuery(LMSG_Q_REWARD_INFO);
	Legacy_DoQuery(LMSG_Q_RUNE0_INFO);
	Legacy_DoQuery(LMSG_Q_RUNE1_INFO);
	Legacy_DoQuery(LMSG_Q_RUNE2_INFO);
	Legacy_DoQuery(LMSG_Q_LEGACY_ITEM_INFO);
	Legacy_DoQuery(LMSG_Q_MARKET_ITEM_INFO);
	Legacy_DoQuery(LMSG_Q_ACCOUNT_INFO);
	Legacy_DoQuery(LMSG_Q_GOLD_RATIO);
	Legacy_DoQuery(LMSG_Q_OWNED_MARKET_SPELLS);
	Legacy_DoQuery(LMSG_Q_MARKET_SPELL_INFO);
	Legacy_DoQuery(LMSG_Q_REPUTATION_SPELL_INFO);
	Legacy_DoQuery(LMSG_Q_REPUTATION_ITEM_INFO);
	Legacy_DoQuery(LMSG_Q_ACTIVATION_KEY);
	Legacy_DoQuery(LMSG_Q_MARKET_BUFF_INFO);
	Legacy_DoQuery(LMSG_Q_MARKET_BUFF_DATA);
	Legacy_DoQuery(LMSG_Q_MEMORIZED_SPELL);
	Legacy_DoQuery(LMSG_Q_ACTIVATED_SPELL);
	Legacy_DoQuery(LMSG_Q_CLASS_SKILL);
	Legacy_DoQuery(LMSG_Q_CLASS_SPELLMOD);
	if (IsInGuild()) then
		Legacy_DoQuery(LMSG_Q_GUILD_RANK_INFO);
		Legacy_DoQuery(LMSG_Q_GUILD_BONUS_INFO);
	end
end