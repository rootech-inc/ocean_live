import json
import sys
from decimal import Decimal
from datetime import datetime, date

from admin_panel.models import Sms, SmsApi, UserAddOns
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

            elif module == 'sync_attendance':
                # get workers
                tk = token('solomon', 'Szczesny@411')
                current_datetime = datetime.now()
                start = f"{str(current_datetime.strftime('%Y-%m-%d'))} 00:00:00"
                end = f"{str(current_datetime.strftime('%Y-%m-%d'))} 23:59:59"
                import requests
                url = "http://192.168.2.15/personnel/api/employees/?page_size=10000"

                payload = json.dumps({
                    "start_time": "2024-01-01",
                    "end_time": "2024-12-01",
                    "emp_code": 1,
                    "page_size": 500000,
                    "terminal_sn": ""
                })
                headers = {
                    'Authorization': f"JWT {tk}",
                    'Content-Type': 'application/json'
                }

                resp = requests.request("GET", url, headers=headers, data=payload)
                j_resp = json.loads(resp.text)

                gl = []
                count = j_resp['count']
                data = j_resp['data']
                for i in data:
                    emp_code = i['emp_code']
                    first_name = i['first_name']
                    last_name = i['last_name']
                    department = i['department']

                    dep_name = department.get('dept_name')
                    position = i['position']

                    position_name = position.get('position_name') if position else ''
                    contact = i['contact_tel']
                    mobile = i['mobile']
                    email = i['email']

                    li = [emp_code,f"{first_name} {last_name}",dep_name,position_name,contact,email]
                    print(li)

                    # get attendance
                    url = f"{ATTENDANCE_URL}iclock/api/transactions/?start_time={start}&end_time={end}&page_size=10000&emp_code={emp_code}"

                    payload = json.dumps({
                        "start_time": "2024-01-01T00:00:00",
                        "end_time": "2024-01-30T00:00:00",
                        "emp_code": 1,
                        "page_size": 500000
                    })
                    headers = {
                        'Authorization': f"JWT {tk}",
                        'Content-Type': 'application/json'
                    }

                    att_response = requests.request("GET", url, headers=headers, data=payload)
                    attendance = json.loads(att_response.text)

                    # print(attendance)
                    att_count = attendance['count']
                    att_data = attendance['data']

                    check_in = ""
                    check_out = ""
                    minutes_diff = 0
                    present = False
                    if attendance['count'] == 0:
                        check_in = "N/A"
                        check_out = "N/A"
                    else:
                        first_record = att_data[0]
                        last_record = att_data[len(att_data) - 1]

                        first_date_time = datetime.strptime(str(first_record['punch_time']), '%Y-%m-%d %H:%M:%S')
                        first_time_only = first_date_time.time()

                        last_date_time = datetime.strptime(str(last_record['punch_time']), '%Y-%m-%d %H:%M:%S')
                        last_time_only = last_date_time.time()

                        total_time = last_date_time - first_date_time
                        minutes_diff = "{:.2f}".format(total_time.total_seconds() / 60)

                        check_in = first_time_only
                        check_out = last_time_only
                        present = True

                    ali = [f"{first_name} {last_name}", dep_name, position_name, str(check_in), str(check_out), present,
                          minutes_diff]
                    print(ali)




            elif module == 'staff':
                import requests

                url = f"{ATTENDANCE_URL}personnel/api/employees/"  # Replace with actual domain

                headers = {
                    "Content-Type": "application/json",
                    "Authorization": f"JWT {token('solomon', 'Szczesny@411')}"
                }

                data = {
                    "emp_code": data.get('emp_code'),
                    "department": data.get('department'),
                    "area": data.get('area'),
                    "first_name": data.get('first_name'),
                    "last_name": data.get('last_name'),
                    "mobile": data.get('mobile'),
                    "email": data.get('email'),
                    "contact_tel":data.get('mobile'),
                    'position':data.get('position')

                }

                response = requests.post(url, json=data, headers=headers)
                print("RESPONSE")
                print(response.json())
                print("RESPONSE")
                success_response['message'] = "Staff Created Successfully"
                # make sms
                Sms.objects.create(
                    api=SmsApi.objects.get(is_default=True),
                    to=data.get('mobile'),
                    message=f"Dear {data.get('first_name')} {data.get('last_name')} your records have been entered into attendace / company records. Follow up to record your bio-data"
                )

                print("CREATED")
                response = success_response




        elif method == 'VIEW':
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

            elif module == 'attendance':
                mt = data.get('month')
                yr = data.get('year')
                mypk = data.get('mypk')
                add_on = UserAddOns.objects.get(user_id=mypk)
                bio_id = add_on.bio_id

                # get transactions

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

            elif module == 'staff':
                import requests
                url = f"{ATTENDANCE_URL}personnel/api/employees/"
                tk   = token('solomon','Szczesny@411')
                headers = {
                    "Authorization": f"JWT {tk}",
                    "Content-Type": "application/json",
                }
                response = requests.get(url, headers=headers,params={
                    "page_size": 10000, "ordering": "id"
                })
                response = response.json()
                success_response['message'] = response.get('data')
                response = success_response

            elif module == 'otp_auth':
                bio_id = data.get('bio_id')
                # bio_id = 2000
                import requests
                url = f"{ATTENDANCE_URL}personnel/api/employees/{bio_id}/"
                tk   = token('solomon','Szczesny@411')
                headers = {
                    "Authorization": f"JWT {tk}",
                    "Content-Type": "application/json",
                }
                rsp1 = requests.get(url, headers=headers,params={
                    "page_size": 10000, "ordering": "id"
                })
                rsp = rsp1.json()
                if rsp.get('detail'):
                    response['status_code'] = 404
                    response['message'] = rsp.get('detail')
                else:

                    # make otp
                    import random
                    otp = random.randint(100000, 999999)
                    message = f"Your verification code is {otp}. Do not share this code with anyone."
                    mobile = rsp.get('mobile')
                    if len(mobile) == 10:
                        success_response['message'] = {
                            'otp':otp,
                            'msg':f"OTP sent to {mobile}, please confirm it is you"
                        }
                        Sms.objects.create(
                            api=SmsApi.objects.get(is_default=True),
                            to=mobile,
                            message=message
                        )
                        response = success_response
                    else:
                        success_response['status_code'] = 505
                        success_response['message'] = f"{mobile} is an invalid phone number"

                    response = success_response


            else:
                response['message'] = "Invalid Module"
                response['status_code'] = 505
    
        elif method == 'PATCH':
            if module == 'update_auth':
                bio_id = data.get('bio_id')
                bio_password = data.get('bio_password')
                mypk = data.get('mypk')

                user = User.objects.get(pk=mypk)
                ad_on = UserAddOns.objects.get(user=user)
                ad_on.bio_id = bio_id
                ad_on.bio_password = bio_password
                ad_on.save()

                response = success_response

    except Exception as e:
        error_type, error_instance, traceback = sys.exc_info()
        tb_path = traceback.tb_frame.f_code.co_filename
        line_number = traceback.tb_lineno
        response["status_code"] = 500
        response[
            "message"] = f"An error occurred on line {line_number} in file {tb_path}. Details: {e}"

    return JsonResponse(response, safe=False)