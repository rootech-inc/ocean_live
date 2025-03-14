import json
import sys
from decimal import Decimal
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.db.models import Q
from django.contrib.auth.models import User


from ssml.models import Cardex, Contractor, InventoryGroup, InventoryMaterial, Issue, IssueTransaction, Ledger, MaterialOrderItem, Meter, Plot, Service, ServiceOrder, ServiceOrderItem, ServiceOrderReturns, ServiceType, Supplier, Grn, GrnTransaction


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
                link = data.get('link')
                company = data.get('company')
                owner = data.get('owner')
                phone = data.get('phone')
                email = data.get('email')
                country = data.get('country')
                city = data.get('city')
                postal_code = data.get('postal_code')
                gh_post_code = data.get('gh_post_code')
                gh_card_no = data.get('gh_card_no')
                created_by = User.objects.get(id=data.get('mypk'))
                Contractor.objects.create(link=link,company=company, owner=owner, phone=phone,email=email,country=country,
                                          city=city,postal_code=postal_code,gh_card_no=gh_card_no,gh_post_code=gh_post_code,created_by=created_by)

                success_response['message'] = "Contractor Created Successfully"
            
            elif module == 'group':
                name = data.get('name')
                InventoryGroup.objects.create(name=name)
                success_response['message'] = "Group Created Successfully"
            elif module == 'material':
                barcode = data.get('barcode')
                name = data.get('name')
                group = InventoryGroup.objects.get(id=data.get('group'))
                reorder_qty = data.get('reorder_qty')
                value = data.get('value')
                InventoryMaterial.objects.create(
                    barcode=barcode,
                    name=name,
                    group=group,
                    reorder_qty=reorder_qty,
                    value=value
                )
                success_response['message'] = "Material Created Successfully"

            elif module == 'supplier':
                supplier_name = data.get('supplier_name')
                contact_person = data.get('contact_person')
                supplier_address = data.get('supplier_address')
                supplier_phone = data.get('supplier_phone')
                supplier_email = data.get('supplier_email')
                Supplier.objects.create(supplier_name=supplier_name, contact_person=contact_person, supplier_address=supplier_address, supplier_phone=supplier_phone, supplier_email=supplier_email)
                success_response['message'] = "Supplier Created Successfully"

            elif module == 'grn':
                try:
                    supplier = Supplier.objects.get(id=data.get('supplier'))
                    grn_date = data.get('grn_date')
                    remarks = data.get('remarks')
                    grn_type = data.get('grn_type')
                    created_by = User.objects.get(id=data.get('created_by'))
                    grn = Grn.objects.create(
                        supplier=supplier, 
                        grn_date=grn_date, 
                        remarks=remarks, 
                        grn_type=grn_type, 
                        created_by=created_by,
                        total_amount=0,
                        total_qty=0,
                        grn_no = f"GRN-{Grn.objects.all().count() + 1}"
                        )
                    total_amount = 0
                    total_qty = 0
                    for transaction in data.get('transactions'):
                        material = InventoryMaterial.objects.get(barcode=transaction.get('barcode'))
                        barcode = transaction.get('barcode')
                        name = transaction.get('name')
                        amount = transaction.get('amount')
                        pack_qty = transaction.get('pack_qty')
                        uom = transaction.get('uom')
                        rate = transaction.get('rate')
                        qty = transaction.get('qty')
                        total_qty = Decimal(qty) * Decimal(pack_qty)
                        GrnTransaction.objects.create(
                            grn=grn, 
                            material=material, 
                            barcode=barcode, 
                            name=name, 
                            amount=amount, 
                            pack_qty=pack_qty, 
                            uom=uom, 
                            rate=rate, 
                            qty=qty, 
                            total_qty=total_qty)
                        total_amount += Decimal(amount)
                        total_qty += Decimal(total_qty)

                    grn.total_amount = total_amount
                    grn.total_qty = total_qty
                    grn.save()
                        
                    success_response['message'] = "GRN Created Successfully"
                except Exception as e:
                    # Roll back any GRN transactions created
                    if 'grn' in locals():
                        GrnTransaction.objects.filter(grn=grn).delete()
                        grn.delete()
                    success_response['status_code'] = 400
                    success_response['message'] = f"Error on line {sys.exc_info()[2].tb_lineno}: {e}"
                
            elif module == 'issue':
                next_no = Issue.objects.all().last()
                if Issue.objects.all().count() > 0:
                    issue_no = f"IS-{next_no.id + 1}"
                else:
                    issue_no = f"IS-1"
                try:
                    contractor = Contractor.objects.get(id=data.get('contractor'))
                    issue_date = data.get('issue_date')
                    remarks = data.get('remarks')
                    issue_type = data.get('issue_type')
                    created_by = User.objects.get(id=data.get('created_by'))
                        
                    issue = Issue.objects.create(
                        contractor=contractor,
                        issue_date=issue_date,
                        remarks=remarks,
                        issue_type=issue_type,
                        created_by=created_by,
                        issue_no=issue_no
                    )
                    total_amount = 0
                    total_qty = 0
                    for transaction in data.get('transactions'):
                        material = InventoryMaterial.objects.get(barcode=transaction.get('barcode'))
                        barcode = transaction.get('barcode')
                        name = transaction.get('name')
                        amount = transaction.get('amount')
                        pack_qty = transaction.get('pack_qty')
                        uom = transaction.get('uom')
                        rate = transaction.get('rate')
                        qty = transaction.get('qty')
                        total_qty = Decimal(qty) * Decimal(pack_qty)
                        IssueTransaction.objects.create(
                            issue=issue,
                            material=material,
                            barcode=barcode,
                            name=name,
                            amount=amount,
                            pack_qty=pack_qty,
                            uom=uom,
                            rate=rate,
                            qty=qty,
                            total_qty=total_qty)

                    issue.total_amount = total_amount
                    issue.total_qty = total_qty

                    for meter in data.get('meters'):
                        Meter.objects.create(meter_no=meter, contractor=contractor, created_by=created_by, issue=issue)

                    issue.save()

                    success_response['message'] = "Issue Created Successfully"
                except Exception as e:
                    # Roll back any Issue transactions created
                    if 'issue' in locals():
                        Issue.objects.filter(issue_no=issue_no).delete()
                        issue.delete()  
                    success_response['status_code'] = 400
                    success_response['message'] = f"Error on line {sys.exc_info()[2].tb_lineno}: {e}"
            
            elif module == 'plot':
                plot_no = data.get('plot-no')
                contractor = Contractor.objects.get(id=data.get('contractor'))
                plot_size = data.get('plot-size')
                created_by = User.objects.get(id=data.get('mypk'))
                Plot.objects.create(plot_no=plot_no, contractor=contractor, plot_size=plot_size,created_by=created_by)
                success_response['message'] = "Plot Created Successfully"

            elif module == 'service_type':
                name = data.get('service_name')
                description = data.get('service_description')
                created_by = User.objects.get(id=data.get('mypk'))
                ServiceType.objects.create(name=name, description=description, created_by=created_by)
                success_response['message'] = "Service Type Created Successfully"

            elif module == 'service':
                code = f"SRV-{Service.objects.all().count() + 1}"
                name = data.get('service_name')
                description = data.get('service_description')
                rate = data.get('service_rate')
                uom = data.get('service_uom')
                created_by = User.objects.get(id=data.get('mypk'))
                Service.objects.create(code=code, name=name, description=description, rate=rate, uom=uom, created_by=created_by)
                success_response['message'] = "Service Created Successfully"

            elif module == 'service_order':
                service_type = ServiceType.objects.get(id=data.get('service-type'))
                service_date = data.get('service-date')
                contractor = Contractor.objects.get(id=data.get('contractor'))
                plot = Plot.objects.get(plot_no=data.get('plot'))
                geo_code = data.get('geo-code')
                customer = data.get('customer')
                customer_no = data.get('customer_no')
                old_meter_no = data.get('old_meter_no')
                new_meter_no = data.get('new_meter_no')
                meter = Meter.objects.get(meter_no=new_meter_no)
                # check if meter belongs to contractor
                if meter.issue.contractor != contractor:
                    raise Exception("Meter Does Not Belong To Contractor")

                # check if meter is already issued
                if meter.is_issued:
                    raise Exception("Meter Already Issued")

                created_by = User.objects.get(id=data.get('mypk'))
                service_order = ServiceOrder.objects.create(service_type=service_type, service_date=service_date, contractor=contractor, plot=plot, geo_code=geo_code, customer=customer, customer_no=customer_no, old_meter_no=old_meter_no, new_meter=meter, created_by=created_by)
                meter.is_issued = True
                meter.service_order = service_order
                meter.save()
                success_response['message'] = "Service Order Created Successfully"

            elif module == 'service_order_item':
                service_order = ServiceOrder.objects.get(id=data.get('order_id'))
                service = Service.objects.get(id=data.get('service_id'))
                quantity = data.get('serv_qty')
                rate = service.rate
                amount = Decimal(quantity) * Decimal(rate)
                ServiceOrderItem.objects.create(service_order=service_order, service=service, quantity=quantity, rate=rate, amount=amount)
                success_response['message'] = "Service Order Item Created Successfully"
                
            elif module == 'material_order_item':
                service_order = ServiceOrder.objects.get(id=data.get('order_id'))
                material = InventoryMaterial.objects.get(id=data.get('material_id'))
                quantity = data.get('mat_qty')
                material_type = data.get('mat_type')
                
                rate = 0
                amount = Decimal(quantity) * Decimal(rate)
                MaterialOrderItem.objects.create(service_order=service_order, material=material, quantity=quantity, rate=rate, amount=amount, material_type=material_type)
                success_response['message'] = "Material Order Item Created Successfully"

            elif module == 'service_order_return':
                service_order = ServiceOrder.objects.get(id=data.get('server_order_id'))
                material = InventoryMaterial.objects.get(id=data.get('material_id'))
                quantity = data.get('ret_qty')
                user = User.objects.get(id=data.get('mypk'))
                ServiceOrderReturns.objects.create(service_order=service_order, material=material, quantity=quantity, created_by=user, modified_by=user)
                success_response['message'] = "Service Order Return Created Successfully"

            elif module == 'service_order_new':
                header = data.get('header')
                mats = data.get('materials')
                services = data.get('services')
                returns = data.get('returns')
                user = User.objects.get(id=header.get('mypk'))

                # print(mats)
                # raise Exception("Test End")

                # validate meter
                new_meter_no = header.get('new_meter_no')
                contractor = Contractor.objects.get(id=header.get('contractor'))
                print(new_meter_no)
                meter = Meter.objects.get(meter_no=header.get('new_meter_no'))

                # check if meter belongs to contractor
                if meter.issue.contractor != contractor:
                    raise Exception("Meter Does Not Belong To Contractor")

                # check if meter is already issued
                if meter.is_issued:
                    raise Exception("Meter Already Issued")



                try:
                    # create service order
                    service_order = ServiceOrder.objects.create(
                        service_type_id=header.get('service_type'),
                        service_date=header.get('service_date'),
                        contractor_id=header.get('contractor'),
                        plot_id=header.get('plot'),
                        geo_code=header.get('cust_code'),
                        customer=header.get('customer'),
                        customer_no=header.get('customer_no'),
                        old_meter_no=header.get('old_meter_no'),
                        new_meter=meter.meter_no,
                        created_by=user,
                        old_meter_no_reading=header.get('old_meter_no_reading'),
                        new_meter_no_reading=header.get('new_meter_no_reading')
                    )

                    # create service order items
                    for service in services:
                        r_service = Service.objects.get(code=service.get('code'))
                        ServiceOrderItem.objects.create(
                            service_order=service_order,
                            service=Service.objects.get(code=service.get('code')),
                            rate=r_service.rate,
                            quantity=service.get('quantity'),
                            amount=Decimal(service.get('quantity')) * Decimal(r_service.rate)
                        )
                    
                    # create material order items
                    for mat in mats:
                        mt = InventoryMaterial.objects.get(barcode=mat.get('barcode'))
                        MaterialOrderItem.objects.create(
                            service_order=service_order,
                            material=InventoryMaterial.objects.get(barcode=mat.get('barcode')),
                            quantity=mat.get('quantity'),
                            material_type='is',
                            rate=mt.value,
                            amount=Decimal(mt.value) * Decimal(mat.get('quantity'))
                        )

                    # automate materials add
                    for ret_item in InventoryMaterial.objects.filter(is_return=True):
                        try:
                            MaterialOrderItem.objects.create(
                                service_order=service_order,
                                material=ret_item,
                                quantity=1,
                                material_type='is',
                                rate=ret_item.value,
                                amount=Decimal(mt.value) * Decimal(mat.get('quantity'))
                            )
                        except Exception as e:
                            pass
                    
                    # create service order returns
                    for rt in returns:
                        ServiceOrderReturns.objects.create(
                            service_order=service_order,
                            material=InventoryMaterial.objects.get(barcode=rt.get('barcode')),
                            quantity=rt.get('quantity'),
                            created_by=user,
                            modified_by=user
                        )

                    # add automatic returns
                    for ret_item in InventoryMaterial.objects.filter(is_return=True):
                        try:
                            ServiceOrderReturns.objects.create(
                                service_order=service_order,
                                material=ret_item,
                                quantity=1,
                                created_by=user,
                                modified_by=user
                            )
                        except Exception as e:
                            pass

                    

                    meter.is_issued = True
                    meter.service_order = service_order
                    meter.save()

                    success_response['message'] = "Service Order Created Successfully"
                except Exception as e:
                    # delete service order if created
                    if 'service_order' in locals():
                        service_order.delete()
                    success_response['status_code'] = 400
                    success_response['message'] = f"Error on line {sys.exc_info()[2].tb_lineno}: {e}"

            else:
                success_response['status_code'] = 400
                success_response['message'] = f"Module Not Found"



        elif method == 'VIEW':
                if module == 'contractor':
                    id = data.get('id','*') 
                    if id == '*':
                        contractors = Contractor.objects.all().order_by('company')
                        success_response['message'] = [contractor.obj() for contractor in contractors]
                    else:
                        contractor = Contractor.objects.get(id=id)
                        success_response['message'] = contractor.obj()

                elif module == 'group':
                    id = data.get('id','*')
                    if id == '*':
                        groups = InventoryGroup.objects.all()
                        success_response['message'] = [group.obj() for group in groups]
                    else:
                        group = InventoryGroup.objects.get(id=id)
                        success_response['message'] = group.obj()
                elif module == 'material':
                    id = data.get('id','*')
                    if id == '*':
                        materials = InventoryMaterial.objects.all().order_by('name')
                        success_response['message'] = [material.obj() for material in materials]
                    else:
                        if id.isdigit():
                            material = InventoryMaterial.objects.get(id=id)
                            success_response['message'] = material.obj()
                        else:
                            material = InventoryMaterial.objects.filter(Q(barcode__icontains=id) | Q(name__icontains=id))
                            success_response['message'] = [m.obj() for m in material]
                       

                elif module == 'meter':
                    meter_no=data.get('meter_no')
                    meter = Meter.objects.get(meter_no=meter_no)
                    arr = meter.obj()
                    print(meter.obj())

                    success_response['message'] = arr

                elif module == 'supplier':
                    id = data.get('id','*')
                    if id == '*':
                        suppliers = Supplier.objects.all()
                        success_response['message'] = [supplier.obj() for supplier in suppliers]
                    else:
                        supplier = Supplier.objects.get(id=id)
                        success_response['message'] = supplier.obj()

                elif module == 'grn':
                    id = data.get('id','*')
                    if id == '*':
                        grns = Grn.objects.all()
                        success_response['message'] = [grn.obj() for grn in grns]
                    else:
                        grn = Grn.objects.get(id=id)
                        success_response['message'] = grn.obj()

                elif module == 'plot':
                    id = data.get('id','*')
                    if id == '*':
                        plots = Plot.objects.all()
                        success_response['message'] = [plot.obj() for plot in plots]
                    else:
                        plot = Plot.objects.get(id=id)
                        success_response['message'] = plot.obj()

                elif module == 'service_type':
                    id = data.get('id','*')
                    if id == '*':
                        service_types = ServiceType.objects.all()
                        success_response['message'] = [service_type.obj() for service_type in service_types]
                    else:
                        service_type = ServiceType.objects.get(id=id)
                        success_response['message'] = service_type.obj()

                elif module == 'service':
                    id = data.get('id','*')
                    if id == '*':
                        services = Service.objects.all()
                        success_response['message'] = [service.obj() for service in services]
                    else:
                        service = Service.objects.get(id=id)
                        success_response['message'] = service.obj() 
                elif module == 'print_grn':
                    grn = Grn.objects.get(id=data.get('id'))

                    from fpdf import FPDF
                    pdf = FPDF()
                    pdf.add_page()

                    pdf.set_font("Arial","B", size=20)
                    pdf.cell(190, 5, txt="GOODS RECIEVED NOTE", ln=True, border=0, align="C")
                    pdf.ln(10)

                    pdf.set_font("Arial","B", size=12)
                    pdf.cell(20, 5, txt=f"Entry No: ", ln=False, align="L",border=0)
                    pdf.set_font("Arial", size=10)
                    pdf.cell(75, 5, txt=f"{grn.grn_no}", ln=False, align="L",border=0)
                    
                    pdf.set_font("Arial", "B", size=10)
                    pdf.cell(75, 5, txt="Supplier Code:", ln=False, align="R",border=0)
                    pdf.set_font("Arial", size=10)
                    pdf.cell(20, 5, txt=f"{grn.supplier.id}", ln=True, align="R",border=0)

                    pdf.set_font("Arial", "B", size=10)
                    pdf.cell(20, 5, txt=f"GRN Date: ", ln=False, align="L",border=0)
                    pdf.set_font("Arial", size=10)
                    pdf.cell(75, 5, txt=f"{grn.grn_date}", ln=False, align="L",border=0)
                    
                    pdf.set_font("Arial", "B", size=10)
                    pdf.cell(75, 5, txt="Supplier Name: ", ln=False, align="R",border=0)
                    pdf.set_font("Arial", size=10)
                    pdf.cell(20, 5, txt=f"{grn.supplier.supplier_name}", ln=True, align="R",border=0)

                    pdf.set_font("Arial", "B", size=10)
                    pdf.cell(20, 5, txt=f"GRN Type: ", ln=False, align="L",border=0)
                    pdf.set_font("Arial", size=10)
                    pdf.cell(75, 5, txt=f"{grn.grn_type}", ln=False, align="L",border=0)

                    pdf.set_font("Arial", "B", size=10)
                    pdf.cell(75, 5, txt=f"Phone: ", ln=False, align="R",border=0)
                    pdf.set_font("Arial", size=10)
                    pdf.cell(20, 5, txt=f"{grn.supplier.supplier_phone}", ln=True, align="R",border=0)

                    pdf.ln(10)
                    

                   

                    pdf.set_font("Arial", "B", size=10)
                    pdf.cell(10, 5, txt="LN", ln=False, border=1, align="L")
                    pdf.cell(25, 5, txt="Barcode", ln=False, border=1, align="L")
                    pdf.cell(50, 5, txt="Name", ln=False, border=1, align="L")
                    pdf.cell(18, 5, txt="UOM", ln=False, border=1, align="C")
                    pdf.cell(18, 5, txt="Pak. Qty", ln=False, border=1, align="C")
                    pdf.cell(18, 5, txt="Qty", ln=False, border=1, align="C")
                    pdf.cell(18, 5, txt="Tot. Qty", ln=False, border=1, align="C")
                    pdf.cell(18, 5, txt="Rate", ln=False, border=1, align="C")
                    pdf.cell(18, 5, txt="Tot. Amt", ln=True, border=1, align="C")
                    
                    pdf.set_font("Arial", size=10)
                    for transaction in GrnTransaction.objects.filter(grn=grn):
                        pdf.cell(10, 5, txt=str(transaction.id), ln=False, border=1, align="L")
                        pdf.cell(25, 5, txt=transaction.barcode, ln=False, border=1, align="L")
                        pdf.cell(50, 5, txt=transaction.name, ln=False, border=1, align="L")
                        pdf.cell(18, 5, txt=transaction.uom, ln=False, border=1, align="C")
                        pdf.cell(18, 5, txt=str(transaction.pack_qty), ln=False, border=1, align="C")
                        pdf.cell(18, 5, txt=str(transaction.qty), ln=False, border=1, align="C")
                        pdf.cell(18, 5, txt=str(transaction.total_qty), ln=False, border=1, align="C")
                        pdf.cell(18, 5, txt=str(transaction.rate), ln=False, border=1, align="C")
                        pdf.cell(18, 5, txt=str(transaction.amount), ln=True, border=1, align="C")

                    
                    pdf.ln(10)
                    pdf.set_font("Arial", size=10)
                    pdf.cell(170, 5, txt="Total Amount: ", ln=False, align="R",border=0)
                    pdf.cell(20, 5, txt=str(grn.total_amount), ln=True, align="R",border=0)

                    
                    pdf.set_font("Arial", size=10)
                    pdf.cell(170, 5, txt="Total Qty: ", ln=False, align="R",border=0)
                    pdf.cell(20, 5, txt=str(grn.total_qty), ln=True, align="R",border=0)

                    pdf.ln(10)
                    pdf.set_font("Arial", size=10)
                    pdf.cell(190 / 6, 10, txt=f"{grn.created_by.first_name} {grn.created_by.last_name}", ln=False, align="C",border=1)
                    pdf.cell(190 / 6, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 12, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt=f"{grn.obj().get('posted_by')}", ln=False, align="R",border=1)
                    pdf.cell(190 / 12, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt="", ln=True, align="R",border=1)
                    
                    pdf.cell(190 / 6, 10, txt="Created By", ln=False, align="C",border=0)
                    pdf.cell(190 / 6, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 12, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt="Posted By", ln=False, align="C",border=0)
                    pdf.cell(190 / 12, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt="Confirmed By", ln=True, align="C",border=0)

                        
                    file_name = f"GRN-{grn.grn_no}.pdf"
                    file = f"static/general/tmp/{file_name}"
                    pdf.output(file)
                    success_response['message'] = file

                elif module == 'print_issue':
                    issue = Issue.objects.get(id=data.get('id'))

                    from fpdf import FPDF
                    pdf = FPDF()
                    pdf.add_page()  
                    
                    pdf.set_font("Arial","",10)
                    pdf.cell(190, 5, txt="Sneda Smart Meters Limited", ln=True, border=0, align="C")
                    pdf.cell(190, 5, txt="P.O. Box 1024, Accra, Ghana", ln=True, border=0, align="C")
                    pdf.cell(190, 5, txt="Tel: +233 54 200 3000 / 55 505 9999", ln=True, border=0, align="C")
                    pdf.cell(190, 5, txt="Email: bharat@snedaghana.com", ln=True, border=0, align="C")
                    pdf.ln(10)

                    pdf.set_font("Arial","B", size=20)
                    pdf.cell(190, 5, txt="GOODS ISSUE WAYBILL", ln=True, border=0, align="C")
                    pdf.ln(10)

                    pdf.set_font("Arial","B", size=12)
                    pdf.cell(90, 5, txt=f"Document", ln=False, align="L",border=0)
                    
                    
                    pdf.set_font("Arial", "B", size=12)
                    pdf.cell(100, 5, txt="Contactor", ln=True, align="R",border=0)

                    pdf.set_font("Arial",'B', size=10)
                    pdf.cell(20, 5, txt=f"Entry: ", ln=False, align="L",border=0)
                    pdf.set_font("Arial",'', size=10)
                    pdf.cell(75, 5, txt=f"{issue.issue_no}", ln=False, align="L",border=0)

                    pdf.set_font("Arial",'B', size=10)
                    pdf.cell(75, 5, txt=f"Name: ", ln=False, align="R",border=0)
                    pdf.set_font("Arial",'', size=10)
                    pdf.cell(20, 5, txt=f"{issue.contractor.company}", ln=True, align="R",border=0)

                    pdf.set_font("Arial",'B', size=10)
                    pdf.cell(20, 5, txt=f"Date: ", ln=False, align="L",border=0)
                    pdf.set_font("Arial",'', size=10)
                    pdf.cell(75, 5, txt=f"{issue.issue_date}", ln=False, align="L",border=0)

                    pdf.set_font("Arial",'B', size=10)
                    pdf.cell(75, 5, txt=f"Rep: ", ln=False, align="R",border=0)
                    pdf.set_font("Arial",'', size=10)
                    pdf.cell(20, 5, txt=f"{issue.contractor.owner}", ln=True, align="R",border=0)

                    pdf.set_font("Arial",'B', size=10)
                    pdf.cell(20, 5, txt=f"", ln=False, align="L",border=0)
                    pdf.set_font("Arial",'', size=10)
                    pdf.cell(75, 5, txt=f"", ln=False, align="L",border=0)

                    pdf.set_font("Arial",'B', size=10)
                    pdf.cell(75, 5, txt=f"Phone: ", ln=False, align="R",border=0)
                    pdf.set_font("Arial",'', size=10)
                    pdf.cell(20, 5, txt=f"{issue.contractor.phone}", ln=True, align="R",border=0)

                    pdf.set_font("Arial",'B', size=10)
                    pdf.cell(20, 5, txt=f"", ln=False, align="L",border=0)
                    pdf.set_font("Arial",'', size=10)
                    pdf.cell(75, 5, txt=f"", ln=False, align="L",border=0)

                   
                    
                    pdf.ln(10)

                    pdf.set_font("Arial", "B", size=8)
                    pdf.cell(10, 5, txt="LN", ln=False, border=1, align="L")
                    pdf.cell(25, 5, txt="Barcode", ln=False, border=1, align="L")
                    pdf.cell(65, 5, txt="Name", ln=False, border=1, align="L")
                    pdf.cell(15, 5, txt="UOM", ln=False, border=1, align="C")
                    pdf.cell(15, 5, txt="Pak. Qty", ln=False, border=1, align="C")
                    pdf.cell(15, 5, txt="Qty", ln=False, border=1, align="C")
                    pdf.cell(15, 5, txt="Tot. Qty", ln=False, border=1, align="C")
                    pdf.cell(15, 5, txt="Rate", ln=False, border=1, align="C")
                    pdf.cell(15, 5, txt="Tot. Amt", ln=True, border=1, align="C")

                    pdf.set_font("Arial", size=8)
                    ln = 1
                    for transaction in IssueTransaction.objects.filter(issue=issue):
                        pdf.cell(10, 5, txt=str(ln), ln=False, border=1, align="L")
                        pdf.cell(25, 5, txt=transaction.barcode, ln=False, border=1, align="L")
                        pdf.cell(65, 5, txt=transaction.name[:60], ln=False, border=1, align="L")
                        pdf.cell(15, 5, txt=transaction.uom, ln=False, border=1, align="C")
                        pdf.cell(15, 5, txt=str(transaction.pack_qty), ln=False, border=1, align="C")
                        pdf.cell(15, 5, txt=str(transaction.qty), ln=False, border=1, align="C")
                        pdf.cell(15, 5, txt=str(transaction.total_qty), ln=False, border=1, align="C")
                        pdf.cell(15, 5, txt=str(transaction.rate), ln=False, border=1, align="C")
                        pdf.cell(15, 5, txt=str(transaction.amount), ln=True, border=1, align="C")
                        ln += 1

                    if Meter.objects.filter(issue=issue).exists():
                        pdf.multi_cell(190, 10, txt="Meters: [" + ', '.join([meter.meter_no for meter in Meter.objects.filter(issue=issue)]) + "]",border=True, align="L")
                    pdf.ln(10)
                    
                    pdf.set_font("Arial", size=10)
                    pdf.cell(170, 5, txt="Total Amount: ", ln=False, align="R",border=0)
                    pdf.cell(20, 5, txt=str(issue.obj().get('total_amount')), ln=True, align="R",border=0)

                    pdf.set_font("Arial", size=10)
                    pdf.cell(170, 5, txt="Total Qty: ", ln=False, align="R",border=0)
                    pdf.cell(20, 5, txt=str(issue.obj().get('total_qty')), ln=True, align="R",border=0)

                    pdf.ln(10)
                    pdf.set_font("Arial", size=10)
                    pdf.cell(190 / 6, 10, txt=f"{issue.created_by.first_name} {issue.created_by.last_name}", ln=False, align="C",border=1)
                    pdf.cell(190 / 6, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 12, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt=f"{issue.obj().get('posted_by')}", ln=False, align="C",border=1)
                    pdf.cell(190 / 12, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt="", ln=True, align="R",border=1)
                    
                    pdf.cell(190 / 6, 10, txt="Created By", ln=False, align="C",border=0)
                    pdf.cell(190 / 6, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 12, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt="Posted By", ln=False, align="C",border=0)
                    pdf.cell(190 / 12, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt="", ln=False, align="R",border=0)
                    pdf.cell(190 / 6, 10, txt="Confirmed By", ln=True, align="C",border=0)
                    
                    file_name = f"ISSUE-{issue.issue_no}.pdf"
                    file = f"static/general/tmp/{file_name}"
                    pdf.output(file)
                    success_response['message'] = file

                elif module == 'print_services':
                    from fpdf import FPDF
                    pdf = FPDF()
                    pdf.add_page()
                    
                    pdf.set_font("Arial","B", size=12)
                    pdf.cell(190, 5, txt="Services", ln=True, border=0, align="C")
                    pdf.ln(10)
                    
                    
                    pdf.cell(20, 5, txt="Code", ln=False, align="L",border=0)
                    pdf.cell(50, 5, txt="Name", ln=False, align="L",border=0)
                    pdf.cell(50, 5, txt="Description", ln=False, align="L",border=0)
                    pdf.cell(20, 5, txt="Rate", ln=True, align="L",border=0)
                    pdf.ln(10)
                    
                    services = Service.objects.all()
                    for service in services:
                        pdf.set_font("Arial","B", size=10)
                        pdf.cell(20, 5, txt=f"{service.code}", ln=False, align="L",border=0)
                        pdf.cell(50, 5, txt=f"{service.name}", ln=False, align="L",border=0)
                        pdf.cell(50, 5, txt=f"{service.description}", ln=False, align="L",border=0)
                        pdf.cell(20, 5, txt=f"{service.rate}", ln=True, align="L",border=0)
                        pdf.ln(5)

                    file_name = f"Services.pdf"
                    file = f"static/general/tmp/{file_name}"
                    pdf.output(file)
                    success_response['message'] = file
                    
                    

                elif module == 'issue':
                    id = data.get('id','*')
                    if id == '*':
                        issues = Issue.objects.all()
                        success_response['message'] = [issue.obj() for issue in issues]
                    else:
                        issue = Issue.objects.get(id=id)
                        success_response['message'] = issue.obj()

                elif module == 'issue_meters':
                    issue_id = data.get('id')
                    issue = Issue.objects.get(id=issue_id)
                    meters = Meter.objects.filter(issue=issue)
                    success_response['message'] = [meter.obj() for meter in meters]

                elif module == 'service_order':
                    id = data.get('id','*')
                    filter = data.get('filter','*')
                    status = data.get('status','pending')
                    print(data)
                    if id == '*':
                        service_orders = ServiceOrder.objects.all()[:10]
                        if filter == 'contractor':
                            limit = data.get('filter',1000)
                            service_orders = ServiceOrder.objects.filter(contractor=data.get('contractor'),status=status)[:100]
                            status = data.get('status')
                            
                        elif filter == 'plot':
                            service_orders = ServiceOrder.objects.filter(plot=data.get('plot'))[:10]
                        elif filter == 'service_type':
                            service_orders = ServiceOrder.objects.filter(service_type=data.get('service_type'))[:10]
                            
                        success_response['message'] = [service_order.obj() for service_order in service_orders]
                    else:
                        service_order = ServiceOrder.objects.get(id=id)
                        success_response['message'] = [service_order.obj()]
                elif module == 'service_order_item':
                    print(data)
                    service_order_id = data.get('service_order_id')
                    if service_order_id == '*':
                        service_order_items = ServiceOrderItem.objects.all()
                        success_response['message'] = [service_order_item.obj() for service_order_item in service_order_items]
                    else:
                        service_order_item = ServiceOrderItem.objects.get(id=service_order_id)
                        success_response['message'] = service_order_item.obj()
                elif module == 'service_order_return':
                    id = data.get('id')
                    if id == '*':
                        return_items = ServiceOrderReturns.objects.all()
                        success_response['message'] = [return_item.obj() for return_item in return_items]
                    else:
                        return_item = ServiceOrderReturns.objects.get(id=id)
                        success_response['message'] = return_item.obj()
                
                else:
                    success_response['status_code'] = 400
                    success_response['message'] = f"Module Not Found {module}"



                response = success_response
        elif method == 'DELETE':
            if module == 'service':
                id = data.get('id')
                service = Service.objects.get(id=id)
                service.delete()
                success_response['message'] = "Service Deleted Successfully"

            elif module == 'order_service':
                id = data.get('id')
                service_order_item = ServiceOrderItem.objects.get(id=id)
                service_order_item.delete()
                success_response['message'] = "Service Order Item Deleted Successfully"

            elif module == 'service_order':
                id = data.get('id')
                service_order = ServiceOrder.objects.get(id=id)
                service_order.delete()
                success_response['message'] = "Service Order Deleted Successfully"

            elif module == 'issue':
                id = data.get('id')
                issue = Issue.objects.get(id=id)
                # delete transactions
                IssueTransaction.objects.filter(issue=issue).delete()
                issue.is_deleted = True
                issue.save()
                success_response['message'] = "Issue Deleted Successfully"

            elif module == 'service_material':
                id = data.get('id')
                MaterialOrderItem.objects.get(id=id).delete()
                success_response['message'] = "Material Deleted"

            elif module == 'service_order_return':
                id = data.get('id')
                ServiceOrderReturns.objects.get(id=id).delete()
                success_response['message'] = "Return Deleted"

            else:
                success_response['status_code'] = 400
                success_response['message'] = f"Module Not Found {module}"
        elif method == 'PATCH':
            if module == 'material':
                
                barcode = data.get('barcode')
                name = data.get('name')
                group = InventoryGroup.objects.get(id=data.get('group'))
                reorder_qty = data.get('reorder_qty')
                value = data.get('value')
                is_return = data.get('is_return')
                is_issue = data.get('is_issue')
                print(data)
                material = InventoryMaterial.objects.get(barcode=barcode)
                material.name = name
                material.group = group
                material.reorder_qty = reorder_qty
                material.value = value
                material.is_return = is_return
                material.is_issue = is_issue
                material.issue_qty = data.get('issue_qty')

                material.save()
                success_response['message'] = "Material Updated Successfully"


            elif module == 'issue_def_qty':
                updated = 0
                created = 0
                for meterial in InventoryMaterial.objects.filter(is_issue=True):
                    
                    issue_qty = meterial.issue_qty
                    MaterialOrderItem.objects.filter(material=meterial).update(
                        quantity=issue_qty,
                        rate=meterial.value,
                        amount=issue_qty*meterial.value
                    )
                    updated += 1

                    mt = meterial

                    for service in ServiceOrder.objects.all():
                        if MaterialOrderItem.objects.filter(material=mt,service_order=service).count() == 0:
                            # create
                            MaterialOrderItem.objects.create(
                                material_type='is',
                                material=mt,
                                quantity=issue_qty,
                                rate=mt.value,
                                amount = issue_qty * mt.value ,
                                service_order=service
                            )
                            created += 1

                success_response['message'] = f"UPDATED {updated}, CREATED:{created}"

            
                
                
            
            elif module == 'post_grn':
                grn_id = data.get('id')
                grn = Grn.objects.get(id=grn_id)
                mypk = data.get('mypk')
                user = User.objects.get(id=mypk)
                try:
                    transactions = GrnTransaction.objects.filter(grn=grn)
                    for transaction in transactions:
                        
                        Cardex.objects.create(
                            doc_type='GR',
                            doc_no=grn.grn_no,
                            ref_no=grn.id,
                            material=transaction.material,
                            qty=transaction.total_qty
                        )
                    
                    grn.is_posted = True
                    grn.posted_by = user
                    success_response['message'] = "GRN Posted Successfully"
                except Exception as e:
                    Cardex.objects.filter(doc_no=grn.grn_no,doc_type='GR').delete()
                    grn.delete()
                    grn.is_posted = False
                    success_response['status_code'] = 400
                    success_response['message'] = f"Error on line {sys.exc_info()[2].tb_lineno}: {e}"
                finally:
                    grn.save()
            elif module == 'grn':
                grn_id = data.get('id')
                grn = Grn.objects.get(id=grn_id)
                grn.supplier = Supplier.objects.get(id=data.get('supplier'))
                grn.grn_no = data.get('grn_no')
                grn.grn_date = data.get('grn_date')
                grn.remarks = data.get('remarks')
                grn.grn_type = data.get('grn_type')

                transactions = GrnTransaction.objects.filter(grn=grn)
                transactions.delete()
                for transaction in data.get('transactions'):
                    material = InventoryMaterial.objects.get(barcode=transaction.get('barcode'))
                    GrnTransaction.objects.create(
                            grn=grn, 
                            material=material, 
                            barcode=transaction.get('barcode'),
                            name=transaction.get('name'),
                            amount=transaction.get('amount'),
                            pack_qty=transaction.get('pack_qty'),
                            uom=transaction.get('uom'),
                            rate=transaction.get('rate'),
                            qty=transaction.get('qty'),
                            total_qty=Decimal(transaction.get('qty')) * Decimal(transaction.get('pack_qty'))    
                        )
                
                success_response['message'] = "GRN Updated Successfully"

            elif module == 'issue':
                issue_id = data.get('id')
                issue = Issue.objects.get(id=issue_id)
                issue.contractor = Contractor.objects.get(id=data.get('contractor'))
                issue.issue_date = data.get('issue_date')
                issue.remarks = data.get('remarks')
                issue.issue_type = data.get('issue_type')
                issue.modified_by = User.objects.get(id=data.get('created_by'))

                transactions = IssueTransaction.objects.filter(issue=issue)
                transactions.delete()
                for transaction in data.get('transactions'):
                    material = InventoryMaterial.objects.get(barcode=transaction.get('barcode'))
                    IssueTransaction.objects.create(
                        issue=issue,
                        material=material,
                        qty=transaction.get('qty'),
                        pack_qty=transaction.get('pack_qty'),
                        uom=transaction.get('uom'),
                        rate=transaction.get('rate'),
                        barcode=transaction.get('barcode'),
                        name=transaction.get('name'),
                        total_qty=Decimal(transaction.get('qty')) * Decimal(transaction.get('pack_qty')),
                        amount=Decimal(transaction.get('qty')) * Decimal(transaction.get('rate'))
                    )
                issue.save()
                success_response['message'] = "Issue Updated Successfully"

            elif module == 'post_issue':
                
                try:
                    print(data)
                    issue_id = data.get('id')
                    issue = Issue.objects.get(id=issue_id)
                    tp = issue.issue_type
                    mypk = data.get('mypk')
                    user = User.objects.get(id=mypk)
                    transactions = IssueTransaction.objects.filter(issue=issue)
                    for transaction in transactions:
                        qty = transaction.total_qty * -1
                        if tp == 'RET':
                            qty = transaction.total_qty
                        
                        if tp == 'ISS':
                            qty = qty
                        Cardex.objects.create(
                            doc_type=tp,
                            doc_no=issue.issue_no,
                            ref_no=issue.id,
                            material=transaction.material,
                            qty=qty
                        )
                    issue.is_posted = True
                    issue.posted_by = user
                    success_response['message'] = "Issue Posted Successfully"
                except Exception as e:
                    Cardex.objects.filter(doc_no=issue.issue_no,doc_type='IS').delete()
                    raise Exception(e)

                issue.save()
            elif module == 'unpost_issue':
                issue_id = data.get('id')
                issue = Issue.objects.get(id=issue_id)
                issue.is_posted = False
                issue.posted_by = None
                Cardex.objects.filter(doc_no=issue.issue_no,doc_type='IS').delete() 
                issue.save()
                success_response['message'] = "Issue Unposted Successfully"

            elif module == 'service':
                id = data.get('id')
                name = data.get('service_name')
                description = data.get('service_description')
                uom = data.get('service_uom')
                rate = data.get('service_rate')

                service = Service.objects.get(id=id)
                service.name = name
                service.description = description
                service.uom = uom
                service.rate = rate
                service.save()
                success_response['message'] = "Service Updated Successfully"
            elif module == 'service_order_item':
                
                service_order_item = ServiceOrderItem.objects.get(id=data.get('service_item_id'))
                service_order_item.quantity = data.get('serv_qty')
                user = User.objects.get(id=data.get('mypk'))
                service_order_item.modified_by = user
                service_order_item.amount = Decimal(data.get('serv_qty')) * Decimal(service_order_item.rate)
                service_order_item.save()
                success_response['message'] = "Service Order Item Updated Successfully"

            elif module == 'contractor':
                id = data.get('id')
                contractor = Contractor.objects.get(id=id)
                contractor.link = data.get('link')
                contractor.company = data.get('company')
                contractor.owner = data.get('owner')
                contractor.phone = data.get('phone')
                contractor.email = data.get('email')
                contractor.country = data.get('country')
                contractor.city = data.get('city')
                contractor.postal_code = data.get('postal_code')
                contractor.gh_post_code = data.get('gh_post_code')
                contractor.gh_card_no = data.get('gh_card_no')
                contractor.save()
        
            elif module == 'service_order_return':
                id = data.get('ret_id')
                return_item = ServiceOrderReturns.objects.get(id=id)
                return_item.quantity = data.get('ret_qty')
                return_item.modified_by = User.objects.get(id=data.get('mypk'))
                return_item.save()
                success_response['message'] = "Service Order Return Updated Successfully"
              
            elif module == 'close_service_order':
                id = data.get('id')
                mypk = data.get('mypk')
                user = User.objects.get(id=mypk)
                service_order = ServiceOrder.objects.get(id=id)
                total_amount = service_order.total_amount()
                print(total_amount)

                try:


                    Ledger.objects.create(
                        contractor=service_order.contractor,
                        amount=total_amount,
                        reference_no=service_order.new_meter,
                        transaction_type='credit',
                        remarks=f"Service Order {service_order.id} Closed",
                        created_by=user
                    )

                except Exception as e:
                    pass

                service_order.status = 'completed'
                service_order.closed_by = user
                service_order.total_amount = total_amount
                contractor_id = service_order.contractor.id
                service_order.save()
                success_response['message'] = contractor_id

            elif module == 'ret_def_rec':
                try:
                    service_id = data.get('service_id')
                    service = ServiceOrder.objects.get(id=service_id)
                    user = User.objects.get(pk=data.get('mypk'))
                    for service in ServiceOrder.objects.all():
                        for material in InventoryMaterial.objects.filter(is_return=True):
                            try:
                                ServiceOrderReturns.objects.create(
                                service_order=service,
                                material=material,
                                quantity=1,
                                created_by=user
                            )
                            except Exception as e:
                                print("Error")
                                print(e)
                                pass
                    success_response['status_code'] = 200
                    success_response['message'] = 'done'
                except Exception as e:
                    success_response['status_code'] = 505
                    success_response['message'] = str(e)

                print(success_response)

            else:
                success_response['status_code'] = 505
                success_response['message'] = "Invalid Module"
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










