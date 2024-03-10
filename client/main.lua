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

RegisterNetEvent('ricky-bossmenu:openMenu')
AddEventHandler('ricky-bossmenu:openMenu', function(job)
    OpenBossMenu(job)
end)

-- Exports
exports('OpenBossMenu', function(job)
    OpenBossMenu(job)
end)

exports('GetSocietyMoney', function(job)
    local money = TriggerServerCallback('ricky-bossmenu:getSocietyMoney', job)
    return money or 0
end)

exports('AddMoneyToSociety', function(job, amount)
    TriggerServerEvent('ricky-bossmenu:AddMoneyToSociety', job, amount)
end)

exports('RemoveMoneyFromSociety', function(job, amount)
    TriggerServerEvent('ricky-bossmenu:RemoveMoneyFromSociety', job, amount)
end)


local markerWait = 1000
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(markerWait)
     for a,b in pairs(Config.Job) do
        if PlayerData.job then 
            if PlayerData.job.name == a and PlayerData.job.grade >= b.minGrade then 
                for k,v in pairs(b.coords) do 
                    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x, v.y, v.z, true)
                    if distance < 10 then
                        markerWait = 1
                        DrawMarker(Config.MarkerSettings.type, v.x, v.y, v.z, 0, 0, 0, 0, 0, 0, Config.MarkerSettings.scale.x,Config.MarkerSettings.scale.y,Config.MarkerSettings.scale.z, Config.MarkerSettings.color.r,Config.MarkerSettings.color.g,Config.MarkerSettings.color.b, Config.MarkerSettings.color.a, Config.MarkerSettings.bump, 0, 0, Config.MarkerSettings.rotate)
    
                        if distance < 1 then 
                            ESX.ShowHelpNotification(Config.Locales.press_to_open)
                            if IsControlJustReleased(0, 38) then 
                                OpenBossMenu(a)
                            end
                        end
                    else
                        markerWait = 1000
                    end
                end
            end
        end 
     end
   end
end)
