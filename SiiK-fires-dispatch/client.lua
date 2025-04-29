local QBCore = exports['qb-core']:GetCoreObject()

local onDuty = false
local currentBlip = nil
local pagerOpen = false

RegisterNetEvent('qb-fireemspager:client:SetDuty', function(status)
    onDuty = status
    if status then
        QBCore.Functions.Notify("You are now ON DUTY for Fire Pager.", "success")
    else
        QBCore.Functions.Notify("You are now OFF DUTY.", "error")
    end
end)

RegisterNetEvent('qb-fireemspager:client:ReceiveCall', function(data)
    if not onDuty then return end

    if Config.Pager.SoundOnDispatch then
        PlaySoundFrontend(-1, Config.Pager.SoundName, Config.Pager.SoundSet, true)
    end

    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(true)

    pagerOpen = true

    SendNUIMessage({
        action = "openPager",
        callType = data.type or "Unknown",
        callStreet = data.street or "Unknown"
    })

    currentBlip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(currentBlip, Config.Blip.Sprite)
    SetBlipColour(currentBlip, Config.Blip.Color)
    SetBlipScale(currentBlip, Config.Blip.Scale)
    SetBlipAsShortRange(currentBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("🔥 Fire Call: " .. (data.type or "Unknown Fire"))
    EndTextCommandSetBlipName(currentBlip)
end)

RegisterNetEvent('qb-fireemspager:client:AcceptCall', function()
    pagerOpen = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ action = "closePager" })

    if Config.General.AcceptNotify then
        QBCore.Functions.Notify("You have accepted the call. Respond safely!", "success")
    end
    if Config.Blip.ShowRouteOnAccept and currentBlip then
        local coords = GetBlipCoords(currentBlip)
        SetNewWaypoint(coords.x, coords.y)
    end
end)

RegisterNetEvent('qb-fireemspager:client:DeclineCall', function()
    pagerOpen = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ action = "closePager" })

    if currentBlip then
        RemoveBlip(currentBlip)
        currentBlip = nil
    end
    if Config.General.DeclineNotify then
        QBCore.Functions.Notify("You declined the call.", "error")
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if pagerOpen then
            if IsControlJustPressed(0, 38) then -- E
                TriggerEvent('qb-fireemspager:client:AcceptCall')
            elseif IsControlJustPressed(0, 45) then -- R
                TriggerEvent('qb-fireemspager:client:DeclineCall')
            end
        end
    end
end)

RegisterCommand('pageron', function()
    TriggerServerEvent('qb-fireemspager:server:SetDuty', true)
end, false)

RegisterCommand('pageroff', function()
    TriggerServerEvent('qb-fireemspager:server:SetDuty', false)
end, false)
