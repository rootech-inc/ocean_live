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
                let arr_4_csv = [
                    ['CODE','NAME','LOCATION','POSITION','ATTENDANCE','BIO']
                ]

                response.message.map(staff => {

                    // console.table(staff['fingerprint'])
                    const fingerprint = staff['fingerprint'];
                    let is_bio = false;
                    if(fingerprint !== '-'){
                        is_bio = true;
                    }

                    arr_4_csv.push([staff.emp_code,`${staff.first_name} ${staff.last_name}`,
                        staff.department.dept_name,staff.position.position_name,is_bio,fingerprint])
                    
                    console.log(is_bio)
                    tr +=  `<tr>
                                <td>${staff.emp_code}</td>
                                <td>${staff.first_name} ${staff.last_name}</td>
                                <td>${staff.department.dept_name}</td>
                                <td>${staff.position.position_name}</td>
                                <td>${is_bio}</td>
                                <td>${fingerprint}</td>
                           </tr>`
                })

                $('#empl').html(tr)
                $('#myTable').DataTable();
                $('#download').click(function(){
                    let data = anton.convertToCSV(arr_4_csv);
                    anton.downloadCSV('staff.csv',data)
                })
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

    async loadAttendance(dt=today) {

        await this.getAttendance(dt).then(response => {
            loader.show()
            if(anton.IsRequest(response)){
                let attds = response.message.array;
                let tr = "";
                let st = "";
                attds.map(attd => {
                    console.table(attd)
                    let tx = ''
                    if (attd[5] === 'absent'){
                        tx = 'text-danger'
                        st = attd[5]
                    } else {
                        if(attd[7]){
                            tx = 'text-warning'
                            st = 'late'
                        } else {
                            tx = 'text-success'
                            st = 'on-time'
                        }
                    }


                    tr += `
                        <tr class="${tx}">
                            <td>${attd[0]}</td>
                            <td>${attd[1]}</td>
                            <td>${st}</td>
                            <td>${attd[3]}</td>
                            <td>${attd[4]}</td>
</tr>
                    `
                })

                $('#att_bd').html(tr)
                $('#attd_table').DataTable();
                loader.hide()
            } else {
                kasa.response(response)
                // loader.hide()
            }
        }).catch(error=>{
            kasa.error(error);
            loader.hide()}
        )
    }

    async getAttendance(dt=today) {
        return api.call('PUT',{module:'sync_attendance',data:{
            date:dt
        }},'/company/api/')
    }

    async loadMyAttendance(rg = 'week') {
        await this.getMyAttendance(rg).then(response => {
            if(anton.IsRequest(response)){
                let recs = response.message;
                let tr = ""
                recs.map(record => {
                    console.table(record)

                    // Add click handler for send button
                    $(document).on('click', '.send-leave-request', function () {
                        let leaveId = $(this).data('id');
                        let payload = {
                            module: 'leave_resend',
                            data: {
                                leave_id: leaveId
                            }
                        }
                        api.v2('PUT', payload, '/company/api/').then(response => {
                            if (anton.IsRequest(response)) {
                                kasa.confirm("Leave request sent successfully", 1, 'here')
                            } else {
                                kasa.response(response)
                            }
                        }).catch(error => {
                            kasa.error(error)
                        })
                    });

                    tr += `
                        <tr>
                            <td>${record['date']}</td>
                            <td>${record['time_in']}</td>
                            <td>${record['time_in']}</td>
                        </tr>
                        
                    `
                })

                $('#att_bd').html(tr)
            } else {
                kasa.response(response)
            }
        }).catch(error => {kasa.error(error)})
    }

    async getMyAttendance(rg) {
        return api.call('VIEW',{module:'attendance',data:{mypk:$('#mypk').val(),range:rg}},'/company/api/')
    }

    LeaveRequestForm(emp_code){
        let formHTML = `
            <div id="employee_leave_form" class="p-3 container">
                <div class='row'>
                <div class='col-sm-4'>${fom.selectv2('type_of_leave', [
                        { val: 'annual', desc: 'Annual Leave' },
                        { val: 'sick', desc: 'Sick Leave' },
                        { val: 'casual', desc: 'Casual Leave' },
                        { val: 'maternity', desc: 'Maternity Leave' },
                        { val: 'paternity', desc: 'Paternity Leave' },
                        { val: 'study', desc: 'Study Leave' },
                        { val: 'compassionate', desc: 'Compassionate Leave' },
                        { val: 'unpaid', desc: 'Unpaid Leave' },
                        { val: 'other', desc: 'Other' }
                    ], '', true)}</div>


                    <div class='col-sm-4'>${fom.text('emp_code', 'Unique ID assigned to employee', true)}</div>
                    <div class='col-sm-4'>${fom.date('date_of_request', 'Date you are submitting this form', true)}</div>

                    <div class='col-sm-4'>${fom.date('start_date', 'Start of leave', true)}</div>
                    <div class='col-sm-4'>${fom.date('end_date', 'End of leave', true)}</div>

                    <div class='col-sm-4'>${fom.text('reliever_name', 'Who will take over your tasks while you are away?', true)}</div>

                    <div class='col-sm-4'>${fom.file('supporting_document', 'Upload medical certificate or supporting documents if required')}</div>
                    <div class='col-sm-6'></div>
                </div>
                
                
                
                
                
                
                
                

                
                
                

                ${fom.textarea('reason', 3, true)}


                

                ${fom.button('submit_leave_form', 'submit', 'success')}
            </div>
            `;
        amodal.setBodyHtml(formHTML)
        amodal.setSize('L')
        amodal.show()
        $('#emp_code').val(emp_code)
        $('#emp_code').attr('disabled',true)

        $('#submit_leave_form').click(async function () {
            let ids = ['type_of_leave', 'emp_code', 'date_of_request', 'start_date', 'end_date', 'reliever_name', 'reason']
            if (anton.validateInputs(ids)) {
                let payload = {
                    module: 'leave',
                    data: anton.Inputs(ids)
                }

                // validate date
                let start = new Date($('#start_date').val());
                let end = new Date($('#end_date').val());

                if (end <= start) {
                    kasa.error("End date must be greater than start date");
                    return;
                }

                await api.v2('PUT', payload, '/company/api/').then(response => {
                    if(anton.IsRequest(response)){
                        kasa.confirm(response.message,1,'here')
                    } else {
                        kasa.response(response)
                    }
                }).catch(error => {
                    kasa.error(error)
                })
            } else {
                kasa.error("Invalid Form")
            }
        })
    }

    async loadMyLeave(pk='*',status='*') {
        await this.getLeave(pk,status).then(response => {
            if(anton.IsRequest(response)){
                let recs = response.message;
                let tr = ""
                recs.map(record => {
                    console.table(record)
                    let act = "";
                    if(record['status'] == 'pending'){
                        act = `
                                <a class="dropdown-item leave_approval_request" data-id="${record['id']}" href="javascript:void(0)">Request Approval</a>
                                <a class="dropdown-item cancel-leave"  data-id="${record['id']}" href="javascript:void(0)" >Cancel</a>
                                `

                    }
                    tr += `
                        <tr>
                            <td>${record['req_date']}</td>
                            <td>${record['type']}</td>
                            <td>${record['start_date']}</td>
                            <td>${record['end_date']}</td>
                            <td>${record['status']}</td>
                            <td>${record['reliever']}</td>
                            <td>
                                <div class="dropdown">
                                    <button class="btn btn-secondary btn-sm" type="button" id="dropdownMenuButton${record.id}" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                        <i class="fa fa-grip-horizontal"></i>
                                    </button>
                                    <div class="dropdown-menu" aria-labelledby="dropdownMenuButton${record.id}">
                                       ${act}
                                    </div>
                                </div>
                            </td>
                        </tr>
                            
                            
                    `
                })

                $('#leave_bd').html(tr)
                $('#leave_table').DataTable();
                $('#leave_table').on('click','.cancel-leave',async function () {
                    let leaveId = $(this).data('id');
                    if(confirm('Are you sure you want to cancel this leave request?') === false){
                        kasa.info('Cancelled')
                        return;
                    }
                    let payload = {
                        module: 'leave',
                        data: {
                            pk: leaveId
                        }
                    }
                    await api.v2('DELETE', payload, '/company/api/').then(response => {
                        kasa.confirm(response.message,1,'here')
                    }).catch(error => {
                        kasa.error(error)
                    })
                })
                $('.leave_approval_request').click(async function () {
                    let leaveId = $(this).data('id');
                    if(confirm('Are you sure you want to request approval for this leave request?') === false){
                        kasa.info('Cancelled')
                        return;
                    }
                    let payload = {
                        module: 'leave_approval_request',
                        data: {
                            leave_id: leaveId
                        }
                    }
                    await api.v2('PATCH', payload, '/company/api/').then(response => {
                        kasa.confirm(response.message,1,'here')
                    })
                })
            } else {
                kasa.response(response)
            }
        }).catch(error => {kasa.error(error)})
    }

    async getLeave(pk='*',status='*') {
        return api.call('VIEW',{module:'leave',data:{mypk:$('#mypk').val(),pk:pk,status:status}},'/company/api/')
    }
}

const staff = new Staff()