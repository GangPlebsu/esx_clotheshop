local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = exports["es_extended"]:getSharedObject()

local HasAlreadyEnteredMarker = false
local LastZone                = nil
local CurrentAction           = nil
local CurrentActionMsg        = ''
local CurrentActionData       = {}
local HasPayed                = false
local PlayerData = {}

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(1000)
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.mask_1 == 163 or skin.mask_1 == 164 or skin.mask_1 == 165 or skin.mask_1 == 167 then
                TriggerEvent('skinchanger:loadClothes', skin, Config.RemoveList[5])
                ESX.ShowNotification(_U('bugg'))
            end 
        end)
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.helmet_1 == 146 then 
				TriggerEvent('skinchanger:loadClothes', skin, Config.RemoveList[2])
				ESX.ShowNotification(_U('bug'))
			end
		end)
    end
end)


function OpenShopMenu()
	ESX.ShowNotification(_U('5s'))
	Wait(5000)
	HasPayed = false
	TriggerEvent('esx_skin:openRestrictedMenu', function(data, menu)
		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'esx_clotheshop',
			{
				title = _U('valid_this_purchase'),
				align = 'center',
				elements = {
					{label = _U('yes'), value = 'yes'},
					{label = _U('no'), value = 'no'},
				}
			},
			function(data, menu)
				menu.close()
				if data.current.value == 'yes' then
					ESX.TriggerServerCallback('esx_clotheshop:buyClothes', function(bought)
						if bought then
							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('esx_skin:save', skin)
							end)
							TriggerServerEvent('esx_clotheshop:pay')
							HasPayed = true
							ESX.TriggerServerCallback('esx_clotheshop:checkPropertyDataStore', function(foundStore)
								if foundStore then
									ESX.UI.Menu.Open(
										'default', GetCurrentResourceName(), 'esx_clotheshop',
										{
											title = _U('save_in_dressing'),
											align = 'center',
											elements = {
												{label = _U('yes'), value = 'yes'},
												{label = _U('no'),  value = 'no'},
											}
										},
										function(data2, menu2)
											menu2.close()
											if data2.current.value == 'yes' then
												ESX.UI.Menu.Open(
													'dialog', GetCurrentResourceName(), 'esx_clotheshop',
													{
														title = _U('name_outfit'),
													},
													function(data3, menu3)
														menu3.close()
														TriggerEvent('skinchanger:getSkin', function(skin)
															TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
														end)
														ESX.ShowNotification(_U('save'))
													end,
													function(data3, menu3)
														menu3.close()
													end
												)
											end

										end
									)

								end

							end)

						else

							TriggerEvent('esx_skin:getLastSkin', function(skin)
								TriggerEvent('skinchanger:loadSkin', skin)
							end)

							ESX.ShowNotification(_U('money'))
						end

					end)

				end

				if data.current.value == 'no' then

					TriggerEvent('esx_skin:getLastSkin', function(skin)
						TriggerEvent('skinchanger:loadSkin', skin)
					end)

				end

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}

			end,
			function(data, menu)

				menu.close()

				CurrentAction     = 'shop_menu'
				CurrentActionMsg  = _U('press_menu')
				CurrentActionData = {}

			end
		)

	end, function(data, menu)

			menu.close()

			CurrentAction     = 'shop_menu'
			CurrentActionMsg  = _U('press_menu')
			CurrentActionData = {}

	end, {
		'chain_1',
		'chain_2',
		'mask_1',
		'mask_2',
		'tshirt_1',
		'tshirt_2',
		'torso_1',
		'torso_2',
		'decals_1',
		'decals_2',
		'arms',
		'pants_1',
		'pants_2',
		'shoes_1',
		'shoes_2',
		'chain_1',
		'chain_2',
        'watches_1',
        'watches_2',
		'helmet_1',
		'helmet_2',
		'glasses_1',
		'glasses_2',
        'bags_1',
        'bags_2',
	})

end

for i=1, #Config.Lokalizacja do
	exports.qtarget:AddBoxZone(Config.Lokalizacja[i].Name, Config.Lokalizacja[i].coords, Config.Lokalizacja[i].length, Config.Lokalizacja[i].width, {
		name = Config.Lokalizacja[i].Name,
		heading = 0,
		debugPoly = Config.Lokalizacja[i].debugPoly,
		minZ = Config.Lokalizacja[i].minZ,
		maxZ = Config.Lokalizacja[i].maxZ,
	}, {
		options = {
			{
				action = function(entity)
					OpenShopMenu()
				end,
				icon = "fas fa-shopping-basket",
				label = _U('offert'),
				zone = zone,
				num = 1,
			},
			{
				action = function(entity)
					OpenSavedClothesMenu()
				end,
				icon = "fa-solid fa-shirt",
				label = _U('desk'),
				num = 2,
			},
			{
				event = "esx_clotheshop:save",
				icon = "fa-solid fa-clipboard",
				label = _U('save_eup'),
				num = 3,
			},
			{
				action = function(entity)
					OpenDelClothesMenu()
				end,
				icon = "fa-solid fa-clipboard",
				label = _U('del_eup'),
				num = 4,
			},
		},
		distance = 2
	})
end

for i=1, #Config.Lokalizacja do

	local blip = AddBlipForCoord(Config.Lokalizacja[i].coord.x, Config.Lokalizacja[i].coord.y, Config.Lokalizacja[i].coord.z)

	SetBlipSprite (blip, 73)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.7)
	SetBlipColour (blip, 2)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(_U('shop'))
	EndTextCommandSetBlipName(blip)
end

function OpenSavedClothesMenu()
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}

		for i=1, #dressing, 1 do
			table.insert(elements, {
				label = dressing[i],
				value = i
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_clotheshop', {
			title    = _U('seves_eup'),
			align    = 'top-left',
			elements = elements
		}, function(data2, menu2)
			TriggerEvent('skinchanger:getSkin', function(skin)
				ESX.TriggerServerCallback('esx_property:getPlayerOutfit', function(clothes)
					TriggerEvent('skinchanger:loadClothes', skin, clothes)
					TriggerEvent('esx_skin:setLastSkin', skin)

					TriggerEvent('skinchanger:getSkin', function(skin)
						TriggerServerEvent('esx_skin:save', skin)
					end)
				end, data2.current.value)
			end)
		end, function(data2, menu2)
			menu2.close()
		end)
	end)
end

function OpenDelClothesMenu()
	ESX.TriggerServerCallback('esx_property:getPlayerDressing', function(dressing)
		local elements = {}
		for i=1, #dressing, 1 do
			table.insert(elements, {label = dressing[i], value = i})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'esx_clotheshop', {
			title    = _U('dele_eup'),
			align    = 'left',
			elements = elements,
		}, function(data, menu)
			menu.close()
			TriggerServerEvent('esx_clotheshop:deleteOutfit', data.current.value)
			ESX.ShowNotification(_U('deles_eup'))

		end, function(data, menu)
			menu.close()
		end)
	end)
end

AddEventHandler('esx_clotheshop:save', function()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'esx_clotheshop', {
		title = _U('name')
	}, function(data3, menu3)
		menu3.close()

		TriggerEvent('skinchanger:getSkin', function(skin)
			TriggerServerEvent('esx_clotheshop:saveOutfit', data3.value, skin)
		end)
	end, function(data3, menu3)
		menu3.close()
	end)
end)