-- skill

function LegacyPanel_OnLoadClassSkillToken(self)
	LegacyPanel_InitToken(self);
	self.entry = 0;
	self.data = nil;
	self.rankData = nil;
	self.Title:Hide();
	self.Icon:SetTexture(LEGACY_SKILL_NAME[self.Id].Icon);
end

function LegacyPanel_OnEnterClassSkillToken(self, motion)
	if (self.entry ~= 0) then
		self.Highlight:SetVertexColor(0, 1, 0, 1);
		self.Highlight:Show();
		if (self.data ~= nil) then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
			local _, cl = UnitClass("player");
			local r, g, b = Legacy_GetColorHex(self.data.Shade);
			if (self.data.Class ~= cl) then
				GameTooltip:AddLine(self.data.Name, r, g, b);
			else
				GameTooltip:AddDoubleLine(self.data.Name, LEGACY_ORIGIN_MASTERY, r, g, b, r, g, b);
			end
			if (self.rankData ~= nil) then
				GameTooltip:AddDoubleLine(LEGACY_SKILL_MASTERY_RANK, format("%d/%d", self.rankData.Rank, self.rankData.Cap), 1, 1, 1, 1, 1, 1);
			end
			GameTooltip:Show();
		end
	end
end

function LegacyPanel_OnLeaveClassSkillToken(self, motion)
	GameTooltip:Hide();
	if (self.entry ~= Legacy.Var.Nav.Selected.ClassSkill) then
		self.Highlight:Hide();
	end
end

function LegacyPanel_OnClickClassSkillToken(self, button, down)
	if (button == "LeftButton") then
		LegacyPanel_SelectClassSkill(self.entry);
	end
end

function LegacyPanel_SelectClassSkill(skill)
	Legacy.Var.Nav.Page.ClassSkill.Memory = 0;
	Legacy.Var.Nav.Selected.ClassSkill = skill;
	LegacyPanel_UpdateClassMemory();
	LegacyPanel_UpdateClassSkill();
end

-- skill nav

function LegacyPanel_OnLoadClassSkillNavToken(self)
	LegacyPanel_InitToken(self);
	self.Icon:SetTexture(LEGACY_NAV_ARROW[self.Id]);
	self.Title:Hide();
	self.Desc:Hide();
end

function LegacyPanel_OnEnterClassSkillNavToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
	self.Highlight:Show();
end

function LegacyPanel_OnLeaveClassSkillNavToken(self, motion)
	self.Highlight:Hide();
end

function LegacyPanel_OnClickClassSkillNavToken(self, button, down)
	if (self.more) then
		if (self == Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_PREV]) then
			Legacy.Var.Nav.Page.ClassSkill.Skill = Legacy.Var.Nav.Page.ClassSkill.Skill - 1;
		else
			Legacy.Var.Nav.Page.ClassSkill.Skill = Legacy.Var.Nav.Page.ClassSkill.Skill + 1;
		end
	end
	LegacyPanel_UpdateClassSkill();
end

