ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('esx_clotheshop:pay')
AddEventHandler('esx_clotheshop:pay', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeMoney(Config.Price)
	TriggerClientEvent('esx:showNotification', _source, _U('you_paid', Config.Price))
end)

RegisterServerEvent('esx_clotheshop:saveOutfit')
AddEventHandler('esx_clotheshop:saveOutfit', function(label, skin)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)

		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skin
		})

		store.set('dressing', dressing)

	end)
end)
ESX.RegisterServerCallback('esx_clotheshop:buyClothes', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getAccount('money').money >= Config.Price then
		xPlayer.removeMoney(Config.Price)
		TriggerClientEvent('esx:showNotification', source, _U('you_paid', Config.Price))

		cb(true)
	else
		cb(false)
	end
end)

--[[
ESX.RegisterServerCallback('esx_clotheshop:checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(xPlayer.getAccount('money').count >= Config.Price)
end)
]]
ESX.RegisterServerCallback('esx_clotheshop:checkPropertyDataStore', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundStore = false

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		foundStore = true
	end)

	cb(foundStore)
end)

ESX.RegisterServerCallback('esx_clotheshop:getPropertyInventory', function(source, cb)
    local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = 0
	local items      = {}

	TriggerEvent('esx_addoninventory:getInventory', 'clotheshop', xPlayer.identifier, function(inventory)
		items = inventory.items
	end)

	cb({
		blackMoney = blackMoney,
		items      = items,
	}, xPlayer.identifier)
end)

RegisterServerEvent('esx_clotheshop:deleteOutfit')
AddEventHandler('esx_clotheshop:deleteOutfit', function(label)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        local dressing = store.get('dressing')
        if dressing == nil then
            dressing = {}
        end
        label = label
        table.remove(dressing, label)
        store.set('dressing', dressing)
    end)
end)