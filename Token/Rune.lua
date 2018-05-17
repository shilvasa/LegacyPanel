function LegacyPanel_OnLoadRuneToken(self)
	LegacyPanel_InitToken(self);
	self.entry = 0;
	self.Title:Hide();
	self.Desc:Hide();
end

function LegacyPanel_OnEnterRuneToken(self, motion)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.entry == 0) then
		local right = LEGACY_RUNE_EMPTY;
		local rightColor = { r = 0.5, g = 0.5, b = 0.5 };
		if (self.locked) then right = LEGACY_RUNE_SEALED; end
		if (self.Tier == LEGACY_RUNE_TIER0) then
			local color = LEGACY_QUALITY_COLOR[2];
			if (not self.locked) then rightColor = color; end
			GameTooltip:AddDoubleLine(LEGACY_RUNE_NAME_T0, right, color.r, color.g, color.b, rightColor.r, rightColor.g, rightColor.b);
		elseif (self.Tier == LEGACY_RUNE_TIER1) then
			local color = LEGACY_QUALITY_COLOR[3];
			if (not self.locked) then rightColor = color; end
			GameTooltip:AddDoubleLine(LEGACY_RUNE_NAME_T1, right, color.r, color.g, color.b, rightColor.r, rightColor.g, rightColor.b);
		elseif (self.Tier == LEGACY_RUNE_TIER2) then
			local color = LEGACY_QUALITY_COLOR[4];
			if (not self.locked) then rightColor = color; end
			GameTooltip:AddDoubleLine(LEGACY_RUNE_NAME_T2, right, color.r, color.g, color.b, rightColor.r, rightColor.g, rightColor.b);
		end
	else
		GameTooltip:SetHyperlink("spell:"..self.entry);
		if (self.locked) then
			local p = _G[GameTooltip:GetName().."TextRight1"];
			p:SetText(LEGACY_RUNE_SEALED);
			p:Show();
		else
		end
	end
	GameTooltip:Show();
	local _, cl = UnitClass("player");
	self.Highlight:SetVertexColor(Legacy_GetClassColor(cl));
	self.Highlight:Show();
end

function LegacyPanel_OnLeaveRuneToken(self, motion)
	GameTooltip:Hide();
	self.Highlight:Hide();
end

function LegacyPanel_OnClickRuneToken(self, button, down)
	if (button == "RightButton") then
		if (self.entry ~= 0) then
			local popup = StaticPopup_Show("LEGACY_REMOVE_RUNE_CONFIRM", GetSpellLink(self.entry));
			popup.tier = self.Tier;
			popup.slot = self.id - 1;
		end
	end
end

function LegacyPanel_UpdateRunes()
	-- t0
	local _, cl = UnitClass("player");
	if (Legacy.Data.Character.Rune[0] ~= nil) then
		for i = 1, 10 do
			local spell = Legacy.Data.Character.Rune[0][i];
			local token = Legacy.UI.Rune[0][i];
			token.entry = spell;
			token.Border:SetVertexColor(Legacy_GetQualityColorShift(2, 0.25));
			if (spell == 0) then
				token.Icon:SetTexture(LEGACY_CLASS_ICON[0][cl]);
				token.Icon:SetVertexColor(Legacy_GetClassShade(cl, 0.75));
			else
				token.Icon:SetTexture(Legacy_GetSpellIcon(spell));
				token.Icon:SetVertexColor(1, 1, 1, 1);
			end
		end
	end
	-- t1
	if (Legacy.Data.Character.Rune[1] ~= nil) then
		for i = 1, 10 do
			local spell = Legacy.Data.Character.Rune[1][i];
			local token = Legacy.UI.Rune[1][i];
			token.entry = spell;
			token.Border:SetVertexColor(Legacy_GetQualityColorShift(3, 0.25));
			if (spell == 0) then
				if (Legacy.Data.Character.Rune[0][i] == 0) then
					token.Icon:SetTexture(LEGACY_LOCKED_ICON);
				else
					token.Icon:SetTexture(LEGACY_CLASS_ICON[0][cl]);
				end
				token.Icon:SetVertexColor(Legacy_GetClassShade(cl, 0.75));
			else
				token.Icon:SetTexture(Legacy_GetSpellIcon(spell));
				token.Icon:SetVertexColor(1, 1, 1, 1);
			end
			
			if (Legacy.Data.Character.Rune[0][i] == 0) then
				token.locked = true;
				token.Icon:SetDesaturated(true);
			else
				token.locked = false;
				token.Icon:SetDesaturated(false);
			end
		end
	end
	-- t2
	if (Legacy.Data.Character.Rune[2] ~= nil) then
		for i = 1, 10 do
			local spell = Legacy.Data.Character.Rune[2][i];
			local token = Legacy.UI.Rune[2][i];
			token.entry = spell;
			token.Border:SetVertexColor(Legacy_GetQualityColorShift(4, 0.25));
			if (spell == 0) then
				if (Legacy.Data.Character.Rune[1][i] == 0) then
					token.Icon:SetTexture(LEGACY_LOCKED_ICON);
				else
					token.Icon:SetTexture(LEGACY_CLASS_ICON[0][cl]);
				end
				token.Icon:SetVertexColor(Legacy_GetClassShade(cl, 0.75));
			else
				token.Icon:SetTexture(Legacy_GetSpellIcon(spell));
				token.Icon:SetVertexColor(1, 1, 1, 1);
			end
			
			if (Legacy.Data.Character.Rune[1][i] == 0) then
				token.locked = true;
				token.Icon:SetDesaturated(true);
			else
				token.locked = false;
				token.Icon:SetDesaturated(false);
			end
		end
	end
end
