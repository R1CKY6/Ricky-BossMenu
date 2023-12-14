// Tech Development
// Another free script
// Join now: https://discord.gg/tHAbhd94vS

const app = new Vue({
    el: '#app',

    data: {
        nomeRisorsa : GetParentResourceName(),

        screen : 'dashboard',

        identifier : 0, // User Identifier

        employe_name : '', // Input name for search employee

        grade_name : '', // Input name for search grade

        currentTime : 'Wednesday, 20 July 2023',
        currentTime2 : '19:00',

        locales : {},

        anim : {
            ['hire'] : false,
            ['fastAction'] : true
        },

        bottomOption : [
            {
                screen : "dashboard",
            },
            {
                screen : "employee",
            },
            {
                screen : "grades",
            },
        ],

        fastActionSettings : { // (Only dashboard)
            input : false,
            playerNearby : true,
            playerName : false,
            playerID : false,
            indexSelected : 0,
            withdraw_money : false,
            deposit_money : false,
            amount : null
        },

        playerNearby : [
        ],

        employee : [
        ],

        grades : [
        ],


        societyInfo : {},

        notify : {
            enable : false,
            message : ""
        },

        employeeSelected : null,

        gradeSelected : 0, // (Only grade_information)
        gradeSelected1 : 0, // (Only employe_management)
        gradeNumberSelected : 0, // (Only grade_information)
        gradeTableSelected : {},
        firing : 0,
        editingSalary : false,
        editingGrade : false,
        viewEmployeeFromGrade : false,
    },

    methods: {

        checkUpInput(event) {
            var key = event.key
            var number = ['0','1','2','3','4','5','6','7','8','9']
            for(const[k,v] of Object.entries(number)) {
                if(key == v) {
                    return true
                }
            }
            event.preventDefault()
            return false
        },
        
        postNUI(type, data) {
            return $.post(`https://${this.nomeRisorsa}/${type}`, JSON.stringify(data))
        },

        notification(message, duration) {
            if(this.notify.enable) {
                return
            }
            if(!message) {
                message = ""
            }
            if(!duration) {
                duration = 3000
            }

            this.notify.message = message
            this.notify.enable = true
            setTimeout(() => {
                this.notify.enable = false
            }, duration);
        },

        getCode(type) {
            var path = './js/icon/' + type + '.js';
            var code = $.ajax({
                url: path,
                async: false
            }).responseText;

            // code = toString(code)
            code = code.replace('`', '')
            code = code.replace('`', '')
            return code
        },

        async changeScreen(screen) {
            if(this.screen == 'employee_information') {
                var note = document.getElementById("note")
                if(note.innerText != this.employeeSelected.note) {
                    this.postNUI('setNote', {
                        job : this.societyInfo.job,
                        note : note.innerText,
                        identifier : this.employeeSelected.identifier
                    })
                }
                note.innerText = ''
            }
            if(screen == 'dashboard') {
               var newTime = await this.postNUI('getTime')
                this.currentTime = newTime.time1
                this.currentTime2 = newTime.time2
            }
            if(screen == 'employee' && this.viewEmployeeFromGrade) {
                this.viewEmployeeFromGrade = false
                this.screen = 'grade_information'
                this.resetFastActionSettings()
                return
            }
            this.screen = screen
            this.resetFastActionSettings()
        },

        searchFromName() {
            if(this.employe_name.length > 0) {
                return this.employee.filter(employee =>
                    employee.fullName.toLowerCase().includes(this.employe_name.toLowerCase()) ||
                    employee.grade.toLowerCase().includes(this.employe_name.toLowerCase()) ||
                    employee.hireDate.toLowerCase().includes(this.employe_name.toLowerCase())
                )
            } else {
                return this.employee
            }
        },

        searchFromGrade() {
            if(this.grade_name.length > 0) {
                return this.grades.filter(grade =>
                    grade.label.toLowerCase().includes(this.grade_name.toLowerCase()) ||
                    grade.name.toLowerCase().includes(this.grade_name.toLowerCase()) 
                )
            } else {
                return this.grades
            }
        },

        getGradeEmployee(grade) {
            var employee = []
            for(const[k,v] of Object.entries(this.employee)) {
                if(v.gradeName == grade) {
                    employee.push(v)
                }
            }
            return employee
        },

        getOptionSelected(screen) {
            if(screen == 'employee') {
                if(this.screen == 'employee_information') {
                    return {
                        filter : "grayscale(0%)"
                    }
                }
            }
            if(screen == 'grades') {
                if(this.screen == 'grade_information') {
                    return {
                        filter : "grayscale(0%)"
                    }
                }
            }
            if(this.screen == screen) {
                return {
                    filter : "grayscale(0%)"
                }
            } else {
                return {
                    filter : "grayscale(100%)"
                }
            }
        },

        closeNui() {
            this.postNUI('close')
            $("#app").fadeOut(500)
        },


        previousFastAction(salary, grade) {
            if(salary || grade) {
                this.fastActionSettings.playerNearby = false
            }
            if(grade) {
                if(this.gradeSelected1 > 0) {
                    this.gradeSelected1 -= 1
                }
            } else {
                if(this.fastActionSettings.playerNearby) {
                    if(this.fastActionSettings.indexSelected > 0) {
                        this.fastActionSettings.indexSelected -= 1
                        this.fastActionSettings.playerName = this.playerNearby[this.fastActionSettings.indexSelected].name
                        this.fastActionSettings.playerID = this.playerNearby[this.fastActionSettings.indexSelected].id
                        this.anim.hire = true
                        setTimeout(() => {
                            this.anim.hire = false
                        }, 300);
                    }
                } else {
                    if(this.fastActionSettings.amount > 0) {
                        this.fastActionSettings.amount--
                        if(this.fastActionSettings.amount == 0) {
                            this.fastActionSettings.amount = null
                        }
                    } else {
                        this.fastActionSettings.amount = null
                    }
                }
            }
        },

        nextFastAction(salary, grade) {
            if(salary || grade) {
                this.fastActionSettings.playerNearby = false
            }
            if(grade) {
                if(this.gradeSelected1 < this.grades.length - 1) {
                    if(this.getMyInfo().gradeName > this.gradeSelected1) {
                        this.gradeSelected1 += 1
                    }
                }
            } else {
                if(this.fastActionSettings.playerNearby) {
                    if(this.fastActionSettings.indexSelected < this.playerNearby.length - 1) {
                        this.anim.hire = true
                        setTimeout(() => {
                            this.anim.hire = false
                        }, 300);
                        this.fastActionSettings.indexSelected += 1
                        this.fastActionSettings.playerName = this.playerNearby[this.fastActionSettings.indexSelected].name
                        this.fastActionSettings.playerID = this.playerNearby[this.fastActionSettings.indexSelected].id
                    }
                } else {
                    if(!this.fastActionSettings.amount) {
                        this.fastActionSettings.amount = 0
                    }
                    this.fastActionSettings.amount++
                }
            }
        },


        async changeFastActionSettings(type) {
            if(type == 'hire') {
                this.playerNearby = await this.postNUI('getPlayerNearby')
                if(this.playerNearby.length == 0) {
                    this.notification(this.locales.no_player)
                    return
                }
            }
            this.anim.fastAction = true 
            setTimeout(() => {
                this.anim.fastAction = false
            }, 300);
            if(type=='hire') {
                this.fastActionSettings.input = false
                this.fastActionSettings.playerName = this.playerNearby[0].name || this.locales.none
                this.fastActionSettings.playerID = this.playerNearby[0].id || 0
                this.fastActionSettings.indexSelected = 0
                this.fastActionSettings.playerNearby = true
                this.fastActionSettings.withdraw_money = false
                this.fastActionSettings.deposit_money = false
                this.fastActionSettings.amount = null
            } else if(type == 'withdraw_money') {
                this.fastActionSettings.input = true
                this.fastActionSettings.playerName = false
                this.fastActionSettings.playerID = false
                this.fastActionSettings.indexSelected = 0
                this.fastActionSettings.playerNearby = false
                this.fastActionSettings.withdraw_money = true
                this.fastActionSettings.deposit_money = false
                this.fastActionSettings.amount = null
            } else if(type == 'deposit_money') {
                this.fastActionSettings.input = true
                this.fastActionSettings.playerName = false
                this.fastActionSettings.playerID = false
                this.fastActionSettings.indexSelected = 0
                this.fastActionSettings.playerNearby = false
                this.fastActionSettings.withdraw_money = false
                this.fastActionSettings.deposit_money = true
                this.fastActionSettings.amount = null
            } else if(type == 'fire') {
                if(this.employeeSelected.identifier == this.identifier) {
                    this.notification(this.locales.no_fire_yourself)
                    return
                }
                this.firing = true
                this.editingGrade = false
            } else if(type == 'edit_grade') {
                this.editingGrade = true
                this.firing = false
            }
        },

        closeFastAction(salary, firing) {
            if(firing) {
                this.firing = false
            }
            if(salary) {
                this.editingSalary = false
            }
            this.resetFastActionSettings()
        },

        resetFastActionSettings() {
            this.fastActionSettings.input = false
            this.fastActionSettings.playerName = false
            this.fastActionSettings.playerID = false
            this.fastActionSettings.indexSelected = 0
            this.fastActionSettings.playerNearby = true
            this.fastActionSettings.withdraw_money = false
            this.fastActionSettings.deposit_money = false
            this.fastActionSettings.amount = null
            this.anim.fastAction = true
            this.editingSalary = false
            this.firing = false
            this.editingGrade = false
            this.gradeSelected1 = 0
        },

        async confirmFastAction(type) {
            if(type == 'hire') {
                var id = this.fastActionSettings.playerID
                this.postNUI('hire', {
                    job : this.societyInfo.job,
                    id : id
                })
                this.notification("Hai assunto "+this.fastActionSettings.playerName)
                this.resetFastActionSettings()
            } else if(type == 'money') {
                if(this.fastActionSettings.withdraw_money) {
                    if(!this.fastActionSettings.amount) {
                        this.notification(this.locales.invalid_amount)
                        return
                    }
                    var withdrawn = await this.postNUI('withdraw', {
                        amount : this.fastActionSettings.amount,
                        job : this.societyInfo.job
                    })
                    if(!withdrawn) {
                        this.notification(this.locales.no_money)
                    } else {
                        this.notification(this.locales.withdrawn.replace('%s', this.fastActionSettings.amount)+this.locales.currency)
                    }
                } else if(this.fastActionSettings.deposit_money) {
                    if(!this.fastActionSettings.amount) {
                        this.notification(this.locales.invalid_amount)
                        return
                    }
                    var deposited = await this.postNUI('deposit', {
                        amount : this.fastActionSettings.amount,
                        job : this.societyInfo.job
                    })
                    if(!deposited) {
                        this.notification(this.locales.no_money)
                    } else {
                        this.notification(this.locales.deposited.replace('%s', this.fastActionSettings.amount)+this.locales.currency)
                    }
                }
                this.resetFastActionSettings()
            } else if(type == 'editsalary') {
                this.editingSalary = false
                if(!this.fastActionSettings.amount) {
                    this.notification(this.locales.invalid_amount)
                    return
                }
                if(this.fastActionSettings.amount < 0) {
                    this.notification(this.locales.invalid_amount)
                    return
                }

                if(this.gradeTableSelected.salary == this.fastActionSettings.amount) {
                    return
                }
                this.postNUI('editSalary', {
                    job : this.societyInfo.job,
                    salary : this.fastActionSettings.amount,
                    grade : this.gradeTableSelected.name
                })

                this.gradeTableSelected.salary = this.fastActionSettings.amount

                this.notification(this.locales.salary_edited)
            } else if(type == 'edit_grade') {
                this.editingGrade = false
                this.postNUI('editGrade', {
                    employeeIdentifier : this.employeeSelected.identifier,
                    job : this.societyInfo.job,
                    grade : this.gradeSelected1
                })
                this.notification(this.locales.grade_edited)
            }
        },

        viewEmployeeInfo(employee, fromGrade) {
            if(fromGrade) {
                this.viewEmployeeFromGrade = true
            }
            this.screen = 'employee_information'
            this.employeeSelected = employee
            $("#note").innerText = employee.note || ''
        },

        viewGradeInfo(grade) {
            this.screen = 'grade_information'
            this.gradeTableSelected = grade
            this.gradeSelected = grade.name
            this.gradeNumberSelected = grade.number
        },

        editSalary() {
            this.firing = false
            this.fastActionSettings.amount = this.gradeTableSelected.salary
            this.editingSalary = true
        },

        firePlayer() {
            this.postNUI('firePlayer', {
                employeeIdentifier : this.employeeSelected.identifier,
                job : this.societyInfo.job
            })
            this.notification(this.locales.fired.replace('%s', this.employeeSelected.fullName))
            this.changeScreen('employee')
            this.resetFastActionSettings()
            this.firing = false
        },


        getMyInfo() {
            for(const[k,v] of Object.entries(this.employee)) {
                if(v.identifier == this.identifier) {
                    return v
                }
            }
            return {}
        },
    }

});


