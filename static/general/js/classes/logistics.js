class Logistics {
    interface = '/logistic/api/';

    async LoadDeliveries(status='pending') {
        await this.getDeliveries(status).then(response =>{
            if(anton.IsRequest(response)){
                let message = response.message;
                let data = [];
                console.log(message);
                message.forEach(delivery => {
                    data.push([
                        delivery.requested_by ? delivery.requested_by.name : '',
                        delivery.destination ?? '',
                        delivery.request_date ?? '',
                        delivery.status ?? '',
                        `<button data-enc="${delivery.enc}" class="btn view_delivery btn-sm btn-primary">View</button>` // Action column (HTML)
                    ]);
                });



                if ($.fn.DataTable.isDataTable('#del')) {

                    var table = $('#del').DataTable();
                    table.clear();
                    table.rows.add(data);
                    table.draw();
                } else {
                    $('#del').DataTable(
                    {
                        data:data,

                        }
                    )
                }

                $('.view_delivery').click(function(){
                    windowPopUp(`/logistic/delivery/view/${$(this).data('enc')}/`,"Delivery Information",600,800)
                })

                console.table(data)
            } else {
                kasa.response(response)
            }
        }).catch(err =>{kasa.error(err)});
    }

    async getDeliveries(status='pending',against='in',enc='*') {
        return api.call('VIEW',{
            module:'delivery_request',
            data:{
                'pk':enc,
                status:status,
                against:against,
            }
        },this.interface)
    }

    async LoadDeliveryDetails(enc) {
        await this.getDeliveries('*','*',enc).then(response => {
            if(anton.IsRequest(response)){
                let message = response.message[0];
                $('.source').text(message.source)
                $('.destination').text(message.destination)
                $('.description').text(message.description)
                $('.requested_by').text(message.requested_by.name)
                $('.request_date').text(message.request_date)

                let status = message.status;
                let btn_color,btn_text,btn_status;
                switch (status) {
                    case 'pending':
                        btn_color = 'info'
                        btn_text = 'Schedule'
                        btn_status = 'schedule'
                        break;
                    case 'schedule':
                        btn_color = 'warning'
                        btn_text = 'Deliver'
                        btn_status = 'in_transit'
                        break;
                    case 'in_transit':
                        btn_color = 'success'
                        btn_text = 'Complete'
                        btn_status = 'delivered'
                        break;
                    default:
                        btn_text = ''
                        btn_color = 'text-light'
                }

                let bu_ht = ""
                if(status !== 'delivered'){
                    bu_ht = `<button data-changeto="${btn_status}" class="btn xgh_del btn-sm btn-${btn_color}">${btn_text}</button>`;
                }

                let logs_ht = ""
                message.logs.map(log => {
                    logs_ht += `
                         <div class="mb-4 position-relative">
                          <div class="rounded-circle bg-success position-absolute" style="left: -32px; top: 0; width: 20px; height: 20px; ${log === message.logs.length - 1 ? 'border-bottom: none;' : ''}"></div>
                          <div class="font-weight-bold">${log.title}</div>
                          <div class="text-muted small">${log.details}</div>
                          <div class="text-muted small">${log.time}</div>
                        </div>
                    `
                })

                $('.bt').html(bu_ht)

                $('.logs').html(logs_ht)

                $('.xgh_del').click(async function(){
                    if(confirm('Are you sure you want to change the status of this delivery?')){
                        let changeto = $(this).data('changeto');
                        let enc = message.enc;
                        let payload = {
                            module:'delivery_request',
                            data:{
                                enc:enc,
                                status:changeto,
                                user:$('#mypk').val()
                            }
                        }

                        console.table(payload)
                        // select car and driver
                        let loader_html = `
                                <div class="shc_screen">
                                    
                                    <div class="spinner-border text-primary x_spin mb-3" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                   
                                </div>
                            `



                            amodal.setBodyHtml(loader_html)
                            amodal.setTitleHtml(`${changeto} Delivery`)
                            amodal.setFooterHtml(`<button disabled class="btn btn-success" id="make_schedule_button">COMPLETE</button>`)
                            amodal.show()
                        $('.shc_screen').prepend(fom.textarea('remarks',5,true))



                        if(changeto === "schedule"){

                            $('.shc_screen').prepend(fom.date_local('schedule_time','',true))

                            // load driver
                            await api.v2('VIEW',{module:'driver',data:{pk:'*'}},logistics.interface).then(response =>{
                                if(anton.IsRequest(response)){
                                    let drivers = []
                                    response.message.map(driver => {
                                        drivers.push({val:driver.pk,desc:driver.name})
                                    })

                                    let driver_form = fom.selectv2('driver',drivers,'',true)
                                    $('.shc_screen').prepend(driver_form)
                                    $('.x_spin').remove()
                                    $('#make_schedule_button').attr('disabled',false)


                                } else {
                                    kasa.response(response)
                                }
                            }).catch(err =>{kasa.error(err)});

                        }

                        if(changeto === "in_transit"){
                            $('.shc_screen').prepend(fom.date_local('departure_time','',true))
                            // load cars
                                    let cars = api.call('VIEW',{module:'vehicle',data:{pk:'*'}},logistics.interface);
                                    if(anton.IsRequest(cars)){
                                        let carss = []
                                        cars.message.map(car => {
                                            carss.push({
                                                val:car.pk,desc:`${car.plate_number} - ${car.description}`
                                            })
                                        })
                                        let cars_form = fom.selectv2('vehicle',carss,'',true)
                                        $('.shc_screen').prepend(cars_form)
                                        $('.x_spin').remove()
                                        $('#make_schedule_button').attr('disabled',false)
                                    } else {
                                        $('.shc_screen').prepend(cars.message)
                                    }
                        }

                        if(changeto === "delivered"){
                            $('.x_spin').remove()
                            $('#make_schedule_button').attr('disabled',false)
                        }

                        $('#make_schedule_button').click(async function(){
                                let ids = ['remarks']
                                if(changeto === "schedule"){

                                    ids.push('schedule_time')
                                    ids.push('driver')

                                    payload['data']['driver'] = $('#driver').val()
                                    payload['data']['schedule_time'] = $('#schedule_time').val()
                                }

                                if(changeto === "in_transit"){
                                    ids.push('departure_time')
                                    ids.push('vehicle')
                                    payload['data']['vehicle'] = $('#vehicle').val()
                                    payload['data']['departure_time'] = $('#departure_time').val()
                                }

                                if(anton.validateInputs(ids)){
                                    payload['data']['remarks'] = $('#remarks').val()
                                    console.table(payload)
                                    await api.v2('PATCH',payload,logistics.interface).then(response =>{
                                        if(anton.IsRequest(response)){
                                            logistics.LoadDeliveries(enc);
                                            kasa.success('Operation Successful')
                                            amodal.hide()
                                        } else {
                                            kasa.response(response)
                                        }
                                    }).catch(err =>{kasa.error(err)});

                                }
                            })
                    } else {
                        kasa.info('Process Cancelled')
                    }


                })
            } else {
                kasa.response(response)
            }
        }).catch(err =>{kasa.error(err)});
    }

    async loadDrivers() {
        await this.getDrivers().then(response =>{
            let ht = ""
            if(anton.IsRequest(response)){
                response.message.map(driver => {
                    console.table(driver)
                    let st = ""
                    if(driver.is_engaged){
                        st = "alert-danger"
                    }
                    ht += `
                        <div class="col-sm-4">
                            <div class="card alert ${st} d-flex flex-row align-items-center p-3" style="border-radius: 1rem; max-width: 500px;">
                              <!-- Profile Image -->
                              <div class="flex-shrink-0">
                                <img src="${driver.db}" class="rounded img-fluid" style="object-fit: cover; width: 75px !important" alt="User">
                              </div>
            
                              <!-- User Info -->
                              <div class="flex-grow-1 d-flex flex-column justify-content-center pl-3">
                                    <h5 class="mb-1 font-weight-bold ellipsis">${driver.name}</h5>
            
            
                                    <div class="d-flex mt-1">
                                      <div class="w-100">
                                        <div class="small text-uppercase text-muted">deliveries</div>
                                        <div class="h6 mb-0 text-info font-weight-bold">${driver.deliveries}</div>
                                      </div>
            
                                    </div>
                              </div>
            
                            </div>
            
                        </div>
                    `
                })
            } else {
                ht = response.message
            }

            $('#drivers').html(ht)
        }).catch(err =>{kasa.error(err)});
    }

    getDrivers() {
        return api.v2("ViEW",{module:'driver',data:{pk:'*'}},logistics.interface)
    }

    newDriver() {
        let form = "";
        // get all users
        let all_users = user.allUsers()
        let opts = []
        if(anton.IsRequest(all_users)){

            all_users.message.map(user => {
                console.log(user)
                opts.push({ val:user.pk,desc:user.fullname })
            })
        } else {
            kasa.response(all_users)
            return false
        }
        console.table(all_users)
        form += fom.selectv2('user',opts,'',true)
        form += fom.text('license_number',"", true)
        form += `
            <form action="/logistic/upload-diver-image/" id="update_image" method="POST" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="image">SELFIE</label>
                    <input type="file" accept="image/*" name="image" id="image">
                </div>
                <div class="form-group">
                    <label for="license">LICENSE</label>
                    <input type="file" accept="image/*" name="image" id="image">
                </div>
                <input type="hidden" name="license" id="license">
            </form>
        `



        amodal.setBodyHtml(form)
        amodal.setTitleHtml("Add Driver")
        amodal.show()
        amodal.setFooterHtml(`<button class="btn btn-success" id="save_new_driver">Save Drivers</button>`)


        $('#save_new_driver').on('click',async function(){
            let ids = ['user','mypk','image','license_number','license']
            if(anton.validateInputs(ids)){
                let payload = {
                    module:'driver',
                    data:anton.Inputs(ids)
                }
                payload['data']['user'] = $('#mypk').val()

                await api.v2('PUT',payload,logistics.interface).then(response =>{
                    if(anton.IsRequest(response)){
                        $('#driver').val(response.message)
                        $('#update_image').submit()
                    }else {
                        kasa.response(response)
                    }
                }).catch(err =>{kasa.error(err)});
            }
        })
    }

    async loadFleets() {
       await this.getFleet().then(response =>{
           let ht = ""
            if(anton.IsRequest(response)){


                response.message.map(fleet => {
                    console.table(fleet)
                    ht += `
                        <div class="col-md-3 mb-4">
                          <div class="card shadow-sm border-0">
                              <img src="${fleet.img}" class="card-img-top" alt="Car Image">
                              <div class="card-body text-center">
                              <h5 class="card-title mb-1">${fleet.plate_number}</h5>
                              <p class="card-text text-muted ellipsis" title="${fleet.description}">${fleet.description}</p>
                            </div>
                          </div>
                        </div>
                    `
                })

                $('#fleets').html(ht)
            } else {
                $('#fleets').html(response.message)
            }
       }) .catch(err =>{kasa.error(err)});
    }

    async getFleet(pk='*') {
        return api.call("ViEW",{module:'vehicle',data:{pk:pk}},logistics.interface)
    }

    async loadFleet(pk){
        console.log(pk)
        await this.getFleet(pk).then(response => {

            if(anton.IsRequest(response)){
                let fleet = response.message[0];
                console.table(fleet)
                anton.setValues(fleet)
                $('#img').attr('src',fleet.img)

                if(fleet.next > 0){
                    $('#next').attr('disabled',false)
                    $('#next').attr('data-pk',fleet.next)
                } else {
                    $('#next').attr('disabled',true)
                }

                if(fleet.previous > 0){
                    $('#previous').attr('disabled',false)
                    $('#previous').attr('data-pk',fleet.prev)
                } else {
                    $('#previous').attr('disabled',true)
                }

            } else {
                console.log(response)
            }
        }).catch(err =>{kasa.error(err)});
    }
}

const logistics = new Logistics();