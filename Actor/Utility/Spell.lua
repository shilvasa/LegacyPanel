function Legacy_FormatSpellModDesc(source, value)
    local d10 = format("%.1f", value/10);
    local d100 = format("%.1f", value/100);
    local d1000 = format("%.1f", value/1000);

    source = string.gsub(source, "xv", math.abs(value));
    source = string.gsub(source, "xd", math.abs(d10));
    source = string.gsub(source, "xp", math.abs(d100));
    source = string.gsub(source, "xm", math.abs(d1000));

    return source;
end

function Legacy_GetSpellLink(entry)
	local link, _ = GetSpellLink(entry);
	return link;
end

function Legacy_GetSpellName(entry)
	local name = GetSpellInfo(entry);
	return name;
end

function Legacy_SpellMemorized(spell)
	return Legacy.Data.Character.Spell.Memorized[spell] == true;
end

function Legacy_GetSpellIcon(spell)
    local _, _, icon, _, _, _, _ = GetSpellInfo(spell);
    return icon;
end

function Legacy_ActiveSpellSlotUnlocked(slot)
	if (slot > 10) then
		return false;
	else
		return true;
	end
end

function LegacyPanel_SelectDefaultClassSkill()
	local _, cl = UnitClass("player");
	local skill = nil;
	for i = 1, #LEGACY_SKILL_NAME do
		if (skill == nil) then
			if (LEGACY_SKILL_NAME[i].Class == cl) then
				skill = i;
			end
		end
	end
	
	LegacyPanel_SelectClassSkill(skill);
end

function Legacy_SpellActivated(spell)
	for k, v in pairs(Legacy.Data.Character.Spell.Activated) do
		if (v == spell) then
			return true;
		end
	end
	return false;
end