function Legacy_GetItemRandFactor(link)
	if (link == nil) then return end;
	local f0, f1, f2 = string.match(link, "|cff%w+|Hitem:(%d+):%d+:%d+:%d+:%d+:%d+:(%-?%d+):(%-?%d+):%d+|h%[[%s%S]*%]|h|r")
    if (f0 == nil) then f0 = 0 end
	if (f1 == nil) then f1 = 0 end
	if (f2 == nil) then f2 = 0 end
	return tonumber(f0), tonumber(f1), tonumber(f2)
end

function Legacy_GetItemRandStatFraction(f)
	if (f == nil or f < 1) then return LEGACY_STAT_FACTOR_MIN, 0, 0, 0, 0, 0 end
	local f0, f1, f2, f3, f4, f5;
	f0 = floor(f/LEGACY_STAT_MASK_LV5);
	f = f - f0*LEGACY_STAT_MASK_LV5;
	f1 = floor(f/LEGACY_STAT_MASK_LV4);
	f = f - f1*(LEGACY_STAT_MASK_LV4);
	f2 = floor(f/LEGACY_STAT_MASK_LV3);
	f = f - f2*LEGACY_STAT_MASK_LV3;
	f3 = floor(f/LEGACY_STAT_MASK_LV2);
	f = f - f3*LEGACY_STAT_MASK_LV2;
	f4 = floor(f/LEGACY_STAT_MASK_LV1);
	f = f - f4*LEGACY_STAT_MASK_LV1;
	return math.max(f0, LEGACY_STAT_FACTOR_MIN), f1, f2, f3, f4, f;
end

function Legacy_GetItemRandModFraction(f)
	if (f == nil) then return 0, 0 end
	local f0, f1 = 0;
	f0 = floor(f/65536);
	f1 = f - f0*65536;
	return f0, f1;
end

function Legacy_ExtractStatValue(text)
    local match = string.match(text, "%+(%d+)%s");
    if (match == nil) then return 0 end
    return tonumber(match);
end

function Legacy_GetRandQualityDesc(quality)
    -- range 1-35
    if (quality < 5) then
        return LEGACY_RAND_QUALITY_1;
    elseif (quality < 10) then
        return LEGACY_RAND_QUALITY_2;
    elseif (quality < 15) then
        return LEGACY_RAND_QUALITY_3;
    elseif (quality < 20) then
        return LEGACY_RAND_QUALITY_4;
    elseif (quality < 25) then
        return LEGACY_RAND_QUALITY_5;
    elseif (quality < 30) then
        return LEGACY_RAND_QUALITY_6;
    else
        return LEGACY_RAND_QUALITY_7;
    end
end

function Legacy_GetEquipmentStatCap(quality, iLevel, class, subclass, equipSlot)
    local factor = iLevel;
    if (quality == 0) then
        factor = factor * 0.5;
    elseif (quality == 1) then
        factor = factor * 0.75;
    elseif (quality == 2) then
        factor = factor * 1;
    elseif (quality == 3) then
        factor = factor * 1.25;
    elseif (quality == 4) then
        factor = factor * 1.5;
    elseif (quality == 5) then
        factor = factor * 2;
    elseif (quality == 6) then
        factor = factor * 2.5;
    elseif (quality == 7) then -- heirloom
        factor = factor * 1.25;
    else
        return 0;
    end
    if (equipSlot == "INVTYPE_2HWEAPON") then
        factor = factor * 2;
    end
    return factor;
end

function Legacy_GetIdentifiedItemInfo(seed)
	local p = bit.band(seed, 16777216);
	local l = bit.band(seed, 16711680);
	local r = bit.band(seed, 65280);
	local m = bit.band(seed, 255);
	return bit.rshift(p, 24), bit.rshift(l, 16), bit.rshift(r, 8), m;
end

function Legacy_GetUnidentifiedItemInfo(seed)
	local s = -seed;
	local d = bit.band(s, 510);
	local p = bit.band(s, 512);
	return bit.rshift(p, 9), bit.rshift(d, 1);
end

