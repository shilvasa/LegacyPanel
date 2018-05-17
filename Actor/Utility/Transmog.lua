function LegacyPanel_TransmogCollectedAtSlot(slot)
	return 0;
end

function LegacyPanel_IsCurrentTransmog(slot, item)
	return Legacy.Data.Transmog.Slot[slot] == item;
end
