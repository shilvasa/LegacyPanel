SLASH_LEGACY_PANEL1, SLASH_LEGACY_PANEL2 = "/lp", "/legacypanel";
local function CmdHandler(msg, editbox)
	if (msg == "") then
		LegacyPanel_Toggle();
	end
end

SlashCmdList["LEGACY_PANEL"] = CmdHandler;

function LegacyPanel_OnLoad(self)
    tinsert(UISpecialFrames, "LegacyFrame");
	self:RegisterEvent("CHAT_MSG_ADDON");
	self:RegisterEvent("ADDON_LOADED");
	self:RegisterEvent("PLAYER_LEVEL_UP");
	self:RegisterEvent("GET_ITEM_INFO_RECEIVED");
    LegacyPanel_HookItemTooltip(GameTooltip);
    LegacyPanel_HookItemTooltip(ItemRefTooltip);
	Dev_HookNpcTooltip(GameTooltip);

    local _, cl = UnitClass("player");
	LegacyPanelBG:SetTexture("Interface\\Addons\\LegacyPanel\\Asset\\Image\\BG\\LegacyPanel_BG_GrayScaled_"..cl);
    LegacyPanelBG:SetVertexColor(LegacyClassColor[cl].r, LegacyClassColor[cl].g, LegacyClassColor[cl].b, 0.5);
	LegacyPanelCharName:SetText(UnitName("player"));
    LegacyPanel.MainFrame = LegacyUI;
	LegacyPanel.TitleFrame = LegacyTitleFrame;
    LegacyPanel.Page[1] = LegacyUI_Page1;
    LegacyPanel.Page[2] = LegacyUI_Page2;
    LegacyPanel.Page[3] = LegacyUI_Page3;
	LegacyPanel.Page[4] = LegacyUI_Page4;
	LegacyPanel.Page[5] = LegacyUI_Page5;
	LegacyPanel.Page[6] = LegacyUI_Page6;
	LegacyPanel.Page[7] = LegacyUI_Page7;
    LegacyPanel.ActiveAbilityFrame = LegacyUI_Active;
    LegacyPanel.PassiveAbilityFrame = LegacyUI_Passive;
    LegacyPanel.StatAbilityFrame = LegacyUI_Stat;
    LegacyPanel.ReplacableAbilityFrame = LegacyUI_ReplacableAbilityFrame;
    LegacyPanel.AbilityUpgradeFrame = LegacyUI_AbilityUpgradeFrame;
    LegacyPanel.TalentAbilityFrame = LegacyUI_Talent;
	LegacyPanel.ReplacableGuildBonusFrame = LegacyUI_ReplacableGuildBonusFrame;
	LegacyPanel.TransmogSlotFrame = LegacyUI_Transmog;
	LegacyPanel.TransmogItemFrame = LegacyUI_TransmogItems;
	
	LegacyPanel.UI.ActionButton[1] = _G["ActionButton1"];
	LegacyPanel.UI.ActionButton[2] = _G["ActionButton2"];
	LegacyPanel.UI.ActionButton[3] = _G["ActionButton3"];
	LegacyPanel.UI.ActionButton[4] = _G["ActionButton4"];
	LegacyPanel.UI.ActionButton[5] = _G["ActionButton5"];
	LegacyPanel.UI.ActionButton[6] = _G["ActionButton6"];
	LegacyPanel.UI.ActionButton[7] = _G["ActionButton7"];
	LegacyPanel.UI.ActionButton[8] = _G["ActionButton8"];
	LegacyPanel.UI.ActionButton[9] = _G["ActionButton9"];
	LegacyPanel.UI.ActionButton[10] = _G["ActionButton10"];
	LegacyPanel.UI.ActionButton[11] = _G["ActionButton11"];
	LegacyPanel.UI.ActionButton[12] = _G["ActionButton12"];
	
	LegacyPanel_InitUI();
end

