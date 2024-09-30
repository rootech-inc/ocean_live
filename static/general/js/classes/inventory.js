class Inventory {

    pendingTransfers() {
        let payload = {
            module:'transfer',
            data:{
                status:1,
            }
        }

        let response = api.call('VIEW',payload,'/inventory/api/');
        if(anton.IsRequest(response)){
            let transfers = response.message;

            let rows = ""
            for (let i = 0; i < transfers.length ; i++) {

                let row = transfers[i]
                let hd = row['header']
                rows += `<tr>
                            <td><a onclick="viewTransfer('${hd['pk']}')" href="javascript:void(0)">${hd['entry_no']}</a></td>
                            <td>${hd['created_on']}</td>
                            <td>${hd['from']}</td>
                            <td>${hd['to']}</td>
                          </tr>`
                console.table(hd)
            }

            let html = `
                <table class="table table-bordered table-hover"><tr><th>ENTRY</th><th>DATE</th><th>FROM</th><th>TO</th></tr>${rows}</table>
            `

            amodal.setBodyHtml(html)
            amodal.setSize('L')
            amodal.show()
        }

    }
}

const inv = new Inventory();