function LegacyPanel_UpdateClassSkill()
	local _, cl = UnitClass("player");
	for i = 1, LEGACY_MAX_SKILL_PER_PAGE do
		local token = Legacy.UI.ClassSkill.Skill[i];
		local index = i+LEGACY_MAX_SKILL_PER_PAGE*Legacy.Var.Nav.Page.ClassSkill.Skill;
		local skill = LEGACY_SKILL_NAME[index];
		local rankData = Legacy.Data.Character.ClassSkill[index];
		token.data = skill;
		token.rankData = rankData;
		if (skill ~= nil) then
			token.entry = index;
			token:Show();
			token.Icon:SetTexture(skill.Icon);
			if (skill.Class == cl) then
				token.Border:SetVertexColor(Legacy_GetClassShade(cl));
			else
				token.Border:SetVertexColor(1, 1, 1, 1);
			end
			
			if (token.entry == Legacy.Var.Nav.Selected.ClassSkill) then
				token.Highlight:SetVertexColor(0, 1, 0, 1);
				token.Highlight:Show();
			else
				token.Highlight:Hide();
			end
			if (token.rankData ~= nil) then
				token.Desc:SetText(token.rankData.Rank.."/"..token.rankData.Cap);
				token.Desc:Show();
				if (token.rankData.Rank > 0) then
					token.Icon:SetDesaturated(false);
				else
					token.Icon:SetDesaturated(true);
				end
			end
		else
			token.entry = 0;
			token:Hide();
		end
	end
	
	if (Legacy.Var.Nav.Page.ClassSkill.Skill > 0) then
		Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_PREV].more = true;
		Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_PREV].more = false;
		Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	
	if ((Legacy.Var.Nav.Page.ClassSkill.Skill+1)*LEGACY_MAX_SKILL_PER_PAGE >= #LEGACY_SKILL_NAME) then
		Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.ClassSkill.Nav.Skill[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
end

-- memory

function LegacyPanel_OnLoadClassMemoryToken(self)
	LegacyPanel_InitToken(self);
	self.entry = 0;
	self.skill = 0;
	self.Title:Hide();
	self.Desc:Hide();
end

function LegacyPanel_OnEnterClassMemoryToken(self, motion)
	if (self.entry ~= 0) then
		local _, cl = UnitClass("player");
		local r, g, b = Legacy_GetColorHex(LEGACY_SKILL_NAME[self.skill].Shade);
		self.Highlight:SetVertexColor(0, 1, 0, 1);
		self.Highlight:Show();
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
		GameTooltip:SetHyperlink("spell:"..self.entry);
		_G[GameTooltip:GetName().."TextLeft1"]:SetVertexColor(r, g, b, 1);
		if (self.entry ~= 0 and self.data.rank ~= 0) then
			local p = _G[GameTooltip:GetName().."TextRight1"];
			p:SetText(format("%s %d", LEGACY_SKILL_NAME[self.skill].Name, self.data.rank));
			p:SetVertexColor(r, g, b, 1);
			p:Show();
		end
		if (self.data.cost > 0) then
			GameTooltip:AddDoubleLine(LEGACY_MEMORY_POINT_COST, self.data.cost, 1, 1, 1, 1, 1, 1);
		end
		if (self.data.origin == 1) then
			if (cl == LEGACY_SKILL_NAME[self.skill].Class) then
				local color = LEGACY_CLASS_COLOR[cl];
				GameTooltip:AddDoubleLine(LEGACY_ORIGIN_MASTERY, Legacy_GetClassName(LEGACY_SKILL_NAME[self.skill].Class), color.r, color.g, color.b, color.r, color.g, color.b);
			else
				GameTooltip:AddDoubleLine(LEGACY_ORIGIN_MASTERY, Legacy_GetClassName(LEGACY_SKILL_NAME[self.skill].Class), 1, 0, 0, 1, 0, 0);
			end
		end
		
		local left, right = " ";
		if (cl == LEGACY_SKILL_NAME[self.skill].Class) then
			left = LEGACY_MEMORY_LEFT_CLICK_HINT;
		end
		if (Legacy_SpellMemorized(self.entry)) then
			right = LEGACY_MEMORY_RIGHT_CLICK_HINT;
		else
			right = LEGACY_MEMORY_NOT_AVAILABLE;
			left = " ";
		end
		GameTooltip:AddDoubleLine(left, right);
		GameTooltip:Show();
	end
end

function LegacyPanel_OnLeaveClassMemoryToken(self, motion)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickClassMemoryToken(self, button, down)
	local _, cl = UnitClass("player");
	if (button == "LeftButton" and ClassSpellMod[self.entry] ~= nil and LEGACY_SKILL_NAME[self.skill].Class == cl) then
		local x, y = self:GetCenter();
		Legacy.UI.SpellModFrame:SetPoint("CENTER", Legacy.UI.SpellModFrame:GetParent(), "BOTTOMLEFT", x, y);
		LegacyPanel_LoadSpellModToFrame(self.entry);
		LegacyPanel_Navigate(Legacy.UI.Home.Page[0], Legacy.UI.SpellModFrame);
	else
	end
end

function LegacyPanel_UpdateClassMemory()
	local spells = ClassSpell[Legacy.Var.Nav.Selected.ClassSkill];
	local _, cl = UnitClass("player");
	for i = 1, LEGACY_MAX_MEMORY_PER_PAGE do
		local token = Legacy.UI.ClassSkill.Memory[i];
		local data = spells[LEGACY_MAX_MEMORY_PER_PAGE*Legacy.Var.Nav.Page.ClassSkill.Memory+i];
		if (data ~= nil) then
			token.entry = data.spell;
			token.skill = Legacy.Var.Nav.Selected.ClassSkill;
			token.data = data;
			token.Icon:SetTexture(Legacy_GetSpellIcon(data.spell));
			token.Desc:SetText(data.cost);
			token.Desc:Show();
			if (LEGACY_SKILL_NAME[Legacy.Var.Nav.Selected.ClassSkill].Class == cl) then
				token.Border:SetVertexColor(Legacy_GetClassShade(cl));
			else
				token.Border:SetVertexColor(1, 1, 1, 1);
			end
			if (Legacy_SpellMemorized(data.spell)) then
				token.Icon:SetDesaturated(false);
			else
				token.Icon:SetDesaturated(true);
			end
			token:Show();
		else
			token.entry = 0;
			token.data = nil;
			token:Hide();
		end
	end
	
	if (Legacy.Var.Nav.Page.ClassSkill.Memory > 0) then
		Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_PREV].more = true;
		Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_PREV].more = false;
		Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	
	if (LEGACY_MAX_MEMORY_PER_PAGE*(Legacy.Var.Nav.Page.ClassSkill.Memory+1) >= #ClassSpell[Legacy.Var.Nav.Selected.ClassSkill]) then
		Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
end

-- memory nav

function LegacyPanel_OnLoadClassMemoryNavToken(self)
	LegacyPanel_InitToken(self);
	self.Icon:SetTexture(LEGACY_NAV_ARROW[self.Id]);
	self.Title:Hide();
	self.Desc:Hide();
end

function LegacyPanel_OnEnterClassMemoryNavToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
	self.Highlight:Show();
end

function LegacyPanel_OnLeaveClassMemoryNavToken(self, motion)
	self.Highlight:Hide();
end

function LegacyPanel_OnClickClassMemoryNavToken(self, button, down)
	if (self == Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_PREV] and Legacy.Var.Nav.Page.ClassSkill.Memory > 0) then
		Legacy.Var.Nav.Page.ClassSkill.Memory = Legacy.Var.Nav.Page.ClassSkill.Memory - 1;
		LegacyPanel_UpdateClassMemory();
	elseif (self == Legacy.UI.ClassSkill.Nav.Memory[LEGACY_NAV_NEXT] and LEGACY_MAX_MEMORY_PER_PAGE*(Legacy.Var.Nav.Page.ClassSkill.Memory+1) < #ClassSpell[Legacy.Var.Nav.Selected.ClassSkill]) then
		Legacy.Var.Nav.Page.ClassSkill.Memory = Legacy.Var.Nav.Page.ClassSkill.Memory + 1;
		LegacyPanel_UpdateClassMemory();
	end
end

-- spell

function LegacyPanel_OnLoadClassSpellToken(self)
	LegacyPanel_InitToken(self);
	self.entry = 0;
	self.Title:Hide();
	self.Desc:Hide();
end

function LegacyPanel_OnEnterClassSpellToken(self, motion)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -30, -30);
	if (self.entry ~= 0) then
		GameTooltip:SetHyperlink("spell:"..self.entry);
	else
		if (self.unlocked) then
			GameTooltip:AddLine(LEGACY_SPELL_SLOT_EMPTY, 0, 1, 0);
			GameTooltip:AddLine(LEGACY_SPELL_SLOT_HINT, 1, 1, 1);
			local _, cl = UnitClass("player");
			self.Highlight:SetVertexColor(Legacy_GetClassShade(cl));
		else
			GameTooltip:AddLine(LEGACY_SPELL_SLOT_SEALED, 0.5, 0.5, 0.5);
			self.Highlight:SetVertexColor(0.5, 0.5, 0.5, 1);
		end
	end
	self.Highlight:Show();
	GameTooltip:Show();