function Legacy_FormatItemRandInfo(tooltip, link)
	if (link == nil) then return end;
    local f0, f1, f2 = Legacy_GetItemRandFactor(link);
	local craftPreview = tooltip:GetOwner():GetName() == "TradeSkillSkillIcon";
    if (LEGACY_DEBUG) then
        print("f0:"..f0);
        print("f1:"..f1);
        print("f2:"..f2);
		print(craftPreview);
    end
    local _, _, quality, iLevel, _, class, subclass, _, equipSlot, _, _ = GetItemInfo(f0);
    local info = ItemInfo[f0];
    if (info ~= nil) then -- has spec requirement
        tooltip:AddLine(LEGACY_EQUIP_REQUIREMENT);
        for i = 1, 6 do
            if (info[i] > 0) then
                if (LegacyCharInfo.SpecialtyStats[i].Point < info[i]) then
                    tooltip:AddLine(format(LEGACY_SPEC_XREQUIREMENT[i], info[i]));
                else
                    tooltip:AddLine(format(LEGACY_SPEC_REQUIREMENT[i], info[i]));
                end
            end
        end
    end
	
	local itemName = _G[tooltip:GetName().."TextLeft1"];
	local rankLine = _G[tooltip:GetName().."TextRight1"];
	local rankLine2 = _G[tooltip:GetName().."TextRight2"]; -- seems always on the right of binding info
	
    if (f2 <= 0) then -- unidentified or craft item tip
		if (f2 < 0) then
			rankLine:Show();
			rankLine:SetText(LEGACY_UNIDENTIFIED);
			local primal, dLvl = Legacy_GetUnidentifiedItemInfo(f2);
			if (primal ~= 0) then
				tooltip:SetBackdropBorderColor(0, 0.93, 0.93, 1);
			end
			if (dLvl > 0) then
				rankLine2:SetText(format(LEGACY_DROP_LEVEL, dLvl));
				rankLine2:Show();
			end
		end
		if ((f2 < 0 or craftPreview) and (class == "武器" or class == "护甲")) then
			local tipTextLeft = tooltip:GetName().."TextLeft";
			for i = 2, tooltip:NumLines() do
				local line = _G[tipTextLeft..i];
				local text = line:GetText();
				if text then
					if (string.find(text, LEGACY_REGEX_DMG) ~= nil) then
						-- this is so stupid
						local dmin, dmax, dtype = string.match(text, LEGACY_REGEX_DMG);
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_DMG_FORMAT, dmin, dmax, dtype)));
					elseif (string.find(text, LEGACY_REGEX_DMG_SINGLE) ~= nil) then
						local dmg, dtype = string.match(text, LEGACY_REGEX_DMG_SINGLE);
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_DMG_SINGLE_FORMAT, dmg, dtype)));
					elseif (string.find(text, LEGACY_REGEX_DPS) ~= nil) then
						local dps = string.match(text, LEGACY_REGEX_DPS);
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_DPS_FORMAT, dps)));
					elseif (string.find(text, LEGACY_REGEX_ARMOR) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_ARMOR_FORMAT, string.match(text, LEGACY_REGEX_ARMOR))));
					elseif (string.find(text, LEGACY_REGEX_BLOCK) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_BLOCK_FORMAT, string.match(text, LEGACY_REGEX_BLOCK))));
					elseif (string.find(text, LEGACY_REGEX_STAT5) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_STAT_SUM_FORMAT_5, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_STAT4) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_STAT_SUM_FORMAT_4, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_STAT3) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_STAT_SUM_FORMAT_3, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_STAT2) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_STAT_SUM_FORMAT_2, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_STAT1) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_STAT_SUM_FORMAT_1, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_RES0) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_RES_FORMAT0, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_RES5) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_RES_FORMAT5, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_RES4) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_RES_FORMAT4, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_RES3) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_RES_FORMAT3, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_RES2) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_RES_FORMAT2, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_RES1) ~= nil) then
						line:SetText(format(LEGACY_STRING_FORMAT_GREEN, format(LEGACY_RES_FORMAT1, Legacy_ExtractStatValue(text))));
					elseif (string.find(text, LEGACY_REGEX_SPELLPOWER) ~= nil) then
						local sp = tonumber(string.match(text, LEGACY_REGEX_SPELLPOWER));
						line:SetText(string.format(LEGACY_SPELLPOWER_FORMAT, sp));
					elseif (string.find(text, LEGACY_REGEX_SPELLDAMAGEPOWER) ~= nil) then
						local sp = tonumber(string.match(text, LEGACY_REGEX_SPELLDAMAGEPOWER));
						line:SetText(string.format(LEGACY_SPELLDAMAGEPOWER_FORMAT, sp));
					elseif (string.find(text, LEGACY_REGEX_SPELLHEALINGPOWER) ~= nil) then
						local sp = tonumber(string.match(text, LEGACY_REGEX_SPELLHEALINGPOWER));
						line:SetText(string.format(LEGACY_SPELLHEALINGPOWER_FORMAT, sp));
					end
				end
			end
		end
    else -- identified
		local primal, dropLvl, reforgeCount, maxCount = Legacy_GetIdentifiedItemInfo(f2);
		if (primal ~= 0) then
			tooltip:SetBackdropBorderColor(0, 0.93, 0.93, 1);
		end
		if (maxCount > 0) then
			rankLine:Show();
			if (reforgeCount >= maxCount) then
				rankLine:SetText(format(LEGACY_REFORGABLE_MAX, reforgeCount, maxCount));
			else
				rankLine:SetText(format(LEGACY_REFORGABLE, reforgeCount, maxCount));
			end
		end
		if (dropLvl > 0) then
			rankLine2:SetText(format(LEGACY_DROP_LEVEL, dropLvl));
			rankLine2:Show();
		end
    end
	
	--tooltip:AddLine(f0);
