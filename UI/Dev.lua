function Dev_HookNpcTooltip(tooltip)
	tooltip:HookScript("OnTooltipSetUnit", function(self, ...)
		local _, unit = self:GetUnit();
		if (unit ~= nil and not UnitIsPlayer(unit)) then
			local guid = UnitGUID(unit);
			local id = tonumber(guid:sub(9, 12), 16);
			tooltip:AppendText("|cff00ff00 ["..id.."]|r");
		end
	end);
end