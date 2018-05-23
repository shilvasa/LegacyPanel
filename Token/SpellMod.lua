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
	if (self == GameTooltip:GetOwner()) then
		GameTooltip:ClearLines();
		local rank = Legacy.Data.Character.Spell.Mod[self.data.id];
		if (rank == nil) then rank = 0; end
		local desc = Legacy_FormatSpellModDesc(self.data.desc, self.data.value * rank);
		if (rank < self.data.mrank) then
			GameTooltip:AddDoubleLine(desc, Legacy_RDots(rank, self.data.mrank), 1, 1, 1, 1, 1, 1);
		else
			GameTooltip:AddDoubleLine(desc, Legacy_RDots(rank, self.data.mrank), 1, 1, 0, 1, 1, 0);
		end
		if (rank < self.data.mrank) then
			GameTooltip:AddDoubleLine(LEGACY_SPELLMOD_NEXT_RANK, Legacy_FormatSpellModDesc(self.data.desc, self.data.value * rank + 1), 0, 1, 0, 0, 1, 0);
			GameTooltip:AddDoubleLine(LEGACY_SPELLMOD_RIGHT_CLICK_HINT, format(LEGACY_SPELLMOD_COST, self.data.costb + self.data.costi * rank), 0, 1, 0, 0, 1, 0);
		else
			GameTooltip:AddLine(LEGACY_SPELLMOD_MAX_RANK_EXCEEDED, 1, 1, 0);
		end
	end
end

function LegacyPanel_OnClickSpellModToken(self, button)
    if (button == "LeftButton") then
        if (self.Id == 1) then
            LegacyPanel_NavigateBack();
            return;
        end
    else
        if (self.Id == 1 or self.data == nil) then
            return;
        else
            local rank = Legacy.Data.Character.Spell.Mod[self.data.id];
			if (rank == nil) then rank = 0; end
			if (rank < self.data.mrank) then
				Legacy_DoQuery(LMSG_A_LEARN_SPELLMOD, self.data.id);
			end
        end
    end
end

function LegacyPanel_LoadSpellModToFrame()
	if (Legacy.Var.Nav.Selected.SpellMod ~= 0) then
		local spItem = Legacy.UI.SpellMod[1];
		spItem.spell = Legacy.Var.Nav.Selected.SpellMod;
		spItem.Icon:SetTexture(Legacy_GetSpellIcon(Legacy.Var.Nav.Selected.SpellMod));
		spItem.Icon:SetDesaturated(false);
		spItem.Title:Hide();
		spItem.Desc:Hide();
		LegacyPanel_UpdateSpellMods();
	end
end

function LegacyPanel_UpdateSpellMods()
    local spMods = ClassSpellMod[Legacy.Var.Nav.Selected.SpellMod];
    if (spMods ~= nil) then
		local index = 2;
		for k, v in pairs(spMods) do
			local token = Legacy.UI.SpellMod[index];
			token.spell = spell;
			token.mod = k;
			token.data = v;
			local rank = Legacy.Data.Character.Spell.Mod[v.id];
			if (rank == nil) then rank = 0; end
			token.Desc:SetText(rank.."/"..v.mrank);
			token.Icon:SetTexture(LEGACY_ABILITY_SPELLMOD_ICON[v.icon]);
			token:Show();
			LegacyPanel_FormatSpellModTooltip(token);
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