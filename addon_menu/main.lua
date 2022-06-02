_menuPool = NativeUI.CreatePool()
mainMenu =  NativeUI.CreateMenu("Addon Vehicles", "~b~Spawn any add on vehicle here")
_menuPool:Add(mainMenu)

function FirstItem(menu) 
    local submenu = _menuPool:AddSubMenu(menu, "LEO Vehicles")
    local carItem = NativeUI.CreateItem("Bugatti Bolide", "Spawns the Bolide!")
    carItem.Activated = function(sender,item)
        if item == carItem then
            deleteVeh()
            spawnCar("bolide")
        end
    end
    local carItem2 = NativeUI.CreateItem("911 Turbo", "Spawns the 911 Turbo")
    carItem2.Activated = function(sender,item)
        if item == carItem2 then
            deleteVeh()
            spawnCar("911turboleo")
        end
    end
    local carItem3 = NativeUI.CreateItem("BMW M5", "Spawns the BMW M5")
    carItem3.Activated = function(sender,item)
        if item == carItem3 then
            deleteVeh()
            spawnCar("m5rb_vv")
        end
    end
    submenu:AddItem(carItem)
    submenu:AddItem(carItem2)
    submenu:AddItem(carItem3)
end


FirstItem(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 166) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)

RegisterCommand('vehmenu', function()
    mainMenu:Visible(not mainMenu:Visible())
end, false)




----- Things That dont touch

function spawnCar(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do 
        RequestModel(car)
        Citizen.Wait(50)
    end

    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, x + 2, y + 2, z + 1, GetEntityHeading(PlayerPedId()), true, false)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)

    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(vehicleName)

    --[[ SetEntityAsMissionEntity(vehicle, true, true) ]]
end

function deleteVeh()
    local ped = GetPlayerPed(-1)
    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then
        local pos = GetEntityCoords(ped)

        if(IsPedSittingInAnyVehicle(ped)) then
            local handle = GetVehiclePedIsIn(ped, false)
            NetworkRequestControlOfEntity(handle)
            SetEntityHealth(handle, 100)
            SetEntityAsMissionEntity(handle, true, true)
            SetEntityAsNoLongerNeeded(handle)
            DeleteEntity(handle)
        end
    end
end

function ShowInfo(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0, 1)
end