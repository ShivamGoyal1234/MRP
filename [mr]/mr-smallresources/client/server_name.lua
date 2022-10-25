function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

CreateThread(function()
  AddTextEntry('FE_THDR_GTAO', 'Mirzapur Roleplay - MR- Framework')
end)
