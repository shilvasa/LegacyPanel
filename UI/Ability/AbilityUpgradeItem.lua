function LegacyPanel_OnLoadAbilityUpgradeItem(self)
	LegacyPanel_InitializeAbilityItem(self);
    LegacyPanel.AbilityUpgradeItem[self.id] = self;
	if (self.id ~= 1) then
		self.icon:SetSize(45, 45);
		self.icon:SetTexCoord(0, 1, 0, 1);
	end
	self.title:Hide();
	self.desc:SetFontObject("GameFontGreenSmall");
	self.desc:SetPoint("CENTER", self, "CENTER", 0, -15);
end

function LegacyPanel_OnEnterAbilityUpgradeItem(self)
    self.highlight:SetVertexColor(0, 1, 0, 1);
    self.highlight:Show();
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
    if (self.id == 1) then
        GameTooltip:SetHyperlink("spell:"..self.spell);
        if (Legacy_IsSpellUnlocked(self.spell)) then
            GameTooltip:AddLine(LEGACY_ABILITY_RETURN_TO_MAIN_FRAME_HINT);
        else
            self.title:SetText("GP");
            self.desc:SetText(self.gp);
            self.title:Show();
            self.desc:Show();
            GameTooltip:AddDoubleLine(LEGACY_ABILITY_RETURN_TO_MAIN_FRAME_HINT, format(LEGACY_ABILITY_RIGHT_CLICK_TO_LEARN, self.gp));
        end
    else
        LegacyPanel_FormatAbilityUpgradeTooltip(self);
    end
    GameTooltip:Show();
end

function LegacyPanel_OnLeaveAbilityUpgradeItem(self)
	self.highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_FormatAbilityUpgradeTooltip(self)
	GameTooltip:Hide();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	GameTooltip:ClearLines();
    if (Legacy_IsSpellUnlocked(LegacyPanel.AbilityUpgradeItem[1].spell)) then
        local leftTitle = "|cff00ff00"..Legacy_FormatSpellModDesc(self.mod.u, self.mod.v * Legacy_GetLevelForSpellMod(self.mod.i)).."|r"..self.mod.d;
        local rightTitle = nil;
        local level = Legacy_GetLevelForSpellMod(self.mod.i);
        local maxString = self.mod.m;
        if (self.mod.m == 0) then maxString = LEGACY_INFINITE_MARK; end
        if (self.mod.m == 0 or level < self.mod.m) then
            rightTitle = format(LEGACY_ABILITY_UPGRADE_LEVEL_FORMAT, Legacy_GetLevelForSpellMod(self.mod.i), maxString);
        else
            rightTitle = format(LEGACY_ABILITY_UPGRADE_LEVEL_MAXED_FORMAT, Legacy_GetLevelForSpellMod(self.mod.i), maxString);
        end
        GameTooltip:AddDoubleLine(leftTitle, rightTitle);
		if (self.mod.m == 0 or level < self.mod.m) then
			GameTooltip:AddLine(format(LEGACY_ABILITY_UPGRADE_STEP_FOR_NEXT_LEVEL, Legacy_FormatSpellModDesc(self.mod.u, self.mod.v)));
			GameTooltip:AddLine(LEGACY_ABILITY_RIGHT_CLICK_TO_SELECT_UPGRADE.." "..format(LEGACY_ABILITY_TP_COST, Legacy_GetSpellModCost(self.mod)));
		end
    else
        GameTooltip:AddLine(LEGACY_ABILITY_NOT_ACQUIRED);
    end
	GameTooltip:Show();
end

function LegacyPanel_OnClickAbilityUpgradeItem(self, button)
    if (button == "LeftButton") then
        if (self.id == 1) then
            LegacyPanel_NavigateBack();
            return;
        end
    else
        if (self.id == 1) then
            if (self.spell == 0) then
                return;
            else
                if (not Legacy_IsSpellUnlocked(self.spell)) then
                    local link = GetSpellLink(self.spell);
                    local popup = StaticPopup_Show("LEGACY_LEARN_ABILITY_CONFIRM", link, self.gp);
                    popup.link = link;
                    popup.spell = self.spell;
                    popup.gp = self.gp;
                end
            end
        else
            if (self.mod ~= nil and Legacy_IsSpellUnlocked(self.spell) and LegacyCharInfo.TP.Available >= Legacy_GetSpellModCost(self.mod)) then
                Legacy_DoQuery(LMSG_A_LEARN_SPELLMOD, self.mod.i);
            end
        end
    end
end

function LegacyPanel_LoadSpellUpgradesToFrame(spell, gp)
    local spItem = LegacyPanel.AbilityUpgradeItem[1];
    spItem.spell = spell;
    spItem.gp = gp;
    spItem.icon:SetTexture(Legacy_GetSpellIcon(spell));
    if (not Legacy_IsSpellUnlocked(spell)) then
        spItem.icon:SetDesaturated(true);
    else
        spItem.icon:SetDesaturated(false);
    end
    spItem.title:Hide();
    spItem.desc:Hide();
    LegacyPanel_UpdateSpellModItems(spell);
end

function LegacyPanel_UpdateSpellModItems(spell)
    local _, cl = UnitClass("player");
    local spMods = SpellMods[cl];
    if (spMods ~= nil) then
        local spMod = spMods[spell];
        if (spMod ~= nil) then
            local index = 2;
            for i = 1, 8 do -- 8 for data iteration, not ui
                local mod = spMod[i];
                if (mod ~= nil) then
                    LegacyPanel_LoadSpellModToItem(LegacyPanel.AbilityUpgradeItem[index], mod, spell);
                    index = index + 1;
                end
            end
            for i = index, LEGACY_MAX_ABILITY_UPGRADE_UI_SLOT do
                LegacyPanel.AbilityUpgradeItem[i]:Hide();
            end
        end
    end
end

function LegacyPanel_LoadSpellModToItem(item, mod, spell)
    item.spell = spell;
    item.mod = mod;
    item.icon:SetTexture(LEGACY_ABILITY_SPELLMOD_ICON[mod.dt]);
    if (not Legacy_IsSpellUnlocked(spell)) then
        item.icon:SetDesaturated(true);
    else
        item.icon:SetDesaturated(false);
    end
    item.title:SetText(mod.s);
    item.desc:SetText(Legacy_FormatSpellModDesc(mod.u, mod.v * Legacy_GetLevelForSpellMod(mod.i)));
    item:Show();
end

function LegacyPanel_UpdateSpellModItem(modID, rank)
    for i = 2, LEGACY_MAX_ABILITY_UPGRADE_UI_SLOT do
        local abilityItem = LegacyPanel.AbilityUpgradeItem[i];
        if (abilityItem.mod ~= nil and abilityItem.mod.i == modID) then
            abilityItem.desc:SetText(Legacy_FormatSpellModDesc(abilityItem.mod.u, abilityItem.mod.v * rank));
            local tipOwner = GameTooltip:GetOwner();
            if (tipOwner == abilityItem) then
                GameTooltip:ClearLines();
                LegacyPanel_FormatAbilityUpgradeTooltip(abilityItem);
            end
        end
    end
end