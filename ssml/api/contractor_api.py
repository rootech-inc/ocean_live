import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.db.models import Sum, F

from ssml.models import Contractor, InventoryMaterial, IssueTransaction, Ledger, MaterialOrderItem, Plot, RedeemTransactions, ServiceOrder, ServiceOrderItem, ServiceOrderReturns


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
                    barcodes = IssueTransaction.objects.filter(issue__contractor=contractor,issue__issue_type='ISS').values_list('barcode', flat=True).distinct()
                    for barcode in barcodes:
                        material = InventoryMaterial.objects.get(barcode=barcode)
                        print(barcode)
                        this_obj = material.obj()
                        this_obj['issued'] = IssueTransaction.objects.filter(material=material,issue__contractor=contractor,issue__issue_type='ISS').aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
                        this_obj['consumed'] = MaterialOrderItem.objects.filter(material=material,service_order__contractor=contractor,material_type='is').aggregate(total_qty=Sum('quantity'))['total_qty'] or 0
                        this_obj['redeemed'] = RedeemTransactions.objects.filter(material=material,redeem__contractor=contractor,redeem__transaction_type='ISS').aggregate(total_qty=Sum('qty'))['total_qty'] or 0
                        this_obj['balance'] = this_obj['issued'] - this_obj['consumed'] + this_obj['redeemed']
                        negative_balance = this_obj['balance'] * -1
                        this_obj['value'] = negative_balance * material.value
                        this_obj['rate'] = material.value
                        arr.append(this_obj)
                except Exception as e:
                    success_response['status_code'] = 505
                    arr = f"Error: {e}"


            elif module == 'returns':
                try:
                    contractor_id = data.get('contractor_id')
                    contractor = Contractor.objects.get(id=contractor_id)
                    returns = ServiceOrderReturns.objects.filter(service_order__contractor=contractor).values_list('material_id',flat=True).distinct()
                    total_returns = 0
                    transactions = []
                    for rt in returns:
                        material = InventoryMaterial.objects.get(id=rt)
                        this_obj = material.obj()
                        this_obj['expected'] = ServiceOrderReturns.objects.filter(service_order__contractor=contractor,material=material).aggregate(tot_qty=Sum('quantity'))['tot_qty'] or 0
                        this_obj['redeemed'] = RedeemTransactions.objects.filter(material=material,redeem__contractor=contractor,redeem__transaction_type='RET').aggregate(total_qty=Sum('qty'))['total_qty'] or 0
                        this_obj['returned'] = IssueTransaction.objects.filter(material=material,issue__contractor=contractor,issue__issue_type='RET').aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
                        this_obj['balance'] = this_obj['returned'] - this_obj['expected'] + this_obj['redeemed']
                        this_obj['total_value'] = this_obj['balance'] * material.value
                        this_obj['rate'] = material.value
                        total_returns += this_obj['total_value']
                        transactions.append(this_obj)

                    arr = {
                        'transactions':transactions,
                        'total':total_returns
                    }
                    print(arr['total'])
                
                except Exception as e:
                    success_response['status_code'] = 505
                    arr = str(e)

            elif module == 'credit_ledger_summary':
                contractor_id = data.get('contractor_id')
                contractor = Contractor.objects.get(id=contractor_id)
                ledger = Ledger.objects.filter(contractor=contractor,transaction_type='credit')
                total_credit = ledger.aggregate(total_credit=Sum('amount'))['total_credit'] or 0
                total_debit = ledger.aggregate(total_debit=Sum('amount'))['total_debit'] or 0
                total_balance = total_credit - total_debit
                arr = {
                    'total_credit':total_credit,
                    'total_debit':total_debit,
                    'total_balance':total_balance
                }

            elif module == 'debit_summary':
                try:
                    from ..helper import returns,material_differences
                    contractor_id = data.get('contractor_id')
                    contractor = Contractor.objects.get(id=contractor_id)
                    rt = returns(contractor_id)
                    mt = material_differences(contractor_id)

                    total = rt['total'] + mt['total']
                    arr = {
                        'returns':rt['total'],
                        'materials':mt['total'],
                        'total':total
                    }

                except Exception as e:
                    success_response['status_code'] = 500
                    arr = str(e)

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
                try:
                    contractor_id = data.get('contractor_id')
                    contractor = Contractor.objects.get(id=contractor_id)
                    total_returns = 0
                    total_usage = 0
                    total_balance = 0
                    obj = []

                    for material in InventoryMaterial.objects.all():
                        # returns
                        stated_returns = ServiceOrderReturns.objects.filter(material=material,service_order__contractor=contractor_id).aggregate(total_qty=Sum('quantity'))['total_qty'] or 0
                        actual_returns = IssueTransaction.objects.filter(material=material,issue__contractor=contractor_id,issue__issue_type='RET').aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
                        returns_diff = actual_returns - stated_returns 
                        returns_balance = returns_diff * material.value


                        # usage in service orders
                        stated_usage = MaterialOrderItem.objects.filter(material=material,material_type='is',service_order__contractor=contractor).aggregate(total_qty=Sum('quantity'))['total_qty'] or 0
                        issued_for_service_orders = IssueTransaction.objects.filter(material=material,issue__contractor=contractor_id,issue__issue_type='ISS').aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
                        usage_diff = stated_usage - issued_for_service_orders
                        usage_balance = usage_diff * material.value

                        # balance
                        balance = returns_balance + usage_balance
                        total_returns += returns_balance
                        total_usage += usage_balance
                        total_balance += balance

                        this_obj = {
                            'material':material.obj(),
                            'returns_balance':returns_balance,
                            'usage_balance':usage_balance,
                            'balance':balance
                        }
                        obj.append(this_obj)

                    arr = {
                        'total_returns':total_returns,
                        'total_usage':total_usage,
                        'total_balance':total_balance,
                        'transactions':obj
                    }



                except Exception as e:
                    success_response['status_code'] = 505
                    arr = str(e)

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

            elif module == 'contractor_usage':
                try:
                    barcode = data.get('barcode')
                    contractor_id = data.get('contractor_id')
                    contractor = Contractor.objects.get(id=contractor_id)
                    trans = []
                    for usage in MaterialOrderItem.objects.filter(service_order__contractor=contractor,material__barcode=barcode):
                        item = usage.material
                        trans.append({
                            'barcode':item.barcode,
                            'name':item.name,
                            'meter':usage.service_order.new_meter,
                            'quantity':usage.quantity
                        })

                    arr = trans
                except Exception as e:
                    success_response['status_code'] = 500
                    arr = str(e)


            elif module == 'contractor_issue':
                contractor_id = data.get('issue_contractor')
                contractor = Contractor.objects.get(id=contractor_id)
                issue_type = data.get('issue_type','ISS')
                mat_barcode = data.get('mat_barcode')
                for issue in IssueTransaction.objects.filter(issue__issue_type=issue_type,issue__contractor=contractor,barcode=mat_barcode).order_by('issue__issue_date'):
                    arr.append(issue.obj())

                success_response['message'] = arr
                

            elif module == 'service_order':
                try:
                    id = data.get('contractor_id')
                    import openpyxl
                    contractor = Contractor.objects.get(id=id)
                    doc = data.get('document')
                    if doc == 'excel':
                        book = openpyxl.Workbook()
                        sheet = book.active
                        hd = ["DATE","TYPE","METER","CUSTOMER","AMOUNT"]
                        sheet.append(hd)
                    for service in ServiceOrder.objects.filter(contractor=contractor).order_by('service_date'):
                        li = [service.service_date,service.service_type.name,service.new_meter,service.customer,service.total_amount()]
                        if doc == 'excel':
                            sheet.append(li)

                    if doc == 'excel':
                        file = f"static/general/tmp/{contractor.company}.xlsx"
                        book.save(file)
                        arr = file

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
