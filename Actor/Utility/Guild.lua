function Legacy_GuildBonusUnlockAt(level)
	return 0;
end

function Legacy_IsCurrentGuildBonus(index, spell)
	return Legacy.Data.Guild.Bonus[index].spell == spell;
end
