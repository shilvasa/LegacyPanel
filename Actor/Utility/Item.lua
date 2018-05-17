function Legacy_GetItemLink(entry)
	local _, link = GetItemInfo(entry);
	return link;
end

function Legacy_AddEnchantToItemLink(oldLink, enchant)
	local item, rest = string.match(oldLink,"(.*item:%d+:)%d+(.*)");
	if item and rest then
		return item..enchant..rest;
	end
	return oldLink;
end