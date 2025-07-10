class Retail {
    interface = '/retail/api/'
    boldUploadScreen(){

        // get groups
        let groups = api.call('VIEW',{module:'bolt_group',data:{'pk':'*'}},'/retail/api/')
        if(groups['status_code'] === 200){
            let group_options = `<option value="0">NEW</option>`;
            let grps = groups['message'];
            for(let g = 0; g < grps.length; g++){
                let group = grps[g];
                group_options += `<option value="${group['pk']}">${group['name']}</option>`;

            }

            let form = `
                <a href="https://">Download Template</a> <br>
                <label for="group">GROUP</label>
                <select onchange="retail.uploadGroupSelection()" id="group" class="form-control rounded-0 mb-2">${group_options}</select>
                <label for="group_name">GROUP NAME</label>
                <input type="text" name="group_name" id="group_name" class="form-control mb-2 rounded-0">
                <label for="file">ITEMS FILE</label>
                <input type="file" name="" id="file" accept="text/csv" class="form-control mb-2 rounded-0">
                <button onclick="retail.boltUpload()" type="submit" class="btn btn-success w-100">PROCESS</button>
            `;
            amodal.setTitleText(`Upload Batch Files`);
            amodal.setBodyHtml(form);
            amodal.show()
        } else {
            kasa.error(groups['message']);
        }

    }

    uploadGroupSelection(){
        let text = $('#group').find(':selected').text();
        let grou_name = $('#group_name')
        if(text === 'NEW'){
            grou_name.val('');
            grou_name.prop('disabled',false);
            grou_name.prop('focused',true);
        } else {
            grou_name.prop('disabled',true);
            grou_name.prop('focused',false);
            grou_name.val(text)
        }

    }

    boltUpload(){

        if(anton.validateInputs(['group_name'])){
            let group_req = api.call(
            'PUT',{'module':'bolt_group',data:{name:$('#group_name').val()}},'/retail/api/'
            );

            let ms = ``

            if(group_req['status_code'] === 200){
                let group = group_req['message'];
                const file = document.getElementById('file').files[0];
                if(!file) {
                    alert('PLEASE SELECT A FILE');
                    return;
                }

                const reader = new FileReader();
                reader.onload = e => {

                    for(const line of e.target.result.split('\r')){
                        const this_line = line.split(',');
                        console.table(this_line)
                        // let barcode,name,price,spintex,nia,osu;
                        // barcode = this_line[0].replace('\n','');
                        // name = this_line[1];
                        // price = this_line[2];
                        // spintex = this_line[3];
                        // nia = this_line[4];
                        // osu = this_line[5];
                        let item_code = this_line[0]
                        // let price = this_line[1]
                        console.log(item_code)
                        // console.log(price)

                        let payload = {
                            'module':'bolt_item',
                            data:{
                                item_code:item_code
                            }
                        };

                        console.log(payload);

                        let prd_put = api.call('PUT',payload,'/retail/api/')
                        if(anton.IsRequest(prd_put)){

                        } else {
                            ms += `${item_code} - NOT ADDED <br>`
                        }

                        console.log(prd_put);
                    }
                }
                reader.readAsText(file)

                kasa.html(ms)
            } else {
                kasa.error(group_req['message'])
            }
        } else {
            kasa.error("ALL FIELDS ARE REQUIRED")
        }




    }

    checkPrices(){
       loader.show();
        let payload = {
            module:'price_change',
            data: {
                'send':'no'
            }
        };

        let request = api.call('VIEW',payload,'/retail/api/');

        if(anton.IsRequest(request)){
            let message = request['message'];
            console.table(message);
            let table = `
                <table class="table table-sm table-bordered">
                    <thead><tr><th>PART</th><th>CHANGES</th><th>FILE</th></tr></thead>
                    <tbody>
                        <tr><td>PRICE CHANGE</td><td>${message['price_change']['count']}</td><td><a href="/${message['price_change']['file']}"><i class="bx bx-download"></i></a></td></tr>
                        <tr><td>SPINTEX STOCK</td><td>${message['spintex_stock_change']['count']}</td><td><a href="/${message['spintex_stock_change']['file']}"><i class="bx bx-download"></i></a></td></tr>
                        <tr><td>NIA STOCK</td><td>${message['nia_stock_change_file']['count']}</td><td><a href="/${message['nia_stock_change_file']['file']}"><i class="bx bx-download"></i></a></td></tr>
                        <tr><td>OSU STOCK</td><td>${message['osu_stock_change_file']['count']}</td><td><a href="/${message['osu_stock_change_file']['file']}"><i class="bx bx-download"></i></a></td></tr>

                    </tbody>
                </table>
            `;

            amodal.setBodyHtml(table);
            amodal.setTitleText("PRICE AND STOCK UPDATE");
            loader.hide();
            amodal.show();
        } else {
            kasa.error(request['message'])
        }

    }

    markProducts(){
        let payload = {
            module:'price_update',
            data: {

            }
        };

        if(confirm("Are you Sure?")){
             let request = api.call('PATCH',payload,'/retail/api/');
            kasa.confirm(request['message'],1,'here')
        }

    }


    exportItems(pk) {
        $('#loader').show()

        let payload = {
            module:'export_items',
            data: {
                'format':'excel',
                key:pk
            }
        };
        let request = api.call('VIEW',payload,'/retail/api/');
        if(anton.IsRequest(request)){

            kasa.html(`<a href="/${request['message']}">Download File</a>`)

        } else {
            kasa.error(request['message'])
        }

        $('#loader').hide()
    }

    getProduct(item_code=''){
        let payload = {
            "module":"prod_master",
            "data":{
                "doc":"json",
                item_code:item_code
            }
        }

         return  api.call('VIEW',payload,'/retail/api/');
    }

    loadProducts(category='') {
        let payload = {
            "module":"prod_master",
            "data":{
                "doc":"json",

            }
        }

        let response = api.call('VIEW',payload,'/retail/api/');
        if(anton.IsRequest(response)){
            let products = response['message'];
            let tr = "";
            for (let p = 0; p < products.length; p++) {
                let product = products[p];
                console.table(product)
                let group,subgroup,barcode,name,price,is_on_bolt,sold;
                let item_code = product['item_code'];
                group = product['group_name'];
                subgroup = product['sub_group_name'];
                barcode = product['barcode'];
                name = product['name'];
                price = product['retail1'];
                is_on_bolt = product['is_on_bolt']
                sold = product['sold']
                if (sold == 'null'){
                    sold = 0
                }
                let bolt_hg = "fa fa-square-o border-success";
                if(is_on_bolt){
                    bolt_hg = 'fa fa-check text-success'
                }
                let r_id = `row_${item_code}`

                let dropa = "";

                dropa += `<a class="dropdown-item" href="javascript:void(0)" onclick="retail.changeProductCategory('${item_code}')">Change Group</a>`
                dropa += `<a class="dropdown-item" href="javascript:void(0)" onclick="retail.viewStock('${item_code}')">See Stock</a>`
                if(!is_on_bolt){
                    dropa += `<a class="dropdown-item" href="javascript:void(0)" onclick="retail.Mark2BoltScreen('${barcode}')">Mark For Bolt</a>`
                }


                let drop = `
                    <div class="dropdown">
                    <button class="btn btn-primary  dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <i class="fa fa-info"></i>
                    </button>
                    <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                    ${dropa}
                    </div>
                </div>
                `

                // tr += `
                //     <tr id="${r_id}"><td>${group}</td><td>${subgroup}</td><td>${barcode}</td><td>${name}</td><td>${price}</td><td>${is_on_bolt}</td></tr>
                // `;

                tr += `
                    <tr id="${r_id}"><td>${group}</td><td>${subgroup}</td><td>${barcode}</td><td>${name}</td><td>${price}</td><td>${sold}</td><td><i class="${bolt_hg}"></i></td><td>${drop}</td></tr>
                `;
            }

            let x =
                `<table class="table table-bordered table-stripped datatable table-bordered">
                    <thead class="thead-dark">
                    <tr>
                        <th>GROUP</th>
                        <th>SUB</th>
                        <th>BARCODE</th>
                        <th>NAME</th>
                        <th>PRICE</th>
                        <th title="Sold since 2024">SSOLD</th>
                        <th>SERVICES</th>
                        <th>ACTION</th>
                    </tr>
                    </thead>

                    <tbody id="assets_table">
                    ${tr}
                    </tbody>
                </table>`

            $('#result').html(x)
        } else {
            $('#pagebody').html(response['message'])
        }
    }

    export_retail_products(pk = '*') {
        $('#loader').show()

        let payload = {
            module:'retail_products',
            data: {
                'doc':'excel',
                product:pk
            }
        };
        let request = api.call('VIEW',payload,'/retail/api/');
        if(anton.IsRequest(request)){

            kasa.html(`<a href="/${request['message']}">Download File</a>`)

        } else {
            kasa.error(request['message'])
        }

        $('#loader').hide()
    }

    // STOCK SECTION
    retrieveSockFreezeScreen(){
        let form = ``;
        form += fom.text('entry','frozen entry in mycom',true)
        amodal.setTitleText("Retrieve Frozen")
        amodal.setBodyHtml(form);
        amodal.setFooterHtml(`<button onclick='retail.retrieveStock()' class='w-100 btn btn-success'>RETIRVE</button>`)
        amodal.show()
    }

    retrieveStock(){
        let ids = ['mypk','entry'];
        if(anton.validateInputs(ids)){
            let payload = {
                module:'retrieve_frozen_stock',
                data:anton.Inputs(ids)
            }

            let ret = api.call("PUT",payload,'/retail/api/');
            if(anton.IsRequest(ret)){
                console.table(ret)
            } else {
                kasa.response(ret)
            }
            
        } else {
            kasa.error("Fill All Fields")
        }
    }
    // END OF STOCK SECTION

    stockMonitoringFlag(pk = 0,flag=false){
        let payload = {
            module:'flag_stock_monitoring',
            data:{
                prod_pk:pk,
                flag:flag
            }
        }

        return api.call('PATCH',payload,'/retail/api/')
    }

    // enable stock
    enableMonitoring(pk){
        kasa.confirm(this.stockMonitoringFlag(pk,true)['message'],0,'here')
    }
    // disable
    disableMonitoring(pk){
        kasa.confirm(this.stockMonitoringFlag(pk,false)['message'],0,'here')
    }

    stockMonitoring(accuracy = '*'){
        let payload = {
            module:'see_stock_monitor',
            data:{
                "filter":accuracy
            }
        }

        return api.call('VIEW',payload,'/retail/api/')
    }

    retrieveStockMonitoring(accuracy='*') {
        let resp = this.stockMonitoring(accuracy);
        if(anton.IsRequest(resp)){
            let stocks = resp['message'];
            if(stocks.length > 0){
                let tr = ``;
                for(let s = 0; s < stocks.length; s++){
                    let stock = stocks[s];
                    tr += `
                        <tr><td>${stock['location']}</td><td>${stock['barcode']}</td><td>${stock['name']}</td><td>${stock['stock']}</td><td>${stock['valid']}</td></tr>
                    `
                }

                $('tbody').html(tr)
            } else {
                $('tbody').html(`<tr><td class="text-danger">NO RECORDS</td></tr>`)
            }
        } else {
            kasa.response(resp)
        }
    }

    materialRequestCompareScreen(){
        let form = '';
        form += fom.text('mr_no',"",true)
        form += fom.select('doc',`
            <option value="" selected disabled>Select Document</option>
            <option value="JSON">VIEW</option>
            <option value="excel">Excel</option>
        `,"",true)
        amodal.setTitleText("Material Request Check")
        amodal.setBodyHtml(form)
        amodal.setFooterHtml(`<button onclick="retail.materialRequestCompare()" class="btn btn-success w-100">CHECK</button>`)
        amodal.show()
    }

    materialRequestCompare() {
        let fields = ['doc','mr_no'];
        if(anton.validateInputs(fields)){
            let dt = anton.Inputs(fields);
            console.table(dt)
            let payload = {
                module:'mr_check',
                data:anton.Inputs(fields)
            };
            loader.show();
            amodal.hide();
            api.v2('VIEW',payload,'/retail/api/').then(view => {

                if(anton.IsRequest(view)){
                let message = view['message'];

                let doc_type = dt['doc'];
                let mr = $('#mr_no').val()
                if(doc_type === 'excel'){
                    kasa.html(`<a href="/${message}">DOWNLOAD FILE</a>`)
                }
                else if (doc_type === 'JSON'){
                    console.table(message)
                    let header,transactions;
                    header = message['header'];
                    transactions = message['transactions'];

                    console.table(message)

                    let rep_header = [
                        "ITEM CODE",
                        "NAME",
                        "REQ. QTY",
                        "LATEST TRANSFER",
                        "TRAN QTY",
                        "SOLD AFTER",
                        "SOLD PERCENTAGE",
                        "STOCK HEALTH"
                    ]
                    // set report table
                    let rows = ""
                    for(let r = 0; r < transactions.length; r++){
                        let row = transactions[r]
                        rows += `
                            <tr>
                                <td>${row['item_code']}</td>
                                <td>${row['name']}</td>
                                <td>${row['request_qty']}</td>
                                <td><p>${row['last_tran_entry']}</p><p>${row['last_tran_entry']}</p></td>
                                <td>${row['last_tran_qty']}</td>
                                <td>${row['sold_qty']}</td>
                                <td>${row['percentage_sold']}</td>
                                <td>${row['health']}</td>
                            </tr>
                        `
                    }

                    console.log("Header here")
                    console.table(rep_header)
                    console.log("Header here")
                    reports.render(rep_header,rows,`MATERIAL REQUEST CHECK FOR ${mr}`)
                    amodal.hide()
                }
                else {
                    kasa.info(`Invalid Render Configuration ${doc_type}`)
                }
            }
            else {
                kasa.response(view)
            }
            }).catch(err => {
                kasa.response(err)
            }).finally(() => {
                loader.hide();
            })

        } else {
            kasa.error("Invalid Field")
        }
    }

    stockReportScreen(){
        let loc_payload = {
            module:'location_master',
            data:{}
        }
        let locations = api.call('VIEW',loc_payload,'/retail/api/')
        let locs = locations.message
        let l_optons = ""
        for(let l = 0; l < locs.length; l++){
            let lc = locs[l]
            l_optons += `<option value="${lc['code']}">${lc['code']} - ${lc['name']}</option>`
        }
        let form = '';
        form += fom.select('loc_code',`
            <option value="" selected disabled>Select Location</option>
            <option value="*" selected>All</option>
            ${l_optons}
        `,"",true)
        form += fom.select('filter',`
            <option value="" selected disabled>Select Filter</option>
            <option value="positive">POSITIVE</option>
            <option value="negative">NEGATIVE</option>
            <option value="neutral">NEUTRAL</option>
        `,"",true)

        form += fom.select('doc',`
            <option value="" selected disabled>Select Document</option>
            <option value="json">VIEW</option>
            <option value="excel">Excel</option>
        `,"",true)
        amodal.setTitleText("Stock Check")
        amodal.setBodyHtml(`REPORT DISABLED FOR NOW`)
        //amodal.setFooterHtml(`<button onclick="retail.stockReport()" class="btn btn-success w-100">CHECK</button>`)
        amodal.show()
    }

    stockReport() {

        let fields = ['doc','filter']
        if(anton.validateInputs(fields)){
            let data = anton.Inputs(fields)
            let payload = {
                module:'see_stock_monitor',
                data:data
            }
            loader.show()
            api.v2('VIEW',payload,'/retail/api/').then(generate => {
                console.log('OKAY')
                amodal.hide()

                console.table(generate)
                if(anton.IsRequest(generate)){
                    let response = generate['message'];
                    if (data['doc'] === 'excel'){
                        kasa.html(`<a href="/${response}">DOWNLOAD REPORT</a>`)
                    } else if (data['doc']){
                        let rows = ''
                        for(let r = 0; r < response.length; r++){
                            let row = response[r]
                            rows += `
                                <tr><td>${row['loc_code']}</td><td>${row['loc_name']}</td><td>${row['barcode']}</td><td>${row['item_name']}</td><td>${row['stock']}</td></tr>
                            `
                        }

                        reports.render(['LOC_CODE',"LOC_NAME","BARCODE","NAME","STOCK"],rows,`STOCK REPORT FOR ${data['filter']} ITEMS`)
                    } else {
                        kasa.error("Unknown Document Rendering Format")
                    }
                } else {
                    kasa.response(generate)
                }
            }).catch(err => {
                kasa.response(err)
            }).finally(() => {
                loader.hide()
            })


        } else {
            kasa.error("Invalid Form")
        }
    }

    getRetailDocuments(start_date,end_date){
        let payload = {
            module:'documents',
            data:{
                start_date:start_date,
                end_date:end_date
            }
        }

        return api.call('VIEW',payload,this.interface)
    }

    loadRetailDocuments(start_date,end_date){
        let documents_response = this.getRetailDocuments(start_date,end_date);
        if(anton.IsRequest(documents_response)){
            let documents = documents_response.message;
            let tr = "";
            for(let m = 0; m < documents.length; m++){
                let row = documents[m]
                tr += `
                <tr>
                                <td>${row['document']}</td>
                                <td>
                                    <span title="Total Documents" class="badge bg-info">${row['total_entries']}</span>
                                    <span title="Posted Documents" class="badge bg-success">${row['posted']}</span>
                                    <span title="Pending Documents" class="badge bg-warning">${row['not_posted']}</span>
                                    <span title="Deleted Documents" class="badge bg-danger">${row['deleted']}</span>
                                </td>
                                <td>${row['total_value']}</td>
                            </tr>
                `
            }

            $('#doc_table').html(tr)
        } else {
            kasa.response(documents_response)
        }
    }

    sales_graph_week() {
        let payload = {
            module:'sales_graph_week',
            data:{}
        }
        return api.call('VIEW',payload,this.interface);
    }

    bolt_graph_week() {
        let payload = {
            module:'bolt_graph_week',
            data:{}
        }
        return api.call('VIEW',payload,this.interface);
    }

    checkExpiryScreen(){
        let form = ``;
        form = `
            <div class="d-flex flex-wrap w-100 justify-content-center">
                
                <button id="by_days" class="btn btn-lg btn-info ms-2 p-5 w-30" style="height: 75px">By Days</button>
                <button id="by_month_target" class="btn btn-lg btn-info ms-2 p-5 w-30" style="height: 75px">Target Month</button>
            
            </div>
        `
        amodal.setTitleText("Check Expiry")
        amodal.setBodyHtml(form);
        //
        amodal.show();
        $('#by_days').click(function (){
            let by_days_form = ""

                by_days_form += fom.text('days','Days before expiry',true)
                by_days_form += fom.select('remove_flagged',`<option value="YES">YES</option><option value="NO">NO</option>`,'',true)
                by_days_form += fom.select('document',`<option value="json">VIEW</option><option value="excel">Excel</option>`,'',true)
                amodal.setTitleText("Expiry Report")
                amodal.setBodyHtml(by_days_form);
            amodal.setFooterHtml(`<button onclick="retail.RetrieveExpiry()" class="btn btn-success w-100 rounded_c">RETRIEVE</button>`);
        })
        
        $('#by_month_target').click(function (){
            let by_month_form = ""

            by_month_form += fom.select('month', `
                <option value="01">January</option>
                <option value="02">February</option>
                <option value="03">March</option>
                <option value="04">April</option>
                <option value="05">May</option>
                <option value="06">June</option>
                <option value="07">July</option>
                <option value="08">August</option>
                <option value="09">September</option>
                <option value="10">October</option>
                <option value="11">November</option>
                <option value="12">December</option>
            `, 'Select Month', true)

            amodal.setBodyHtml(by_month_form)
            amodal.setTitleText("Expiry Report By Month")
            amodal.setFooterHtml(`<button class="btn btn-info" id="retrieve_by_month">Retrieve</button>`)

            $('#retrieve_by_month').click(function (){
                loader.show()
                let month = $('#month').val()
                let payload = {
                    module:'expiry_by_month',
                    data:{

                        "month":month,
                        "document":$('#document').val(),
                    }
                }

                api.v2('VIEW',payload,'/retail/api/').then(result => {
                    if(anton.IsRequest(result)){

                        console.table(result)
                        let doc = $('#document').val();
                        if(true){
                            let header = ['EXPIRY DATE','GRN','BARCODE','ITEM CODE','ITEM NAME','WAREHOUSE',"SPINTEX",'NIA',"OSU",'STOCK']
                            let tr = '';
                            let res = result.message;
                            let dt = []
                            dt.push(['BARCODE','NAME','GRN','EXPIRY DATE','DAYS TO EXPIRY','WAREHOUSE',"SPINTEX",'NIA',"OSU",'KITCHEN'])

                            for(let m = 0; m < res.length; m++){
                                let row = res[m];
                                console.table(row)
                                tr += `<tr>
                                            <td>${row.barcode}</td>
                                            <td>${row.item_des}</td>
                                            <td>${row.entry_no}</td>
                                            <td>${row.expiry_date}</td>
                                            <td>${row.warehouse}</td>
                                            <td>${row.spintex_stock}</td>
                                            <td>${row.nia_stock}</td>
                                            <td>${row.osu_stock}</td>
                                            <td>${row.kitchen_stock}</td>
                                      </tr>`
                                dt.push([row.barcode,row.item_des,row.entry_no,row.expiry_date,row.days_to_expire,row.warehouse,row.spintex_stock,row.nia_stock,row.osu_stock,row.kitchen_stock])
                            }
                            header = ['BARCODE','NAME','GRN','EXPIRY DATE','WAREHOUSE',"SPINTEX",'NIA',"OSU",'KITCHEN']
                            reports.render(header,tr,`EXPIRY REPORT <button id="dnlod">EXPORT</button>`)
                            amodal.hide()
                            loader.hide()
                            $('#dnlod').click(function (){


                                anton.downloadCSV('expiry.csv',anton.convertToCSV(dt))
                            })


                        }
                    } else {
                        kasa.response(result)
                        loader.hide()
                    }
                }).catch(err => {kasa.error(error);loader.hide()})
            })

        })
    }


    RetrieveExpiry() {
        let ids = ['days','remove_flagged','document'];
        if(anton.validateInputs(ids)) {
            let payload = {
                module:"expiry",
                data:anton.Inputs(ids)
            }

            loader.show()
            api.v2('VIEW',payload,this.interface)
                .then(result => {
                    if(anton.IsRequest(result)){
                        let doc = $('#document').val();
                        if(doc === 'json'){
                            let header = ['EXPIRY DATE','GRN','BARCODE','ITEM CODE','DAYS RO EXPIRY','ITEM NAME','WAREHOUSE',"SPINTEX",'NIA',"OSU",'STOCK']
                            let tr = '';
                            let res = result.message;
                            for(let m = 0; m < res.length; m++){
                                let row = res[m];
                                tr += `
                                    <tr>
                                        <td>${row['expiry_date']}</td>
                                        <td>${row['grn']}</td>
                                        <td>${row['barcode']}</td>
                                        <td>${row['item_code']}</td>
                                        <td>${row['item_des']}</td>
                                        <td>${row['warehouse_stock']}</td>
                                        <td>${row['spintex_stock']}</td>
                                        <td>${row['osu_stock']}</td>
                                        <td>${row['nia_stock']}</td>
                                        <td>${row['stock']['total']}</td>
                                    </tr>
                                `
                            }
                            console.table(header)
                            reports.render(header,tr,'EXPIRY REPORT')
                            amodal.hide()
                        }

                        if(doc === 'excel'){
                            kasa.html(`<a href="/${result.message}">DOWNLOAD FILE</a>`)
                        }
                    } else {
                        kasa.response(result);
                    }

                })
                .catch(err => {
                    kasa.response(err)
                })
                .finally(() => {
                    loader.hide()
                })

        } else {
            kasa.error("Invalid Form")
        }
    }

    addButchMonitorScreen() {
        let loc_payload = {
            module:'location_master',
            data:{}
        }
        // let locations = api.call('VIEW',loc_payload,'/retail/api/')
        // let locs = locations.message
        // let l_optons = ""
        // for(let l = 0; l < locs.length; l++){
        //     let lc = locs[l]
        //     l_optons += `<option value="${lc['pk']}">${lc['code']} - ${lc['name']}</option>`
        // }
        let form   = '';
        // form += fom.select('location',`${l_optons}`,'',true)
        form += fom.text('barcode','',true)
        // form += fom.text('quantity','',true)

        amodal.setBodyHtml(form);
        amodal.show();
        amodal.setTitleText("Add Butchry Sale")
        amodal.setFooterHtml(`<button class="btn btn-success w-100" onclick="retail.addButchMon()">ADD</button>`)
    }

    addButchMon() {
        let ids = ['barcode'];
        if(anton.validateInputs(ids)){
            let payload = {
                module:'mark_butch',
                data:anton.Inputs(ids)
            }

            let send = api.call('PUT',payload,'/retail/api/')
            kasa.confirm(send['message'],1,'here')
        }
    }

    seeStockToSend() {


        let form = fom.locations('code')
        form += fom.select('view',`<option value="json">VIEW</option><option value="excel">Download</option>`,'',true)
        form += fom.select('ripe',`<option value="ALL">ALL</option><option value="YES">YES</option><option value="NO">NO</option>`,'show qualified to go only',true)
        amodal.setBodyHtml(form)
        amodal.setTitleText("Retrieve Stock TO Send")
        amodal.setFooterHtml(`<button onclick="retail.StockToSend()" class="btn btn-info w-100">RETRIEVE</button>`)
        amodal.show();
    }

    async StockToSend() {
        let id = ['location','ripe','view'];
        if(anton.validateInputs(id)){
            let payload = {
                module:'analysis_for_transfer',
                data:anton.Inputs(id)
            }



            console.table(payload)

            let ripe = $('#ripe').val()
            await api.v2('VIEW',payload,'/retail/api/').then(response => {
                if(anton.IsRequest(response)){
                let message = response.message
                let rows = ``;
                let v = $('#view').val()

                if(v === 'excel'){
                    kasa.html(`<a href="/${message}">DOWNLOAD</a>`)
                } else {
                    for (let i = 0; i < message.length; i++) {
                        let row = message[i];
                        console.table(row)
                        let text = ''
                        // if(row['health']){
                        //     text = 'bg-info'
                        // }

                        let line = i + 1;


                        rows += `
                            <tr class="${text}">
                                <td>${line}<input type="hidden" id="sold_${line}" value="${row['sold_qty']}"> </td>
                                <td><input type="checkbox" id="sel_${line}"></td>
                                <td>${row['location']}</td>
                                <td id="barcode_${line}">${row['barcode']}</td>
                                <td>${row['name']}</td>
                                <td>${row['last_transfer']} <br>${row['last_transfer_date']}</td>
                                <td>${row['last_transfer_quantity']}</td>
                                <td>${row['sold_qty']} (${row['percentage_sold']})</td>
                                
                                <td>${row['stock']}</td>
                            </tr>
                        `

                    }

                    $('#items').html(rows)
                    $('#tabs').DataTable()
                }

            } else {
                    kasa.response(response)
                }
                console.table(response)
            }).catch(error => {kasa.info(error)})

        }
    }

    downloadMaterialRequest() {
        // Get the table body by ID
        var tableBody = document.getElementById('items');

        // Find all checkbox elements within the table body
        var checkboxes = tableBody.querySelectorAll('input[type="checkbox"]');
        let l_arr = []
        // Loop through all checkboxes
        checkboxes.forEach(function(checkbox) {
            var checkboxId = checkbox.id; // Get the ID of the checkbox
            let line = checkboxId.split('_')[1];

            if (checkbox.checked) {
                console.log(line);
                let barcode_id = `#barcode_${line}`
                let itemcode_id = `#itemcode_${line}`;
                let sold_id = `#sold_${line}`;

                let barcode = $(barcode_id).text()
                let itemcode = $(itemcode_id).text()
                let sold = parseFloat($(sold_id).val());
                let to_send = parseInt(sold * 1.25); //25%


                let arr = [barcode, itemcode,to_send]
                l_arr.push(arr)
                console.table(arr)
                console.log('Checkbox with ID ' + checkboxId + ' is checked');
            }
        });

        let csv = anton.convertToCSV(l_arr)
        anton.downloadCSV('mr.csv',csv)

    }

    loadPriceChange(from=today,to=today,doc='json'){

            let price_change = this.getPriceChange(from,to,doc)
            console.table(price_change)
            if(anton.IsRequest(price_change)){
                let price_list = price_change.message

                let tr = "";
                if (doc === 'json'){
                    for(let p = 0; p < price_list.length; p++){
                    let r = price_list[p];
                    let sn = p+1;
                    let text = '';
                    if(r['margin'].includes('(')){
                        text = 'text-danger'
                    }
                    tr +=  `
                        <tr class="${text}">
                            <td>${sn}</td>
                            <td>${r['barcode']}</td>
                            <td>${r['name']}</td>
                            <td>${r['old_price']}</td>
                            <td>${r['new_price']}</td>
                            <td>${r['margin']}</td>
                            <td>${r['by']}</td>
                            <td>${r['date']}</td>
                        </tr>
                    `;
                }

                    $('#items').html(tr)
                } else if(doc === 'excel'){
                    anton.viewFile(`/${price_list}`)
                }

                if(doc === 'excel'){
                    kasa.html(`<a href="/${price_list}">DOWNLOAD</a>`)
                }
                console.table(doc)



            } else {
                kasa.response(price_change)
            }
    }

    retrievePriceChange() {
        let inp = ['from','to','doc'];
        let from = $('#from').val();
        let to = $('#to').val()
        let doc = $('#doc').val();
        if(anton.validateInputs(inp)){
            this.loadPriceChange(from,to,doc)
        } else {
            kasa.error('Invalid Form')
        }

    }

    getPriceChange(from=today, to=today,doc='json') {
        let payload = {
            module:'price_change',
            data:{
                from:from,
                to:to,
                'doc':doc
            }
        }

        return api.call('VIEW',payload,'/retail/api/')
    }

    retrievePriceChangeScreen() {
        let form = "";
        form += fom.date('from','',true)
        form += fom.date('to','',true)
        form += fom.selectv2('doc',[
            {
                val:'json',
                desc:'Preview',
            },{
                val:'excel',
                desc:'Excel',
            }
        ],'',true)

        amodal.setTitleText("Retrieve Price Change")
        amodal.setBodyHtml(form)
        amodal.setFooterHtml(`<button class="btn btn-info w-100" onclick="retail.retrievePriceChange();amodal.hide()">Retrieve</button>`)
        amodal.show()
    }

    loadSales(limit = 10) {
        let sales = this.getSales(limit)
        let tr = "";
        if(anton.IsRequest(sales)){
            let message = sales.message
            let max = 50;
            if (message.length < 50){
                max = message.length;
            }


            for (let i = 0; i < max; i++) {
                let sale = message[i];
                tr += `
                    <tr>
                                <td>${sale['location']}</td>
                                <td>${sale['time']}</td>
                                <td>${sale['barcode']}</td>
                                <td>${sale['name']}</td>
                                <td>${sale['quantity']}</td>
                                <td>${sale['price']}</td>
                                <td>${sale['total']}</td>

                            </tr>
                `;
            }
        } else {
            tr = `<tr><td colspan="7" class="text-dan">${sales.message}</td></tr>`
        }

        $('#sales').html(tr)
    }

    getSales(limit = 10) {
        let payload = {
            module:'transactions_today',
            data:{
                limit:limit
            }
        }

        return api.call('VIEW',payload,'/retail/api/')
    }

    changeProductCategory(item_code) {
        let form = ``;

        let gp_opt = []
        let groups = this.getProdGroup('*')
        let pd = this.getProduct(item_code).message[0];

        console.log("products")

        console.log("products")
        if(anton.IsRequest(groups)){
            let gps = groups.message
            for (let g = 0; g < gps.length; g++){
                let gp = gps[g];
                let ob = {
                    val:gp.code,
                    desc:gp.name,
                }

                gp_opt.push(ob)
            }

            form += fom.text('item_code','',true)
            form += fom.text('barcode','',true)
            form += fom.text('name','',true)
            form += fom.selectv2('new_group',gp_opt,'',true)
            form += fom.selectv2('new_sub_group',[],'',true)
            form += fom.selectv2('new_sub_subgroup',[],'',true)


            form += `<hr><button onclick="retail.changeGroup()" class="btn btn-warning w-100">CHANGE</button>`

            amodal.setBodyHtml(form)
            amodal.setTitleText("Change Product Code")
            amodal.show()


            console.table(pd)
            $('#item_code').prop('disabled',true)
            $('#barcode').prop('disabled',true)
            $('#name').prop('disabled',true)

            $('#item_code').val(pd['item_code'])
            $('#barcode').val(pd['barcode'])
            $('#name').val(pd['name'])

        } else {
            kasa.response(groups)
        }

    }

    getProdGroup(s) {
        let payload = {
            "module":"group_master",
            "data":{

            }
        }
        return api.call('VIEW',payload,'/retail/api/')
    }

    getProductSubGroups(group_id) {
        let payload = {
            "module":"sub_group_master",
            "data":{
                group:group_id
            }
        }
        return api.call('VIEW',payload,'/retail/api/')
    }

    getProductSubSubGroups(group_id,sub_group_id) {
        let payload = {
            "module":"sub_subgroup_master",
            "data":{
                group:group_id,
                sub_group_id:sub_group_id
            }
        }
        return api.call('VIEW',payload,'/retail/api/')
    }

    changeGroup() {
        let ids = ['item_code','barcode','name','new_group','new_sub_group','mypk']
        if(anton.validateInputs(ids)){
            let payload = {
                module:'change_group',
                data:anton.Inputs(ids)
            }

            let item_code = payload['data']['item_code'];

            payload.data['new_sub_subgroup'] = $('#new_sub_subgroup').val()

            // amodal.setFooterHtml(`<button class="w-100 btn btn-success w-100" onclick="amodal.hide()">OK</button>`)
            // amodal.setBodyHtml(api.call('PATCH',payload,'/retail/api/')['message'])
            kasa.info(api.call('PATCH',payload,'/retail/api/')['message'])
            let r_id = `#row_${item_code}`
            $(r_id).remove();
            amodal.hide()
            // retail.loadProducts()
            // kasa.confirm(api.call('PATCH',payload,'/retail/api/')['message'],1,'here')
        } else {
            kasa.error("Invalid Form")
        }


    }

    newSampleScreen() {
        let loc_payload = {
            module:'location_master',
            data:{}
        }
        let locations = api.call('VIEW',loc_payload,'/retail/api/')
        if(anton.IsRequest(locations)){
            let loc = locations.message
            let tr = [];
            for (let i = 0; i < loc.length; i++) {
                let lc = loc[i];
                let tp = lc['type'];
                if(tp === 'retail'){
                    console.table(lc)
                    let obj = {
                        val:lc['pk'],
                        desc:lc['name']
                    }

                    tr.push(obj)
                }

            }

            let form = "";
            form += fom.selectv2('location',tr,'',true)
            form += fom.text('bill_ref','',true)
            form += `<hr><button class="btn btn-success w-100" onclick="retail.saveSample()">SAVE</button>`

            amodal.setBodyHtml(form)
            amodal.setTitleText("New Sample")
            amodal.show()
        } else {
            kasa.response(locations)
        }
    }

    saveSample() {
        let ids = ['location','bill_ref','mypk'];
        if(anton.validateInputs(ids)){
             let payload = {
                 module:'sample',
                 data:anton.Inputs(ids)
             }

             kasa.confirm(api.call('PUT',payload,'/retail/api/').message,1,'here')

        } else {
            kasa.error("Invalid Form Field")
        }
    }

    getSamples(pk='*'){
        let payload = {
            module:'sample',
            data:{
                pk:pk
            }
        }

        return api.call('VIEW',payload,'/retail/api/')
    }

    loadSamples(pk='*'){
        let samples = this.getSamples(pk);
         let table = "";
        if(anton.IsRequest(samples)){
            let sams = samples.message
            let tr = "";
            for(let i = 0; i < sams.length; i++) {
                let samp = sams[i]
                tr += `
                    <tr>
                        <td>${samp['location']['name']}</td>
                        <td>${samp['mech_no']}</td>
                        <td>
                            ${samp['bill_no']} : ${samp['ref']}<br>${samp['bill_refund_no']} : ${samp['bill_refund_ref']}
                        </td>
                        <td>${samp['owner']}</td>
                        <td>${samp['value']}</td>
                        <td>${samp['date']}</td>
                        <td>${samp['ad']}</td>
                        <td><span class="badge bg-info">pending</span></td>
                        <td>
                            
                            <div class="dropdown dropleft">
                                <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    
                                </button>
                                <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                                    <a onclick="retail.adjustSampleScreen('${samp['pk']}')" class="dropdown-item text-primary" href="javascript:void(0)">Adjustemtn</a>
                                    <a onclick="retail.refundSampleScreen('${samp['pk']}')" class="dropdown-item text-info" href="javascript:void(0)">Refund</a>
                                    <a onclick="retail.deleteSample('${samp['pk']}')"  class="dropdown-item text-danger" href="javascript:void(0)">Delete</a>
                                </div>
                            </div>
                        
                        </td>
                    </tr>
                `
            }

            table = `<table class="table table-stripped datatable table-bordered">
                <thead>
                    <tr>
                        <th>LOCATION</th>
                        <th>MECH NO</th>
                        <th>BILL NO</th>
                        <th>USER</th>
                        <th>VALUE</th>
                        <th>DATE</th>
                        <th>AD</th>
                        <th>STATUS</th>
                        <th>ACTION</th>
                    </tr>
                </thead>
                <tbody>
                    ${tr}
                </tbody>
            </table>`


        } else {
            kasa.response(samples)
        }

        $('#samp_card').html(table)
    }

    adjustSampleScreen(pk) {
        let form = `<input type="hidden" id="sam_pk" value="${pk}">`
        form += fom.text('adjustment_entry','',true)
        form += `<hr><button onclick="retail.adjustSample()" class="btn btn-success">ADJUST</button>`

        amodal.setBodyHtml(form)
        amodal.setTitleText('Adjust Sample')
        amodal.show()
    }

    adjustSample() {
        let ids = ['sam_pk','adjustment_entry']
        if(anton.validateInputs(ids)){
            let payload = {
                module:'sample_adjust',
                data:anton.Inputs(ids)
            }

            kasa.confirm(api.call('PATCH',payload,'/retail/api/').message,1,'here')
        }
    }

    refundSampleScreen(pk) {
        let form = `<input type="hidden" id="sam_pk" value="${pk}">`
        form += fom.text('refund_entry','',true)
        form += `<hr><button onclick="retail.refundSample()" class="btn btn-success">REFUND</button>`

        amodal.setBodyHtml(form)
        amodal.setTitleText('Refund Sample')
        amodal.show()
    }

    refundSample() {
        let ids = ['sam_pk','refund_entry']
        if(anton.validateInputs(ids)){
            let payload = {
                module:'sample_refund',
                data:anton.Inputs(ids)
            }

            kasa.confirm(api.call('PATCH',payload,'/retail/api/').message,1,'here')
        }
    }

    deleteSample(pk) {
        let payload = {
            module:'sample_delete',
            data:{
                sam_pk:pk
            }
        }

        kasa.confirm(api.call('PATCH',payload,'/retail/api/').message,1,'here')
    }

    StockScreen(){
        let loc_payload = {
            module:'location_master',
            data:{}
        }
        let locations = api.call('VIEW',loc_payload,'/retail/api/')
        let locs = locations.message
        let l_optons = ""
        for(let l = 0; l < locs.length; l++){
            let lc = locs[l]
            l_optons += `<option value="${lc['code']}">${lc['code']} - ${lc['name']}</option>`
        }
        let form = '';
        let loc =  fom.select('loc_id',`
            <option value="" selected disabled>Select Location</option>
            <option value="*" selected>All</option>
            ${l_optons}
        `,"",true)

        let stat = fom.select('status',`
            
            <option value="*" selected>All</option>
            <option value="-">Negative</option>
            <option value="+">Positive</option>
        `,"",true);

        let catpl = {
            "module":"group_master",
            "data":{

            }
        }

        let cx = "";
        let cats = api.call('VIEW',catpl,'/retail/api/')['message'];
        for(let c = 0; c < cats.length; c++){
            const ct = cats[c];
            cx += `<option value="${ct['code']}">${ct['name']}</option>`
        }

        let cat =  fom.select('category',`
            <option value="" disabled>Select Category</option>
            
            ${cx}
        `,"",true)

        let doc = fom.select('export',`
            
            
            <option value="json">Preview</option>
            <option value="excel">Excel</option>
        `,"",true);

        let ht = `<div class="container"><div class="row"><div class="col-sm-6">${loc}</div><div class="col-sm-6">${stat}</div><div class="col-sm-6">${cat}</div><div class="col-sm-6">${doc}</div></div></div>`

        amodal.setBodyHtml(ht)
        amodal.setTitleText("Get Stock")
        amodal.setFooterHtml(`<button onclick="retail.seeStock()" class="btn btn-info w-100">GENERATE</button>`)
        amodal.show()
    }

    async seeStock() {
        let ids = ['export','category','loc_id','status'];
        let inps = anton.Inputs(ids);
        let payload = {
            module:'detailed_stock',
            data:anton.Inputs(ids)
        }

        loader.show()
        amodal.hide()
        api.v2('VIEW',payload,'/retail/api/').then(res => {
            console.table(res)
            if(inps['export'] === 'excel'){
                anton.viewFile(`/${res['message']}`)
            } else if(inps['export'] === 'json'){
                let tr = "";
                let message = res['message'];
                console.table(message)
                for(let i = 0; i < message.length; i++){
                    let r = message[i];
                    let barcode, name,quantity;
                    barcode = r[0];
                    name = r[1];
                    quantity = r[2];
                    tr += `
                        <tr>
                            <td>${barcode}</td>
                            <td>${name}</td>
                            <td>${quantity}</td>
                        </tr>
                    `;

                }

                reports.render(['BARCODE',"NAME","QUANTITY"],tr,`Stock Report for ${inps['loc_id']} adn group ${inps['category']} with status ${inps['status']}`)
            }
            else {
                kasa.info('configure preview')
            }
        }).catch(err => {
            kasa.response(err)
        }).finally(() => {
            loader.hide()

        })



    }

    newBoltGroupScrren() {
        let form = "";
        form += fom.text('name','',true)

        let entites = api.call('VIEW',{
            module:'entity_type',data:{}
        },'/adapi/')

        console.table(entites)

        let arr = [];
        for(let e = 0; e < entites.message.length; e++){
            let ent = entites.message[e];
            arr.push({
                val:ent['pk'],
                desc:ent['name']
            })
        }

        form += fom.selectv2('entity',arr,'',true)

        amodal.setBodyHtml(form)
        amodal.setTitleText('NEW BOLT GROUP')
        amodal.setFooterHtml(`<button onclick="retail.saveBoltCategory()" class="btn btn-success w-100">SAVE</button>`)
        amodal.show()
    }

    saveBoltCategory() {
        let ids = ['mypk','name','entity']
        if(anton.validateInputs(ids)){
            let payload = {
                module:'bolt_group',
                data:anton.Inputs(ids)
            }

            kasa.confirm(api.call('PUT',payload,'/retail/api/')['message'],1,'here')

        } else {
            kasa.error("Invalid Form")
        }
    }

    deleteBoltGroup(id) {
        let payload = {
            module:'bolt_group',
            data:{pk:id}
        }

        kasa.confirm(api.call("DELETE",payload,'/retail/api/')['message'],1,'here')
    }

    addProduct2groupScreen(group_pk) {
        // get all products
        let products = retail.getProduct('');
        if(anton.IsRequest(products)){
            let prods = products.message;
            console.table(prods)
        } else {
            kasa.response(products)
        }

    }

    getBoltGroups(pk='*',entity='*'){
        let payload = {
            module:'bolt_group',
            data:{
                pk:"*"
            }
        }

        return api.call('VIEW', payload, '/retail/api/')
    }

    getBoltSubGroups(pk,entity='*'){
        let payload = {
                module:'bolt_sub_group',
                data:{
                    key:pk,
                    entity:entity
                }
        }
        console.table(payload)

        return api.call('VIEW', payload, '/retail/api/')
    }

    Mark2BoltScreen(barcode) {
        let payload = {
            module:'bolt_group',
            data:{
                pk:"*",
                entity:$('#entity').val(),
            }
        }

        let groups = api.call('VIEW',payload,'/retail/api/')['message']
        let product = retail.getProduct(barcode)['message'][0]['name']


        let gob = [];
        for (let g = 0; g < groups.length; g++){
            let grp = groups[g];
            console.table(grp)
            let x = {
                val:grp['pk'],
                desc:grp['name']
            }

            gob.push(x)
        }


        let image_form = `
            <form action="/retail/bolt/upload_image/" id="bolt_img_form" method="post" enctype="multipart/form-data" class="w-100"><input name="image" id="bolt_image_input" type="file" accept="image/*"><input type="text" class="form-control rounded-0" readonly value="${barcode}" name="barcode"></form><div><img src="" style="width: 200px" alt="" class="img-fluid" id="bolt_img"></div>
        `;

        let form = "";

       let category = fom.selectv2('category',gob,'',true)
        let sub_category = fom.selectv2('sub_category',[],'',true)
        let name_frm = `<input class="form-control rounded-0" readonly value="${product}">`
        let descriptio = fom.textarea('description',2,true)
        form += `
            <div class="row"><div class="col-sm-6">${image_form}</div><div class="col-sm-6">${name_frm}${category}${sub_category}${descriptio}</div></div>
        `




        amodal.setBodyHtml(form);
        amodal.setTitleText("Mark For Bolt Sync")
        amodal.setFooterHtml(`<button onclick="retail.mark2Bolt('${barcode}')" class="btn btn-success w-100">MARK</button>`)
        amodal.setSize('L')
        amodal.show()

        $('#category').change(function(){
            // load sub
            console.log("hello")
            let payload = {
                module:'bolt_sub_group',
                data:{
                    key:$('#category').val(),
                    entity:$('#entity').val()
                }
            }

            let sub_groups = api.call('VIEW',payload,'/retail/api/')['message']


            let sub_gob ='';
            for (let g = 0; g < sub_groups.length; g++){
                let grp = sub_groups[g];
                sub_gob += `<option value="${grp['pk']}">${grp['name']}</option>`
            }

            $('#sub_category').html(sub_gob)
        });



    }

    mark2Bolt(barcode) {
        let ids = ['category','sub_category'];
        if(anton.validateInputs(ids) && anton.isInputFiles('bolt_image_input')){
            let payload = {
                module:'mark2bolt',
                data:anton.Inputs(ids)
            }

            payload['data']['menu'] = $('#entity').val();

            payload.data['description'] = $('#description').val();

            payload['data']['barcode'] = barcode;

            let mark = api.call('PATCH',payload,'/retail/api/');
            if(anton.IsRequest(mark)){
                $('#bolt_img_form').submit()
                this.changeShelfScreen(barcode)
            } else {
                kasa.response(mark)
            }
            // kasa.confirm(api.call('PATCH',payload,'/retail/api/')['message'],1,'here')

        } else {
            kasa.error("Invalid Form")
        }
    }

    sync2bolt() {
        let payload = {
            "module":"send2bolt",
            "data":{}
        }

        let call = api.call("VIEW",payload,'/retail/api/')
        if(anton.IsRequest(call)){
            let files = call['message'];
            let images,products,prices,stock;
            images = files['images']
            products = files['csv'];
            prices = files['prices']
            stock = files['stock']

            let html = `
                <table class="table table-striped table-bordered"><thead><tr><th>FILE</th><th>ACTION</th></tr></thead>
                   <tbody>
                   <tr><td>IMAGES</td><td><a href="/${images}"><i class="fa fa-download"></i></a></td></tr>
                   <tr><td>PRODUCTS</td><td><a href="/${products}"><i class="fa fa-download"></i></a></td></tr>
                   <tr><td>PRICES</td><td><a href="/${prices}"><i class="fa fa-download"></i></a></td></tr>
                   <tr><td>STOCK</td><td>
                    <a href="/${stock['spintex']}"><i class="fa fa-download"></i></a> Spintex <br>
                    <a href="/${stock['nia']}"><i class="fa fa-download"></i></a> NIA <br>
                    <a href="/${stock['osu']}"><i class="fa fa-download"></i></a> OSU
                   </td></tr>
                   </tbody></table>
            `

            amodal.setBodyHtml(html)
            amodal.show()
            amodal.setTitleText("Downlaod FOr Bolt")

        } else {
            kasa.response(call)
        }

    }

    changeBoltGroupScreen(s) {

        let product_detail = this.getBoltProduct(s)['message'][0]
        console.table(product_detail)

        let form  = "";
        let top_div = `
            <p><strong>BARCODE</strong> ${product_detail['barcode']}</p>
            <p><strong>NAME</strong> ${product_detail['item_des']}</p>
            <p><strong>GROUP</strong> ${product_detail['group'].name} / ${product_detail['subgroup'].name}</p>
        `;

        let options = "";

        let groups = this.getBoltGroups('*')
        if(anton.IsRequest(groups)){
            let grps = groups.message;
            let arr = [];
            for(let g = 0; g < grps.length; g++){
                let grp = grps[g];
                // make object
                arr.push({
                    val:grp['pk'],desc:grp['name']
                })
            }

            options = arr

        } else {
            kasa.response(groups);
            throw Error("Error")
        }

        form += top_div

        form += fom.selectv2('category',options,'',true)
        form += fom.selectv2('sub_category',[],'',true)

        amodal.setBodyHtml(form)
        amodal.setTitleText("Change Category")
        amodal.setFooterHtml(`<button onclick="retail.commitBoltGroupChange('${s}')" class="w-100 btn btn-success">CHANGE</button>`)
        amodal.show()

        $('#category').change(function(){
            let pk = $('#category').val();
            let subsx = retail.getBoltSubGroups(pk);

            if(anton.IsRequest(subsx)){
                let subs = subsx['message'];

                let s_opts = '';
                for(let s = 0; s < subs.length; s++) {
                    let sub = subs[s];
                    s_opts += `<option value="${sub['pk']}">${sub['name']}</option>`
                }
                $('#sub_category').html(s_opts)
            } else {
                kasa.response(subsx)
            }

        });
    }

    getBoltProduct(pk) {
        return api.call("VIEW",{module:"bolt_products",data:{pk:pk}},'/retail/api/');
    }

    commitBoltGroupChange(pk) {
        let ids = ['category,sub_category'];
        if(anton.validateInputs(ids)){
            let payload = {
                module:'bolt_group',
                data:anton.Inputs(ids)
            }

            payload['data']['pk'] = pk;

            kasa.confirm(api.call('PATCH',payload,'/retail/api/')['message'],1,'here')

        } else {
            kasa.error("Invalid Form")
        }
    }

    getStock(item_code){
        return api.call('VIEW',{module:'stock',data:{item_code:item_code}},'/retail/api/')
    }

    viewStock(itemCode) {
        let stock = this.getStock(itemCode);
        if(anton.IsRequest(stock)){
            let message = stock.message;
            console.table(message)
            // display stock
            let tr = ``
            for (const trKey in message) {
                tr += `
                    <tr><td><strong>${trKey}</strong></td><td>${message[trKey]}</td></tr>
                `
            }

            amodal.setBodyHtml(`<table class="table table-striped table-bordered">${tr}</table>`)
            amodal.show()

        } else {
            kasa.response(stock)
        }
    }

    mark_send2bold() {
        if(confirm("Are you sure you want to send to bolt?")){
            let payload = {
                module:'mark_send2bold',
                data:{}
            }

            let response = api.call('VIEW',payload,'/retail/api/');
            if(anton.IsRequest(response)){
                let link = response.message
                anton.viewFile(`/${link}`)
            } else {
                kasa.response(response)
            }

        } else {
            kasa.info("Cancelled")
        }
    }

    async loadCard(s = '*', filter = 'pk', entity = '*') {

        let product = this.getCardProduct(s, filter, entity);
        console.log(`BARCODE IS :${s}`)


        if (anton.IsRequest(product)) {
            const message = product['message'][0];


            $('#previous').val(message['previous'])
            $('#next').val(message['next'])
            $('#image').attr('src', `${message['image']}`)


            if (message['previous'] === 0) {
                $('#previous').attr('disabled', true)
            } else {
                $('#previous').attr('disabled', false)
            }

            if (message['next'] === 0) {
                $('#next').attr('disabled', true)
            } else {
                $('#next').attr('disabled', false)
            }

            let stock = message['stock'];

            let str = ""
            for (const trKey in stock) {
                str += `<tr><td>${trKey}</td><td>${stock[trKey]}</td></tr>`
            }

            $('#stock_body').html(str)


            let live_product = this.getProduct(message['barcode'])['message'][0];


            // if(live_product.length < 0){
            //     kasa.error("Live Product Not Found")
            // }



            let cardex = message['cardex'];
            let cl = 5;
            if (cardex.length < cl + 1) {
                cl = cardex.length
            }

            let ctr = ""
            for (let c = 0; c < cl; c++) {
                let cr = cardex[c];
                ctr += `
                    <tr>
                                                <td>${cr['location']['code']}</td>
                                                <td>${cr['move_type']}</td>
                                                <td>${cr['ref']}</td>
                                                <td>${cr['date']}</td>
                                                <td>${cr['qty']}</td>
                                            </tr>
                `
            }
            $('#cardex_tr').empty()
            $('#cardex_tr').html(ctr)
            console.table(cardex)
            console.log("LIVE PRODUCT")
            console.table(live_product)
            $('#barcode').val(live_product['barcode'])
            $('#group_name').val(live_product['group_name'])
            $('#sub_group_name').val(live_product['sub_group_name'])
            $('#sold').val(live_product['sold'])
            $('#is_on_bolt').val(live_product['is_on_bolt'])
            $('#retail1').val(live_product['retail1'])
            console.log("LIVE PRODUCT")
            // anton.setValues(live_product)
            anton.setValues(message)


        } else {
            kasa.response(product)
        }
    }

    getCardProduct(pk='*',filter='pk',entity='*') {
        return api.call("VIEW",{
            module:'prod',
            data:{
                pk:pk,
                filter:filter,
                entity:entity
            },

        },'/retail/api/');


    }

    changeBoltImage(barcode='none') {
        console.log("Barcode")
        let image_form = `
            <form action="/retail/bolt/upload_image/" id="bolt_img_form" method="post" enctype="multipart/form-data" class="w-100"><input name="image" id="bolt_image_input" type="file" accept="image/*"><input type="hidden" class="form-control rounded-0" readonly value="${barcode}" name="barcode"></form><div><img src="" style="width: 200px" alt="" class="img-fluid" id="bolt_img"></div>
        `;
        amodal.setBodyHtml(image_form);
        amodal.setTitleText("Change Bolt Image")
        amodal.setFooterHtml(`<button id="save_bolt_image" class="btn btn-success w-100">CHANGE</button>`)
        // amodal.setSize('L')
        amodal.show()
        console.log("Hello")

        $('#save_bolt_image').click(function(){
            $('#bolt_img_form').submit()
        });
    }


    removeFromBolt(barcode) {
        if(confirm("Are you sure you want to remove from bolt?")){
            let remove = api.call('DELETE',{
                module:'bolt_item',
                data:{
                    barcode:barcode
                }
            },'/retail/api/');

            if(anton.IsRequest(remove)){
                $(`#row_${barcode}`).remove();
                kasa.success(
                    `Removed ${barcode} from bolt`)
            } else {
                kasa.response(remove)
            }
        } else {
            kasa.info("Operation Canceled")
        }
    }

    changeShelfScreen(barcode) {
        let form = "";
        form += fom.text('shelf','',true,'2')
        amodal.setBodyHtml(form)
        amodal.setTitleText('CHANGE SHELF')
        amodal.setFooterHtml(`<button onclick="retail.changeShelf('${barcode}')" class="btn btn-success w-100">CHANGE</button>`)
        amodal.show()
    }

    changeShelf(barcode) {
        let payload = {
            module:'shelf',
            data:{
                barcode:barcode,
                shelf:$('#shelf').val()
            }
        }

        kasa.response(api.call('PATCH',payload,'/retail/api/'));
        amodal.hide()

        // load product
        this.loadCard(barcode,'barcode')

    }

    getSuppliers(){
        let payload = {
            module:'suppliers',data:{}
        }

        return api.call('VIEW',payload,'/retail/api/')
    }

    slowMovingItemsScreen(){
        let form = ``;
        let loc_payload = {
            module:'location_master',
            data:{}
        }
        let locations = api.call('VIEW',loc_payload,'/retail/api/')
        let suppliers = this.getSuppliers()
        console.table(suppliers)
        let supp_arr = []
        supp_arr.push({val:'',desc:"All"})
        if(anton.IsRequest(suppliers)){
            let sups = suppliers.message;
            for(let s = 0; s < sups.length; s++){
                let sup = sups[s];
                console.table(sup)
                supp_arr.push({
                    val:sup.code,desc:sup.name
                })
            }
        }
        let l_arr = []
        l_arr.push({val:'*',desc:'All'})
        let locs = locations['message'];
        for(let l = 0; l < locs.length; l++){
            let lc = locs[l]
            l_arr.push({val:lc['code'],desc:lc['name']})
        }
        // form += fom.selectv2('location',l_arr,'',true)
        let t1 = fom.selectv2('location',l_arr,'',true)
        let t2 = fom.selectv2('supplier',supp_arr,'',true)
        form += `<div class="row"><div class="col-sm-6">${t1}</div><div class="col-sm-6">${t2}</div></div>`;
        let quantity = fom.number('quantity','how many quantity moved',true)
        let days = fom.number('days','how many days movement?',true)
        let nums = `<hr><div class="row"><div class="col-sm-6">${quantity}</div><div class="col-sm-6">${days}</div></div>`;
        form += nums

        let operators = []
        operators.push({val:'==',desc:'Moved Quanaity Equal To Quantity'})
        operators.push({val:'>',desc:"Move Quantity Greater Than Quantity"})
        operators.push({val:'<',desc:"Move Quantity  Less Quantity"})
        operators.push({val:'<=',desc:"Move Quantity Less or Equal to Quantity"})
        operators.push({val:'>=',desc:"Move Quantity Greater or Equal to Quantity"})

        let f1 =  fom.selectv2('operator',operators,'Analyric direction',true)
        let f2 = fom.selectv2('focus',[{val:'sold',desc:'Sold Quantity'},{val:'moved',desc:'Moved Quantity'}],'Movemetn Focus',true)
        let fe = `<hr><div class="row"><div class="col-sm-6">${f1}</div><div class="col-sm-6">${f2}</div></div>`;
        form += fe

        let b1 = fom.selectv2('stock_type',[{val:'',desc:'All'},{val:'1',desc:"Active"},{val:'0',desc:"Discontinued"}],'',true)
        let b2 = fom.selectv2('export',[{val:'json',desc:'Preview'},{val:'excel',desc:"Excel Export"}],'',true)

        let fb = `<hr><div class="row"><div class="col-sm-6">${b1}</div><div class="col-sm-6">${b2}</div></div>`;
        form += fb;


        amodal.setBodyHtml(form)
        amodal.setTitleText('SLOW MOVING ITEMS')
        amodal.setFooterHtml(`<button onclick="retail.slowMovingItems()" class="btn btn-success w-100">GENERATE</button>`)
        amodal.show()
    }

    slowMovingItems() {
        let ids = ['export','quantity','days','operator','focus'];
        if(anton.validateInputs(ids)){
            let payload = {
                module:'slow_moving_items',
                data:anton.Inputs(ids)
            }

            payload['data']['location'] = $('#location').val()
            payload['data']['supplier'] = $('#supplier').val()

            console.table(payload)

            loader.show()

            // Making the API call
            api.v2('VIEW', payload, '/retail/api/')
                .then((res) => {
                    console.table(res)
                    if (anton.IsRequest(res)) {
                        let message = res.message;
                        let ht = ``;

                        if (payload['data']['export'] === 'excel') {
                            loader.hide()
                            anton.viewFile(`/${message}`)
                        } else {
                            let header = ['Barcode', 'Name', 'Moved', 'Sold']
                            let rows = ``;
                            for (let i = 0; i < message.length; i++) {
                                rows += `<tr><td>${message[i]['barcode']}</td><td>${message[i]['name']}</td><td>${message[i]['moved']}</td><td>${message[i]['sold']}</td></tr>`
                      thon      }
                            reports.render(header, rows, `Slow Moving Items above ${payload['data']['quantity']} for the past ${payload['data']['days']} days`)
                            loader.hide()
                            amodal.hide()
                        }
                    } else {
                        kasa.response(res)
                        loader.hide()
                    }
                })
                .catch((err) => {
                    console.log("Responsed error")
                    console.table(err)
                    loader.hide() // Make sure loader is hidden even on error
                })
        }
    }

    async migrateBoltItems(stage) {
        switch (stage) {

            case 'from':
                loader.show()
                // show select from menu
                let et_load = {
                module: 'entity_type',
                data: {}
            }
                await api.v2('VIEW', et_load, '/adapi/').then(
                    response => {
                        if(anton.IsRequest(response)){
                            let ets = response.message;
                            let et_arr = [];
                             let from_locations = [{val:'*',desc:'All'}];
                            for(let e = 0; e < ets.length; e++){
                                let et = ets[e];
                                et_arr.push({
                                    val:et['pk'],desc:et['name']
                                })
                                from_locations.push({
                                    val:et['pk'],desc:et['name']
                                })
                            }
                           
                            
                            let et_form = fom.selectv2('from',from_locations,'Which location you want to migrate from',true)
                            et_form += fom.selectv2('to',et_arr,'Which location you want to migrate to',true)
                            amodal.setBodyHtml(et_form)
                            amodal.setTitleText('Migrate Bolt Items')
                            amodal.setFooterHtml(`<button id="load_from_items" class="btn btn-success w-100">Select Items</button>`)
                            loader.hide()
                            amodal.show()


                            $('#load_from_items').click(async function () {
                                let ids = ['from', 'to']
                                if (anton.validateInputs(ids)) {
                                    let from = $('#from').val();
                                    let to = $('#to').val();
                                    if (from === to) {
                                        kasa.error("From and To cannot be the same")
                                    } else {
                                        // get menu of from
                                        let from_menu_payload = {
                                            module: 'menu',
                                            data: {
                                                entity: from,
                                                to:to
                                            }
                                        }

                                        loader.show()
                                        amodal.hide()
                                        await api.v2('VIEW', from_menu_payload, '/retail/api/').then(
                                            response => {
                                                if (anton.IsRequest(response)) {
                                                    let menu = response.message;
                                                    let tr = ``;
                                                    for(let mi = 0; mi < menu.length; mi++){
                                                        const item = menu[mi]
                                                        const product = item['product']
                                                        const group = item['group']
                                                        const subgroup = item['subgroup']

                                                        let row = `row_${mi}`
                                                        let check = `check_${mi}`
                                                        let barcode = `barcode_${mi}`
                                                        let image = product['image']
                                                        tr += `
                                                            <tr id="${row}">
                                                                <td><input id="${check}" type="checkbox" class="menu_item"></td>
                                                                <td id="${barcode}">${product['barcode']}</td>
                                                                <td>${product.name}</td>
                                                                <td>${group}</td>
                                                                <td>${subgroup}</td>
                                                            </tr>
                                                        `
                                                    }
                                                    let html = `
                                                        <table class="table"><thead><tr><th><button id="check_all"><i  class="fa fa-check"></i></button></th><th>BARCODE</th><th>NAME</th><th>GROUP</th><th>SUBGROUP</th></tr></thead><tbody>${tr}</tbody></table>
                                                    `

                                                    amodal.setBodyHtml(html)
                                                    amodal.setTitleText('Select items for migration')
                                                    amodal.setFooterHtml(`<button id="migrate_items_button" class="btn btn-success w-100">Migrate</button>`)
                                                    amodal.show()
                                                    amodal.setSize('XL')

                                                    $('#check_all').click(function(){
                                                        let checkboxes = $('.menu_item')
                                                        for(let i = 0; i < checkboxes.length; i++){
                                                            checkboxes[i].checked = true
                                                        }
                                                    })

                                                    $('#migrate_items_button').click(async function () {
                                                        let items = []
                                                        loader.show()
                                                        let checkboxes = $('.menu_item')
                                                        for (let i = 0; i < checkboxes.length; i++) {
                                                            let checkbox = checkboxes[i]
                                                            if (checkbox.checked) {
                                                                let id = checkbox.id
                                                                let line = id.split('_')[1]
                                                                let bc = $(`#barcode_${line}`).text()
                                                                items.push(bc)
                                                            }
                                                        }

                                                        let payload = {
                                                            module: 'menu_transfer',
                                                            data: {
                                                                to: to,
                                                                items: items
                                                            }
                                                        }
                                                        await api.v2('PATCH', payload, '/retail/api/').then(
                                                            response => {
                                                                if (anton.IsRequest(response)) {
                                                                    kasa.success('Items Migrated')
                                                                    amodal.hide()
                                                                    location.reload()
                                                                } else {
                                                                    kasa.response(response)
                                                                    loader.hide()
                                                                }
                                                            }
                                                        )
                                                    })
                                                    
                                                } else {
                                                    kasa.response(response)
                                                }
                                                loader.hide()
                                                
                                            }
                                        ).catch(err => {
                                            kasa.error(err)
                                            loader.hide()
                                        })

                                    }
                                } else {
                                    kasa.error("Invalid Form")
                                }

                            })
                        }
                    }
                ).catch(err => {
                    kasa.error(err)
                })
                break;
            default:
            // do nothing
        }
    }

    getGroups(menu) {
        return api.call('VIEW',{module:'entity_groups',data:{menu:menu}},'/retail/api/')
    }

    boltCategories(menu) {
        let payload = {
            module:'bolt_group',
            data:{
                entity:menu
            }
        }

        return api.call('VIEW',payload,'/retail/api/')
    }


    async boltPriceChange(entity_id) {
        let rate_at = prompt("Margin Increment?")
        loader.show()
        let payload = {
            module: 'bolt_price_change',
            data: {
                rate_at: parseInt(rate_at),
                entity_id:entity_id
            }
        }

        await api.v2('VIEW', payload, '/retail/api/').then(response => {
            if(anton.IsRequest(response)) {
                console.log(response)
                anton.viewFile(`/${response.message['price_change']}`)
            } else {
                kasa.error(response)
            }
            loader.hide()
        }).catch(err => {
            kasa.error(err)
            loader.hide()
        })
    }

    async bolt_stock_update(entity_pk) {
        let payload = {
            module: 'bolt_stock_update',
            data: {
                entity_pk: entity_pk
            }
        }

        loader.show()

        await api.v2('VIEW', payload, '/retail/api/').then(response => {
            if (anton.IsRequest(response)) {
                let xx = response.message;
                let spintex = `<a href="/${xx['spintex']}"><i class="fa fa-download"></i> Spintex</a>`
                let nia = `<a href="/${xx['nia']}"><i class="fa fa-download"></i> NIA</a>`
                let osu = `<a href="/${xx['osu']}"><i class="fa fa-download"></i> OSU</a>`

                let ht = `
                    <table class="table table-bordered"><thead><tr><th>LOC</th><th>FILE</th></tr></thead>
                    <tbody>
                        <tr><td><strong>SPINTEX</strong></td><td>${spintex}</td></tr>
                        <tr><td><strong>NIA</strong></td><td>${nia}</td></tr>
                        <tr><td><strong>OSU</strong></td><td>${osu}</td></tr>
                    </tbody></table>
                `

                amodal.setBodyHtml(ht)
                amodal.show()
                amodal.setTitleText('Stock Update')
                loader.hide()
            }
        }).catch(err => {
            kasa.error(err)
            loader.hide()
        })
    }

    async loadButchMonitors(view='view') {
        let payload = {
            module: 'butch_items',
            data: {
                target_date:$('#date').val()
            }
        }

        await api.v2('VIEW', payload, '/retail/api/').then(response => {
            if(anton.IsRequest(response)) {
                let items = response.message;
                let tr = ``
                for(let i = 0; i < items.length; i++){
                    let item = items[i];
                    let barcode = item['barcode']
                    let name = item['name']
                    let image = item['image']
                    let price = item['price']
                    let moves = item['moves'];
                    let ob = moves['OB'];
                    let pur = parseFloat(moves['GR'])
                    if(pur === null){pur = 0}

                    let tra = moves['TR']
                    let ad = moves['AD'];
                    let si = moves['SI']
                    let tot_in = parseFloat(ob) + parseFloat(pur)
                    let tot_out = parseFloat(tra) + parseFloat(ad) + parseFloat(si)
                    let sys_difference = parseFloat(tot_in) - parseFloat(tot_out)
                    let cb = moves['CB'];

                    let leg_diff = parseFloat(cb) - parseFloat(sys_difference);


                    // let quantity = item['quantity']
                    // let sold = item['sold']
                    // let moved = item['moved']
                    if(view === 'view'){
                         tr += `
                        <tr>
                            <td>${barcode}</td>
                            <td>${name}</td>
                            <td>${ob}</td>
                            <td>${pur}</td>
                            <td class="text-primary">${tot_in.toFixed(2)}</td>
                            <td>${tra}</td>
                            <td>${ad}</td>
                            <td>${si}</td>
                            <td class="text-success">${tot_out.toFixed(2)}</td>
                            <td>${sys_difference.toFixed(2)}</td>
                            <td>${cb}</td>
                            <td class="text-info">${leg_diff.toFixed(2)}</td>

                        </tr>
                    `
                    }

                    if(view === 'edit'){
                        let line = i + 1;

                         tr += `
                        <tr id = 'row_${line}'>
                            <td>${line}</td>
                            <td id = 'barcode_${line}'>${barcode}</td>
                            <td>${name}</td>
                            <td><input id ='qty_${line}' type="number" value="0" class="form-control text-right" style="width: 200px" ></td>

                        </tr>
                    `
                    }


                }
                $('tbody').empty()
                $('tbody').html(tr)
            } else {
                kasa.response(response)
            }
        })

    }

    async boltExpityExport(entity) {
        let payload = {
            module: 'check_bolt_expiry',
            data: {
                entity: entity,
            }
        }

        loader.show()
        await api.v2('VIEW', payload, '/retail/api/').then(response => {
            if(anton.IsRequest(response)) {
                let message = response.message;
                let js = message.json;
                let xl = message.excel

                let tr = "";
                for (let i = 0; i < js.length; i++) {
                    let row = js[i];
                    tr += `
                        <tr><td>${row['product']['barcode']}</td><td>${row['product']['name']}</td><td>${row['exp_date']}</td></tr>
                    `
                }

                let ht = `
                    <table class="table table-sm"><thead><tr><th>SKU</th><th>NAME</th><th>EXPIRY DATE</th></tr></thead><tbody>${tr}</tbody></table>
                `

                amodal.setFooterHtml(`<a href="/${xl}" class="btn btn-success"><i class="fa fa-download"></i> Download</a>`)
                amodal.setBodyHtml(ht)
                amodal.setTitleText('Bolt Expiry')
                amodal.setSize('L')
                amodal.show()
                console.table(js)
                loader.hide()
            } else {
                kasa.response(response)
                loader.hide()
            }
        }).catch(err => {
            kasa.error(err)
            loader.hide()
        })
    }

    async resetStockScreen() {
        // get locations
        let loc_payload = {
            module: 'location_master',
            data: {}
        }
        let barcode,name;
        barcode = $('#barcode').val()
        name = $('#name').val()

        if(!anton.validateInputs(['barcode','name'])){
            kasa.error("Select Product")
            return
        }
        await api.v2('VIEW',loc_payload,'/retail/api/').then(response => {
            if(anton.IsRequest(response)){
                let locs = response['message'];
                let tr = "";
                for(let l = 0; l < locs.length; l++){
                    let loc = locs[l];
                    if(loc['type'] === 'retail'){
                        tr +=  `
                            <tr id="row_${l}"><td id="code_${l}">${loc['code']}</td><td>${loc['name']}</td><td><input type="text" id="quantity_${l}" value="not_include"></td></tr>
                        `
                    }

                }

                let html = `
<!--                <input type="date" id="as_of_date">-->
                    <p>Barcode: ${barcode}</p>
                    <p>Namr: ${name}</p>
                    
                    <hr>
                    <table class="table table-sm"><thead><tr><th>CODE</th><th>DESCR</th><th>PHYSICAL</th></tr></thead><tbody id="rs_body">${tr}</tbody></table>
                `
                amodal.setBodyHtml(html)
                amodal.setTitleText("Stock Reset")
                amodal.show()
                amodal.setFooterHtml(`<button class="btn btn-warning" id="reset_stock">RESET</button>`)
                $('#reset_stock').click(function(){
                    // if(!anton.validateInputs(['as_of_date'])){
                    //     kasa.error("Select Date")
                    //     return
                    // }
                    $('#rs_body tr').each(function (){
                        let id = $(this).attr('id');
                        let line = id.split('_')[1];
                        let qty = $(`#quantity_${line}`).val();
                        if(qty !== 'not_include'){
                            let payload = {
                                "module":"moves",
                                "data":{
                                    "type":"SR",
                                    "loc_id":$(`#code_${line}`).text(),
                                    "remarks":"Stock Reset Test",
                                    'entry_date':$('#as_of_date').val(),
                                    "transactions":[
                                        {
                                            "barcode":barcode,
                                            "quantity":qty
                                        }
                                    ]
                                }
                            }



                            console.table(payload)
                            let send = api.call('PUT',payload,'/retail/api/')
                            console.table(send)
                        }


                    })
                    amodal.hide()
                })
            } else {
                kasa.response(response)
            }
        }).catch(error => {kasa.error(error)})
    }


    hideBolt(barcode){
        let html = `
            <select id='hide_reason' class='form-control rounded-0'>
                <option value='' selected disabled>Select Reason</option>
                <option value='EXP'>Expired</option>
                <option value='OUT'>Out Of Stock</option>
            </select>
        `
        amodal.setBodyHtml(html)
        amodal.setTitleText("Hide Reason")
        amodal.setFooterHtml(`<button id='hide_btn' class='btn btn-warning rounded-0'>HIDE</button>`)
        amodal.show()

        $('#hide_btn').click(async function(){
            let ids = ['hide_reason','mypk']
            if(anton.validateInputs(ids)){
                let payload= {
                    module:'hide_bolt',
                    data:anton.Inputs(ids)
                }

                payload['data']['pk'] = barcode

                console.table(payload)

                await api.v2('PATCH',payload,'/retail/api/').then(response => {
                    if(anton.IsRequest(response)){
                        kasa.success("HELLO WORLD")
                    } else {
                        kasa.error(response)
                    }
                }).catch(error => {
                    kasa.info(error)
                })
            } else {
                kasa.error("Fill Form")
            }
        })

    }

}

const retail = new Retail();

$(document).on('change', '#bolt_image_input', function() {
    console.log("Bolt Image Loading")
    const file = this.files[0]; // Get the selected file

    if (file) {
        const reader = new FileReader();

        reader.onload = function(e) {
            $('#bolt_img').attr('src', e.target.result).show(); // Set image source and make it visible
        };

        reader.readAsDataURL(file); // Read the file as a data URL
    }
});

 $(document).on('submit', '#bolt_img_form', function(e) {
            e.preventDefault(); // Prevent the default form submission
            console.log("Sending Image")
            const form = $(this);
            const formData = new FormData(form[0]); // Create FormData object from the form

            $.ajax({
                type: 'POST', // Or use form.attr('method') if you want it dynamic
                url: form.attr('action'), // Form action or current page URL
                data: formData,
                contentType: false, // Prevent jQuery from setting content type
                processData: false, // Prevent jQuery from processing data
                success: function(response) {
                    console.table(response)
                    kasa.info(response.message)
                },
                error: function(xhr) {
                    $('#response').html('<p>Error: ' + xhr.responseText + '</p>');
                }
            });
        });


