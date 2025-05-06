class Api {

    constructor() {
        this.payload = {
            module:'',
            data:{}
        }
    }
    call(method,data,link='/apiv2/'){
        // console.log(JSON.stringify(data))
        // let link = interface
        // console.table(link)
        var result = {
            'status_code':0,
            'message':'Not Sent To Backend'
        };



        try {
            $.ajax({
            url:link,
            type: method,
            contentType: 'application/json; charset=utf-8',
            processData: false,
            async: false,
            dataType: 'html',
            data:JSON.stringify(data),
            // dataType: "json",
            success: function (response) {

                result =  JSON.parse(response)
                // console.table(response)

            },
            error: function (error)
            {

                result = error
            }
        })
        } catch (e) {
            result.status_code = 500;
            result.message = e;
        }


        // console.table(result['responseText'])
        return result
    }

    async v2(method, data, int = '/api/') {
        // console.log(data)
        // console.log(int)
        // console.log(method)
        try {
            const response = await fetch(int, {
                method: method,
                headers: {
                    'Content-Type': 'application/json; charset=utf-8'
                },
                body: JSON.stringify(data)
            });

            // Check if the response is ok (status in the range 200-299)
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            // Parse the JSON response
            const result = await response.json();
            // console.log(result);
            return result;
        } catch (error) {
            console.error('Error:', error);
            return error;
        }
    }

    view(data){
        return this.call('VIEW',data)
    }

    put(data){
        return this.call('PUT',data)
    }

    patch(data){
        return this.call('PATCH',data)
    }

    delete(data){
        return this.call('DELETE',data)
    }
}

const api = new Api()