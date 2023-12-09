-- Tech Development
-- Another free script
-- Join now: https://discord.gg/tHAbhd94vS

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    TriggerServerEvent('ricky-bossmenu:playerLoaded', job)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    TriggerServerEvent('ricky-bossmenu:playerLoaded')
end)

Citizen.CreateThread(function()
   while not ESX.IsPlayerLoaded() do
       Citizen.Wait(100)
   end
   TriggerServerEvent('ricky-bossmenu:playerLoaded')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    TriggerServerEvent('ricky-bossmenu:loadJobs')
end)

RegisterNetEvent('ricky-bossmenu:refreshMoney')
AddEventHandler('ricky-bossmenu:refreshMoney', function(job, money)
    if not canOpen(job, Config.Job[job].minGrade) then return end
    SendNUIMessage({
        type = 'refreshMoney',
        money = money
    })
end)

RegisterNetEvent('ricky-bossmenu:refreshEmployee')
AddEventHandler('ricky-bossmenu:refreshEmployee', function(job)
    if not canOpen(job, Config.Job[job].minGrade) then return end
    local data = TriggerServerCallback('ricky_bossmenu:getBossMenuData', job)
    SendNUIMessage({
        type = 'refreshEmployee',
        employee = data.employee
    })
end)

RegisterNetEvent('ricky-bossmenu:refreshGrades')
AddEventHandler('ricky-bossmenu:refreshGrades', function(job)
    if not canOpen(job, Config.Job[job].minGrade) then return end
    local data = TriggerServerCallback('ricky_bossmenu:getBossMenuData', job)
    SendNUIMessage({
        type = 'refreshGrades',
        grades = data.grades
    })
end)


Citizen.CreateThread(function()
    while true do
        Wait(60000)
        TriggerServerEvent('ricky-bossmenu:incrementPlayTime')
    end
end)


-- Exports
exports('OpenBossMenu', function(job)
    OpenBossMenu(job)
end)

RegisterNetEvent('ricky-bossmenu:openMenu')
AddEventHandler('ricky-bossmenu:openMenu', function(job)
    OpenBossMenu(job)
end)

exports('GetSocietyMoney', function(job)
    local money = TriggerServerCallback('ricky-bossmenu:getSocietyMoney', job)
    return money or 0
end)