window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === "OPEN") {
        $("#app").show()
    } else if(data.type === "SET_DATA") {
        app.employee = data.data.employee
        app.societyInfo = data.data.societyInfo
        app.identifier = data.data.myIdentifier
        app.currentTime = data.data.time
        app.currentTime2 = data.data.time2
        app.grades = data.data.grades
    } else if(data.type === "refreshMoney") {
        app.societyInfo.money = data.money
    } else if(data.type === "refreshEmployee") {
        app.employee = data.employee
        if(app.employeeSelected) {
            for(const[k,v] of Object.entries(app.employee)) {
                if(v.identifier == app.employeeSelected.identifier) {
                    app.employeeSelected = v
                }
            }
        }
    } else if(data.type === "refreshGrades") {
        app.grades = data.grades
    } else if(data.type === "SET_LOCALES") {
        app.locales = data.locales
    }
})

document.onkeyup = function (data) {
    if (data.key == 'Escape') {
        if(app.screen == 'dashboard') {
            app.closeNui()
        } else if(app.screen == 'employee_information') {
            app.changeScreen('employee')
        } else if(app.screen == 'grade_information') {
            app.changeScreen('grades')
        } else if(app.screen == 'employee') {
            app.closeNui()
        } else if(app.screen == 'grades') {
            app.closeNui()
        }
    }
};
