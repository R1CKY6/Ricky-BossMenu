-- Tech Development
-- Another free script
-- Join now: https://discord.gg/tHAbhd94vS

RegisterServerCallback('ricky_bossmenu:getBossMenuData', function(source, cb, job)
    local myIdentifier = GetIdentifier(source) 
    
    local data = {
        employee = GetEmployee(job),
        grades = GetGrades(job),
        time = os.date(Config.DateFormat.dashboard),
        time2 = os.date(Config.DateFormat.dashboardTime),
        myIdentifier = myIdentifier,
        societyInfo = {
            label = Config.Job[job].label,
            job = job,
            creationDate = Config.Job[job].creationDate,
            logo = Config.Job[job].logo,
            money = GetSocietyMoney(job),
        },
    }

    cb(data)
end)

RegisterServerCallback('ricky-bossmenu:getSocietyMoney', function(source, cb, job)
    local money = GetSocietyMoney(job)
    cb(money)
end)

RegisterServerEvent('ricky-bossmenu:playerLoaded')
AddEventHandler('ricky-bossmenu:playerLoaded', function(jobTable)
    local src = source
    local xPlayer = getPlayer(src)
    if not xPlayer then return end
    local job = xPlayer.job.name 

    for k,v in pairs(Config.Job) do 
        if job == k then 
            TriggerClientEvent('ricky-bossmenu:refreshEmployee', -1, job)
            if not CheckPlayerInDbFromIdentifier(GetIdentifier(src), job) then 
                AddPlayerToDb(src, job, nil)
            end

            -- Only for prevent bug
            if jobTable then 
                MySQL.Sync.execute("UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier", {
                    ['@identifier'] = GetIdentifier(src),
                    ['@job'] = job,
                    ['@job_grade'] = jobTable.grade
                })
            else
                MySQL.Sync.execute("UPDATE ricky_bossmenu SET avatar = @avatar WHERE identifier = @identifier", {
                    ['@identifier'] = GetIdentifier(src),
                    ['@avatar'] = GetAvatar(src) or false
                })
            end
            
            return
        end
    end
    RemovePlayerFromDb(src)
end)

RegisterServerEvent('ricky-bossmenu:loadJobs')
AddEventHandler('ricky-bossmenu:loadJobs', function()
    local jobs = Config.Job
    for k,v in pairs(jobs) do 
        checkJobInDb(k)
    end
end)


