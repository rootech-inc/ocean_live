class Form {
    input(type='text',ini,comment = '',required=false,max_value=100){
        let req = ''
        if(required){
            req = `<span class="text-danger">*</span>`
        }
        return `
                <div class="input-group mb-2">
                <label class="w-100 text-info" for="${ini}">${ini.toUpperCase().replace('_',' ')} ${req}</label>
                <input type="${type}" maxlength="${max_value}" id="${ini}" name="${ini}" required="${required}" class="form-control w-100 rounded-0"  />
                <small class="text-info">${comment}</small>
                </div>
                `
    }
    text(ini,comment='',required=false,max_val=100){
        return this.input('text',ini,comment,required,max_val)
    }

    email(ini,comment='',required=false){
        return this.input('email',ini,comment,required)
    }

    phone(ini,comment='',required=false){
        return this.input('tel',ini,comment,required)
    }

    date(ini,comment='',required=false){
        return this.input('date',ini,comment,required)
    }

    date_local(ini,comment='',required=false){
        return this.input('datetime-local',ini,comment,required)
    }

    time(ini,comment='',required=false){
        return this.input('time',ini,comment,required)
    }

    select(ini,options,comment='',required=false){
        let req = ''
        if(required){
            req = `<span class="text-danger">*</span>`
        }
        return `
                <label class="text-info" for="${ini}">${ini.toUpperCase().replace('_',' ')} ${req}</label>
                <select id="${ini}" name="${ini}" required="${required}" class="form-control mb-2 rounded-0"><${options}</select><i class="text-muted">${comment}</i>
                `
    }

    selectv2(ini,options=[],comment='',required=false){
        let opxt = `<option disabled selected>Select ${ini.toUpperCase().replace('_',' ')}</option>`;
        for (let i = 0; i < options.length; i++) {
            let option = options[i];
            console.table(option)
            opxt += `<option value="${option['val']}">${option.desc}</option>`
        }

        let req = ''
        if(required){
            req = `<span class="text-danger">*</span>`
        }
        return `
                <label class="text-info" for="${ini}">${ini.toUpperCase().replace('_',' ')} ${req}</label>
                <select id="${ini}" name="${ini}" required="${required}" class="form-control mb-2 rounded-0"><${opxt}</select><i class="text-muted">${comment}</i>
                `
    }

    button(ini,type,color='info',margin=2,onclick=''){
        return `<button class="btn btn-${color}" style="border-radius: 0px !important; margin-left: .2rem" id="${ini}" onclick="${onclick}" type="${type}">${ini.toUpperCase().replace('_',' ')}</button>`
    }
    textarea(ini,rows=3,required=false){
        let req = ''
        if(required){
            req = `<span class="text-danger">*</span>`
        }
        return `
                <label class="text-info" for="${ini}">${ini.toUpperCase()} ${req}</label>
                <textarea id="${ini}" name="${ini}" required="${required}" class="form-control mb-2 rounded-0" rows="${rows}"></textarea>
                `
    }

    file(ini,comment='',required=false){
        return this.input('file',ini,comment,required)
    }

    locations(key='code') {
        let loc_payload = {
            module:'location_master',
            data:{}
        }
        let locations = api.call('VIEW',loc_payload,'/retail/api/')
        let locs = locations.message
        let l_optons = ""
        for(let l = 0; l < locs.length; l++){
            let lc = locs[l]
            l_optons += `<option value="${lc[`${key}`]}">${lc['code']} - ${lc['name']}</option>`
        }

        return this.select('location',l_optons,'',true)
    }

    number(ini,comment='',required=false,max_val=100){
        return this.input('number',ini,comment,required,max_val)
    }
}

const fom = new Form()