
from django.db.models import Sum, F
from ssml.models import Contractor, InventoryMaterial, IssueTransaction, MaterialOrderItem, ServiceOrderReturns


def returns(contractor_id):
    contractor = Contractor.objects.get(id=contractor_id)
    returns = ServiceOrderReturns.objects.filter(service_order__contractor=contractor)
    total_returns = 0
    transactions = []
    for rt in returns:
                    this_obj = rt.material.obj()
                    this_obj['expected'] = rt.quantity
                    this_obj['returned'] = IssueTransaction.objects.filter(material=rt.material,issue__contractor=contractor,issue__issue_type='RET').aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
                    this_obj['balance'] = this_obj['returned'] - this_obj['expected']
                    this_obj['total_value'] = this_obj['balance'] * rt.material.value
                    this_obj['rate'] = rt.material.value
                    total_returns += this_obj['total_value']
                    transactions.append(this_obj)

    return {
                    'transactions':transactions,
                    'total':total_returns
                }


def material_differences(contractor_id):
        contractor = Contractor.objects.get(id=contractor_id)
        barcodes = IssueTransaction.objects.filter(issue__contractor=contractor,issue__issue_type='ISS').values_list('barcode', flat=True).distinct()
        total_value = 0

        transactions = []
        for barcode in barcodes:
            material = InventoryMaterial.objects.get(barcode=barcode)
            this_obj = material.obj()
            this_obj['issued'] = IssueTransaction.objects.filter(material=material,issue__contractor=contractor,issue__issue_type='ISS').aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
            this_obj['consumed'] = MaterialOrderItem.objects.filter(material=material,service_order__contractor=contractor,material_type='is').aggregate(total_qty=Sum('quantity'))['total_qty'] or 0
            this_obj['balance'] = this_obj['issued'] - this_obj['consumed']
            negative_balance = this_obj['balance'] * -1
            this_obj['value'] = negative_balance * material.value
            this_obj['rate'] = material.value
            total_value = this_obj['value']
            print(total_value)
            transactions.append(this_obj)
            
        return {
                'trancactions':transactions,
                'total':total_value
        }
                        