RegisterServerCallback('ricky_bossmenu:deposit', function(source, cb, amount, job)
    local money = GetPlayerMoney(source)
    if money >= amount then 
        local xPlayer = getPlayer(source)
        if not xPlayer then return end

        xPlayer.removeAccountMoney('money', amount)

        local newMoney = GetSocietyMoney(job) + amount

        MySQL.Sync.execute("UPDATE ricky_bossmenu_society SET money = @money WHERE job = @job", {
            ['@money'] = newMoney,
            ['@job'] = job
        })
        TriggerClientEvent('ricky-bossmenu:refreshMoney', -1, job, newMoney)
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerCallback('ricky_bossmenu:withdraw', function(source, cb, amount, job)
    local money = GetSocietyMoney(job)
    if money >= amount then 
        local xPlayer = getPlayer(source)
        if not xPlayer then return end

        xPlayer.addAccountMoney('money', tonumber(amount))

        local newMoney = GetSocietyMoney(job) - amount

        MySQL.Sync.execute("UPDATE ricky_bossmenu_society SET money = @money WHERE job = @job", {
            ['@money'] = newMoney,
            ['@job'] = job
        })
        TriggerClientEvent('ricky-bossmenu:refreshMoney', -1, job, newMoney)
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('ricky_bossmenu:setNote')
AddEventHandler('ricky_bossmenu:setNote', function(job, data)
    local src = source
    local xPlayer = getPlayer(src)
    if not xPlayer then return end

    local noteUpdate = os.date(Config.DateFormat.note)
    MySQL.Sync.execute("UPDATE ricky_bossmenu SET note = @note, noteUpdate = @noteUpdate WHERE identifier = @identifier AND job = @job", {
        ['@note'] = data.note,
        ['@noteUpdate'] = noteUpdate,
        ['@identifier'] = data.identifier,
        ['@job'] = job,
    })

    TriggerClientEvent('ricky-bossmenu:refreshEmployee', canOpen(src, job, Config.Job[job].minGrade, true), job)
end)

RegisterServerEvent('ricky_bossmenu:editSalary')
AddEventHandler('ricky_bossmenu:editSalary', function(job, salary, grade)
    MySQL.Sync.execute("UPDATE job_grades SET salary = @salary WHERE job_name = @job AND name = @grade", {
        ['@job'] = job,
        ['@grade'] = grade,
        ['@salary'] = salary,
    })
    TriggerClientEvent('ricky-bossmenu:refreshGrades', -1, job)
end)

RegisterServerEvent('ricky_bossmenu:editGrade')
AddEventHandler('ricky_bossmenu:editGrade', function(data)
    MySQL.Sync.execute("UPDATE users SET job_grade = @job_grade WHERE identifier = @identifier", {
        ['@identifier'] = data.employeeIdentifier,
        ['@job_grade'] = data.grade
    })
    local player = getFrameworkPlayerFromIdentifier(data.employeeIdentifier)
    if player then 
        player.setJob(data.job, data.grade)
    end
    TriggerClientEvent('ricky-bossmenu:refreshEmployee', -1, data.job)
end)

RegisterServerEvent('ricky_bossmenu:firePlayer')
AddEventHandler('ricky_bossmenu:firePlayer', function(data)
    MySQL.Sync.execute("UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier", {
        ['@identifier'] = data.employeeIdentifier,
        ['@job'] = Config.UnemployedJob.name,
        ['@job_grade'] = Config.UnemployedJob.grade
    })
    
    local player = getFrameworkPlayerFromIdentifier(data.employeeIdentifier)
    if player then 
        player.setJob(Config.UnemployedJob.name, Config.UnemployedJob.grade)
    end

    MySQL.Sync.execute('DELETE FROM ricky_bossmenu WHERE identifier = @identifier AND job = @job',{
        ['@identifier'] = data.employeeIdentifier,
        ['@job'] = data.job
    })
    TriggerClientEvent('ricky-bossmenu:refreshEmployee', -1, data.job)
end)

RegisterServerEvent('ricky_bossmenu:removeAvatar')
AddEventHandler('ricky_bossmenu:removeAvatar', function(data)
    local identifier = GetIdentifier(source)
    MySQL.Sync.execute("UPDATE ricky_bossmenu SET avatar = @avatar WHERE identifier = @identifier", {
        ['@identifier'] = identifier,
        ['@avatar'] = nil
    })
    TriggerClientEvent('ricky-bossmenu:refreshEmployee', -1, data.job)
end)

RegisterServerCallback('ricky-bossmenu:getScreenshotWebhook', function(source, cb)
    cb(ConfigS.Webhook)
end)

RegisterServerEvent('ricky-bossmenu:updateAvatar')
AddEventHandler('ricky-bossmenu:updateAvatar', function(avatar, job)
    local identifier = GetIdentifier(source)
    MySQL.Sync.execute("UPDATE ricky_bossmenu SET avatar = @avatar WHERE identifier = @identifier", {
        ['@identifier'] = identifier,
        ['@avatar'] = avatar
    })
    TriggerClientEvent('ricky-bossmenu:refreshEmployee', -1, job)
end)

RegisterServerEvent('ricky_bossmenu:hire')
AddEventHandler('ricky_bossmenu:hire', function(data)
  local src = source
  local xPlayer = getPlayer(src)
  local xTarget = getPlayer(data.id)
  if not xPlayer then return end
  if not xTarget then return end

  AddPlayerToDb(data.id, data.job, GetPlayerName(src)) 

  MySQL.Sync.execute("UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier", {
      ['@identifier'] = xTarget.identifier,
      ['@job'] = data.job,
      ['@job_grade'] = 0
  })
  xTarget.setJob(data.job, 0)
end)

RegisterServerCallback('ricky_bossmenu:getPlayerJob', function(source, cb, id)
    local xPlayer = getPlayer(id)
    if not xPlayer then return end
    local job = xPlayer.job.name
    cb(job)
end)

RegisterServerEvent('ricky-bossmenu:incrementPlayTime')
AddEventHandler('ricky-bossmenu:incrementPlayTime', function()
  local src = source
  local xPlayer = getPlayer(src)
    if not xPlayer then return end
    local job = xPlayer.job.name
    local playTime = GetPlayTime(src)
    local newPlayTime = playTime + 1
    MySQL.Sync.execute("UPDATE ricky_bossmenu SET playTime = @playTime WHERE identifier = @identifier AND job = @job", {
        ['@identifier'] = GetIdentifier(src),
        ['@job'] = job,
        ['@playTime'] = newPlayTime
    })
end)


ESX.RegisterServerCallback('ricky_bossmenu:getTime', function(source, cb)
    local time = {
        time1 = os.date(Config.DateFormat.dashboard),
        time2 = os.date(Config.DateFormat.dashboardTime),
    }
    cb(time)
end)

-- Exports
exports('GetSocietyMoney', function(job)
    local money = GetSocietyMoney(job)
    return money or 0
end)