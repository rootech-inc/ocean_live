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
                            <button class="btn btn-primary mb-2" onclick="ssml.addMaterial(${id})">Add Material</button>
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
                            <button class="btn btn-warning" onclick="ssml.addServiceToOrder(${id}, ${service.id})">Add</button>
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

    async addMaterialToOrder(order_id, material_id, material_name) {
            
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
        let payload = {
            module: 'contractor',
            data: {
                id: id
            }
        }

        await api.v2('VIEW', payload, '/ssml/api/').then(response => {
            if(anton.IsRequest(response)) {
                let contractor = response.message;
                console.table(contractor.material);
                let body = `
                    <div class='card p-0'>
                        <div class='card-body p-2'>
                            <div class='d-flex flex-wrap'>
                                <button class='btn btn-primary'>Make Returns</button>
                            </div>
                        </div>
                    </div>
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
                            </div>

                            
                        </div>

                        <h4 class="mt-4">Materials</h4>

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
                                <tbody>
                                    ${contractor.materials.map(material => `
                                        <tr>
                                            <td>${material.barcode}</td>
                                            <td>${material.name}</td>
                                            <td>${material.issued}</td>
                                            <td>${material.consumed}</td>
                                            <td>${material.balance}</td>
                                            <td>${material.rate}</td>
                                            <td>${material.value}</td>
                                        </tr>
                                    `).join('')}
                                </tbody>
                            </table>
                        </div>

                        <h4 class="mt-4">Returns</h4>
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
                                <tbody>
                                    ${contractor.returns.map(material => `
                                        <tr>
                                            <td>${material.barcode}</td>
                                            <td>${material.name}</td>
                                            <td>${material.expected}</td>
                                            <td>${material.returned}</td>
                                            <td>${material.balance}</td>
                                            <td>${material.rate}</td>
                                            <td>${material.total_value}</td>
                                        </tr>
                                    `).join('')}
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
        loader.show();
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
}

const ssml = new SSML();