end

function Legacy_GetChronoInfo(param)
	local power = bit.band(param, 127);
	local polarity = bit.band(param, 896);
	local stabilizationLvl = bit.band(param, 130048);
	local id = bit.band(param, 4294836224);
	return power, bit.rshift(polarity, 7), bit.rshift(stabilizationLvl, 10), bit.rshift(id, 17);
end

function Legacy_GetChronoEffectIdx(param)
	local idx = {};
	local pos = {};
	local ps = 1;
	local tcount = 0;
	idx[1] = bit.band(param, 15);
	idx[2] = bit.rshift(bit.band(param, 240), 4);
	idx[3] = bit.rshift(bit.band(param, 3840), 8);
	pos[1] = bit.rshift(bit.band(param, 28672), 12);
	pos[2] = bit.rshift(bit.band(param, 229376), 15);
	pos[3] = bit.rshift(bit.band(param, 1835008), 18);
	ps = 0.5 + bit.rshift(bit.band(param, 31457280), 21) / 15;
	tcount = bit.rshift(bit.band(param, 1040187392), 25);
	return idx, pos, ps, tcount;
end

function Legacy_GetPolarityMatchingColor(p1, p2, n)
	if (p1 == p2) then
		if (n == 0) then
			return 0, 1, 0;
		else
			return 1, 1, 1;
		end
	else
		if (n == 0) then
			return 1, 1, 1;
		else
			return 1, 0, 0;
		end
	end
end

function Legacy_GetPolarityColor(p1, p2)
	if (p1 == p2) then
		return LEGACY_POLARITY_ICON[p2].r, LEGACY_POLARITY_ICON[p2].g, LEGACY_POLARITY_ICON[p2].b;
	else
		return 1, 1, 1;
	end
end

function Legacy_GetPolarityColors(chrono, pos, polarity, power)
	if (chrono.m > power) then
		return 0.5, 0.5, 0.5, 0.5, 0.5, 0.5;
	end
	
	if (pos == polarity) then
		if (chrono.p == 1) then
			return LEGACY_POLARITY_ICON[pos].r, LEGACY_POLARITY_ICON[pos].g, LEGACY_POLARITY_ICON[pos].b, LEGACY_POLARITY_ICON[pos].r, LEGACY_POLARITY_ICON[pos].g, LEGACY_POLARITY_ICON[pos].b;
		else
			return LEGACY_POLARITY_ICON[pos].r, LEGACY_POLARITY_ICON[pos].g, LEGACY_POLARITY_ICON[pos].b, LEGACY_POLARITY_ICON[pos].r, LEGACY_POLARITY_ICON[pos].g, LEGACY_POLARITY_ICON[pos].b;
		end
	else
		if (chrono.p == 1) then
			return 1, 1, 1, 0.5, 0.5, 0.5;
		else
			return 1, 1, 1, 0.5, 0.5, 0.5;
		end
	end
end

