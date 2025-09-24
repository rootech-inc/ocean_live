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

                console.table(message)

                let logs_ht = ""
                message.logs.map(log => {
                    logs_ht += `
                         <div class="mb-4 position-relative">
                          <div class="rounded-circle bg-success position-absolute" style="left: -32px; top: 0; width: 20px; height: 20px;"></div>
                          <div class="font-weight-bold">${log.title}</div>
                          <div class="text-muted small">${log.time}</div>
                        </div>
                    `
                })

                $('.logs').html(logs_ht)
            } else {
                kasa.response(response)
            }
        }).catch(err =>{kasa.error(err)});
    }
}

const logistics = new Logistics();