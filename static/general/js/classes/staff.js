class Staff {


    int = '/company/api/'


    async getArea(){
        return api.call('VIEW',{module:'area',data:{}},this.int)
    }

    async loadArea(){
        await this.getArea().then(response => {

            if(anton.IsRequest(response)){
                let tr = "";
                response.message.map(area => {
                    tr +=  `<tr><td>${area.area_code}</td><td>${area.area_name}</td></tr>`
                })

                $('#dept_ids').html(tr)
            } else {
                kasa.response(response)
            }
        }).catch(error => {
            kasa.error(error)
        })
    }

    newArea() {
        let form = "";
        form += fom.text('area_code','',true,5)
        form += fom.text('area_name','',true,20)

        amodal.setBodyHtml(form)
        amodal.setTitleHtml("New Are")
        amodal.setFooterHtml(`<button class="btn btn-success" id="save_area">SAVE</button>`)
        amodal.show()

        $('#save_area').click(function(){
            let ids = ['area_code','area_name']
            if(anton.validateInputs(ids)){
                let payload = {
                    module:'area',
                    data:anton.Inputs(ids)
                }

                kasa.confirm(api.call('PUT',payload,staff.int),1,'here')
            } else {
                kasa.error("Invalid Form")
            }
        })
    }

    async getDepartments(){
        return api.call('VIEW',{module:'department',data:{}},this.int)
    }

    async loadDepartment(){
        await this.getDepartments().then(response => {

            if(anton.IsRequest(response)){
                let tr = "";
                response.message.map(dept => {
                    tr +=  `<tr><td>${dept.dept_code}</td><td>${dept.dept_name}</td></tr>`
                })

                $('#dept_ids').html(tr)
            } else {
                kasa.response(response)
            }
        }).catch(error => {
            kasa.error(error)
        })
    }

    newDepartment() {
        let form = "";
        form += fom.text('dept_code','',true,5)
        form += fom.text('dept_name','',true,20)

        amodal.setBodyHtml(form)
        amodal.setTitleHtml("New save_dept")
        amodal.setFooterHtml(`<button class="btn btn-success" id="save_dept">SAVE</button>`)
        amodal.show()

        $('#save_dept').click(function(){
            let ids = ['dept_code','dept_name']
            if(anton.validateInputs(ids)){
                let payload = {
                    module:'department',
                    data:anton.Inputs(ids)
                }

                kasa.confirm(api.call('PUT',payload,staff.int).message,1,'here')
            } else {
                kasa.error("Invalid Form")
            }
        })
    }


    async getPosition(){
        return api.call('VIEW',{module:'position',data:{}},this.int)
    }

    async loadPosition(){
        await this.getPosition().then(response => {

            if(anton.IsRequest(response)){
                let tr = "";
                response.message.map(position => {
                    tr +=  `<tr><td>${position.position_code}</td><td>${position.position_name}</td></tr>`
                })

                $('#position_ids').html(tr)
            } else {
                kasa.response(response)
            }
        }).catch(error => {
            kasa.error(error)
        })
    }

    newPosition() {
        let form = "";
        form += fom.text('position_code','',true,5)
        form += fom.text('position_name','',true,20)

        amodal.setBodyHtml(form)
        amodal.setTitleHtml("New pos")
        amodal.setFooterHtml(`<button class="btn btn-success" id="save_posti">SAVE</button>`)
        amodal.show()

        $('#save_posti').click(function(){
            let ids = ['position_code','position_name']
            if(anton.validateInputs(ids)){
                let payload = {
                    module:'position',
                    data:anton.Inputs(ids)
                }

                kasa.confirm(api.call('PUT',payload,staff.int).message,1,'here')
            } else {
                kasa.error("Invalid Form")
            }
        })
    }

    async getStaff(){
        return api.call('VIEW',{module:'staff',data:{}},this.int)
    }

    async loadStaff(){
        loader.show()
        await this.getStaff().then(response => {

            if(anton.IsRequest(response)){
                let tr = "";
                next_code = response.message.length + 1
                response.message.map(staff => {

                    // console.table(staff)
                    tr +=  `<tr>
                                <td>${staff.emp_code}</td>
                                <td>${staff.first_name} ${staff.last_name}</td>
                                <td>${staff.department.dept_name}</td>
                                <td>${staff.position.position_name}</td>
                           </tr>`
                })

                $('#empl').html(tr)
                $('#myTable').DataTable();
                loader.hide()
            } else {
                kasa.response(response)
                loader.hide()
            }
        }).catch(error => {
            kasa.error(error)
            loader.hide()
        })
    }

    async newStaff() {
        let form = "";
        form += fom.text('emp_code', '', true, 5)

        let deps = []
        await this.getDepartments().then(response => {
            if(anton.IsRequest(response)){
                response.message.map(dep => {
                    console.table(dep)
                    deps.push({val:dep.id,desc:dep.dept_name})
                })
            } else {
                kasa.response(response)
                return
            }
        })
        form += fom.selectv2('department', deps, '', true)


        let posts = []
        await staff.getPosition().then(response => {
            if(anton.IsRequest(response)){
                response.message.map(pos => {
                    posts.push({
                        val:pos.id,desc:pos.position_name
                    })
                })
            } else {
                kasa.response(response);
                return
            }
        }).catch(error => {kasa.error(error); return })
        form += fom.selectv2('position', posts, '', true)

        // get areas
        let areas = []
        await this.getArea().then(response => {
            if (anton.IsRequest(response)) {
                response.message.map(area => {
                    areas.push({
                        val:area.id,
                        desc:area.area_name
                    })
                })
            } else {
                kasa.response(response)

            }
        })
        form += fom.multiselect('area', areas, '', true)


        form += fom.text('first_name', '', true, 20)
        form += fom.text('last_name', '', true, 20)

        form += fom.text('mobile', '', true, 10)
        form += fom.text('email', '', true, 50)


        amodal.setBodyHtml(form)
        amodal.setTitleHtml("New pos")
        amodal.setFooterHtml(`<button class="btn btn-success" id="save_staff">SAVE</button>`)
        $('#emp_code').val(parseInt(next_code) + 1)
        amodal.show()

        $('#save_staff').click(function () {
            let ids = ['emp_code', 'department','area','first_name','last_name','mobile','email','position']

            if (anton.validateInputs(ids)) {
                let payload = {
                    module: 'staff',
                    data: anton.Inputs(ids)
                }

                console.table(payload)
                kasa.confirm(api.call('PUT', payload, staff.int).message, 1, 'here')
            } else {
                kasa.error("Invalid Form")
            }
        })
    }

    setBioData() {
        let form = '';
        form += fom.number('bio_id','user id on clocking system',true,3)
        form += fom.password('bio-password','password to use when accessing user data',true)

        amodal.setBodyHtml(form)
        amodal.setTitleHtml("Update BIO-Credentials")
        amodal.setFooterHtml(`<button id="verify_bio_credentials" class="btn btn-info btn-sm">SAVE</button>`)
        amodal.show()

        $('#verify_bio_credentials').click(async function(){
            // get otp
            let idsx = ['bio_id','bio-password']
            let bio_id = $('#bio_id').val()
            let bio_password = $('#bio-password').val()
            if(anton.validateInputs(idsx)){
                let payload = {
                    module:'otp_auth',
                    data:anton.Inputs(idsx)
                }

                await api.v2('VIEW',payload,'/company/api/').then(response => {
                    if(anton.IsRequest(response)){
                        let msg = response.message
                        let otp = msg.otp
                        let comment = msg.msg
                        form = fom.text('otp',comment,true,6)
                        amodal.setBodyHtml(form)
                        amodal.setTitleHtml("Validate")
                        amodal.setFooterHtml(`<button id='valid_otp' class="btn btn-success">Complete</button>`)

                        $('#valid_otp').click(async function(){
                            let entered_otp = $('#otp').val();
                            if(entered_otp == otp){
                                // send update request
                                let payload = {
                                    module:'update_auth',
                                    data:{
                                        bio_id:bio_id,
                                        bio_password:bio_password,
                                        mypk:$('#mypk').val()
                                    }
                                }

                                await api.v2('PATCH',payload,'/company/api/').then(response => {
                                    console.table(response)
                                    if(anton.IsRequest(response)){
                                        kasa.confirm("Credentials Update",1,'here')
                                    } else {
                                        kasa.error(response)
                                    }
                                }).catch(error => {
                                    kasa.error(error)
                                })
                            } else {
                                kasa.error("Invalid Otp")
                            }
                        })
                    } else {
                        kasa.response(response)
                    }
                }).catch(error => {
                    kasa.error(error)
                })
            }



            
        })
    }
}

const staff = new Staff()