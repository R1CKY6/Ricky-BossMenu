-- Tech Development
-- Another free script
-- Join now: https://discord.gg/tHAbhd94vS

ESX = exports.es_extended:getSharedObject()

RegisterServerCallback = function(name, cb)
    ESX.RegisterServerCallback(name, cb)
end

getPlayer = function(source)
    return ESX.GetPlayerFromId(source)
end

getPlayerFromIdentifier = function(identifier)
    return MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier,
  })
end

GetPlayTime = function(src)
    local xPlayer = getPlayer(src)
    if not xPlayer then return end
    local result =  MySQL.Sync.fetchAll("SELECT * FROM ricky_bossmenu WHERE identifier = @identifier", {
          ['@identifier'] = xPlayer.identifier,
    })
    return result[1].playTime or 0
end

GetGrades = function(job)
    local Grades = {}
    local Table = MySQL.Sync.fetchAll("SELECT * FROM job_grades WHERE job_name = @job", {
        ['@job'] = job,
    })
    for k,v in pairs(Table) do 
        table.insert(Grades, {
            label = v.label,
            name = v.name,
            number = v.grade,
            salary = v.salary,
        })
    end
    return Grades
end

getFrameworkPlayerFromIdentifier = function(identifier)
    return ESX.GetPlayerFromIdentifier(identifier)
end

getRankLabel = function(job, numberGrade)
    local result = MySQL.Sync.fetchAll("SELECT * FROM job_grades WHERE job_name = @job AND grade = @grade", {
        ['@job'] = job,
        ['@grade'] = numberGrade,
    })
    return result[1].label
end

GetEmployee = function(job)
    local employees = {}
    local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_bossmenu WHERE job = @job", {
        ['@job'] = job,
    })

    for k,v in pairs(result) do 
        local xPlayer = getPlayerFromIdentifier(v.identifier)
        local player = getFrameworkPlayerFromIdentifier(v.identifier)
        local online = false
        local id = false
        local avatar = false
        
        if player then 
            online = true
            id = player.source
        end

        table.insert(employees, {
            identifier = v.identifier,
            fullName = xPlayer[1].firstname .. " " .. xPlayer[1].lastname,
            grade = getRankLabel(xPlayer[1].job, xPlayer[1].job_grade),
            gradeName = xPlayer[1].job_grade,
            playTime = GetTemplatePlayTime(v.playTime) or 0,
            online = online,
            id = id,
            note = v.note or "",
            hiredFrom = v.hiredFrom or "Unknown",
            hireDate = v.hireDate or "Unknown",
            noteUpdate = v.noteUpdate or "Never",
            avatar = v.avatar or false,
        })
    end

    return employees
end

GetTemplatePlayTime = function(playTimeMinute)
    local day = math.floor(playTimeMinute / 1440)
    local hour = math.floor((playTimeMinute - (day * 1440)) / 60)
    local minute = math.floor(playTimeMinute - (day * 1440) - (hour * 60))
    return day .. "D/" .. hour .. "H/" .. minute .. "M"
end

checkJobInDb = function(jobName)
    local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_bossmenu_society WHERE job = @job", {
        ['@job'] = jobName,
    })

    if not result[1] then 
        MySQL.Sync.execute("INSERT INTO ricky_bossmenu_society (job, money) VALUES(@job, @money)", {
            ['@job'] = jobName,
            ['@money'] = 0,
        })
    end
end


CheckPlayerInDbFromIdentifier = function(identifier, job)
    local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_bossmenu WHERE identifier = @identifier AND job = @job", {
        ['@identifier'] = identifier,
        ['@job'] = job,
    })

    if result[1] then 
        return true
    else
        return false
    end
end

GetDiscordLicense = function(src)
    local discord = nil
    for k,v in pairs(GetPlayerIdentifiers(src))do
            
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
           discord = v:gsub("discord:", "")
        end
    end

    while discord == nil do
        Wait(0)
    end
    return discord
end

GetAvatar = function(src)
    local token = ConfigS.DiscordToken
    local idDiscord = tonumber(GetDiscordLicense(src))
    local url = "https://discord.com/api/v8/users/"..idDiscord
    local avatarUrl = nil
    if(token == nil or token == "") then
        -- print("You need to put your discord token in the config file")
        return "https://cdn.discordapp.com/attachments/944572269202640946/1023536303180107856/tech2.png"
    end
    PerformHttpRequest(url, function(err, text, headers) 
        local data = json.decode(text)
        if not data then 
            -- print("You need to put a valid discord token in the config file")
            return "https://cdn.discordapp.com/attachments/944572269202640946/1023536303180107856/tech2.png"
        end
        local username = data.display_name
        local avatar = data.avatar
        avatarUrl = "https://cdn.discordapp.com/avatars/" .. data.id .. "/" .. avatar .. ".png"
    end, "GET", "", {["Authorization"] = "Bot "..token})
    while avatarUrl == nil do
        Wait(0)
    end
    return avatarUrl
end

AddPlayerToDb = function(source, job, hiredFrom)
    local xPlayer = getPlayer(source)
    if not xPlayer then return end

    
    MySQL.Sync.execute('DELETE FROM ricky_bossmenu WHERE identifier = @identifier',{
       ['@identifier'] = GetIdentifier(source)
    })

    MySQL.Sync.execute("INSERT INTO ricky_bossmenu (identifier, job, hireDate, playTime, hiredFrom, avatar) VALUES(@identifier, @job, @hireDate, @playTime, @hiredFrom, @avatar)", {
        ['@identifier'] = GetIdentifier(source),
        ['@job'] = job,
        ['@hireDate'] = os.date(Config.DateFormat.hire),
        ['@playTime'] = 0,
        ['@hiredFrom'] = hiredFrom or "Unknown",
        ['@avatar'] = GetAvatar(source) or false,
    })
end

GetPlayerMoney = function(source)
    local xPlayer = getPlayer(source)
    if not xPlayer then return end

    return xPlayer.getAccount('money').money
end

GetSocietyMoney = function(job)
    local result = MySQL.Sync.fetchAll("SELECT * FROM ricky_bossmenu_society WHERE job = @job", {
        ['@job'] = job,
    })

    return tonumber(result[1].money or 0)
end


canOpen = function(source, job, grade, returnId)
    local player = getPlayer(source)
    if not player then return end
    local currentJob = player.job.name
    local currentGrade = player.job.grade
    if currentJob == job and currentGrade >= grade then
        if not returnId then  
            return true
        else
            return tonumber(source) 
        end
    else
        return false
    end
end

RemovePlayerFromDb = function(src)
    local xPlayer = getPlayer(src)
    if not xPlayer then return end

    MySQL.Sync.execute("DELETE FROM ricky_bossmenu WHERE identifier = @identifier", {
        ['@identifier'] = GetIdentifier(src),
    })
end

GetIdentifier = function(src)
    local player = getPlayer(src)
    if not player then return end
    return player.identifier
end