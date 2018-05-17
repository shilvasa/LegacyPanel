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
	LegacyPanel_HookSpellTooltip(GameTooltip);
	Dev_HookNpcTooltip(GameTooltip);
	LegacyPanel_InitUI();
end

function LegacyPanel_OnShow()
    PlaySound("Glyph_MinorCreate");
    Legacy.UI.Home.CharName:Show();
end

function LegacyPanel_OnHide()
    PlaySound("Glyph_MinorDestroy");
    Legacy.UI.Home.CharName:Hide();
	Legacy.UI.UIFrame:Hide();
end

function LegacyPanel_ProcessAddonMessage(prefix, msg)
	local action = Legacy_GetAction(prefix);
    if (LEGACY_DEBUG) then
	    print("|cff00ff00RECEIVED:|r ".."\n PREFIX:"..prefix.."\n MSG:"..msg.."\n ACTION:");
    end
	
	Legacy_ParseQuery(action, msg);
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

function LegacyPanel_Show(frame)
	frame:SetFrameStrata("HIGH");
	frame:Show();
end

function LegacyPanel_Hide(frame)
	frame:Hide();
end

function LegacyPanel_ShowMainFrame()
	LegacyPanel_Show(Legacy.UI.MainFrame);
	LegacyPanel_Show(Legacy.UI.UIFrame);
end

function LegacyPanel_HideMainFrame()
	LegacyPanel_Hide(Legacy.UI.MainFrame);
	LegacyPanel_Hide(Legacy.UI.UIFrame);
end

function LegacyPanel_Toggle(self, button)
    if (Legacy.UI.MainFrame:IsShown()) then
        Legacy.UI.MainFrame:Hide();
		Legacy.UI.UIFrame:Hide();
    else
        if (FRESH_RUN) then -- do initial queries here
            LegacyPanel_DoInitialQueries();
            FRESH_RUN = false;
        end
        Legacy.UI.MainFrame:Show();
		Legacy.UI.UIFrame:Show();
    end
end
