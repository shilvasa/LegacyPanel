LegacyPanel = {
    ActiveAbilityFrame = nil,
    ActiveAbilityItem = {},
    PassiveAbilityFrame = nil,
    PassiveAbilityItem = {},
    StatAbilityFrame = nil,
    StatAbilityItem = {},
    ReplacableAbilityFrame = nil,
    ReplacableAbilityItem = {},
    AbilityUpgradeFrame = nil,
    AbilityUpgradeItem = {},
    AbilityItemTarget = nil,
    PreviousFrame = nil,
    CurrentFrame = nil,
    GPItem = nil,
    TalentAbilityFrame = nil,
    TalentAbilityItem = {},
	ReplacableGuildBonusFrame = nil,
    Nav = {},
    Page = {},
    SelectedPage = 1,
    LegacyItem = {},
	MarketItem = {},
	RewardItem = {},
	ActivationKey = {},
	LegacyItemPage = 0,
	MarketItemPage = 0,
	MarketSpellPage = 0,
	RewardItemPage = 0,
	ReputationItemPage = 0,
	ReputationSpellPage = 0,
	LegacyItemNavButton = {},
	MarketItemNavButton = {},
	MarketSpellNavButton = {},
	RewardItemNavButton = {},
	ReputationItemNavButton = {},
	ReputationSpellNavButton = {},
	GuildUI =
	{
		RankIndicator = {},
		RankProgress = {},
		Bonus = {},
		BonusReplacer = {},
	},
	UI = 
	{
		ActionButton = {},
	},
	TransmogSlotFrame = nil,
	TransmogItemFrame = nil,
	TransmogSlot = {},
	TransmogItem = {},
	TransmogNavButton = {},
	Transmogs = {
		[0] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
		[6] = 0,
		[7] = 0,
		[8] = 0,
		[9] = 0,
		[14] = 0,
		[15] = 0,
		[16] = 0,
		[17] = 0
	},
	TransmogCollections = {
		[LEGACY_TRANSMOG_SLOT_HEAD_CLOTH] = 0,
		[LEGACY_TRANSMOG_SLOT_SHOULDER_CLOTH] = 0,
		[LEGACY_TRANSMOG_SLOT_CHEST_CLOTH] = 0,
		[LEGACY_TRANSMOG_SLOT_WRIST_CLOTH] = 0,
		[LEGACY_TRANSMOG_SLOT_HAND_CLOTH] = 0,
		[LEGACY_TRANSMOG_SLOT_WAIST_CLOTH] = 0,
		[LEGACY_TRANSMOG_SLOT_LEG_CLOTH] = 0,
		[LEGACY_TRANSMOG_SLOT_FEET_CLOTH] = 0,
		[LEGACY_TRANSMOG_SLOT_HEAD_LIGHT] = 0,
		[LEGACY_TRANSMOG_SLOT_SHOULDER_LIGHT] = 0,
		[LEGACY_TRANSMOG_SLOT_CHEST_LIGHT] = 0,
		[LEGACY_TRANSMOG_SLOT_WRIST_LIGHT] = 0,
		[LEGACY_TRANSMOG_SLOT_HAND_LIGHT] = 0,
		[LEGACY_TRANSMOG_SLOT_WAIST_LIGHT] = 0,
		[LEGACY_TRANSMOG_SLOT_LEG_LIGHT] = 0,
		[LEGACY_TRANSMOG_SLOT_FEET_LIGHT] = 0,
		[LEGACY_TRANSMOG_SLOT_HEAD_CHAIN] = 0,
		[LEGACY_TRANSMOG_SLOT_SHOULDER_CHAIN] = 0,
		[LEGACY_TRANSMOG_SLOT_CHEST_CHAIN] = 0,
		[LEGACY_TRANSMOG_SLOT_WRIST_CHAIN] = 0,
		[LEGACY_TRANSMOG_SLOT_HAND_CHAIN] = 0,
		[LEGACY_TRANSMOG_SLOT_WAIST_CHAIN] = 0,
		[LEGACY_TRANSMOG_SLOT_LEG_CHAIN] = 0,
		[LEGACY_TRANSMOG_SLOT_FEET_CHAIN] = 0,
		[LEGACY_TRANSMOG_SLOT_HEAD_HEAVY] = 0,
		[LEGACY_TRANSMOG_SLOT_SHOULDER_HEAVY] = 0,
		[LEGACY_TRANSMOG_SLOT_CHEST_HEAVY] = 0,
		[LEGACY_TRANSMOG_SLOT_WRIST_HEAVY] = 0,
		[LEGACY_TRANSMOG_SLOT_HAND_HEAVY] = 0,
		[LEGACY_TRANSMOG_SLOT_WAIST_HEAVY] = 0,
		[LEGACY_TRANSMOG_SLOT_LEG_HEAVY] = 0,
		[LEGACY_TRANSMOG_SLOT_FEET_HEAVY] = 0,
		[LEGACY_TRANSMOG_SLOT_CLOAK] = 0,
		[LEGACY_TRANSMOG_SLOT_M_WEAPON_1H_SWORD] = 0,
		[LEGACY_TRANSMOG_SLOT_M_WEAPON_1H_AXE] = 0,
		[LEGACY_TRANSMOG_SLOT_M_WEAPON_1H_MACE] = 0,
		[LEGACY_TRANSMOG_SLOT_M_WEAPON_1H_DAGGER] = 0,
		[LEGACY_TRANSMOG_SLOT_M_WEAPON_2H_SWORD] = 0,
		[LEGACY_TRANSMOG_SLOT_M_WEAPON_2H_AXE] = 0,
		[LEGACY_TRANSMOG_SLOT_M_WEAPON_2H_MACE] = 0,
		[LEGACY_TRANSMOG_SLOT_M_WEAPON_2H_POLEARM] = 0,
		[LEGACY_TRANSMOG_SLOT_R_WEAPON_BOW] = 0,
		[LEGACY_TRANSMOG_SLOT_R_WEAPON_CROSSBOW] = 0,
		[LEGACY_TRANSMOG_SLOT_R_WEAPON_GUN] = 0,
		[LEGACY_TRANSMOG_SLOT_O_SHIELD] = 0,
		[LEGACY_TRANSMOG_SLOT_O_HOLDABLE] = 0,
		[LEGACY_TRANSMOG_SLOT_M_WEAPON_2H_STAFF] = 0,
		[LEGACY_TRANSMOG_SLOT_R_WEAPON_WAND] = 0,
		[LEGACY_TRANSMOG_SLOT_O_WEAPON_1H_SWORD] = 0,
		[LEGACY_TRANSMOG_SLOT_O_WEAPON_1H_AXE] = 0,
		[LEGACY_TRANSMOG_SLOT_O_WEAPON_1H_MACE] = 0,
		[LEGACY_TRANSMOG_SLOT_O_WEAPON_1H_DAGGER] = 0,
	},
	TransmogQualityCache = {},
	SelectedTransmogSlot = -1,
	TransmogItemPage = 1,
};

