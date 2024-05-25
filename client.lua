local QBCore = exports['qb-core']:GetCoreObject()

local Enabled = false

CreateThread(function()
    while QBCore == nil do
        Wait(1)
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
    end

    while not QBCore.Functions.GetPlayerData().job do
        Wait(1)
    end
    TriggerServerEvent("OS:officers:refresh")
end)

-- Refresh Menu --
CreateThread(function()
    while true do
        Wait(3000)
        TriggerServerEvent("OS:officers:refresh")
    end
end)
Citizen.CreateThread(function()
    while true do
        Wait(0)
         if IsControlJustReleased(0, 10)  then
            TriggerServerEvent('DoSomeWork')
         end
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(jobInfo)
    if Enabled then
        xPlayer = QBCore.Functions.GetPlayerData()
        if xPlayer.job.name ~= "police" then
            SendNUIMessage({ ['action'] = "close" })
        end
    end
    
    TriggerServerEvent("OS:officers:refresh")
end)

RegisterNetEvent("OS:officers:open")
AddEventHandler("OS:officers:open", function(type)
    if type == 'toggle' then
        if Enabled then
            Enabled = false
            SendNUIMessage({ ['action'] = 'close' })
        else
            Enabled = true
            SendNUIMessage({ ['action'] = 'open' })
        end
    elseif type == 'drag' then
        SetNuiFocus(true, true)
        SendNUIMessage({ ['action'] = 'drag' })
    end
end)

RegisterNUICallback("Close", function()
    SetNuiFocus(false, false)
end)

RegisterNetEvent("OS:officers:refresh")
AddEventHandler("OS:officers:refresh", function(data)
    SendNUIMessage({ ['action'] = 'refresh', ['data'] = data })
end)

