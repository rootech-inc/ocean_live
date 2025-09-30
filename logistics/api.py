import json
import sys

from django.contrib.auth.models import User
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from numba.cpython.charseq import is_default

from admin_panel.anton import make_md5_hash
from admin_panel.models import Sms, SmsApi, MailQueues, MailSenders, UserAddOns
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
                owner = User.objects.get(pk=data.get('user'))



                Vehicle.objects.create(plate_number=plate_number,
                                       description=description,
                                       capacity=capacity,
                                       owner=owner,
                                       model=data.get('model'),
                                       manufacturer=data.get('manufacturer'),
                                       make_year=data.get('make_year'),
                                       fuel_type=data.get('fuel_type'),
                                       chassis=data.get('chassis')
                                       )
                success_response['message'] = Vehicle.objects.get(plate_number=plate_number).pk

            elif module == 'driver':

                user = User.objects.get(pk=data.get('user'))
                name =user.get_full_name()
                ad_on = UserAddOns.objects.get(user=user)
                phone_number = ad_on.phone
                license_number = data.get('license_number')
                email = user.email

                Driver.objects.create(
                    name=name,phone_number=phone_number,license_number=license_number,email=email
                )

                Sms.objects.create(
                    api=SmsApi.objects.get(is_default=True),
                    to=phone_number,
                    message=f"Hello {user.get_full_name()}, You have been registered as a driver with the following details: \nName: {name} \nLicense Number: {license_number}"
                )



                success_response['message'] = Driver.objects.get(name=name,phone_number=phone_number,license_number=license_number,email=email).pk

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

        elif method == 'PATCH':
            if module == 'delivery_request':
                enc = data.get('enc')
                user = User.objects.get(pk=data.get('user'))
                status = data.get('status')
                delivery = DeliveryRequest.objects.get(enc=enc)
                remarks = data.get('remarks')


                DeliveryLog.objects.create(
                    delivery=delivery,
                    title=f"{status.replace('_', ' ').title()}",
                    details=remarks,
                    user=user
                )

                # Send SMS to requested person
                Sms.objects.create(
                    api=SmsApi.objects.get(is_default=True),
                    to=user.username,
                    message=f"Your delivery request status has been updated to {status}."
                )

                if status == 'schedule':
                    delivery.driver = Driver.objects.get(pk=data.get('driver'))
                    delivery.schedule_date = data.get('schedule_date')

                if status == 'in_transit':
                    delivery.vehicle = Vehicle.objects.get(pk=data.get('vehicle'))
                    delivery.departure_time = data.get('in_transit_date')

                delivery.status = status
                delivery.save()


                success_response['message'] = 'Delivery Request Updated'

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