Legacy = {
    Data = {
        MF = 0,
        ActiveSpells = {
            [1] = 0,
            [2] = 0,
            [3] = 0,
            [4] = 0,
            [5] = 0,
            [6] = 0,
            [7] = 0,
            [8] = 0,
            [9] = 0,
            [10] = 0,
        },
        PassiveSpells = {
            [1] = 0,
            [2] = 0,
            [3] = 0,
            [4] = 0,
            [5] = 0,
            [6] = 0,
            [7] = 0,
            [8] = 0,
            [9] = 0,
            [10] = 0,
        },
        TalentSpells = {
            [1] = 0,
            [2] = 0,
            [3] = 0,
            [4] = 0,
            [5] = 0,
            [6] = 0,
            [7] = 0,
            [8] = 0,
            [9] = 0,
            [10] = 0,
        },
		LegacyItems = {},
		ReputationItems = {},
		ReputationSpells = {},
		MarketItems = {},
		MarketSpells = {},
		MarketBuffs = {},
		PossessedMarketSpells = {},
		PossessedMarketBuffs = {},
		RewardItems = {},
		ActivationKeys = {},
        UnlockedSpells = {},
        UpgradedSpellMods = {},
        Rewards = {
            Count = 0,
        },
		Account = {
			Currency = 0,
			Level = 0,
			Rank = 0,
		},
		Guild = 
		{
			Rank = 0,
			XP = 0,
			XPToNextLevel = 0,
			Bonus = {
			},
		},
		GoldRatio = 0,
    },
    Conf = {
        MaxLevel = 0,
        GPForNextLevel = 0,
    },
};

LegacyCharInfo =
{
    GP = {
        Total = 0,
        Cost = 0,
        Available = 0,
    },
	TP = {
		Total = 0,
		Cost = 0,
		Available = 0,
	},
	Spell = {
		ActiveCount = 0,
		PassiveCount = 0,
		TalentCount = 0,
	},
    SpecialtyStats = {
        [1] = { Point = 0, Cap = 0 },
        [2] = { Point = 0, Cap = 0 },
        [3] = { Point = 0, Cap = 0 },
        [4] = { Point = 0, Cap = 0 },
        [5] = { Point = 0, Cap = 0 },
        [6] = { Point = 0, Cap = 0 }
    },
	MF = {
		Level = 0,
		SLevel = 0,
		Cap = 0,
		State = 0,
	},
};

FRESH_RUN = true;
