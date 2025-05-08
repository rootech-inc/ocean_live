import json
import sys
from decimal import Decimal

from ocean.settings import ATTENDANCE_URL
from .modric import token
import requests

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.db.models import Q
from django.contrib.auth.models import User

from employee.models import Attendance, Company, Department, Employee, Position

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
            if module == 'area':
                import requests

                url = "http://192.168.2.15/personnel/api/areas/"  # Replace with actual domain

                headers = {
                    "Content-Type": "application/json",
                    "Authorization": f"JWT {token('solomon', 'Szczesny@411')}"
                }

                data = {
                    "area_code": data.get('area_code'),
                    "area_name": data.get('area_name'),
                    "parent_area": None
                }

                response = requests.post(url, json=data, headers=headers)


                success_response['message'] = "Area Created Successfully"


            elif module == 'department':
                import requests

                url = f"{ATTENDANCE_URL}personnel/api/departments/"  # Replace with actual domain

                headers = {
                    "Content-Type": "application/json",
                    "Authorization": f"JWT {token('solomon', 'Szczesny@411')}"
                }

                data = {
                    "dept_code": data.get('dept_code'),
                    "dept_name": data.get('dept_name'),
                    "parent_dept": None
                }

                response = requests.post(url, json=data, headers=headers)
                success_response['message'] = "Dept Created Successfully"
                response = success_response

            elif module == 'position':
                import requests

                url = f"{ATTENDANCE_URL}personnel/api/positions/"  # Replace with actual domain

                headers = {
                    "Content-Type": "application/json",
                    "Authorization": f"JWT {token('solomon', 'Szczesny@411')}"
                }

                data = {
                    "position_code": data.get('position_code'),
                    "position_name": data.get('position_name'),
                    "parent_position": None
                }

                response = requests.post(url, json=data, headers=headers)
                success_response['message'] = "Position Created Successfully"
                response = success_response



        if method == 'VIEW':
            if module == 'area':
                url = 'http://192.168.2.15/personnel/api/areas/'

                tk = token('solomon','Szczesny@411')
                headers = {
                    'Authorization': f'JWT {tk}',
                    'Content-Type': 'application/json',
                    'ordering': 'dept_id'
                }
                import requests
                response = requests.get(url, headers=headers,json={})
                response = response.json()
                data = response.get('data')

                success_response['message'] = data
                response = success_response

            elif module == 'department':
                import requests
                url = f"{ATTENDANCE_URL}personnel/api/departments/"
                tk   = token('solomon','Szczesny@411')
                headers = {
                    "Authorization": f"JWT {tk}",
                    "Content-Type": "application/json",
                }
                response = requests.get(url, headers=headers,params={
                    "page_size": 10000, "ordering": "dept_name"
                })
                response = response.json()
                success_response['message'] = response.get('data')
                response = success_response

            elif module == 'position':
                import requests
                url = f"{ATTENDANCE_URL}personnel/api/positions/"
                tk   = token('solomon','Szczesny@411')
                headers = {
                    "Authorization": f"JWT {tk}",
                    "Content-Type": "application/json",
                }
                response = requests.get(url, headers=headers,params={
                    "page_size": 10000, "ordering": "dept_name"
                })
                response = response.json()
                success_response['message'] = response.get('data')
                response = success_response

    except Exception as e:
        error_type, error_instance, traceback = sys.exc_info()
        tb_path = traceback.tb_frame.f_code.co_filename
        line_number = traceback.tb_lineno
        response["status_code"] = 500
        response[
            "message"] = f"An error occurred on line {line_number} in file {tb_path}. Details: {e}"

    return JsonResponse(response, safe=False)