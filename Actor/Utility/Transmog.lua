function Legacy_TransmogCollected(entry)
	return Legacy.Data.Transmog.Collection[entry] == true;
end

function Legacy_IsCurrentTransmog(slot, item)
	return Legacy.Data.Transmog.Slot[slot] == item;
end

function Legacy_ActivateTransmog(slot, entry)
	Legacy_DoQuery(LMSG_A_ACTIVATE_TRANSMOG_FOR_SLOT, slot..":"..entry);
end