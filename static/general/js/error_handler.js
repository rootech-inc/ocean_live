function swal_reload(message='')
{
    Swal.fire({

        icon: 'success',
        title: 'RELOAD',
        text:message,
        showDenyButton: false,
        showCancelButton: false,
        confirmButtonText: 'OK',
        denyButtonText: `Don't save`,
    }).then((result) => {
        /* Read more about isConfirmed, isDenied below */
        if (result.isConfirmed) {
            location.reload()
        } else if (result.isDenied) {
            location.reload()
        }
    })
}

function swal_success(str) {
    swal.fire({
        icon: 'success',
        title: 'Process Completed Successfully',
        text:str,
    })
}

function swal_response(icon='info',title = 'SWAL RESPONSE',text ='') {
    swal.fire({
        icon: icon,
        title: title,
        html:text,
    })
}

const al = (icon='info',message='') => {
    Swal.fire({
        'icon':icon,
        'text':message
    })
}

// error handler
function error_handler(response)
{
    // split response
    if(response.split('%%').length === 2)
    {
        let response_split = response.split('%%');
        let response_type = response_split[0];
        let response_message = response_split[1];
        console.log(response)
        // $('#gen_modal').modal('hide')
        // switching response type
        switch (response_type)
        {
            case 'done':
                switch (response_message){
                    case 'msg_sent':
                        $('#convo_message').val('')
                        load_convo_message()
                        break;
                    default:
                        swal_reload("Process Completed")
                        console.table(response_message)
                        break;
                }
                break

            case 'error':
                swal_response('error','PROCEDURE ERROR',response_message)
                break;

            default:
                swal_response('info','SYSTEM INFORMATION',response_message)
        }

    } else {
        swal_response('info','SYSTEM INFORMATION',response)
    }
}

function str_len(str) {
    if(str.length > 0)
    {
        return true
    } else
    {
        return false
    }
}

function ctable(str){
    console.table(str)
}

function clog(str) {
    console.table(str)
}

function windowPopUp(url, title, w, h) {
    let left = (screen.width / 2) - (w / 2);
    let top = (screen.height / 2) - (h / 2);

    // Create overlay
    let overlay = document.createElement('div');
    overlay.id = "popup-overlay";
    overlay.className = "d-flex align-items-center justify-content-center";
    overlay.style.position = "fixed";
    overlay.style.top = 0;
    overlay.style.left = 0;
    overlay.style.width = "100%";
    overlay.style.height = "100%";
    overlay.style.background = "rgba(0,0,0,0.4)";
    overlay.style.backdropFilter = "blur(5px)"; // <-- blur effect
    overlay.style.zIndex = 9999;
    overlay.style.pointerEvents = "auto";

    // Create centered message card using Bootstrap classes
    overlay.innerHTML = `
        <div class="card shadow-lg text-center" style="max-width: 300px;">
            <div class="card-body">
                <h5 class="card-title mb-3">Popup Open</h5>
                <p class="card-text">Please complete the action in the popup window to continue.</p>
                <div class="spinner-border text-primary mt-3" role="status">
                  <span class="sr-only">Loading...</span>
                </div>
            </div>
        </div>
    `;

    document.body.appendChild(overlay);

    // Open popup window
    let popupWindow = window.open(
        url,
        title,
        'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' +
        w + ', height=' + h + ', top=' + top + ', left=' + left
    );

    popupWindow.focus();

    // Check when popup closes, then remove overlay
    let interval = setInterval(function () {
        if (popupWindow.closed) {
            clearInterval(interval);
            let overlay = document.getElementById("popup-overlay");
            if (overlay) overlay.remove();
        }
    }, 500);
}
