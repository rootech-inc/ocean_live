class SSML {
   


    async LoadServiceOrders() {
        let payload = {
            module: 'service_order',
            data: {
                id: '*'
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            
            if(anton.IsRequest(response)) {
                let service_orders = response.message;
                let tbody = '';
                service_orders.forEach(order => {
                    tbody += `<tr>
                        <td>${order.contractor.company}<br>
                            ${order.contractor.phone}</td>
                        <td>${order.service_type.name}</td>
                        <td>plot: ${order.plot.plot_no} <br> geo: ${order.geo_code}</td>
                        <td><i class="bi bi-arrow-up text-success"></i> ${order.new_meter_no} <br> 
                            <i class="bi bi-arrow-down text-danger"></i> ${order.old_meter_no}</td>
                        <td>${order.service_date}</td>
                        <td>${order.status}</td>
                        <td>
                            <div class="dropdown">
                                <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    Actions
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="javascript:void(0)" onclick="ssml.viewServiceOrder(${order.id})"><i class="bi bi-eye"></i> View</a></li>
                                    <li><a class="dropdown-item" href="javascript:void(0)" onclick="ssml.closeServiceOrder(${order.id})"><i class="bi bi-check-circle"></i> Close</a></li>
                                    <li><a class="dropdown-item" href="javascript:void(0)" onclick="ssml.editServiceOrder(${order.id})"><i class="bi bi-pencil"></i> Edit</a></li>
                                    <li><a class="dropdown-item" href="javascript:void(0)" onclick="ssml.deleteServiceOrder(${order.id})"><i class="bi bi-trash"></i> Delete</a></li>
                                </ul>
                            </div>
                        </td>
                    </tr>`;
                });
                // make data table
                let table = `
                <table class="table table-bordered table-stripped table-bordered">
                    <thead class="table-dark">
                        <tr>
                            <th>Contractor</th>
                            <th>Service Type</th>
                            <th>Geo Code</th>
                            <th>Meter No</th>
                            <th>Service Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        ${tbody}
                    </tbody>
                </table>
                `
                $('#result').html(table);
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    async viewServiceOrder(id) {
        let payload = {
            module: 'service_order',
            data: {
                id: id
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            let resp = response.message[0];
            console.table(resp);
        
            let body = `
                <div class="row m-2">
                    <h4>Contractor</h4>
                    <div class="col-md-12" style="background-color:rgba(248, 249, 250, 0.57); padding: 20px; border-radius: 10px; border: 2px dotted #808080;">
                        
                        <div class="row">
                            <div class="col-md-4">
                                <strong class="text-primary">Company</strong>
                                <p><small>${resp.contractor.company}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">Phone</strong>
                                <p><small>${resp.contractor.phone}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">Email</strong>
                                <p><small>${resp.contractor.email}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">Link</strong>
                                <p><small>${resp.contractor.link}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">Ghana Card No.</strong>
                                <p><small>${resp.contractor.gh_card_no}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">City</strong>
                                <p><small>${resp.contractor.city}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">Postal Code</strong>
                                <p><small>${resp.contractor.postal_code}</small></p>
                            </div>
                            
                        </div>
                    </div>
                    
                </div>
                <hr>
                <div class="row m-2">
                    <h4>Service Type</h4>
                    <div class="col-md-12" style="background-color:rgba(248, 249, 250, 0.57); padding: 20px; border-radius: 10px; border: 2px dotted #808080;">
                        <div class="row">
                            <div class="col-md-4">
                                <strong class="text-primary">Name</strong>
                                <p><small>${resp.service_type.name}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">Customer</strong>
                                <p><small>${resp.customer}<br>
                                    ${resp.customer_no}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">Geo Code</strong>
                                <p><small>${resp.geo_code}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">Plot</strong>
                                <p><small>${resp.plot.plot_no}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">Meter No</strong>
                                <p><small>${resp.new_meter_no}<br>
                                    ${resp.old_meter_no}</small></p>
                            </div>
                            <div class="col-md-4">
                                <strong class="text-primary">Service Date</strong>
                                <p><small>${resp.service_date}</small></p>
                            </div>
                        </div>
                    </div>
                </div>
                <hr>
                <div class="row m-2">
                    <h4>Services</h4>
                    <div class="col-md-12" style="background-color:rgba(248, 249, 250, 0.57); padding: 20px; border-radius: 10px; border: 2px dotted #808080;">
                        <div class='d-flex flex-wrap justify-content-between'>
                            <button class="btn btn-primary mb-2" onclick="ssml.addService(${id})">Add Service</button>
                            
                        </div>
                        <table class="table table-bordered table-stripped table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Rate</th>
                                    <th>Quantity</th>
                                    <th>Total</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="service_items">
                            </tbody>
                        </table>
                    </div>
                </div>
                <hr>
                <div class="row m-2">
                    <h4>Materials</h4>
                    <div class="col-md-12" style="background-color:rgba(248, 249, 250, 0.57); padding: 20px; border-radius: 10px; border: 2px dotted #808080;">
                        <div class='d-flex flex-wrap justify-content-between'>
                            <button class="btn btn-primary mb-2" onclick="ssml.addMaterialToOrderOnly(${id})">Add Material V2</button>
                        </div>
                        <table class="table table-bordered table-stripped table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th>Type</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Quantity</th>
                                </tr>
                            </thead>
                            <tbody id="material_items">
                            </tbody>
                        </table>
                    </div>
                </div>

                <hr>
                <div class="row m-2">
                    <h4>Returns</h4>
                    <div class="col-md-12" style="background-color:rgba(248, 249, 250, 0.57); padding: 20px; border-radius: 10px; border: 2px dotted #808080;">
                        <div class='d-flex flex-wrap justify-content-between'>
                            <button class="btn btn-primary mb-2" onclick="ssml.addReturn(${id})">Add Return</button>
                            <button onclick='ssml.retRecon(${id})' class='btn btn-info'>?</button>
                        </div>
                        <table class="table table-bordered table-stripped table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th>Barcode</th>
                                    <th>Name</th>
                                    <th>Quantity</th>
                                    <th>Rate</th>
                                    <th>Amount</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody id="returns_items">
                            ${resp.returns.map(rt => `
                                <tr>
                                    <td>${rt.material.barcode}</td>
                                    <td>${rt.material.name}</td>
                                    <td>${rt.quantity}</td> 
                                    <td>${rt.rate}</td>
                                    <td>${rt.amount}</td>
                                    <td>
                                        <div class="dropdown">  
                                            <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                                Actions
                                            </button>
                                            <ul class="dropdown-menu">
                                                <li><a class="dropdown-item" href="#" onclick="ssml.editReturn(${rt.id}, ${resp.id})">Edit</a></li>
                                                <li><a class="dropdown-item" href="#" onclick="ssml.deleteReturn(${rt.id}, ${resp.id})">Delete</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            `).join('')}
                            </tbody>
                        </table>
                    </div>
                </div>
            `

            amodal.setTitleText('Service Order');
            amodal.setBodyHtml(body);
            amodal.setFooterHtml('<button class="btn btn-primary" id="close_modal">Close</button>');
            amodal.setSize('L');

            // add service items
            resp.service_items.forEach(item => {
                $('#service_items').append(`
                    <tr>
                        <td><small>${item.service.code}</small></td>
                        <td><small>${item.service.name}</small></td>
                        <td><small>${item.service.description}</small></td>
                        <td><small>${item.rate}</small></td>
                        <td><small>${item.quantity}</small></td>
                        <td><small>${item.amount}</small></td>
                        <td>
                            <div class="dropdown d-inline">
                                <button class="btn btn-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#" onclick="ssml.editService(${item.id}, ${resp.id})">Edit</a></li>
                                    <li><a class="dropdown-item" href="#" onclick="ssml.deleteService(${item.id}, ${resp.id})">Delete</a></li>
                                </ul>
                            </div>

                        </td>
                    </tr>
                `);
            });

            // add material items
            resp.materials.forEach(material => {
                $('#material_items').append(`
                    <tr>
                        <td><small>${material.material_type}</small></td>
                        <td><small>${material.material.barcode}</small></td>
                        <td><small>${material.material.name}</small></td>
                        <td><small>${material.quantity}</small></td>
                        <td><button onclick=ssml.deleteServiceMaterial('${material.id}')>DEL</button></td>
                    </tr>
                `);
            });


            $('#service_items').append(`
                <tr>
                    <td colspan="7">
                        <strong>Total Amount: <span class="text-success">${resp.total_amount}</span></strong>
                    </td>
                </tr>
            `);
            amodal.show();
        }).catch(error => {
            kasa.error(error);
        });
    }


    async addService(id) {
        let payload = {
            module: 'service',
            data: {
                id: '*'
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let services = response.message;
                let tbody = '';
                services.forEach(service => {
                    tbody += `<tr>
                        <td>${service.code}</td>
                        <td>${service.name}</td>
                        <td>${service.description}</td>
                        <td>${service.rate}</td>
                        <td>
                            <button class="btn btn-warning" onclick="ssml.addServiceToOrder('${service.code}', '${service.name}')">Add</button>
                        </td>
                    </tr>`;
                });
                amodal.setTitleText('Add Service');

                amodal.setBodyHtml(`
                    <table class="table table-bordered table-stripped table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>Code</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Rate</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${tbody}
                        </tbody>
                    </table>
                `);
                amodal.setFooterHtml(`
                    <button onclick="ssml.viewServiceOrder(${id})" class="btn btn-primary" id="close_modal">Cancel</button>
                `);
                amodal.setSize('L');
                amodal.show();
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    async addServiceToOrder(order_id, service_id) {
        let payload = {
            module: 'service',
            data: {
                id: service_id
            }
        }

        let last_service_line = $('#service_items tr').length;
        let next_service_line = last_service_line + 1;
        let row_id = 'srv_'+next_service_line;
        let row_name_id = 'srvname_'+next_service_line;
        let row_qty_id = 'srvqty_'+next_service_line;
        let row_code_id = 'srvcode_'+next_service_line;
        let row = `
            <tr id="${row_id}">
                <td id="${row_code_id}">${order_id}</td>
                <td id="${row_name_id}">${service_id}</td>
                <td ><input style='width: 100px;' type="number" id="${row_qty_id}" class="form-control" placeholder="Qty" value="1"></td>
            </tr>
        `

        console.table(row);

        $('#services_table').append(row);
        amodal.hide();


        return

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let service = response.message;
                let body = `
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <h4>${service.name}</h4>
                            <input type="number" class="form-control mx-auto" style="width: 100px;" id="serv_qty" placeholder="Quantity">
                        </div>
                    </div>
                `

                amodal.setTitleText('Add Service');
                amodal.setBodyHtml(body);
                amodal.setFooterHtml(`
                    <div class='d-flex w-100 justify-content-between'>
                        <button class='btn btn-danger' onclick='ssml.viewServiceOrder(${order_id})'>Cancel</button>
                        <button class='btn btn-primary' id='add_service_to_order'>Add</button>
                        
                    </div>
                `);
                amodal.setSize('');
                amodal.show();
                $('#add_service_to_order').click(async function() {
                    let ids = ['mypk','serv_qty']
                    if(anton.validateInputs(ids)) {
                        let payload = {
                            module: 'service_order_item',
                            data: anton.Inputs(ids)
                        }

                        payload.data['order_id'] = order_id;
                        payload.data['service_id'] = service_id;

                        await api.v2('PUT', payload, '/ssml/api/').then(response => {
                            if(anton.IsRequest(response)) {
                                kasa.success(response.message);
                                ssml.viewServiceOrder(order_id);
                            } else {
                                kasa.error(response.message);
                            }
                        }).catch(error => {
                                kasa.error(error);
                            });
                    } else {
                        kasa.error('Please fill all the fields');
                    }
                });
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }


    async editService(id, order_id) {
        // get service item
        let payload = {
            module: 'service_order_item',
            data: {
                service_order_id: id
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let service = response.message;
                let body = `
                    <div class="row">
                        <div class="col-md-12 text-center">
                            <h4>${service.service.name}</h4>
                            <input type="number" value="${service.quantity}" class="form-control mx-auto" style="width: 100px;" id="serv_qty" placeholder="Quantity">
                        </div>
                    </div>
                `

                amodal.setTitleText('Add Service');
                amodal.setBodyHtml(body);
                amodal.setFooterHtml(`
                    <div class='d-flex w-100 justify-content-between'>
                        <button class='btn btn-danger' onclick='ssml.viewServiceOrder(${order_id})'>Cancel</button>
                        <button class='btn btn-primary' id='update_service_to_order'>Update</button>
                        
                    </div>
                `);
                amodal.setSize('');
                amodal.show();

                $('#update_service_to_order').click(async function() {
                    let ids = ['mypk','serv_qty']
                    if(anton.validateInputs(ids)) {
                        let payload = {
                            module: 'service_order_item',
                            data: anton.Inputs(ids)
                        }

                        payload.data['service_item_id'] = id;
                        payload.data['service_id'] = order_id;

                        await api.v2('PATCH', payload, '/ssml/api/').then(response => {
                            if(anton.IsRequest(response)) {
                                kasa.success(response.message);
                                ssml.viewServiceOrder(order_id);
                            } else {
                                kasa.error(response.message);
                            }
                        }).catch(error => {
                            kasa.error(error);
                        });
                    } else {
                        kasa.error('Please fill all the fields');
                    }
                });
                
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    async deleteService(id, order_id) {
        let payload = {
            module: 'order_service',
            data: {
                id: id
            }
        }

        if(confirm('Are you sure you want to delete this service?')) {
            await api.v2('DELETE', payload, '/ssml/api/').then(response => {
                if(anton.IsRequest(response)) {
                kasa.success(response.message);
                ssml.viewServiceOrder(order_id);
            } else {
                kasa.error(response.message);
            }
            }).catch(error => {
                kasa.error(error);
            });
        } else {
            kasa.error('Operation Cancelled');
        }
    }


    async addMaterial(order_id) {
        let payload = {
            module: 'material',
            data: {
                id: '*'
            }
        }   

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let materials = response.message;
                let tbody = '';
                materials.forEach(material => {
                    tbody += `<tr>
                        <td>${material.barcode}</td>
                        <td>${material.name}</td>
                        <td>
                            <button class="btn btn-warning" onclick="ssml.addMaterialToOrder(${order_id}, ${material.id}, '${material.name}')">Add</button>
                        </td>
                    </tr>`;
                });
                amodal.setTitleText('Add Material');
                amodal.setBodyHtml(`
                    <table class="table table-bordered table-stripped table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>Code</th>
                                <th>Name</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${tbody}
                        </tbody>
                    </table>
                `);
                amodal.setFooterHtml(`
                    <button class='btn btn-danger' onclick='ssml.viewServiceOrder(${order_id})'>Cancel</button>
                `);
                amodal.setSize('');
                amodal.show();
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    async addMaterialToOrder(order_id) {

        let line = order_id;
        let material_name = $('#name_'+line).text();
        let material_barcode = $('#barcode_'+line).text();
        let material_qty = $('#qty_'+line).val();

        
        let active_tab = $('#serviceOrderTabs .nav-link.active').attr('href');
        let next_line = active_tab == '#materials' ? $('#materials_table tr').length + 1 : $('#returns_table').length + 1
        let row_id = active_tab == '#materials' ? 'mat_'+next_line : 'ret_'+next_line;
        let row_barcode_id = active_tab == '#materials' ? 'mat_barcode_'+next_line : 'ret_barcode_'+next_line;
        let row_name_id = active_tab == '#materials' ? 'mat_name_'+next_line : 'ret_name_'+next_line;
        let row_qty_id = active_tab == '#materials' ? 'mat_qty_'+next_line : 'ret_qty_'+next_line;

        let row = `
            <tr  id="${row_id}">
                <td ondblclick='$(#${row_id}).remove()'>${next_line}</td>
                <td id="${row_barcode_id}">${material_barcode}</td>
                <td id="${row_name_id}">${material_name}</td>
                <td><input style='width: 100px;' type="number" id="${row_qty_id}" class="form-control" placeholder="Qty" value="1"></td>
            </tr>
        `

        if(active_tab == '#materials'){
            $('#materials_table').append(row);
        } else {
            $('#returns_table').append(row);
        }

        return
            
        let body = `
            <div class="row">
                <div class="col-md-12 text-center">
                    <h4>${material_name}</h4>
                    <div class="row d-flex justify-content-center">
                        <div class="col-md-3">
                            <select class="form-control rounded-0 mx-auto" id="mat_type">
                                <option value="">Select Type</option>
                                <option value="rt">Return</option>
                                <option value="is">Issue</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <input type="number" class="form-control rounded-0 mx-auto"  id="mat_qty" placeholder="Quantity">
                        </div>
                    </div>
                </div>
            </div>
        `

        amodal.setTitleText('Add Material');
        amodal.setBodyHtml(body);
        amodal.setFooterHtml(`
            <div class='d-flex w-100 justify-content-between'>
                <button class='btn btn-danger' onclick='ssml.viewServiceOrder(${order_id})'>Cancel</button>
                <button class='btn btn-primary' id='add_material_to_order'>Add</button>
            </div>
        `);
        amodal.setSize('');
        amodal.show();

        $('#add_material_to_order').click(async function() {
            let ids = ['mypk','mat_qty','mat_type']
            if(anton.validateInputs(ids)) {
                let payload = {
                    module: 'material_order_item',
                    data: anton.Inputs(ids)
                }

                payload.data['order_id'] = order_id;
                payload.data['material_id'] = material_id;

                await api.v2('PUT', payload, '/ssml/api/').then(response => {
                    if(anton.IsRequest(response)) {
                        kasa.success(response.message);
                        ssml.viewServiceOrder(order_id);
                    } else {
                        kasa.error(response.message);
                    }
                }).catch(error => {
                    kasa.error(error);
                });
            } else {
                kasa.error('Please fill all the fields');
            }
        });
    }

    async closeServiceOrder(id) {
        let body = `
        `

        let service_body = ``


        amodal.setTitleText('Close Service Order');
        amodal.setBodyHtml(body);
        amodal.setFooterHtml('<button class="btn btn-primary" id="close_modal">Close</button>');
        amodal.setSize('L');
        amodal.show();
        
    }

    editServiceOrder(id) {
        console.log(id);
    }

    async deleteServiceOrder(id) {
        let payload = {
            module: 'service_order',
            data: {
                id: id
            }
        }

        await api.v2('DELETE', payload, '/ssml/api/').then(response => {    
            if(anton.IsRequest(response)) {
                kasa.success(response.message);
                ssml.LoadServiceOrders();
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    async EditContractor(id) {
        let payload = {
            module: 'contractor',
            data: {
                id: id
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let contractor = response.message;
                console.log(contractor);

                let form = `
                    <div class='row'>
                        <div class="form-group mb-2 col-sm-6">
                            <label for="link" class="text-primary">Link</label>
                            <input type="text" class="form-control" value="${contractor.link}" id="link" name="link">
                        </div>
                        <div class="form-group mb-2 col-sm-6">
                            <label for="company" class="text-primary">Company</label>
                            <input type="text" class="form-control" value="${contractor.company}" id="company" name="company">
                        </div>
                        
                        
                        
                        <div class="form-group mb-2 col-sm-6">
                            <label for="owner" class="text-primary">Owner</label>
                            <input type="text" class="form-control" value="${contractor.owner}" id="owner" name="owner">
                        </div>
                        <div class="form-group mb-2 col-sm-6">
                            <label for="phone" class="text-primary">Phone</label>
                            <input type="text" class="form-control" value="${contractor.phone}" id="phone" name="phone">
                        </div>
                        <div class="form-group mb-2 col-sm-6">
                            <label for="email" class="text-primary">Email</label>
                            <input type="email" class="form-control" value="${contractor.email}" id="email" name="email">
                        </div>
                        <div class="form-group mb-2 col-sm-6">
                            <label for="country" class="text-primary">Country</label>
                            <input type="text" class="form-control" value="${contractor.country}" id="country" name="country">
                        </div>
                        <div class="form-group mb-2 col-sm-6">
                            <label for="city" class="text-primary">City</label>
                            <input type="text" class="form-control" value="${contractor.city}" id="city" name="city">
                        </div>
                        <div class="form-group mb-2 col-sm-6">
                            <label for="postal_code" class="text-primary">Postal Code</label>
                            <input type="text" class="form-control" value="${contractor.postal_code}" id="postal_code" name="postal_code">
                        </div>
                        <div class="form-group mb-2 col-sm-6">
                            <label for="gh_post_code" class="text-primary">Ghana Post Code</label>
                            <input type="text" class="form-control" value="${contractor.gh_post_code}" id="gh_post_code" name="gh_post_code">
                        </div>
                        <div class="form-group mb-2 col-sm-6">
                            <label for="gh_card_no" class="text-primary">Ghana Card No</label>
                            <input type="text" class="form-control" value="${contractor.gh_card_no}"   id="gh_card_no" name="gh_card_no">
                        </div>

                    </div>
                    
                    
                     

                `

                amodal.setTitleText('Edit Contractor');
                amodal.setBodyHtml(form);
                amodal.setFooterHtml('<button class="btn btn-primary" id="update_contractor">Update</button>');
                amodal.setSize('L');
                amodal.show();

                $('#update_contractor').click(async function() {
                    let ids = ['link','company','owner','phone','email','country','city','postal_code','gh_post_code','gh_card_no']
                    if(anton.validateInputs(ids)) {
                            let payload = {
                                module: 'contractor',
                                data: anton.Inputs(ids)
                            }
                            payload.data['id'] = id;

                            await api.v2('PATCH', payload, '/ssml/api/').then(response => {
                                if(anton.IsRequest(response)) {
                                    kasa.success(response.message);
                                    location.reload();
                                } else {
                                    kasa.error(response.message);
                                }
                            });
                    } else {
                        kasa.error('Please fill all the fields');
                    }
                });

            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    async ViewContractor(id) {
        loader.show();
        let payload = {
            module: 'contractor',
            data: {
                id: id
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let contractor = response.message;
                let total_credit = contractor.ledger.total_credit
                let total_balance = contractor.ledger.total_balance
                let total_debit = contractor.ledger.total_debit
                
            
                let body = `
                    
                    <div class="row m-2" id='contractor_print_screen'>
                        <div class="col-md-12" style="background-color:rgba(248, 249, 250, 0.57); padding: 20px; border-radius: 10px; border: 2px dotted #808080;">
                            <div class="row">
                                <div class="col-md-4">
                                    <strong class="text-primary">Company</strong>
                                    <p><small>${contractor.company}</small><br>
                                        <small>${contractor.link}</small>
                                    </p>
                                </div>
                                <div class="col-md-4">
                                    <strong class="text-primary">Owner</strong>
                                    <p><small>${contractor.owner}</small></p>
                                </div>
                                <div class="col-md-4">
                                    <strong class="text-primary">Contact</strong>
                                    <p><small>${contractor.phone}</small><br>
                                        <small>${contractor.email}</small>
                                    </p>
                                </div>

                                <div class="col-md-4">
                                    <strong class="text-primary text-center">Materials Balance</strong>
                                    <div id='materials_balance'>
                                        <div class="spinner-border text-primary" role="status">
                                                <span class="visually-hidden"></span>
                                            </div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <strong class="text-primary text-center">Service Balance</strong>
                                    <div id='service_balance'>
                                        ${total_credit}
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <strong class="text-primary text-center">Total Balance</strong>
                                    <div id='total_balance'>
                                        ${total_balance}
                                    </div>
                                </div>
                            </div>

                            
                        </div>

                        <h4 class="mt-4">Materials <span class="text-primary" id="total_amount"></span></h4>

                        <div class='col-sm-12' style="background-color:rgba(248, 249, 250, 0.57); padding: 20px; border-radius: 10px; border: 2px dotted #808080;">
                            <table class="table table-bordered table-stripped table-bordered">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Barcode</th>
                                        <th>Name</th>
                                        <th>Issued</th>
                                        <th>Consumed</th>
                                        <th>Balance</th>
                                        <th>Rate</th>
                                        <th>Value</th>
                                    </tr>
                                </thead>
                                <tbody id='mat_rows'>
                                    <tr>
                                        <td colspan="7" class="text-center">
                                            <div class="spinner-border text-primary" role="status">
                                                <span class="visually-hidden">Loading...</span>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <h4 class="mt-4">Returns <span class="text-primary" id="total_returns"></span></h4>
                        <div class='col-sm-12' style="background-color:rgba(248, 249, 250, 0.57); padding: 20px; border-radius: 10px; border: 2px dotted #808080;">
                            <table class="table table-bordered table-stripped table-bordered">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Barcode</th>
                                        <th>Name</th>
                                        <th>Expected</th>
                                        <th>Returned</th>
                                        <th>Balance</th>
                                        <th>Rate</th>
                                        <th>Value</th>
                                    </tr>
                                </thead>
                                <tbody id='ret_rows'>
                                    <tr>
                                        <td colspan="6" class="text-center">
                                            <div class="spinner-border text-primary" role="status">
                                                <span class="visually-hidden">Loading...</span>
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                `

                amodal.setTitleText('Contractor Details');
                amodal.setBodyHtml(body);
                amodal.setFooterHtml('<button class="btn btn-primary" id="print_contractor">Print</button>');
                amodal.setSize('L');
                amodal.show();
                loader.hide();

                let issue_material_balance = 0;
                


                // get materials
                let mat_load = {
                    module: 'material',
                    data: {
                        contractor_id: id
                    }
                }
                let mat_rows = ``;
                api.v2('VIEW', mat_load, '/ssml/api/contractor/').then(response => {
                    if(anton.IsRequest(response)) {
                        let materials = response.message;
                        let total_amount = 0;
                        materials.forEach(material => {
                            mat_rows += `
                                <tr>
                                    <td>${material.barcode}</td>
                                    <td>${material.name}</td>
                                    <td>${material.issued}</td>
                                    <td>${material.consumed}</td>
                                    <td>${material.balance}</td>
                                    <td>${material.rate}</td>
                                    <td>${material.value}</td>
                                </tr>
                            `;
                            total_amount += parseFloat(material.value);
                        });
                        
                        $('#mat_rows').html(mat_rows);
                        $('#total_amount').html(total_amount.toFixed(2));
                        issue_material_balance = total_amount;
                        
                    } else {
                        
                        mat_rows = `
                            <tr>
                                <td colspan="7" class="text-center text-danger">
                                    ${response.message}
                                </td>
                            </tr>
                        `;
                        console.log(mat_rows);
                        console.log(mat_rows);
                        $('#mat_rows').html(mat_rows);
                    }
                }).catch(error => {
                    mat_rows = `
                        <tr>
                            <td colspan="7" class="text-center text-danger">
                                ${error}
                            </td>
                        </tr>
                    `;
                    console.log(mat_rows);
                    $('#mat_rows').html(mat_rows);
                });


                let return_material_balance = 0;
                let ret_load = {
                    module: 'returns',
                    data: {
                        contractor_id: id
                    }
                }
                let ret_rows = ``;
                api.v2('VIEW', ret_load, '/ssml/api/contractor/').then(response => {
                    console.log(response);
                    if(anton.IsRequest(response)) {
                        let returns = response.message.transactions;
                        let total_returns = response.message.total;
                        returns.forEach(ret => {
                            ret_rows += `
                                <tr>
                                    <td>${ret.barcode}</td>
                                    <td>${ret.name}</td>
                                    <td>${ret.expected}</td>
                                    <td>${ret.returned}</td>
                                    <td>${ret.balance}</td>
                                    <td>${ret.rate}</td>
                                    <td>${ret.total_value}</td>
                                </tr>
                            `;
                            // total_returns += parseFloat(ret.total_value);
                        });
                        $('#ret_rows').html(ret_rows);
                        $('#total_returns').html(total_returns);
                        return_material_balance = total_returns;
                        console.log("returns_balance",return_material_balance);
                        console.log("issue_material_balance",issue_material_balance);
                        let materials_balance = parseFloat(issue_material_balance) + parseFloat(return_material_balance);
                        $('#materials_balance').empty();
                        $('#materials_balance').html(total_debit);
                        // let t_balance = parseFloat(total_credit) - parseFloat(materials_balance)
                        // $('#total_balance').html(total_balance.toFixed(2))
                        
                        // get service balance


                    } else {
                        ret_rows = `
                            <tr>
                                <td colspan="6" class="text-center text-danger">
                                    ${response.message}
                                </td>
                            </tr>
                        `;
                        $('#ret_rows').html(ret_rows);
                    }
                }).catch(error => {
                    ret_rows = `
                        <tr>
                            <td colspan="6" class="text-center text-danger">
                                ${error}
                            </td>
                        </tr>
                    `;
                    $('#ret_rows').html(ret_rows);
                });


                
                
                
                

                $('#print_contractor').click(function() {
                    let print_screen = document.getElementById('contractor_print_screen');
                    let print_window = window.open('', '', 'height=400,width=600');
                    print_window.document.write('<html><head><style>');
                    print_window.document.write('table { width: 100%; border-collapse: collapse; margin-bottom: 1em; }');
                    print_window.document.write('th, td { border: 1px solid black; padding: 8px; text-align: left; }');
                    print_window.document.write('th { background-color: #ddd; }');
                    print_window.document.write('h4 { margin: 1em 0; }');
                    print_window.document.write('.col-sm-12 { margin: 1em 0; padding: 1em; border: 1px dashed #999; }');
                    print_window.document.write('</style></head><body>');
                    print_window.document.write(print_screen.innerHTML);
                    print_window.document.write('</body></html>');
                    print_window.document.close();
                    print_window.print();
                });
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    async addReturn(server_order_id) {
        // get materials
        let payload = {
            module: 'material',
            data: {
                id:'*'
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let materials = response.message;
                let tr = ``;
                materials.forEach(material => {
                    tr += `
                        <tr>
                            <td>${material.barcode}</td>
                            <td>${material.name}</td>
                            <td>${material.value}</td>
                            <td><button class='btn btn-primary' onclick='ssml.addReturnToOrder(${server_order_id}, ${material.id}, "${material.name}")'>Add</button></td>
                        </tr>
                    `;
                });

                let body = `
                    <div class='row'>
                        <div class='col-md-12'>
                            <table class='table table-bordered table-stripped table-bordered'>
                                <thead class='table-dark'>
                                    <tr>
                                        <th>Barcode</th>
                                        <th>Name</th>
                                        <th>Value</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    ${tr}
                                </tbody>
                            </table>
                        </div>
                    </div>
                `;

                amodal.setTitleText('Add Material');
                amodal.setBodyHtml(body);
                amodal.setFooterHtml(`<button onclick="ssml.viewServiceOrder(${server_order_id})" class="btn btn-primary" id="close_modal">Close</button>`);
                amodal.setSize('L');
                amodal.show();

            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    async addReturnToOrder(server_order_id, material_id, material_name) {
        let body = `
            <div class='row'>
                <div class='col-md-12'>
                    <h4>${material_name}</h4>
                    <div class='form-group'>
                        <label for='ret_qty'>Quantity</label>
                        <input type='number' class='form-control' id='ret_qty' name='ret_qty'>
                        <input type='hidden' id='material_id' value='${material_id}'>
                    </div>
                </div>
            </div>
        `

        amodal.setTitleText('Add Material to Order');
        amodal.setBodyHtml(body);
        amodal.setFooterHtml(`<button onclick="ssml.viewServiceOrder(${server_order_id})" class="btn btn-primary" id="close_modal">Cancel</button>
            <button class="btn btn-primary" id="add_material_to_order">Add</button>
            `);
        amodal.setSize('L');
        amodal.show();

        $('#add_material_to_order').click(async function() {
            let ids = ['ret_qty','material_id','mypk'];
            if(anton.validateInputs(ids)) {
                let payload = {
                    module: 'service_order_return',
                    data: anton.Inputs(ids)
                }

                payload.data['server_order_id'] = server_order_id;
                await api.v2('PUT', payload, '/ssml/api/').then(response => {
                    if(anton.IsRequest(response)) {
                        kasa.success(response.message);
                        ssml.viewServiceOrder(server_order_id);
                    } else {
                        kasa.error(response.message);
                    }
                }).catch(error => {
                    kasa.error(error);
                });
            } else {
                kasa.error('Please fill all the fields');
            }
        });
    }

    async editReturn(return_id, server_order_id) {
        let payload = {
            module: 'service_order_return',
            data: {
                id: return_id
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let return_item = response.message;
                let body = `
                    <div class='row'>
                        <div class='col-md-12'>
                            <h4>${return_item.material.name}</h4>
                            <div class='form-group'>
                                <label for='ret_qty'>Quantity</label>
                                <input type='number' class='form-control' id='ret_qty' name='ret_qty' value='${return_item.quantity}'>
                                <input type='hidden' id='ret_id' value='${return_id}'>
                            </div>
                        </div>
                    </div>
                `;

                amodal.setTitleText('Edit Return'); 
                amodal.setBodyHtml(body);
                amodal.setFooterHtml(`<button onclick="ssml.viewServiceOrder(${server_order_id})" class="btn btn-primary" id="close_modal">Cancel</button>
                    <button class="btn btn-primary" id="update_return">Update</button>
                `);
                amodal.setSize('L');
                amodal.show();

                $('#update_return').click(async function() {
                    let ids = ['ret_qty','ret_id','mypk'];
                    if(anton.validateInputs(ids)) {
                        let payload = {
                            module: 'service_order_return',
                            data: anton.Inputs(ids)
                        }

                        payload.data['id'] = return_id;
                        payload.data['server_order_id'] = server_order_id;

                        await api.v2('PATCH', payload, '/ssml/api/').then(response => {
                            if(anton.IsRequest(response)) {
                                kasa.success(response.message);
                                ssml.viewServiceOrder(server_order_id);
                            } else {
                                kasa.error(response.message);
                            }
                        }).catch(error => {
                            kasa.error(error);
                        });
                    } else {
                        kasa.error('Please fill all the fields');
                    }
                });
            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    async deleteReturn(return_id, server_order_id) {
        let payload = {
            module: 'service_order_return',
            data: {
                id: return_id
            }
        }

        await api.v2('DELETE', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                kasa.success(response.message);
                ssml.viewServiceOrder(server_order_id);
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    async ViewContractorJobs(contractor_id) {
        
        let payload = {
            module: 'service_order',
            data: {
                id: '*',
                contractor: contractor_id,
                filter: 'contractor'
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let jobs = response.message;
                let body = `
                    <div class='row'>
                        <div class='col-md-12'>
                            <h4>Jobs</h4>
                            <table class='table table-bordered table-stripped table-bordered'>
                                <thead class='table-dark'>
                                    <tr>
                                        <th>Job</th>
                                        <th>Date</th>
                                        <th>Geo Code</th>
                                        <th>Service Type</th>
                                        <th>Total Amount</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    ${jobs.map(job => `
                                        <tr>
                                            <td>${job.id}</td>
                                            <td>${job.service_date}</td>
                                            <td>${job.plot.plot_no}-${job.geo_code}</td>
                                            <td>${job.service_type.name}</td>
                                            <td>${job.total_amount}</td>
                                            <td>${job.status}</td>
                                        </tr>
                                    `).join('')}
                            </table>
                        </div>
                    </div>
                `;

                amodal.setTitleText('Contractor Jobs');
                amodal.setBodyHtml(body);
                amodal.setFooterHtml(`<button class="btn btn-primary" id="export_jobs">Export</button>`);
                amodal.setSize('L');
                loader.hide();
                amodal.show();
                
            } else {
                kasa.error(response.message);
                loader.hide();
            }
        }).catch(error => {
            kasa.error(error);
            loader.hide();
        });
    }

    async deleteIssue(id) {
        let payload = {
            module: 'issue',
            data: {
                id: id
            }
        }

        await api.v2('DELETE', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                kasa.success(response.message);
                location.reload();
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }

    

    async loadContractor(contractor_id) {
        loader.show();
        let payload = {
            module: 'contractor',
            data: {
                id: contractor_id
            }
        }

        

        await api.v2('VIEW', payload, '/ssml/api/contractor/').then(response => {
            if(anton.IsRequest(response)) {
                let contractor = response.message;
                console.table(contractor);
                $('#name').val(contractor.company);
                $('#owner').val(contractor.owner);
                $('#link').val(contractor.link);
                $('#phone').val(contractor.phone);
                $('#email').val(contractor.email);
                $('#address').val( contractor.city + ', ' + contractor.postal_code);
                // $('#debit').val(contractor.recievable);
                $('#credit').val(contractor.ledger.total_credit);
                // $('#balance').val(contractor.balance);
                $('#contractor_id').val(contractor_id);

                if(contractor.prev_row) {
                    
                    $('#prev_contractor').attr('disabled', false);
                    previous = contractor.prev_row
                } else {
                    $('#prev_contractor').attr('disabled', true);
                    previous =0
                }

                if(contractor.next_row) {
                    $('#next_contractor').attr('disabled', false);
                    next = contractor.next_row
                } else {
                    $('#next_contractor').attr('disabled', true);
                    next = 0
                    
                }

                loader.hide();

                let debit_payload = {
                    module:'debit_summary',
                    data:{
                        contractor_id:contractor_id
                    }
                }

                api.v2('VIEW',debit_payload,'/ssml/api/contractor/').then(response => {
                    
                    if(anton.IsRequest(response)){
                        let tot = response.message.total
                        let balance = parseFloat(contractor.ledger.total_credit) + parseFloat(tot)
                        $('#debit').val(parseFloat(tot).toFixed(2))
                        $('#balance').val(balance.toFixed(2))
                        
                    }

                }).catch(error => {
                    console.error(error)
                })

                $('#jobs').html(`
                    <tr>
                        <td colspan="7" class="text-center">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </td>
                    </tr>
                `);

                // get recievales
                let rec_payload = {
                    module:'recievable',
                    data:{
                        contractor_id:contractor_id
                    }
                }

                // api.v2('VIEW',rec_payload,'/ssml/api/contractor/').then(response => {
                //     //console.table(response)

                // }).catch(error => {
                //     console.error(error)
                // })

                // get jobs
                let payload = {
                    module: 'service_order',
                    data: {
                        id: '*',
                        contractor: contractor_id,
                        filter: 'contractor',
                        status:'pending'
                    }
                }

                payload = {}

                api.v2('VIEW', payload, '/ssml/api/').then(response => {
                    if(anton.IsRequest(response)) {
                        let jobs = response.message;
                        
                        let max_length = 10;
                        if(jobs.length < max_length) {
                            max_length = jobs.length;
                        }
                        let tr = ``;
                        for(let i = 0; i < max_length; i++) {
                            let job = jobs[i];
                            let status = job.status == 'completed' ? 'text-success' : 'text-warning';
                            tr += `
                                <tr>
                                    <td>${job.new_meter_no}</td>
                                    <td>${job.service_date}</td>
                                    <td>${job.plot.plot_no}-${job.geo_code}</td>
                                    <td>${job.service_type.name}</td>
                                    <td>${job.total_amount}</td>
                                    <td id='status_${job.id}' class='${status}'>${job.status}</td>
                                    <td>
                                        <div class="dropdown">
                                            <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                Action
                                            </button>
                                            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                                <a class="dropdown-item" href="javascript:void(0)" onclick="ssml.closeJob(${job.id})">Close</a>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            `;
                        }
                        $('#jobs').html(tr);
                    } else {
                        $('#jobs').html(`
                            <tr>
                                <td colspan="7" class="text-center">
                                    ${response.message}
                                </td>
                            </tr>
                        `);
                    }
                }).catch(error => {
                    kasa.error(error);
                });
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }


    async closeJob(job_id) {
        let payload = {
            module: 'close_service_order',
            data: {
                id: job_id,
                mypk: $('#mypk').val()
            }
        }

        if(true) {
            await api.v2('PATCH', payload, '/ssml/api/').then(response => {
                if(anton.IsRequest(response)) {
                kasa.success(response.message);
                $('#status_'+job_id).html('Completed');
                $('#status_'+job_id).attr('class', 'text-success');
                ssml.loadContractor(response.message)
            } else {
                kasa.error(response.message);
                }
            }).catch(error => {
                kasa.error(error);
            });
        } else {
            kasa.error('Operation Cancelled');
        }
    }


    async LoadServiceOrder(id) {
        loader.show();
        let payload = {
            module: 'service_order',
            data: {
                id: id,
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let service_order = response.message[0];
                console.table(service_order);
                $('#contractor').val(service_order.contractor.company);
                $('#service_type').val(service_order.service_type.name);
                $('#service_date').val(service_order.service_date);
                $('#customer').val(service_order.customer);
                $('#customer_no').val(service_order.customer_no);
                $('#geo_data').val(service_order.plot.plot_no + '-' + service_order.geo_code);
                $('#old_meter_no').val(service_order.old_meter_no);
                $('#old_meter_no_reading').val(service_order.old_meter_reading);
                $('#new_meter_no').val(service_order.new_meter_no);
                $('#new_meter_no_reading').val(service_order.new_meter_no_reading);
                $('#total_amount').val(service_order.total_amount);
                $('#service_order_id').val(service_order.id);

                if(service_order.next_row) {
                    $('#next_service_order').attr('onclick', `ssml.LoadServiceOrder(${service_order.next_row})`);
                    $('#next_service_order').attr('disabled', false);
                } else {
                    $('#next_service_order').attr('disabled', true);
                }

                if(service_order.prev_row) {
                    $('#prev_service_order').attr('onclick', `ssml.LoadServiceOrder(${service_order.prev_row})`);
                    $('#prev_service_order').attr('disabled', false);
                } else {
                    $('#prev_service_order').attr('disabled', true);
                }
                

                let materials = service_order.materials;
                let materials_table = ``;
                materials.forEach(material => {
                    materials_table += `
                        <tr>
                            <td>${material.material.barcode}</td>
                            <td>${material.material.name}</td>
                            <td>ISS</td>
                            <td>${material.quantity}</td>
                        </tr>
                    `;
                });
                $('#materials_table').html(materials_table);

                let returns = service_order.returns;
                let returns_table = ``;
                returns.forEach(ret => {
                    returns_table += `
                        <tr>
                            <td>${ret.material.barcode}</td>
                            <td>${ret.material.name}</td>
                            <td>${ret.quantity}</td>
                            <td>${ret.rate}</td>
                            <td>${ret.amount}</td>
                        </tr>
                    `;
                });
                $('#returns_table').html(returns_table);

                let services = service_order.service_items;
                let services_table = ``;
                services.forEach(service => {
                    services_table += `
                        <tr>
                            <td>${service.service.name}</td>
                            <td>${service.quantity}</td>
                            <td>${service.rate}</td>
                            <td>${service.amount}</td>
                        </tr>
                    `;
                });
                $('#services_table').html(services_table);

                loader.hide();
            } else {
                kasa.error(response.message);
                loader.hide();
            }
        }).catch(error => {
            kasa.error(error);
            loader.hide();
        });
    }


    async AddMaterialToOrderScreen() {
        
        let body =  `
            <input type="text" id="material_search" class="form-control w-50 mx-auto mb-2" placeholder="Search Material">
            <div id="material_search_results"></div>
        `;        
        amodal.setTitleText('Search Material');
        amodal.setBodyHtml(body);
        amodal.setSize('L');
        amodal.show();

        $('#material_search').on('keyup', function(event) {
            let search = $(this).val();
            // check if key is enter
            if(event.key === 'Enter') {
                let string = search.trim();
                if(string.length > 0) {
                    // get materials
                    let payload = {
                        module: 'material',
                        data: {
                            id: string
                        }
                    }

                    api.v2('VIEW', payload, '/ssml/api/').then(response => {
                        if(anton.IsRequest(response)) {
                            let materials = response.message;
                            let material_search_results = ``;
                            let line = 1;
                            materials.forEach(material => {
                                
                                let row_id = `material_${line}`;
                                material_search_results += `
                                    <tr id="${row_id}">
                                        <td  id='barcode_${line}'>${material.barcode}</td>
                                        <td id='name_${line}'>${material.name}</td>
                                        <td><input style='width: 100px;' type="number" id='qty_${line}' class="form-control" placeholder="Qty" value="1"></td>
                                        <td><button class="btn btn-primary" id='add_${line}' onclick="ssml.addMaterialToOrder(${line})">Add</button></td>
                                    </tr>
                                `;
                                line++;
                            });

                            let tb = `
                                <table class="table table-bordered">
                                    <thead class="thead-dark">
                                        <tr>
                                            <th>Barcode</th>
                                            <th>Name</th>
                                            <th>Qty</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        ${material_search_results}
                                    </tbody>
                                </table>
                            `;
                            $('#material_search_results').html(tb);
                        }
                    }).catch(error => {
                        kasa.error(error);
                    });
                } else {
                    kasa.error('Please enter at least a character');
                }
            }
        });
        
        
    }


    AddContractor(){
        amodal.setTitleText('Contractors');
            amodal.setBodyHtml('<div id="contractor_modal"></div>');
            amodal.setFooterHtml('<button class="btn btn-primary" id="add_contractor">Add Contractor</button>');
            amodal.show();

            $("#add_contractor").click(function(){
                amodal.setTitleText('Add Contractor');
                let form = `
                    <div class="form-group mb-2">
                        <label for="link" class="text-info">Link</label>
                        <input type="text" class="form-control" id="link" name="link">
                    </div>
                    <div class="form-group mb-2">
                        <label for="company" class="text-info">Company</label>
                        <input type="text" class="form-control" id="company" name="company">
                    </div>
                    <div class="form-group mb-2">
                        <label for="owner" class="text-info">Owner</label>
                        <input type="text" class="form-control" id="owner" name="owner">
                    </div>
                    <div class="form-group mb-2">
                        <label for="phone" class="text-info">Phone</label>
                        <input type="text" class="form-control" id="phone" name="phone">
                    </div>
                    <div class="form-group mb-2">
                        <label for="email" class="text-info">Email</label>
                        <input type="email" class="form-control" id="email" name="email">
                    </div>
                    <div class="form-group mb-2">
                        <label for="country" class="text-info">Country</label>
                        <input type="text" class="form-control" id="country" name="country">
                    </div>
                    <div class="form-group mb-2">
                        <label for="city" class="text-info">City</label>
                        <input type="text" class="form-control" id="city" name="city">
                    </div>
                    <div class="form-group mb-2">
                        <label for="postal_code" class="text-info">Postal Code</label>
                        <input type="text" class="form-control" id="postal_code" name="postal_code">
                    </div>
                    <div class="form-group mb-2">
                        <label for="gh_post_code" class="text-info">Ghana Post Code</label>
                        <input type="text" class="form-control" id="gh_post_code" name="gh_post_code">
                    </div>
                    <div class="form-group mb-2">
                        <label for="gh_card_no" class="text-info">Ghana Card No</label>
                        <input type="text" class="form-control" id="gh_card_no" name="gh_card_no">
                    </div>
                    
                    
                     

                `;
                amodal.setBodyHtml(form);
                amodal.setFooterHtml('<button class="btn btn-primary" id="save_contractor">Save</button>');
                amodal.show();
                $("#save_contractor").click(async function(){
                    let ids = ['link', 'company', 'owner', 'phone', 'email','country','city','postal_code','gh_post_code','gh_card_no','mypk'];
                    if(anton.validateInputs(ids)){
                        let payload = {
                            module: 'contractor',
                            data: anton.Inputs(ids)
                        }

                        await api.v2('PUT',payload,'/ssml/api/').then(res=>{
                            kasa.response(res);
                        }).catch(err=>{
                            kasa.error(err);
                        });

                        
                    } else {
                        kasa.error('Please fill all the fields');
                    }
                });
            });
    }



    async retRecon(service_id){
        let payload = {
            module:'ret_def_rec',
            data:{
                service_id:service_id,
                mypk:$('#mypk').val()
            }
        }
        loader.show()

        await api.v2('PATCH',payload,'/ssml/api/').then(response => {
            if(anton.IsRequest(response)){
                kasa.response(response)
                loader.hide()
                ssml.viewServiceOrder(service_id)
            } else {
                kasa.response(response)
                loader.hide()
            }
        }).catch(error => {
            kasa.error(error)
            loader.hide()
        })
    }


    async materialUsage(){
        

        let payload = {
            module:'contractor',
            data:{
                contractor_id:'*'
            }
        }

        await api.v2('VIEW',payload,'/ssml/api/').then(response => {
            if(anton.IsRequest(response)){
                let conts = response.message
                let option = ``
                for(let x = 0; x < conts.length; x++){
                    let contractor = conts[x];
                    console.table(contractor)
                    option +=  `<option value='${contractor.id}' >${contractor.company}</option>`
                }

                let form = `
                <div class='form-group mb-2'>
                    <label>CONTRACTOR</label><br>
                    <select class='form-control' id='contractor_id'>
                        ${option}
                    </select>
                </div>
                <div class='form-group'>
                    <label>BARCODE</label><br>
                    <input class='form-control' id='barcode' >
                </div>
            
            `
                amodal.setBodyHtml(form)
                amodal.setFooterHtml(`<button id='see'>SEE</button>`)
                amodal.show()

                $('#see').click(async function(){
                    let ids = ['barcode','contractor_id'];
                    payload = {
                        module:'contractor_usage',
                        data:anton.Inputs(ids)
                    }

                    await api.v2('VIEW',payload,'/ssml/api/contractor/').then(response => {
                        if(anton.IsRequest(response)){
                            let records = response.message
                            let to_export = []
                            let tr = ``;
                            for(let m = 0; m < records.length; m++){
                                let record = records[m];
                                console.table(record)
                                tr += `
                                    <tr>
                                        <td>${record.meter}</td>
                                        <td>${record.barcode}</td>
                                        <td>${record.name}</td>
                                        <td>${record.quantity}</td>
                                    </tr>
                                `

                                to_export.push([record.meter,record.name,record.quantity])
                            }

                            let table = `<table class='table table-sm table-bordered'>
                                <tbody>${tr}</tbody>
                            </table>`

                            amodal.setBodyHtml(table)
                            amodal.setSize('L')
                            amodal.setFooterHtml(`<button>AGAIN</button><button id='export'>Export</button>`)

                            $('#export').click(function(){
                                anton.downloadCSV('material_use.csv',anton.convertToCSV(to_export))
                            });

                        }
                    }).catch(error => {
                        kasa.error(error)
                    })
                })
            }
            
        }).catch(error => {
            kasa.error(error)
        })

        



        
    }

    getMeter(meter_number){
        let payload = {
            module:'meter',
            data:{
                meter_no:meter_number
            }
        }

        return api.call('VIEW',payload,'/ssml/api/')
    }

    loadByMeterNumber(meter_no){
        let meter = ssml.getMeter(meter_no)
        if(anton.IsRequest(meter)){
            // console.log("METER")
            // console.table(meter)

            // console.log("SERVICE #")
            // console.table(meter.message.service)
            ssml.LoadServiceOrder(meter.message.service)
        } else {
            kasa.response(meter)
        }
        console.table(meter)
    }

    async deleteServiceMaterial(id){
        let payload = {
            module:'service_material',
            data:{
                id:id
            }
        }

        if(confirm("Are You Sure?")){
            await api.v2('DELETE',payload,'/ssml/api/').then(response =>{
                kasa.response(response)
                ssml.viewServiceOrder($('#service_order_id').val())
            }).catch(error => {
                kasa.error(error)
            })
        } else {
            kasa.info("Operation Cancelled")
        }
    }

    async addMaterialToOrderOnly(order_id){
        let payload = {
            module: 'material',
            data: {
                id: '*'
            }
        }   

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let materials = response.message;
                let tbody = '';
                materials.forEach(material => {
                    let qty_id = `${material.barcode}_qty`
                    console.log(qty_id)
                    tbody += `<tr>
                        <td id='${material.barcode}'>${material.barcode}</td>
                        <td>${material.name}</td>
                        <td><input id='${qty_id}' value='1' type_no stayle='width:50' ><td>
                        <td>
                            <button class="btn btn-warning add-new-material" data-id='${material.id}' data-barcode='${material.barcode}' onclick="kasa.info('ok')">Add</button>
                        </td>
                    </tr>`;
                });
                amodal.setTitleText('Add Material');
                amodal.setBodyHtml(`
                    <table class="table table-bordered table-stripped table-bordered">
                        <thead class="table-dark">
                            <tr>
                                <th>Code</th>
                                <th>Name</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${tbody}
                        </tbody>
                    </table>
                `);
                amodal.setFooterHtml(`
                    <button class='btn btn-danger' onclick='ssml.viewServiceOrder(${order_id})'>Cancel</button>
                `);
                amodal.setSize('');
                amodal.show();

                $('.add-new-material').click(async function(){
                    let barcode = $(this).attr('data-barcode');
                    let material_id = $(this).attr('data-id')
                    let qty_id = `#${barcode}_qty`;
                    console.log(qty_id)
                    let qty = $(qty_id).val()
                    let payload = {
                        module:'material_order_item',
                        data:{
                            order_id:order_id,
                            material_id:material_id,
                            barcode:barcode,
                            mat_qty:qty,
                            mat_type:'is'
                        }
                    }

                    await api.v2('PUT',payload,'/ssml/api/').then(reponse => {
                        if(anton.IsRequest(response)){
                            kasa.success("Material Added")
                        } else {
                            kasa.error(response.message)
                        }

                    }).catch(error => {
                        kasa.error(err)
                    })

                    
                })
            } else {
                kasa.error(response.message);
            }
        }).catch(error => {
            kasa.error(error);
        });
    }


    async updateIssued(){
        loader.show()
        let payload = {
            module:'issue_def_qty',
            data:{}
        }

        await api.v2('PATCH',payload,'/ssml/api/').then(response => {
            kasa.response(response)
            loader.hide()
        }).catch(error => {kasa.error(error);loader.hide()})
    }

    async exportContractorService(doc='excel',id){
        loader.show()
        let payload = {
            module:'service_order',
            data:{
                document:doc,
                contractor_id:id
            }
        }

        await api.v2('VIEW',payload,'/ssml/api/contractor/').then(response => {

            if(anton.IsRequest(response)){
                console.table(response)
                anton.viewFile(`/${response.message}`)
                loader.hide()
            } else {
                kasa.response(response)
                loader.hide()
            }

        }).catch(error => {kasa.error(error);loader.hide()})
    }


    async contractorIssueScreen(){
        loader.show()
        let payload = {
            module: 'contractor',
            data: {
                id: '*'
            }
        }

        await api.v2('VIEW',payload,'/ssml/api/contractor/').then(response => {

            if(anton.IsRequest(response)){


                let opts = ``;
                for(let x = 0; x < response.message.length; x++){
                    let contractor = response.message[x];
                    opts += `<option value='${contractor.id}'>${contractor.company}</option>`
                }
                console.table(response.message)
                let form = `
                    <div class='form-group mb-2'>
                        <label for='issue_contractor'>Contractor</label>
                        <select class='form-control rounded-0' id='issue_contractor'>${opts}</select>
                    </div>

                    <div class='form-group mb-2'>
                        <label for='issue_type'>Issue Type</label>
                        <select class='form-control rounded-0' id='issue_type'>
                            <option value='ISS'>Issue</option>
                            <option value='RET'>Return</option>
                        </select>
                    </div>

                    <div class='form-group mb-2'>
                        <label for='mat_barcode'>Barcode</label>
                        <input class='form-control rounded-0' id='mat_barcode' />
                    </div>
                `

                amodal.setTitleText("Contractor Issue")
                amodal.setBodyHtml(form)
                amodal.setFooterHtml(`<button id='check_issue'>Check</button>`)
                amodal.setSize('')
                amodal.show()

                loader.hide()

                $('#check_issue').click(async function(){
                    loader.show()
                    let ids = ['mat_barcode','issue_type','issue_contractor']
                    if(anton.validateInputs(ids)){


                        let payload = {
                            module:'contractor_issue',
                            data:anton.Inputs(ids)
                        }
                        
                        await api.v2("VIEW",payload,'/ssml/api/contractor/').then(response => {
                            

                            if(anton.IsRequest(response)){
                                let issues = response.message;
                                let rows = ``;
                                let export_list = []
                                // amodal.hide()
                                for(let i = 0 ; i < issues.length; i++){
                                    const issue = issues[i]
                                    rows += `
                                        <tr>
                                            <td>${issue.issue_no}</td>
                                            <td>${issue.issue_date}</td>
                                            <td>${issue.material.barcode}</td>
                                            <td>${issue.material.name}</td>
                                            <td>${issue.total_qty}</td>
                                        </tr>
                                    `
                                    export_list.push([issue.issue_no,issue.issue_date,issue.material.name,issue.total_qty])
                                }

                                let table = `
                                    <table class='table table-sm table-stripped table-hover'>
                                        <thead>
                                            <tr>
                                                <th>ENTRY</th>
                                                <th>DATE</th>
                                                <th>BARCODE</th>
                                                <th>NAME</th>
                                                <th>QUANTITY</th>
                                            </tr>
                                        </thead>
                                        <tbody>${rows}</tbody>
                                    </table>
                                `

                                amodal.setBodyHtml(table)
                                amodal.setTitleText(`ISSUE`)
                                amodal.setSize('L')
                                amodal.setFooterHtml(`<button id='is_export'>Export</button>`)

                                $('#is_export').click(function(){
                                    anton.downloadCSV("ISSUE",anton.convertToCSV(export_list))
                                })

                            } else {
                                kasa.response(response)
                            }
                            loader.hide()

                        }).catch(error=>{
                            kasa.error(error)
                            loader.hise()
                        })



                    }
                })

            } else {
                kasa.response(response)
            }

            

        }).catch(error => {
            kasa.error(error)
            loader.hise()
        })

        
    }

}
const ssml = new SSML();