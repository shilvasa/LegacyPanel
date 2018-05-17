function Legacy_Fetch(msg)
	return strsplit(":", msg);
end

function Legacy_TFetch(msg)
	return strsplit("\t", msg);
end

function Legacy_ReplaceChar(str, index, c)
	return str:sub(1, index-1)..c..str:sub(index+1);
end

function Legacy_DoQuery(header, param)
	if (param == nil) then
		param = "";
	end
    if (LEGACY_DEBUG) then
	    print("|cffff0000Sending:|r TYPE: "..header.." PARAM: "..param);
    end
	SendAddonMessage(LMSG_Q_HEADER..header, param, "GUILD");
end

function Legacy_GetAction(msg)
	local _, index = string.find(msg, LMSG_A_HEADER, 1);
	if not index then
		return 0; 
	end
	return tonumber(string.sub(msg, index + 1, string.len(msg)));
end

function Legacy_SplitToSet(msg, sep)
	local start = 1;
	local index = 1;
	local set = {};
    if (msg == nil or msg == "" or not string.find(msg, sep, start)) then
        return set;
    end
	while true do
		local lastIndex = string.find(msg, sep, start);
		if not lastIndex then
			set[index] = string.sub(msg, start, string.len(msg));
			break;
		end
		set[index] = string.sub(msg, start, lastIndex - 1);
		start = lastIndex + string.len(sep);
		index = index + 1;
	end
	return set;
end

function Legacy_Signal(msg)
    print(msg);
end

function Legacy_TLength(t)
	local count = 0;
	for k, v in pairs(t) do count = count + 1 end
	return count;
end

function Legacy_QualityColor(quality)
	if (quality == 0) then
		return 0.5, 0.5, 0.5, 1.0;
	elseif (quality == 1) then
		return 1.0, 1.0, 1.0, 1.0;
	elseif (quality == 2) then
		return 0.1176, 1.0, 0, 1.0;
	elseif (quality == 3) then
		return 0, 0.4392, 0.8667, 1.0;
	elseif (quality == 4) then
		return 0.6392, 0.2078, 0.9333, 1.0;
	else
		return 1, 0.502, 0, 1.0;
	end
end

function Legacy_QualityColorNA(quality)
	if (quality == 0) then
		return 0.5, 0.5, 0.5;
	elseif (quality == 1) then
		return 1.0, 1.0, 1.0;
	elseif (quality == 2) then
		return 0.1176, 1.0, 0;
	elseif (quality == 3) then
		return 0, 0.4392, 0.8667;
	elseif (quality == 4) then
		return 0.6392, 0.2078, 0.9333;
	else
		return 1, 0.502, 0;
	end
end

function Legacy_QualityColorHex(quality)
	if (quality == 0 or quality == 1) then
		return "ffffff";
	elseif (quality == 2) then
		return "1eff00";
	elseif (quality == 3) then
		return "0070dd";
	elseif (quality == 4) then
		return "a335ee";
	else
		return "ff8000";
	end
end

function Legacy_ConvertSecToDay(sec)
	return format("%d天", sec/86400 + 0.5);
end

function Legacy_GetClassName(cl)
	if (cl == "MAGE") then
		return "法师";
	elseif (cl == "ROGUE") then
		return "盗贼";
	elseif (cl == "SHAMAN") then
		return "萨满";
	elseif (cl == "WARRIOR") then
		return "战士";
	elseif (cl == "PRIEST") then
		return "牧师";
	elseif (cl == "HUNTER") then
		return "猎人";
	elseif (cl == "WARLOCK") then
		return "术士";
	elseif (cl == "PALADIN") then
		return "圣骑士";
	elseif (cl == "DRUID") then
		return "德鲁伊";
	elseif (cl == "DEATHKNIGHT") then
		return "死亡骑士";
	else
		return "脚男";
	end
end

function Legacy_GetColorHex(hex)
	return tonumber("0x"..string.sub(hex,1,2))/255, tonumber("0x"..string.sub(hex,3,4))/255, tonumber("0x"..string.sub(hex,5,6))/255
end

function Legacy_GetClassColor(cl)
	return LEGACY_CLASS_COLOR[cl].r, LEGACY_CLASS_COLOR[cl].g, LEGACY_CLASS_COLOR[cl].b, 1;
end

function Legacy_GetClassColorShift(cl, s)
	return min(1, LEGACY_CLASS_COLOR[cl].r + s), min(1, LEGACY_CLASS_COLOR[cl].g + s), min(1, LEGACY_CLASS_COLOR[cl].b + s), 1;
end

function Legacy_GetClassShade(cl, a)
	return LEGACY_CLASS_COLOR[cl].r, LEGACY_CLASS_COLOR[cl].g, LEGACY_CLASS_COLOR[cl].b, a;
end

function Legacy_GetQualityColor(q)
	return LEGACY_QUALITY_COLOR[q].r, LEGACY_QUALITY_COLOR[q].g, LEGACY_QUALITY_COLOR[q].b, 1;
end

function Legacy_GetQualityColorShift(q, s)
	return min(1, LEGACY_QUALITY_COLOR[q].r + s), min(1, LEGACY_QUALITY_COLOR[q].g + s), min(1, LEGACY_QUALITY_COLOR[q].b + s), 1;
end

function Legacy_GetQualityShade(q, a)
	return LEGACY_QUALITY_COLOR[q].r, LEGACY_QUALITY_COLOR[q].g, LEGACY_QUALITY_COLOR[q].b, a;
end

function Legacy_GetSpecialtyResetCost()
	local p = Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_ARMFORCE];
	p = p + Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_INSTINCT];
	p = p + Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_WILLPOWER];
	p = p + Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_SANITY];
	p = p + Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_PYSCHE];
	p = p + Legacy.Data.Character.Specialty.Stat[LEGACY_SPECIALTY_TRIAL];
	return p*p;
end