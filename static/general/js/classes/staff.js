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
}

const staff = new Staff()