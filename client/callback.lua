-- Tech Development
-- Another free script
-- Join now: https://discord.gg/tHAbhd94vS

RegisterNUICallback('deposit', function(data, cb)
    local amount = tonumber(data.amount)
    local money = TriggerServerCallback('ricky_bossmenu:deposit', amount, data.job)
    cb(money)
end)

RegisterNUICallback('withdraw', function(data, cb)
    local amount = tonumber(data.amount)
    local money = TriggerServerCallback('ricky_bossmenu:withdraw', amount, data.job)
    cb(money)
end)

RegisterNUICallback('setNote', function(data)
    TriggerServerEvent('ricky_bossmenu:setNote', data.job, data)
end)

RegisterNUICallback('editSalary', function(data)
    TriggerServerEvent('ricky_bossmenu:editSalary', data.job, data.salary, data.grade)
end)

RegisterNUICallback('editGrade', function(data)
    TriggerServerEvent('ricky_bossmenu:editGrade', data)
end)

RegisterNUICallback('firePlayer', function(data)
    TriggerServerEvent('ricky_bossmenu:firePlayer', data)
end)

RegisterNUICallback('removeAvatar', function(data)
    TriggerServerEvent('ricky_bossmenu:removeAvatar', data)
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('hire', function(data)
    TriggerServerEvent('ricky_bossmenu:hire', data)
end)

RegisterNUICallback('getPlayerNearby', function(data, cb)
    cb(GetNearbyPlayers())
end)

RegisterNUICallback('getTime', function(data, cb)
    local time = TriggerServerCallback('ricky_bossmenu:getTime')
    cb(time)
end)