end

function LegacyPanel_OnLeaveClassSpellToken(self, motion)
	self.Highlight:Hide();
	GameTooltip:Hide();
end

function LegacyPanel_OnClickClassSpellToken(self, button, down)
end

-- spell nav

function LegacyPanel_OnLoadClassSpellNavToken(self)
	LegacyPanel_InitToken(self);
	self.Icon:SetTexture(LEGACY_NAV_ARROW[self.Id]);
	self.Title:Hide();
	self.Desc:Hide();
end

function LegacyPanel_OnEnterClassSpellNavToken(self, motion)
	self.Highlight:SetVertexColor(0, 1, 0, 1);
	self.Highlight:Show();
end

function LegacyPanel_OnLeaveClassSpellNavToken(self, motion)
	self.Highlight:Hide();
end

function LegacyPanel_OnClickClassSpellNavToken(self, button, down)
	if (self.more) then
		if (self == Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_PREV]) then
			Legacy.Var.Nav.Page.ClassSkill.Spell = Legacy.Var.Nav.Page.ClassSkill.Spell - 1;
		else
			Legacy.Var.Nav.Page.ClassSkill.Spell = Legacy.Var.Nav.Page.ClassSkill.Spell + 1;
		end
		LegacyPanel_UpdateActivatedSpell();
		LegacyPanel_UpdateActivatedSpellNavState();
	end
