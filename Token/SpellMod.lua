function LegacyPanel_OnLoadSpellModToken(self)
	LegacyPanel_InitToken(self);
	if (self.Id ~= 1) then
		self.Icon:SetSize(45, 45);
		self.Icon:SetTexCoord(0, 1, 0, 1);
	end
	self.Title:Hide();
	self.Desc:SetFontObject("GameFontGreenSmall");
	self.Desc:SetPoint("CENTER", self, "CENTER", 0, -15);
end

function LegacyPanel_OnEnterSpellModToken(self)
    self.Highlight:SetVertexColor(0, 1, 0, 1);
    self.Highlight:Show();
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
    if (self.Id == 1) then
        GameTooltip:SetHyperlink("spell:"..self.spell);
		GameTooltip:AddLine(LEGACY_ABILITY_RETURN_TO_MAIN_FRAME_HINT);
    else
        LegacyPanel_FormatSpellModTooltip(self);
    end
    GameTooltip:Show();
end

function LegacyPanel_OnLeaveSpellModToken(self)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_FormatSpellModTooltip(self)
	GameTooltip:Hide();
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	GameTooltip:ClearLines();
	local leftTitle = "|cff00ff00"..Legacy_FormatSpellModDesc(self.data.desc, self.data.value).."|r";
	local rightTitle = "0/"..self.data.mrank;
	GameTooltip:AddDoubleLine(leftTitle, rightTitle);
	GameTooltip:Show();
end

function LegacyPanel_OnClickSpellModToken(self, button)
    if (button == "LeftButton") then
        if (self.Id == 1) then
            LegacyPanel_NavigateBack();
            return;
        end
    else
        if (self.Id == 1) then
            return;
        else
            -- learn mod
        end
    end
end

function LegacyPanel_LoadSpellModToFrame(spell)
    local spItem = Legacy.UI.SpellMod[1];
    spItem.spell = spell;
    spItem.Icon:SetTexture(Legacy_GetSpellIcon(spell));
	spItem.Icon:SetDesaturated(false);
    spItem.Title:Hide();
    spItem.Desc:Hide();
    LegacyPanel_UpdateSpellMods(spell);
end

function LegacyPanel_UpdateSpellMods(spell)
    local spMods = ClassSpellMod[spell];
    if (spMods ~= nil) then
		local index = 2;
		for k, v in pairs(spMods) do
			local token = Legacy.UI.SpellMod[index];
			token.spell = spell;
			token.mod = k;
			token.data = v;
			token.Desc:SetText("0/"..v.mrank);
			token.Icon:SetTexture(LEGACY_ABILITY_SPELLMOD_ICON[v.icon]);
			token:Show();
			index = index + 1;
		end
		
		for i = index, LEGACY_MAX_ABILITY_UPGRADE_UI_SLOT do
			Legacy.UI.SpellMod[i]:Hide();
		end
    end
end

function LegacyPanel_UpdateSpellModItem(mod, rank)
    for i = 2, LEGACY_MAX_ABILITY_UPGRADE_UI_SLOT do
        local token = Legacy.UI.SpellMod[i];
        if (token.mod == mod) then
            token.Desc:SetText(Legacy_FormatSpellModDesc(token.data.desc, token.mod.value * rank));
            local tipOwner = GameTooltip:GetOwner();
            if (tipOwner == token) then
                GameTooltip:ClearLines();
                LegacyPanel_FormatSpellModTooltip(token);
            end
        end
    end
end