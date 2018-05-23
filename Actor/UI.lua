function LegacyPanel_InitUI()
	Legacy.UI.SpellModFrame = LegacyUI_SpellModFrame;
	Legacy.UI.SpellMod[1] = LegacyUI_SpellModFrameItem1;
	Legacy.UI.SpellMod[2] = LegacyUI_SpellModFrameItem2;
	Legacy.UI.SpellMod[3] = LegacyUI_SpellModFrameItem3;
	Legacy.UI.SpellMod[4] = LegacyUI_SpellModFrameItem4;
	Legacy.UI.SpellMod[5] = LegacyUI_SpellModFrameItem5;
	Legacy.UI.SpellMod[6] = LegacyUI_SpellModFrameItem6;
	Legacy.UI.SpellMod[7] = LegacyUI_SpellModFrameItem7;
	Legacy.UI.SpellMod[8] = LegacyUI_SpellModFrameItem8;
	Legacy.UI.SpellMod[9] = LegacyUI_SpellModFrameItem9;
	
	Legacy.UI.MainFrame = LegacyFrame;
	Legacy.UI.UIFrame = LegacyUI;
	Legacy.UI.Home.Background = LegacyPanelBG;
	Legacy.UI.Home.CharName = LegacyPanelCharName;
	Legacy.UI.Home.Page[0] = LegacyUI_Page0;
	Legacy.UI.Home.Nav[0] = LegacyUI_Nav0;
	Legacy.UI.Home.Page[1] = LegacyUI_Page1;
	Legacy.UI.Home.Nav[1] = LegacyUI_Nav1;
	Legacy.UI.Home.Page[2] = LegacyUI_Page2;
	Legacy.UI.Home.Nav[2] = LegacyUI_Nav2;
	Legacy.UI.Home.Page[3] = LegacyUI_Page3;
	Legacy.UI.Home.Nav[3] = LegacyUI_Nav3;
	Legacy.UI.Home.Page[4] = LegacyUI_Page4;
	Legacy.UI.Home.Nav[4] = LegacyUI_Nav4;
	Legacy.UI.Home.Page[5] = LegacyUI_Page5;
	Legacy.UI.Home.Nav[5] = LegacyUI_Nav5;
	Legacy.UI.Home.Page[6] = LegacyUI_Page6;
	Legacy.UI.Home.Nav[6] = LegacyUI_Nav6;
	Legacy.UI.Home.Page[7] = LegacyUI_Page7;
	Legacy.UI.Home.Nav[7] = LegacyUI_Nav7;
	
	Legacy.UI.Specialty.Stat = LegacyUI_Stat;
	Legacy.UI.Specialty.Armforce = LegacyUI_Specialty1;
	Legacy.UI.Specialty.Instinct = LegacyUI_Specialty2;
	Legacy.UI.Specialty.Willpower = LegacyUI_Specialty3;
	Legacy.UI.Specialty.Sanity = LegacyUI_Specialty4;
	Legacy.UI.Specialty.Pysche = LegacyUI_Specialty5;
	Legacy.UI.Specialty.Trial = LegacyUI_Specialty6;
	
	Legacy.UI.ClassSkill.Stat.Skill = LegacyUI_ClassSkillStat;
	Legacy.UI.ClassSkill.Stat.Memory = LegacyUI_ClassMemoryStat;
	Legacy.UI.ClassSkill.Stat.Spell = LegacyUI_ClassSpellStat;
	
	Legacy.UI.ClassSkill.Skill[1] = LegacyUI_ClassSkill1;
	Legacy.UI.ClassSkill.Skill[2] = LegacyUI_ClassSkill2;
	Legacy.UI.ClassSkill.Skill[3] = LegacyUI_ClassSkill3;
	Legacy.UI.ClassSkill.Skill[4] = LegacyUI_ClassSkill4;
	Legacy.UI.ClassSkill.Skill[5] = LegacyUI_ClassSkill5;
	Legacy.UI.ClassSkill.Skill[6] = LegacyUI_ClassSkill6;
	Legacy.UI.ClassSkill.Skill[7] = LegacyUI_ClassSkill7;
	Legacy.UI.ClassSkill.Skill[8] = LegacyUI_ClassSkill8;
	Legacy.UI.ClassSkill.Skill[9] = LegacyUI_ClassSkill9;
	Legacy.UI.ClassSkill.Skill[10] = LegacyUI_ClassSkill10;
	
	Legacy.UI.ClassSkill.Memory[1] = LegacyUI_ClassMemory1;
	Legacy.UI.ClassSkill.Memory[2] = LegacyUI_ClassMemory2;
	Legacy.UI.ClassSkill.Memory[3] = LegacyUI_ClassMemory3;
	Legacy.UI.ClassSkill.Memory[4] = LegacyUI_ClassMemory4;
	Legacy.UI.ClassSkill.Memory[5] = LegacyUI_ClassMemory5;
	Legacy.UI.ClassSkill.Memory[6] = LegacyUI_ClassMemory6;
	Legacy.UI.ClassSkill.Memory[7] = LegacyUI_ClassMemory7;
	Legacy.UI.ClassSkill.Memory[8] = LegacyUI_ClassMemory8;
	Legacy.UI.ClassSkill.Memory[9] = LegacyUI_ClassMemory9;
	Legacy.UI.ClassSkill.Memory[10] = LegacyUI_ClassMemory10;
	Legacy.UI.ClassSkill.Memory[11] = LegacyUI_ClassMemory11;
	
	Legacy.UI.ClassSkill.Spell[1] = LegacyUI_ClassSpell1;
	Legacy.UI.ClassSkill.Spell[2] = LegacyUI_ClassSpell2;
	Legacy.UI.ClassSkill.Spell[3] = LegacyUI_ClassSpell3;
	Legacy.UI.ClassSkill.Spell[4] = LegacyUI_ClassSpell4;
	Legacy.UI.ClassSkill.Spell[5] = LegacyUI_ClassSpell5;
	Legacy.UI.ClassSkill.Spell[6] = LegacyUI_ClassSpell6;
	Legacy.UI.ClassSkill.Spell[7] = LegacyUI_ClassSpell7;
	Legacy.UI.ClassSkill.Spell[8] = LegacyUI_ClassSpell8;
	Legacy.UI.ClassSkill.Spell[9] = LegacyUI_ClassSpell9;
	Legacy.UI.ClassSkill.Spell[10] = LegacyUI_ClassSpell10;
	
	Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_PREV] = LegacyUI_ClassSkillNavPrev;
	Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_NEXT] = LegacyUI_ClassSkillNavNext;
	Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_PREV] = LegacyUI_ClassMemoryNavPrev;
	Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_NEXT] = LegacyUI_ClassMemoryNavNext;
	Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_PREV] = LegacyUI_ClassSpellNavPrev;
	Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_NEXT] = LegacyUI_ClassSpellNavNext;
	
	Legacy.UI.Rune[0] = {};
	Legacy.UI.Rune[0][1] = _G["LegacyUI_RuneA1"];
	Legacy.UI.Rune[0][2] = _G["LegacyUI_RuneA2"];
	Legacy.UI.Rune[0][3] = LegacyUI_RuneA3;
	Legacy.UI.Rune[0][4] = LegacyUI_RuneA4;
	Legacy.UI.Rune[0][5] = LegacyUI_RuneA5;
	Legacy.UI.Rune[0][6] = LegacyUI_RuneA6;
	Legacy.UI.Rune[0][7] = LegacyUI_RuneA7;
	Legacy.UI.Rune[0][8] = LegacyUI_RuneA8;
	Legacy.UI.Rune[0][9] = LegacyUI_RuneA9;
	Legacy.UI.Rune[0][10] = LegacyUI_RuneA10;
	Legacy.UI.Rune[0][1].Tier = LEGACY_RUNE_TIER0;
	Legacy.UI.Rune[0][2].Tier = LEGACY_RUNE_TIER0;
	Legacy.UI.Rune[0][3].Tier = LEGACY_RUNE_TIER0;
	Legacy.UI.Rune[0][4].Tier = LEGACY_RUNE_TIER0;
	Legacy.UI.Rune[0][5].Tier = LEGACY_RUNE_TIER0;
	Legacy.UI.Rune[0][6].Tier = LEGACY_RUNE_TIER0;
	Legacy.UI.Rune[0][7].Tier = LEGACY_RUNE_TIER0;
	Legacy.UI.Rune[0][8].Tier = LEGACY_RUNE_TIER0;
	Legacy.UI.Rune[0][9].Tier = LEGACY_RUNE_TIER0;
	Legacy.UI.Rune[0][10].Tier = LEGACY_RUNE_TIER0;
	
	Legacy.UI.Rune[1] = {};
	Legacy.UI.Rune[1][1] = LegacyUI_RuneB1;
	Legacy.UI.Rune[1][2] = LegacyUI_RuneB2;
	Legacy.UI.Rune[1][3] = LegacyUI_RuneB3;
	Legacy.UI.Rune[1][4] = LegacyUI_RuneB4;
	Legacy.UI.Rune[1][5] = LegacyUI_RuneB5;
	Legacy.UI.Rune[1][6] = LegacyUI_RuneB6;
	Legacy.UI.Rune[1][7] = LegacyUI_RuneB7;
	Legacy.UI.Rune[1][8] = LegacyUI_RuneB8;
	Legacy.UI.Rune[1][9] = LegacyUI_RuneB9;
	Legacy.UI.Rune[1][10] = LegacyUI_RuneB10;
	Legacy.UI.Rune[1][1].Tier = LEGACY_RUNE_TIER1;
	Legacy.UI.Rune[1][2].Tier = LEGACY_RUNE_TIER1;
	Legacy.UI.Rune[1][3].Tier = LEGACY_RUNE_TIER1;
	Legacy.UI.Rune[1][4].Tier = LEGACY_RUNE_TIER1;
	Legacy.UI.Rune[1][5].Tier = LEGACY_RUNE_TIER1;
	Legacy.UI.Rune[1][6].Tier = LEGACY_RUNE_TIER1;
	Legacy.UI.Rune[1][7].Tier = LEGACY_RUNE_TIER1;
	Legacy.UI.Rune[1][8].Tier = LEGACY_RUNE_TIER1;
	Legacy.UI.Rune[1][9].Tier = LEGACY_RUNE_TIER1;
	Legacy.UI.Rune[1][10].Tier = LEGACY_RUNE_TIER1;
	
	Legacy.UI.Rune[2] = {};
	Legacy.UI.Rune[2][1] = LegacyUI_RuneC1;
	Legacy.UI.Rune[2][2] = LegacyUI_RuneC2;
	Legacy.UI.Rune[2][3] = LegacyUI_RuneC3;
	Legacy.UI.Rune[2][4] = LegacyUI_RuneC4;
	Legacy.UI.Rune[2][5] = LegacyUI_RuneC5;
	Legacy.UI.Rune[2][6] = LegacyUI_RuneC6;
	Legacy.UI.Rune[2][7] = LegacyUI_RuneC7;
	Legacy.UI.Rune[2][8] = LegacyUI_RuneC8;
	Legacy.UI.Rune[2][9] = LegacyUI_RuneC9;
	Legacy.UI.Rune[2][10] = LegacyUI_RuneC10;
	Legacy.UI.Rune[2][1].Tier = LEGACY_RUNE_TIER2;
	Legacy.UI.Rune[2][2].Tier = LEGACY_RUNE_TIER2;
	Legacy.UI.Rune[2][3].Tier = LEGACY_RUNE_TIER2;
	Legacy.UI.Rune[2][4].Tier = LEGACY_RUNE_TIER2;
	Legacy.UI.Rune[2][5].Tier = LEGACY_RUNE_TIER2;
	Legacy.UI.Rune[2][6].Tier = LEGACY_RUNE_TIER2;
	Legacy.UI.Rune[2][7].Tier = LEGACY_RUNE_TIER2;
	Legacy.UI.Rune[2][8].Tier = LEGACY_RUNE_TIER2;
	Legacy.UI.Rune[2][9].Tier = LEGACY_RUNE_TIER2;
	Legacy.UI.Rune[2][10].Tier = LEGACY_RUNE_TIER2;
	
	Legacy.UI.Guild.RankIndicator[1] = LegacyUI_GuildRankIndicatorLeft;
	Legacy.UI.Guild.RankIndicator[2] = LegacyUI_GuildRankIndicatorRight;
	Legacy.UI.Guild.RankProgress[1] = LegacyUI_GuildProgress1;
	Legacy.UI.Guild.RankProgress[2] = LegacyUI_GuildProgress2;
	Legacy.UI.Guild.RankProgress[3] = LegacyUI_GuildProgress3;
	Legacy.UI.Guild.RankProgress[4] = LegacyUI_GuildProgress4;
	Legacy.UI.Guild.RankProgress[5] = LegacyUI_GuildProgress5;
	Legacy.UI.Guild.RankProgress[6] = LegacyUI_GuildProgress6;
	Legacy.UI.Guild.RankProgress[7] = LegacyUI_GuildProgress7;
	Legacy.UI.Guild.RankProgress[8] = LegacyUI_GuildProgress8;
	Legacy.UI.Guild.RankProgress[9] = LegacyUI_GuildProgress9;
	Legacy.UI.Guild.RankProgress[10] = LegacyUI_GuildProgress10;
	Legacy.UI.Guild.Bonus[1] = LegacyUI_GuildBonus1;
	Legacy.UI.Guild.Bonus[2] = LegacyUI_GuildBonus2;
	Legacy.UI.Guild.Bonus[3] = LegacyUI_GuildBonus3;
	Legacy.UI.Guild.Bonus[4] = LegacyUI_GuildBonus4;
	Legacy.UI.Guild.Bonus[5] = LegacyUI_GuildBonus5;
	Legacy.UI.Guild.Bonus[6] = LegacyUI_GuildBonus6;
	Legacy.UI.Guild.Bonus[7] = LegacyUI_GuildBonus7;
	Legacy.UI.Guild.Bonus[8] = LegacyUI_GuildBonus8;
	Legacy.UI.Guild.Bonus[9] = LegacyUI_GuildBonus9;
	Legacy.UI.Guild.BonusSelectionFrame = LegacyUI_GuildBonusSelectionFrame;
	Legacy.UI.Guild.BonusSelection[1] = LegacyUI_ReplacableGuildBonusFrameAbility1;
	Legacy.UI.Guild.BonusSelection[2] = LegacyUI_ReplacableGuildBonusFrameAbility2;
	Legacy.UI.Guild.BonusSelection[3] = LegacyUI_ReplacableGuildBonusFrameAbility3;
	Legacy.UI.Guild.BonusSelection[4] = LegacyUI_ReplacableGuildBonusFrameAbility4;
	Legacy.UI.Guild.BonusSelection[5] = LegacyUI_ReplacableGuildBonusFrameAbility5;
	Legacy.UI.Guild.BonusSelection[6] = LegacyUI_ReplacableGuildBonusFrameAbility6;
	Legacy.UI.Guild.BonusSelection[7] = LegacyUI_ReplacableGuildBonusFrameAbility7;
	
	Legacy.UI.Market.Item[1] = LegacyUI_MarketItem1;
	Legacy.UI.Market.Item[2] = LegacyUI_MarketItem2;
	Legacy.UI.Market.Item[3] = LegacyUI_MarketItem3;
	Legacy.UI.Market.Item[4] = LegacyUI_MarketItem4;
	Legacy.UI.Market.Item[5] = LegacyUI_MarketItem5;
	Legacy.UI.Market.Item[6] = LegacyUI_MarketItem6;
	Legacy.UI.Market.Item[7] = LegacyUI_MarketItem7;
	Legacy.UI.Market.Item[8] = LegacyUI_MarketItem8;
	Legacy.UI.Market.Item[9] = LegacyUI_MarketItem9;
	Legacy.UI.Market.Item[10] = LegacyUI_MarketItem10;
	Legacy.UI.Market.Item[11] = LegacyUI_MarketItem11;
	for i = 1, 11 do
		Legacy.UI.Market.Item[i].Type = LEGACY_MARKET_TYPE_ITEM;
	end
	
	Legacy.UI.Market.Buff[1] = LegacyUI_MarketBuff1;
	Legacy.UI.Market.Buff[2] = LegacyUI_MarketBuff2;
	Legacy.UI.Market.Buff[3] = LegacyUI_MarketBuff3;
	Legacy.UI.Market.Buff[4] = LegacyUI_MarketBuff4;
	Legacy.UI.Market.Buff[5] = LegacyUI_MarketBuff5;
	Legacy.UI.Market.Buff[6] = LegacyUI_MarketBuff6;
	Legacy.UI.Market.Buff[7] = LegacyUI_MarketBuff7;
	Legacy.UI.Market.Buff[8] = LegacyUI_MarketBuff8;
	Legacy.UI.Market.Buff[9] = LegacyUI_MarketBuff9;
	Legacy.UI.Market.Buff[10] = LegacyUI_MarketBuff10;
	Legacy.UI.Market.Buff[11] = LegacyUI_MarketBuff11;
	Legacy.UI.Market.Buff[12] = LegacyUI_MarketBuff12;
	for i = 1, 12 do
		Legacy.UI.Market.Buff[i].Type = LEGACY_MARKET_TYPE_BUFF;
	end
	
	Legacy.UI.Market.Spell[1] = LegacyUI_MarketSpell1;
	Legacy.UI.Market.Spell[2] = LegacyUI_MarketSpell2;
	Legacy.UI.Market.Spell[3] = LegacyUI_MarketSpell3;
	Legacy.UI.Market.Spell[4] = LegacyUI_MarketSpell4;
	Legacy.UI.Market.Spell[5] = LegacyUI_MarketSpell5;
	Legacy.UI.Market.Spell[6] = LegacyUI_MarketSpell6;
	Legacy.UI.Market.Spell[7] = LegacyUI_MarketSpell7;
	Legacy.UI.Market.Spell[8] = LegacyUI_MarketSpell8;
	Legacy.UI.Market.Spell[9] = LegacyUI_MarketSpell9;
	Legacy.UI.Market.Spell[10] = LegacyUI_MarketSpell10;
	Legacy.UI.Market.Spell[11] = LegacyUI_MarketSpell11;
	for i = 1, 11 do
		Legacy.UI.Market.Spell[i].Type = LEGACY_MARKET_TYPE_SPELL;
	end
	
	Legacy.UI.Market.Nav.Item[LEGACY_NAV_PREV] = LegacyUI_MarketItemNavLeft;
	Legacy.UI.Market.Nav.Item[LEGACY_NAV_NEXT] = LegacyUI_MarketItemNavRight;
	Legacy.UI.Market.Nav.Buff[LEGACY_NAV_PREV] = LegacyUI_MarketBuffNavLeft;
	Legacy.UI.Market.Nav.Buff[LEGACY_NAV_NEXT] = LegacyUI_MarketBuffNavRight;
	Legacy.UI.Market.Nav.Spell[LEGACY_NAV_PREV] = LegacyUI_MarketSpellNavLeft;
	Legacy.UI.Market.Nav.Spell[LEGACY_NAV_NEXT] = LegacyUI_MarketSpellNavRight;
	Legacy.UI.Market.Nav.Item[LEGACY_NAV_PREV].Type = LEGACY_MARKET_TYPE_ITEM;
	Legacy.UI.Market.Nav.Item[LEGACY_NAV_NEXT].Type = LEGACY_MARKET_TYPE_ITEM;
	Legacy.UI.Market.Nav.Buff[LEGACY_NAV_PREV].Type = LEGACY_MARKET_TYPE_BUFF;
	Legacy.UI.Market.Nav.Buff[LEGACY_NAV_NEXT].Type = LEGACY_MARKET_TYPE_BUFF;
	Legacy.UI.Market.Nav.Spell[LEGACY_NAV_PREV].Type = LEGACY_MARKET_TYPE_SPELL;
	Legacy.UI.Market.Nav.Spell[LEGACY_NAV_NEXT].Type = LEGACY_MARKET_TYPE_SPELL;
	
	Legacy.UI.Transmog.SlotFrame = LegacyUI_Transmog;
	Legacy.UI.Transmog.CollFrame = LegacyUI_TransmogItems;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_HEAD] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_SHOULDERS] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_SHIRT] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_CHEST] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_WAIST] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_LEGS] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_FEET] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_WRIST] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_HANDS] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_BACK] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_MAINHAND] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_OFFHAND] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Slot[LEGACY_EQUIP_SLOT_RANGED] = LegacyUI_TransmogSlotItem1;
	Legacy.UI.Transmog.Item[0] = LegacyUI_TransmogItem0;
	Legacy.UI.Transmog.Item[1] = LegacyUI_TransmogItem1;
	Legacy.UI.Transmog.Item[2] = LegacyUI_TransmogItem2;
	Legacy.UI.Transmog.Item[3] = LegacyUI_TransmogItem3;
	Legacy.UI.Transmog.Item[4] = LegacyUI_TransmogItem4;
	Legacy.UI.Transmog.Item[5] = LegacyUI_TransmogItem5;
	Legacy.UI.Transmog.Item[6] = LegacyUI_TransmogItem6;
	Legacy.UI.Transmog.Item[7] = LegacyUI_TransmogItem7;
	Legacy.UI.Transmog.Item[8] = LegacyUI_TransmogItem8;
	Legacy.UI.Transmog.Item[9] = LegacyUI_TransmogItem9;
	Legacy.UI.Transmog.Item[10] = LegacyUI_TransmogItem10;
	Legacy.UI.Transmog.Item[11] = LegacyUI_TransmogItem11;
	Legacy.UI.Transmog.Nav[LEGACY_NAV_PREV] = LegacyUI_TransmogNavItem1;
	Legacy.UI.Transmog.Nav[LEGACY_NAV_NEXT] = LegacyUI_TransmogNavItem2;
	
	Legacy.UI.Reputation.Reward[1] = LegacyUI_ReputationReward1;
	Legacy.UI.Reputation.Reward[2] = LegacyUI_ReputationReward2;
	Legacy.UI.Reputation.Reward[3] = LegacyUI_ReputationReward3;
	Legacy.UI.Reputation.Reward[4] = LegacyUI_ReputationReward4;
	Legacy.UI.Reputation.Reward[5] = LegacyUI_ReputationReward5;
	Legacy.UI.Reputation.Reward[6] = LegacyUI_ReputationReward6;
	Legacy.UI.Reputation.Reward[7] = LegacyUI_ReputationReward7;
	Legacy.UI.Reputation.Reward[8] = LegacyUI_ReputationReward8;
	Legacy.UI.Reputation.Reward[9] = LegacyUI_ReputationReward9;
	Legacy.UI.Reputation.Reward[10] = LegacyUI_ReputationReward10;
	Legacy.UI.Reputation.Reward[11] = LegacyUI_ReputationReward11;
	for i = 1, 11 do
		Legacy.UI.Reputation.Reward[i].Type = LEGACY_REPUTATION_TYPE_REWARD;
	end
	
	Legacy.UI.Reputation.Item[1] = LegacyUI_ReputationItem1;
	Legacy.UI.Reputation.Item[2] = LegacyUI_ReputationItem2;
	Legacy.UI.Reputation.Item[3] = LegacyUI_ReputationItem3;
	Legacy.UI.Reputation.Item[4] = LegacyUI_ReputationItem4;
	Legacy.UI.Reputation.Item[5] = LegacyUI_ReputationItem5;
	Legacy.UI.Reputation.Item[6] = LegacyUI_ReputationItem6;
	Legacy.UI.Reputation.Item[7] = LegacyUI_ReputationItem7;
	Legacy.UI.Reputation.Item[8] = LegacyUI_ReputationItem8;
	Legacy.UI.Reputation.Item[9] = LegacyUI_ReputationItem9;
	Legacy.UI.Reputation.Item[10] = LegacyUI_ReputationItem10;
	Legacy.UI.Reputation.Item[11] = LegacyUI_ReputationItem11;
	for i = 1, 11 do
		Legacy.UI.Reputation.Item[i].Type = LEGACY_REPUTATION_TYPE_ITEM;
	end
	
	Legacy.UI.Reputation.Spell[1] = LegacyUI_ReputationSpell1;
	Legacy.UI.Reputation.Spell[2] = LegacyUI_ReputationSpell2;
	Legacy.UI.Reputation.Spell[3] = LegacyUI_ReputationSpell3;
	Legacy.UI.Reputation.Spell[4] = LegacyUI_ReputationSpell4;
	Legacy.UI.Reputation.Spell[5] = LegacyUI_ReputationSpell5;
	Legacy.UI.Reputation.Spell[6] = LegacyUI_ReputationSpell6;
	Legacy.UI.Reputation.Spell[7] = LegacyUI_ReputationSpell7;
	Legacy.UI.Reputation.Spell[8] = LegacyUI_ReputationSpell8;
	Legacy.UI.Reputation.Spell[9] = LegacyUI_ReputationSpell9;
	Legacy.UI.Reputation.Spell[10] = LegacyUI_ReputationSpell10;
	Legacy.UI.Reputation.Spell[11] = LegacyUI_ReputationSpell11;
	for i = 1, 11 do
		Legacy.UI.Reputation.Spell[i].Type = LEGACY_REPUTATION_TYPE_SPELL;
	end
	
	Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_PREV] = LegacyUI_ReputationRewardNavLeft;
	Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_NEXT] = LegacyUI_ReputationRewardNavRight;
	Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_PREV] = LegacyUI_ReputationItemNavLeft;
	Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_NEXT] = LegacyUI_ReputationItemNavRight;
	Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_PREV] = LegacyUI_ReputationSpellNavLeft;
	Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_NEXT] = LegacyUI_ReputationSpellNavRight;
	Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_PREV].Type = LEGACY_REPUTATION_TYPE_REWARD;
	Legacy.UI.Reputation.Nav.Reward[LEGACY_NAV_NEXT].Type = LEGACY_REPUTATION_TYPE_REWARD;
	Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_PREV].Type = LEGACY_REPUTATION_TYPE_ITEM;
	Legacy.UI.Reputation.Nav.Item[LEGACY_NAV_NEXT].Type = LEGACY_REPUTATION_TYPE_ITEM;
	Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_PREV].Type = LEGACY_REPUTATION_TYPE_SPELL;
	Legacy.UI.Reputation.Nav.Spell[LEGACY_NAV_NEXT].Type = LEGACY_REPUTATION_TYPE_SPELL;
	
	for i = 1, 36 do
		Legacy.UI.ActivationKey[i] = _G["LegacyUI_ActivationKey"..i];
	end
	
	for i = 1, 36 do
		Legacy.UI.Legacy.Item[i] = _G["LegacyUI_LegacyItem"..i];
	end
	Legacy.UI.Legacy.Nav[LEGACY_NAV_PREV] = LegacyUI_LegacyItemNavLeft;
	Legacy.UI.Legacy.Nav[LEGACY_NAV_NEXT] = LegacyUI_LegacyItemNavRight;

    local _, cl = UnitClass("player");
	Legacy.UI.Home.Background:SetTexture("Interface\\Addons\\LegacyPanel\\Asset\\Image\\BG\\LegacyPanel_BG_GrayScaled_"..cl);
    Legacy.UI.Home.Background:SetVertexColor(LEGACY_CLASS_COLOR[cl].r, LEGACY_CLASS_COLOR[cl].g, LEGACY_CLASS_COLOR[cl].b, 0.5);
	Legacy.UI.Home.CharName:SetText(UnitName("player"));
	
	LegacyPanel_SelectDefaultClassSkill();
end

function LegacyPanel_InitToken(self)
    self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    local name = self:GetName();
    self.Id = self:GetID();
	self.Icon = _G[name .. "Icon"];
	self.Border = _G[name .. "Border"];
	self.Highlight = _G[name .. "Highlight"];
    self.Title = _G[name.."Title"];
    self.Desc = _G[name.."Desc"];
end

function LegacyPanel_Navigate(prev, current)
    Legacy.UI.PrevFrame = prev;
    Legacy.UI.CurFrame = current;
    if (prev ~= nil) then prev:Hide(); end
    if (current ~= nil) then current:SetFrameStrata("HIGH"); current:Show(); end
end

function LegacyPanel_NavigateBack()
    if (Legacy.UI.PrevFrame ~= nil) then
        Legacy.UI.PrevFrame:Show();
    end

    if (Legacy.UI.CurFrame ~= nil) then
        Legacy.UI.CurFrame:Hide();
    end

    Legacy.UI.PrevFrame = Legacy.UI.CurFrame;
    Legacy.UI.CurFrame = nil;
end