end

function LegacyPanel_UpdateActivatedSpell()
	local _, cl = UnitClass("player");
	for i = 1, LEGACY_MAX_ACTIVE_SPELL_PER_PAGE do
		local token = Legacy.UI.ClassSkill.Spell[i];
		local slot = i+Legacy.Var.Nav.Page.ClassSkill.Spell*LEGACY_MAX_ACTIVE_SPELL_PER_PAGE;
		local spell = Legacy.Data.Character.Spell.Activated[slot];
		if (spell ~= nil) then
			token.entry = spell;
			if (spell ~= 0) then
				token.Icon:SetTexture(Legacy_GetSpellIcon(spell));
			else
				token.Icon:SetTexture(LEGACY_CLASS_ICON[0][cl]);
				token.Icon:SetVertexColor(Legacy_GetClassShade(cl));
			end
			local unlocked = Legacy_ActiveSpellSlotUnlocked(slot);
			token.unlocked = unlocked;
			if (unlocked) then
				token.Icon:SetDesaturated(false);
			else
				token.Icon:SetDesaturated(true);
			end
			token.Desc:SetText(slot);
			token.Desc:Show();
			token:Show();
		else
			token:Hide();
		end
	end
end

function LegacyPanel_UpdateActivatedSpellNavState()
	if (Legacy.Var.Nav.Page.ClassSkill.Spell > 0) then
		Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_PREV].more = true;
		Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_PREV].Icon:SetDesaturated(false);
	else
		Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_PREV].more = false;
		Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_PREV].Icon:SetDesaturated(true);
	end
	if ((Legacy.Var.Nav.Page.ClassSkill.Spell+1)*LEGACY_MAX_ACTIVE_SPELL_PER_PAGE >= #Legacy.Data.Character.Spell.Activated) then
		Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_NEXT].more = false;
		Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_NEXT].Icon:SetDesaturated(true);
	else
		Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_NEXT].more = true;
		Legacy.UI.ClassSkill.Nav.Spell[LEGACY_NAV_NEXT].Icon:SetDesaturated(false);
	end
end

-- build switch

function LegacyPanel_OnLoadClassSwitchToken(self)
	LegacyPanel_InitToken(self);
	self.Title:Hide();
	self.Desc:Hide();
	self.Icon:SetTexture(LEGACY_BUILD_NAME[self.Id].i);
end

function LegacyPanel_OnEnterClassSwitchToken(self, motion)
end

function LegacyPanel_OnLeaveClassSwitchToken(self, motion)
end

function LegacyPanel_OnClickClassSwitchToken(self, button, down)
end

function LegacyPanel_UpdateMemoryPoint()
	Legacy.UI.Home.Nav[0].Desc:SetText(Legacy.Data.Character.Memory.Available);
end
