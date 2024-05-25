local HTML = ""
local CallSigns = {}
local radio = 0

local QBCore = exports['qb-core']:GetCoreObject()



RegisterCommand("phub", function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)

    if xPlayer.PlayerData.job.name == "police" then
        local type = "toggle"
        TriggerEvent("OS:officers:refresh")
        
        if args[1] == "0" then
            type = "drag"
        end

        TriggerClientEvent("OS:officers:open", src, type)
    end
end)

RegisterCommand("duty", function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)

    if xPlayer.PlayerData.job.name == "police" then
        local type = "toggle"
        TriggerEvent("OS:officers:refresh")
        
        if args[1] == "0" then
            type = "drag"
        end

        TriggerClientEvent("es-policejob:ToggleDuty", src, type)
    end
end)

RegisterServerEvent('DoSomeWork')
AddEventHandler('DoSomeWork', function()
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)

    if xPlayer.PlayerData.job.name == "police" then
        local type = "toggle"
        TriggerEvent("OS:officers:refresh")  
        TriggerClientEvent("OS:officers:open", src, type)
    end
end)

RegisterCommand("callsign", function(source, args)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer and (xPlayer.PlayerData.job.name == 'police') and args[1] then
        if args[1] == 'none' then
            xPlayer.Functions.SetMetaData("callsign", "NO TAG")
            TriggerEvent("OS:officers:refresh")
            TriggerEvent("OS:officers:refresh")
            TriggerClientEvent('QBCore:Notify', source, "Restored Callsign", "success")
        else
            xPlayer.Functions.SetMetaData("callsign", args[1])
            TriggerEvent("OS:officers:refresh")
            TriggerEvent("OS:officers:refresh")
            TriggerClientEvent('QBCore:Notify', source, "Updated Callsign: " .. args[1], "success")
        end
    end
end)

RegisterServerEvent("OS:officers:refresh")
AddEventHandler("OS:officers:refresh", function()
    local new = ""

    for k,v in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(v)
        if xPlayer and (xPlayer.PlayerData.job.name == 'police') then
            local name = GetName(v)
            local dutyClass = ""
            local duty = ""
            
            if xPlayer.PlayerData.job.onduty then
                dutyClass = 'duty'
                duty = "🟢"
            else
                dutyClass = 'offduty'
                duty = "🔴"
            end
            local radioChannel = GetRadioChannel(v)
            local radioLabel = ""

            if radioChannel ~= nil then
                if radioChannel == 0 then
                    radioLabel = "0"
                else
                    radioLabel = ' '..radioChannel
                end
            end

            local callSign = xPlayer.PlayerData.metadata["callsign"]

            if (callSign >= Config.Command_Min and callSign <= Config.Command_Max) then
                new = new .. '<div class="officer"><span class="callsign-command">' .. callSign .. '</span> <span class="name">' .. name .. '</span> | <span class="grade">' .. xPlayer.PlayerData.job.grade.name .. '</span> <span class="' .. dutyClass .. '">' .. duty .. '</span> <span class="radio"> ' .. radioLabel .. '</span></div>'
            elseif (callSign >= Config.Detective_Min and callSign <= Config.Detective_Max) then
                new = new .. '<div class="officer"><span class="callsign-detective">' .. callSign .. '</span> <span class="name">' .. name .. '</span> | <span class="grade">' .. xPlayer.PlayerData.job.grade.name .. '</span> <span class="' .. dutyClass .. '">' .. duty .. '</span> <span class="radio"> ' .. radioLabel .. '</span></div>'
            elseif (callSign >= Config.Swat_Min and callSign <= Config.Swat_Max) then
                new = new .. '<div class="officer"><span class="callsign-swat">' .. callSign .. '</span> <span class="name">' .. name .. '</span> | <span class="grade">' .. xPlayer.PlayerData.job.grade.name .. '</span> <span class="' .. dutyClass .. '">' .. duty .. '</span> <span class="radio"> ' .. radioLabel .. '</span></div>'
            elseif (callSign >= Config.Bcso_Min and callSign <= Config.Bcso_Max) then
                new = new .. '<div class="officer"><span class="callsign-bcso">' .. callSign .. '</span> <span class="name">' .. name .. '</span> | <span class="grade">' .. xPlayer.PlayerData.job.grade.name .. '</span> <span class="' .. dutyClass .. '">' .. duty .. '</span> <span class="radio"> ' .. radioLabel .. '</span></div>'
            elseif (callSign >= Config.Troopers_Min and callSign <= Config.Troopers_Min) then
                new = new .. '<div class="officer"><span class="callsign-troopers">' .. callSign .. '</span> <span class="name">' .. name .. '</span> | <span class="grade">' .. xPlayer.PlayerData.job.grade.name .. '</span> <span class="' .. dutyClass .. '">' .. duty .. '</span> <span class="radio"> ' .. radioLabel .. '</span></div>'
            elseif (callSign >= Config.Rangers_Min and callSign <= Config.Rangers_Min) then
                new = new .. '<div class="officer"><span class="callsign-rangers">' .. callSign .. '</span> <span class="name">' .. name .. '</span> | <span class="grade">' .. xPlayer.PlayerData.job.grade.name .. '</span> <span class="' .. dutyClass .. '">' .. duty .. '</span> <span class="radio"> ' .. radioLabel .. '</span></div>'
            else
                new = new .. '<div class="officer"><span class="callsign">' .. callSign .. '</span> <span class="name">' .. name .. '</span> | <span class="grade">' .. xPlayer.PlayerData.job.grade.name .. '</span> <span class="' .. dutyClass .. '">' .. duty .. '</span> <span class="radio"> ' .. radioLabel .. '</span></div>'
            end
        end
    end

    HTML = new
    TriggerClientEvent("OS:officers:refresh", -1, HTML)
end)

function GetName(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)

    if xPlayer ~= nil and xPlayer.PlayerData.charinfo.firstname ~= nil and xPlayer.PlayerData.charinfo.lastname ~= nil then
         return xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    else
        return ""
    end
end

function GetRadioChannel(source)
    return Player(source).state['radioChannel']
end

CreateThread(function()
    local result = json.decode(LoadResourceFile(GetCurrentResourceName(), "callsigns.json"))

    if result then
        CallSigns = result
    end
end)
