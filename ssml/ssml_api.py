import json
import sys

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

from ssml.models import Contractor


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


        if method == 'PUT':
            if module == 'contractor':
                company = data.get('company')
                owner = data.get('owner')
                phone = data.get('phone')
                email = data.get('email')
                country = data.get('country')
                city = data.get('city')
                postal_code = data.get('postal_code')
                gh_post_code = data.get('gh_post_code')
                gh_card_no = data.get('gh_card_no')

                Contractor.objects.create(company=company, owner=owner, phone=phone,email=email,country=country,
                                          city=city,postal_code=postal_code,gh_card_no=gh_card_no,gh_post_code=gh_post_code)

                success_response['message'] = "Contractor Created Successfully"



        elif method == 'VIEW':
            pass
        elif method == 'DELETE':
            pass
        elif method == 'PATCH':
            pass
        else:
            success_response['status_code'] = 400
            success_response['message'] = f"Method Not Found"

        response = success_response

    except Exception as e:
        error_type, error_instance, traceback = sys.exc_info()
        tb_path = traceback.tb_frame.f_code.co_filename
        line_number = traceback.tb_lineno
        response["status_code"] = 500
        response[
            "message"] = f"An error occurred on line {line_number} in file {tb_path}. Details: {e}"

    return JsonResponse(response, safe=False)