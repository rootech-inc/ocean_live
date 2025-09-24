import json
import sys
from http.client import responses

from django.contrib.auth.models import User
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

from admin_panel.models import Locations, TransferHD, TransferTran, ProductMaster, UserAddOns, ProductTrans
from admin_panel.views import bank_posts
from inventory.models import Evidence
from retail.models import Products
from django.db.models import Q


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

    error_response = {
        'status_code': 505,
        'message': "Procedure Failed"
    }

    # get method
    method = request.method

    try:

        body = json.loads(request.body)
        module = body.get('module')
        data = body.get('data')

        if method == 'PUT':
            if module == 'product':
                pass

            elif module == 'transfer':
                header = data.get("header")
                transactions = data.get("transactions")
                mypk = header.get('mypk')
                owner = User.objects.get(pk=mypk)

                l_from = header.get('loc_from')
                l_to = header.get('loc_to')

                loc_from = Locations.objects.get(pk=l_from)
                loc_to = Locations.objects.get(pk=l_to)
                remarks = header.get("remarks")

                entry_no = f"TR{loc_from.code}{TransferHD.objects.filter(loc_fr=loc_from).count() + 1}"

                try:
                    TransferHD(
                        entry_no=entry_no,loc_fr=loc_from,remarks=remarks,loc_to=loc_to,created_by=owner
                    ).save()
                    thd = TransferHD.objects.get(entry_no=entry_no)
                    line = 1
                    for tr in transactions:
                        print(tr)
                        TransferTran(
                            parent=thd,
                            line = line,
                            product = ProductMaster.objects.get(barcode=tr['barcode']),
                            packing = tr['packing'],
                            pack_qty = tr['pack_qty'],
                            tran_qty = tr['tran_qty'],
                            unit_cost = tr['unit_cost'],
                            cost = tr['total_cost'],
                        ).save()
                        line += 1
                    success_response['message'] = f"Transfer Saved {entry_no}"
                    response = success_response
                except Exception as e:
                    TransferHD.objects.filter(entry_no=entry_no).delete()
                    error_response['message'] = f"Transfer Failed: {e}"
                    response = error_response

            elif module == 'issue':
                # Get data from request
                location_id = data.get('issue_location')
                qty = data.get('issue_qty')
                remarks = data.get('issue_remarks')
                barcode = data.get('barcode')

                try:
                    location = Locations.objects.get(pk=location_id)
                    product = ProductMaster.objects.get(barcode=barcode)
                    qty = float(qty)

                    # Negate quantity since it is to reduce stock
                    qty = -abs(qty)

                   

                    ProductTrans.objects.create(
                        product=product,
                        loc=location,
                        doc_ref='ISSUE',
                        tran_qty=qty,
                        doc='IS'
                    )

                    success_response['message'] = f"Issued {abs(qty)} of {product.shrt_descr} from {location.code}"
                    response = success_response
                except Exception as e:
                    error_response['message'] = f"Issue Failed: {e}"
                    response = error_response

            else:
                error_response['message'] = 'Invalid Module'
                response = error_response

        elif method == 'VIEW':
            print(data)
            # view transfer in window
            arr = []
            if module == 'transfer':
                doc = data.get("doc")
                pk = data.get("pk")
                status = data.get("status")
                frm = data.get("from")
                to = data.get("to")

                hds = TransferHD.objects.all()

                if pk is not None:
                    print(pk)
                    hds = hds.filter(pk=pk)

                if status:
                    if status == 1:
                        hds = hds.filter(is_sent=True)
                    elif status == 2:
                        hds = hds.filter(is_posted=True)

                if frm:
                    hds = hds.filter(loc_fr_id=frm)

                if to:
                    hds = hds.filter(loc_to_id=to)

                for hd in hds:
                    obj = {
                        "header":hd.obj()
                    }

                    # get transactions
                    trans = []
                    transactions = TransferTran.objects.filter(parent=hd)
                    for tran in transactions:
                        trans.append(tran.obj())

                    obj['transactions'] = trans
                    arr.append(obj)

                success_response['message'] = arr
                response = success_response
                print(responses)

            elif module == 'product':
                key = data.get('key')
                
                try:    
                    products = ProductMaster.objects.filter(Q(barcode__icontains=key) | Q(descr__icontains=key))
                    success_response['message'] = [p.obj() for p in products]
                    response = success_response
                except Exception as e:
                    error_response['message'] = f"Product Not Found: {e}"
                    response = error_response

        elif method == 'PATCH':
            if module == 'transfer':
                header = data.get("header")

                transactions = data.get("transactions")
                mypk = header.get('mypk')
                owner = User.objects.get(pk=mypk)

                l_from = header.get('loc_from')
                l_to = header.get('loc_to')

                loc_from = Locations.objects.get(pk=l_from)
                loc_to = Locations.objects.get(pk=l_to)
                remarks = header.get("remarks")

                entry_no = header.get('entry_no')

                try:

                    thd = TransferHD.objects.get(entry_no=entry_no)
                    thd.remarks = remarks
                    thd.loc_fr = loc_from
                    thd.loc_to = loc_to
                    line = 1
                    # delete transactions
                    TransferTran.objects.filter(parent=thd).delete()
                    for tr in transactions:
                        print(tr)
                        TransferTran(
                            parent=thd,
                            line = line,
                            product = ProductMaster.objects.get(barcode=tr['barcode']),
                            packing = tr['packing'],
                            pack_qty = tr['pack_qty'],
                            tran_qty = tr['tran_qty'],
                            unit_cost = tr['unit_cost'],
                            cost = tr['total_cost'],
                        ).save()
                        line += 1
                    thd.save()
                    success_response['message'] = f"Transfer Saved {entry_no}"
                    response = success_response
                except Exception as e:
                    # TransferHD.objects.filter(entry_no=entry_no).delete()
                    error_response['message'] = f"Transfer Failed: {e}"
                    response = error_response

            elif module == 'send_transfer':
                entry_no = data.get('entry_no')
                my_pk = data.get('mypk')
                delivery_by = data.get('delivery_by')



                transfer = TransferHD.objects.get(entry_no = entry_no)
                transfer.is_sent = True
                transfer.sent_by = User.objects.get(pk=my_pk)
                transfer.delivery_by = delivery_by
                transfer.save()

                response = success_response

            elif module == 'post_transfer':
                try:
                    recieved_by = data.get('recieved_by')
                    rec_remark = data.get('rec_remark')
                    entry_no = data.get('entry_no')
                    mypk = data.get('mypk')

                    transfer = TransferHD.objects.get(entry_no=entry_no)
                    rec_by = UserAddOns.objects.get(pk=recieved_by).user
                    approved_by = User.objects.get(pk=mypk)

                    # post transfer into stock
                    from_loc = transfer.loc_fr
                    sent_to = transfer.loc_to

                    transactions = TransferTran.objects.filter(parent=transfer)
                    ProductTrans.objects.filter(doc='TR',doc_ref=entry_no).delete()
                    Evidence.objects.filter(doc_type='TR',entry=entry_no).delete()
                    for tr in transactions:
                        qty_to = tr.tran_qty * tr.pack_qty

                        q_2 = qty_to * 2
                        qty_fr = qty_to - q_2

                        ProductTrans(loc=from_loc,doc='TR',doc_ref=entry_no,product=tr.product,
                                     tran_qty=qty_fr,created_on=transfer.created_on).save()

                        ProductTrans(loc=sent_to, doc='TR', doc_ref=entry_no, product=tr.product,
                                     tran_qty=qty_to, created_on=transfer.created_on).save()



                    transfer.reccieved_by = rec_by
                    transfer.approved_by = approved_by
                    transfer.rec_remark = rec_remark
                    transfer.is_posted = True
                    transfer.save()

                    response = success_response
                except Exception as e:
                    raise Exception(e)

        else:
            error_response['message'] = f"Method Not Allowed: {method}"
            response = error_response

    except Exception as e:
        error_type, error_instance, traceback = sys.exc_info()
        tb_path = traceback.tb_frame.f_code.co_filename
        line_number = traceback.tb_lineno
        response["status_code"] = 500
        response[
            "message"] = f"An error of type {error_type} occurred on line {line_number} in file {tb_path}. Details: {e}"

    return JsonResponse(response, safe=False)