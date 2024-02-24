-- Tech Development
-- Another free script
-- Join now: https://discord.gg/tHAbhd94vS

Config = {}

Config.HireRange = 2.5

Config.UseESXAddonAccount = true

Config.DateFormat = { -- https://www.lua.org/pil/22.1.html
    dashboard = '%A, %d %B %Y',
    dashboardTime = '%H:%M',
    note = '%d/%m/%y %H:%M',
    hire = '%d/%m/%y',
}

Config.MarkerSettings = {
    type = 2,
    color = {r = 0, g = 255, b = 0, a = 200},
    scale = {x = 0.7, y = 0.7, z = 0.7},
    bump = false,
    rotate = true
}

Config.UnemployedJob = {
    name = 'unemployed',
    grade = 0,
}

Config.Job = {
    ['police'] = {
        label = 'Police Department',
        minGrade = 1,
        creationDate = '01/01/2021',
        logo = "https://cdn.discordapp.com/attachments/944572269202640946/1023536303180107856/tech2.png",
        coords = {
           vec3(439.845856, -982.529419, 30.689310)
        }
    },
    ['ambulance'] = {
        label = 'EMS',
        minGrade = 1,
        creationDate = '01/01/2021',
        logo = "https://cdn.discordapp.com/attachments/944572269202640946/1023536303180107856/tech2.png"
    },
}

Config.Locales = {
    ['society_informations'] = "Society Informations",
    ['society_money'] = "Society Money",
    ['employee'] = "Employee",
    ['since'] = "Since",
    ['welcome'] = "Welcome!",
    ['rank'] = "Rank",
    ['play_time'] = "Play Time",
    ['hire'] = "Hire",
    ['actions'] = "Actions",
    ['amount'] = "Amount",
    ['withdraw_money'] = "Withdraw Money",
    ['deposit_money'] = "Deposit Money",
    ['dashboard'] = "Dashboard",
    ['confirm'] = "Confirm",
    ['invalid_amount'] = "Invalid amount",
    ['edit_grade'] = "Edit Grade",
    ['last_update'] = "Last Update",
    ['fire'] = "Fire",
    ['employee_managament'] = "Employee Managament",
    ['employee_info'] = "Employee Info",
    ['hired_from'] = "Hired From",
    ['status'] = "Status",
    ['input_employee'] = "Search From Name",
    ['grade_list'] = "Grades List",
    ['employees'] = "Employees",
    ['grade_managament'] = "Grade Managament",
    ['edit_salary'] = "Edit Salary",
    ['sure_fire'] = "Are you sure to fire this employee?",
    ['cancel'] = "Cancel",
    ['no_player'] = "Nobody",
    ['online'] = "Online",
    ['offline'] = "Offline",
    ['currency'] = "$",
    ['no_money'] = "You don't have enough money",
    ['sure_remove_avatar'] = "Are you sure to remove your avatar?",
    ['no_fire_yourself'] = "You can't fire yourself",
    ['salary_edited'] = "You have edited the salary",
    ['grade_edited'] = "You have edited the grade",
    ['withdrawn'] = "You withdrew %s",
    ['deposited'] = "You deposited %s",
    ['fired'] = "You have fired %s",
    ['press_to_open'] = "Press ~g~[E]~w~ to open the boss menu"
}
