import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.db.models import Sum, F

from ssml.models import Contractor, InventoryMaterial, IssueTransaction, MaterialOrderItem, Plot, ServiceOrder, ServiceOrderItem, ServiceOrderReturns


@csrf_exempt
def contractor_api(request):
    print(f"Received method: {request.method}")
    
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
            pass

        elif method == 'VIEW':
            arr = []

            if module == 'contractor':
                try:
                    id = data.get('id','*')
                    
                    if id == '*':
                        arr = [contractor.obj() for contractor in Contractor.objects.all().order_by('company')]
                    else:
                        contractor = Contractor.objects.get(id=id)
                        arr = contractor.obj()
                except Exception as e:
                    success_response['status_code'] = 505
                    success_response['message'] = f"Error at line {e.__traceback__.tb_lineno}"
                    arr = f"Error at line {e.__traceback__.tb_lineno}: {e}"

            elif module == 'material':
                try:
                    contractor_id = data.get('contractor_id')
                    contractor = Contractor.objects.get(id=contractor_id)
                    barcodes = IssueTransaction.objects.filter(issue__contractor=contractor).values_list('barcode', flat=True).distinct()
                    for barcode in barcodes:
                        material = InventoryMaterial.objects.get(barcode=barcode)
                        this_obj = material.obj()
                        this_obj['issued'] = IssueTransaction.objects.filter(material=material,issue__contractor=contractor).aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
                        this_obj['consumed'] = MaterialOrderItem.objects.filter(material=material,service_order__contractor=contractor,material_type='is').aggregate(total_qty=Sum('quantity'))['total_qty'] or 0
                        this_obj['balance'] = this_obj['issued'] - this_obj['consumed']
                        negative_balance = this_obj['balance'] * -1
                        this_obj['value'] = negative_balance * material.value
                        this_obj['rate'] = material.value
                        arr.append(this_obj)
                except Exception as e:
                    success_response['status_code'] = 505
                    arr = f"Error: {e}"


            elif module == 'returns':
                contractor_id = data.get('contractor_id')
                contractor = Contractor.objects.get(id=contractor_id)
                returns = ServiceOrderReturns.objects.filter(service_order__contractor=contractor)
                for rt in returns:
                    this_obj = rt.material.obj()
                    this_obj['expected'] = rt.quantity
                    this_obj['returned'] = IssueTransaction.objects.filter(material=rt.material,issue__contractor=contractor,issue__issue_type='RET').aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
                    this_obj['balance'] = this_obj['expected'] - this_obj['returned']
                    this_obj['total_value'] = this_obj['balance'] * rt.material.value
                    this_obj['rate'] = rt.material.value
                    arr.append(this_obj)

            elif module == 'jobs':
                contractor_id = data.get('contractor_id')
                contractor = Contractor.objects.get(id=contractor_id)
                jobs = ServiceOrder.objects.filter(contractor=contractor)
                
                for job in jobs:
                    arr.append(job.obj())

            elif module == 'issued_recievable_balance':
                contractor_id = data.get('contractor_id')

                transactions = []
                total = 0

                contractor = Contractor.objects.get(id=contractor_id)
                for issue in IssueTransaction.objects.filter(issue__contractor=contractor,issue__issue_type='ISS'):
                    material = issue.material.obj()
                    total_qty = issue.total_qty
                    total_value = total_qty * material['value']

                    total_used = MaterialOrderItem.objects.filter(service_order__contractor=contractor,material=issue.material,material_type='is').aggregate(total_qty=Sum('quantity'))['total_qty'] or 0    
                    total_used_value = total_used * material['value']

                    total_diff = total_value - total_used_value
                    total += total_diff
                    transactions.append({
                        'material':material,
                        'total_qty':total_qty,
                        'total_value':total_value,
                        'total_used':total_used,
                        'total_used_value':total_used_value,
                        'total_diff':total_diff
                    })

                arr = {
                    'transactions':transactions,
                    'total':total
                }

            elif module == 'recievable':
                contractor_id = data.get('contractor_id')
                contractor = Contractor.objects.get(id=contractor_id)
                total_returns = 0
                total_usage = 0
                total_balance = 0
                obj = []

                for material in InventoryMaterial.objects.all():
                    # returns
                    stated_returns = ServiceOrderReturns.objects.filter(material=material,service_order__contractor=contractor).aggregate(total_qty=Sum('quantity'))['total_qty'] or 0
                    actual_returns = IssueTransaction.objects.filter(material=material,issue__contractor=contractor,issue__issue_type='RET').aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
                    returns_diff = actual_returns - stated_returns 
                    returns_balance = returns_diff * material.value
                    total_returns += returns_balance

                    # usage in service orders
                    stated_usage = MaterialOrderItem.objects.filter(material=material,material_type='is').aggregate(total_qty=Sum('quantity'))['total_qty'] or 0
                    issued_for_service_orders = IssueTransaction.objects.filter(material=material,issue__contractor=contractor,issue__issue_type='ISS').aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
                    usage_diff = stated_usage - issued_for_service_orders
                    usage_balance = usage_diff * material.value
                    total_usage += usage_balance

                    # balance
                    balance = returns_balance + usage_balance
                    total_balance += balance
                    total_usage += usage_balance
                    total_returns += returns_balance


                    this_obj = {
                        'material':material.obj(),
                        'returns':returns_balance,
                        'usage':usage_balance,
                        'balance':balance
                    }

                    obj.append(this_obj)

                arr = {
                    'total_returns':total_returns,
                    'total_usage':total_usage,
                    'total_balance':total_balance,
                    'transactions':obj
                }
                

            elif module == 'payable':
                contractor_id = data.get('contractor_id')
                contractor = Contractor.objects.get(id=contractor_id)
                payable = ServiceOrderItem.objects.filter(service_order__contractor=contractor).aggregate(total_amount=Sum('amount'))['total_amount'] or 0
                arr = payable

            
            elif module == 'plots':
                try:
                    contractor_id = data.get('contractor_id')
                    contractor = Contractor.objects.get(id=contractor_id)
                    if contractor_id == '*':
                        arr = [plot.obj() for plot in Plot.objects.all()]
                    else:
                        arr = [plot.obj() for plot in Plot.objects.filter(contractor=contractor)]
                    
                except Exception as e:
                    success_response['status_code'] = 500
                    arr = str(e)


            success_response['message'] = arr

        elif method == 'DELETE':
            pass

        elif method == 'PATCH':
            pass

        else:
            response['message'] = "Invalid Method"

        response = success_response

    
    except Exception as e:
        response['message'] = str(e)
        return JsonResponse(response, status=400)
    
    return JsonResponse(success_response, status=200)