function Legacy_GetChipPolarityColors(pos)
	return LEGACY_POLARITY_ICON[pos].r, LEGACY_POLARITY_ICON[pos].g, LEGACY_POLARITY_ICON[pos].b, LEGACY_POLARITY_ICON[pos].r, LEGACY_POLARITY_ICON[pos].g, LEGACY_POLARITY_ICON[pos].b;
end

function Legacy_GetPolarityIcon(p1, p2)
	if (p1 == p2) then
		return LEGACY_POLARITY_ICON[p2].a;
	else
		return LEGACY_POLARITY_ICON[p2].d;
	end
end

function Legacy_GetPolarityName(p)
	return LEGACY_POLARITY_ICON[p].n;
end

function Legacy_GetChronoBonus(chrono, idx)
	local bonus;
	local factor = 1;
	if (chrono.e > 0) then
		bonus = ChronoEffect[chrono.e];
	elseif (chrono.e < 0) then
		local g = ChronoGroup[-chrono.e][idx];
		bonus = ChronoEffect[g.b];
		factor = g.f;
	end
	
	return bonus, factor;
end

function Legacy_FormatChronoDesc(chrono, stab, power, polarity, ilvl, idx, pos, ps)
	local bonus, factor = Legacy_GetChronoBonus(chrono, idx);
	local v;
	if (chrono.x ~= 1) then
		if (chrono.m > power) then
			v = (2 + chrono.m) * Legacy_CalcILFactor(ilvl) * chrono.f * ps;
		else
			v = (2 + power) * Legacy_CalcILFactor(ilvl) * chrono.f * ps;
		end
	else
		v = (2 + power) * chrono.f * ps;
	end
	v = v * factor;
	if (pos == polarity) then
		v = v * Legacy_StabilizationFactor(chrono.p, stab);
	end
	local vStr;
	if (bonus.e > 0) then
		vStr = format("%."..bonus.e.."f", v);
	else
		vStr = format("%d", v);
	end
	if (v >= 0) then
		vStr = "+"..vStr;
	end
	local str = gsub(bonus.d, "vx", vStr);
	if (power < chrono.m) then
		str = str.." [P"..chrono.m.."]";
	end
	
	return str;
end

function Legacy_FormatChronoChipDesc(chrono, idx, ps)
	local bonus, factor = Legacy_GetChronoBonus(chrono, idx);
	local v = chrono.f * 2 * factor * ps;
	if (chrono.x ~= 1) then
		v = chrono.f * 0.618 * factor * ps;
	end
	local vStr;
	if (bonus.e > 0) then
		vStr = format("%."..bonus.e.."f", v);
	else
		vStr = format("%.2f", v);
	end
	if (v >= 0) then
		vStr = "+"..vStr;
	end
	if (chrono.x ~= 1) then
		vStr = "["..vStr.."x]";
	end
	local str = gsub(bonus.d, "vx", vStr);
	if (chrono.m > 0) then
		str = str.." [P"..chrono.m.."]";
	end
	
	return str;
end

function Legacy_PolarityFactor(p1, p2, positive)
	if (positive == 0) then
		if (p1 == p2) then
			return 0.5;
		else
			return 1;
		end
	else
		if (p1 == p2) then
			return 1.5;
		else
			return 1;
		end
	end
end

function Legacy_StabilizationFactor(positive, stabilizationLvl)
	if (positive == 1) then
		return 1 + stabilizationLvl / 200;
	else
		return 1 - stabilizationLvl / 200;
	end
end

function Legacy_GetStabIcon(stab)
	local icon = "○○○○○";
	if (stab > 0) then
		if (stab > 80) then
			icon = "●●●●●";
		elseif (stab > 60) then
			icon = "●●●●○";
		elseif (stab > 40) then
			icon = "●●●○○";
		elseif (stab > 20) then
			icon = "●●○○○";
		else
			icon = "●○○○○";
		end
	end
	
	return icon;
end

function Legacy_CalcILFactor(ilvl)
	return (13.5 + math.pow(ilvl, 0.8)) * 0.45;
end

function Legacy_StabColor(stabilizationLvl)
	local r = 1;
	local g = 1;
	local b = 1;
	if (stabilizationLvl <= 50) then
		g = stabilizationLvl / 50;
		b = stabilizationLvl / 50;
	elseif (stabilizationLvl > 50) then
		r = (100 - stabilizationLvl) / 50;
		b = (100 - stabilizationLvl) / 50;
	end
	
	return r, g, b, 1;
end