function LegacyPanel_ProcessAddonMessage(prefix, msg)
	local action = Legacy_GetAction(prefix);
    if (LEGACY_DEBUG) then
	    print("|cff00ff00RECEIVED:|r ".."\n PREFIX:"..prefix.."\n MSG:"..msg.."\n ACTION:");
    end
	
	if (action == LMSG_Q_STATS) then
		LegacyPanel_ProcessStatInfo(msg);
	elseif (action == LMSG_Q_GP) then
		LegacyPanel_ProcessGPInfo(msg);
    elseif (action == LMSG_Q_GP_FOR_NEXT_LEVEL) then
        LegacyPanel_ProcessGrowthPointToNextLevel(msg);
    elseif (action == LMSG_Q_MF_RATE) then
        LegacyPanel_ProcMFInfo(msg);
    elseif (action == LMSG_Q_REWARD_COUNT) then
        LegacyPanel_ProcessRewardCount(msg);
    elseif (action == LMSG_Q_REWARD_INFO) then
        LegacyPanel_ProcRewardInfo(msg);
    elseif (action == LMSG_Q_SPELLMOD_INFO) then
        LegacyPanel_ProcessUpgradedSpellModInfo(msg);
    elseif (action == LMSG_Q_ACTIVE_SPELL_INFO) then
        LegacyPanel_ProcActiveSpellInfo(msg);
    elseif (action == LMSG_Q_PASSIVE_SPELL_INFO) then
        LegacyPanel_ProcPassiveSpellInfo(msg);
    elseif (action == LMSG_Q_UNLOCKED_SPELL_INFO) then
        LegacyPanel_ProcUnlockedSpellInfo(msg);
    elseif (action == LMSG_Q_TALENT_SPELL_INFO) then
        LegacyPanel_ProcTalentSpellInfo(msg);
	elseif (action == LMSG_Q_LEGACY_ITEM_INFO) then
		LegacyPanel_ProcLegacyItemInfo(msg);
	elseif (action == LMSG_Q_MARKET_ITEM_INFO) then
		LegacyPanel_ProcMarketItemInfo(msg);
	elseif (action == LMSG_NOTIFY) then
		LegacyPanel_ProcNotification(msg);
	elseif (action == LMSG_Q_ACCOUNT_INFO) then
		LegacyPanel_ProcAccountInfo(msg);
	elseif (action == LMSG_Q_GUILD_RANK_INFO) then
		LegacyPanel_ProcGuildRankInfo(msg);
	elseif (action == LMSG_A_REQUEST_GUILD_SPELL) then
		LegacyPanel_ProcGuildSpellInfo(msg);
	elseif (action == LMSG_Q_GUILD_BONUS_INFO) then
		LegacyPanel_ProcGuildBonusInfo(msg);
	elseif (action == LMSG_Q_GOLD_RATIO) then
		LegacyPanel_ProcUpdateGoldRatio(msg);
	elseif (action == LMSG_Q_UNLOCKED_SPELL_COUNT) then
		LegacyPanel_ProcUpdateUnlockedSpellCount(msg);
	elseif (action == LMSG_Q_TRANSMOGS) then
		LegacyPanel_ProcTransmogInfo(msg);
	elseif (action == LMSG_Q_TRANSMOG_COLLECTIONS) then
		LegacyPanel_ProcTransmogCollectionInfo(msg);
	elseif (action == LMSG_Q_POSSESSED_MARKET_SPELLS) then
		LegacyPanel_ProcMarketSpellPossessionInfo(msg);
	elseif (action == LMSG_Q_MARKET_SPELL_INFO) then
		LegacyPanel_ProcMarketSpellInfo(msg);
	elseif (action == LMSG_Q_REPUTATION_ITEM_INFO) then
		LegacyPanel_ProcReputationItemInfo(msg);
	elseif (action == LMSG_Q_REPUTATION_SPELL_INFO) then
		LegacyPanel_ProcReputationSpellInfo(msg);
	elseif (action == LMSG_Q_TRANSMOG_COLLECTION_SLOT) then
		LegacyPanel_ProcTransmogCollectionSlot(msg);
	elseif (action == LMSG_Q_TRANSMOG_SLOT) then
		LegacyPanel_ProcTransmogSlot(msg);
	elseif (action == LMSG_MSG) then
		LegacyPanel_ProcMsg(msg);
	elseif (action == LMSG_Q_ACTIVATION_KEY) then
		LegacyPanel_ProcActivationKey(msg);
	elseif (action == LMSG_Q_MARKET_BUFF_DATA) then
		LegacyPanel_ProcPossessedMarketBuffInfo(msg);
	elseif (action == LMSG_Q_MARKET_BUFF_INFO) then
		LegacyPanel_ProcMarketBuffInfo(msg);
	end
end

function LegacyPanel_OnEvent(self, event, ...)
	local addon = ...;
	if (event == "ADDON_LOADED" and ... == "LegacyPanel") then
        -- //
	elseif (event == "CHAT_MSG_ADDON") then
		local prefix, msg, channel, target = ...;
		LegacyPanel_ProcessAddonMessage(prefix, msg);
	elseif (event == "PLAYER_LEVEL_UP") then
        local level, _, _, _, _, _, _, _, _ = ...;
        LegacyPanel_UpdateSpells(level);
	elseif (event == "GET_ITEM_INFO_RECEIVED") then
		--print("received something new.");
    end
end

function LegacyPanel_Toggle(self, button)
    if (LegacyFrame:IsShown()) then
        LegacyFrame:Hide();
    else
        if (FRESH_RUN) then -- do initial queries here
            LegacyPanel_DoInitialQueries();
            FRESH_RUN = false;
        end
        LegacyFrame:Show();
		LegacyFrame:SetFrameStrata("HIGH");
		LegacyPanel.MainFrame:SetFrameStrata("HIGH");
    end
end
