
from django.db.models import Sum, F
from ssml.models import Contractor, InventoryMaterial, IssueTransaction, Ledger, MaterialOrderItem, ServiceOrderReturns


def returns(contractor_id):
    contractor = Contractor.objects.get(id=contractor_id)
    returns = ServiceOrderReturns.objects.filter(service_order__contractor=contractor).values_list('material_id',flat=True).distinct()
    total_returns = 0
    transactions = []
    for rt in returns:
                        material = InventoryMaterial.objects.get(id=rt)
                        this_obj = material.obj()
                        this_obj['expected'] = ServiceOrderReturns.objects.filter(service_order__contractor=contractor,material=material).aggregate(tot_qty=Sum('quantity'))['tot_qty'] or 0
                        this_obj['returned'] = IssueTransaction.objects.filter(material=material,issue__contractor=contractor,issue__issue_type='RET').aggregate(total_qty=Sum('total_qty'))['total_qty'] or 0
                        this_obj['balance'] = this_obj['returned'] - this_obj['expected']
                        this_obj['total_value'] = this_obj['balance'] * material.value
                        this_obj['rate'] = material.value
                        total_returns += this_obj['total_value']
                        transactions.append(this_obj)

    arr = {
                        'transactions':transactions,
                        'total':total_returns
                    }
    
    print("HELPER")
    print(arr['total'])
    print("HELPER")
    
    return arr


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
            total_value += this_obj['value']
            
            transactions.append(this_obj)
            
        return {
                'trancactions':transactions,
                'total':total_value
        }

def lederhd(contractor_id):
        rets = returns(contractor_id)['total']
        issued = material_differences(contractor_id)['total']
        debit = rets + issued

        print(f"RETUNR: {rets}\nISSUE: {issued}\nDEBIT: {debit}\n")

        
        credit = Ledger.objects.filter(contractor_id=contractor_id,transaction_type='credit').aggregate(total_credit=Sum('amount'))['total_credit'] or 0

        balance = credit + debit

        return {
                'total_credit':credit,
                'total_debit':debit,
                'total_balance':balance
        }


                        