function Legacy_FormatItemChronoInfo(tooltip, link)
	if (link ~= nil) then
		local f0, f1, f2 = Legacy_GetItemRandFactor(link);
		local power, polarity, stabilizationLvl, chronoId = Legacy_GetChronoInfo(f2);
		local idx, pos, ps, tcount = Legacy_GetChronoEffectIdx(f1);
		if (polarity ~= 0 or chronoId ~= 0) then
			local _, _, quality, iLevel, _, class, subclass, _, equipSlot, _, _ = GetItemInfo(f0);
			--[[
			local polarityIcon = tooltip:CreateTexture();
			polarityIcon:SetTexture(LEGACY_POLARITY_ICON[1].a);
			polarityIcon:SetWidth(16);
			polarityIcon:SetHeight(16);
			polarityIcon:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", -8, -10);
			]]--
			local polarityLine = _G[tooltip:GetName().."TextRight1"];
			if (polarity ~= 0) then
				local itemName = _G[tooltip:GetName().."TextLeft1"];
				local polarityStr = LEGACY_POLARITY_ICON[polarity].n..power;
				if (chronoId == 0) then polarityStr = LEGACY_POLARITY_ICON[polarity].n; end;
				polarityLine:SetText(polarityStr);
				polarityLine:SetVertexColor(LEGACY_POLARITY_ICON[polarity].r, LEGACY_POLARITY_ICON[polarity].g, LEGACY_POLARITY_ICON[polarity].b, 1);
				polarityLine:Show();
				
				if (chronoId > 0) then
					tooltip:AddLine(" ");
					local chronoName = ChronoSet[chronoId].t;
					if (ChronoSet[chronoId].u == 1) then
						chronoName = chronoName.." <唯一>";
					end
					tooltip:AddDoubleLine("时空能量", chronoName, 0, 1, 1, Legacy_QualityColorNA(ChronoSet[chronoId].q));
					for i = 1, 3 do
						local chrono = ChronoSet[chronoId].d[i];
						if (chrono.e ~= 0) then
							tooltip:AddDoubleLine(Legacy_FormatChronoDesc(chrono, stabilizationLvl, power, polarity, iLevel, idx[i], pos[i], ps),
							Legacy_GetPolarityName(pos[i]),
							Legacy_GetPolarityColors(chrono, pos[i], polarity, power));
						end
					end
				end
				
				if (stabilizationLvl > 0 or chronoId > 0) then
					local r = 1;
					local g = 1;
					local b = 1;
					if (stabilizationLvl <= 50) then
						g = stabilizationLvl / 50;
						b = stabilizationLvl / 50;
					elseif (stabilizationLvl > 50) then
						r = (100 - stabilizationLvl) / 50;
						b = (100 - stabilizationLvl) / 50;
					end
					tooltip:AddDoubleLine("能量稳定度", Legacy_GetStabIcon(stabilizationLvl), r, g, b, r, g, b);
				end
				
				if (tcount > 0) then
					tooltip:AddLine(" ");
					tooltip:AddDoubleLine("剩余能量转换次数", tcount);
				end
			elseif (class == "珍宝" and subclass == "时空晶元" and chronoId > 0) then
				-- polarityLine:SetText("唯一");
				-- polarityLine:Show();
				tooltip:AddLine(" ");
				local chronoName = ChronoSet[chronoId].t;
				if (ChronoSet[chronoId].u == 1) then
					chronoName = chronoName.." <唯一>";
				end
				tooltip:AddDoubleLine("时空能量", chronoName, 0, 1, 1, Legacy_QualityColorNA(ChronoSet[chronoId].q));
				for i = 1, 3 do
					local chrono = ChronoSet[chronoId].d[i];
					if (chrono.e ~= 0) then
						tooltip:AddDoubleLine(Legacy_FormatChronoChipDesc(chrono, idx[i], ps),
						Legacy_GetPolarityName(pos[i]),
						Legacy_GetChipPolarityColors(pos[i]));
					end
				end
			end
		end
	end
	
	Legacy_FormatSpellInfo(tooltip, link);
end

function LegacyPanel_HookItemTooltip(tooltip)
    tooltip:HookScript("OnTooltipSetItem", function(self, ...)
        local _, link = self:GetItem();
		if (link ~= "") then
			Legacy_FormatItemChronoInfo(self, link);
		end
    end)
end
