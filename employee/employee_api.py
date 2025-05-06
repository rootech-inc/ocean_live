import json
import sys
from decimal import Decimal
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
            if module == 'company':
                name = data.get('name')
                address = data.get('address')
                city = data.get('city')
                country = data.get('country')
                postal_code = data.get('postal_code')
                phone = data.get('phone')
                email = data.get('email')
                website = data.get('website', '')

                
                Company.objects.create(
                    name=name,
                    address=address,
                    city=city,
                    country=country,
                    postal_code=postal_code,
                    phone=phone,
                    email=email,
                    website=website
                )

                success_response['message'] = "Company Created Successfully"


            elif module == 'department':
                name = data.get('name')
                description = data.get('description', '')

                Department.objects.create(
                    name=name,
                    description=description,
                )

                success_response['message'] = "Department Created Successfully"

            elif module == 'position':
                name = data.get('name')
                description = data.get('description', '')
                department_id = data.get('department_id')

                Position.objects.create(
                    name=name,
                    description=description,
                    department_id=department_id
                )

                success_response['message'] = "Position Created Successfully"

            elif module == 'employee':
                emp_code = data.get('emp_code')
                first_name = data.get('first_name')
                last_name = data.get('last_name')
                email = data.get('email')
                phone = data.get('phone')
                address = data.get('address')
                city = data.get('city')
                country = data.get('country')
                postal_code = data.get('postal_code')
                company_id = data.get('company_id')
                department_id = data.get('department_id')
                position_id = data.get('position_id')
                hire_date = data.get('hire_date')
                salary = data.get('salary')
                is_active = data.get('is_active', True)

                Employee.objects.create(
                    first_name=first_name,
                    last_name=last_name,
                    email=email,
                    phone=phone,
                    address=address,
                    city=city,
                    country=country,
                    postal_code=postal_code,
                    company_id=company_id,
                    department_id=department_id,
                    position_id=position_id,
                    hire_date=hire_date,
                    salary=salary,
                    is_active=is_active
                )

                success_response['message'] = "Employee Created Successfully"

            elif module == 'attendance':
                employee_id = data.get('employee_id')
                date = data.get('date')
                time_in = data.get('time_in')
                time_out = data.get('time_out')
                status = data.get('status')
                notes = data.get('notes', '')

                Attendance.objects.create(
                    employee_id=employee_id,
                    date=date,
                    time_in=time_in,
                    time_out=time_out,
                    status=status,
                    notes=notes
                )

                success_response['message'] = "Attendance Created Successfully"
    
    except Exception as e:
        error_type, error_instance, traceback = sys.exc_info()
        tb_path = traceback.tb_frame.f_code.co_filename
        line_number = traceback.tb_lineno
        response["status_code"] = 500
        response[
            "message"] = f"An error occurred on line {line_number} in file {tb_path}. Details: {e}"

    return JsonResponse(response, safe=False)