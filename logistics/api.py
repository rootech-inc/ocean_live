import json
import sys

from django.contrib.auth.models import User
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from numba.cpython.charseq import is_default

from admin_panel.anton import make_md5_hash
from admin_panel.models import Sms, SmsApi, MailQueues, MailSenders
from blog.anton import make_md5
from logistics.models import Vehicle, Driver, DeliveryRequest, DeliveryLog
from ocean.settings import LOGISTIC_CONTACT


@csrf_exempt
def interface(request):
    response = {
        'status_code': 0,
        'message': ""
    }

    success_response = {
        'status_code': 200,
        'message': "Procedure Completed Successfully"
    }

    # get method
    method = request.method

    try:

        body = json.loads(request.body)
        module = body.get('module')
        data = body.get('data')


        if method == "PUT":
            if module == 'vehicle':
                plate_number = data.get('plate_number')
                description = data.get('description')
                capacity = data.get('capacity')

                Vehicle.objects.create(plate_number=plate_number, description=description, capacity=capacity)
                success_response['message'] = 'Successfully Updated'

            elif module == 'driver':
                name = data.get('name')
                phone_number = data.get('phone_number')
                license_number = data.get('license_number')
                email = data.get('email')

                Driver.objects.create(
                    name=name,phone_number=phone_number,license_number=license_number,email=email
                )

                success_response['message'] = 'Driver Successfully Created'

            elif module == 'delivery_request':
                requested_by = User.objects.get(pk=data.get('requested_by'))
                destination = data.get('destination')
                description = data.get('description')
                delivery_type = data.get('delivery_type')
                source = data.get('source')

                enc = make_md5(make_md5_hash(f"{requested_by.first_name} {requested_by.last_name} {description} {delivery_type}"))

                DeliveryRequest.objects.create(
                    requested_by=requested_by,
                    description=description,
                    destination=destination,
                    delivery_type=delivery_type,
                    enc=enc,
                    source=source,
                )

                # make sms or email
                Sms.objects.create(
                    api=SmsApi.objects.get(is_default=True),
                    to=LOGISTIC_CONTACT.get('phone'),
                    message=f"There is a new delivery ({delivery_type}) request by {requested_by.first_name} {requested_by.last_name}."
                )

                # send email
                MailQueues.objects.create(
                    mail_key=enc,
                    recipient=LOGISTIC_CONTACT.get('email'),
                    sender=MailSenders.objects.get(is_default=True),
                    subject="Delivery Request",
                    body=f"There is a There is a new delivery ({delivery_type}) request by {requested_by.first_name} {requested_by.last_name}. "
                )

                # add to log
                DeliveryLog.objects.create(
                    delivery=DeliveryRequest.objects.get(enc=enc),
                    title="Delivery Request",
                    details="Delivery Request",
                    user=requested_by,
                )

                success_response['message'] = 'Delivery Request Added'


            elif module == 'delivery_log':
                delivery = DeliveryRequest.objects.get(enc=data.get('delivery'))
                title = data.get('title')
                details = data.get('details')
                user = User.objects.get(pk=data.get('user'))

                DeliveryLog.objects.create(
                    delivery=delivery,
                    title=title,
                    details=details,
                    user=user
                )

                success_response['message'] = 'Log Added'

            else:
                raise Exception('Module Not Supported')

            response = success_response

        elif method == 'VIEW':
            if module == 'vehicle':
                pk = data.get('pk','*')
                if pk == '*':
                    success_response['message'] = [v.obj() for v in Vehicle.objects.all()]
                else:
                    success_response['message'] = [v.obj() for v in Vehicle.objects.filter(pk=pk)]

            elif module == 'driver':
                pk = data.get('pk','*')
                if pk == '*':
                    success_response['message'] = [v.obj() for v in Driver.objects.all()]
                else:
                    success_response['message'] = [v.obj() for v in Driver.objects.filter(pk=pk)]

            elif module == 'delivery_request':
                # DeliveryRequest.objects.all().delete()
                print(data)
                pk = data.get('pk', '*')

                if pk == '*':
                    result = DeliveryRequest.objects.all()

                    status = data.get('status', '*')
                    if status != '*':
                        if data.get('against') == 'in':
                            result = result.filter(status=status)
                        else:
                            result = result.exclude(status=status)

                    result = result.order_by('-request_date')

                    # Ensure limit is an integer
                    limit = int(data.get('limit', 100))
                    result = result[:limit]


                    success_response['message'] = [v.obj() for v in result]
                else:
                    success_response['message'] = [v.obj() for v in DeliveryRequest.objects.filter(enc=pk)] if DeliveryRequest.objects.filter(enc=pk).exists() else []

            else:
                raise Exception('Module Not Supported')
            response = success_response
        else:
            raise Exception('Method Not Supported')





    except Exception as e:
        error_type, error_instance, traceback = sys.exc_info()
        tb_path = traceback.tb_frame.f_code.co_filename
        line_number = traceback.tb_lineno
        response["status_code"] = 500
        response[
            "message"] = f"An error occurred on line {line_number} in file {tb_path}. Details: {e}"

    return JsonResponse(response, safe=False)