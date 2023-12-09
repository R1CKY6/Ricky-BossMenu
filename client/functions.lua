-- Tech Development
-- Another free script
-- Join now: https://discord.gg/tHAbhd94vS

ESX = exports.es_extended:getSharedObject()
PlayerData = {}

canOpen = function(job, grade)
    local currentJob = PlayerData.job.name
    local currentGrade = PlayerData.job.grade 

    if currentJob == job and currentGrade >= grade then 
        return true
    else
        return false
    end
end

GetCore = function()
    while ESX.GetPlayerData() == nil do
        Wait(0)
    end
    PlayerData = ESX.GetPlayerData()
end

GetCore()

TriggerServerCallback = function(name, ...)
    local data2 = nil
    ESX.TriggerServerCallback(name, function(data3) 
        data2 = data3
    end, ...)

    while data2 == nil do
        Wait(0)
    end

    return data2
end


ExistJob = function(job)
    if Config.Job[job] then 
        return true
    else
        return false
    end
end

OpenBossMenu = function(job)
    if not ExistJob(job) then return end
    if not canOpen(job, Config.Job[job].minGrade) then return end
    local data = TriggerServerCallback('ricky_bossmenu:getBossMenuData', job)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "SET_LOCALES",
        locales = Config.Locales
    })
    SendNUIMessage({
        type = "OPEN",
    })
    SendNUIMessage({
        type = "SET_DATA",
        data = data,
    })
end


GetNearbyPlayers = function()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local distance = #(GetEntityCoords(GetPlayerPed(player)) - GetEntityCoords(PlayerPedId()))
        if player ~= PlayerId() and distance < Config.HireRange then
            local playerJob = TriggerServerCallback('ricky_bossmenu:getPlayerJob', GetPlayerServerId(player))
            if playerJob ~= nil then
                if playerJob ~= PlayerData.job.name then 
                    local playerName = GetPlayerName(player)
                    local playerId = GetPlayerServerId(player)
                    table.insert(players, {
                        name = playerName,
                        id = playerId,
                    })
                end
            end
        end
    end
    return players
end